//
//  Status_DataModal.m
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "Status_DataModal.h"

@implementation Status_DataModal

@synthesize status_,code_,des_,exObj_,exObjArr_;

-(id) init
{
    self = [super init];

    status_ = Fail_Status;
    code_ = @"400";
    
    return self;
}

@end
