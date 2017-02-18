//
//  TalentMarket_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************************
        人才market数据模块
 ********************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface TalentMarket_DataModal : PageInfo {
    NSString                            *name_; //名称
    NSString                            *lat_;
    NSString                            *lng_;
    NSString                            *address_;  //地址
    NSString                            *phone_;    //电话
    
    BOOL                                bHaveLooked_;
}

@property(nonatomic,retain) NSString            *name_;
@property(nonatomic,retain) NSString            *lat_;
@property(nonatomic,retain) NSString            *lng_;
@property(nonatomic,retain) NSString            *address_;
@property(nonatomic,retain) NSString            *phone_;
@property(nonatomic,assign) BOOL                bHaveLooked_;

@end
