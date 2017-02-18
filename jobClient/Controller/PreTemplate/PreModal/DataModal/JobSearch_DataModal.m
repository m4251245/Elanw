//
//  JobSearch_DataModal.m
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JobSearch_DataModal.h"

@implementation JobSearch_DataModal

@synthesize companyID_;
@synthesize zwID_;
@synthesize zwName_;
@synthesize companyName_;
@synthesize regionName_;
@synthesize major_;
@synthesize updateTime_;
@synthesize zwFavKeyId_;
@synthesize bChoosed_;
@synthesize bRead_,jtzw_,cnameAll_,province_,city_,county,salary_,companyLogo_,welfareArray_,count_,edu_,gznum_,regionId_,tjNumber;

-(id) init
{
    self = [super init];
    
    if( self )
    {
        
        bChoosed_   = NO;
        bRead_      = NO;
    }
    
    return self;
}

- (instancetype)initWithPageInfoDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

@end
