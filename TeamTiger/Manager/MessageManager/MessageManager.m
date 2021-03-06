//
//  MessageManager.m
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "MessageManager.h"
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate+PushView.h"
#import "LoginManager.h"
#import "KeyboardManager.h"

NSString *const NotificationCategoryIdent  = @"ACTIONABLE";
NSString *const NotificationActionOneIdent = @"ACTION_ONE";
NSString *const NotificationActionTwoIdent = @"ACTION_TWO";

@interface MessageManager ()<UNUserNotificationCenterDelegate>

@property(nonatomic, assign) NSTimeInterval lastTimeInterval;

@end

@implementation MessageManager

static MessageManager *singleton = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
            singleton.lastTimeInterval = 0.0;
        }
    });
    return singleton;
}


- (void)startGeTui {
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:gtAppId appKey:gtAppKey appSecret:gtAppSecret delegate:self];
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:NO];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

- (void)registerDeviceToken:(NSString *)deviceToken {
    if (![Common isEmptyString:deviceToken]) {
        [GeTuiSdk registerDeviceToken:deviceToken];
    }
}

#pragma mark - 用户通知(推送) _自定义方法
/** 注册用户通知 */
+ (void)registerUserNotification {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
        //进行用户权限的申请
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|
         UNAuthorizationOptionSound|
         UNAuthorizationOptionAlert|
         UNAuthorizationOptionCarPlay
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
          //默认程序内允许声音和震动
            if (UserDefaultsGet(ALLOW_USER_KEY_PLAY_AUDIO) == nil) {
                UserDefaultsSave(@1, ALLOW_USER_KEY_PLAY_AUDIO);
            }
            if (UserDefaultsGet(ALLOW_USER_KEY_PLAY_SHAKE) == nil) {
                UserDefaultsSave(@1, ALLOW_USER_KEY_PLAY_SHAKE);
            }
            if (UserDefaultsGet(ALLOW_USER_KEY_SHOW_MESSAGE) == nil) {
                UserDefaultsSave(@1, ALLOW_USER_KEY_SHOW_MESSAGE);
            }
        }
                                                                            }];
        [UNUserNotificationCenter currentNotificationCenter].delegate = [MessageManager sharedInstance];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
             [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:NSLocalizedString(@"取消",@"")];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:NSLocalizedString(@"回复",@"")];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MessageManager checkAPNs];
    });
}

+ (BOOL)isMessageNotificationServiceOpen {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return UIRemoteNotificationTypeNone != [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    } else {
        return UIRemoteNotificationTypeNone != [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
}

+ (void)checkAPNs {
    if([MessageManager isMessageNotificationServiceOpen]){
        //允许声音和震动
        if (UserDefaultsGet(ALLOW_USER_KEY_PLAY_AUDIO) == nil) {
            UserDefaultsSave(@1, ALLOW_USER_KEY_PLAY_AUDIO);
        }
        if (UserDefaultsGet(ALLOW_USER_KEY_PLAY_SHAKE) == nil) {
            UserDefaultsSave(@1, ALLOW_USER_KEY_PLAY_SHAKE);
        }
        if (UserDefaultsGet(ALLOW_USER_KEY_SHOW_MESSAGE) == nil) {
            UserDefaultsSave(@1, ALLOW_USER_KEY_SHOW_MESSAGE);
        }
    }
    else {
        //不允许声音和震动
        UserDefaultsRemove(ALLOW_USER_KEY_PLAY_AUDIO);
        UserDefaultsRemove(ALLOW_USER_KEY_PLAY_SHAKE);
        UserDefaultsRemove(ALLOW_USER_KEY_SHOW_MESSAGE);
    }
}

//MARK:- iOS Notification Delegate ()
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
//    UNNotificationRequest *request = notification.request; // 原始请求
    //该回调函数是在通知条即将显示之前调用的
    completionHandler(UNNotificationPresentationOptionBadge);
}

//
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    UNNotificationRequest *request = response.notification.request; // 原始请求
    //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    // Required
    NSDictionary *userInfo = request.content.userInfo;
    //iOS10 收到远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        TT_Message *tmpMsg = [[TT_Message alloc] init];
        tmpMsg.title = userInfo[@"aps"][@"alert"][@"title"];
        tmpMsg.content = userInfo[@"aps"][@"alert"][@"body"];
        tmpMsg.sound = userInfo[@"aps"][@"sound"];
        tmpMsg.badge = [userInfo[@"aps"][@"badge"] integerValue];
        if([userInfo.allKeys containsObject:@"message_type"]) {
            tmpMsg.message_type = [userInfo[@"message_type"] integerValue];
        }
        if ([userInfo.allKeys containsObject:@"payload"]) {
            tmpMsg.url = userInfo[@"payload"];
        }
        [self handleOneMessage:tmpMsg IsOffLine:YES];
        //跳转页面
        if (![LoginManager sharedInstace].isLogin || [Common isEmptyString:gSession]){
            gMessageType = @(tmpMsg.message_type).stringValue;
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appdelegate push:tmpMsg];
            });
        }
    }
    completionHandler();  // 系统要求执行这个方法
}
#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    if (![Common isEmptyString:gSession]) {
        LoginManager *loginManager = [LoginManager sharedInstace];
        if (loginManager.isLogin) {
            //已登录，直接上传client id
            [loginManager uploadClientID:clientId];
        } else {
            gClientID = clientId;
        }
    } else {
        gClientID = clientId;
    }
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    [self handleOneMessage:payloadData IsOffLine:offLine];
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    NSLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    NSLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}



