//
//  TTAddMemberCell.m
//  TeamTiger
//
//  Created by Dale on 17/1/5.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTAddMemberCell.h"

@interface TTAddMemberCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *msgLB;

@end

@implementation TTAddMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    setViewCorner(self.headIcon, self.headIcon.bounds.size.width / 2);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
}


- (void)setUser:(TT_User *)user {
    _user = user;
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:user.head_img_url] placeholderImage:kImage(@"common-headDefault") options:SDWebImageRetryFailed | SDWebImageLowPriority];
    self.nameLB.text = user.nick_name;
    self.msgLB.text = user.nick_name;
}
- (IBAction)handleSelectBtn {
    if (self.selectBtnBlock) {
        self.selectBtnBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
