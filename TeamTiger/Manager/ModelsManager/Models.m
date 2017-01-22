// =======================================================
// This file is auto generated by [Convert Excel To .plist and .sqlite] convertor,
// do not edit by youself!
// >>>> by HuMinghua <<<<  2016年8月15日 10:37:28
// ======================================================


#import "Models.h"

#pragma mark - 
@implementation TT_Group

@synthesize group_id = _group_id;
@synthesize group_name = _group_name;
@synthesize pids = _pids;
@synthesize description = _description;
@synthesize current_state = _current_state;
@synthesize is_allow_delete = _is_allow_delete;
@synthesize create_date = _create_date;
@synthesize create_user_id = _create_user_id;
@synthesize last_edit_date = _last_edit_date;
@synthesize last_edit_user_id = _last_edit_user_id;

- (NSString *)description
{
    NSLog(@"group_id:%@", _group_id);
    NSLog(@"name:%@", _group_name);
    NSLog(@"pids:%@", _pids);
    NSLog(@"description:%@", _description);
    NSLog(@"current_state:%@", @(_current_state));
    NSLog(@"is_allow_delete:%@", @(_is_allow_delete));
    NSLog(@"create_date:%@", _create_date);
    NSLog(@"create_user_id:%@", _create_user_id);
    NSLog(@"last_edit_date:%@", _last_edit_date);
    NSLog(@"last_edit_user_id:%@", _last_edit_user_id);
    
    return [super description];
}

+ (TT_Group *)creatGroupWithDictionary:(NSDictionary *)dic {
    TT_Group *group = [[TT_Group alloc] init];
    group.group_name = dic[@"Name"];
    group.pids = dic[@"Pids"];
    group.group_id = dic[@"Gid"];
    group.description = @"";
    group.current_state = 0;
    group.is_allow_delete = 1;
    group.create_date = [NSDate date];
    group.create_user_id = [TT_User sharedInstance].user_id;
    group.last_edit_date = [NSDate date];
    group.last_edit_user_id = [TT_User sharedInstance].user_id;
    return group;
}

@end


@implementation TT_Project

@synthesize project_id = _project_id;
@synthesize name = _name;
@synthesize isTop = _isTop;
@synthesize isNoDisturb = _isNoDisturb;
@synthesize newscount = _newscount;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"_id"]) {
        self.project_id = value;
    } else if ([key isEqualToString:@"name"]) {
        self.name = value;
    } else if ([key isEqualToString:@"position"]) {
        if ([value intValue] == 1) {
            self.isTop = NO;
        } else {
            self.isTop = YES;
        }
    } else if ([key isEqualToString:@"isDisturb"]) {
        self.isNoDisturb = [value boolValue];
    } else if ([key isEqualToString:@"banner"]) {
        self.logoURL = value[@"url"];
    }
}


@end


#pragma mark -
@implementation TT_Project_Members

@synthesize project_id = _project_id;
@synthesize user_id = _user_id;
@synthesize user_name = _user_name;
@synthesize user_img_url = _user_img_url;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"nick_name"]) {
        self.user_name = value;//@"nick_name"
    } else if ([key isEqualToString:@"_id"]) {
        self.user_id = value;//@"_id"
    } else if ([key isEqualToString:@"head_img_url"] ) {
        if (![Common isEmptyString:value]) {
            self.user_img_url = value;//@"head_img_url"
        }
    }
}

- (NSString *)description
{
    NSLog(@"project_id:%@", _project_id);
    NSLog(@"user_id:%@", _user_id);
    NSLog(@"user_name:%@", _user_name);
    NSLog(@"user_img_url:%@", _user_img_url);

    return [super description];
}
@end


#pragma mark - 
@implementation TT_Discuss

