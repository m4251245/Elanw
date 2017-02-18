//
//  MyCntInfo_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-14.
//
//

#import "MyCntInfo_DataModal.h"

@implementation MyCntInfo_DataModal

@synthesize xjhCnt_;
@synthesize zphCnt_;
@synthesize msgCnt_;
@synthesize newMsgCnt_;


-(id) init
{
    self = [super init];
    
    xjhCnt_ = 0;
    zphCnt_ = 0;
    msgCnt_ = 0;
    newMsgCnt_ = 0;
    
    return self;
}

@end
