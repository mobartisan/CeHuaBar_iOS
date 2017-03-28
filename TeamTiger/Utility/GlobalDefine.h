//
//  GlobalDefine.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

#define kColorForBackgroud [UIColor colorWithRed:28.0/255.0f green:37.0/255.0f blue:51.0/255.0f alpha:1.0f]
#define kColorForCommonCellBackgroud [Common colorFromHexRGB:@"1a293b"]
#define kColorForCommonCellSelectedBackgroud [Common colorFromHexRGB:@"272d39"]

#define TEST 1

#define OPENENCRYPT   0

typedef NS_ENUM(NSUInteger, EResponseType) {
    ResponseStatusSuccess = 0,
    ResponseStatusFailure,
    ResponseStatusOffline,
};

typedef enum : NSUInteger {
    ECurrentIsProject = 0,
    ECurrentIsGroup,
    ECurrentIsAll,
} ECurrentStatus;

typedef void(^ResponseBlock)(EResponseType resType, id response);

static const double default_NavigationHeight = 64.0;
static const double kDistanceToHSide = 16.0f;
static const double kDistanceToVSide = 20.0f;
static const double kLabelHeight = 21.0f;
static const double kCommonCellHeight = 77.0f;
static const double kPointd = 8.0F;

static const double kWidthHeightScale = 767 / 1242.0;

static const int STR_COLOR_MAX = 6;
static const char* kColorAr[STR_COLOR_MAX] = {
    "DCAD62", "669AFF", "DA4042", "91BF42", "E8C61E","41C4F0"};

static const double pushViewHeight = 64.0;

NSString *gSession;

NSString *gClientID;//client id

UIView *bView;

NSString *gMessageType;
NSString *serviceVersion;
NSString *downLoadUrl;
NSString *appDescription;
#endif /* GlobalDefine_h */
