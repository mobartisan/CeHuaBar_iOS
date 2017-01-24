//
//  Extension.h
//  TeamTiger
//
//  Created by xxcao on 2017/1/24.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MaxLengthBlock)(BOOL isBeyond);

@interface UITextField (Extension)

- (void)beyondMaxLength:(NSInteger)maxLength BeyondBlock:(MaxLengthBlock)block;

@end
