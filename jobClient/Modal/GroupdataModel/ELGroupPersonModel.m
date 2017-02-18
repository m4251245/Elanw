//
//  ELGroupPersonModel.m
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELGroupPersonModel.h"

@implementation ELGroupPersonModel

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        self.person_iname = [MyCommon translateHTML:self.person_iname];
        self.person_name = [MyCommon translateHTML:self.person_name];
        self.person_nickname = [MyCommon translateHTML:self.person_nickname];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}

@end
