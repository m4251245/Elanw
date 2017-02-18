//
//  NSMutableDictionary+_New.m
//  jobClient
//
//  Created by 一览iOS on 16/10/19.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NSMutableDictionary+New.h"

@implementation NSMutableDictionary (New)

-(void)setNewValue:(id)value forKey:(NSString *)key{
    if (value && key){
        [self setObject:value forKey:key];
    }
}

@end
