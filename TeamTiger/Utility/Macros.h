//
//  Macros.h
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//当前iOS系统版本
#define CurrentSystemVersion_String        [[UIDevice currentDevice] systemVersion]
#define CurrentSystemVersion_Double        [[[UIDevice currentDevice] systemVersion] doubleValue]

//app 当前的版本
#define AppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

//检测是否retina屏
#define isRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 960.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测iPad是否retina屏
#define isRetina_iPad  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(2048, 1536), [[UIScreen mainScreen] currentMode].size)) : NO)
//检测是否iPhone4
#define isIPhone4    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 960.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测是否iPhone5
#define isIPhone5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测是否iPhone6
#define isIPhone6    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0, 1334.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测是否iPhone6P
#define isIPhone6P    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0, 2208.0), [[UIScreen mainScreen] currentMode].size) : NO)


//检测是否4寸屏
#define is35inch    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 960.0), [[UIScreen mainScreen] currentMode].size) : NO)

#define is40inch    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)

#define is47inch    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0, 1334.0), [[UIScreen mainScreen] currentMode].size) : NO)

#define is55inch    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0, 2208.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测是否iOS7
#define iOS7       (CurrentSystemVersion_Double >= 7.0)
//检测是否 iOS8
#define iOS8       (CurrentSystemVersion_Double >= 8.0)
//检测是否iPad
#define isiPad      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//检测是否iPod或者iPhone
#define isiPhone    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define FONT(s)       [UIFont systemFontOfSize:s]

//View相关
#define Point(Xpos, Ypos)                  CGPointMake(Xpos, Ypos)
#define Size(Width, Height)                CGSizeMake(Width, Height)
#define Frame(Xpos, Ypos, Width, Height)   CGRectMake(Xpos, Ypos, Width, Height)
#define Xpos                               origin.x
#define Ypos                               origin.y
#define Width                              size.width
#define Height                             size.height

//frame相关
#define SetFrameByXPos(frame,xpos)        {CGRect rect = frame; rect.origin.x = xpos; frame = rect;}
#define SetFrameByYPos(frame,ypos)        {CGRect rect = frame; rect.origin.y = ypos; frame = rect;}
#define SetFrameByWidth(frame,kWidth)     {CGRect rect = frame; rect.size.width = kWidth; frame = rect;}
#define SetFrameByHeight(frame,kHeight)   {CGRect rect = frame; rect.size.height = kHeight; frame = rect;}

//Window相关
#define Screen_Width                 [UIScreen mainScreen].bounds.size.width
#define Screen_Height                [UIScreen mainScreen].bounds.size.height

//弧度与角度的转换
#define DegreeToRadian(X)            ((X) * M_PI / 180.0)
#define RadianToDegree(Radian)       ((Radian) * 180.0 / M_PI)

//设置View圆角
#define setViewCorner(view,radius)   {view.layer.cornerRadius = radius; view.layer.masksToBounds = YES;}

//设置View圆角加边框
#define setViewCornerAndBorder(view,radius)   {view.layer.cornerRadius = radius; view.layer.masksToBounds = YES; view.layer.borderWidth = (minLineWidth); view.layer.borderColor = ColorRGB(46, 201, 202).CGColor;}

//设置颜色
#define ColorRGBA(R,G,B,A)           [UIColor colorWithRed:R / 255.0 green:G / 255.0  blue:B / 255.0  alpha:A]
#define ColorRGB(R,G,B)              [UIColor colorWithRed:R / 255.0 green:G / 255.0  blue:B / 255.0  alpha:1.0]

//设置View边框
#define setViewBorder(view, width) {view.layer.borderWidth = width; view.layer.borderColor = ColorRGB(190, 190, 190).CGColor;}

//block self
#define WeakSelf        __weak typeof(self) wself = self


//从nib中加载cell
#define LoadFromNib(nibName)  [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject]

////最小线宽
#define minLineWidth  (1.0 / [UIScreen mainScreen].scale)

typedef void(^ClickBlock)();

//数据存储
#define UserDefaultsGet(Key)           [[NSUserDefaults standardUserDefaults] objectForKey:Key]
#define UserDefaultsSave(Value,Key)    {[[NSUserDefaults standardUserDefaults] setObject:Value forKey:Key]; [[NSUserDefaults standardUserDefaults] synchronize];}
#define UserDefaultsRemove(Key)        {[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key]; [[NSUserDefaults standardUserDefaults] synchronize];}

//空字符串
#define NullString            @""

#endif /* Macros_h */
