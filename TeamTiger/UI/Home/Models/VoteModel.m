//
//  VoteModel.m
//  TeamTiger
//
//  Created by Dale on 16/12/15.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "VoteModel.h"

@implementation VoteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"medias"]) {
        for (NSDictionary *mediasDic in value) {
            self.url = mediasDic[@"url"];
        }
    }
}



@end
