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

//微信相关
#define WXDoctor_App_ID @"wx6103c7337b6114c0"  // 注册微信时的AppID
#define WXDoctor_App_Secret @"822233ed08a3484e00ff4f10d8608c1a" // 注册时得到的AppSecret
#define WXPatient_App_ID @"wxbd02bfeea4292***"
#define WXPatient_App_Secret @"4a788217f363358276309ab655707***"
#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"


#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

//七牛
static NSInteger defaultLiveTime = 365;
static NSString *const QiNiuScope = @"cjdalebbs";
static NSString *const QiNiuAccessKey = @"M82sZ5xflkxGQr1Kyi0VTG9UUid5PYBqYCzGgxv0";
static NSString *const QiNiuSecretKey = @"t9uR0JgBozDzQduR9h-HS0p-nye7Vm2cYIlGkkem";
#define QiNiuBaseUrl @"http://oez5w6mq8.bkt.clouddn.com/"

#endif /* Constant_h */
