//
//  TTCommonCell.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonCell.h"
#import "TTCommonItem.h"
#import "TTCommonSwitchItem.h"
#import "TTCommonArrowItem.h"
#import "TTCommonLabelItem.h"
#import "TTCommonTextViewItem.h"
#import "TTCommonCustomViewItem.h"
#import "UITextView+PlaceHolder.h"

typedef enum : NSUInteger {
    TTCommonCellLabel = 0,
    TTCommonCellArrow,
    TTCommonCellSwitch,
    TTCommonCellTextView,
    TTCommonCellDefual,
    TTCommonCellCustomView,
} TTCommonCellType;

@interface TTCommonCell()<UITextViewDelegate>

/**
 *  textView
 */
@property (nonatomic, strong) UITextView *textView;
/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;
/**
 *  标签
 */
@property (nonatomic, strong) UILabel *labelView;

/**
 *  子标签
 */
@property (nonatomic, strong) UILabel *subLabelView;

@property (nonatomic, weak) UIView *divider;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign)TTCommonCellType cellType;
@end

@implementation TTCommonCell

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_enter"]];
    }
    return _arrowView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.tintColor = [UIColor whiteColor];
        _textView.maxLength = 120;//最大字数
    }
    return _textView;
    
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UILabel *)labelView
{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.font = [UIFont systemFontOfSize:17];
        _labelView.textColor = [UIColor whiteColor];
        //        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

- (UILabel *)subLabelView
{
    if (_subLabelView == nil) {
        _subLabelView = [[UILabel alloc] init];
        _subLabelView.font = [UIFont systemFontOfSize:17];
        _subLabelView.textColor = [Common colorFromHexRGB:@"dcdcdc"];
        _subLabelView.backgroundColor = [UIColor clearColor];
        _subLabelView.textAlignment = NSTextAlignmentRight;
    }
    return _subLabelView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        self.cellType = TTCommonCellLabel;
        [self.contentView addSubview:self.labelView];
        // 1.初始化背景
        [self setupBg];
        
        // 2.初始化子控件
        [self setupSubviews];
        
        [self setupDivider];
    }
    return self;
}

/**
 *  初始化子控件
 */
- (void)setupSubviews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

/**
 *  初始化背景
 */
- (void)setupBg
{
    // 设置普通背景
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = kColorForCommonCellBackgroud;
    self.backgroundView = bg;
    
    // 设置选中时的背景
    UIView *selectedBg = [[UIView alloc] init];
    selectedBg.backgroundColor =kColorForCommonCellSelectedBackgroud;
    self.selectedBackgroundView = selectedBg;
}

/**
 *  初始化分割线
 */
- (void)setupDivider
{
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor blackColor];
    divider.alpha = 0.2;
    [self.contentView addSubview:divider];
    self.divider = divider;
}

/**
 *  监听开关状态改变
 */
- (void)switchStateChange
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    if (self.item.key) {
    [defaults setBool:self.switchView.isOn forKey:self.item.title];
    [defaults synchronize];
    //    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.labelView];
    // 1.初始化背景
    [self setupBg];
    
    // 2.初始化子控件
    [self setupSubviews];
    
    [self setupDivider];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CommonCell";
    TTCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    cell = [[TTCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    if (cell == nil) {
        cell = [[TTCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView isReuse:(BOOL)isReuse {
    if (isReuse) {
        return [self cellWithTableView:tableView];
    } else {
        TTCommonCell *cell = [[TTCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
}


- (void)dealloc {
    //    self.textView.delegate = nil;
}
/**
 *  拦截frame的设置
 */
//- (void)setFrame:(CGRect)frame
//{
//    if (!iOS7) {
//        CGFloat padding = 10;
//        frame.size.width += padding * 2;
//        frame.origin.x = -padding;
//    }
//    [super setFrame:frame];
//}

- (void)customLayoutSubviews {
    if (self.cellType == TTCommonCellCustomView) {
        //        CGFloat customViewH = self.customView.hyb_height;
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            //            make.left.equalTo(self.contentView);
            //            make.right.equalTo(self.contentView);
            //            make.top.equalTo(self.contentView);
            //            make.bottom.equalTo(self.contentView).offset(-kDistanceToVSide);
        }];
        return;
    }
    
    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kDistanceToHSide);
        make.height.mas_equalTo(kLabelHeight);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    if (self.cellType == TTCommonCellTextView) {
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(kDistanceToHSide*3.5);
            make.right.equalTo(self.contentView.mas_right).offset(-kDistanceToHSide);
            make.top.equalTo(self.contentView.mas_top).offset(kDistanceToVSide);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kDistanceToVSide);
        }];
    }
    
    if (self.cellType == TTCommonCellArrow) {
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(12);
            //            make.top.equalTo(self.contentView.mas_top).offset(33);
            //            make.bottom.equalTo(self.contentView.mas_bottom).offset(-33);
            make.right.equalTo(self.contentView.mas_right).offset(-kDistanceToHSide);
        }];
    }
    
    if (self.subLabelView.superview) {
        [self.subLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.mas_greaterThanOrEqualTo(40);
            make.right.equalTo(self.contentView.mas_right).offset(-kDistanceToHSide*2);
            make.height.mas_equalTo(kLabelHeight);
        }];
    }
    
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        if (self.cellType != TTCommonCellTextView ) {
            make.top.equalTo(self.contentView).offset(73);
        }
        make.bottom.equalTo(self.contentView).offset(-1);
    }];
}

/**
 *  设置子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setItem:(TTCommonItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
    
    [self customLayoutSubviews];
}

- (void)setLastRowInSection:(BOOL)lastRowInSection
{
    _lastRowInSection = lastRowInSection;
    
    self.divider.hidden = lastRowInSection;
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    if (self.cellType == TTCommonCellCustomView) {
        return;
    }
    
    if ([self.item isKindOfClass:[TTCommonArrowItem class]]) { // 箭头
        self.cellType = TTCommonCellArrow;
        [self.contentView addSubview:self.arrowView];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if ([self.item isKindOfClass:[TTCommonSwitchItem class]]) { // 开关
        self.cellType = TTCommonCellSwitch;
        [self.contentView addSubview:self.switchView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置开关的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:self.item.title];
    } else if ([self.item isKindOfClass:[TTCommonLabelItem class]]) { // 标签
        self.cellType = TTCommonCellLabel;
    } else if ([self.item isKindOfClass:[TTCommonTextViewItem class]]){
        self.cellType = TTCommonCellTextView;
        [self.contentView addSubview:self.textView];
        TTCommonTextViewItem *item = (TTCommonTextViewItem *)self.item;
        if (item.text) {
            self.textView.text = item.text;
        }
        self.textView.placeholder = item.placeholder;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        self.cellType = TTCommonCellDefual;
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

/**
 *  设置数据
 */
- (void)setupData
{
    if ([self.item isKindOfClass:[TTCommonCustomViewItem class]]) {
        self.cellType = TTCommonCellCustomView;
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        TTCommonCustomViewItem *item = (TTCommonCustomViewItem *)self.item;
        
        self.customView = item.customView;
        
        [self.contentView addSubview:self.customView];
        return;
    }
    
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    //    self.textLabel.text = self.item.title;
    self.labelView.text = self.item.title;
    if (self.item.subtitle) {
        self.subLabelView.text = self.item.subtitle;
        [self.contentView addSubview:self.subLabelView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    UITableView *tableView = [self tableView];
    CGPoint currentOffset = tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [tableView setContentOffset:currentOffset animated:NO];
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.actionBlock) {
        self.actionBlock(textView.text);
    }
}


@end
