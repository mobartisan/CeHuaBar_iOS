//
//  CustomAlertView.m
//  Cattle
//
//  Created by 刘鵬 on 15/11/9.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property(nonatomic,strong) UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (nonatomic,copy) void(^completionHandler)(NSInteger);

@end

@implementation CustomAlertView



- (void)awakeFromNib {
    [super awakeFromNib];
    //self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    setViewCorner(self, 8);
    SetFrameByHeight(self.line1.frame, minLineWidth);
    SetFrameByWidth(self.line2.frame, minLineWidth);
}

-(void)showWithTitle:(NSString *)title Content:(NSString *)content btnLeft:(NSString *)btnLeftStr btnRight:(NSString *)btnRightStr CompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler {
    self.titleLab.text = title;
    self.contentLab.text = content;
    [self.btnLeft setTitle:btnLeftStr forState:UIControlStateNormal];
    [self.btnRight setTitle:btnRightStr forState:UIControlStateNormal];
    CGRect s = [self.contentLab.text boundingRectWithSize:CGSizeMake(self.contentLab.frame.Width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLab.font} context:nil];
    CGFloat height = MIN(s.size.height, 240.0);
    CGFloat extraHeight = height - 45.0;
    SetFrameByHeight(self.contentLab.frame, height);
    SetFrameByHeight(self.frame, 150.0 + extraHeight);
    SetFrameByYPos(self.line1.frame, 110.0 + extraHeight);
    SetFrameByYPos(self.line2.frame, 110.0 + extraHeight);
    SetFrameByYPos(self.btnLeft.frame, 110.0 + extraHeight);
    SetFrameByYPos(self.btnRight.frame, 110.0 + extraHeight);
    if (completionHandler != nil) {
        self.completionHandler = completionHandler;
    }
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.0;
    [SingletonApplication.keyWindow addSubview:self.bgView];
    [SingletonApplication.keyWindow addSubview:self];
    self.center = self.bgView.center;
    self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 0.4;
    }];
}

- (void)hide {
    [self removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (IBAction)returnAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (self.completionHandler) {
        self.completionHandler(btn.tag);
    }
    [self hide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
