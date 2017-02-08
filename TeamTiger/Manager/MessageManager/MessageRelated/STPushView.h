//
//  STPushView.h
//  TeamTiger
//
//  Created by xxcao on 2017/2/7.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//


#import <UIKit/UIKit.h>

// push 推送的model

//推送过来的数据如下：
/**
 content = dsfdsnfds;
 id = 5077;
 mid = 1270339;
 title = dsfdsnfds;
 url = "3?_from=push";
 urlType = 3;
 
 **/
#import <Foundation/Foundation.h>

@interface STPushModel : NSObject <NSCoding> //STBaseModel 是一个继承自NSObject的类 我主要是在这个类中实现了字典转模型的功能 你可以直接修改为NSObject

/***id**/
@property (copy,nonatomic) NSString *recordId;
/***标题**/
@property (copy, nonatomic) NSString *title;
/***url**/
@property (copy, nonatomic) NSString *url;
/***url 类型**/
@property (copy, nonatomic) NSString *urlType;
/***图标的高度**/
@property (assign,nonatomic) NSString *mid;
/***推送内容**/
@property (copy, nonatomic) NSString *content;

- (void)getModelFromDict:(NSDictionary *)dict;

@end

@interface STPushView : UIView

/** *推送数据模型 */
@property(nonatomic,strong) STPushModel *model;

+(instancetype)shareInstance;
+ (void)show;
+ (void)hide;

@end
