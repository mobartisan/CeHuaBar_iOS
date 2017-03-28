//
//  CustomAlertView.h
//  Cattle
//
//  Created by 刘鵬 on 15/11/9.
//  Copyright © 2015年 xxcao. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^CompletionHandler)(NSInteger tag);

@interface CustomAlertView : UIView


-(void)showWithTitle:(NSString *)title Content:(NSString *)content btnLeft:(NSString *)btnLeftStr btnRight:(NSString *)btnRightStr CompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

@end
