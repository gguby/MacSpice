//
//  ViewController.swift
//  MacSpice
//
//  Created by y2k on 2022/07/06.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        
//        engine_spice_set_client_info("test", "ios", "0.0.0.0")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func test(_ sender: Any) {
        let ip = "192.168.162.25"
        let port = "-1"
        let tlsPort = "5917"
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VfdGxzIjp0cnVlLCJ2bV9pZCI6IjczOThjMWU0LWUzZGMtNGM2Yi1hZTI3LWY5MmQ5NzVjNzc5MCIsInVzZXJfdHlwZSI6InVzZXIiLCJleHAiOjE2NTc4NDAzMzEsInRva2VuIjoidUE4SGlDdWxGZFRna3NYUzg1TlUzZz09In0.66rKTK9qod-r0OZSibCpiszbRxd6ZGcAGx9JENolyiU"
        let cert = "-----BEGIN CERTIFICATE-----\r\nMIICTDCCAbWgAwIBAgIJAPXVlIshF3oGMA0GCSqGSIb3DQEBCwUAMD8xCzAJBgNV\r\nBAYTAktSMQ4wDAYDVQQHDAVTZW91bDEMMAoGA1UECgwDU0tCMRIwEAYDVQQDDAlD\r\nbG91ZFBDQ0EwHhcNMjEwMzMxMDgzMDQ1WhcNMzEwMzI5MDgzMDQ1WjA/MQswCQYD\r\nVQQGEwJLUjEOMAwGA1UEBwwFU2VvdWwxDDAKBgNVBAoMA1NLQjESMBAGA1UEAwwJ\r\nQ2xvdWRQQ0NBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCaaJAC4j9Bv7Jr\r\nwJfSr8ces0Pd/ZUV5QpbORRx/WsPRsNo+GNOJFMncDuZb+0JipjszdzNH4Kpc6V9\r\nJtVKw6O3PVxjY1T5MgdXf2TGHSfpg/QYl5nyJianO6OuOtSxSzYFItsg1prEpRtM\r\nMZNC47c8cNXZ4bgIZoKqFI7D5qyj+wIDAQABo1AwTjAdBgNVHQ4EFgQUXGNC6wiC\r\nx2JyzmESg1Sa/VSi4SUwHwYDVR0jBBgwFoAUXGNC6wiCx2JyzmESg1Sa/VSi4SUw\r\nDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOBgQBB3rP+y/pDu73Dy71r4DXv\r\nZUlB2BD3zIbMFALAp6ph3Z1m+FzezlvLWZdPxCO2S4Oj4G+YhSenRg4OZJWxEfXR\r\n/DDH/DZnST4s8ePhuhq4BKXQlu2HUfwB03Y/4CUx22lM2dP8CHMZH9ubhZjvMwmj\r\nnR+zhrBMPvVWqRVTGekqAg==\r\n-----END CERTIFICATE-----\r\n"
        let subject = "C=KR, L=Seoul, O=SKB, CN=CloudPCCERT"
//        let subject = ""
        let audio = true
        engine_spice_set_connection_data(ip, port, "-1", "pw", tlsPort, token, cert, subject, audio ? 1:0)
        DispatchQueue.global(qos: .default).async {
            let ret = engine_spice_connect();
            print("ret = \(ret)")
        }
    }

}

