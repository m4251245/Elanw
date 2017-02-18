//
//  Upload_DataModal.m
//  MBA
//
//  Created by 一览iOS on 13-12-30.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "Upload_DataModal.h"

@implementation Upload_DataModal

@synthesize name_,size_,exe_,path_,pathArr_;

- (instancetype)init
{
    self = [super init];
    if (self) {
        pathArr_ = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
