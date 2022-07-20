/*
 * This file is part of launcher-mobile.
 *
 * launcher-mobile is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * launcher-mobile is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with launcher-mobile.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include "spice.h"
#include "globals.h"
#include "native.h"

#if USE_GLV
#define CONNECTION_TRY_COUNT 10
#endif

pthread_t spice_worker;
pthread_t mainloop_worker;

//GLOOVIR
global_state_t global_state;

void engine_mainloop_worker(void *data)
{
    GLUE_DEBUG("InitializeLogging\n");
    SpiceGlibGlue_InitializeLogging(0);
    
    GLUE_DEBUG("engine_mainloop_worker\n");
    SpiceGlibGlue_MainLoop();
    
    GLUE_DEBUG("engine_mainloop_worker exit\n");
}

void engine_spice_worker(void *data)
{
    spice_conn_data_t *conn_data = global_state.conn_data;
    int result;
    
    GLUE_DEBUG("engine_spice_worker\n");
    result = SpiceGlibGlue_Connect(conn_data->host,
                                   conn_data->port, conn_data->tlsport,
                                   conn_data->wsport,
                                   conn_data->password,
#if USE_GLV
                                   conn_data->ca_cert, conn_data->ca_subject, conn_data->user_token,
#else
                                   NULL, NULL,
#endif
                                   global_state.enable_audio);
    
    GLUE_DEBUG("engine_spice_worker: result=%d\n", result);
}

void engine_spice_set_connection_data(const char *host,
                                      const char *port,
                                      const char *wsport,
                                      const char *password,
#if USE_GLV
                                      const char *tlsport,
                                      const char *user_token,
                                      const char *ca_cert,
                                      const char *ca_subject,
#endif
                                      int32_t enableAudio)
{
    spice_conn_data_t *conn_data;
    
    if (global_state.conn_data != NULL)
    {
        if (global_state.conn_data->host != NULL)
        {
            free(global_state.conn_data->host);
        }
        if (global_state.conn_data->port != NULL)
        {
            free(global_state.conn_data->port);
        }
        if (global_state.conn_data->wsport != NULL)
        {
            free(global_state.conn_data->wsport);
        }
        if (global_state.conn_data->password != NULL)
        {
            free(global_state.conn_data->password);
        }
        conn_data = global_state.conn_data;
    }
    else
    {
        conn_data = global_state.conn_data = malloc(sizeof(spice_conn_data_t));
    }
    
    conn_data->host = malloc(strlen(host) + 1);
    strcpy(conn_data->host, host);
    
    conn_data->port = malloc(strlen(port) + 1);
    strcpy(conn_data->port, port);
    
    conn_data->wsport = malloc(strlen(wsport) + 1);
    strcpy(conn_data->wsport, wsport);
    
    conn_data->password = malloc(strlen(password) + 1);
    strcpy(conn_data->password, password);
    
#if USE_GLV
    if (tlsport != NULL && strcmp(tlsport, "-1") != 0)
    {
        conn_data->tlsport = malloc(strlen(tlsport) + 1);
        strcpy(conn_data->tlsport, tlsport);
    }
    else
    {
        conn_data->tlsport = NULL;
    }
    
    if (user_token != NULL && strcmp(user_token, "-1") != 0)
    {
        conn_data->user_token = malloc(strlen(user_token) + 1);
        strcpy(conn_data->user_token, user_token);
    }
    else
    {
        conn_data->user_token = NULL;
    }
    
    if (ca_cert != NULL && strcmp(ca_cert, "-1") != 0)
    {
        conn_data->ca_cert = malloc(strlen(ca_cert) + 1);
        strcpy(conn_data->ca_cert, ca_cert);
    }
    else
    {
        conn_data->ca_cert = NULL;
    }
    
    if (ca_subject != NULL && strcmp(ca_subject, "-1") != 0)
    {
        conn_data->ca_subject = malloc(strlen(ca_subject) + 1);
        strcpy(conn_data->ca_subject, ca_subject);
    }
    else
    {
        conn_data->ca_subject = NULL;
    }
#endif
    
    global_state.enable_audio = enableAudio;
}

int engine_spice_connect()
{
    int i;
    printf("engine_spice_connect\n");

    if (global_state.main_loop_running == 0)
    {
        pthread_create(&mainloop_worker, NULL, (void *)&engine_mainloop_worker, NULL);
        global_state.main_loop_running = 1;
    }
    
    global_state.first_frame = 1;
    
    if (global_state.conn_state == DISCONNECTED)
    {
        engine_spice_worker(NULL);
#if USE_GLV
        for (i = 0; i < CONNECTION_TRY_COUNT; i++)
        {
#else
            for (i = 0; i < 10; i++)
            {
#endif
                printf("engine_spice_connect for i = %d\n", i);
                if (global_state.main_loop_running == 0)
                {
                    return 1; //force closed.
                }
                
                if (engine_spice_is_connected())
                {
                    printf("engine_spice_connect = connected\n");
                    global_state.display_state = CONNECTED;
                    global_state.conn_state = CONNECTED;
                    return 0;
                }
                printf("engine_spice_connect = sleep(1)\n");
                sleep(1);
            }
            return -1; //connection error
        }
        
        return 0;
    }
    
    void engine_spice_disconnect()
    {
        if (global_state.conn_state == CONNECTED)
        {
            /* Do this first, preventing screen updates */
            global_state.display_state = DISCONNECTED;
            SpiceGlibGlue_Disconnect();
            //        global_state.guest_width = 0;
            //        global_state.guest_height = 0;
            global_state.conn_state = DISCONNECTED;
            global_state.input_initialized = 0;
            global_state.main_loop_running = 0;
