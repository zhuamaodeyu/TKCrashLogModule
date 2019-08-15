//
//  Models.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2019/8/14.
//

import Foundation


struct Email {
    private(set) var title: String
    private(set) var target: String
    private(set) var from: String
    private(set) var host: String
    private(set) var requiresAuth: Bool
    private(set) var password: String
    private(set) var isSecure: Bool
    private(set) var zipPassword:String? = nil
    init(title: String, target: String, from: String,host: String,requiresAuth: Bool,password: String,isSecure: Bool, zipPassword:String? = nil) {
        self.title = title
        self.target = target
        self.from = from
        self.host = host
        self.requiresAuth = requiresAuth
        self.password = password
        self.isSecure = isSecure
        self.zipPassword = zipPassword
    }
}

struct Http {
    private(set) var host: String
    private(set) var zipPassword: String?
    init(host: String, zipPassword: String? = nil) {
        self.host = host
        self.zipPassword = zipPassword
    }
}



