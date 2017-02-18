//
//  AnswerDetialModal.m
//  jobClient
//
//  Created by YL1001 on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "AnswerDetialModal.h"

@implementation AnswerDetialModal

- (instancetype)initWithDictionary:(NSDictionary *)dict
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
    
    if ([key isEqualToString:@"person_detail"])
    {
        NSDictionary *dict = value;
        _person_id = dict[@"person_id"];
        _person_iname = dict[@"person_iname"];
        _person_pic = dict[@"person_pic"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
    
}

@end
