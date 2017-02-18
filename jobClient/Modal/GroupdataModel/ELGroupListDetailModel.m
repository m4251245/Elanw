//
//  ELGroupListDetailModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupListDetailModel.h"
#import "ELGroupArticleModel.h"
#import "ELGroupCommentModel.h"

@implementation ELGroupListDetailModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary *relDic = dic[@"group_person_rel"];
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        if ([relDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"group_person_rel"];
            [subDic addEntriesFromDictionary:relDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.group_name = [MyCommon translateHTML:self.group_name];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"_article"]) {
        NSArray *arr = value;
        self._article = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arr) {
            ELGroupArticleModel *model = [[ELGroupArticleModel alloc] initWithDictionary:dic];
            model.title = [MyCommon translateHTML:model.title];
            model.person_iname = [MyCommon translateHTML:model.person_iname];
            [self._article addObject:model];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
