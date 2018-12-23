//
//  CrashLogManager.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

import Foundation


public class CrashLogManager {
    public static let sharedManager = CrashLogManager()
    fileprivate var config = Config()
    fileprivate var block:(()->Void)?

    init() {
        installSignalHandler()
        installUncaughtExceptionHander()
        if checkUnSend() {
            upload()
        }
    }
}

/**
 config :
    1. 邮件  或者 HTTP
    2.
 */

extension CrashLogManager {
    
   /// register
   ///
   /// - Parameters:
   ///   - title: 邮件主题
   ///   - target: 目标邮箱
   ///   - from: 发送者邮箱
   ///   - host: 发送代理服务器
   ///   - requiresAuth: 是否 auth
   ///   - password: 发送者邮箱密码
   ///   - isSecure: 是否加密
    public func register(title: String, target: String, from: String,host: String,requiresAuth: Bool,password: String,isSecure: Bool, block:(()->Void)?) {
        let email = Email(title: title, target: target, from: from, host: host, requiresAuth: requiresAuth, password: password, isSecure: isSecure)
        self.config.config(email: email, http: nil)
        self.block = block
    }
    
   /// register
   ///
   /// - Parameter host: HTTP 文件上传服务器地址
   public func register (host: String,block:(()->Void)?) {
        let http = Http(host: host)
        self.config.config(email: nil , http: http)
        self.block = block
    }
}

extension CrashLogManager {
    // 信号量拦截
    fileprivate func installSignalHandler() {
        // 调用C 代码
        InstallSignalHander()
    }
    // 系统异常捕获
    fileprivate func installUncaughtExceptionHander() {
        InstallUncaughtHandler()
    }
    /// 检测是否有未上传的
    fileprivate func checkUnSend() ->Bool {
        return false
    }
    fileprivate func upload() {
        self.config.upload()
    }
    
}














