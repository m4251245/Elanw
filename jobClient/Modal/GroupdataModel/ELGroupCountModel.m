//
//  ELGroupCountModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupCountModel.h"

@implementation ELGroupCountModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
        [super setValue:value forKey:key]; 
}

@end
