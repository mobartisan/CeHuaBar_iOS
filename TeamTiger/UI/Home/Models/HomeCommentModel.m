//
//  HomeCommentModel.m
//  BBSDemo
//
//  Created by Dale on 16/11/1.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeCommentModel.h"

@implementation HomeCommentModel

+ (instancetype)homeCommentModelWithDict:(NSDictionary *)dic {
    return [[self alloc] initWithDict:dic];
}

- (instancetype)initWithDict:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (CGFloat)heightOfCellData:(id)object {
    HomeCommentModel *model = (HomeCommentModel *)object;
    CGRect rect = [model.content boundingRectWithSize:Size(Screen_Width - 14 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    NSLog(@"height: %lf",27.0 + 20.0 + rect.size.height + ceil(model.photeNameArry.count / 3.0) * 52.0);
    return 27.0 + 20.0 + rect.size.height + ceil(model.photeNameArry.count / 3.0) * 52.0;
}

@end
