//
//  CondictionList_DataModal.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionList_DataModal.h"


//编解码时对应的Key值
//#define ParentIDKey             @"parentID"
//#define MyIDKey                 @"myID"
//#define MyNameKey               @"myName"
//#define bParentKey              @"bParent"

 NSString *ParentIDKey = @"parentID";
 NSString *MyIDKey = @"myID";
 NSString *MyNameKey = @"myName";
 NSString *bParentKey = @"bParent";


@implementation CondictionList_DataModal

@synthesize str_;
@synthesize id_;
@synthesize id_1;
@synthesize pId_;
@synthesize pic_;
@synthesize bParent_;
@synthesize bAttention_;
@synthesize bSelected_;

-(id) init
{
    self = [super init];
    
    if( self )
    {
        bParent_ = NO;
        bSelected_ = NO;
        bAttention_ = NO;
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:pId_ forKey:ParentIDKey];
    [aCoder encodeObject:id_ forKey:MyIDKey];
    [aCoder encodeObject:str_ forKey:MyNameKey];
    [aCoder encodeBool:bParent_ forKey:bParentKey];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    pId_        = [aDecoder decodeObjectForKey:ParentIDKey];
    id_         = [aDecoder decodeObjectForKey:MyIDKey];
    str_        = [aDecoder decodeObjectForKey:MyNameKey];
    bParent_    = [aDecoder decodeBoolForKey:bParentKey];
    
    return self;
}

@end
