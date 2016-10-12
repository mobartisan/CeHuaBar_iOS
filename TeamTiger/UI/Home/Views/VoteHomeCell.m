//
//  VoteHomeCell.m
//  TeamTiger
//
//  Created by Dale on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "VoteHomeCell.h"
#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"
#import "HomeDetailCell4.h"
#import "HomeDetailCell5.h"
#import "HomeDetailCell6.h"
#import "ButtonIndexPath.h"
#import "JJPhotoManeger.h"

static CGFloat tableViewHeight = 0.0;

@interface VoteHomeCell ()

@property (strong, nonatomic) HomeDetailCellModel *detailModel;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *aDesLB;
@property (weak, nonatomic) IBOutlet UILabel *bDesLB;
@property (weak, nonatomic) IBOutlet UILabel *cDesLB;
@property (weak, nonatomic) IBOutlet UIProgressView *aProgress;
@property (weak, nonatomic) IBOutlet UILabel *aTicketLB;
@property (weak, nonatomic) IBOutlet UILabel *aPerLB;
@property (weak, nonatomic) IBOutlet UIProgressView *bProgress;
@property (weak, nonatomic) IBOutlet UILabel *bTicketLB;
@property (weak, nonatomic) IBOutlet UILabel *bPerLB;
@property (weak, nonatomic) IBOutlet UIProgressView *cProgress;
@property (weak, nonatomic) IBOutlet UILabel *cTicketLB;
@property (weak, nonatomic) IBOutlet UILabel *cPerLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@end

