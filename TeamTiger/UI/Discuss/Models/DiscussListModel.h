//
//  DiscussListModel.h
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussListModel : NSObject

//moment id
@property (nonatomic,copy) NSString *mid;
//头像url
@property (copy, nonatomic) NSString *head_img_url;
//姓名
@property (copy, nonatomic) NSString *name;
//moment创建时间
@property (copy, nonatomic) NSString *update_at;
//图片url
@property (copy, nonatomic) NSString *media;
//moment内容
@property (copy, nonatomic) NSString *content;
//未读消息个数
@property (nonatomic,copy) NSString *newscount;


@end
