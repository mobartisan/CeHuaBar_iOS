//
//  STPushView.m
//  TeamTiger
//
//  Created by xxcao on 2017/2/7.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//


#import "STPushView.h"
#import "AppDelegate.h"

@implementation STPushModel

/**
 * 保存对象到文件中
 *
 * @param aCoder <#aCoder description#>
 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.recordId forKey:@"recordId"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.urlType forKey:@"urlType"];
    [aCoder encodeObject:self.mid forKey:@"mid"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.subTitle forKey:@"subTitle"];
    [aCoder encodeObject:self.badge forKey:@"badge"];
    [aCoder encodeObject:self.sound forKey:@"sound"];
}


/**
 * 从文件中读取对象
 *
 * @param aDecoder <#aDecoder description#>
 *
 * @return <#return value description#>
 */
-(id)initWithCoder:(NSCoder *)aDecoder
{
    //注意：在构造方法中需要先初始化父类的方法
    if (self=[super init]) {
        self.recordId=[aDecoder decodeObjectForKey:@"recordId"];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.url=[aDecoder decodeObjectForKey:@"url"];
        self.urlType=[aDecoder decodeObjectForKey:@"urlType"];
        self.mid=[aDecoder decodeObjectForKey:@"mid"];
        self.content= [aDecoder decodeObjectForKey:@"content"];
        self.subTitle= [aDecoder decodeObjectForKey:@"subTitle"];
        self.badge= [aDecoder decodeObjectForKey:@"badge"];
        self.sound= [aDecoder decodeObjectForKey:@"sound"];
    }
    return self;
}

- (void)getModelFromDict:(NSDictionary *)dict {
    if (!dict) {
        return;
    }
    self.recordId = dict[@"recordId"];
    self.title = dict[@"title"];
    self.url = dict[@"url"];
    self.urlType = dict[@"urlType"];
    self.mid = dict[@"mid"];
    self.content = dict[@"content"];
    self.subTitle = dict[@"subTitle"];
    self.badge = dict[@"badge"];
    self.sound = dict[@"sound"];
}

@end

@interface STPushView()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic,weak ) UILabel *timLabel;
@property (nonatomic,weak ) UILabel *content;

@end

@implementation STPushView

static STPushView *_instance = nil;

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[STPushView alloc] init];
    });
    return _instance;
}

+(instancetype) allocWithZone:(struct _NSZone *)zone
{
    if (!_instance) {
        _instance = [super allocWithZone:zone];
    }
    return _instance ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ColorRGB(15, 14, 12);
        CGFloat margin = 12;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.userInteractionEnabled = NO;
        imageV.image = [UIImage imageNamed:@"logo"];
        imageV.layer.cornerRadius = 5;
        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];
        self.imageV = imageV;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(margin);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        titleLabel.text = @"客户，您好！";
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageV.mas_right).offset(margin);
            make.top.equalTo(self.mas_top).offset(margin);
            make.height.mas_equalTo(16);
        }];
        [titleLabel sizeToFit];
        
        UILabel *timLabel = [[UILabel alloc] init];
        timLabel.font = [UIFont systemFontOfSize:12];
        timLabel.userInteractionEnabled = NO;
        timLabel.textColor = [UIColor whiteColor];
        timLabel.text = @"刚刚";
        timLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:timLabel];
        self.timLabel = timLabel;
        [timLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(margin);
            make.top.equalTo(self.mas_top).offset(margin);
            make.width.mas_lessThanOrEqualTo(40);
            make.height.mas_equalTo(16);
        }];
        
        
        UILabel *content = [[UILabel alloc] init];
        content.numberOfLines = 2;
        content.font = [UIFont systemFontOfSize:13];
        content.textColor = [UIColor whiteColor];
        content.userInteractionEnabled = NO;
        [self addSubview:content];
        self.content = content;
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageV.mas_right).offset(margin);
            make.top.equalTo(titleLabel.mas_bottom).offset(-3);
            make.right.equalTo(self.mas_right).offset(-margin);
            make.height.mas_equalTo(35);
        }];
        
        
        UIView *toolbar = [[UIView alloc] init];
        toolbar.backgroundColor = ColorRGB(121, 101, 81);
        toolbar.layer.cornerRadius = 3;
        [self addSubview:toolbar];
        [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(6);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
        }];
        
    }
    return self;
}

- (void)setModel:(STPushModel *)model
{
    _model = model;
    self.timLabel.text = @"刚刚";
    self.content.text = model.content;
}

+ (void)show
{
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    STPushView *pushView = [STPushView shareInstance];
    pushView.hidden = NO;
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window bringSubviewToFront:pushView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        pushView.frame = CGRectMake(0, 0, Screen_Width, pushViewHeight);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                
                pushView.frame = CGRectMake(0, -pushViewHeight, Screen_Width, pushViewHeight);
                
                
            } completion:^(BOOL finished) {
                
                [UIApplication sharedApplication].statusBarHidden = NO;
                pushView.hidden = YES;
                
            }];
            
        });
        
    }];
}

+ (void)hide
{
    STPushView *pushView = [STPushView shareInstance];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        pushView.frame = CGRectMake(0, -pushViewHeight, Screen_Width, pushViewHeight);
        
    } completion:^(BOOL finished) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        pushView.hidden = YES;
    }];
}

@end
