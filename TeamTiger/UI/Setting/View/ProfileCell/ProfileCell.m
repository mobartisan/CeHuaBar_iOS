//
//  ProfileCell.m
//  TeamTiger
//
//  Created by xxcao on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+YYAdd.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    setViewCorner(self.exitBtn, 5);
    
    if (self.headImgV) {
        self.headImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderAction:)];
        [self.headImgV addGestureRecognizer:tapGR];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (instancetype)loadCellWithType:(int)type {
    ProfileCell *cell = nil;
    switch (type) {
        case 0:
            cell = LoadFromNib(@"ProfileCell_Header");
            break;
        case 1:
            cell = LoadFromNib(@"ProfileCell");
            break;
        default:
            cell = LoadFromNib(@"ProfileCell_Footer");
            break;
    }
    return cell;
}

+ (CGFloat)loadCellHeightWithType:(int)type {
    return 76.0;
}

- (void)reloadCellData:(id)obj{
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
    self.bgImgV.backgroundColor = dic[@"Color"];
    self.nameLab.text = dic[@"Name"];
    self.detailTxtField.text = dic[@"Description"];

    if ([dic[@"ShowAccessory"] intValue]) {
        self.accessoryImgV.hidden = NO;
    } else {
        self.accessoryImgV.hidden = YES;
    }

    if ([dic[@"IsEdit"] intValue]) {
        self.detailTxtField.userInteractionEnabled = YES;
    } else {
        self.detailTxtField.userInteractionEnabled = NO;
    }
    
    if (![Common isEmptyString:dic[@"HeadImage"]]) {
        NSString *usrString = dic[@"HeadImage"];
        NSArray *components = [usrString componentsSeparatedByString:@"/"];
        NSMutableString *mString = [NSMutableString string];
        NSInteger count = components.count;
        [components enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != count - 1) {
                [mString appendFormat:@"%@/",obj];
            } else {
                [mString appendString:@"64"];//头像大小 46 64 96 132
            }
        }];
        NSURL *url = [NSURL URLWithString:mString];
        [self.headImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"common-headDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            image = [image imageByResizeToSize:Size(60, 60)];
            image = [image imageByRoundCornerRadius:30];
            self.headImgV.image = image;
        }];
    }    
    
    if ([dic[@"Type"] intValue] == 1) {
        if (self.accessoryImgV.hidden) {
            self.dWeight.constant = -20;
        }
    }
}

- (void)clickHeaderAction:(id)sender {
    if (self.block) {
        self.block(self,1);
    }
}

- (IBAction)clickExitBtnAction:(id)sender {
    if (self.block) {
        self.block(self,2);
    }
}

@end
