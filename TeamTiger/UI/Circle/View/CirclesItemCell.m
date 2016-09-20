//
//  CirclesItemCell.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CirclesItemCell.h"
#import "CirclesItemModel.h"

@implementation CirclesItemCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CirclesItemCell";
    CirclesItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pointImgV.layer.cornerRadius =self.pointImgV.hyb_width * 0.5;
    
    // 设置普通背景
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = kColorForBackgroud;
    self.backgroundView = bg;
    
    // 设置选中时的背景
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor =kColorForCommonCellSelectedBackgroud;
    self.selectedBackgroundView = selectedBg;
}

- (void)setLastRowInSection:(BOOL)lastRowInSection
{
    _lastRowInSection = lastRowInSection;
    
    self.divider.hidden = lastRowInSection;
}

-(void)setData:(id)item{
    CirclesItemModel *model = (CirclesItemModel *)item;
    self.titleLab.text = model.title;
    self.pointImgV.backgroundColor = [Common colorFromHexRGB:model.pointColor];
}
@end
