//
//  CirclesManager.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CirclesManager.h"
#import "MBProgressHUD.h"

@implementation CirclesManager

+ (CirclesManager *)sharedInstance {
    
    static CirclesManager *circlesManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        circlesManager = [[self alloc] init];
    });
    return circlesManager;
}


#pragma mark  获取所有的项目
- (void)loadingGlobalCirclesInfo {
    if (![Common isEmptyArr:self.circles]) {
        [self.circles removeAllObjects];
    }
    AllProjectsApi *allProject = [[AllProjectsApi alloc] init];
    [allProject startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"AllProjectsApi:%@", request.responseJSONObject);
        ;
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            if (![Common isEmptyArr:request.responseJSONObject[OBJ]]) {
                for (NSDictionary *objDic in request.responseJSONObject[OBJ]) {
                    [self.circles addObject:objDic];
                }
                self.selectCircle = (self.circles)[self.selectIndex];
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.label.text = [NSString stringWithFormat:@"%@", request.responseJSONObject[MSG]];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.label.text = @"您的网络好像有问题~";
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (self.circles.count > selectIndex ) {
        _selectIndex = selectIndex;
        self.selectCircle = self.circles[selectIndex];
    } else
    {
        NSAssert(NO, @"set SelectIndex error.");
    }
}

- (NSMutableArray *)circles {
    if (!_circles) {
        _circles = [NSMutableArray array];
    }
    return _circles;
}

- (NSMutableArray *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

@end