@synthesize discuss_id = _discuss_id;
@synthesize project_id = _project_id;
@synthesize discuss_type = _discuss_type;
@synthesize head_image_url = _head_image_url;
@synthesize user_name = _user_name;
@synthesize discuss_label = _discuss_label;
@synthesize content = _content;
@synthesize current_state = _current_state;
@synthesize is_allow_comment = _is_allow_comment;
@synthesize is_allow_delete = _is_allow_delete;
@synthesize create_date = _create_date;
@synthesize create_user_id = _create_user_id;
@synthesize last_edit_date = _last_edit_date;
@synthesize last_edit_user_id = _last_edit_user_id;
@synthesize is_has_image = _is_has_image;
@synthesize is_has_result = _is_has_result;
@synthesize comment_count = _comment_count;

- (NSString *)description
{
    NSLog(@"discuss_id:%@", _discuss_id);
    NSLog(@"project_id:%@", _project_id);
    NSLog(@"discuss_type:%@", @(_discuss_type));
    NSLog(@"head_image_url:%@", _head_image_url);
    NSLog(@"user_name:%@", _user_name);
    NSLog(@"discuss_label:%@", _discuss_label);
    NSLog(@"content:%@", _content);
    NSLog(@"current_state:%@", @(_current_state));
    NSLog(@"is_allow_comment:%@", @(_is_allow_comment));
    NSLog(@"is_allow_delete:%@", @(_is_allow_delete));
    NSLog(@"create_date:%@", _create_date);
    NSLog(@"create_user_id:%@", _create_user_id);
    NSLog(@"last_edit_date:%@", _last_edit_date);
    NSLog(@"last_edit_user_id:%@", _last_edit_user_id);
    NSLog(@"is_has_image:%@", @(_is_has_image));
    NSLog(@"is_has_result:%@", @(_is_has_result));
    NSLog(@"comment_count:%@", @(_comment_count));

    return [super description];
}
@end

#pragma mark - 
@implementation TT_Discuss_Result

@synthesize discuss_result_id = _discuss_result_id;
@synthesize discuss_id = _discuss_id;
@synthesize discuss_result = _discuss_result;
@synthesize discuss_result_description = _discuss_result_description;

- (NSString *)description
{
    NSLog(@"discuss_result_id:%@", _discuss_result_id);
    NSLog(@"discuss_id:%@", _discuss_id);
    NSLog(@"discuss_result:%@", _discuss_result);
    NSLog(@"discuss_result_description:%@", _discuss_result_description);

    return [super description];
}
@end


#pragma mark -
@implementation TT_Comment

@synthesize comment_id = _comment_id;
@synthesize discuss_id = _discuss_id;
@synthesize content = _content;
@synthesize name = _name;
@synthesize at_name = _at_name;
@synthesize is_allow_delete = _is_allow_delete;
@synthesize create_date = _create_date;
@synthesize create_user_id = _create_user_id;
@synthesize last_edit_date = _last_edit_date;
@synthesize last_edit_user_id = _last_edit_user_id;
@synthesize is_has_image = _is_has_image;

- (NSString *)description
{
    NSLog(@"comment_id:%@", _comment_id);
    NSLog(@"discuss_id:%@", _discuss_id);
    NSLog(@"content:%@", _content);
    NSLog(@"name:%@", _name);
    NSLog(@"at_name:%@", _at_name);
    NSLog(@"is_allow_delete:%@", @(_is_allow_delete));
    NSLog(@"create_date:%@", _create_date);
    NSLog(@"create_user_id:%@", _create_user_id);
    NSLog(@"last_edit_date:%@", _last_edit_date);
    NSLog(@"last_edit_user_id:%@", _last_edit_user_id);
    NSLog(@"is_has_image:%@", @(_is_has_image));

    return [super description];
}
@end

#pragma mark - 
@implementation TT_User

@synthesize user_id = _user_id;
@synthesize password = _password;
@synthesize name = _name;
@synthesize nick_name = _nick_name;
@synthesize remark = _remark;
@synthesize wx_account = _wx_account;
@synthesize phone = _phone;
@synthesize head_img_url = _head_img_url;
@synthesize os_type = _os_type;
@synthesize os_description = _os_description;
@synthesize device_identify = _device_identify;
@synthesize create_date = _create_date;
@synthesize create_user_id = _create_user_id;
@synthesize last_edit_date = _last_edit_date;
@synthesize last_edit_user_id = _last_edit_user_id;

