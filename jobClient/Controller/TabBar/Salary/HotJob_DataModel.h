//
//  HotJob_DataModel.h
//  jobClient
//
//  Created by YL1001 on 15/4/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotJob_DataModel : NSObject

@property(strong,nonatomic) NSString        *   jobId;
@property(strong,nonatomic) NSString        *   jobName;
@property(strong,nonatomic) NSString        *   pic;
@property(strong,nonatomic) NSMutableArray  *   subArray;

@end
