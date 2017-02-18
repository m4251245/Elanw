//
//  MyComment_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-11-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyComment_DataModal.h"


@implementation MyComment_DataModal

@synthesize id_;
@synthesize projectIndity_;
@synthesize objId_;
@synthesize objName_;
@synthesize pId_;
@synthesize name_;
@synthesize personId_;
@synthesize bHide_;
@synthesize content_;
@synthesize title_;
@synthesize good_;
@synthesize bad_;
@synthesize score_;
@synthesize updateTime_;
@synthesize clientName_;
@synthesize companyId_;
@synthesize replyCnt_;
@synthesize agreetCnt_;

-(id) init
{
    self = [super init];
    
    replyCnt_ = 0;
    agreetCnt_ = 0;
    
    bHide_ = NO;
    
    return self;
}

@end
