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
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:user.head_img_url] placeholderImage:kImage(@"common-headDefault")];
    self.nameLB.text = user.nick_name;
    
//    if (![Common isEmptyString:user.city] && ![Common isEmptyString:user.country]) {
//        long len1 = [user.city length];
//        long len2 = [user.country length];
//        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:user.nick_name];
//        [str2 addAttribute:NSForegroundColorAttributeName value:kRGB(60, 183, 186) range:NSMakeRange(len1,len2)];
//        
//    }
    self.msgLB.text = user.nick_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
