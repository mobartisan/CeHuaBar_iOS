//
//  DiscussListCell.m
//  TeamTiger
//
//  Created by Dale on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DiscussListCell.h"
#import "DiscussListModel.h"

@interface DiscussListCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation DiscussListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withModel:(DiscussListModel *)model {
    static NSString *cellID = @"DiscussListCell";
    DiscussListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (![Common isEmptyString:model.head_img_url]) {
            cell = LoadFromNib(@"DiscussListCell");
        } else {
            cell = LoadFromNib(@"DiscussListCell1");
        }
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithModel:(DiscussListModel *)model withHideLineView:(BOOL)hiden {
    self.iconImage.image = kImage(model.head_img_url);
    self.nameLB.text = model.name;
    self.desLB.text = model.content;
    self.timeLB.text = model.update_date;
    self.image.image = kImage(model.img_url);
    self.lineView.hidden = hiden;
}

@end
