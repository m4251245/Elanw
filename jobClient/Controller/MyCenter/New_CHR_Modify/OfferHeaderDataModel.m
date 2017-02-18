//
//  OfferHeaderDataModel.m
//  jobClient
//
//  Created by 一览ios on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "OfferHeaderDataModel.h"
#import "OfferPartyTalentsModel.h"

@implementation OfferHeaderDataModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"jobfairInfo"]) {
        OfferPartyTalentsModel *OfferPartyVO = [[OfferPartyTalentsModel alloc]init];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [OfferPartyVO setValuesForKeysWithDictionary:value];
        }
        else{
            self.jobfairInfo = value;
            return;
        }
        self.jobfairInfo = OfferPartyVO;
        }
    else{
        [super setValue:value forKey:key];
    }
}

@end
