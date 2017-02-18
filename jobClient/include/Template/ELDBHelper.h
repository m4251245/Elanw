//
//  ELDBHelper.h
//  jobClient
//
//  Created by 一览ios on 16/10/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@interface ELDBHelper : NSObject
+(FMDatabase *)getDB;
@end
