//
//  ELNewOfferPaiViewController.h
//  jobClient
//
//  Created by 一览ios on 16/10/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CHRIndexCtl.h"

@interface ELNewOfferPaiViewController : BaseListCtl

@property(nonatomic,copy)NSString *jobId_;
@property (nonatomic,assign) BOOL shouldRefresh;
@property (assign, nonatomic) ResumeType resumeType;

@end
