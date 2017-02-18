//
//  ELArticleVoteModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELArticleVoteModel : NSObject
@property(nonatomic, copy) NSString *isVote;
@property(nonatomic, copy) NSString *canVote;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *allVote;
@property(nonatomic,strong) NSMutableArray *option_info;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
