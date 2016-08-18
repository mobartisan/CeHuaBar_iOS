//
//  ContactTableViewCell.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactTableViewCell.h"
#import "ContactModel.h"
#import "UIButton+HYBHelperBlockKit.h"

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    
    self.contentView.backgroundColor = [UIColor colorWithRed:43.0/255.0 green:47.0/255.0 blue:61.0/255.0 alpha:1.0];
    //头像
    [self headImageView];
    //姓名
    [self.contentView addSubview:self.nameLabel];
    //邮箱
    [self.contentView addSubview:self.emailLabel];
    //添加按钮
    [self.contentView addSubview:self.operationBtn];
    
}

- (void)reloadCell:(id)obj IsLast:(BOOL)isLast {
    
    UIView *v = [self viewWithTag:2016];
    if (v && [v isKindOfClass:[UIImageView class]]) {
        [v removeFromSuperview];
    }
    if (!isLast) {
        UIImageView *line = [[UIImageView alloc] init];
        [self.contentView addSubview:line];
        line.backgroundColor = [UIColor whiteColor];
        line.alpha = 0.3;
        line.tag = 2016;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(69);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(minLineWidth);
        }];
    }
    
    ContactModel *model = (ContactModel *)obj;
    self.nameLabel.text = model.name;
    self.emailLabel.text = model.email;
    if (![Common isEmptyString:model.portrait]) {
        self.headImageView.image = [UIImage imageNamed:model.portrait];
    } else if (model.imageData){
        self.headImageView.image = [UIImage imageWithData:model.imageData];
    }
    
    if (!model.email || model.email.length == 0) {
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth - 100.0);
            make.left.equalTo(self.headImageView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    } else {
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth - 100.0);
            make.left.equalTo(self.headImageView.mas_right).offset(15);
            make.top.mas_equalTo(10.0);
        }];
    }
    
    if(model.isAdd.intValue == 0){
        [self.operationBtn setImage:[UIImage imageNamed:@"add_contactor_normal"] forState:UIControlStateNormal];
    } else {
        [self.operationBtn setImage:[UIImage imageNamed:@"add_contactor_selected"] forState:UIControlStateNormal];
    }
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        _headImageView.image = [UIImage imageNamed:@"common-headDefault"];
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0);
            make.top.mas_equalTo(10.0);
            make.width.mas_equalTo(40.0);
            make.height.mas_equalTo(40.0);
        }];
        setViewCorner(_headImageView,20);
    }
    return _headImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        _nameLabel.textColor = [UIColor colorWithRed:54.0 / 255.0 green:82.0 / 255.0 blue:134.0 / 255.0 alpha:1.0];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth - 100.0);
            make.left.equalTo(self.headImageView.mas_right).offset(15);
            make.top.mas_equalTo(10.0);
        }];
    }
    return _nameLabel;
}

- (UILabel *)emailLabel{
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc]init];
        [_emailLabel setFont:[UIFont systemFontOfSize:14.0]];
        _emailLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:129.0/255.0 alpha:1.0];
        _emailLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_emailLabel];
        [_emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth - 100.0);
            make.left.equalTo(self.headImageView.mas_right).offset(15);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        }];
    }
    return _emailLabel;
}

- (UIButton *)operationBtn{
    if (!_operationBtn) {
        _operationBtn = [UIButton hyb_buttonWithImage:nil selectedImage:nil superView:self.contentView constraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.contentView.mas_centerY);
        } touchUp:^(UIButton *sender) {
            NSLog(@"click me");
        }];
        _operationBtn.backgroundColor = [UIColor clearColor];
    }
    return _operationBtn;
}


@end
