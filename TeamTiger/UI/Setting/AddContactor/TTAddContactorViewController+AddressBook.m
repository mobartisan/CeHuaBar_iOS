//
//  TTAddContactorViewController+AddressBook.m
//  TeamTiger
//
//  Created by xxcao on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTAddContactorViewController+AddressBook.h"
#import <AddressBook/AddressBook.h>

@implementation TTAddContactorViewController (AddressBook)

- (NSArray *)getMyAddressBook {
    NSMutableArray *mArray = [NSMutableArray array];
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    //进行遍历
    for (NSInteger i = 0; i < number; i++) {
        //获取联系人对象的引用
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        //获取当前联系人名字
        NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        NSMutableArray *emailArr = [[NSMutableArray alloc]init];
        //获取当前联系人的邮箱 注意是数组
        ABMultiValueRef emails = ABRecordCopyValue(people, kABPersonEmailProperty);
        for (NSInteger j = 0; j < ABMultiValueGetCount(emails); j++) {
            [emailArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, j))];
        }

        //获取当前联系人头像图片
        NSData *userImage = (__bridge NSData*)(ABPersonCopyImageData(people));
        
        NSMutableDictionary *baseInfo = [NSMutableDictionary dictionary];
        if (userImage) {
            baseInfo[@"imageData"] = userImage;
        }
        NSString *name = nil;
        if(![Common isEmptyString:lastName] && ![Common isEmptyString:firstName]) {
            name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            baseInfo[@"name"] = name;
        } else if([Common isEmptyString:lastName] && ![Common isEmptyString:firstName]) {
            name = [NSString stringWithFormat:@"%@",firstName];
            baseInfo[@"name"] = name;
        } else if(![Common isEmptyString:lastName] && [Common isEmptyString:firstName]) {
            name = [NSString stringWithFormat:@"%@",lastName];
            baseInfo[@"name"] = name;
        }
        if (emailArr && emailArr.count > 0) {
            baseInfo[@"email"] = emailArr.firstObject;
        }
        baseInfo[@"isAdd"] = @0;
        
        if (![Common isEmptyString:lastName] || ![Common isEmptyString:firstName]) {
            [mArray addObject:baseInfo];
        }
        //release
        CFRelease(emails);
        
    }
    return mArray;
}


- (int)applyAddressAuthority {
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip = 0;
    //声明一个通讯簿的引用
    addBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //创建一个出事信号量为0的信号
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
        //greanted为YES是表示用户允许，否则为不允许
        if (!greanted) {
            tip = 1;
        }
        //发送一次信号
        dispatch_semaphore_signal(sema);
    });
    //等待信号触发
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return tip;
}

- (void)loadDataFromSource:(EDataFromSource)dataSourceType {
    if (dataSourceType == EDataFromAddressBook) {
        //从地址簿
        int isTips = [self applyAddressAuthority];
        if (isTips == 0) {
            self.serverDataArr = [NSMutableArray arrayWithArray:[self getMyAddressBook]];
        } else {
            if (!self.serverDataArr) {
                self.serverDataArr = [NSMutableArray array];
            }
            //做一个友好的提示
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
        }
    } else {
        self.serverDataArr = [NSMutableArray arrayWithArray:  @[
        @{@"portrait":@"1", @"name":@"1", @"email":@"sdsssfsfdf@qq.com", @"isAdd":@0},
        @{@"portrait":@"2", @"name":@"花无缺", @"email":@"dfdfdfdf@163.com", @"isAdd":@0},
        @{@"portrait":@"3", @"name":@"东方不败", @"email":@"", @"isAdd":@1},
        @{@"portrait":@"4", @"name":@"任我行", @"email":@"ththththth@gmail.com", @"isAdd":@0},
        @{@"portrait":@"5", @"name":@"逍遥王", @"email":@"", @"isAdd":@0},
        @{@"portrait":@"6", @"name":@"阿离", @"email":@"ddbbgbgbgb@qq.com", @"isAdd":@0},
        @{@"portrait":@"13",@"name":@"百草堂", @"email":@"ynynynyny@qq.com", @"isAdd":@0},
        @{@"portrait":@"8", @"name":@"三味书屋", @"email":@"sdsssfsfdf@yahoo.com", @"isAdd":@0},
        @{@"portrait":@"9", @"name":@"彩彩", @"email":@"", @"isAdd":@0},
        @{@"portrait":@"10", @"name":@"陈晨", @"email":@"", @"isAdd":@0},
        @{@"portrait":@"11", @"name":@"多多", @"email":@"vfvfbfbgnbhn@qq.com", @"isAdd":@1},
        @{@"portrait":@"12", @"name":@"峨嵋山", @"email":@"werererere@126.com", @"isAdd":@0},
        @{@"portrait":@"7", @"name":@"哥哥", @"email":@"fbgnhnynyny@souhu.com", @"isAdd":@0},
        @{@"portrait":@"14", @"name":@"林俊杰", @"email":@"dvdvvfvfvf@qq.com", @"isAdd":@0},
        @{@"portrait":@"15", @"name":@"足球", @"email":@"", @"isAdd":@1},
        @{@"portrait":@"16", @"name":@"58赶集", @"email":@"", @"isAdd":@0},
        @{@"portrait":@"17", @"name":@"搜房网", @"email":@"sdsssfsfdf@tencent.com", @"isAdd":@0},
        @{@"portrait":@"18", @"name":@"欧弟王", @"email":@"", @"isAdd":@1}]];
    }
}

@end
