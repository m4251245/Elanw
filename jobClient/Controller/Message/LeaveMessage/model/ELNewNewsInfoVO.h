//
//  ELNewNewsInfoVO.h
//  jobClient
//
//  Created by 一览ios on 2016/12/22.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELNewNewsInfoVO : NSObject
@property (nonatomic, copy) NSString *newsInfoId;
@property (nonatomic, strong) NSNumber *is_expert;
@property (nonatomic, strong) NSNumber *is_private;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, strong) NSNumber *is_hr;
@property (nonatomic, strong) NSNumber *is_zp;
@property (nonatomic, strong) NSNumber *is_new;
@property (nonatomic, strong) NSNumber *group_type;
@property (nonatomic, strong) NSNumber *group_mess_type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *qi_id_isdefault;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, strong) NSNumber *all_cnt;
@end
