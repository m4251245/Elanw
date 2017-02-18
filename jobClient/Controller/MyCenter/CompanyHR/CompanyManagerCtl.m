//
//  CompanyManagerCtl.m
//  jobClient
//
//  Created by YL1001 on 15/1/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CompanyManagerCtl.h"
#import "Manager.h"
#import "UIButton+WebCache.h"

@interface CompanyManagerCtl ()
{
    NSString * companyId_;
    BOOL       bOpen_;
}

@end

@implementation CompanyManagerCtl

-(id)init
{
    self = [super init];
    companyHrCtl_ = [[CompanyHRCtl alloc] init];
    companySearchCtl_ = [[CompanySearchCtl alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    leftSwipeGestureRecognizer_ = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
   rightSwipeGestureRecognizer_ = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer_.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer_.direction = UISwipeGestureRecognizerDirectionRight;
    
    [centerView_ addGestureRecognizer:rightSwipeGestureRecognizer_];
    [centerView_ addGestureRecognizer:leftSwipeGestureRecognizer_];
    segmentedView_.layer.cornerRadius = 4.0;
    segmentedView_.layer.masksToBounds = YES;
    segmentedView_.layer.borderWidth = 1;
    segmentedView_.layer.borderColor = UIColorFromRGB(0xfa3435).CGColor;
    
    [leftBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    [leftBtn_ setBackgroundColor:UIColorFromRGB(0xfa3435)];
    [leftBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn_ setTitle:@"看简历" forState:UIControlStateNormal];
    [leftBtn_.layer setMasksToBounds:YES];
    [leftBtn_.layer setCornerRadius:4.0];
    
    [rightBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    [rightBtn_ setBackgroundColor:[UIColor whiteColor]];
    [rightBtn_ setTitle:@"搜简历" forState:UIControlStateNormal];
    [rightBtn_ setTitleColor:UIColorFromRGB(0xfa3435) forState:UIControlStateNormal];
    [rightBtn_.layer setMasksToBounds:YES];
    [rightBtn_.layer setCornerRadius:4.0];
    
    scrollView_.delegate = self;
    scrollView_.scrollEnabled = NO;
    [scrollView_ setContentSize:CGSizeMake(2*scrollView_.frame.size.width, 1)];
    
    [scrollView_ addSubview:companyHrCtl_.view];
    [scrollView_ addSubview:companySearchCtl_.view];
    companyHrCtl_.view.frame = scrollView_.bounds;
    companySearchCtl_.view.frame = scrollView_.bounds;
    
    CGRect rect = companySearchCtl_.view.frame;
    rect.origin.x = rect.size.width * 1;
    [companySearchCtl_.view setFrame:rect];
    
    [scrollView_ setContentOffset:CGPointMake(modelIndex_*scrollView_.frame.size.width, 0) animated:YES];
    
    companyCenterBtn_.layer.cornerRadius = 18.0;
    companyCenterBtn_.layer.masksToBounds = YES;
    companyCenterBtn_.layer.borderWidth = 0.5;
    companyCenterBtn_.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (IOS7) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (IOS7) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

-(void)updateCom:(RequestCon *)con
{
    if(myModal_)
    {
        [companyCenterBtn_ setImageWithURL:[NSURL URLWithString:myModal_.logoPath_] forState:UIControlStateNormal];
        [cLogo_ setImageWithURL:[NSURL URLWithString:myModal_.logoPath_]];
        [cNameLb_ setText:myModal_.cname_];
        if (myModal_.questionCnt_ > 0) {
            redDotImg_.alpha = 1.0;
            questionCntLb_.text = [NSString stringWithFormat:@"%ld",(long)myModal_.questionCnt_];
        }
        else
        {
            redDotImg_.alpha = 0.0;
            questionCntLb_.text = @"";
        }
    }
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    myModal_ = nil;
    [super beginLoad:dataModal exParam:exParam];
    [companyHrCtl_ beginLoad:dataModal exParam:exParam];
    [companySearchCtl_ beginLoad:dataModal exParam:exParam];
    [self changeModel:0];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    [con companyHRDetail:companyId_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_CompanyHRDetail:
        {
            myModal_ = [dataArr objectAtIndex:0];
            [Manager getUserInfo].companyModal_ = myModal_;
            [companyHrCtl_ updateCount:myModal_];
            
        }
            break;
        case Request_CancelBindCompany:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"解绑成功" msg:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"解绑失败" msg:@"请稍后再试"];
            }
        }
            break;
        default:
            break;
    }
}

-(void)showLoadingView:(BOOL)flag
{
    [super showLoadingView:NO];
}


-(void)changeModel:(int)index
{
    [companySearchCtl_ hideKeyboard];
    [self changeBtnStatus:index];
    [scrollView_ setContentOffset:CGPointMake(index*scrollView_.frame.size.width, 0) animated:YES];
    
    modelIndex_ = index;
    
    switch ( index ) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}


-(void)changeBtnStatus:(int)index
{
    switch (index) {
        case 0:
        {
            [leftBtn_ setBackgroundColor:UIColorFromRGB(0xfa3435)];
            [leftBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [rightBtn_ setBackgroundColor:[UIColor whiteColor]];
            [rightBtn_ setTitleColor:UIColorFromRGB(0xfa3435) forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [rightBtn_ setBackgroundColor:UIColorFromRGB(0xfa3435)];
            [rightBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [leftBtn_ setBackgroundColor:[UIColor whiteColor]];
            [leftBtn_ setTitleColor:UIColorFromRGB(0xfa3435) forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}



#pragma UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( scrollView_ == scrollView )
    {
        CGFloat pageWidth = scrollView_.frame.size.width;
        int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if( pageIndex != modelIndex_ ){
            [self changeModel:pageIndex];
        }
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == companyCenterBtn_) {
        [companySearchCtl_ hideKeyboard];
        if (!bOpen_) {
            [UIView beginAnimations:nil context:nil];
            CGRect rect = centerView_.frame;
            rect.origin.x = -200;
            centerView_.frame = rect;
            [UIView commitAnimations];
            if( !singleTapRecognizer_ )
                singleTapRecognizer_ = [MyCommon addTapGesture:centerView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
        }
        else
        {
            [UIView beginAnimations:nil context:nil];
            CGRect rect = centerView_.frame;
            rect.origin.x = 0;
            centerView_.frame = rect;
            [UIView commitAnimations];
            [MyCommon removeTapGesture:centerView_ ges:singleTapRecognizer_];
            singleTapRecognizer_ = nil;
        }
        bOpen_ = !bOpen_;
    }
    else if (sender == leftBtn_){
        [self changeModel:0];
    }
    else if (sender == rightBtn_){
        [self changeModel:1];
    }
    else if(sender == wgzBtn_){
        ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
        dataModel.companyID_ = myModal_.companyID_;
        dataModel.companyName_ = myModal_.cname_;
        dataModel.companyLogo_ = myModal_.logoPath_;
        PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
        positionCtl.type_ = 3;
        [self.navigationController pushViewController:positionCtl animated:YES];
        [positionCtl beginLoad:dataModel exParam:nil];
    }
    else if (sender == interviewBtn_){
        CompanyInterviewCtl * companyInterviewCtl = [[CompanyInterviewCtl alloc] init];
        [self.navigationController pushViewController:companyInterviewCtl animated:YES];
        [companyInterviewCtl beginLoad:companyId_ exParam:nil];
        
    }
    else if (sender == jianliBtn_){
        ComColllectResumeCtl *comCollectResumeCtl_ = [[ComColllectResumeCtl alloc] init];
        [self.navigationController pushViewController:comCollectResumeCtl_ animated:YES];
        [comCollectResumeCtl_ beginLoad:companyId_ exParam:nil];
    }
    else if (sender == questionBtn_){
        questionCntLb_.text = @"";
        redDotImg_.alpha = 0.0;
        CompanyQuestionCtl  *companyQuestionCtl_  = [[CompanyQuestionCtl alloc] init];
        [self.navigationController pushViewController:companyQuestionCtl_ animated:YES];
        [companyQuestionCtl_ beginLoad:companyId_ exParam:nil];
    }
    else if (sender == zbarLoginBtn_){
        //扫描登陆
        ZBarScanLoginCtl *scanCtl = [[ZBarScanLoginCtl alloc]init];
        scanCtl.inDataModel =  myModal_;
        [[Manager shareMgr].centerNav_ pushViewController:scanCtl animated:YES];
    }
    else if(sender == serviceBtn_){
        ServiceInfoCtl * serviceInfoCtl = [[ServiceInfoCtl alloc] init];
        [self.navigationController pushViewController:serviceInfoCtl animated:YES];
        [serviceInfoCtl beginLoad:companyId_ exParam:nil];
    }
    else if (sender == backBtn_){
        if (IOS7) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    
    bOpen_ = NO;
    [UIView beginAnimations:nil context:nil];
    CGRect rect = centerView_.frame;
    rect.origin.x = 0;
    centerView_.frame = rect;
    [UIView commitAnimations];
    [MyCommon removeTapGesture:centerView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
}

//滑动视图
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    [companySearchCtl_ hideKeyboard];
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (!bOpen_) {
            [UIView beginAnimations:nil context:nil];
            CGRect rect = centerView_.frame;
            rect.origin.x = -200;
            centerView_.frame = rect;
            [UIView commitAnimations];
            bOpen_ = YES;
            if( !singleTapRecognizer_ )
                singleTapRecognizer_ = [MyCommon addTapGesture:centerView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
        }
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (bOpen_) {
            [UIView beginAnimations:nil context:nil];
            CGRect rect = centerView_.frame;
            rect.origin.x = 0;
            centerView_.frame = rect;
            [UIView commitAnimations];
            bOpen_ = NO;
            [MyCommon removeTapGesture:centerView_ ges:singleTapRecognizer_];
            singleTapRecognizer_ = nil;
        }
        
    }
}

-(void)jumpToQuestion
{
    [self performSelector:@selector(jump) withObject:nil afterDelay:1.0f];
}

- (void)jump
{
    questionCntLb_.text = @"";
    redDotImg_.alpha = 0.0;
    CompanyQuestionCtl  *companyQuestionCtl_  = [[CompanyQuestionCtl alloc] init];
    [[Manager shareMgr].centerNav_ pushViewController:companyQuestionCtl_ animated:YES];
    [companyQuestionCtl_ beginLoad:companyId_ exParam:nil];
}

@end
