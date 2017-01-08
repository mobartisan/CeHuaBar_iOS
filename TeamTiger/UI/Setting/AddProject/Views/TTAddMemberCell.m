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

@end

@implementation TTAddMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tintColor = kRGB(48, 215, 216);
    setViewCorner(self.headIcon, self.headIcon.bounds.size.width / 2);
    self.backgroundColor = kRGB(27, 41, 58);
    self.contentView.backgroundColor = kRGB(27, 41, 58);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setUser:(TT_User *)user {
    _user = user;
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:user.head_img_url] placeholderImage:kImage(@"common-headDefault")];
    self.nameLB.text = user.nick_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
