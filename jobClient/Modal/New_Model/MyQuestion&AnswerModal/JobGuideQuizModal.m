//
//  JobGuideQuizModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "JobGuideQuizModal.h"
#import "AnswerListModal.h"

@implementation JobGuideQuizModal

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.question_title =[MyCommon translateHTML:self.question_title];
        self.question_content =[MyCommon translateHTML:self.question_content];
        self.question_title =[MyCommon MyfilterHTML:self.question_title];
        self.question_content =[MyCommon MyfilterHTML:self.question_content];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"person_detail"]) {
        
        NSDictionary *dict = value;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.person_detail = [[ELSameTradePeopleModel alloc] initWithDictionary:dict];
        }
    }else if ([key isEqualToString:@"answer_detail"]) {
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]){
            if (arr.count > 0) {
                self.answer_detail = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr) {
                    AnswerListModal *modal = [[AnswerListModal alloc] initWithDictionary:dic];
                    modal.answer_content =[MyCommon translateHTML:modal.answer_content];
                    modal.answer_content =[MyCommon MyfilterHTML:modal.answer_content];
                    [self.answer_detail addObject:modal];
                }
            }
        }    
    }else{
        [super setValue:value forKey:key];
    }
}

@end
