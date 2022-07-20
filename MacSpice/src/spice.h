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

#ifndef SPICE_H
#define SPICE_H

#include "spice-mono-glue.h"

typedef struct _spice_conn_data_t
{
    char *host;
    char *port;
    char *wsport;
    char *password;
#if USE_GLV
    char *tlsport;
    char *user_token;
    char *ca_cert;
    char *ca_subject;
#endif
} spice_conn_data_t;

void engine_spice_worker(void *data);

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
                                      int32_t enableAudio);

int engine_spice_connect(void);

void engine_spice_disconnect(void);

int engine_spice_is_connected(void);

void engine_spice_request_resolution(int width, int height);

void engine_spice_resolution_changed(void);

int engine_spice_lock_display(char *display_buffer, int *width, int *height);

void engine_spice_unlock_display(void);

void engine_spice_motion_event(int pos_x, int pos_y);

void engine_spice_button_event(int pos_x, int pos_y, int button, int down);

void engine_spice_keyboard_event(int keycode, int16_t down);

#if USE_GLV

enum
{
    APP_EVENT_URL_REDIR = 1,
    APP_EVENT_DISCONN = 2,
    APP_EVENT_PUSH_NOTIFY = 3,
    APP_EVENT_PRINTER_REDIR = 4,
    APP_EVENT_WORKING_TIME = 5
};

void engine_spice_set_event_callback(void (*func)(int, void *));
void engine_spice_notify_disconn(void);

int engine_spice_has_disconn_reason(void);
int engine_spice_get_latency(void);
int engine_spice_get_bandwidth(void);

int engine_spice_sso_login(const char *logonId, const char *logonPw);

void engine_spice_set_url_redir(int on);

//printer redirection
void engine_spice_set_security_policy(int urlRedirOn, int printerRedirOn, const char *baseDir);

void engine_spice_start_push_service(const char *svrAddr, const char *vpcId);

int engine_spice_check_connection(const char *addr, int port);

void engine_spice_set_client_info(const char *uuid, const char *osType, const char *ip);
#endif

#endif
