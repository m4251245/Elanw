//
//  ELGroupSearchCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/10/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ELGroupListDetailModel.h"

//typedef NS_ENUM(NSInteger,searchFrom){
//    all,         //所有
//    mygroup,     //我的社群
//    jingxuan,    //精选
//    company,     //公司群
//    jobs,        //职业群
//};

typedef void (^MessageDetailSearchBolck)(ELGroupListDetailModel *dataModal);

@interface ELGroupSearchCtl : BaseListCtl

@property (nonatomic,assign) BOOL fromMessageDailog;
@property(nonatomic,copy) MessageDetailSearchBolck block;

@property(nonatomic, copy) NSString *searchFrom;

@property(nonatomic, copy) NSString *userId;

@end
