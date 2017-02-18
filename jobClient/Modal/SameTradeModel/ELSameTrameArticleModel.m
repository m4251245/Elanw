//
//  ELSameTrameArticleModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSameTrameArticleModel.h"
#import "ELGroupCommentModel.h"
#import "ELActivityModel.h"
#import "ELArticleVoteModel.h"
//#import "ELGroupDetailModal.h"

@implementation ELSameTrameArticleModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *personDic = dic[@"_person_detail"];
        if ([personDic isKindOfClass:[NSDictionary class]]){
            [subDic removeObjectForKey:@"_person_detail"];
            [subDic addEntriesFromDictionary:personDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
        [self jsonData];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key]; 
}

-(void)jsonData{
//    if ([self.summary containsString:@"&nbsp;"]) {
//        self.summary = [self.summary stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
//    }
//    if ([self.summary containsString:@"&ldquo;"]) {
//        self.summary = [self.summary stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
//    }
//    if ([self.summary containsString:@"&rdquo;"]) {
//        self.summary = [self.summary stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
//    }
//    if ([self.summary containsString:@"&n"]) {
//        self.summary = [self.summary stringByReplacingOccurrencesOfString:@"&n" withString:@""];
//    }
    self.title = [MyCommon translateHTML:self.title];
    self.summary = [MyCommon translateHTML:self.summary];
    self.person_iname = [MyCommon translateHTML:self.person_iname];
    self.person_zw = [MyCommon translateHTML:self.person_zw];
    if ([self._group_info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *value = (NSDictionary *)self._group_info;
        self._group_info = [[ELGroupDetailModal alloc] initWithDictionary:value];
    }
    
    if ([self._comment_list isKindOfClass:[NSArray class]]) {
        NSArray *value = (NSArray *)self._comment_list;
        self._comment_list = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in value) {
            ELGroupCommentModel *model = [[ELGroupCommentModel alloc] initWithDictionary:dic];
            if ([model.parent_id isEqualToString:@"0"]) {
                model._parent_person_detail = nil;
            }
            model.content = [MyCommon translateHTML:model.content];
            model.person_iname = [MyCommon translateHTML:model.person_iname];
            model.parent_name = [MyCommon translateHTML:model.parent_name];
            [self._comment_list addObject:model];
        }
    }
    if ([self._activity_info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *value = (NSDictionary *)self._activity_info;
        self._activity_info = [[ELActivityModel alloc] initWithDictionary:value];
    }
    if ([self._vote_info isKindOfClass:[NSDictionary class]]) {
        NSDictionary *value = (NSDictionary *)self._vote_info;
        self._vote_info = [[ELSalaryModel alloc] initWithDictionary:value];
    }
    if ([self._answer_list isKindOfClass:[NSArray class]]) {
        self._comment_list = [[NSMutableArray alloc] init];
        NSArray *value = (NSArray *)self._answer_list;
        for (NSDictionary *dic in value) {
            ELGroupCommentModel *model = [[ELGroupCommentModel alloc] initWithDictionary:dic];
            model.id_ = [dic objectForKey:@"answer_id"];
            model.user_id = [dic objectForKey:@"uid"];
            model.content = [dic objectForKey:@"answer_content"];
            model.content = [MyCommon translateHTML:model.content];
            model.person_iname = [MyCommon translateHTML:model.person_iname];
            model.parent_name = [MyCommon translateHTML:model.parent_name];
            [self._comment_list addObject:model];
        }
    }
}

-(id)initWithFriendDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];       
        
        NSString * nftype = [subDic objectForKey:@"nf_type"];
        if ([nftype isEqualToString:@"yl1001_follower"] || [nftype isEqualToString:@"yl1001_follower_user"]){
            NSMutableDictionary *_person_info_ = [[NSMutableDictionary alloc] initWithDictionary:subDic[@"_person_info_"]];
            if ([_person_info_ isKindOfClass:[NSDictionary class]]) {
                NSArray *article_list = _person_info_[@"article_list"];
                if ([article_list isKindOfClass:[NSArray class]]) {
                    if (article_list.count > 0) {
                        [_person_info_ removeObjectForKey:@"article_list"];
                        NSDictionary *articleDic = article_list[0];
                        [subDic addEntriesFromDictionary:articleDic];
                    }
                }
                NSDictionary *expert_detail = _person_info_[@"expert_detail"];
                if ([expert_detail isKindOfClass:[NSDictionary class]]) {
                    [_person_info_ removeObjectForKey:@"expert_detail"];
                    [subDic addEntriesFromDictionary:expert_detail];
                }
                [subDic removeObjectForKey:@"_person_info_"];
                [subDic addEntriesFromDictionary:_person_info_];
            }
        }else if ([nftype isEqualToString:@"yl1001_share_article"]) {
            NSDictionary *share_person = [subDic objectForKey:@"share_person"];
            if ([share_person isKindOfClass:[NSDictionary class]]) {
                NSDictionary *expert_detail = share_person[@"expert_detail"];
                if ([expert_detail isKindOfClass:[NSDictionary class]]) {
                    [subDic addEntriesFromDictionary:expert_detail];
                }
                [subDic removeObjectForKey:@"share_person"];
                [subDic addEntriesFromDictionary:share_person];
            }
            NSDictionary *article_info = subDic[@"article_info"];
            if ([article_info isKindOfClass:[NSDictionary class]]) {
                [subDic removeObjectForKey:@"article_info"];
                [subDic addEntriesFromDictionary:article_info];
            }
        }else{
            NSArray *article_list = subDic[@"article_list"];
            if ([article_list isKindOfClass:[NSArray class]]) {
                if (article_list.count > 0) {
                    [subDic removeObjectForKey:@"article_list"];
                    NSDictionary *articleDic = article_list[0];
                    [subDic addEntriesFromDictionary:articleDic];
                }
            }
        }
        [self setValuesForKeysWithDictionary:subDic];
        [self jsonData];
    }
    return self;
}

-(id)initWithExpertDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSMutableDictionary *_person_info_ = [[NSMutableDictionary alloc] initWithDictionary:subDic[@"person_detail"]];
        if ([_person_info_ isKindOfClass:[NSDictionary class]]) {
            NSArray *article_list = _person_info_[@"article_list"];
            if ([article_list isKindOfClass:[NSArray class]]) {
                if (article_list.count > 0) {
                    [_person_info_ removeObjectForKey:@"article_list"];
                    NSDictionary *articleDic = article_list[0];
                    [subDic addEntriesFromDictionary:articleDic];
                }
            }
            NSDictionary *expert_detail = _person_info_[@"expert_detail"];
            if ([expert_detail isKindOfClass:[NSDictionary class]]) {
                [_person_info_ removeObjectForKey:@"expert_detail"];
                [subDic addEntriesFromDictionary:expert_detail];
            }
            [subDic removeObjectForKey:@"person_detail"];
            [subDic addEntriesFromDictionary:_person_info_];
        }
        [self setValuesForKeysWithDictionary:subDic];
        [self jsonData];
    }
    return self;
}
@end
