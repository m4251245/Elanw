//
//  CompanyOtherHR_DataModal.h
//  jobClient
//
//  Created by YL1001 on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "User_DataModal.h"

@interface CompanyOtherHR_DataModal : User_DataModal

@property(nonatomic,copy) NSString * contactId_;
@property(nonatomic,copy) NSString * companyId_;
@property(nonatomic,copy) NSString * contactPhone_;
@property(nonatomic,copy) NSString * contactMobl_;
@property(nonatomic,copy) NSString * contactEmail_;
@property(nonatomic,copy) NSString * contactZW_;
@property(nonatomic,copy) NSString * constate_;
@property(nonatomic,copy) NSString * contactAddress_;
@property(nonatomic,assign) BOOL       bChoosed_;

@end
