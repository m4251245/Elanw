//
//  SysNotification_DataModal.h
//  jobClient
//
//  Created by YL1001 on 14/10/31.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface SysNotification_DataModal : PageInfo

@property(nonatomic,strong) NSString * userImg_;
@property(nonatomic,strong) NSString * userName_;
@property(nonatomic,assign) BOOL       userbExpert_;
@property(nonatomic,strong) NSString * content_;
@property(nonatomic,strong) NSString * datetime_;
@property(nonatomic,strong) NSString * type_;
@property(nonatomic,strong) NSString * userId_;
@property(nonatomic,strong) NSString * groupId_;
@property(nonatomic,strong) NSString * kw_;
@property(nonatomic,strong) NSString * salary_;
@property(nonatomic,strong) NSString * regionId_;
@property(nonatomic,strong) NSString * productId_;
@property(nonatomic,strong) NSString * companyId_;
@property(nonatomic,strong) NSString * companyName_;
@property(nonatomic,strong) NSString * url_;
@property(nonatomic,strong) NSString * detailContent;

-(instancetype)initWithDictionary:(NSDictionary *)subDic;

@end
