//
//  ELGroupListTwoModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupListTwoModel.h"
#import "ELGroupPersonModel.h"

@implementation ELGroupListTwoModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSMutableDictionary *subDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        NSDictionary *groupDic = subDic[@"_group_info"];
        if ([groupDic isKindOfClass:[NSDictionary class]]) {
            [subDic removeObjectForKey:@"_group_info"];
            [subDic addEntriesFromDictionary:groupDic];
        }
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"person_list"]) {
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            self.person_list = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                ELGroupPersonModel *model = [[ELGroupPersonModel alloc] initWithDictionary:dic];
                [self.person_list addObject:model];
            }
        }
    }else{
        [super setValue:value forKey:key]; 
    }
}

@end
