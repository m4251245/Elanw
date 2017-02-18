//
//  ConditionItemCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"


typedef enum{
    condition_WorkAge=1,  //工作年限
    condition_Time,     //发布日期
    condition_Edu,      //学历要求
    condition_WorkType,  //工作类型
    condition_PayMent,  //月薪范围
}conditionType;

@protocol ConditionItemCtlDelegate <NSObject>
@optional
/**
 *  代理方法
 *
 *  @param type           枚举类型（条件类型）
 *  @param conditionName  conditionName 条件名字
 *  @param conditionValue conditionValue 条件对应的值
 */
- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1;

@end

@interface ConditionItemCtl : BaseListCtl
{
    NSArray     *inDataArray_;
    NSArray     *inValueArray_;
    NSArray     *inValueArray_1;
    
}

@property (nonatomic,assign) conditionType conditionType_;
@property (nonatomic,assign) id <ConditionItemCtlDelegate> delegate_;

@property (nonatomic,copy) NSString *idStr;

@end
