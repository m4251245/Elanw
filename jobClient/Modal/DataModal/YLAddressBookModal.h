//
//  YLAddressBookModal.h
//  jobClient
//
//  Created by 一览iOS on 15/6/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface YLAddressBookModal : PageInfo

@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *personId;
@property(nonatomic,copy) NSString *phoneNumber;
@property(nonatomic,copy) NSString *follow_rel;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *pic;
@property(nonatomic,copy) NSString *group_rel;
@property(nonatomic,strong) NSMutableArray *arrListPhone;

@end
