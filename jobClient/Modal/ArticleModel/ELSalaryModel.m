//
//  ELSalaryModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSalaryModel.h"
#import "YLVoteDataModal.h"

@implementation ELSalaryModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [subDic removeObjectForKey:@"_rel_info"];
        NSMutableDictionary *firDic = dic[@"_rel_info"];
        NSDictionary *secDic = firDic[@"personInfo"];
        [firDic removeObjectForKey:@"personInfo"];
        [subDic removeObjectForKey:@"_vote_info"];
        NSDictionary *voteDic = dic[@"_vote_info"];
        
        NSMutableDictionary *thridDic = subDic[@"_person_detail"];
        [subDic removeObjectForKey:@"_person_detail"];
        
        if ([firDic isKindOfClass:[NSDictionary class]]){
            [subDic addEntriesFromDictionary:firDic];
        }
        if ([secDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:secDic];
        }
        if ([voteDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:voteDic];
        }
        if ([thridDic isKindOfClass:[NSDictionary class]]) {
            [subDic addEntriesFromDictionary:thridDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.resultDataArr = self.option_info;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"option_info"]){
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            self.option_info = [[NSMutableArray alloc] init];
            for (NSDictionary *dicTwo in arr) {
                YLVoteDataModal *voteModal = [[YLVoteDataModal alloc] initWithDictionary:dicTwo];
                [self.option_info addObject:voteModal];
            }
        }
    }
    else{
        [super setValue:value forKey:key];
    }
}

-(void)setArticle_id:(NSString *)article_id
{
    _article_id = article_id;
    _isLike_ = [Manager getIsLikeStatus:article_id];
}

-(void)setIsLike_:(BOOL)isLike_
{
    if (!_isLike_) {
        _isLike_ = isLike_;
    }
}

@end
