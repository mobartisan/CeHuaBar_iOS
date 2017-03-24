//
//  KeyboardManager.h
//  TeamTiger
//
//  Created by xxcao on 2017/3/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardManager : NSObject

@property(nonatomic, strong)id messageObject;

+ (instancetype)sharedInstance;

- (BOOL)keyboardIsVisible;

@end
