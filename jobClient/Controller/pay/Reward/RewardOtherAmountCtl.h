//
//  RewardOtherAmountCtl.h
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

typedef void(^AmountBlock)(NSString *);

@interface RewardOtherAmountCtl : BaseUIViewController
@property (weak, nonatomic) IBOutlet UITextField *otherAmountTF;    /**<textfield */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;          /**<提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;            /**<关闭按钮 */
@property(nonatomic, copy) AmountBlock amountBlock;
@property (weak, nonatomic) IBOutlet UIView *maskView;              /**<透明背景 */
@property (weak, nonatomic) IBOutlet UIView *amoutView;             /**<白色背景 */
@property (strong, nonatomic) IBOutlet UILabel *tipsLb;             /**<标题 */
@property (strong, nonatomic) IBOutlet UIImageView *redpackImg;     /**<红包图片 */
@property (strong, nonatomic) IBOutlet UIButton *randomBtn;
@property (strong, nonatomic) IBOutlet UIButton *packBtn;
@property (strong, nonatomic) IBOutlet UIImageView *personImg;
@property (strong, nonatomic) IBOutlet UILabel *personNameLb;
@property (strong, nonatomic) IBOutlet UIButton *outViewBtn;


@end
