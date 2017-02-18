//
//  ELUserJobModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELUserJobModel : PageInfo
@property(nonatomic, copy) NSString *company;
@property(nonatomic, copy) NSString *jtzw;
@property(nonatomic, copy) NSString *startdate;
@property(nonatomic, copy) NSString *stopdate;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
