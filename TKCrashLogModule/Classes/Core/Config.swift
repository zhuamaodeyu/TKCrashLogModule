//
//  Config.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

import Foundation
import skpsmtpmessage
import  ZipArchive

fileprivate let timerName = "upload_timer"
class Config {
    fileprivate var email: Email?
    fileprivate var http: Http?
    
    func config(email: Email?,http: Http?)  {
        if let e = email {
            self.email = e
        }
        if let h = http {
            self.http = h
        }
    }
    
    func start()  {
        if GCDTimer.shared.isExistTimer(WithTimerName: timerName) {
            return
        }
        GCDTimer.shared.scheduledDispatchTimer(WithTimerName: timerName, timeInterval: 30 * 60, queue: DispatchQueue.global(), repeats: true, action: {[weak self] in
            self?.upload()
        })
    }
    
    fileprivate func upload() {
        if email != nil {
            sendEmail()
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
        // read content
        let body = self.body()
        if body == nil {
            return
        }
        
        let messagePart = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: "body"] as [String : Any]
        message.parts = [messagePart]
        message.delegate = self
        message.send()
    }
    
    fileprivate func uploadFile() {
        let url = URL(string: (self.http?.host ?? ""))
        let request =  NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let fileUrl = zip()
        if fileUrl == nil {
            return
        }
        
        URLSession.shared.uploadTask(with: request as URLRequest, fromFile: fileUrl!) { (data , response, error) in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode ?? 0 == 200 {
                
            }
        }.resume()
    }
}

extension Config: SKPSMTPMessageDelegate {
    func messageSent(_ message: SKPSMTPMessage!) {
        // 是否要删除文件
        if self.http != nil  {
            uploadFile()
        }else {
//            removeAllFile()
        }
    }
    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        debugPrint("sending email failed")
    }
}

extension Config {
    /// 获取所有的内容拼接
    fileprivate func body() -> String?{
        return ""
    }
    /// 获取压缩后的路径
    fileprivate func zip() -> URL? {
        return URL(string: "")
    }
}

struct Email {
    fileprivate var title: String
    fileprivate var target: String
    fileprivate var from: String
    fileprivate var host: String
    fileprivate var requiresAuth: Bool
    fileprivate var password: String
    fileprivate var isSecure: Bool
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

struct Http {
    fileprivate var host: String
    fileprivate var password: String
    fileprivate var isSecure: Bool
    init(host: String, password: String, isSecure: Bool) {
        self.host = host
        self.isSecure = isSecure
        self.password = password
    }
}



