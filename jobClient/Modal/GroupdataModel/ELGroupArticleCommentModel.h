//
//  ELGroupArticleCommentModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupArticleCommentModel : PageInfo

@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *parent_name;
@property (nonatomic, copy) NSString *user_name;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
