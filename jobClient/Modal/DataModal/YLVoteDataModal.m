//
//  YLVoteDataModal.m
//  jobClient
//
//  Created by 一览iOS on 15/6/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLVoteDataModal.h"

@implementation YLVoteDataModal

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
@end
