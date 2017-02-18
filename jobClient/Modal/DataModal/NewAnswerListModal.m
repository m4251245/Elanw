//
//  NewAnswerListModal.m
//  jobClient
//
//  Created by 一览iOS on 15-3-20.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NewAnswerListModal.h"

@implementation NewAnswerListModal

-(NewAnswerListModal *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.answer_id = [dic objectForKey:@"answer_id"];
        self.answer_content = [dic objectForKey:@"answer_content"];
        self.answer_support_count = [dic objectForKey:@"answer_support_count"];
        self.answer_comment_count = [dic objectForKey:@"answer_comment_count"];
        self.answer_idate = [dic objectForKey:@"answer_idate"];
        self.person_id = [[dic objectForKey:@"answer_person_detail"] objectForKey:@"person_id"];
        self.person_iname = [[dic objectForKey:@"answer_person_detail"] objectForKey:@"person_iname"];
        self.person_pic = [[dic objectForKey:@"answer_person_detail"] objectForKey:@"person_pic"];
        self.is_support = [dic objectForKey:@"is_support"];
        self.dashangTotal = [dic objectForKey:@"_dashang_total"];
        NSString *str = [[dic objectForKey:@"answer_person_detail"] objectForKey:@"is_expert"];
        if ([str integerValue] == 0) {
            self.isExpert = NO;
        }
        else
        {
            self.isExpert = YES;
        }
        
        self.commentList = [[NSMutableArray alloc] init];
            
        NSArray *arr = [dic objectForKey:@"_comment_list"];
        
        if ([arr isKindOfClass:[NSArray class]])
        {
            for (NSInteger i=0;i<arr.count;i++)
            {
                Comment_DataModal *modal = [[Comment_DataModal alloc] init];
                modal.id_ = [arr[i] objectForKey:@"comment_id"];
                modal.userId_ = [arr[i] objectForKey:@"uid"];
                modal.content_ = [arr[i] objectForKey:@"comment_content"];
                modal.userName_ = [[arr[i] objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
                
                @try {
                    modal.parent_ = [[Comment_DataModal alloc] init];
                    modal.parent_.userId_ = arr[i][@"_parent_person_detail"][@"personId"] ;
                    modal.parent_.userName_ = arr[i][@"_parent_person_detail"][@"person_iname"] ;
                    modal.parent_.imageUrl_ = arr[i][@"_parent_person_detail"][@"person_pic"] ;
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                [self.commentList addObject:modal];
            }
        }

    }
    
    return self;
}

@end
