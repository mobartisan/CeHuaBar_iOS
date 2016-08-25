//
//  UploadManager.m
//  TeamTiger
//
//  Created by xxcao on 16/8/25.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "LCBatchRequest.h"
#import "NetworkManager.h"
#import "UploadManager.h"
#import "YYTimer.h"

#define kTimeInterval   5

@interface UploadManager ()

@property(nonatomic,strong)YYTimer *timer;

@end

@implementation UploadManager

static UploadManager *singleton = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}

- (BOOL)startService {
    self.timer = [YYTimer timerWithTimeInterval:kTimeInterval target:self selector:@selector(uploadDatas) repeats:YES];
    return YES;
}

- (BOOL)endService {
    [self.timer invalidate];
    self.timer = nil;
    return YES;
}

- (BOOL)appendUploadObject:(id)object {
    @synchronized (self) {
        [self.uploadQueue addObject:object];
    }
    return YES;
}

- (BOOL)appendUploadObjects:(NSArray *)objects {
    @synchronized (self) {
        [self.uploadQueue addObjectsFromArray:objects];
    }
    return YES;
}

- (BOOL)cancelUploadObjectWithID:(id)objectId {
    @synchronized (self) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UploadModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject.fileId isEqualToString:objectId];
        }];
        NSArray *reusltArray = [self.uploadQueue filteredArrayUsingPredicate:predicate];
        [self.uploadQueue removeObjectsInArray:reusltArray];
    }
    return YES;
}

- (BOOL)cancelUploadObjectsWithIDs:(NSArray *)objectIds {
    @synchronized (self) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UploadModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [objectIds containsObject:evaluatedObject.fileId];
        }];
        NSArray *reusltArray = [self.uploadQueue filteredArrayUsingPredicate:predicate];
        [self.uploadQueue removeObjectsInArray:reusltArray];
    }
    return YES;
}

#pragma -mark
#pragma -mark Getter
- (NSMutableArray *)uploadQueue {
    if (!_uploadQueue) {
        _uploadQueue = [NSMutableArray array];
    }
    return _uploadQueue;
}


#pragma -mark
#pragma -mark upload method
- (void)uploadDatas{
    if (!self.uploadQueue || self.uploadQueue.count == 0) {
        return;
    }
    NSMutableArray *apis = [NSMutableArray array];
    NSMutableArray *modelIDs = [NSMutableArray array];
    for (UploadModel *obj in self.uploadQueue) {
        ImageUploadApi *api = [[ImageUploadApi alloc] init];
        api.uploadModel = obj;
        [apis addObject:api];
        [modelIDs addObject:obj.fileId];
    }
    
    LCBatchRequest *request = [[LCBatchRequest alloc] initWithRequestArray:apis];
    [request startWithBlockSuccess:^(LCBatchRequest *batchRequest) {
        //success
        [self cancelUploadObjectsWithIDs:modelIDs];
    } failure:^(LCBatchRequest *batchRequest) {
        
    }];
}

@end
