//
//  EditorTagCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-1.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//行业或职业选择

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "PersonCenterDataModel.h"
#import "personTagModel.h"


@protocol SelectTradeCtlDelegate <NSObject>

@optional
- (void)updateTrade:(personTagModel *)personTagModel;//行业

- (void)updateJob:(personTagModel *)personTagModel;//职业

@end

@interface RegInfoThreeCtl : BaseEditInfoCtl<UITextFieldDelegate>
{
    UITextField         *tagsTextField_;
    UIButton            *submitBtn;
}

@property(nonatomic,weak) id<SelectTradeCtlDelegate> delegate;
//  nil默认注册， type ==0 修改行业信息入口 type=1 修改职业
@property(nonatomic, copy) NSString *type;
@property(nonatomic, strong) User_DataModal *inDataModal;

@end
