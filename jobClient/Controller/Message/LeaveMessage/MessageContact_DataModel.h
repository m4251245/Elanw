//
//  MessageContact_DataModel.h
//  jobClient
//
//  Created by 一览ios on 14/12/11.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface MessageContact_DataModel : PageInfo

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *lastDateTime;
@property(nonatomic, copy) NSString *isExpert;
@property(nonatomic, copy) NSString *userIname;
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *gzNum;
@property(nonatomic, copy) NSString *userZW;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *sameSchool;
@property(nonatomic, copy) NSString *sameCity;
@property(nonatomic, copy) NSString *sameHKA;
@property(nonatomic, copy) NSString *isNew;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, assign) BOOL       boolHrFlag;
@property(nonatomic, assign) BOOL       boolGWFlag;
@property (assign, nonatomic) BOOL  inEditing;

@end
