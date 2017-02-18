//
//  ELNewsListDAO.h
//  jobClient
//
//  Created by 一览ios on 2016/12/23.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ELNewNewsListVO;
@interface ELNewsListDAO : NSObject

-(BOOL)save:(ELNewNewsListVO *)vo;
-(BOOL)deleteData:(NSString *)infoId type:(NSString *)type;
-(BOOL)deleteAll;

-(NSArray *)showAll:(NSString *)personId;

//-(NSArray *)showAll:(NSString *)personId pageindex:(NSInteger)pIdx pagesize:(NSInteger)pSize;

-(BOOL)updateData:(NSArray *)dataArr;
-(BOOL)updateOneData:(ELNewNewsListVO *)vo;
//查找某条数据
-(ELNewNewsListVO *)findByType:(NSString *)type info:(NSString *)infoId personId:(NSString *)personId close:(BOOL)close;

@end
