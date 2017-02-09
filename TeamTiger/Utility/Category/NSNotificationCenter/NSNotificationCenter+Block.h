//
//  NSNotificationCenter+Block.h
//  Cattle
//
//  Created by xxcao on 15/11/5.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^selBlock)(_Nullable id sender);

@interface NSNotificationCenter (Block)

- (void)addCustomObserver:(nullable id)observer Name:(nullable NSString *)aName Object:(nullable id)anObject Block:(_Nullable selBlock)block;

- (void)removeCustomObserver:(nullable id)observer Name:(nullable NSString *)aName Object:(nullable id)anObject;

//自定义方法
- (void)doNotificationAction:(nullable id)sender Key:(nullable NSString *)key;

//组建key
+ (nullable NSString *)composeNotificationKey:(nullable id)observer Name:(nullable NSString *)aName;

@end
