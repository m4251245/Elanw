//
//  Home_DataModal.m
//  Association
//
//  Created by 一览iOS on 14-1-16.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "Home_DataModal.h"

@implementation Home_DataModal
@synthesize type_,typeId_,articleArray_,personInfo,updatetime_,groupInfo;

-(id) init
{
    self = [super init];
    if (!articleArray_) {
         articleArray_ = [[NSMutableArray alloc] init];
    }
    
    
    return self;
}


@end
