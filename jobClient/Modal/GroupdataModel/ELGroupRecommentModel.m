//
//  ELGroupRecommentModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupRecommentModel.h"
#import "ELGroupCommentModel.h"

@implementation ELGroupRecommentModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary *groupInfoDic = dic[@"group_info"];
        NSDictionary *articleInfoDic = dic[@"article_info"];
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
        if ([groupInfoDic isKindOfClass:[NSDictionary class]]){
            [subDic addEntriesFromDictionary:groupInfoDic];
        }
        if ([articleInfoDic isKindOfClass:[NSDictionary class]]){
            [subDic addEntriesFromDictionary:articleInfoDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"_comment"]) {
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            self._comment = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                ELGroupCommentModel *model = [[ELGroupCommentModel alloc] initWithDictionary:dic];
                [self._comment addObject:model];
            }
        }
    }else{
       [super setValue:value forKey:key]; 
    }
}

@end
