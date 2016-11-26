//
//  HomeCommentModelFrame.m
//  TeamTiger
//
//  Created by Dale on 16/11/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeCommentModelFrame.h"
#import "HomeCommentModel.h"



@implementation HomeCommentModelFrame

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setHomeCommentModel:(HomeCommentModel *)homeCommentModel {
    _homeCommentModel = homeCommentModel;
    
    CGFloat margin = 0.0;
    if (is55inch) {
        margin = 10.0;
    }
    /**
     *  上时间线的frame
     */
    CGFloat lineX = 61;
    CGFloat lineY = 0;
    CGFloat lineW = 4;
    CGFloat lineH = 10;
    _lineF = CGRectMake(lineX, lineY, lineW, lineH);
    
    /**
     *  亮点的frame
     */
    CGFloat imageWH = 15;
    CGFloat imageX = CGRectGetMidX(_lineF) - imageWH / 2;
    CGFloat imageY = CGRectGetMaxY(_lineF) - imageWH / 2;
    _imageF = CGRectMake(imageX, imageY, imageWH, imageWH);
    
    /**
     *  时间的frame
     */
    CGFloat timeW = 47;//47 38
    CGFloat timeH = 20;
    CGFloat timeX = 3;//3   8
    CGFloat timeY = CGRectGetMidY(_imageF) - timeH / 2;
    _timeF = CGRectMake(timeX, timeY, timeW, timeH);

    /**
     *  第一个姓名的frame
     */
    UIFont *font = nil;
    if ([homeCommentModel.sName isEqualToString:@"时间节点"]) {
        font = KTimeFont;
    }else {
        font = KNameFont;
    }
    CGFloat nameX = 78;
    CGFloat nameY = timeY;
    CGFloat nameW = [self sizeWithText:homeCommentModel.name font:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    CGFloat nameH = 20;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    /**
     *  第二个姓名的frame
     */
    CGFloat name1X = CGRectGetMaxX(_nameF) + 2;
    CGFloat name1Y = nameY;
    CGFloat name1W = [self sizeWithText:homeCommentModel.sName font:KNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    CGFloat name1H = 20;
    _name1F = CGRectMake(name1X, name1Y, name1W, name1H);
    /**
     *  正文的frame
     */
    CGFloat contentX = nameX;
    CGFloat contentY = CGRectGetMaxY(_timeF);
    CGFloat maxW = kScreenWidth - 14 * 2 - contentX - 35;
    CGSize maxSize = [self sizeWithText:homeCommentModel.content font:KTextFont maxSize:CGSizeMake(maxW, MAXFLOAT)];
    _contentF = CGRectMake(contentX, contentY, maxSize.width, maxSize.height);
    
    
    /**
     *  下时间线的frame
     */
    CGFloat line1X = lineX;
    CGFloat line1Y = CGRectGetMaxY(_lineF);
    CGFloat line1W = 4;
    CGFloat line1H = 0;
    
    /**
     *  图片的frame
     */
    if (![Common isEmptyArr:homeCommentModel.photeNameArry]) {
        CGFloat picX = nameX;
        CGFloat picY = CGRectGetMaxY(_contentF) + 5;
        CGFloat picW = maxW;
        CGFloat picH = 52;
        _pictureF = CGRectMake(picX, picY, picW, picH);
        line1H = CGRectGetMaxY(_pictureF) + margin;
    }else {
        if (![Common isEmptyString:homeCommentModel.content]) {
            line1H = CGRectGetMaxY(_contentF);
        }else {
            line1H = CGRectGetMaxY(_timeF);
        }
    }
    //此处为时间节点
    if ([homeCommentModel.sName isEqualToString:@"时间节点"]) {
        line1H = CGRectGetMaxY(_timeF);
    }
    
    _line1F = CGRectMake(line1X, line1Y, line1W, line1H);
    
    
    CGFloat moreBtnX = kScreenWidth - 14 * 2 - 30 -5;
    CGFloat moreBtnY = CGRectGetMaxY(_line1F) - 30 -5;
    CGFloat moreBtnW = 30;
    CGFloat moreBtnH = 30;
    _moreBtnF = CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnH);
    
    /**
     *  cell的高度
     */
    _cellHeight = CGRectGetMaxY(_line1F);
    if (homeCommentModel.show) {
        _cellHeight = CGRectGetMaxY(_line1F) + margin;
    }
    
}


@end
