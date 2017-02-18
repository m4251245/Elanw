//
//  CounselorOfferPartyResumeListCtl.h
//  jobClient
//
//  Created by YL1001 on 16/9/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"
#import "OfferPartyResumeEnumeration.h"

@interface CounselorOfferPartyResumeListCtl : ELBaseListCtl

@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *jobfair_time;
@property (nonatomic, copy) NSString *fromtype;

@property (nonatomic, assign) OPResumeListType resumeListType;

@end
