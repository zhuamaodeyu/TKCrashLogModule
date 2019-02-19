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
        registerSignalHandler()
        registerUncaughtExceptionHander()
    }
}

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
        self.begin()
    }
    
   /// register
   ///
   /// - Parameter host: HTTP 文件上传服务器地址
   public func register(host: String,password: String,isSecure: Bool,block:(()->Void)?) {
        let http = Http.init(host: host, password: password, isSecure: isSecure)
        self.config.config(email: nil , http: http)
        self.block = block
        self.begin()
    }
}

extension CrashLogManager {
    // 信号量拦截
    fileprivate func registerSignalHandler() {
        installSignalHandler()
    }
    // 系统异常捕获
    fileprivate func registerUncaughtExceptionHander() {
        installUncaughtException()
    }
    /// 开启上传
    fileprivate func begin() {
        self.config.start()
    }
}














