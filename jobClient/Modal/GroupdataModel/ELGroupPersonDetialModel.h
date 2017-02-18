//
//  ELGroupPersonDetialModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELSameTradePeopleModel.h"

@interface ELGroupPersonDetialModel : PageInfo

@property (nonatomic, copy) NSString *gp_id;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *group_user_role;
@property (nonatomic, copy) NSString *idatetime;
@property (nonatomic, copy) NSString *topic_publish;
@property (nonatomic, copy) NSString *member_invite;

@property (nonatomic, strong) ELSameTradePeopleModel *group_person_detail;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
