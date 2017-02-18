//
//  AboutUsCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "WebLinkCtl.h"
#import "EAIntroView.h"
#import "AgreementCtl.h"

@interface AboutUsCtl : BaseUIViewController<EAIntroDelegate>
{
//    WebLinkCtl  * weblinkCtl_;
//    AgreementCtl * agreementCtl_;
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *versonLb;

@property(nonatomic,weak) IBOutlet  UIButton *  weblinkBtn_;
@property(nonatomic,weak) IBOutlet  UIButton *  introBtn_;
@property(nonatomic,weak) IBOutlet  UIButton *  agreementBtn_;

@end
