//
//  Constant.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

static NSString *const Dev_Server = @"http://120.26.102.93:3002/bbs/api/v1.0/";
//static NSString *const Pro_Server = @"http://www.cehuabar.com:3001/bbs/api/v1.0/";
static NSString *const Pro_Server = @"http://118.31.115.93:3306/bbs/api/v1.0/";
//GeTui

static NSString *const gtAppId = @"IDmqL4Had8ARm3iKv9y4g2";

static NSString *const gtAppSecret = @"Ei65yWW81c7EPhwd5d3Pn9";

static NSString *const gtAppKey = @"jj16WEjX6z8vpT4TF1ChM6";

static NSString *const gtMasterSecret = @"4bxJjcNdUh96Ght4aHotg4";

//默认图片
#define kImageForHead [UIImage imageNamed:@"common-headDefault"]

static NSString *const SYSTEM = @"SYSTEM";//系统数据库名字

static NSString *const TABLE_APP_SETTINGS = @"APP_SETTINGS";//数据库表名

static NSString *const TABLE_TT_Group = @"TT_Group";

static NSString *const TABLE_TT_Project = @"TT_Project";

static NSString *const TABLE_TT_Project_Members = @"TT_Project_Members";

static NSString *const TABLE_TT_Discuss = @"TT_Discuss";

static NSString *const TABLE_TT_Discuss_Result = @"TT_Discuss_Result";

static NSString *const TABLE_TT_Comment = @"TT_Comment";

static NSString *const TABLE_TT_User = @"TT_User";

static NSString *const TABLE_TT_Notification = @"TT_Notification";

static NSString *const TABLE_TT_Attachment = @"TT_Attachment";

static NSString *const TABLE_TT_At_Members = @"TT_At_Members";

static NSString *const TABLE_TT_Message = @"TT_Message";



//网络返回Key
static NSString *const CODE = @"code";
static NSString *const MSG = @"msg";
static NSString *const SUCCESS = @"success";
static NSString *const OBJ = @"obj";
static NSString *const TOKEN = @"token";
static NSString *const DATA = @"data";
static NSString *const SERVICEVERSION = @"version_number";
static NSString *const DESCRIPTION = @"description";
static NSString *const NETWORKERROR = @"您的网络好像有问题~";

//微信相关
#define WXDoctor_App_ID @"wx6103c7337b6114c0"  // 注册微信时的AppID
#define WXDoctor_App_Secret @"822233ed08a3484e00ff4f10d8608c1a" // 注册时得到的AppSecret
#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

//七牛
//by xiao jie
//static NSInteger defaultLiveTime = 365;
//static NSString *const QiNiuScope = @"cjdale";
//static NSString *const QiNiuAccessKey = @"M82sZ5xflkxGQr1Kyi0VTG9UUid5PYBqYCzGgxv0";
//static NSString *const QiNiuSecretKey = @"t9uR0JgBozDzQduR9h-HS0p-nye7Vm2cYIlGkkem";
//#define QiNiuBaseUrl @"http://ohcjw5fss.bkt.clouddn.com/"

//by xxcao
static NSInteger defaultLiveTime = 365 * 2;
static NSString *const QiNiuScope = @"cehuabar";
static NSString *const QiNiuAccessKey = @"tRt7hVxW6XdAhZCFG3BY1e8Eq5SuIoHdLbao4vp4";
static NSString *const QiNiuSecretKey = @"kHeHeJ6TKGk_xg0cLduUPwESFFyWoK8XOzMfrC71";
#define QiNiuBaseUrl @"http://oeveo0t8n.bkt.clouddn.com/"


static NSString *const kCompressKey = @"?imageView2/2/w/120/h/120/q/100";

//new message notification
static NSString *const ALLOW_USER_KEY_PLAY_SHAKE = @"USER_KEY_PLAY_SHAKE";

static NSString *const ALLOW_USER_KEY_PLAY_AUDIO = @"USER_KEY_PLAY_AUDIO";

static NSString *const ALLOW_USER_KEY_SHOW_MESSAGE = @"USER_KEY_SHOW_MESSAGE";

//Notification Key
static NSString *const NOTICE_KEY_MESSAGE_COMING = @"NOTICE_KEY_MESSAGE_COMING";
static NSString *const NOTICE_KEY_RELATED_APNS = @"APNS_Notification_Key";
static NSString *const NOTICE_KEY_NEED_REFRESH_MOMENTS = @"Need_Refresh_Moments";
static NSString *const NOTICE_KEY_NEED_REFRESH_MOMENTS_2 = @"Need_Refresh_Moments_String";

#endif /* Constant_h */
