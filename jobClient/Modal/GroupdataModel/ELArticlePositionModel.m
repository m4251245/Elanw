//
//  ELArticlePositionModel.m
//  jobClient
//
//  Created by 一览iOS on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticlePositionModel.h"

@implementation ELArticlePositionModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        self.jtzw = [MyCommon translateHTML:self.jtzw];
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
