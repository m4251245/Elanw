//
//  UserJob_DataModal.h
//  jobClient
//
//  Created by YL1001 on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface UserJob_DataModal : PageInfo

@property(nonatomic,strong) NSString * zwName_;
@property(nonatomic,strong) NSString * stratDate_;
@property(nonatomic,strong) NSString * endDate_;
@property(nonatomic,strong) NSString * cname_;
@property(nonatomic,strong) NSString * gznum_;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
