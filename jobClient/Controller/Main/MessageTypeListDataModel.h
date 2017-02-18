//
//  MessageTypeListDataModel.h
//  jobClient
//
//  Created by 一览ios on 15/4/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTypeListDataModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) int           count;

@end
