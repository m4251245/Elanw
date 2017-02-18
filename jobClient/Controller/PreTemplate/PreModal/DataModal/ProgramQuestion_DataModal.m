//
//  ProgramQuestion_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProgramQuestion_DataModal.h"


@implementation ProgramQuestion_DataModal

@synthesize id_;
@synthesize question_;
@synthesize type_;
@synthesize classFlag_;
@synthesize otherFlag_;
@synthesize classType_;
@synthesize answerArr_;
@synthesize totalCnt_;
@synthesize testCnt_;
@synthesize lessCnt_;

-(id) init
{
    totalCnt_   = 0;
    testCnt_    = 0;
    lessCnt_    = 0;
    
    return self;
}

@end
