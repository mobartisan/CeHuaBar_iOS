//
//  DeviceManager.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/29.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject
+ (instancetype)sharedInstance;

- (NSString *)iphoneType;

- (NSString *)getDeviceType;
@end
