//
//  ContactModel.m
//  TeamTiger
//
//  Created by xxcao on 16/7/31.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ContactModel.h"
#import "NSString+Utils.h"
@implementation ContactModel


+ (NSArray *)modelArrayFromDictionaryArray:(NSArray *)dArray {
    NSMutableArray *tmpArrays = [NSMutableArray array];
    for (NSDictionary *dic in dArray) {
        ContactModel *model = [[ContactModel alloc] init];
        model.portrait = dic[@"portrait"];
        model.name = dic[@"name"];
        model.email = dic[@"email"];
        model.isAdd = dic[@"isAdd"];
        model.imageData = dic[@"imageData"];
        [tmpArrays addObject:model];
    }
    return tmpArrays;
}


+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = ((ContactModel *)obj1).name.pinyin;
        NSString *strB = ((ContactModel *)obj2).name.pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (ContactModel *user in serializeArray) {
        char c = [user.name.pinyin characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}

+ (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:UITableViewIndexSearch];
    for (NSArray *item in array) {
        ContactModel *user = [item objectAtIndex:0];
        char c = [user.name.pinyin characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}

+ (ContactModel *)customCopy:(ContactModel *)srcModel {
    ContactModel *desModel = [[ContactModel alloc] init];
    desModel.portrait = srcModel.portrait;
    desModel.name = srcModel.name;
    desModel.email = srcModel.email;
    desModel.isAdd = srcModel.isAdd;
    desModel.imageData = srcModel.imageData;
    return desModel;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.isAdd forKey:@"isAdd"];
    [aCoder encodeObject:self.imageData forKey:@"imageData"];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self){
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.isAdd = [aDecoder decodeObjectForKey:@"isAdd"];
        self.imageData = [aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}


@end
