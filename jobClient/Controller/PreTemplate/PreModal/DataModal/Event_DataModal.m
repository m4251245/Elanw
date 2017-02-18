//
//  Event_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Event_DataModal.h"

@implementation Event_DataModal

@synthesize eventId_;
@synthesize navTitle_;
//@synthesize id_;
@synthesize bRepeat_;
@synthesize bAllDay_;
//@synthesize title_;
@synthesize location_;
@synthesize startDate_;
@synthesize endDate_;
@synthesize firstAlertDateTime_;
@synthesize secondAlertDateTime_;
@synthesize notes_;
//@synthesize cid_;
//@synthesize cname_;
//@synthesize sid_;
//@synthesize sname_;
//@synthesize regionId_;
//@synthesize addr_;
//@synthesize sdate_;

-(id) init
{
    self = [super init];
    
    eventType_ = Event_Null;
    
    bRepeat_ = NO;
    bAllDay_ = NO;
    
    notes_ = [NSString stringWithFormat:@"%@事件提醒",Client_Name];
    
    return self;
}

@end
