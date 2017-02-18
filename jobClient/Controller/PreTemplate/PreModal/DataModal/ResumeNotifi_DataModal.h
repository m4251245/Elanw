//
//  ResumeNotifi_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobSearch_DataModal.h"

@interface ResumeNotifi_DataModal : JobSearch_DataModal {
//    NSString                        *companyID_;
//    NSString                        *companyName_;
//    NSString                        *updateTime_;
    NSString                        *mailFlag_;                  //"已阅/未阅"，状态值
    NSString                        *boxID_;                    //此面试通知的id，用来查看面试通知的详情
    
}

//@property(nonatomic,retain) NSString                        *companyID_;
//@property(nonatomic,retain) NSString                        *companyName_;
//@property(nonatomic,retain) NSString                        *updateTime_;
@property(nonatomic,retain) NSString                        *mailFlag_;
@property(nonatomic,retain) NSString                        *boxID_;


@end
