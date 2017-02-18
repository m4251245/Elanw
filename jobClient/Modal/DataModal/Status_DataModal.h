//
//  Status_DataModal.h
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 请求状态
 Status_DataModal
 
 ******************************/

#define Success_Code            @"100"
#define Success_Status          @"OK"
#define Fail_Status             @"FAIL"

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface Status_DataModal : PageInfo

@property(nonatomic,strong) NSString    *status_;   //状态
@property(nonatomic,strong) NSString    *code_;     //code
@property(nonatomic,strong) NSString    *des_;      //描述
@property(nonatomic,strong) NSString    *exObj_;    //额外的obj
@property(nonatomic,strong) NSArray     *exObjArr_; //额外的Arr
@property(nonatomic,strong) NSDictionary * exDic_;
@property(nonatomic,strong) NSString    *status_desc;
@property(nonatomic,strong) NSString    *leftgjcnt;
@property(nonatomic,strong) NSString    *leftptcnt;
@property(nonatomic,copy) NSString * is_binding; //1 未绑定   2 绑定


@end
