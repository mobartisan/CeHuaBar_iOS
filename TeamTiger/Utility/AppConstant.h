//
//  Constant.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

static NSString *const Dev_Server = @"http://192.168.253.20:3001/";
static NSString *const Pro_Server = @"http://www.cehuabar.com:3001/";
//GeTui

static NSString *const gtAppId = @"IDmqL4Had8ARm3iKv9y4g2";

static NSString *const gtAppSecret = @"Ei65yWW81c7EPhwd5d3Pn9";

static NSString *const gtAppKey = @"jj16WEjX6z8vpT4TF1ChM6";

static NSString *const gtMasterSecret = @"4bxJjcNdUh96Ght4aHotg4";

//默认图片
#define kImageForHead [UIImage imageNamed:@"common-headDefault"]

static NSString *const SYSTEM = @"SYSTEM";//系统数据库名字

static NSString *const TABLE_APP_SETTINGS = @"APP_SETTINGS";//数据库表名

static NSString *const TABLE_TT_Project = @"TT_Project";

static NSString *const TABLE_TT_Project_Members = @"TT_Project_Members";

static NSString *const TABLE_TT_Discuss = @"TT_Discuss";

static NSString *const TABLE_TT_Discuss_Result = @"TT_Discuss_Result";

static NSString *const TABLE_TT_Comment = @"TT_Comment";

static NSString *const TABLE_TT_User = @"TT_User";

static NSString *const TABLE_TT_Notification = @"TT_Notification";

static NSString *const TABLE_TT_Attachment = @"TT_Attachment";

static NSString *const TABLE_TT_At_Members = @"TT_At_Members";

//网络返回Key
static NSString *const CODE = @"code";
static NSString *const MSG = @"msg";
static NSString *const SUCCESS = @"success";
static NSString *const OBJ = @"obj";

#endif /* Constant_h */
