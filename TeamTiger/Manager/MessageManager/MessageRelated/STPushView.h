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
/**
  message_type:
//项目变更 1
1.创建一个项目时，当添加与我有关联的人员，他（他）将会收到一条ApnS通知；
2.群主解散一个项目时，组员将收到一条解散项目的ApnS通知；
3.当组员退出项目时，所有成员收到一条退出项目的ApnS通知；

项目成员变更 2
4.当给项目增加人员时，给出一条增加人员的ApnS通知；
5.当给项目删除人员时，给出一条删除人员的ApnS通知；
 
//moment变更 3
6.当组员（管理员）发布一条moment时，该项目的其他成员将收到一条发布moment的ApnS通知；
7.当组员（管理员）发布一条投票时，该项目的其他成员将收到一条投票的ApnS通知；
8.当组员（管理员）评论一条moment时，该项目的其他成员将收到一条moment更新的ApnS通知；
9.当组员（管理员）投票时，该项目的其他成员将收到一条投票更新的ApnS通知；
*/

@interface TT_Message: NSObject <NSCoding>

/***id**/
@property (copy,nonatomic) NSString *record_id;
/***标题**/
@property (copy, nonatomic) NSString *title;
/***副标题**/
@property (copy, nonatomic) NSString *sub_title;
/***url**/
@property (copy, nonatomic) NSString *url;
/***url 类型**/
@property (assign, nonatomic) NSInteger url_type;//1.图片， 2.语音， 3.视频 ...
/***右上角数字**/
@property (assign, nonatomic) NSInteger badge;
/***声音**/
@property (copy, nonatomic) NSString *sound;
/***推送内容**/
@property (copy, nonatomic) NSString *content;
/***创建日期**/
@property (copy, nonatomic) NSString *create_date;
/***最后一次修改日期**/
@property (copy, nonatomic) NSString *last_edit_date;
/***是否已读**/
@property (assign, nonatomic) BOOL is_read;
/***媒体类型**/
@property (assign, nonatomic) NSInteger media_type; //1.纯文本， 2.带图片， 3.带语音， 4.带视频 ...
/***消息类型**/
@property (assign, nonatomic) NSInteger message_type; //

- (void)getModelFromDict:(NSDictionary *)dict;

@end

@interface STPushView : UIView

/** *推送数据模型 */
@property(nonatomic,strong) TT_Message *msgModel;

+(instancetype)shareInstance;
+ (void)show;
+ (void)hide;

@end
