//
//  CrashHandler.swift
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/24.
//

import Foundation
import libkern
import MachO
import Darwin


// MARK: - register
func installUncaughtException() {
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler)
}
func installSignalHandler() {
    //Swift代码将以SIGTRAP此异常类型终止
    //本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业
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


// MARK: - unregister
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

// MARK: - handler
func SignalHandler(signal: Int32) -> Void {
    var string = String()
    string += "TKCrashLogModule: \n"
    string += "Stack:\n"
    string += "=================begin========\(Utils.dateString())=========================\n"
    string += "=============================\(Utils.identifity())==========================\n"
    string = string.appendingFormat("Address:0x%0x\r\n", calculate())
    for symbol  in Thread.callStackSymbols {
        string = string.appendingFormat("%@\r", symbol)
    }
    string += "\n=================end========\(Utils.dateString())============================\n"
    // TODO: 写入文件
    Utils.init()?.save(type: .signal, message: string)
    // 终止程序
    exit(signal)
}

func UncaughtExceptionHandler(exception: NSException) {
    let stack = exception.callStackSymbols
    let userInfo = exception.userInfo
    let reason = exception.reason
    let name = exception.name
    
    var string = String()
    string += "======================\(Utils.dateString())==============================\n"
    string += "=============================\(Utils.identifity())==========================\n"
    string += "Stack:\n"
    string = string.appendingFormat("address:0x%0x\r\n", calculate())
    string += "name: \(name.rawValue)  \n"
    string += "reason: \(String(describing: reason))   \n"
    string += "\(stack.joined(separator: "\r"))"
    if userInfo != nil  {
        string += "userInfo: \(String(describing: userInfo))  \n"
    }
    string += "\n=================end========\(Utils.dateString())============================\n"
    
    // TODO: 写入文件
    Utils.init()?.save(type: .exception, message: string)
}



func calculate() -> Int64 {
    var slide:Int64 = 0
    
    for i in 0..<_dyld_image_count() {
        let header = _dyld_get_image_header(i).pointee
        if header.filetype == MH_EXECUTE {
            slide = Int64(_dyld_get_image_vmaddr_slide(i))
            break
        }
    }
     return slide
}