- (NSString *)description
{
    NSLog(@"user_id:%@", _user_id);
    NSLog(@"password:%@", _password);
    NSLog(@"name:%@", _name);
    NSLog(@"nick_name:%@", _nick_name);
    NSLog(@"wx_account:%@", _wx_account);
    NSLog(@"phone:%@", _phone);
    NSLog(@"head_img_url:%@", _head_img_url);
    NSLog(@"os_type:%@", _os_type);
    NSLog(@"os_description:%@", _os_description);
    NSLog(@"device_identify:%@", _device_identify);
    NSLog(@"create_date:%@", _create_date);
    NSLog(@"create_user_id:%@", _create_user_id);
    NSLog(@"last_edit_date:%@", _last_edit_date);
    NSLog(@"last_edit_user_id:%@", _last_edit_user_id);

    return [NSString stringWithFormat:@"{nick_name:%@, nick_name:%@, user_id:%@}", _nick_name, _head_img_url, _user_id];
}

static TT_User *singleton = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}

- (BOOL)createUser:(NSDictionary *)userDic {
    if (userDic) {
        self.city = userDic[@"city"];
        self.country = userDic[@"country"];
        self.headimgurl = userDic[@"head_img_url"];
        self.language = userDic[@"language"];
        self.nickname = userDic[@"nick_name"];
        self.remark = userDic[@"remark"];
        self.user_id = userDic[@"uid"];
        
#warning to do ...
        self.openid = userDic[@"phone"];//phone
        self.privilege = userDic[@"head_img_from"];
        self.province = userDic[@"username"];//username
        self.sex = userDic[@"_id"];//1 男  0 女
        self.unionid = userDic[@"email"];//email
        return YES;
    }
    return NO;
}


- (NSComparisonResult)compareByName:(TT_User *)user {
    NSString *_tempNickName = [_nick_name pinyin];
    NSString *tempNickName = [user.nick_name pinyin];
    return [_tempNickName compare:tempNickName];
}

@end

#pragma mark - 
@implementation TT_Notification

@synthesize notifiction_id = _notifiction_id;
@synthesize is_read = _is_read;
@synthesize content = _content;
@synthesize type = _type;
@synthesize is_removed = _is_removed;
@synthesize create_date = _create_date;
@synthesize create_user_id = _create_user_id;
@synthesize last_edit_date = _last_edit_date;
@synthesize last_edit_user_id = _last_edit_user_id;

- (NSString *)description
{
    NSLog(@"notifiction_id:%@", _notifiction_id);
    NSLog(@"is_read:%@", @(_is_read));
    NSLog(@"content:%@", _content);
    NSLog(@"type:%@", @(_type));
    NSLog(@"is_removed:%@", @(_is_removed));
    NSLog(@"create_date:%@", _create_date);
    NSLog(@"create_user_id:%@", _create_user_id);
    NSLog(@"last_edit_date:%@", _last_edit_date);
    NSLog(@"last_edit_user_id:%@", _last_edit_user_id);

    return [super description];
}
@end

#pragma mark - 
@implementation TT_Attachment

@synthesize attachment_id = _attachment_id;
@synthesize current_item_id = _current_item_id;
@synthesize attachment_url = _attachment_url;
@synthesize attachment_content = _attachment_content;

- (NSString *)description
{
    NSLog(@"attachment_id:%@", _attachment_id);
    NSLog(@"current_item_id:%@", _current_item_id);
    NSLog(@"attachment_url:%@", _attachment_url);
    NSLog(@"attachment_content:%@", _attachment_content);

    return [super description];
}
@end

#pragma mark - 
@implementation TT_At_Members

@synthesize at_members_id = _at_members_id;
@synthesize current_item_id = _current_item_id;
@synthesize user_id = _user_id;

- (NSString *)description
{
    NSLog(@"at_members_id:%@", _at_members_id);
    NSLog(@"current_item_id:%@", _current_item_id);
    NSLog(@"user_id:%@", _user_id);

    return [super description];
}
@end
