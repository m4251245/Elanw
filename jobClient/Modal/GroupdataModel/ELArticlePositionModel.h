//
//  ELArticlePositionModel.h
//  jobClient
//
//  Created by 一览iOS on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELArticlePositionModel : PageInfo

@property(nonatomic,copy) NSString *id_;
@property(nonatomic,copy) NSString *jtzw;
@property(nonatomic,copy) NSString *regionid;
@property(nonatomic,copy) NSString *region_name;
@property(nonatomic,copy) NSString *cname_all;
@property(nonatomic,copy) NSString *logopath;
@property(nonatomic,copy) NSString *uid;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
