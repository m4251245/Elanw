//
//  JobGuideExpertModal.h
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface JobGuideExpertModal : PageInfo

/*
 职导行家列表
 */
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_signature;
@property (nonatomic, copy) NSString *person_region;
@property (nonatomic, copy) NSString *person_type;
@property (nonatomic, copy) NSString *answer_cnt;
@property (nonatomic, assign) NSInteger expertType;

@property (nonatomic, strong) NSDictionary *course_info;
@property (nonatomic, strong) NSDictionary *expert_detail;

@end
