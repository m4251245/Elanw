//
//  Person_trainDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/5/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//  培训经历

#import <Foundation/Foundation.h>

@interface Person_trainDataModel : NSObject
@property (nonatomic, copy) NSString *train_cource;
@property (nonatomic, copy) NSString *train_id;
@property (nonatomic, copy) NSString *train_startdate;
@property (nonatomic, copy) NSString *train_enddate;
@property (nonatomic, copy) NSString *train_istonow;
@property (nonatomic, copy) NSString *train_region;
@property (nonatomic, copy) NSString *train_institution;
@property (nonatomic, copy) NSString *train_isshow;
@property (nonatomic, copy) NSString *train_desc;
@property (nonatomic, copy) NSString *personId;
@end
