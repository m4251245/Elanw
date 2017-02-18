//
//  MyQuestionAndAnswerModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "MyQuestionAndAnswerModal.h"

@implementation MyQuestionAndAnswerModal

- (instancetype)initWithdict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"person_info"]) {
        
        NSDictionary *dict = value;
        _person_id = dict[@"person_id"];
        _person_iname = dict[@"person_iname"];
        _person_pic = dict[@"person_pic"];
    }
    else if ([key isEqualToString:@"question_person_info"]) {
        
        NSDictionary *dict = value;
        _person_id = dict[@"person_id"];
        _person_iname = dict[@"person_iname"];
        _person_pic = dict[@"person_pic"];
    }
    else if ([key isEqualToString:@"answer_info"]) {
       
        NSDictionary *dict = value;
        _answer_id = dict[@"answer_id"];
        _answer_idate = dict[@"answer_idate"];
        _answer_content = dict[@"answer_content"];
        _manage_status = dict[@"manage_status"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
    
}

@end
