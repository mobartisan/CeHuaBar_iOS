//
//  DeviceManager.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/29.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DeviceManager.h"
#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#import "SDiPhoneVersion.h"

@implementation DeviceManager
static DeviceManager *deviceManager = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!deviceManager) {
            deviceManager = [[[self class] alloc] init];
        }
    });
    return deviceManager;
}

- (NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *type = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return type;
}
- (NSString *)iphoneType
{
    return [NSString stringWithFormat:@"%@-iOS(%@)-Sys(%@)-App(%@)",[UIDevice currentDevice].name,[SDiPhoneVersion deviceType:[SDiPhoneVersion deviceVersion]],CurrentSystemVersion_String,AppVersion];
}
- (NSString *)iphoneScreen
{
    return [SDiPhoneVersion deviceScreen];
}

@end
