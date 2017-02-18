                                     //
//  ELArticleVoteModel.m
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticleVoteModel.h"
#import "YLVoteDataModal.h"

@implementation ELArticleVoteModel

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
    if([key isEqualToString:@"option_info"]){
        NSArray *arr = value;
        if ([value isKindOfClass:[NSArray class]]) {
            self.option_info = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                YLVoteDataModal *model = [[YLVoteDataModal alloc] initWithDictionary:dic];
                [self.option_info addObject:model];
            }
        }
    }else{
        [super setValue:value forKey:key]; 
    }
}

@end
