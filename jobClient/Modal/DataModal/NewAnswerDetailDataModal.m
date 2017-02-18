//
//  NewAnswerDetailDataModal.m
//  jobClient
//
//  Created by 一览iOS on 15-3-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NewAnswerDetailDataModal.h"

@implementation NewAnswerDetailDataModal


-(NewAnswerDetailDataModal *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.question_id = [dic objectForKey:@"question_id"];
        self.question_title = [dic objectForKey:@"question_title"];
        self.question_replys_count = [dic objectForKey:@"question_replys_count"];
        self.question_view_count = [dic objectForKey:@"question_view_count"];
        self.question_idate = [dic objectForKey:@"question_idate"];
        self.question_content = [dic objectForKey:@"question_content"];
        self.person_id = [[dic objectForKey:@"person_detail"] objectForKey:@"person_id"];
        self.person_iname = [[dic objectForKey:@"person_detail"] objectForKey:@"person_iname"];
        self.person_pic = [[dic objectForKey:@"person_detail"] objectForKey:@"person_pic"];
        self.tagArray = dic[@"tag_info"];
        self.isRecommend = dic[@"is_recommend"];
        if ([self.tagArray isKindOfClass:[NSNull class]]) {
            self.tagArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

@end
