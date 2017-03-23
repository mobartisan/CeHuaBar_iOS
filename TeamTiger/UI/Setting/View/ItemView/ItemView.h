//
//  ItemView.h
//  TeamTiger
//
//  Created by xxcao on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemView;

typedef void(^ClickAddBlock)(ItemView *view);

@interface ItemView : UIView

@property(nonatomic,strong) UIImageView *headImgV;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,copy) ClickAddBlock didSelectBlock;

- (instancetype)initWithData:(id)object;

@end
