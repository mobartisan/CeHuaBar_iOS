//
//  DeleteFooterView.h
//  TeamTiger
//
//  Created by xxcao on 2016/12/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeleteFooterView;

typedef void(^DeleteGroupBlock)(DeleteFooterView *view);

@interface DeleteFooterView : UIView

@property(nonatomic,weak)IBOutlet UIButton *deleteBtn;

@property(nonatomic,copy)DeleteGroupBlock deleteGroupBlock;

@end
