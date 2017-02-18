//
//  ELMyAccountCtl.h
//  jobClient
//
//  Created by YL1001 on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "PayCtl.h"

@interface ELMyAccountCtl : BaseUIViewController
{
    
    IBOutlet UILabel *balanceMoneyLb_;   /**<余额 */
    IBOutlet UIButton *withdrawBtn_;     /**<提现 */
    IBOutlet UIButton *tradRecordBtn_;   /**<交易记录 */
    IBOutlet UIButton *leftBtn_;         /**<返回按钮 */
    
    IBOutlet UIView *withdrawBgView_;    /**<提现背景View */
    IBOutlet UITextField *aliPayTF_;     /**<支付宝账户 */
    IBOutlet UITextField *phoneNumTF_;   /**<手机 */
    IBOutlet UITextField *userNameTF_;   /**<用户名 */
    IBOutlet UIButton *sureBtn_;         /**<确认按钮 */
    IBOutlet UIButton *cancelBtn_;       /**<关闭按钮 */
    IBOutlet UIButton *authCodeBtn;      /**<验证码 */
    
}

@property(nonatomic, copy) NSString *balance;//账户余额
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_;

#pragma mark 支付宝认证登录
//- (void)authLogin;

@end