#if USE_GLV == 0
            native_connection_change(DISCONNECTED);
#endif
        }
#if USE_GLV
        else
        {
            SpiceGlibGlue_Disconnect();
            global_state.main_loop_running = 0;
        }
#endif
    }
    
    int engine_spice_is_connected()
    {
        if (SpiceGlibGlue_getNumberOfChannels() > 2)
        {
            return 1;
        }
        return 0;
    }
    
    void engine_spice_request_resolution(int width, int height)
    {
        SpiceGlibRecalcGeometry(0, 0, width, height);
        
        if (!global_state.change_resolution)
        {
            global_state.change_resolution = 1;
#if USE_GLV == 0
            native_resolution_change(1);
#endif
        }
    }
    
    void engine_spice_resolution_changed()
    {
        if (global_state.change_resolution)
        {
            global_state.change_resolution = 0;
#if USE_GLV == 0
            native_resolution_change(0);
#endif
        }
    }
    
    int engine_spice_lock_display(char *display_buffer, int *width, int *height)
    {
        int invalidated = 0;
        int flags = 0;
        
        if (!global_state.input_initialized)
        {
            /* XXX - HACK! We send here a bogus input to ensure
             coroutines are properly coordinated. */
            SpiceGlibGlueMotionEvent(0, 0, global_state.button_mask);
            global_state.input_initialized = 1;
        }
        
        invalidated = SpiceGlibGlueLockDisplayBuffer(width, height);
        
        if (invalidated /*|| global_state.first_frame < 5*/)
        {
            flags |= DISPLAY_INVALIDATE;
            //global_state.first_frame += 1;
        }
        
        if (*width != 0 &&
            *height != 0 &&
            (*width != global_state.guest_width ||
             *height != global_state.guest_height))
        {
            global_state.guest_width = *width;
            global_state.guest_height = *height;
#ifdef ANDROID
            global_state.mouse_fix[0] = 1.0;
            global_state.mouse_fix[1] = 1.0;
#else
            global_state.mouse_fix[0] = (double)global_state.guest_width / (double)global_state.width;
            global_state.mouse_fix[1] = (double)global_state.guest_height / (double)global_state.height;
#endif
            flags |= DISPLAY_CHANGE_RESOLUTION;
        }
        
        return flags;
    }
    
    void engine_spice_unlock_display()
    {
        SpiceGlibGlueUnlockDisplayBuffer();
    }
    
    void engine_spice_motion_event(int pos_x, int pos_y)
    {
        SpiceGlibGlueMotionEvent(pos_x, pos_y, global_state.button_mask);
    }
    
    void engine_spice_button_event(int pos_x, int pos_y, int button, int down)
    {
        if (button == 1 || button == 3)
        {
            if (down)
            {
                global_state.button_mask |= (1 << (button - 1));
            }
            else
            {
                global_state.button_mask &= ~(1 << (button - 1));
            }
        }
        SpiceGlibGlueButtonEvent(pos_x, pos_y, button, 0, down);
    }
    
    void engine_spice_keyboard_event(int keycode, int16_t down)
    {
        SpiceGlibGlue_SpiceKeyEvent(down, keycode);
    }
    
#if USE_GLV
    void (*g_spiceAppEventCallback)(int, void *) = NULL;
    void engine_spice_set_event_callback(void (*func)(int, void *))
    {
        g_spiceAppEventCallback = func;
        app_event_set_callback(func);
    }
    
    void engine_spice_notify_disconn()
    {
        static char reason[4];
        if (g_spiceAppEventCallback == NULL)
        {
            return;
        }
        //2 means
        strcpy(reason, "0");
        return g_spiceAppEventCallback(APP_EVENT_DISCONN, (void *)reason);
    }
    
    int engine_spice_has_disconn_reason()
    {
        return SpiceGlibGlue_hasDisconnReason();
    }
    
    int engine_spice_get_latency()
    {
        return (int)SpiceGlibGlue_getLatency();
    }
    int engine_spice_get_bandwidth()
    {
        return (int)SpiceGlibGlue_getBandwidth();
    }
    
    int engine_spice_sso_login(const char *logonId, const char *logonPw)
    {
        printf("engine_spice_sso_login = %s, pw = %s\n", logonId, logonPw);
        return (int)SpiceSsoLogon(logonId, logonPw);
    }
    
    void engine_spice_set_url_redir(int on)
    {
        SpiceGlibGlue_setUrlRedir(on);
    }
    void engine_spice_set_security_policy(int urlRedirOn, int printerRedirOn, const char *baseDir)
    {
        SpiceGlibGlue_setSecurityPolicy(urlRedirOn, printerRedirOn, baseDir);
    }
    /* GLV_2ND : engine_spice_start_push_service() start/stop push service.
     * svrAddr format is IP:Port. if svrAddr is NULL, push service stops.
     */
    void engine_spice_start_push_service(const char *svrAddr, const char *vpcId)
    {
        SpiceGlibGlue_startPushService(svrAddr, vpcId);
    }
    
    int engine_spice_check_connection(const char *addr, int port)
    {
        return SpiceGlibGlue_checkConnection(addr, port) ? 1 : 0;
    }
    
    /* GLV_2ND : engine_spice_set_client_info()
     * This sets client info. These are used in message header of spice channel connection.
     */
    void engine_spice_set_client_info(const char *uuid, const char *osType, const char *ip)
    {
        SpiceGlibGlue_setClientInfo(uuid, osType, ip);
    }
    
#endif
