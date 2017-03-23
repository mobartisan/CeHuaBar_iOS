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
    setViewCorner(self.iconImage, 25);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithModel:(DiscussListModel *)model withHideLineView:(BOOL)hiden {
    //handle image
    NSString *headUrl = [Common handleWeChatHeadImageUrl:model.head_img_url Size:96];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:kImage(@"img_user")];
    self.nameLB.text = model.name;
    self.desLB.text = model.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(model.update_at.longLongValue / 1000.0)];
    self.timeLB.text = [NSDate hyb_timeInfoWithDate:date];
    //handle image
    if (![Common isEmptyString:model.media]) {
        self.image.hidden = NO;
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",model.media,kCompressKey];
        [self.image sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                      placeholderImage:kImage(@"defaultBG")
                               options:SDWebImageRetryFailed | SDWebImageLowPriority];
    } else {
        self.image.hidden = YES;
    }
    self.lineView.hidden = hiden;
}

@end
