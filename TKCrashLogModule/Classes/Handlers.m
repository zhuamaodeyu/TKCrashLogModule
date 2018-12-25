//
//  Handlers.m
//  TKCrashLogModule
//
//  Created by 聂子 on 2018/12/23.
//

#import "Handlers.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <mach-o/dyld.h>


@implementation Handlers


@end

// 获取偏移量地址
long calculate(void)
{
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}


//NSString *executableUUID()
//{
//    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
//    for (uint32_t idx = 0; idx cmd == LC_UUID) {
//        command += sizeof(struct load_command);
//        return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
//                command[0], command[1], command[2], command[3],
//                command[4], command[5],
//                command[6], command[7],
//                command[8], command[9],
//                command[10], command[11], command[12], command[13], command[14], command[15]];
//    } else {
//        command += ((const struct load_command *)command)->cmdsize;
//    }
//    return  nil;
//}

void SignalHandler(int signal) {
    NSMutableString *string = [[NSMutableString alloc] init];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [string appendFormat:@"%s\n", strs[i]];
    }
}
