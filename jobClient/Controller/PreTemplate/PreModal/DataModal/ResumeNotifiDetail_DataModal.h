//
//  ResumeNotifiDetail_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 面试通知详情的DataModal
 ********************************************/

#import <Foundation/Foundation.h>


@interface ResumeNotifiDetail_DataModal : NSObject {
    NSString                *regionID_;         //地区名称
    NSString                *sendUID_;          //公司的id
    NSString                *sendName_;         //公司名称
    NSString                *sendDate_;         //面试日期
    NSString                *mailText_;         //备注
}

@property(nonatomic,retain) NSString                *regionID_;
@property(nonatomic,retain) NSString                *sendUID_;
@property(nonatomic,retain) NSString                *sendName_;
@property(nonatomic,retain) NSString                *sendDate_;
@property(nonatomic,retain) NSString                *mailText_;

@end
