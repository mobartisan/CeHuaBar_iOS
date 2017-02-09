//
//  NSNotificationCenter+Block.m
//  Cattle
//
//  Created by xxcao on 15/11/5.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "NSNotificationCenter+Block.h"
#import <objc/runtime.h>
static char OperationKey;

@implementation NSNotificationCenter (Block)

- (void)addCustomObserver:(nullable id)observer Name:(nullable NSString *)aName Object:(nullable id)anObject Block:(_Nullable selBlock)block {
    NSString *methodName = [NSNotificationCenter composeNotificationKey:observer Name:aName];
    class_addMethod([observer class], NSSelectorFromString(methodName), (IMP)doNotificaiotn, "v@:@");
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:NSSelectorFromString(methodName)
                                                 name:aName
                                               object:anObject];
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &OperationKey);
    if (!operations) {
        operations = [NSMutableDictionary dictionary];
    }
    operations[methodName] = block;
    objc_setAssociatedObject(self, &OperationKey, operations, OBJC_ASSOCIATION_RETAIN);
}

- (void)removeCustomObserver:(nullable id)observer Name:(nullable NSString *)aName Object:(nullable id)anObject {
    NSString *methodName = [NSNotificationCenter composeNotificationKey:observer Name:aName];
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &OperationKey);
    if (operations && [operations.allKeys containsObject:methodName]) {
        [operations removeObjectForKey:methodName];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:nil];
}

#pragma -mark
#pragma -mark Notification Action
- (void)doNotificationAction:(id)sender Key:(nullable NSString *)key {
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &OperationKey);
    if (operations && [operations.allKeys containsObject:key]) {
        selBlock tmpBlock = operations[key];
        if (tmpBlock) {
            tmpBlock(sender);
        }
    }
}

#pragma -mark
+ (NSString *)composeNotificationKey:(nullable id)observer Name:(nullable NSString *)aName {
    NSString *className = NSStringFromClass([observer class]);
    NSString *key = [NSString stringWithFormat:@"%@_%@:",className,aName];
    return key;
}

@end
