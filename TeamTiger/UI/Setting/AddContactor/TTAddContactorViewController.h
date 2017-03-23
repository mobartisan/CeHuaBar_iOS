//
//  TTAddContactorViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/7/30.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"
#import <AddressBook/AddressBook.h>

typedef enum : NSUInteger {
    EDataFromAddressBook = 0,
    EDataFromNetwork,
    EDataFromOther,
} EDataFromSource;

@interface TTAddContactorViewController : TTBaseViewController<UITableViewDelegate,UITableViewDataSource> {
    ABAddressBookRef addBook;
}

@property (weak, nonatomic) IBOutlet UITableView *contactTable;
@property (nonatomic,strong) NSArray *serverDataArr;//数据源

@end

