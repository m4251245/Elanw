//
//  Publisher_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 13-3-11.
//
//

#import "Publisher_DataModal.h"

@implementation Publisher_DataModal

@synthesize id_;
@synthesize publisherIdType_;
@synthesize name_;
@synthesize pic_;
@synthesize title_;
@synthesize dateDes_;
@synthesize newMsgCnt_;
@synthesize bImageLoad_;
@synthesize imageData_;

-(id) init
{
    self = [super init];
    
    newMsgCnt_ = 0;
    
    return self;
}

@end
