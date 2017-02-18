//
//  WhoLikeMeDataModal.h
//  jobClient
//
//  Created by 一览iOS on 15/5/21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface WhoLikeMeDataModal : PageInfo

@property (nonatomic,copy) NSString *yp_id;
@property (nonatomic,copy) NSString *yp_type;
@property (nonatomic,copy) NSString *yp_type_code;
@property (nonatomic,copy) NSString *idatetime;
@property (nonatomic,copy) NSString *personId;
@property (nonatomic,copy) NSString *person_iname;
@property (nonatomic,copy) NSString *person_nickname;
@property (nonatomic,copy) NSString *person_pic;
@property (nonatomic,copy) NSString *person_zw;
@property (nonatomic,copy) NSString *infoid;
@property (nonatomic,copy) NSString *infocontent;
@property (nonatomic,copy) NSString *infostatus;
@property (nonatomic,copy) NSString *article_id;
@property (nonatomic,copy) NSString *own_id;
@property (nonatomic,copy) NSString *qi_id;
@property (nonatomic,assign) BOOL isNewMessage;

@property (nonatomic,strong) NSMutableAttributedString *contentAttString;

-(WhoLikeMeDataModal *)initWithDictionary:(NSDictionary *)dic;

@end
