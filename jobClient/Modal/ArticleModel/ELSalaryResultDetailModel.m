//
//  ELSalaryResultDetailModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSalaryResultDetailModel.h"
#import "UserJob_DataModal.h"
#import "ELSalaryModel.h"
#import "ELJobSearchModel.h"
#import "ELUserJobModel.h"

@implementation ELSalaryResultDetailModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//        [subDic removeObjectForKey:@"person_info"];
        NSMutableDictionary *firDic = subDic[@"percent_info"];
        [subDic removeObjectForKey:@"percent_info"];
        if ([firDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:firDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
   
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"person_info"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.userInfo = [[ELUserModel alloc] initWithDictionary:value];
        }
    }else if ([key isEqualToString:@"work_list"]){
        NSArray *jobarr = value;
        if (jobarr && jobarr != NULL) {
            self.jobArr = [[NSMutableArray alloc] init];
            for (NSDictionary *jobDic in jobarr) {
                ELUserJobModel *jobModel = [[ELUserJobModel alloc] initWithDictionary:jobDic];
                
                [self.jobArr addObject:jobModel];
            }

        }
    }else if ([key isEqualToString:@"gxs_list"]){
        NSArray *gxsArr = value;
        if (gxsArr && gxsArr != NULL) {
            self.gxsArticleArr = [[NSMutableArray alloc] init];
            for (NSDictionary *artDic in gxsArr) {
                ELSalaryModel *salaryModel = [[ELSalaryModel alloc] initWithDictionary:artDic];
                [self.gxsArticleArr addObject:salaryModel];
            }
        }
        
    }else if ([key isEqualToString:@"reco_position"]){
        NSArray *zwArr = value;
        if (zwArr && zwArr != NULL) {
            self.recommendJobArr = [[NSMutableArray alloc] init];
            for (NSDictionary *zwDic in zwArr) {
                ELJobSearchModel *zwModel = [[ELJobSearchModel alloc] initWithDictionary:zwDic];
                [self.recommendJobArr addObject:zwModel];
            }
        }
    }
    
    else{
        [super setValue:value forKey:key];
    }
}
@end
