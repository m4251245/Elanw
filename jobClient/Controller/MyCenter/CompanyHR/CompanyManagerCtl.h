//
//  CompanyManagerCtl.h
//  jobClient
//
//  Created by YL1001 on 15/1/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "CompanyInfo_DataModal.h"
#import "ZBarScanLoginCtl.h"
#import "CompanyHRCtl.h"
#import "CompanySearchCtl.h"

@interface CompanyManagerCtl : BaseUIViewController<UIScrollViewDelegate>
{
    IBOutlet   UIView           *centerView_;
    IBOutlet   UIView           *segmentedView_;
    IBOutlet   UIButton         *companyCenterBtn_;
    IBOutlet   UIButton         *leftBtn_;
    IBOutlet   UIButton         *rightBtn_;
    IBOutlet   UIScrollView     *scrollView_;
    IBOutlet   UIView           *rightView_;
    IBOutlet   UIImageView      *cLogo_;
    IBOutlet   UILabel          *cNameLb_;
    IBOutlet   UIButton         *wgzBtn_;
    IBOutlet   UIButton         *interviewBtn_;
    IBOutlet   UIButton         *jianliBtn_;
    IBOutlet   UIButton         *questionBtn_;
    IBOutlet   UIButton         *zbarLoginBtn_;
    IBOutlet   UIButton         *serviceBtn_;
    IBOutlet   UIButton         *backBtn_;
    IBOutlet   UIImageView      *redDotImg_;
    IBOutlet   UILabel          *questionCntLb_;
    int                         modelIndex_;
    
    CompanyInfo_DataModal       * myModal_;
    RequestCon                  * jiebangCon_;
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer_;
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer_;
    
    CompanyHRCtl            *companyHrCtl_;
    CompanySearchCtl        *companySearchCtl_;
}

-(void) changeModel:(int)index;

-(void)jumpToQuestion;

@end
