//
//  BadgeModal.h
//  jobClient
//
//  Created by 一览iOS on 15-3-3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface BadgeModal : PageInfo

@property (nonatomic,strong) NSString *ylb_id;
@property (nonatomic,strong) NSString *ylb_name;
@property (nonatomic,strong) NSString *ylb_pic;
@property (nonatomic,strong) NSString *ylb_pic_gray;
@property (nonatomic,strong) NSString *ylb_desc;
@property (nonatomic,strong) NSString *ypb_person_id;
@property (nonatomic,strong) NSString *idatetime;
@property (nonatomic,strong) NSString *ylb_code;
@property (nonatomic,assign) BOOL isbadge;


@property (nonatomic,strong) NSString *prestige;
@property (nonatomic,strong) NSString *personId;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *actionId;
@property (nonatomic,strong) NSString *slave;
@property (nonatomic,assign) BOOL isOtherUser;


-(BadgeModal *)initWithDictionary:(NSDictionary *)subDic;

-(BadgeModal *)initWithDictionaryTwo:(NSDictionary *)subDic;
@end
