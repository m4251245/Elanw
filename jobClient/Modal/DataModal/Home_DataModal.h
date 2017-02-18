//
//  Home_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-16.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_DataModal.h"
#import "PageInfo.h"
#import "Groups_DataModal.h"
#import "Expert_DataModal.h"
typedef enum
{
    Home_Groups,     //社群
    Home_Expert,     //行家
    Home_Others,
}HomeType;

@interface Home_DataModal : PageInfo


@property(nonatomic,assign) HomeType     type_;
@property(nonatomic,strong) NSString *   typeId_;
@property(nonatomic,strong) NSString *   updatetime_;
@property(nonatomic,strong) Expert_DataModal  *   personInfo;
@property(nonatomic,strong) NSMutableArray    *   articleArray_;
@property(nonatomic,strong) Groups_DataModal  *   groupInfo;


@end
