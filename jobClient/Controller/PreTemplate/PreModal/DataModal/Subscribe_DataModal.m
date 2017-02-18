//
//  Subscribe_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Subscribe_DataModal.h"

@implementation Subscribe_DataModal

@synthesize subscribeId_;
@synthesize personId_;
@synthesize sId_;
@synthesize sname_;
@synthesize cId_;
@synthesize cname_;
@synthesize regionId_;
@synthesize subscribeType_;
@synthesize bHaveNewMsg_;
@synthesize msgCnt_;


-(id) init{
    self = [super init];
    
    bHaveNewMsg_ = NO;
    
    
    return self;
}


@end
