//
//  NearPositionDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface NearPositionDataModel : PageInfo
@property (nonatomic, copy) NSString *positionId;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *gznum;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *jtzw;
@property (nonatomic, copy) NSString *geo_diff;
@property (nonatomic, copy) NSString *logopath;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *jobtypes;
@property (nonatomic, copy) NSString *zpnum;
@property (nonatomic, copy) NSString *latnum;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *Longnum;

@property (nonatomic, strong) NSArray *com_tag;
@end
