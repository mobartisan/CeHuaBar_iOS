//
//  NotificationViewController.m
//  NotificationContentService
//
//  Created by xxcao on 2017/2/10.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *subtitleLabel;
@property IBOutlet UILabel *bodyLabel;
@property IBOutlet UIImageView *bgImgV;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
//    self.titleLabel.text = [NSString stringWithFormat:@"%@", notification.request.content.title];
//    self.subtitleLabel.text = [NSString stringWithFormat:@"%@", notification.request.content.subtitle];
//    self.bodyLabel.text = [NSString stringWithFormat:@"%@", notification.request.content.body];

    UNNotificationAttachment *attachment = notification.request.content.attachments.firstObject;
    if (attachment) {
        if ([attachment.URL startAccessingSecurityScopedResource]) {
            self.bgImgV.image = [UIImage imageWithContentsOfFile:attachment.URL.path];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [attachment.URL stopAccessingSecurityScopedResource];
            });
        }
    }
}

@end
