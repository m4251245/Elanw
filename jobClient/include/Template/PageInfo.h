//
//  PageInfo.h
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
	DataModal=>Page Info
 
 ***************************/

#import <Foundation/Foundation.h>


@interface PageInfo : NSObject {
	NSInteger						currentPage_;	//current page index
	NSInteger						pageSize_;		//page size
	NSInteger						pageCnt_;		//page cnt
	NSInteger						totalCnt_;		//total cnt
}

@property(nonatomic,assign) NSInteger		currentPage_;
@property(nonatomic,assign) NSInteger		pageSize_;
@property(nonatomic,assign) NSInteger		pageCnt_;
@property(nonatomic,assign) NSInteger		totalCnt_;
@property (nonatomic, assign) BOOL          lastPageFlag;

//重置
-(void) resetPageInfo;

-(instancetype)initWithPageInfoDictionary:(NSDictionary *)dic;

@end

@interface ELPageInfo : NSObject

@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *sums;
@property (nonatomic,copy) NSString *pages;

-(id)initWithDic:(NSDictionary *)dic;

@end
