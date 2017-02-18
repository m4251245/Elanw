//
//  ELUserModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELUserModel.h"

@implementation ELUserModel
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
