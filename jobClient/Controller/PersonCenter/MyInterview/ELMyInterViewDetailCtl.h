//
//  ELMyInterViewDetailCtl.h
//  jobClient
//
//  Created by YL1001 on 15/11/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface ELMyInterViewDetailCtl : BaseEditInfoCtl
{
    //约谈内容
    IBOutlet UIView *headerView;
    IBOutlet UIImageView *redPoint1;
    IBOutlet UIImageView *redPoint2;
    IBOutlet UIImageView *redPoint3;
    IBOutlet UIImageView *redPoint4;
    IBOutlet UIImageView *redPoint5;
    
    IBOutlet UIView *redLine1;
    IBOutlet UIView *redLine2;
    IBOutlet UIView *redLine3;
    IBOutlet UIView *redLine4;
    
    IBOutlet UILabel *applyLb;    /**<约谈申请 */
    IBOutlet UILabel *acceptLb;   /**<行家接受 */
    IBOutlet UILabel *payLb;      /**<用户付款 */
    IBOutlet UILabel *confirmLb;  /**<完成约谈 */
    IBOutlet UILabel *appraiseLb; /**<用户评价 */
    
    
    IBOutlet UIView *DetailBgView;
    IBOutlet UIView *interviewInfoView;  /**<话题卡片 */
    IBOutlet UIImageView *personImg;     /**<头像 */
    IBOutlet UILabel *nameLb;            /**名字 */
    IBOutlet UILabel *tipsLb;
    
    IBOutlet UILabel *titleLb;   /**<话题标题 */
    IBOutlet UILabel *dateLb;    /**<话题时间 */
    IBOutlet UILabel *courseTimeLb;   /**<话题时长 */
    IBOutlet UILabel *coursePriceLb;  /**<话题价格 */
    
    IBOutlet UIView *bgView1;        /**<描述问题View */
    IBOutlet UILabel *questionLb;    /**<问题Label */
    
    IBOutlet UIView *bgView;         /**<个人情况View */
    IBOutlet UILabel *personTip;
    IBOutlet UILabel *personInfoLb;  /**<个人情况Label */
    
    IBOutlet UIView *acceptBtnView; /**<接受约谈View */
    IBOutlet UIButton *refuseBtn;   /**<拒绝约谈 */
    IBOutlet UIButton *acceptBtn;   /**<接受约谈 */
    
    IBOutlet UIView *goPayView;
    IBOutlet UIButton *goPayBtn;        /**<去支付 */
    IBOutlet UIButton *cancelOrderBtn;  /**<取消订单 */
    
    IBOutlet UILabel *tipsLb1;
    
    IBOutlet UIView *timeAndPlaceView;
    IBOutlet UILabel *tipsLb2;
    
    IBOutlet UIView *ytzRefundView;    /**<约谈者退款申请 */
    IBOutlet UILabel *refundReasonLb;  /**<约谈者退款原因 */
    IBOutlet UILabel *tipsLb3;
    IBOutlet UILabel *refundTimeLb;    /**<约谈者退款时间 */
    
    IBOutlet UIView *bytzRefundView;    /**<被约谈者退款卡片 */
    IBOutlet UILabel *refundReasonLb2;  /**<被约谈者退款原因 */
    IBOutlet UILabel *refundTimeLb2;    /**<被约谈者退款时间 */
    IBOutlet UIButton *agreeRefundBtn;  /**<被约谈者同意退款 */
    IBOutlet UIButton *noRefundBtn;     /**<被约谈者拒绝退款 */
    IBOutlet UILabel *refundTitleLb;

}
@end
