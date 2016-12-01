// =======================================================
// This file is auto generated by [Convert Excel To .plist and .sqlite] convertor,
// do not edit by youself!
// >>>> by HuMinghua <<<<  2016年8月15日 10:37:28
// ======================================================


#import <Foundation/Foundation.h>

#pragma mark - 
@interface TT_Group : NSObject
@property(nonatomic, strong) NSString *group_id;  // group_id
@property(nonatomic, strong) NSString *name;  // name
@property(nonatomic, strong) NSString *pids;  //pids
@property(nonatomic, strong) NSString *description;  // description
@property(nonatomic)         NSInteger current_state;  // current_state
@property(nonatomic)         BOOL is_allow_delete;  // is_allow_delete
@property(nonatomic, strong) NSDate *create_date;  // create_date
@property(nonatomic, strong) NSString *create_user_id;  // create_user_id
@property(nonatomic, strong) NSDate *last_edit_date;  // last_edit_date
@property(nonatomic, strong) NSString *last_edit_user_id;  // last_edit_user_id
@end

@interface TT_Project : NSObject
@property(nonatomic, strong) NSString *project_id;  // project_id
@property(nonatomic, strong) NSString *name;  // name
@property(nonatomic, strong) NSString *description;  // description
@property(nonatomic)         BOOL is_private;  // is_private
@property(nonatomic)         NSInteger current_state;  // current_state
@property(nonatomic)         BOOL is_allow_delete;  // is_allow_delete
@property(nonatomic, strong) NSDate *create_date;  // create_date
@property(nonatomic, strong) NSString *create_user_id;  // create_user_id
@property(nonatomic, strong) NSDate *last_edit_date;  // last_edit_date
@property(nonatomic, strong) NSString *last_edit_user_id;  // last_edit_user_id
@property(nonatomic)         BOOL is_grouped;  // is_grouped

@end



#pragma mark -
@interface TT_Project_Members : NSObject
@property(nonatomic, strong) NSString *project_id;  // project_id
@property(nonatomic, strong) NSString *user_id;  // user_id
@property(nonatomic, strong) NSString *user_name;  // user_name
@property(nonatomic, strong) NSString *user_img_url;  // user_img_url

@end


#pragma mark - 
@interface TT_Discuss : NSObject
@property(nonatomic, strong) NSString *discuss_id;  // discuss_id
@property(nonatomic, strong) NSString *project_id;  // project_id
@property(nonatomic)         NSInteger discuss_type;  // discuss_type
@property(nonatomic, strong) NSString *head_image_url;  // head_image_url
@property(nonatomic, strong) NSString *user_name;  // user_name
@property(nonatomic, strong) NSString *discuss_label;  // discuss_label
@property(nonatomic, strong) NSString *content;  // content
@property(nonatomic)         NSInteger current_state;  // current_state
@property(nonatomic)         BOOL is_allow_comment;  // is_allow_comment
@property(nonatomic)         BOOL is_allow_delete;  // is_allow_delete
@property(nonatomic)         BOOL is_has_image;  // is_has_image
@property(nonatomic)         BOOL is_has_result;  // is_has_result
@property(nonatomic)         NSInteger comment_count;  // comment_count
@property(nonatomic, strong) NSDate *create_date;  // create_date
@property(nonatomic, strong) NSString *create_user_id;  // create_user_id
@property(nonatomic, strong) NSDate *last_edit_date;  // last_edit_date
@property(nonatomic, strong) NSString *last_edit_user_id;  // last_edit_user_id
@end


#pragma mark - 
@interface TT_Discuss_Result : NSObject
@property(nonatomic, strong) NSString *discuss_result_id;  // discuss_result_id
@property(nonatomic, strong) NSString *discuss_id;  // discuss_id
@property(nonatomic, strong) NSString *discuss_result;  // discuss_result
@property(nonatomic, strong) NSString *discuss_result_description;  // discuss_result_description
@end




