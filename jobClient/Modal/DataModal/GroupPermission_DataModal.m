//
//  GroupPermission_DataModal.m
//  Association
//
//  Created by YL1001 on 14-5-29.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "GroupPermission_DataModal.h"

@implementation GroupPermission_DataModal
@synthesize groupId_,joinStatus_,InviteArr_,inviteStatus_,publishArr_,publishStatus_;

- (instancetype)initWithDictionary:(NSDictionary *)subDic
{
    self = [super init];
    if (self){
        [self setValuesForKeysWithDictionary:subDic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"_topic_publish_list"]) {
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
             self._topic_publish_list = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                [self._topic_publish_list addObject:dic[@"person_id"]];
            }
        }
    }else if ([key isEqualToString:@"_member_invite_list"]){
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            self._member_invite_list = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                [self._member_invite_list addObject:dic[@"person_id"]];
            }
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
