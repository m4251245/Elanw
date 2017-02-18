//
//  ELNewNewsListVO.h
//  jobClient
//
//  Created by 一览ios on 2016/12/22.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"
@class ELNewNewsInfoVO;
@interface ELNewNewsListVO : PageInfo
@property (nonatomic, strong) NSNumber *cnt;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong)ELNewNewsInfoVO *info;

//info里面的字段
@property (nonatomic, copy) NSString *jsonStr;
@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *qi_id_isdefault;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, strong) NSNumber *all_cnt;
@end
