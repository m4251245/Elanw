//
//  DownloadResumeListCtl.h
//  jobClient
//
//  Created by YL1001 on 15/1/26.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CHRIndexCtl.h"

@interface DownloadResumeListCtl : BaseListCtl

@property (nonatomic,assign) BOOL shouldRefresh;
@property (assign, nonatomic) ResumeType resumeType;

@end
