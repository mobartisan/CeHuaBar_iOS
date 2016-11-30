//
//  NotificationCell.m
//  TeamTiger
//
//  Created by xxcao on 16/8/17.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:22.0 / 255.0 green:30.0 / 255.0 blue:44.0 / 255.0 alpha:1.0];
    }
    return self;
}

- (void)reloadCellData:(id)obj {
    self.nameLab.text = obj[@"Name"];
    
    
    if ([obj[@"Type"] intValue] == 0) {
        self.contentLab.text = obj[@"Content"];
    } else if ([obj[@"Type"] intValue] == 1) {
        if ([obj[@"Content"] intValue] == 1) {
            self.tSwitch.on = YES;
        } else {
            self.tSwitch.on = NO;
        }
    }
}


- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(Screen_Width / 2.0);
        }];
    }
    return _nameLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor lightGrayColor];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(100.0);
        }];
    }
    return _contentLab;
}

- (TTFadeSwitch *)tSwitch {
    if (!_tSwitch) {
        _tSwitch = [[TTFadeSwitch alloc] init];
        _tSwitch.thumbImage = [UIImage imageNamed:@"toggle_handle_on"];
        _tSwitch.thumbOffImage = [UIImage imageNamed:@"toggle_handle_off"];
        _tSwitch.thumbHighlightImage = [UIImage imageNamed:@"toggle_handle_on"];
        _tSwitch.trackMaskImage = [UIImage imageNamed:@"toggle_background_off"];
        _tSwitch.trackImageOn = [UIImage imageNamed:@"toggle_background_on"];
        _tSwitch.trackImageOff = [UIImage imageNamed:@"toggle_background_off"];
        _tSwitch.thumbInsetX = -3.0;
        _tSwitch.thumbOffsetY = 0.0;
        [self.contentView addSubview:_tSwitch];
        [_tSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.width.equalTo(@51.5);
            make.height.equalTo(@31);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        _tSwitch.changeHandler = ^(BOOL on){
            if ((self.tag - 2016) / 1000 == 2 &&
                (self.tag - 2016) % 1000 == 0) {
                NSNumber *switchValue = on ? @1 : @0;
                UserDefaultsSave(switchValue, @"USER_KEY_PLAY_AUDIO");
            }
            if ((self.tag - 2016) / 1000 == 2 &&
                (self.tag - 2016) % 1000 == 1) {
                NSNumber *switchValue = on ? @1 : @0;
                UserDefaultsSave(switchValue, @"USER_KEY_PLAY_SHAKE");
            }
            NSLog(@"%d",on);
        };
    }
    return _tSwitch;
}

@end
