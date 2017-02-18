//
//  OfferPartyInterviewTipsCtl.h
//  jobClient
//
//  Created by 一览ios on 15/7/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "OfferPartyTalentsModel.h"

typedef void(^OfferPartyTipsBlock)(NSInteger);

@interface OfferPartyInterviewTipsCtl : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *offerPartyGuideImgv;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *companyLb;     /**<公司名称 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;   /**<知道了 */
@property (strong, nonatomic) IBOutlet UIButton *refuseBtn;  /**<不去了 */
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;    /**<确定 */
@property (strong, nonatomic) IBOutlet UIView *shadeView;    /**<黄色背景 */
@property (strong, nonatomic) IBOutlet UILabel *tipsLb1;     /**<文本提示1 */
@property (strong, nonatomic) IBOutlet UILabel *tipLb2;      /**<文本提示2 */

@property(nonatomic,assign) BOOL isShowCtl;

@property(nonatomic, copy) OfferPartyTipsBlock clickBlock;

@property (strong, nonatomic) OfferPartyTalentsModel *offerPartyModel;

-(void)showViewCtl;
-(void)hideViewCtl;
- (void)getPersonInterviewState;

@end
