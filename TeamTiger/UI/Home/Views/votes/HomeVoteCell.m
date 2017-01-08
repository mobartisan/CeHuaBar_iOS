//
//  HomeVoteCell.m
//  TeamTiger
//
//  Created by Dale on 16/11/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeVoteCell.h"
#import "HomeModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "VoteView.h"
#import "ButtonIndexPath.h"
#import "VoteModel.h"
#import "MBProgressHUD.h"

@interface HomeVoteCell ()

@property (strong, nonatomic) UIImageView *iconImV;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UIImageView *imageV1;
@property (strong, nonatomic) UILabel *projectLB;
@property (strong, nonatomic) UIImageView *imageV2;
@property (strong, nonatomic) UILabel *contentLB;
@property (strong, nonatomic) VoteView *photoContainerView;
@property (strong, nonatomic) VoteBottomView *voteBottomView;
@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) UIView *separLine;
@property (strong, nonatomic) NSMutableArray *ticketsArr;

@end

@implementation HomeVoteCell

- (NSMutableArray *)ticketsArr {
    if (_ticketsArr == nil) {
        _ticketsArr = [NSMutableArray array];
    }
    return _ticketsArr;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"HomeVoteCell";
    HomeVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HomeVoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kRGBColor(28, 37, 51);
        [self setupCellContentView];
    }
    return self;
}

- (void)setupCellContentView {
    //头像
    self.iconImV = [UIImageView new];
    self.iconImV.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.iconImV];
    
    //姓名
    self.nameLB = [UILabel new];
    self.nameLB.textColor = [Common colorFromHexRGB:@"446695"];
    self.nameLB.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.contentView addSubview:self.nameLB];
    
    self.imageV1 = [UIImageView new];
    self.imageV1.image = [UIImage imageNamed:@"＃"];
    [self.contentView addSubview:self.imageV1];
    
    //项目
    self.projectLB = [UILabel new];
    self.projectLB.textColor = [Common colorFromHexRGB:@"5093ef"];
    self.projectLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.projectLB];
    
    self.imageV2 = [UIImageView new];
    self.imageV2.image = [UIImage imageNamed:@"＃"];
    [self.contentView addSubview:self.imageV2];
    
    self.projectBtn = [ButtonIndexPath buttonWithType:UIButtonTypeCustom];
    [self.projectBtn addTarget:self action:@selector(handleClickProjectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.projectBtn];
    
    //内容
    self.contentLB = [UILabel new];
    self.contentLB.textColor = [Common colorFromHexRGB:@"ffffff"];
    self.contentLB.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.contentLB];
    
    //图片
    self.photoContainerView = [[VoteView alloc] init];
    [self.contentView addSubview:self.photoContainerView];
    
    self.voteBottomView = [[VoteBottomView alloc] init];
    [self.contentView addSubview:self.voteBottomView];
    
    //时间
    self.timeLB = [UILabel new];
    self.timeLB.textColor = [Common colorFromHexRGB:@"6f839d"];
    self.timeLB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.timeLB];

    //分割线
    self.separLine = [UIView new];
    self.separLine.backgroundColor = kRGBColor(41, 50, 61);
    [self.contentView addSubview:self.separLine];
    
    self.iconImV.sd_layout.leftSpaceToView(self.contentView, 17).topSpaceToView(self.contentView, 19).widthIs(37).heightIs(37);
    self.iconImV.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    
    self.nameLB.sd_layout.leftSpaceToView(self.iconImV, 13).topSpaceToView(self.contentView, 20).widthIs(200).heightIs(17);
    [self.nameLB setSingleLineAutoResizeWithMaxWidth:200];
    
    
    self.imageV1.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.nameLB, 9).widthIs(8).heightIs(10);
    
    self.projectLB.sd_layout.leftSpaceToView(self.imageV1, 2).topSpaceToView(self.nameLB, 7).heightIs(13);
    [self.projectLB setSingleLineAutoResizeWithMaxWidth:200];
    
    
    self.imageV2.sd_layout.leftSpaceToView(self.projectLB, 2).topEqualToView(self.imageV1).widthIs(8).heightIs(10);
    
    self.projectBtn.sd_layout.leftEqualToView(self.imageV1).rightEqualToView(self.imageV2).topSpaceToView(self.nameLB, 7).heightIs(20);
    
    self.contentLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.imageV1, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    [self.contentLB setMaxNumberOfLinesToShow:6];
    
    self.photoContainerView.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.contentLB, 10);
    
    self.voteBottomView.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.photoContainerView, 10);
    
    //时间
    self.timeLB.sd_layout.leftEqualToView(self.nameLB).topSpaceToView(self.voteBottomView, 10).heightIs(20);
    [self.timeLB setSingleLineAutoResizeWithMaxWidth:200];
    [self.timeLB updateLayout];
    
    self.separLine.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1.5).topSpaceToView(self.timeLB, 10);
    
    [self setupAutoHeightWithBottomView:self.separLine bottomMargin:0];
}

- (void)setHomeModel:(HomeModel *)homeModel {
    WeakSelf;
    _homeModel = homeModel;
    
    
    [self.iconImV sd_setImageWithURL:[NSURL URLWithString:homeModel.iconImV] placeholderImage:kImage(@"1")];
    self.nameLB.text = homeModel.name;
    self.projectLB.text = homeModel.project;
    self.contentLB.text = homeModel.content;
    self.photoContainerView.picPathStringsArray = homeModel.vote;
    self.photoContainerView.voteClickBlock = ^(VoteModel *voteModel){
        [wself voteClick:voteModel];
    };
    self.voteBottomView.total_count = homeModel.vcount;
    self.voteBottomView.ticketArr = homeModel.vote;
    self.timeLB.text = homeModel.time;
}


- (void)handleClickProjectBtnAction:(ButtonIndexPath *)sender {
    TT_Project *tempProject = [[TT_Project alloc] init];
    tempProject.project_id = _homeModel.Id;
    tempProject.name = _homeModel.project;
    if ([self.delegate respondsToSelector:@selector(clickVoteProjectBtn:)]) {
        [self.delegate clickVoteProjectBtn:tempProject];
    }
}

- (void)voteClick:(VoteModel *)voteModel {
    NSArray *voteModelArr = [NSArray arrayWithObjects:voteModel._id, nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:voteModelArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *vidStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    VoteClickApi *votecClickApi = [[VoteClickApi alloc] init];
    votecClickApi.requestArgument = @{@"pid":_homeModel.Id, //项目id
                                      @"mid":_homeModel.moment_id,//moment id
                                      @"vid":vidStr, //投票id
                                      @"isvote":@(voteModel.isvote)};
    [votecClickApi startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@", request.responseJSONObject);
        if ([request.responseJSONObject[SUCCESS] intValue] == 1) {
            HomeModel *homeModel = [HomeModel modelWithDic: request.responseJSONObject[OBJ]];
            if ([self.delegate respondsToSelector:@selector(clickVoteSuccess:homeModel:)]) {
                [self.delegate clickVoteSuccess:self.projectBtn.indexPath homeModel:homeModel];
            }
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.label.text = request.responseJSONObject[MSG];
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0];
        }
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.label.text = @"您的网络好像有问题~";
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }];
}

@end