@implementation VoteHomeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (is40inch) {
        self.bgViewHeight.constant = 361;
    }else {
        self.bgViewHeight.constant = 381;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [Common removeExtraCellLines:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell4" bundle:nil] forCellReuseIdentifier:@"cellIdentifier4"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell5" bundle:nil] forCellReuseIdentifier:@"cellIdentifier5"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeDetailCell6" bundle:nil] forCellReuseIdentifier:@"cellIdentifier6"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.detailModel.isClick) {
        return _model.comment.count;
    }else {
        for (HomeDetailCellModel *detailModel in _model.comment) {
            if (detailModel.typeCell == TypeCellTitle) {
                NSUInteger index = [_model.comment indexOfObject:detailModel];
                return index + 1;
            }
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailCellModel *detailModel = _model.comment[indexPath.row];
    if (detailModel.typeCell == TypeCellTitleNoButton) {
        HomeDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier4"];
        [cell configureCellWithModel:detailModel];
        return cell;
    }else if(detailModel.typeCell == TypeCellTitle){
        HomeDetailCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier5"];
        [cell configureCellWithModel:detailModel];
        cell.clickBlock = ^() {
            self.detailModel = detailModel;
            detailModel.isClick = YES;
            detailModel.isTap = YES;
            detailModel.typeCell = TypeCellTitleNoButton;
            [self.tableView reloadData];
            _model.height = 0;
            if ([self.delegate respondsToSelector:@selector(reloadTableViewWithHeight:withIndexPath:)]) {
                [self.delegate reloadTableViewWithHeight:0.0 withIndexPath:nil];
            }
        };
        return cell;
    }else {
        HomeDetailCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier6"];
        cell.lineView2.hidden = NO;
        if (indexPath.row == _model.comment.count - 1) {
            cell.lineView2.hidden = YES;
        }
        [cell configureCellWithModel:detailModel];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailCellModel *model = _model.comment[indexPath.row];
    if (model.typeCell == TypeCellTitleNoButton) {
        return 35;
    }else if (model.typeCell == TypeCellTitle){
        return 65;
    }else {
        return 35;
    }
}

//投票
- (IBAction)handleBtnAction:(UIButton *)sender {
    NSString *projectType = @"";
    NSInteger typeCell = 0;
    switch (sender.tag) {
        case 100:{
            if (!_model.aIsClick) {
                _model.aIsClick = YES;
                _model.aTicket = [NSString stringWithFormat:@"%.1f", ([_model.aTicket floatValue] + 0.1)];
                typeCell = TypeCellTime;
            }else {
                _model.aIsClick = NO;
                _model.aTicket = [NSString stringWithFormat:@"%.1f", ([_model.aTicket floatValue] - 0.1)];
                typeCell = TypeCellTitleNoButton;
            }
            projectType = @"A";
        }
            break;
        case 101:{
            if (!_model.bIsClick) {
                _model.bIsClick = YES;
                _model.bTicket = [NSString stringWithFormat:@"%.1f", ([_model.bTicket floatValue] + 0.1)];
                typeCell = TypeCellTime;
            }else {
                _model.bIsClick = NO;
                _model.bTicket = [NSString stringWithFormat:@"%.1f", ([_model.bTicket floatValue] - 0.1)];
                typeCell = TypeCellTitleNoButton;
            }
            projectType = @"B";
        }
            break;
        case 102:{
            if (!_model.cIsClick) {
                _model.cIsClick = YES;
                _model.cTicket = [NSString stringWithFormat:@"%.1f", ([_model.cTicket floatValue] + 0.1)];
                typeCell = TypeCellTime;
            }else {
                _model.cIsClick = NO;
                _model.cTicket = [NSString stringWithFormat:@"%.1f", ([_model.cTicket floatValue] - 0.1)];
                typeCell = TypeCellTitleNoButton;
            }
            projectType = @"C";
        }
            break;
    }
    NSDictionary *dic = @{@"time":[Common getCurrentSystemTime],
            @"firstName":_model.name,
            @"secondName":projectType,
            @"typeCell":@(typeCell)
            };
    HomeDetailCellModel *detailModel = [HomeDetailCellModel modelWithDic:dic];
    [_model.comment insertObject:detailModel atIndex:0];
    _model.isClick = YES;
    _model.height = 0.0;
    if (self.voteClick) {
        self.voteClick();
    }
}

//图片
- (IBAction)handleClickImageAction:(UIButton *)sender {
    UIImageView *image = nil;
    switch (sender.tag) {
        case 200:
            image = self.image1;
            break;
        case 201:
            image = self.image2;
            break;
        case 202:
            image = self.image3;
            break;
        default:
            break;
    }
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    [mg showNetworkPhotoViewer:@[self.image1, self.image2, self.image3] urlStrArr:nil selecView:image];
    
}

- (void)setModel:(HomeCellModel *)model {
    if (model.isClick) {
        [self.moreBtn setImage:kImage(@"icon_shang") forState:UIControlStateNormal];
    }else {
        [self.moreBtn setImage:kImage(@"icon_xia") forState:UIControlStateNormal];
    }
    if (model.aIsClick) {
        [self.aBtn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
    }else {
        [self.aBtn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
    }
    if (model.bIsClick) {
        [self.bBtn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
    }else {
        [self.bBtn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
    }
    if (model.cIsClick) {
        [self.cBtn setBackgroundImage:kImage(@"icon_vote") forState:UIControlStateNormal];
    }else {
        [self.cBtn setBackgroundImage:kImage(@"icon_vote_normal") forState:UIControlStateNormal];
    }
    _model = model;
    self.timeLB.text = model.time;
    self.headImage.image = kImage(model.headImage);
    self.nameLB.text = model.name;
    self.typeLB.text = model.type;
    self.image1.image = kImage(model.image1);
    self.image2.image = kImage(model.image2);
    self.image3.image = kImage(model.image3);
    self.aDesLB.text = model.aDes;
    self.bDesLB.text = model.bDes;
    self.cDesLB.text = model.cDes;
    self.aProgress.progress = [model.aTicket floatValue];
    self.bProgress.progress = [model.bTicket floatValue];
    self.cProgress.progress = [model.cTicket floatValue];
    
    self.aTicketLB.text = [NSString stringWithFormat:@"%.0f票", (model.aTicket.floatValue) * 10];
    self.bTicketLB.text = [NSString stringWithFormat:@"%.0f票", (model.bTicket.floatValue) * 10];
    self.cTicketLB.text = [NSString stringWithFormat:@"%.0f票", (model.cTicket.floatValue) * 10];
    
    self.aPerLB.text = [NSString stringWithFormat:@"(%.0f%%)", (model.aTicket.floatValue) * 100];
    self.bPerLB.text = [NSString stringWithFormat:@"(%.0f%%)", (model.bTicket.floatValue) * 100];
    self.cPerLB.text = [NSString stringWithFormat:@"(%.0f%%)", (model.cTicket.floatValue) * 100];
    
    for (HomeDetailCellModel *detailModel in _model.comment) {
        if (detailModel.typeCell == TypeCellTitle || detailModel.isTap) {
            self.detailModel = detailModel;
        }
    }
    
    if (model.isClick == NO) {
        self.detailModel.isClick = NO;
        self.detailModel.typeCell = TypeCellTitle;
    }
    
    CGFloat height = 0;
    NSMutableArray *cellHeightArr = [NSMutableArray array];
    NSMutableArray *cellHeight1Arr = [NSMutableArray array];
    NSMutableArray *cellHeight2Arr = [NSMutableArray array];
    if (model.isClick) {
        for (HomeDetailCellModel *detailModel in model.comment) {
            if (detailModel.typeCell == TypeCellTitleNoButton) {
                [cellHeightArr addObject:detailModel];
            } else if (detailModel.typeCell == TypeCellTitle) {
                [cellHeight1Arr addObject:detailModel];
                if (detailModel.isClick == NO) {
                    break;
                }
            }else if (detailModel.typeCell == TypeCellTime) {
                [cellHeight2Arr addObject:detailModel];
            }
        }
    }
    height =  35 * ((int)cellHeightArr.count)  + 65 * ((int)cellHeight1Arr.count) + 35 * ((int)cellHeight2Arr.count);
    if (_model.height == 0) {
        _model.height = height;
    }
    tableViewHeight = _model.height;
}

+ (CGFloat)tableViewHeight {
    return tableViewHeight;
}

+ (CGFloat)cellHeightWithModel:(HomeCellModel *)model {
    CGFloat cellHeight = 0;
    if (is40inch) {
        cellHeight = 411;
    }else {
        cellHeight = 431;
    }
    if (model.height == 0) {
        if (model.isClick) {
            return cellHeight + [VoteHomeCell tableViewHeight];
        }else {
            return cellHeight;
        }
    }else{
        return cellHeight + model.height;
    }
}

- (IBAction)handleCommitAction:(UIButton *)sender {
    if (self.clickBtn) {
        self.clickBtn(sender);
    }
}

@end
