//
//  SpiceVC.swift
//  MacSpice
//
//  Created by y2k on 2022/07/15.
//

import Cocoa

class SpiceVC: NSViewController {
    
    @IBOutlet weak var viewSpice: SpiceView!
    
    var setting: ConnectSettingModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func setData(_setting: ConnectSettingModel) {
        print("schy2k setData")
//        if isConnected {
//            return
//        }
        setting = _setting
//        initRdpConnect()
        connectSpice()
    }
    
    
    func connectSpice() {
        guard let setting = setting else {
            return
        }
        engine_spice_set_client_info("test", "ios", "0.0.0.0")

//        
//        let ip = "192.168.162.25"
//        let port = "-1"
//        let tlsPort = "5917"
//        let token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VfdGxzIjp0cnVlLCJ2bV9pZCI6IjczOThjMWU0LWUzZGMtNGM2Yi1hZTI3LWY5MmQ5NzVjNzc5MCIsInVzZXJfdHlwZSI6InVzZXIiLCJleHAiOjE2NTc4NDAzMzEsInRva2VuIjoidUE4SGlDdWxGZFRna3NYUzg1TlUzZz09In0.66rKTK9qod-r0OZSibCpiszbRxd6ZGcAGx9JENolyiU"
//        let cert = "-----BEGIN CERTIFICATE-----\r\nMIICTDCCAbWgAwIBAgIJAPXVlIshF3oGMA0GCSqGSIb3DQEBCwUAMD8xCzAJBgNV\r\nBAYTAktSMQ4wDAYDVQQHDAVTZW91bDEMMAoGA1UECgwDU0tCMRIwEAYDVQQDDAlD\r\nbG91ZFBDQ0EwHhcNMjEwMzMxMDgzMDQ1WhcNMzEwMzI5MDgzMDQ1WjA/MQswCQYD\r\nVQQGEwJLUjEOMAwGA1UEBwwFU2VvdWwxDDAKBgNVBAoMA1NLQjESMBAGA1UEAwwJ\r\nQ2xvdWRQQ0NBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCaaJAC4j9Bv7Jr\r\nwJfSr8ces0Pd/ZUV5QpbORRx/WsPRsNo+GNOJFMncDuZb+0JipjszdzNH4Kpc6V9\r\nJtVKw6O3PVxjY1T5MgdXf2TGHSfpg/QYl5nyJianO6OuOtSxSzYFItsg1prEpRtM\r\nMZNC47c8cNXZ4bgIZoKqFI7D5qyj+wIDAQABo1AwTjAdBgNVHQ4EFgQUXGNC6wiC\r\nx2JyzmESg1Sa/VSi4SUwHwYDVR0jBBgwFoAUXGNC6wiCx2JyzmESg1Sa/VSi4SUw\r\nDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOBgQBB3rP+y/pDu73Dy71r4DXv\r\nZUlB2BD3zIbMFALAp6ph3Z1m+FzezlvLWZdPxCO2S4Oj4G+YhSenRg4OZJWxEfXR\r\n/DDH/DZnST4s8ePhuhq4BKXQlu2HUfwB03Y/4CUx22lM2dP8CHMZH9ubhZjvMwmj\r\nnR+zhrBMPvVWqRVTGekqAg==\r\n-----END CERTIFICATE-----\r\n"
//        let subject = "C=KR, L=Seoul, O=SKB, CN=CloudPCCERT"
////        let subject = ""
//        let audio = true
//        engine_spice_set_connection_data(ip, port, "-1", "pw", tlsPort, token, cert, subject, audio ? 1:0)
        print("setting.curRemoteIp = \(setting.curRemoteIp)")
        print("setting.curRemotePort = \(setting.curRemotePort)")
        print("setting.curRemoteTlsPort = \(setting.curRemoteTlsPort)")
        print("setting.spice_token = \(setting.spice_token)")
        print("setting.ca_cert = \(setting.ca_cert)")
        print("setting.ca_subject = \(setting.ca_subject)")
        print("setting.enableAudio = \(setting.enableAudio)")
        engine_spice_set_connection_data(setting.curRemoteIp, String(setting.curRemotePort), "-1", "pw", String(setting.curRemoteTlsPort), setting.spice_token, setting.ca_cert, setting.ca_subject, setting.enableAudio ? 1:0)

        DispatchQueue.global(qos: .default).async {
            let ret = engine_spice_connect();
            print("ret = \(ret)")
        }
    }
}
