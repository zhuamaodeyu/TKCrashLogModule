//
//  Handlers.m
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

#import "Handlers.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

@implementation Handlers

+(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    return  [formatter stringFromDate:[NSDate date]];
}
+ (NSString *)path {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) firstObject];
    return path;
}

@end



void SignalHandler(int signal) {
    NSMutableString *string = [[NSMutableString alloc] init];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [string appendFormat:@"%s\n", strs[i]];
    }
}

/**
 1. Signal
 2. Exception
 
 */
void UncaughtHandler(NSException *exception) {
    
    
    // 堆栈信息
    NSArray *stack = [exception callStackSymbols];
    
    NSDictionary *userInfo = [exception userInfo];
    
    NSArray *stackAddress = [exception callStackReturnAddresses];
    
    // 原因
    NSString *reason = [exception reason];
    
    // 名字
    NSString *name = [exception name];
    
    // date
    
    
    // 时间
    NSLog(@"%@------%@------%@------%@------%@",reason, name, stack, userInfo,stackAddress);
}

void InstallSignalHander() {
//    本信号在用户终端连接(正常或非正常)结束时发出, 通常是在终端的控制进程结束时, 通知同一session内的各个作业
    signal(SIGHUP, SignalHandler);
//    程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进程组终止进程。
    signal(SIGINT, SignalHandler);
//    类似于一个程序错误信号。
    signal(SIGQUIT, SignalHandler);
    
//    调用abort函数生成的信号。
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

void InstallUncaughtHandler() {
    NSSetUncaughtExceptionHandler(&UncaughtHandler);
}
