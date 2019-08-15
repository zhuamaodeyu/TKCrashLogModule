//
//  Upload.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

import Foundation
import skpsmtpmessage


enum UploadType {
    case email
    case http
}

typealias UploadComplation = (_ type: UploadType, _ result: Bool, _ error: String?) -> Void
class Upload {

    private var email: Email?
    private var http: Http?
    private var complation:UploadComplation

    private let group = DispatchGroup.init()
    private let semaphore = DispatchSemaphore.init(value: 0)
    private let queue = DispatchQueue.global()

    private var utils: Utils?

    init(_ com:@escaping UploadComplation) {
        self.complation = com
        self.utils = Utils.init()
    }

    func config(email: Email? = nil ,http: Http? = nil)  {
        if let e = email{
            self.email = e
        }
        if let h = http {
            self.http = h
        }
    }
    
    func start() {
        queue.async(group: group) {
            self.sendEmail()
        }
        semaphore.wait()
        queue.async(group: group) {
            self.uploadFile()
        }
        semaphore.wait()
        group.notify(queue: queue) {
            self.utils?.remove(type: .all)
        }
    }
}


extension Upload {
    private func sendEmail() {
        guard let email = email, let fileUrl = zip(password: email.zipPassword), let data = try? NSData.init(contentsOf: fileUrl, options: []) else {
            semaphore.signal()
            return
        }


        let message = SKPSMTPMessage()
        message.relayHost = email.host
        message.login = email.from
        message.pass = email.password
        message.requiresAuth = email.requiresAuth
        message.wantsSecure = email.isSecure
        message.fromEmail = email.from
        message.toEmail = email.target
        message.subject = email.title

        let messagePart = [
            kSKPSMTPPartContentTypeKey: "text/directory; charset=UTF-8",
            kSKPSMTPPartContentDispositionKey: "attachment;\r\n\tfilename=\"\(Utils.zipName())\"",
            kSKPSMTPPartMessageKey: data.encodeBase64ForData(),
            kSKPSMTPPartContentTransferEncodingKey:"base64",
            ] as [String : Any]
        message.parts = [messagePart]
        message.delegate = self

        DispatchQueue.global().async {
            message.send()
            RunLoop.current.run()
        }
    }
    
    fileprivate func uploadFile() {
        guard let http = http,let url = URL(string: (http.host)), let fileUrl = zip(password: http.zipPassword) else {
            semaphore.signal()
            return
        }

        let request =  NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        let config = URLSessionConfiguration.background(withIdentifier: "com.crashlog.upload")
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.init())
        session.uploadTask(with: request as URLRequest, fromFile: fileUrl) { [weak self](data , response, error) in
            self?.semaphore.signal()
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode ?? 0 == 200 {
                self?.complation(.http, true, nil)
            }else {
                self?.complation(.http, false, httpResponse.debugDescription)
            }

        }.resume()
    }
}

extension Upload: SKPSMTPMessageDelegate {
    func messageSent(_ message: SKPSMTPMessage!) {
        semaphore.signal()
        self.complation(.email, true,nil)
    }
    func messageFailed(_ message: SKPSMTPMessage!, error: Error!) {
        semaphore.signal()
        self.complation(.email, false, "\(String(describing: error))")
    }
}

extension Upload {
    private func zip(password: String?) -> URL? {
        guard let path = self.utils?.zip(password: password) else {
            return nil
        }
        return URL.init(fileURLWithPath: path)
    }
}

