//
//  ELGroupArticleModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupArticleModel.h"
#import "ELGroupCommentModel.h"

@implementation ELGroupArticleModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary *relDic = dic[@"_person_detail"];
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        if ([relDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"_person_detail"];
            [subDic addEntriesFromDictionary:relDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.title = [MyCommon translateHTML:self.title];
        self.person_zw = [MyCommon translateHTML:self.person_zw];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"_comment"]) {
        NSArray *arr = value;
        self._comment = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in arr) {
            ELGroupCommentModel *model = [[ELGroupCommentModel alloc] initWithDictionary:dic];
            [self._comment addObject:model];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
