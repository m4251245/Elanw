//
//  ELGroupArticleModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupArticleModel : PageInfo

@property (nonatomic, copy) NSString *own_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *_is_xinwen;
@property (nonatomic, copy) NSString *_url;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *is_majia;
@property (nonatomic, copy) NSString *person_pic;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, strong) NSMutableArray *_comment;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
