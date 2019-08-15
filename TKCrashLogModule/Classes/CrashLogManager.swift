//
//  CrashLogManager.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

import Foundation

public typealias Compaltion = (_ result: Bool, _ err: String?)-> Void

public class TKCrashLogManager {
    public static let intance = TKCrashLogManager()

    private var config:Upload?
    private var emailBlock:Compaltion?
    private var httpBlock:Compaltion?

    init() {
        registerSignalHandler()
        registerUncaughtExceptionHander()
        config = Upload.init({ [weak self](type,result, err) in
            switch type {
            case .email:
                self?.emailBlock?(result, err)
            case .http:
                self?.httpBlock?(result,err)
            }
        })
    }
}

extension TKCrashLogManager {
    
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
    public func register(email title: String, target: String, from: String,host: String,requiresAuth: Bool,password: String,isSecure: Bool,zipPassword:String? = nil, complation:Compaltion?) {
        let email = Email(title: title, target: target, from: from, host: host, requiresAuth: requiresAuth, password: password, isSecure: isSecure, zipPassword: zipPassword)
        self.config?.config(email: email)
        self.emailBlock = complation
        self.begin()
    }
    
   /// register
   ///
   /// - Parameter host: HTTP 文件上传服务器地址
    public func register(host: String,zipPassword: String?,complation:Compaltion?) {
        let http = Http.init(host: host, zipPassword: zipPassword)
        self.config?.config(http: http)
        self.httpBlock = complation
        self.begin()
    }
}


// MARK: - private method
extension TKCrashLogManager {

    private func registerSignalHandler() {
        installSignalHandler()
    }

    private func registerUncaughtExceptionHander() {
        installUncaughtException()
    }

    private func begin() {
        self.config?.start()
    }
}














