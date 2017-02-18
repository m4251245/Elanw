//
//  OfferPartyCompanyResumeModel.m
//  jobClient
//
//  Created by YL1001 on 16/9/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "OfferPartyCompanyResumeModel.h"

@implementation OfferPartyCompanyResumeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{

    [super setValue:value forKey:key];
    
    _notOperating = NO;
    if ([self.company_state isEqualToString:@"0"]) {
        _notOperating = YES;
    }
    else if ([self.company_state isEqualToString:@"1"]) {
        _resumeType = OPResumeTypeConfirmFit;
    }
    else if ([self.company_state isEqualToString:@"2"]) {
        _resumeType = OPResumeTypeNoConfirFit;
    }
    else if ([self.company_state isEqualToString:@"3"]) {
        _resumeType = OPResumeTypeWait;
        _notOperating = YES;
    }

    if ([self.mianshi_state isEqualToString:@"6"]) {
        _resumeType = OPResumeTypeInterviewed;
    }
    else if ([self.mianshi_state isEqualToString:@"7"]) {
        _resumeType = OPResumeTypeInterviewUnqualified;
    }
    else if ([self.mianshi_state isEqualToString:@"0"]) {
        self.mianshi_state = value;
    }
    
    if ([self.luyong_state isEqualToString:@"1"]) {
        _resumeType = OPResumeTypeSendOffer;
    }
    
    if ([self.work_state isEqualToString:@"1"]) {
        _resumeType = OPResumeTypeWorked;
    }
}

@end
