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

#include <stdlib.h>

void SpiceGlibGlue_InitializeLogging(int32_t verbosityLevel);

int16_t SpiceGlibGlue_MainLoop(void);

int16_t SpiceGlibGlue_Connect(char *h, char *p,
                              char *tp, char *ws,
                              char *pw, char *cf,
                              char *cs,
#if USE_GLV
                              char *user_token,
#endif
                              int32_t sound);

void SpiceGlibGlueSetDisplayBuffer(uint32_t *display_buffer,
                                   int32_t width,
                                   int32_t height);

int16_t SpiceGlibGlueLockDisplayBuffer(int32_t *width, int32_t *height);

void SpiceGlibGlueUnlockDisplayBuffer(void);

void SpiceGlibGlue_Disconnect(void);

int16_t SpiceGlibGlue_isConnected(void);

int16_t SpiceGlibGlue_getNumberOfChannels(void);

int SpiceGlibRecalcGeometry(int x, int y, int w, int h);

int SpiceSsoLogon(const char *logon_id, const char *logon_pw);

int SpiceGlibGlueUpdateDisplayData(char *, int *, int *);

int16_t SpiceGlibGlueMotionEvent(int pos_x, int pos_y, int16_t button_mask);

int16_t SpiceGlibGlueButtonEvent(int pos_x, int pos_y,
                                 int16_t button, int16_t button_mask, int16_t down);

void SpiceGlibGlue_SpiceKeyEvent(int down, int keycode);

#if USE_GLV
void app_event_set_callback(void (*func)(int, void *));

int16_t SpiceGlibGlue_hasDisconnReason(void);
int64_t SpiceGlibGlue_getLatency(void);
int64_t SpiceGlibGlue_getBandwidth(void);

void SpiceGlibGlue_setUrlRedir(int32_t on);

//printer redirection
void SpiceGlibGlue_setSecurityPolicy(int32_t urlRedirOn, int32_t printerRedirOn, const char *baseDir);
//void SpliceGlibGlue_printerredirectionStarted(void);

typedef struct _SpiceGlibGlueCursorData

{
    uint32_t width;
    uint32_t height;
    uint32_t hot_x;
    uint32_t hot_y;
    //int32_t* rgba;
} SpiceGlibGlueCursorData;

int16_t SpiceGlibGlueGetCursor(uint32_t previousCursorId,
                               uint32_t *currentCursorId,
                               uint32_t *showInClient,
                               SpiceGlibGlueCursorData *cursor,
                               int32_t *dstRgba);

void SpiceGlibGlue_startPushService(const char *svrAddr, const char *vpcId);
void SpiceGlibGlue_sendPushMessage(const char *msgType, const char *msgBody);
int16_t SpiceGlibGlue_checkConnection(const char *addr, int port);

void SpiceGlibGlue_setClientInfo(char *uuid, char *os_type, char *ip);

#endif
