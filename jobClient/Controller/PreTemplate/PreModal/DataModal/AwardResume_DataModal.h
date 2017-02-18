//
//  AwardResume_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/********************************
 
 简历修改->奖项dataModal
 ********************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface AwardResume_DataModal : PageInfo {
    NSString                    *awardId_;      //主键
    NSString                    *personId_;     //人才id
    NSString                    *awardDesc_;    //奖项描述
    NSString                    *awardDate_;    //所获时间
}

@property(nonatomic,retain) NSString                    *awardId_;
@property(nonatomic,retain) NSString                    *personId_;
@property(nonatomic,retain) NSString                    *awardDesc_;
@property(nonatomic,retain) NSString                    *awardDate_;
@property(nonatomic,assign) NSInteger                   cellIndex;

@end
