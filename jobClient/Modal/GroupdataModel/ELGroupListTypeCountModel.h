//
//  ELGroupListTypeCountModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupListTypeCountModel : PageInfo

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *pic;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
