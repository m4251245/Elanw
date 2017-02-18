//
//  InbiddingJobCtl.h
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CompanyInfo_DataModal.h"

@interface InbiddingJobCtl : BaseListCtl

{
    __weak IBOutlet UIButton *fabuBtn;
}

@property(nonatomic,strong) CompanyInfo_DataModal *companyDetailModal;

@end