#pragma mark -
@interface TT_Comment : NSObject
@property(nonatomic, strong) NSString *comment_id;  // comment_id
@property(nonatomic, strong) NSString *discuss_id;  // discuss_id
@property(nonatomic, strong) NSString *content;  // content
@property(nonatomic, strong) NSString *name;  // name
@property(nonatomic, strong) NSString *at_name;  // at_name
@property(nonatomic)         BOOL is_allow_delete;  // is_allow_delete
@property(nonatomic, strong) NSDate *create_date;  // create_date
@property(nonatomic, strong) NSString *create_user_id;  // create_user_id
@property(nonatomic, strong) NSDate *last_edit_date;  // last_edit_date
@property(nonatomic, strong) NSString *last_edit_user_id;  // last_edit_user_id
@property(nonatomic)         BOOL is_has_image;  // is_has_image

@end


#pragma mark - 
@interface TT_User : NSObject
@property(nonatomic, strong) NSString *user_id;  // user_id
@property(nonatomic, strong) NSString *password;  // password
@property(nonatomic, strong) NSString *name;  // name
@property(nonatomic, strong) NSString *nick_name;  // nick_name
@property(nonatomic, strong) NSString *wx_account;  // wx_account
@property(nonatomic, strong) NSString *phone;  // phone
@property(nonatomic, strong) NSString *head_img_url;  // head_img_url
@property(nonatomic, strong) NSString *os_type;  // os_type
@property(nonatomic, strong) NSString *os_description;  // os_description
@property(nonatomic, strong) NSString *device_identify;  // device_identify
@property(nonatomic, strong) NSDate *create_date;  // create_date
@property(nonatomic, strong) NSString *create_user_id;  // create_user_id
@property(nonatomic, strong) NSDate *last_edit_date;  // last_edit_date
@property(nonatomic, strong) NSString *last_edit_user_id;  // last_edit_user_id
//for wechat
@property(nonatomic, strong) NSString *city;  // city
@property(nonatomic, strong) NSString *country;  // country
@property(nonatomic, strong) NSString *headimgurl;  // headimgurl
@property(nonatomic, strong) NSString *language;  // language
@property(nonatomic, strong) NSString *nickname;  // nickname
@property(nonatomic, strong) NSString *openid;  // openid
@property(nonatomic, strong) NSArray *privilege;  // privilege
@property(nonatomic, strong) NSString *province;  // province
@property(nonatomic, strong) NSString *sex;  // sex
@property(nonatomic, strong) NSString *unionid;  // unionid

+ (instancetype)sharedInstance;

- (BOOL)createUser:(NSDictionary *)userDic;

@end


#pragma mark - 
@interface TT_Notification : NSObject
@property(nonatomic, strong) NSString *notifiction_id;  // notifiction_id
@property(nonatomic)         BOOL is_read;  // is_read
@property(nonatomic, strong) NSString *content;  // content
@property(nonatomic)         NSInteger type;  // type
@property(nonatomic)         BOOL is_removed;  // is_removed
@property(nonatomic, strong) NSDate *create_date;  // create_date
@property(nonatomic, strong) NSString *create_user_id;  // create_user_id
@property(nonatomic, strong) NSDate *last_edit_date;  // last_edit_date
@property(nonatomic, strong) NSString *last_edit_user_id;  // last_edit_user_id
@end


#pragma mark - 
@interface TT_Attachment : NSObject
@property(nonatomic, strong) NSString *attachment_id;  // attachment_id
@property(nonatomic, strong) NSString *current_item_id;  // current_item_id
@property(nonatomic, strong) NSString *attachment_url;  // attachment_url
@property(nonatomic, strong) NSString *attachment_content;  // attachment_content
@end


#pragma mark - 
@interface TT_At_Members : NSObject
@property(nonatomic, strong) NSString *at_members_id;  // at_members_id
@property(nonatomic, strong) NSString *current_item_id;  // current_item_id
@property(nonatomic, strong) NSString *user_id;  // user_id
@end
