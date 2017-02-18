//
//  ELActivityPeopleFrameCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/6/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELActivityPeopleModel.h"

@interface ELActivityPeopleFrameModel : PageInfo

@property (nonatomic,strong) ELActivityPeopleModel *peopleModel;
@property (nonatomic,copy) NSString *agreeStatus;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) NSMutableArray *arrListData;

@end


