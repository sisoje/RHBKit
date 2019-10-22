#import "RHBDiagnostics.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

mach_vm_size_t memory_usage() {
    
    struct mach_task_basic_info info;
    mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
    return result == KERN_SUCCESS ? info.resident_size : 0;
}

@implementation RHBDiagnostics

+(UInt64)memoryUsed {
    
    return memory_usage();
}

@end
