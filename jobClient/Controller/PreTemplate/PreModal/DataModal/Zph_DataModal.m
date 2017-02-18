//
//  Zph_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Zph_DataModal.h"


@implementation Zph_DataModal

@synthesize id_;
@synthesize title_;
@synthesize sid_;
@synthesize sname_;
@synthesize regionId_;
@synthesize addr_;
@synthesize sdate_;
@synthesize week_;
@synthesize bHaveAdd_;
@synthesize addCnt_;
@synthesize bRead_;
@synthesize eventType_;
@synthesize attentionCnt_;

-(id) init
{
    self = [super init];
    
    bHaveAdd_ = NO;
    addCnt_ = -1;
    
    bRead_ = NO;
    eventType_ = Event_Recruitment;
    attentionCnt_ = 0;
    
    return self;
}

@end
