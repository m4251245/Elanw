//
//  Answer_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-3-6.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Answer_DataModal.h"

@implementation Answer_DataModal
@synthesize answerId_,collectCnt_,commentCnt_,content_,supportCnt_,sysUpdatetime_,lastUpdatetime,managerstatus_,questionId_,questionTitle_,quizzerId_,quizzerName_,reportCnt_,unsupportCnt_,quesLastUpdate_,quesReplyCnt_,quesViewCnt_,quesFollowCnt_,isMine_,bImageLoad_,imageData_,img_,expertName_,expertgznum_,expertJob_,expertId_,expert_,ask_expert_,questionTime_,anserTime_,isSupport_,questionContent_;

-(id)init
{
    self = [super init];
    self.expert_ = [[Expert_DataModal alloc] init];
    self.ask_expert_ = [[Expert_DataModal alloc] init];
    return  self;
}

@end
