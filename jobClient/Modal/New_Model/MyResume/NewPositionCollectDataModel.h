//
//  NewPositionCollectDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface NewPositionCollectDataModel : PageInfo
@property (nonatomic, copy) NSString *positionId;
@property (nonatomic, copy) NSString *pf_id;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *jtzw;
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *xzdy;
@property (nonatomic, copy) NSString *idate;
@property (nonatomic, copy) NSString *zptype;
@property (nonatomic, assign) BOOL isSeleted_;
@property (nonatomic, strong) NSArray *fldy;

@property (nonatomic, copy) NSString *is_ky;

@end
