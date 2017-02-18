//
//  ELGroupInviteModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupInviteModel.h"

@implementation ELGroupInviteModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"_parent_comment"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *content = value[@"content"];
            if (content.length > 0) {
                
            }
        }
    }
}
@end

@implementation ELGroupMessageModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"group_id"]) {
        self.groupInfoModel.group_id = value;
    }
    if ([key isEqualToString:@"group_name"]) {
        self.groupInfoModel.group_name = value;
    }
}
@end