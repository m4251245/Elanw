//
//  MapSearchResult_DataModal.m
//  jobClient
//
//  Created by job1001 job1001 on 12-1-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapSearchResult_DataModal.h"


@implementation MapSearchResult_DataModal

@synthesize id_;
@synthesize uids_;
@synthesize cname_;
@synthesize longnum_;
@synthesize latnum_;
@synthesize regionid_;
@synthesize bHaveLooked_;


-(id) init
{
    self = [super init];
    
    bHaveLooked_ = NO;
    
    return self;
}

@end
