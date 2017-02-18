//
//  ELCreateCourseCtl.h
//  jobClient
//
//  Created by YL1001 on 15/10/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
@class RewardOtherAmountCtl;
@class CreateCourseOtherBtnCtl;

@interface ELCreateCourseCtl : BaseEditInfoCtl
{
    
    IBOutlet UIView *titleBgView;      /**< 主题背景 */
    IBOutlet UIView *timeBgView;       /**< 时长背景 */
    IBOutlet UIView *priceBgView;      /**< 价格背景 */
    IBOutlet UIView *contentBgView;    /**< 内容背景 */
    
    IBOutlet UITextView *titleTV;     /**< 主题名称 */
    IBOutlet UITextView *contentTV;   /**< 话题描述 */
    
    IBOutlet UIButton *hoursBtnOne;     /**< 时长1 */
    IBOutlet UIButton *hoursBtnTwo;     /**< 时长2 */
    IBOutlet UIButton *hoursBtnthree;   /**< 时长3 */
    IBOutlet UIButton *otherTimeBtn;    /**< 其他时长 */
    
    IBOutlet UIButton *priceBtnOne;     /**< 价格1 */
    IBOutlet UIButton *priceBtnTwo;     /**< 价格2 */
    IBOutlet UIButton *priceBtnThree;   /**< 价格3 */
    IBOutlet UIButton *otherPriceBtn;   /**< 其他金额 */
    
    IBOutlet UILabel *tipsOne;     /**< 提示1 */
    IBOutlet UILabel *tipsTwo;     /**< 提示2 */
    
    IBOutlet UILabel *numOfTitleTV;
    IBOutlet UILabel *numOfContentTv;
    
    
    IBOutlet UILabel *tips3;
    IBOutlet UIButton *confirmBtn;     /**< 提交按钮 */
}

@property (strong, nonatomic) RewardOtherAmountCtl *rewardOtherAmountCtl;
@property (strong, nonatomic) CreateCourseOtherBtnCtl *courseOtherTimeCtl;
@property (nonatomic,assign) NSInteger backIndex;

@end
