//
//  ELCommentModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCommentModel.h"

@implementation ELCommentModel
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

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.id_ = value;
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setId_:(NSString *)id_{
    _id_ = id_;
    self.isLike = [Manager getIsLikeStatus:id_];
}

-(void)setIsLike:(BOOL)isLike{
    if (!_isLike) {
        _isLike = isLike;
    }
}

@end
