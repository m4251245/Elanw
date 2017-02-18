//
//  CreateGroupDataModel.h
//  jobClient
//
//  Created by 一览iOS on 14-9-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateGroupDataModel : NSObject

@property(nonatomic,copy) NSString    *groupName_;
@property(nonatomic,copy) NSString    *groupTags_;
@property(nonatomic,copy) NSString    *isPublic_;    //1为公开 0为私密
@property(nonatomic,copy) NSString    *groupIntro;
@property(nonatomic,strong) UIImage     *groupImg_;

@end
