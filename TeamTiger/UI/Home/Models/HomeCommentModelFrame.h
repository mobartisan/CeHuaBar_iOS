//
//  HomeCommentModelFrame.h
//  TeamTiger
//
//  Created by Dale on 16/11/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeCommentModel;
// 姓名的字体
#define kNameFont [UIFont systemFontOfSize:16]
//时间的字体
#define kTimeFont [UIFont systemFontOfSize:12]
// 正文的字体
#define kTextFont [UIFont systemFontOfSize:16]

@interface HomeCommentModelFrame : NSObject

/**
 *  时间的frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  亮点的frame
 */
@property (nonatomic, assign, readonly) CGRect imageF;
/**
 *  上时间线的frame
 */
@property (nonatomic, assign, readonly) CGRect lineF;
/**
 *  下时间线的frame
 */
@property (nonatomic, assign, readonly) CGRect line1F;
/**
 *  第一个姓名的frame
 */
@property (nonatomic, assign, readonly) CGRect nameF;
/**
 *  第二个姓名的frame
 */
@property (nonatomic, assign, readonly) CGRect name1F;
/**
 *  正文的frame
 */
@property (nonatomic, assign, readonly) CGRect contentF;
/**
 *  图片的frame
 */
@property (nonatomic, assign, readonly) CGRect pictureF;
/**
 *  更多按钮的frame
 */
@property (nonatomic, assign, readonly) CGRect moreBtnF;

/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


@property (nonatomic, strong) HomeCommentModel *homeCommentModel;

@end
