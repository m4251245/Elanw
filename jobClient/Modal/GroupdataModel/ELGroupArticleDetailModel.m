//
//  ELGroupArticleDetailModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupArticleDetailModel.h"
#import "ELGroupArticleCommentModel.h"
#import "ELGroupLikePersonModel.h"
#import "ELGroupCommentModel.h"

@interface ELGroupArticleDetailModel()
{
    BOOL isGroupComment;
}
@end

@implementation ELGroupArticleDetailModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *personDic = dic[@"_person_detail"];
        if ([personDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"_person_detail"];
            [subDic addEntriesFromDictionary:personDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.title = [MyCommon translateHTML:self.title];
        self.summary = [MyCommon translateHTML:self.summary];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"_comment_list"]) {
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            self._comment_list = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                if (isGroupComment) {
                    ELGroupCommentModel *model = [[ELGroupCommentModel alloc] initWithDictionary:dic];
                    model.content = [MyCommon translateHTML:model.content];
                    model.person_iname = [MyCommon translateHTML:model.person_iname];
                    model.parent_name = [MyCommon translateHTML:model.parent_name];
                    model.user_name = [MyCommon translateHTML:model.user_name];
                    [self._comment_list addObject:model];
                }else{
                    ELGroupArticleCommentModel *model = [[ELGroupArticleCommentModel alloc] initWithDictionary:dic];
                    model.content = [MyCommon translateHTML:model.content];
                    model.user_name = [MyCommon translateHTML:model.user_name];
                    model.parent_name = [MyCommon translateHTML:model.parent_name];
                    [self._comment_list addObject:model];
                }
            }
        }
    }else if ([key isEqualToString:@"_agree_list"]) {
//        NSArray *arr = value;
//        if ([arr isKindOfClass:[NSArray class]]) {
//            self._agree_list = [[NSMutableArray alloc] init];
//            for (NSDictionary *dic in arr) {
//                ELGroupLikePersonModel *model = [[ELGroupLikePersonModel alloc] initWithDictionary:dic];
//                [self._agree_list addObject:model];
//            }
//        }
    }else{
       [super setValue:value forKey:key]; 
    }
}

-(id)initWithGroupDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        isGroupComment = YES;
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *personDic = dic[@"_person_detail"];
        if ([personDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"_person_detail"];
            [subDic addEntriesFromDictionary:personDic];
        }
        NSDictionary *groupDic = dic[@"_group_info"];
        if ([groupDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"_group_info"];
            [subDic addEntriesFromDictionary:groupDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.title = [MyCommon translateHTML:self.title];
        self.summary = [MyCommon translateHTML:self.summary];
    }
    return self;
}

@end
