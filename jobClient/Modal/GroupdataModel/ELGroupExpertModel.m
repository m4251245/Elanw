//
//  ELGroupExpertModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupExpertModel.h"

@implementation ELGroupExpertModel

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
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }else{
        [super setValue:value forKey:key]; 
    }
}

@end
