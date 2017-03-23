//
//  ContactModel.h
//  TeamTiger
//
//  Created by xxcao on 16/7/31.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactModel : NSObject<NSCoding>

@property(copy,nonatomic)NSString *portrait;

@property(copy,nonatomic)NSString *name;

@property(copy,nonatomic)NSString *email;

@property(strong,nonatomic)NSNumber *isAdd;

@property(strong,nonatomic)NSData *imageData;

+ (NSArray *)modelArrayFromDictionaryArray:(NSArray *)dArray;

+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;
+ (NSMutableArray *) getFriendListSectionBy:(NSMutableArray *)array;

+ (ContactModel *)customCopy:(ContactModel *)srcModel;

@end
