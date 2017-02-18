//
//  ELArticleDetailModel.m
//  jobClient
//
//  Created by 一览iOS on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticleDetailModel.h"
#import "ELGroupArticleModel.h"
#import "ELArticlePositionModel.h"
#import "ELSameTradePeopleModel.h"
#import "ELActivityModel.h"
#import "YLMediaModal.h"

@implementation ELArticleDetailModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        self.summary = [MyCommon translateHTML:self.summary];
        self.ctime = [MyCommon getDateStrFromTimestamp:self.ctime];
        self.title = [MyCommon translateHTML:self.title];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"other_article"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arr = value;
            if (arr.count > 0) {
                self.other_article = [[NSMutableArray alloc] init];
                for (NSDictionary * artDic in arr) {
                    ELGroupArticleModel * artModal = [[ELGroupArticleModel alloc] initWithDictionary:artDic];
                    [self.other_article addObject:artModal];
                }
            }
        }
    }else if ([key isEqualToString:@"zhiwei"]){
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arr = value;
            if (arr.count > 0) {
                self.zhiwei = [[NSMutableArray alloc] init];
                for (NSDictionary * artDic in arr) {
                    ELArticlePositionModel * artModal = [[ELArticlePositionModel alloc] initWithDictionary:artDic];
                    [self.zhiwei addObject:artModal];
                }
            }
        }
    }else if ([key isEqualToString:@"_majia_info"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            self._majia_info = [[ELSameTradePeopleModel alloc] initWithDictionary:value];
        }
    }else if ([key isEqualToString:@"_media"]){
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arr = value;
            if (arr.count > 0) {
                self._media = [[NSMutableArray alloc] init];
                for (NSDictionary * artDic in arr) {
                    YLMediaModal *modalOne = [[YLMediaModal alloc] initWithDictionary:artDic];
                    
                    if ([modalOne.postfix.lowercaseString isEqualToString:@"jpg"] || [modalOne.postfix.lowercaseString isEqualToString:@"png"] || [modalOne.postfix.lowercaseString isEqualToString:@"jpeg"] || [modalOne.postfix.lowercaseString isEqualToString:@"gif"] ||[modalOne.postfix.lowercaseString isEqualToString:@"bmp"])
                    {
                        [self._media addObject:modalOne];
                    }else{
                        if(modalOne.file_swf.length > 0){
                            [self._media addObject:modalOne];
                        }
                    }
                }
            }
        }
        
    }else if ([key isEqualToString:@"_group_info"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            self._group_info = [[ELGroupDetailModal alloc] initWithDictionary:value];
        }
    }else if ([key isEqualToString:@"_activity_info"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subDic = value;
            self.dicJoinName = subDic;
            NSDictionary *dic = subDic[@"info"][@"info"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                self._activity_info = [[ELActivityModel alloc] initWithDictionary:dic];
            }
        }
    }else if ([key isEqualToString:@"person_detail"]){
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.person_detail = [[ELSameTradePeopleModel alloc] initWithDictionary:value];
        }
    }else{
        [super setValue:value forKey:key]; 
    }
}

@end
