//
//  SqliteManager.m
//  MPP
//
//  Created by xxcao on 16/7/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SqliteManager.h"
#import <objc/runtime.h>

@interface SqliteManager ()

@property (copy, nonatomic)NSString *dbPath;

@end

@implementation SqliteManager

static SqliteManager *singleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}

- (void)setDataBasePath:(NSString *)dbName{
    if (!dbName) {
        NSAssert(!dbName, @"please must fill db name");
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbDir = [paths[0] stringByAppendingFormat:@"/database"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    self.dbPath = [NSString stringWithFormat:@"%@/%@.db",dbDir,dbName];
    
    if ([self.dbPath containsString:@"SYSTEM"]) {
        NSLog(@"Current System DB Path: %@",self.dbPath);
    } else {
        NSLog(@"Current User DB Path: %@",self.dbPath); 
    }
}


- (BOOL)createDataBaseIsNeedUpdate:(BOOL)isNeedUpdate isForUser:(BOOL)isUser{
    @synchronized (self) {
        if (!self.dbPath){
            NSAssert(YES, @"database path can not be nil");
            return NO;
        }
        
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return NO;
        }
        //是否要更新检查表
        if (isNeedUpdate) {
            [self onUpgradeVersion:db isForUser:isUser];
        }
        
//        UserDefaultsSave(AppVersion, @"Key_Last_Version");
        sqlite3_close(db);
        return YES;
    }
}

- (BOOL)executeSql:(NSString *)sql {
    @synchronized (self) {
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return NO;
        }
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库操作数据失败!");
            return NO;
        }
        sqlite3_close(db);
        return YES;
    }
}

- (NSArray *)selectDatasSql:(NSString *)sql Class:(NSString *)objClass {
    @synchronized (self) {
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return nil;
        }
        
        NSMutableArray *resutArray = nil;
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            int column_count = sqlite3_column_count(statement);
            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSObject *object = [[NSClassFromString(objClass) alloc] init];

                for (int i = 0; i < column_count; i++) {
                    const char *column_name = sqlite3_column_name(statement, i);
                    NSString *key = [NSString stringWithFormat:@"%s", column_name];

                    const char *column_decltype = sqlite3_column_decltype(statement, i);
                    NSString *obj_column_decltype = [[NSString stringWithUTF8String:column_decltype] lowercaseString];

                    id column_value = nil;
                    NSData *column_data = nil;
                    
                    if ([obj_column_decltype isEqualToString:@"text"]) {
                        const unsigned char *value = sqlite3_column_text(statement, i);
                        if (value != NULL) {
                            column_value = [NSString stringWithUTF8String: (const char *)value];
                            if (column_value) {
                                [object setValue:column_value forKey:key];
                            }
                        }
                    }
                    else if ([obj_column_decltype isEqualToString:@"integer"]) {
                        int value = sqlite3_column_int(statement, i);
                        column_value = [NSNumber numberWithLongLong: value];
                        [object setValue:column_value forKey:key];
                    }
                    else if ([obj_column_decltype isEqualToString:@"real"]) {
                        double value = sqlite3_column_double(statement, i);
                        column_value = [NSNumber numberWithDouble:value];
                        [object setValue:column_value forKey:key];
                    }
                    else if ([obj_column_decltype isEqualToString:@"blob"]) {
                        const void *databyte = sqlite3_column_blob(statement, i);
                        if (databyte != NULL) {
                            int dataLenth = sqlite3_column_bytes(statement, i);
                            column_data = [NSData dataWithBytes:databyte length:dataLenth];
                            [object setValue:column_data forKey:key];
                        }
                    }
                    else {
                        const unsigned char *value = sqlite3_column_text(statement, i);
                        if (value != NULL) {
                            column_value = [NSString stringWithUTF8String: (const char *)value];
                            [object setValue:column_value forKey:key];
                        }
                    }
                }
                
                if (!resutArray) {
                    resutArray = [[NSMutableArray alloc] initWithObjects:object, nil];
                } else {
                    [resutArray addObject:object];
                }
            }
        }
        sqlite3_finalize(statement);
        statement = nil;
        sqlite3_close(db);
        return resutArray;
    }
}


/**
 *	计算count(*)或 sum (*)
 */
