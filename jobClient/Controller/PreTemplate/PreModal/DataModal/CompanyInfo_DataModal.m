//
//  CompanyInfo_DataModal.m
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CompanyInfo_DataModal.h"


@implementation CompanyInfo_DataModal

@synthesize companyID_;
@synthesize email_;
@synthesize cname_;
@synthesize cxz_;
@synthesize yuangong_;
@synthesize phone_;
@synthesize fax_;
@synthesize address_;
@synthesize regionid_;
@synthesize classid_;
@synthesize trade_;
@synthesize des_,logoPath_,albumArr_,weblink_,tradeId_,totalId_,followStatus_,employeeArr_,shareArr_,culture_,developmentArr_,hrAnwerArr_,teamArr_,zwArr_,addInfo_,answerModal_,answerSum_,picSum_,zwSum_,followNum_,resumeCnt_,interviewCnt_,questionCnt_;

-(id)init
{
    self = [super init];
    if (self) {
        self.albumArr_ = [[NSMutableArray alloc] init];
        self.zwArr_ = [[NSMutableArray alloc] init];
        culture_ = [[CultureContent_DataModal alloc] init];
        answerModal_ = [[CompanyHRAnswer_DataModal alloc] init];
    }
    return self;
}


@end

@implementation ELCompanyInfoModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key]; 
}

@end
