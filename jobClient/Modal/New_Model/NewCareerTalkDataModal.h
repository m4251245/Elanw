//
//  NewCareerTalkDataModal.h
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface NewCareerTalkDataModal : PageInfo
@property (nonatomic, copy) NSString *xjhId;
@property (nonatomic, copy) NSString *saddr;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *addr;
@property (nonatomic, copy) NSString *edate;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *sdate;
@property (nonatomic, copy) NSString *content;//招聘会详情内容
@property (nonatomic, copy) NSString *sname;
//@property (nonatomic, copy) NSString *care;//1为关注 0未关注

@property (nonatomic, copy) NSString *contents;//宣讲会详情内容

@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, assign) int type;//1为招聘会 2宣讲会
@property(nonatomic,strong) NSString * attention;      //1为关注 0未关注

@end
