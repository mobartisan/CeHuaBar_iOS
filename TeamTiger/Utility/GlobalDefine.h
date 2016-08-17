//
//  GlobalDefine.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

#define kColorForBackgroud [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f]
#define kColorForCommonCellBackgroud [Common colorFromHexRGB:@"333949"]
#define kColorForCommonCellSelectedBackgroud [Common colorFromHexRGB:@"272d39"]

static const double default_NavigationHeight = 64.0;
static const double kDistanceToHSide = 16.0f;
static const double kDistanceToVSide = 20.0f;
static const double kLabelHeight = 21.0f;
static const double kCommonCellHeight = 77.0f;
static const double kPointd = 8.0F;

static const int STR_COLOR_MAX = 6;
static const char* kColorAr[STR_COLOR_MAX] = {
    "DCAD62", "669AFF", "DA4042", "91BF42", "E8C61E","41C4F0"};

NSString *gSession;

#endif /* GlobalDefine_h */
