//
//  CrashManager.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/24.
//

import Foundation

// 此处不能写在任何  class truct 中
// MARK: Uncaught Exception
func installUncaughtException() {
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler)
}

func UncaughtExceptionHandler(exception: NSException) {
    let stack = exception.callStackSymbols
    let userInfo = exception.userInfo
    let reason = exception.reason
    let name = exception.name
    let date = dataString()
    
    var string = String()
    string += "======================\(date)==============================\n"
    string += "Stack:\n"
    string = string.appendingFormat("address:0x%0x\r\n", calculate())
    string += "name: \(name.rawValue)  \n"
    string += "reason: \(String(describing: reason))   \n"
    string += "\(stack.joined(separator: "\r"))"
    if userInfo != nil  {
        string += "userInfo: \(String(describing: userInfo))  \n"
    }
    string += "====================================================\n"
}

// MARK: Signal
func installSignalHandler() {
    //Swift代码将以SIGTRAP此异常类型终止
    //    本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业
    signal(SIGHUP, SignalHandler)
    //    程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进程组终止进程。
    signal(SIGINT, SignalHandler)
    //    类似于一个程序错误信号。
    signal(SIGQUIT, SignalHandler)
    
    //调用abort函数生成的信号。
    signal(SIGABRT, SignalHandler)
    signal(SIGILL, SignalHandler)
    signal(SIGTRAP, SignalHandler)
    signal(SIGSEGV, SignalHandler)
    
    signal(SIGFPE, SignalHandler)
    signal(SIGBUS, SignalHandler)
    signal(SIGPIPE, SignalHandler)
}

func SignalHandler(signal: Int32) -> Void {
    var string = String()
    string += "TKCrashLogModule: \n"
    string += "Stack:\n"
    string += "=================begin========\(dataString())========================="
    string = string.appendingFormat("Address:0x%0x\r\n", calculate())
    
    for symbol  in Thread.callStackSymbols {
        string = string.appendingFormat("%@\r", symbol)
    }
    
    string += "=================end========\(dataString())============================"
    
    // 写入文件
    exit(signal)
    
}

func unInstallSignalHandler() {
    signal(SIGHUP, SIG_DFL)
    signal(SIGINT, SIG_DFL)
    signal(SIGQUIT, SIG_DFL)
    
    signal(SIGABRT, SIG_DFL)
    signal(SIGILL, SIG_DFL)
    signal(SIGTRAP, SIG_DFL)
    signal(SIGSEGV, SIG_DFL)
    
    signal(SIGFPE, SIG_DFL)
    signal(SIGBUS, SIG_DFL)
    signal(SIGPIPE, SIG_DFL)
}


/////////////////////////////////////////////////////////////////////////////////
func dataString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY/MM/dd hh:mm:ss SS"
    return formatter.string(from: Date())
}

func path() -> String? {
    let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    return path
}


