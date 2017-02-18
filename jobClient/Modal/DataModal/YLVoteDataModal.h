//
//  YLVoteDataModal.h
//  jobClient
//
//  Created by 一览iOS on 15/6/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLVoteDataModal : NSObject

@property(nonatomic,copy) NSString *gaapName;
@property(nonatomic,copy) NSString *gaapId;
@property(nonatomic,copy) NSString *sort;
@property(nonatomic,copy) NSString *isBest;
@property(nonatomic,copy) NSString *result;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
