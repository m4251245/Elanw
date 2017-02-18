//
//  ConsultantRecommendDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/5/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ConsultantRecommendDataModel.h"
#import "ZPinfoDataModel.h"
@implementation ConsultantRecommendDataModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"zpinfo"]) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *zpinfo = value;
        for (id obj in zpinfo) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                ZPinfoDataModel *zpVO = [[ZPinfoDataModel alloc]init];
                [zpVO setValuesForKeysWithDictionary:obj];
                [arr addObject:zpVO];
            }
            else{
                self.zpinfo = value;
                return;
            }
        }
        self.zpinfo = arr;
    }
    else{
        [super setValue:value forKey:key];
    }
}


@end
