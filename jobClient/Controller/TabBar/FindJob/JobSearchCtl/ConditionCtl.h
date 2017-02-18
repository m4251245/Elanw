//
//  ConditionCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ConditionItemCtl.h"
#import "SearchParam_DataModal.h"

@protocol ConditionCtlDelegate <NSObject>
//回调搜索参数
- (void)conditionSelectedOK:(SearchParam_DataModal *)searchParam;

@end

@interface ConditionCtl : BaseListCtl<ConditionItemCtlDelegate>
{
    NSMutableArray     *dataArray_;
    NSArray            *workAgeArray_;
    NSArray            *workAgeValueArray_;
    
    NSArray            *timeArray_;
    NSArray            *timeValueArray_;
    
    NSArray            *eduArray_;
    NSArray            *eduValueArray_;
    
    NSArray            *paymentArray_;
    NSArray            *paymentValueArray_;
    
    NSArray            *workTypeArray_;
    NSArray            *workTypeVauleArray_;
    
    SearchParam_DataModal  *inSearchParam_;
}

@property(nonatomic,assign) id <ConditionCtlDelegate> delegate_;

@end
