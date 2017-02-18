//
//  ELGroupPersonModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupPersonModel : PageInfo

@property (nonatomic, copy) NSString *person_name;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *person_nickname;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
