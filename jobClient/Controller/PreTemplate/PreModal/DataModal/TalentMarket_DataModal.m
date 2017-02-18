//
//  TalentMarket_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TalentMarket_DataModal.h"


@implementation TalentMarket_DataModal

@synthesize name_;
@synthesize lat_;
@synthesize lng_;
@synthesize address_;
@synthesize phone_;
@synthesize bHaveLooked_;


-(id) init
{
    self = [super init];
    
    bHaveLooked_ = NO;
    
    return self;
}

@end
