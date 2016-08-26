//
//  UploadManager.h
//  TeamTiger
//
//  Created by xxcao on 16/8/25.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadModel : NSObject

@property(nonatomic,strong) NSData *data;

@property(nonatomic,copy) NSString *fileName;

@property(nonatomic,copy) NSString *fileExt;

@property(nonatomic,copy) NSString *fileLength;

@property(nonatomic,copy) NSString *fileFormKey;

@property(nonatomic,copy) NSString *fileType;

@property(nonatomic,copy) NSString *fileId;

@end

@interface UploadManager : NSObject

@property(nonatomic,strong)NSMutableArray *uploadQueue;

+ (instancetype)sharedInstance;

- (BOOL)startService;

- (BOOL)endService;

- (BOOL)appendUploadObject:(id)object;

- (BOOL)appendUploadObjects:(NSArray *)objects;

- (BOOL)cancelUploadObjectWithID:(id)objectId;

- (BOOL)cancelUploadObjectsWithIDs:(NSArray *)objectIds;

@end
