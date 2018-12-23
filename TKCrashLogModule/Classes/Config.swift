//
//  Config.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

import Foundation
import skpsmtpmessage

class Config {
    fileprivate var email: Email?
    fileprivate var http: Http?
    func config(email: Email?,http: Http?)  {
        if email != nil {
            self.email = email
        }
        if http != nil {
            self.http = http
        }
    }
    
    func  upload()  {
        if email != nil {
            sendEmail()
            return
        }
        if http != nil  {
            uploadFile()
        }
    }
}

extension Config {
    fileprivate func sendEmail() {
        let message = SKPSMTPMessage()
        message.relayHost = email?.host
        message.login = email?.from
        message.pass = email?.password
        message.requiresAuth = email?.requiresAuth ?? false
        message.wantsSecure = email?.isSecure ?? false
        message.fromEmail = email?.from
        message.toEmail = email?.target
        message.subject = email?.title
        let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: "body"] as [String : Any]
        message.parts = [messagePart]
        message.delegate = self
        message.send()
    }
    
    fileprivate func uploadFile() {
        let url = URL(string: (self.http?.host ?? ""))
        let request =  NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        URLSession.shared.uploadTask(with: request as URLRequest, fromFile: url!) { (data , response, error) in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode ?? 0 == 200 {
                self.removeAllFile()
            }
        }
        URLSession.shared.uploadTask(with: request as URLRequest, fromFile: URL(string: "")!) { (data , response, error) in
            
        }.resume()
        
    }
    
}

extension Config {
    /// 获取所有的内容拼接
    fileprivate func body() -> String{
        return ""
    }
    /// 获取压缩后的路径
    fileprivate func zip() -> String {
        return ""
    }
    
    fileprivate func removeAllFile() {
        
    }
}


extension Config: SKPSMTPMessageDelegate {
    func messageSent(_ message: SKPSMTPMessage!) {
        // 是否要删除文件
        if self.http != nil  {
            uploadFile()
        }else {
            removeAllFile()
        }
    }
    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        debugPrint("sending email failed")
    }
}


class Email {
    var title: String
    var target: String
    var from: String
    var host: String
    var requiresAuth: Bool
    var password: String
    var isSecure: Bool
    init(title: String, target: String, from: String,host: String,requiresAuth: Bool,password: String,isSecure: Bool) {
        self.title = title
        self.target = target
        self.from = from
        self.host = host
        self.requiresAuth = requiresAuth
        self.password = password
        self.isSecure = isSecure
    }
}

class Http {
    var host: String
    init(host: String) {
        self.host = host
    }
}


