//
//  AppDelegate.swift
//  TKCrashLogModule
//
//  Created by zhuamaodeyu on 12/23/2018.
//  Copyright (c) 2018 zhuamaodeyu. All rights reserved.
//

import UIKit
import TKCrashLogModule

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 包含两种方式
        // 1. 文件上传
        // 2. email 发送
        TKCrashLogManager.intance.register(email: "crash log", target: "13759668367@163.com", from: "playtomandjerry@gmail.com", host: "smtp.gmail.com", requiresAuth: true, password: "xxxxxxx", isSecure: true, zipPassword: "123456") { (result, error) in
            debugPrint("发送email")
        }



        return true
    }
}