- (int)caculateCountOrSumSql:(NSString *)sql {
    @synchronized(self){
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return -1;
        }
        sqlite3_stmt *stmt;
        int count = 0;
        int tmpRet = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
        if (tmpRet == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                count = sqlite3_column_int(stmt, 0);
            }
        }
        sqlite3_finalize(stmt);
        stmt = nil;
        sqlite3_close(db);
        return count;
    }
}


#pragma -mark
-(void)checkTable:(sqlite3*)database
        tableName:(NSString*)tableName
        allFields:(NSMutableArray*)allFields
    allFieldTypes:(NSMutableArray*)allFieldTypes
      primaryKeys:(NSMutableArray*)primaryKeys
isFieldTypeChanged:(BOOL)isFieldTypeChanged
{
    if(!database||!tableName||
       allFields==nil||allFields.count<=0||
       allFieldTypes==nil||allFieldTypes.count<=0||
       allFields.count!=allFieldTypes.count) return;
    
    NSString* sql=[NSString stringWithFormat:@"select * from %@ where (1=0)", tableName];
    sqlite3_stmt *stmt;
    NSString* newTableName=[NSString stringWithFormat:@"%@_tmp", tableName];
    NSString* tempText1, *tempText2;
    const char * columnName=nil;
    NSHashTable* hash=[[NSHashTable alloc] init];
    int tmpRet = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (tmpRet == SQLITE_OK)
    {
        int column_count = sqlite3_column_count(stmt);
        //array=[[NSMutableArray alloc] init];
        for(int i=0;i<column_count;i++)
        {
            columnName= sqlite3_column_name(stmt, i);
            NSString* nsColumnName=[NSString stringWithUTF8String:columnName];
            [hash addObject:nsColumnName];
        }
        
        for(int i=0;i<allFields.count;i++)
        {
            tempText1=[allFields objectAtIndex:i];
            tempText2=[allFieldTypes objectAtIndex:i];
            if(![hash containsObject:tempText1]){
                sql=[NSString stringWithFormat:@"alter table %@ add column %@ %@", tableName, tempText1,tempText2];
                [[SqliteManager sharedInstance] executeSql:sql];
            }
        }
        
        if(isFieldTypeChanged)
        {
            [self onCreateTable:database tableName:newTableName allFields:allFields allFieldTypes:allFieldTypes primaryKeys:primaryKeys];
            [self onMoveTable:database tableName:tableName newTableName:newTableName allFields:allFields allFieldTypes:allFieldTypes hasKDbIdColumnInNewTable:YES];
            sql=[NSString stringWithFormat:@"drop table %@",tableName];
            [[SqliteManager sharedInstance] executeSql:sql];
            sql=[NSString stringWithFormat:@"alter table %@ rename to %@", newTableName, tableName];
            [[SqliteManager sharedInstance] executeSql:sql];
        }
    }
    else{
        [self onCreateTable:database tableName:tableName allFields:allFields allFieldTypes:allFieldTypes primaryKeys:primaryKeys];
    }
}

- (void)onMoveTable:(sqlite3*)database
         tableName:(NSString*)tableName
      newTableName:(NSString*)newTableName
         allFields:(NSMutableArray*)allFields
     allFieldTypes:(NSMutableArray*)allFieldTypes
hasKDbIdColumnInNewTable:(BOOL)hasKDbIdColumnInNewTable
{
    NSInteger index = [allFields indexOfObject:@"__id__"];
    
    NSMutableString* sb=[[NSMutableString alloc] init];
    [sb appendString:@"insert into "];
    [sb appendString:newTableName];
    [sb appendString:@"("];
    
    for(int i=0;i<allFields.count;i++)
        if(index<0||i==index)
        {
            [sb appendString:[allFields objectAtIndex:i]];
            [sb appendString:@","];
        }
    NSRange range;
    range.location=sb.length-1;
    range.length=1;
    [sb deleteCharactersInRange:range];
    [sb appendString:@") select "];
    
    for(int i=0;i<allFields.count;i++)
        if(index<0||i==index)
        {
            [sb appendString:[allFields objectAtIndex:i]];
            [sb appendString:@","];
        }
    [sb deleteCharactersInRange:range];
    [sb appendString:@" from "];
    [sb appendString:tableName];
    [[SqliteManager sharedInstance] executeSql:sb];
}

