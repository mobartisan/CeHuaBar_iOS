//
//  TTNotificationSetting.m
//  TeamTiger
//
//  Created by xxcao on 16/8/17.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTNotificationSetting.h"
#import "NotificationCell.h"
#import "MessageManager.h"


@interface TTNotificationSetting ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *datas;

@property(nonatomic, copy) NSString *isShake;

@property(nonatomic, copy) NSString *isAudio;

@property(nonatomic, copy) NSString *isShowMessage;

@property(nonatomic, copy) NSString *allowNotification;

@end

@implementation TTNotificationSetting


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hyb_setNavTitle:@"新消息通知"];
    WeakSelf;
    [self hyb_setNavLeftImage:[UIImage imageNamed:@"icon_back"] block:^(UIButton *sender) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];

    [self reloadAPNsData:nil];
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAPNsData:) name:NOTICE_KEY_RELATED_APNS object:nil];
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] init];
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 80;
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [Common removeExtraCellLines:_table];
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)loadDatas {
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:@[
                                      @{@"Name":@"接收信息消息通知",@"Type":@"0",@"Content":self.allowNotification,@"Description":@"如果你要关闭或开启策话的新消息通知，请在“设置” - “通知”功能中，找到应用程序“策话”更改。"},
                                      @{@"Name":@"通知显示消息详情",@"Type":@"1",@"Content":self.isShowMessage,@"Description":@"关闭后，当收到策话信息时，通知提示将不显示发表人和内容摘要。"},
                                      @{@"Name":@"声音",@"Type":@"1",@"Content":self.isAudio,@"Description":@""},
                                      @{@"Name":@"振动",@"Type":@"1",@"Content":self.isShake,@"Description":@"当策话在运行时，你可以设置是否需要声音或振动。"},
                                      ]];
}

#pragma UITableView Delegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2)
        return 2;
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentify";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = 2016 + 1000 * indexPath.section + indexPath.row;
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell reloadCellData:self.datas[0]];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [cell reloadCellData:self.datas[1]];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [cell reloadCellData:self.datas[2]];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        [cell reloadCellData:self.datas[3]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *text = nil;
    if (section == 0) {
        text = self.datas[0][@"Description"];
    } else if (section == 1) {
        text = self.datas[1][@"Description"];;
    } else if (section == 2) {
        text = self.datas[3][@"Description"];;
    }
    CGRect rect = [text boundingRectWithSize:Size(Screen_Width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return rect.size.height + 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    if (section == 0) {
        label.text = self.datas[0][@"Description"];
    } else if (section == 1) {
        label.text = self.datas[1][@"Description"];;
    } else if (section == 2) {
        label.text = self.datas[3][@"Description"];;
    }
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
    }];
    return view;
}

- (void)reloadAPNsData:(id)sender {
    //
    //play shake
    self.isShake = @"0";
    if ([UserDefaultsGet(ALLOW_USER_KEY_PLAY_SHAKE) integerValue] == 1) {
        self.isShake = @"1";
    }
    //play audio
    self.isAudio = @"0";
    if ([UserDefaultsGet(ALLOW_USER_KEY_PLAY_AUDIO) integerValue] == 1) {
        self.isAudio = @"1";
    }
    
    //show message
    self.isShowMessage = @"0";
    if ([UserDefaultsGet(ALLOW_USER_KEY_SHOW_MESSAGE) integerValue] == 1) {
        self.isShowMessage = @"1";
    }
    
    //允许和禁止推送
    self.allowNotification = @"已开启";
    if([MessageManager isMessageNotificationServiceOpen]){
        self.allowNotification = @"已开启";
    } else {
        self.allowNotification = @"已关闭";
    }
    [self loadDatas];
    [self.table reloadData];
}

@end
