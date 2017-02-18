//
//  ELActivityModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELActivityModel.h"

@implementation ELActivityModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *article_own_info = dic[@"article_own_info"];
        if ([article_own_info isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"article_own_info"];
            [subDic addEntriesFromDictionary:article_own_info];
        }
        NSDictionary *info = dic[@"info"];
        if ([info isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"info"];
            [subDic addEntriesFromDictionary:info];
        }
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.id_ = value;
    }else{
        [super setValue:value forKey:key]; 
    }
}

@end
