//
//  ELGroupCountModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupCountModel : PageInfo

@property (nonatomic, copy) NSString *question_count;
@property (nonatomic, copy) NSString *letter_count;
@property (nonatomic, copy) NSString *answer_count;
@property (nonatomic, copy) NSString *publish_count;
@property (nonatomic, copy) NSString *groups_count;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *follow_count;
@property (nonatomic, copy) NSString *groups_mine_count;
@property (nonatomic, copy) NSString *company_count;
@property (nonatomic, copy) NSString *prestige_count;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
