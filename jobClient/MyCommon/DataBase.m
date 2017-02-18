//
//  DataBase.m
//  changeRegion
//
//  Created by 一览iOS on 14-12-15.
//  Copyright (c) 2014年 TestDemo. All rights reserved.
//

#import "DataBase.h"
#import "SqlitData.h"
#import "Common.h"


@interface DataBase()

@end


@implementation DataBase

+(DataBase *)shareDatabase
{
    static DataBase *database;
    if (database == nil) {
        database = [[DataBase alloc] init];
    }
    return database;
}
-(id)init
{
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [Common getSandBoxPath:@"data.db"];
        if( ![fileManager fileExistsAtPath:filePath] ){
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"data.db"]];
            [data writeToFile:[Common getSandBoxPath:@"data.db"] atomically:YES];
        }
        self.database = [FMDatabase databaseWithPath:filePath];
        self.list = [[NSMutableArray alloc] init];
    }
    return self;
}
-(NSMutableArray *)selectWithString:(NSString *)str;
{
    [self.list removeAllObjects];
    if ([self.database open]) {
        FMResultSet *set = [self.database executeQuery:str];
        while ([set next]) {
            SqlitData *data = [[SqlitData alloc] init];
            data.provinceName = [set stringForColumn:@"provinceName"];
            data.stringId = [set stringForColumn:@"id"];
            data.provinceld = [set stringForColumn:@"provinceId"];
            data.parentld = [set stringForColumn:@"parentId"];
            data.level = [set stringForColumn:@"level"];
            [self.list addObject:data];
        }
    }
    [self.database close];
    return self.list;
}

@end
