//
//  PageInfo.m
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PageInfo.h"

@implementation PageInfo

@synthesize currentPage_,pageSize_,pageCnt_,totalCnt_;

-(id) init
{
	self = [super init];
	
    [self resetPageInfo];
	
	return self;
}

-(instancetype)initWithPageInfoDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        dic = [dic objectForKey:@"pageparam"];
        self.pageCnt_ = [[dic objectForKey:@"pages"] intValue];
        self.totalCnt_ = [[dic objectForKey:@"sums"] intValue];
        if(![dic objectForKey:@"pages"])
        {
            self.pageCnt_ = self.totalCnt_/10.0 ;
        }
    }
    return self;
}

//重置
-(void) resetPageInfo
{
    currentPage_ = 0;
	pageSize_ = 10;
	pageCnt_ = 0;
	totalCnt_ = 0;
}

@end

@implementation ELPageInfo
    
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