#pragma -mark
#pragma -mark Handle Message
- (void)handleOneMessage:(id)msgObj IsOffLine:(BOOL)isOffLine {
    //do a message
    //    jsonstring 转 object   {"age":"18","name":"xxcao","gender":"male"}
    if (!msgObj) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您收到一条空消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![LoginManager sharedInstace].isLogin || [Common isEmptyString:gSession]){
        //当前处于未登录状态，不接收和处理消息
        return;
    }
    //1.转成message model
    TT_Message *msgModel = [[TT_Message alloc] init];;
    if ([msgObj isKindOfClass:[TT_Message class]]) {
        msgModel = msgObj;
    } else {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:msgObj options:kNilOptions error:nil];
        NSLog(@"Message Transformat Dict: %@",dict);
        [msgModel getModelFromDict:dict];
    }
    //2.storage sqlite
    SqliteManager *sqliteManager = SQLITEMANAGER;
    [sqliteManager setDataBasePath:[TT_User sharedInstance].user_id];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (record_id,title,sub_title,url,url_type,badge,sound,content,create_date,last_edit_date,is_read,media_type,message_type) values('%@','%@','%@','%@','%zd','%zd','%@','%@','%@','%@','%d','%zd','%zd')",TABLE_TT_Message,msgModel.record_id,msgModel.title,msgModel.sub_title,msgModel.url,msgModel.url_type,msgModel.badge,msgModel.sound,msgModel.content,msgModel.create_date,msgModel.last_edit_date,msgModel.is_read,msgModel.media_type,msgModel.message_type];
    [sqliteManager executeSql:sql];
    //3.通知相关UIViewController
    KeyboardManager *keyboardManager = [KeyboardManager sharedInstance];
    if(!keyboardManager.keyboardIsVisible) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_KEY_MESSAGE_COMING object:msgModel];
    } else {
        keyboardManager.messageObject = msgModel;
    }
    //4.UI changed
    if (!isOffLine) {
        NSTimeInterval nowTimeInterval = [NSDate date].timeIntervalSince1970;
        if (nowTimeInterval - self.lastTimeInterval > 0.5) {//时间窗
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //show message
                if ([UserDefaultsGet(ALLOW_USER_KEY_SHOW_MESSAGE) integerValue] == 1) {
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    msgModel.content = msgModel.content;
                    appDelegate.topView.msgModel = msgModel;
                    [appDelegate displayPushView];
                }
                //play shake
                if ([UserDefaultsGet(ALLOW_USER_KEY_PLAY_SHAKE) integerValue] == 1) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                //play audio
                if ([UserDefaultsGet(ALLOW_USER_KEY_PLAY_AUDIO) integerValue] == 1) {
                    static SystemSoundID soundIDTest = 0;
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"bbs" ofType:@"caf"];
                    if (path) {
                        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest);
                    }
                    AudioServicesPlaySystemSound(soundIDTest);
                }
            });
        }
        self.lastTimeInterval = nowTimeInterval;
    }
}

@end
