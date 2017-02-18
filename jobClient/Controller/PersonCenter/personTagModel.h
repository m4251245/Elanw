
//
//  personTagModel.h
//  jobClient
//
//  Created by 一览iOS on 14-10-29.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personTagModel : NSObject

@property(nonatomic,strong) NSString    *tagId_;
@property(nonatomic,strong) NSString    *queryId_;//查询自标签使用的ID
@property(nonatomic,strong) NSString    *tagName_;
@property(nonatomic,assign) BOOL        isCustomTag;
@property(nonatomic,assign) NSInteger buttonIndex;
@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong) NSString    *firstId;
@property(nonatomic,strong) NSString    *firstName;
@property(nonatomic,strong) NSString    *secondId;
@property(nonatomic,strong) NSString    *secondName;

@end
