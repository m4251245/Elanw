//
//  ZWModel.m
//  jobClient
//
//  Created by 一览ios on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ZWModel.h"
#import "CondictionListCtl.h"
#import "FBCondictionCtl.h"

@implementation ZWModel

-(ZWModel *)initWithDictionary:(NSDictionary *)dic;
{
    self = [super init];
    if (self)
    {
        self.jwId = dic[@"id"];
        self.regionid = dic[@"regionid"];
        self.region = dic[@"regionname"];
        int gznum1 = [dic[@"gznum1"] intValue];
        int gznum2 = [dic[@"gznum2"] intValue];
        self.gznumId = [NSString stringWithFormat:@"%d",gznum1];
        self.gznumId1 = [NSString stringWithFormat:@"%d",gznum2];
      
        self.gznum = [FBCondictionCtl getWorkAgeNameWithStart:self.gznumId end:self.gznumId1];
        if (self.gznum.length <= 0)
        {
            self.gznum = @"不限";
        }
        
        self.jtzw = dic[@"jtzw"];
        self.deptId = dic[@"deptId"];
        self.deptName = dic[@"deptName"];
        self.zp_urlId = dic[@"urlId"];
        self.zp_urlName = dic[@"homename"];
        self.email = dic[@"email"];
        self.eduId = dic[@"eduId"];
        self.edu = [FBCondictionCtl getEduNameWith:self.eduId];
        self.zptext = dic[@"zptxt"];
        self.salary = [NSString stringWithFormat:@"%@-%@",dic[@"minsalary"],dic[@"maxsalary"]];
        self.zpnum = dic[@"zpnum"];
        self.job = dic[@"parentName"];
        self.job_child = dic[@"childName"];
    }
    return self;
}

@end
