//
//  ELGroupListTwoModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupListTwoModel : PageInfo

@property (nonatomic, copy) NSString *group_code;
@property (nonatomic, copy) NSString *info_type;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *group_id;
@property(nonatomic,strong) NSMutableArray *person_list;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
