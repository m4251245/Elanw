//
//  DataBase.h
//  changeRegion
//
//  Created by 一览iOS on 14-12-15.
//  Copyright (c) 2014年 TestDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBase : NSObject

@property (nonatomic,strong) FMDatabase *database;
@property (nonatomic,strong) NSMutableArray *list;

+(DataBase *)shareDatabase;
-(id)init;
-(NSMutableArray *)selectWithString:(NSString *)str;

@end
