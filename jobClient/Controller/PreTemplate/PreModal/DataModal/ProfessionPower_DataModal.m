//
//  ProfessionPower_DataModal.m
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProfessionPower_DataModal.h"


@implementation ProfessionPower_DataModal

@synthesize newsID_;
@synthesize newsTitle_;
@synthesize newsCount_;
@synthesize newsDate_;
@synthesize imagePath_;
@synthesize preId_;
@synthesize preTitle_;
@synthesize preQikan_;
@synthesize nextId_;
@synthesize nextTitle_;
@synthesize nextQikan_;
@synthesize newsContent_;
@synthesize newsAuthor_;
@synthesize status_;
@synthesize code_;
@synthesize msg_;
@synthesize imageData_;
@synthesize bImageDataLoaded_;


-(id) init
{
    self = [super init];
    
    if( self )
    {        
        bImageDataLoaded_ = NO;
    }
    
    return self;
}

@end
