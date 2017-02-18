//
//  UserJob_DataModal.m
//  jobClient
//
//  Created by YL1001 on 14-9-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "UserJob_DataModal.h"

@implementation UserJob_DataModal

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
