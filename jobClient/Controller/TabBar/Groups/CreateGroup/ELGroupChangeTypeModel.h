//
//  ELGroupChangeTypeModel.h
//  jobClient
//
//  Created by 一览iOS on 16/8/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupChangeTypeModel : PageInfo

@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *detailStatus;
@property(nonatomic,copy) NSMutableArray *publishArr;
@property(nonatomic,copy) NSMutableArray *inviteArr;

@end
