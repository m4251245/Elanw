//
//  TagDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/9/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface TagDataModel : PageInfo
@property (nonatomic, copy) NSString *yltpr_status;
@property (nonatomic, copy) NSString *zwid;
@property (nonatomic, copy) NSString *yltpr_idatetime;
@property (nonatomic, copy) NSString *yltpr_level;
@property (nonatomic, copy) NSString *yltpr_level_flag;
@property (nonatomic, copy) NSString *ylt_id;
@property (nonatomic, copy) NSString *yltpr_id;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *totalid;
@property (nonatomic, copy) NSString *yltpr_order;
@property (nonatomic, copy) NSString *yltpr_belongs;
@property (nonatomic, copy) NSString *yltpr_parent_id;
@property (nonatomic, retain) NSDictionary *tag_info;
@end
