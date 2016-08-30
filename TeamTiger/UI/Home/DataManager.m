//
//  DataManager.m
//  TeamTiger
//
//  Created by Dale on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DataManager.h"
#import "NetworkManager.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"


@implementation DataManager

+ (DataManager *)mainSingleton {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
        //项目列表
        ProjectsApi *projectsApi = [[ProjectsApi alloc] init];
        [projectsApi startWithBlockProgress:^(NSProgress *progress) {
            
        } success:^(__kindof LCBaseRequest *request) {
            NSLog(@"%@", request.rawJSONObject);
        } failure:^(__kindof LCBaseRequest *request, NSError *error) {
            NSLog(@"%@", error);
        }];
    });
    return manager;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        for (NSDictionary *dic in self.dataArr) {
            HomeCellModel *model = [HomeCellModel modelWithDic:dic];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = @[
                     @{@"time":@"2016年7月19日 15:25",
                       @"headImage":@"touxiang",
                       @"name":@"唐小旭",
                       @"type":@"工作牛",
                       @"image1":@"placeImage",
                       @"image2":@"image",
                       @"image3":@"image",
                       @"projectType":@(ProjectTypeAll),
                       @"imageCount":@(3),
                       @"comment":@[
                               @{@"time":@"19:50",
                                 @"firstName":@"唐小旭",
                                 @"secondName":@"@卞克",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellImage)
                                 },
                               @{@"time":@"13:55",
                                 @"firstName":@"卞克",
                                 @"secondName":@"@唐小旭",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellTitleNoButton)
                                 },
                               @{@"time":@"9:00",
                                 @"firstName":@"齐云猛",
                                 @"secondName":@"",
                                 @"des":@"TypeSomething...",
                                 @"secondImage":@"image",
                                 @"firstImage":@"image",
                                 @"typeCell":@(TypeCellTitle)
                                 },
                               @{@"time":@"昨天",
                                 @"firstName":@"2016年7月18日",
                                 @"secondName":@"@唐小旭",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellTime)
                                 },
                               @{@"time":@"13:55",
                                 @"firstName":@"俞弦",
                                 @"secondName":@"",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellTitleNoButton),
                                 },
                               ].mutableCopy
                       },
                     @{@"time":@"2016年7月24日 15:25",
                       @"headImage":@"touxiang",
                       @"name":@"唐小旭",
                       @"type":@"工作牛",
                       @"image1":@"placeImage",
                       @"image2":@"image",
                       @"image3":@"image",
                       @"image3":@"image",
                       @"image4":@"image",
                       @"projectType":@(ProjectTypeAll),
                       @"imageCount":@(4),
                       @"comment":@[
                               @{@"time":@"19:50",
                                 @"firstName":@"唐小旭",
                                 @"secondName":@"@卞克",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellImage)
                                 },
                               @{@"time":@"9:00",
                                 @"firstName":@"齐云猛",
                                 @"secondName":@"",
                                 @"des":@"TypeSomething...",
                                 @"secondImage":@"image",
                                 @"firstImage":@"image",
                                 @"typeCell":@(TypeCellTitle)
                                 },
                               @{@"time":@"昨天",
                                 @"firstName":@"2016年7月18日",
                                 @"secondName":@"@唐小旭",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellTime)
                                 },
                               @{@"time":@"13:55",
                                 @"firstName":@"俞弦",
                                 @"secondName":@"",
                                 @"des":@"TypeSomething...",
                                 @"firstImage":@"image",
                                 @"secondImage":@"image",
                                 @"typeCell":@(TypeCellTitleNoButton),
                                 },
                               ].mutableCopy
                       },
                     @{@"time":@"2016年8月2日 15:25",
                       @"headImage":@"touxiang",
                       @"name":@"卞克",
                       @"type":@"BBS",
                       @"image1":@"image",
                       @"image2":@"image",
                       @"image3":@"image",
                       @"aDes":@"tape something",
                       @"bDes":@"tape something",
                       @"cDes":@"tape something",
                       @"aTicket":@"0.7",
                       @"bTicket":@"0.4",
                       @"cTicket":@"0.1",
                       @"projectType":@(ProjectTypeVote),
                       @"imageCount":@(3),
                       @"comment":@[
                               @{@"time":@"19:50",
                                 @"firstName":@"卞克",
                                 @"secondName":@"A",
                                 @"typeCell":@(TypeCellTitleNoButton)
                                 },
                               @{@"time":@"13:55",
                                 @"firstName":@"唐小旭",
                                 @"secondName":@"A",
                                 @"typeCell":@(TypeCellTitle)
                                 },
                               @{@"time":@"9:55",
                                 @"firstName":@"唐小旭",
                                 @"secondName":@"B",
                                 @"typeCell":@(TypeCellTime)
                                 }
                               ].mutableCopy
                       }
                     ].mutableCopy;
    }
    return _dataArr;
}



@end
