//
//  OfferPartyTalentsModel.m
//  jobClient
//
//  Created by YL1001 on 16/6/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "OfferPartyTalentsModel.h"
#import "ELAnswerLableModel.h"

@implementation OfferPartyTalentsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"isjoin"]) {
        if ([value isEqualToString:@"1"]) {
            _isjoin = YES;
        }
    }
    else if ([key isEqualToString:@"iscome"])
    {
        if ([value isEqualToString:@"1"]) {
            _iscome = YES;
        }
    }
    else if ([key isEqualToString:@"isNew"])
    {
        _isNew = [value boolValue];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

@end

@implementation ELOfferListModel
    
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"jobfairCnt"]) {
        NSArray *arr = value;
        if ([arr isKindOfClass:[NSArray class]]) {
            self.jobfairCnt = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                ELOfferCountModel *model = [[ELOfferCountModel alloc] initWithDic:dic];
                [self.jobfairCnt addObject:model];
            }
        }
    }else{
         [super setValue:value forKey:key]; 
    }
}

-(void)creatLabel
{
    self.lableArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0;i<self.jobfairCnt.count;i++) {
        ELOfferCountModel *model = self.jobfairCnt[i];
        ELAnswerLableModel *labelModel = [[ELAnswerLableModel alloc] init];
        labelModel.name = [NSString stringWithFormat:@"%@ %@",model.labelName,model.labelCount];
        if (i<4) {
            labelModel.colorType = CyanColorType;
        }else{
            labelModel.colorType = GrayColorType;
        }
        [self.lableArr addObject:labelModel];
    }
}

@end

@implementation ELOfferCountModel

-(id)initWithDic:(NSDictionary *)dic{
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