- (void)onCreateTable:(sqlite3*)database
           tableName:(NSString*)tableName
           allFields:(NSMutableArray*)allFields
       allFieldTypes:(NSMutableArray*)allFieldTypes
         primaryKeys:(NSMutableArray*)primaryKeys
{
    NSMutableString* sb=[[NSMutableString alloc] init];
    [sb appendString:@"create table "];
    [sb appendString:tableName];
    [sb appendString:@"("];
    for(int i=0;i<allFields.count;i++)
    {
        [sb appendString:[allFields objectAtIndex:i]];
        [sb appendString:@" "];
        [sb appendString:[allFieldTypes objectAtIndex:i]];
        [sb appendString:@","];
    }
    NSRange range;
    range.location=sb.length-1;
    range.length=1;
    [sb deleteCharactersInRange:range];
    [sb appendString:@")"];
    [[SqliteManager sharedInstance] executeSql:sb];
    
    //create the unique index for primary keys
    //for we already create the __id__ as the primary key
    if(primaryKeys&&primaryKeys.count>0)
    {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *uniqueIndex = [[[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString] substringToIndex:20];
        sb=[[NSMutableString alloc] init];
        [sb appendString:@"create unique index INDEX_"];
        [sb appendString:uniqueIndex];
        [sb appendString:@" on "];
        [sb appendString:tableName];
        [sb appendString:@"("];
        for(int i=0;i<primaryKeys.count;i++)
        {
            [sb appendString:[primaryKeys objectAtIndex:i]];
            [sb appendString:@","];
        }
        range.location=sb.length-1;
        [sb deleteCharactersInRange:range];
        [sb appendString:@")"];
        [[SqliteManager sharedInstance] executeSql:sb];
    }
}


- (void)preparePredefineDatas:(sqlite3 *)database
                     commands:(NSMutableArray *)commands {
    for (NSString *sql in commands) {
        @try {
            [[SqliteManager sharedInstance] executeSql:sql];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
    }
}



#pragma -mark
#pragma -mark 更新表
-(BOOL)onUpgradeVersion:(sqlite3*)database isForUser:(BOOL)isUser
{
    if (isUser) {
//        TABLE_TT_User
        [self checkTable:database
               tableName:TABLE_TT_User
           allFields:@[@"user_id",@"password",@"name",@"nick_name",@"wx_account",@"phone",@"head_img_url",@"os_type",@"os_description",@"device_identify",@"create_date",@"create_user_id",@"last_edit_date",@"last_edit_user_id"].mutableCopy
       allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"timestamp",@"varchar",@"timestamp",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
        
//        TABLE_TT_Project_Members
        [self checkTable:database
               tableName:TABLE_TT_Project_Members
               allFields:@[@"project_id",@"user_id",@"user_name",@"user_img_url"].mutableCopy
           allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
        //        TABLE_TT_Group
        [self checkTable:database
               tableName:TABLE_TT_Group
               allFields:@[@"group_id",@"group_name",@"pids",@"description",@"current_state",@"is_allow_delete",@"create_date",@"create_user_id",@"last_edit_date",@"last_edit_user_id"].mutableCopy
           allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"varchar",@"integer",@"boolean",@"timestamp",@"varchar",@"timestamp",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];

        
//        TABLE_TT_Project
//        [self checkTable:database
//               tableName:TABLE_TT_Project
//           allFields:@[@"project_id",@"name",@"description",@"is_private",@"current_state",@"is_allow_delete",@"create_date",@"create_user_id",@"last_edit_date",@"last_edit_user_id",@"is_grouped"].mutableCopy
//       allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"boolean",@"integer",@"boolean",@"timestamp",@"varchar",@"timestamp",@"varchar",@"boolean"].mutableCopy
//             primaryKeys:nil
//      isFieldTypeChanged:NO
//         ];
        
        [self checkTable:database
               tableName:TABLE_TT_Project
               allFields:@[@"project_id",@"name"].mutableCopy
           allFieldTypes:@[@"varchar",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
//        TABLE_TT_Notification
        [self checkTable:database
               tableName:TABLE_TT_Notification
           allFields:@[@"notifiction_id",@"is_read",@"content",@"type",@"is_removed",@"create_date",@"create_user_id",@"last_edit_date",@"last_edit_user_id"].mutableCopy
       allFieldTypes:@[@"varchar",@"boolean",@"varchar",@"integer",@"boolean",@"timestamp",@"varchar",@"timestamp",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];

    
//        TABLE_TT_Discuss_Result
        [self checkTable:database
               tableName:TABLE_TT_Discuss_Result
           allFields:@[@"discuss_result_id",@"discuss_id",@"discuss_result",@"discuss_result_description",].mutableCopy
           allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
//        TABLE_TT_Discuss
        [self checkTable:database
               tableName:TABLE_TT_Discuss
           allFields:@[@"discuss_id",@"project_id",@"discuss_type",@"head_image_url",@"user_name",@"discuss_label",@"content",@"current_state",@"is_allow_comment",@"is_allow_delete",@"create_date",@"create_user_id",@"last_edit_date",@"last_edit_user_id",@"is_has_image",@"is_has_result",@"comment_count"].mutableCopy
       allFieldTypes:@[@"varchar",@"varchar",@"integer",@"varchar",@"varchar",@"varchar",@"varchar",@"integer",@"boolean",@"boolean",@"timestamp",@"varchar",@"timestamp",@"varchar",@"boolean",@"boolean",@"integer"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
//      TABLE_TT_Comment
        [self checkTable:database
               tableName:TABLE_TT_Comment
           allFields:@[@"comment_id",@"discuss_id",@"content",@"name",@"at_name",@"is_allow_delete",@"create_date",@"create_user_id",@"last_edit_date",@"last_edit_user_id",@"is_has_image"].mutableCopy
       allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"varchar",@"varchar",@"boolean",@"timestamp",@"varchar",@"timestamp",@"varchar",@"boolean"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
//        TABLE_TT_Attachment
        [self checkTable:database
               tableName:TABLE_TT_Attachment
               allFields:@[@"attachment_id",@"current_item_id",@"attachment_url",@"attachment_content"].mutableCopy
           allFieldTypes:@[@"varchar",@"varchar",@"varchar",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];

       
        
//        TABLE_TT_At_Members
        [self checkTable:database
               tableName:TABLE_TT_At_Members
               allFields:@[@"at_members_id",@"current_item_id",@"user_id"].mutableCopy
           allFieldTypes:@[@"varchar",@"varchar",@"varchar"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        

        //add preparePredefineDatas
        [self preparePredefineDatas:database
                           commands:
         @[
           //groups
           @"delete from TT_Group",
           @"INSERT INTO TT_Group(group_id, group_name, pids, description, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id) VALUES('00001','我管理的项目','0001,0002',null,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao')",
           @"INSERT INTO TT_Group(group_id, group_name, pids, description, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id) VALUES('00002','我关注的项目','0002,0004',null,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao')",
           @"INSERT INTO TT_Group(group_id, group_name, pids, description, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id) VALUES('00003','南京的项目','0001,0002,0003,0004',null,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao')",
           @"INSERT INTO TT_Group(group_id, group_name, pids, description, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id) VALUES('00004','北京的项目','0001,0003',null,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao')",

           //projects
           @"delete from TT_Project",
           @"INSERT INTO TT_Project(project_id, name, description, is_private, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_grouped) VALUES('0001','工作牛',null,0,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao',1)",
           @"INSERT INTO TT_Project(project_id, name, description, is_private, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_grouped) VALUES('0002','易会',null,0,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao',1)",
           @"INSERT INTO TT_Project(project_id, name, description, is_private, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_grouped) VALUES('0003','末端融合',null,0,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao',1)",
           @"INSERT INTO TT_Project(project_id, name, description, is_private, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_grouped) VALUES('0004','电动汽车',null,0,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao',1)",
           @"INSERT INTO TT_Project(project_id, name, description, is_private, current_state, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_grouped) VALUES('0005','主网抢修',null,0,0,1,datetime('now','localtime'),'xxcao',datetime('now','localtime'),'xxcao',0)",
           
           //project members
           @"delete from TT_Project_Members",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000001','曹兴星','1.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000002','刘鹏','3.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000003','陈杰','5.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000004','赵瑞','7.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000005','琳琳','9.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000006','俞弦','11.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000007','董宇鹏','13.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000008','齐云猛','15.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000009','焦兰兰','17.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000010','严必庆','2.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0001','000011','陆毅全','4.png')",

           
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000012','刘德华','11.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000013','张学友','3.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000014','郭富城','4.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000015','黎明','6.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000016','周星驰','9.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000017','周润发','1.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000018','成龙','12.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0002','000019','张国荣','8.png')",
           
           
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000020','葫芦娃','11.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000021','路飞','3.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000022','鸣人','4.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000023','黑猫警长','6.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000024','阿童木','9.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000025','沙加','1.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000026','穆先生','12.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000027','索隆','7.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000028','佐助','13.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000029','喜洋洋','14.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000030','灰太狼','8.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0003','000031','白胡子','2.png')",
           
           
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000032','郭靖','1.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000033','杨过','2.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000034','慕容复','3.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000035','胡斐','4.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000036','阿朱','5.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000037','杨铁心','6.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000038','李寻欢','7.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000039','花无缺','8.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000040','沈浪','9.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000041','陆小凤','10.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0004','000042','楚留香','11.png')",

           
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000043','乾隆','2.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000044','万历','4.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000045','忽必烈','6.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000046','李世明','8.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000047','赵匡胤','10.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000048','明成祖','12.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000049','李寻欢','14.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000050','溥仪','3.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000051','魏武帝','5.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000052','秦始皇','7.png')",
           @"INSERT INTO TT_Project_Members(project_id, user_id, user_name, user_img_url) VALUES('0005','000053','光武帝','9.png')",
           
           

           //moments
           @"delete from TT_Discuss",
           @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00001', '0001', 0, '1.png', '唐小旭', '工作牛', '测试数据测试数据测试数据测试数据', 0, 1, 0, datetime('2016-11-17 09:45:00'), 'xxcao', datetime('2016-11-17 09:45:00'), 'xxcao', 1, 0, 4)",
           @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00002', '0002', 1, '2.png', '刘鹏', '易会', '测试数据测试数据测试数据测试数据', 0, 1, 0, datetime('2016-10-26 09:45:00'), 'xxcao', datetime('2016-10-26 09:45:00'), 'xxcao', 1, 1, 0)",
           @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00003', '0003', 0, '9.png', '唐小旭', '营配班组', '测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据', 0, 1, 0, datetime('2016-09-20 09:45:00'), 'xxcao', datetime('2016-09-20 09:45:00'), 'xxcao', 1, 0, 6)",
           @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00004', '0004', 0, '3.png', '曹兴星', '电动汽车', '测试数据测试数据测试数据', 0, 1, 0, datetime('2016-08-20 09:45:00'), 'xxcao', datetime('2016-08-20 09:45:00'), 'xxcao', 1, 0, 4)",
           @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00005', '0005', 0, '4.png', '赵瑞', '主网抢修', '测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据', 0, 1, 0, datetime('2016-08-10 09:30:00'), 'xxcao', datetime('2016-08-10 09:30:00'), 'xxcao', 1, 0, 3)",
            @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00006', '0001', 0, '10.png', '曹兴星', '工作牛', '测试数据测试数据测试数据测试数据测试数据测试数据', 0, 1, 0, datetime('2016-07-10 12:31:00'), 'xxcao', datetime('2016-07-10 12:31:00'), 'xxcao', 1, 0, 4)",
            @"INSERT INTO TT_Discuss(discuss_id, project_id, discuss_type, head_image_url, user_name, discuss_label, content, current_state, is_allow_comment, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image, is_has_result, comment_count) VALUES('D00007', '0005', 1, '2.png', '刘鹏', '主网抢修', '测试数据测试数据测试数据测试数据', 0, 1, 0, datetime('2016-06-10 12:20:00'), 'xxcao', datetime('2016-06-10 12:20:00'), 'xxcao',  1, 1, 0)",
           
           //discuss_result
           @"delete from TT_Discuss_Result",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00002_001', 'D00002', '7', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00002_002', 'D00002', '2', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00002_003', 'D00002', '1', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00007_001', 'D00007', '7', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00007_002', 'D00007', '2', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00007_003', 'D00007', '1', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00007_004', 'D00007', '3', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00007_005', 'D00007', '5', null)",
           @"INSERT INTO TT_Discuss_Result(discuss_result_id, discuss_id, discuss_result, discuss_result_description) VALUES('D00007_006', 'D00007', '9', null)",
           
           //comments
           @"delete from TT_Comment",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00001_C00001', 'D00001', '测试数据测试数据测试数据测试数据', '唐小旭', '@卞克', 0, datetime('2016-11-21 19:50:00'), 'xxcao', datetime('2016-11-21 19:50:00'), 'xxcao', 1)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00001_C00002', 'D00001', '哈哈哈', '卞克', '@唐小绪', 0, datetime('2016-07-26 13:55:00'), 'xxcao', datetime('2016-07-26 13:55:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00001_C00003', 'D00001', '有点意思', '俞弦', '', 0, datetime('2016-07-25 14:17:00'), 'xxcao', datetime('2016-07-25 14:17:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00001_C00004', 'D00001', '滴滴滴滴的', '齐云猛', '', 0, datetime('2016-07-18 09:30:00'), 'xxcao', datetime('2016-07-18 09:30:00'), 'xxcao', 0)",
           
            @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00003_C00001', 'D00003', '测试数据测试数据测试数据测试数据', '唐小旭', '@卞克', 0, datetime('2016-11-22 20:30:00'), 'xxcao', datetime('2016-11-22 20:30:00'), 'xxcao', 0)",
            @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00003_C00002', 'D00003', '哈哈哈', '曹兴星', '@唐小绪', 0, datetime('2016-07-23 15:05:00'), 'xxcao', datetime('2016-07-23 15:05:00'), 'xxcao', 1)",
            @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00003_C00003', 'D00003', '有点意思', '俞弦', '', 0, datetime('2016-07-22 12:01:00'), 'xxcao', datetime('2016-07-22 12:01:00'), 'xxcao', 0)",
            @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00003_C00004', 'D00003', '滴滴滴滴的', '齐云猛', '', 0, datetime('2016-07-22 11:30:00'), 'xxcao', datetime('2016-07-22 11:30:00'), 'xxcao', 0)",
            @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00003_C00005', 'D00003', '测试数据测试数据', '刘鹏', '', 0, datetime('2016-07-20 12:01:00'), 'xxcao', datetime('2016-07-20 12:01:00'), 'xxcao', 1)",
            @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00003_C00006', 'D00003', '滴滴滴滴的', '齐云猛', '', 0, datetime('2016-07-20 11:30:00'), 'xxcao', datetime('2016-07-20 11:30:00'), 'xxcao', 0)",
           
           
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00004_C00001', 'D00004', '测试数据测试数据测试数据测试数据', '唐小旭', '@卞克', 0, datetime('2016-07-23 20:30:00'), 'xxcao', datetime('2016-07-23 20:30:00'), 'xxcao', 1)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00004_C00002', 'D00004', '哈哈哈', '卞克', '@唐小绪', 0, datetime('2016-07-23 15:05:00'), 'xxcao', datetime('2016-07-23 15:05:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00004_C00003', 'D00004', '有点意思', '俞弦', '', 0, datetime('2016-07-23 12:01:00'), 'xxcao', datetime('2016-07-23 12:01:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00004_C00004', 'D00004', '滴滴滴滴的', '齐云猛', '', 0, datetime('2016-07-22 11:30:00'), 'xxcao', datetime('2016-07-22 11:30:00'), 'xxcao', 0)",
           
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00005_C00001', 'D00005', '测试数据测试数据测试数据测试数据', '唐小旭', '', 0, datetime('2016-07-24 20:30:00'), 'xxcao', datetime('2016-07-24 20:30:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00005_C00002', 'D00005', '哈哈哈', '卞克', '@唐小绪', 0, datetime('2016-07-24 15:05:00'), 'xxcao', datetime('2016-07-24 15:05:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00005_C00003', 'D00005', '有点意思', '俞弦', '', 0, datetime('2016-07-21 12:01:00'), 'xxcao', datetime('2016-07-21 12:01:00'), 'xxcao', 0)",
           
           
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00006_C00001', 'D00006', '测试数据测试数据测试数据测试数据', '唐小旭', '', 0, datetime('2016-08-21 19:50:00'), 'xxcao', datetime('2016-08-21 19:50:00'), 'xxcao', 1)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00006_C00002', 'D00006', '哈哈哈哈哈哈哈哈哈', '琳琳', '@卞克', 0, datetime('2016-08-20 13:55:00'), 'xxcao', datetime('2016-08-20 13:55:00'), 'xxcao', 0)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00006_C00003', 'D00006', '有点意思有点意思', '俞弦', '', 0, datetime('2016-08-16 20:17:00'), 'xxcao', datetime('2016-08-16 20:17:00'), 'xxcao', 1)",
           @"INSERT INTO TT_Comment(comment_id, discuss_id, content, name, at_name, is_allow_delete, create_date, create_user_id, last_edit_date, last_edit_user_id, is_has_image) VALUES('D00006_C00004', 'D00006', '滴滴滴滴的滴滴滴滴的滴滴滴滴的', '赵瑞', '', 0, datetime('2016-08-16 16:31:00'), 'xxcao', datetime('2016-08-16 16:31:00'), 'xxcao', 0)",

           
           //attachment
           @"delete from TT_Attachment",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000001', 'D00001', null, 'image_2.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000002', 'D00001', null, 'image_6.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000003', 'D00001', null, 'image_4.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000004', 'D00001', null, 'image_4.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000005', 'D00001_C00001', null, 'image_2.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000006', 'D00001_C00001', null, 'image_6.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000007', 'D00001_C00001', null, 'image_3.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000008', 'D00001_C00001', null, 'image_5.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000009', 'D00002', null, 'image_2.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000010', 'D00002', null, 'image_6.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000011', 'D00002', null, 'image_7.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000012', 'D00003', null, 'image_1.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000013', 'D00003', null, 'image_2.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000014', 'D00003', null, 'image_3.jpg')",
           
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000015', 'D00003_C00002', null, 'image_1.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000016', 'D00003_C00002', null, 'image_2.jpg')",
           
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000017', 'D00003_C00005', null, 'image_5.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000018', 'D00003_C00005', null, 'image_6.jpg')",
           
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000019', 'D00004', null, 'image_4.jpg')",
           
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000020', 'D00004_00001', null, 'image_8.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000021', 'D00004_00001', null, 'image_9.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000022', 'D00005', null, 'image_4.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000023', 'D00005', null, 'image_9.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000024', 'D00006', null, 'image_4.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000025', 'D00006_00001', null, 'image_2.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000026', 'D00006_00001', null, 'image_6.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000027', 'D00006_00001', null, 'image_1.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000028', 'D00006_00003', null, 'image_2.jpg')",

           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000029', 'D00007', null, 'image_2.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000030', 'D00007', null, 'image_6.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000031', 'D00007', null, 'image_7.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000032', 'D00007', null, 'image_1.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000033', 'D00007', null, 'image_8.jpg')",
           @"INSERT INTO TT_Attachment(attachment_id, current_item_id, attachment_url, attachment_content) VALUES('0000034', 'D00007', null, 'image_5.jpg')",
           ].mutableCopy
         ];

    }
    else {
        //T_APP_SETTINGS
        [self checkTable:database
               tableName:TABLE_APP_SETTINGS
           allFields:@[@"current_app_version",@"current_iPhone_OS",@"current_iPhone_type",@"current_server_address",@"current_server_port",@"last_login_user_id",@"last_login_date",@"last_login_user_name",@"last_login_user_pwd",@"current_login_user_id",@"current_login_date",@"current_login_user_name",@"current_login_user_pwd"].mutableCopy
        allFieldTypes:@[@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        
//            //add preparePredefineDatas
//            [self preparePredefineDatas:database
//                                        commands:
//             @[
//        
//        
//        
//                @"delete from T_APP_APPLICATION_MSG",
//                @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(1,'cf3ca900804743fc9334c5a8a4c4fc72','092ad3c991374d7a83ca62cb3f01c837','项目组已报批9月6日全网检修票。',1,1)"
//                ].mutableCopy
//             ];
        
    }
    return YES;
}

@end
