//
//  ResumeStatusDataModel.h
//  Association
//
//  Created by 一览iOS on 14-6-25.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumeStatusDataModel : NSObject

@property(nonatomic,strong)NSString *statusKey_;    //状态key
@property(nonatomic,strong)NSString *statusValue_;  //状态值
@property(nonatomic,assign)BOOL     selected_;      //是否选中
@property(nonatomic,copy)NSString *linkStr;

@end
