//
//  SalaryCompeteCtl.m
//  Association
//
//  Created by 一览iOS on 14-2-13.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "SalaryCompeteCtl.h"
#import "SalaryCompareQueryListCtl.h"
#import "SalaryCompareOrderListCtl.h"
#import "NoLoginPromptCtl.h"
#import "BuySalaryServiceCtl.h"
#import "SalaryFutureListCtl.h"

@interface SalaryCompeteCtl () <NoLoginDelegate>
{
    RequestCon *_querySalaryCountCon;// 使用数
    __weak IBOutlet UILabel *_orderCountLb;
    
    __weak IBOutlet UIImageView *titleRightImage;
}
@end

@implementation SalaryCompeteCtl
@synthesize type_,haveKw_,kwFlag_;

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"查询";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isEnablePop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    UITapGestureRecognizer *singleTapRecognizer = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap)];
    [self.view addGestureRecognizer:singleTapRecognizer];
    
    salaryTF_.layer.borderWidth = 1.0;
    salaryTF_.layer.borderColor = SalaryTextBorderColor.CGColor;
    salaryTF_.layer.cornerRadius = 4.0;
    
    jobTF_.delegate = self;
    salaryTF_.delegate = self;
    self.scrollView_.scrollEnabled = YES;
    
    if ([Manager shareMgr].regionName_) {
        [regionBtn_ setTitle:[Manager shareMgr].regionName_ forState:UIControlStateNormal];
        [regionBtn_ setTitleColor:SalaryTextColor forState:UIControlStateNormal];
    }
    else{
        [regionBtn_ setTitle:@"你现在在哪里？" forState:UIControlStateNormal];
    }

    [jobTF_ setTextColor:SalaryTextColor];

    
    [salaryTF_ becomeFirstResponder];
    //设置按钮圆角
    [commitBtn_.layer setMasksToBounds:YES];
    [commitBtn_.layer setCornerRadius:4.0];
    [commitBtn_ setTitle:@"薪酬比一比>>" forState:UIControlStateNormal];
    
    //设置圆角
    CALayer *layer=[staticView_ layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setCornerRadius:8.0];
    [layer setBorderColor:[[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor]];

    [_orderCountLb.layer setMasksToBounds:YES];
    [_orderCountLb.layer setCornerRadius:6.0];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.scrollView_.scrollEnabled = NO;
    
    titleRightImage.userInteractionEnabled = YES;
    [titleRightImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeMoneyPathGesture:)]];
    
    //设置未支付订单的数量 orderNumBtn
//    [_orderBtn setTitle:_orderNum forState:UIControlStateNormal];
}

#pragma mark - 看前景点击事件
-(void)seeMoneyPathGesture:(UITapGestureRecognizer *)sender{
    SalaryFutureListCtl *futureCtl = [[SalaryFutureListCtl alloc]init];
    [self.navigationController pushViewController:futureCtl animated:YES];
    [futureCtl beginLoad:nil exParam:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self beginLoad:nil exParam:nil];
    [jobTF_ resignFirstResponder];
    [salaryTF_ resignFirstResponder];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, 0);
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (type_ == 1) {
        [regionBtn_ setTitle:inLocation_ forState:UIControlStateNormal];
    }
    if (type_ == 2) {
        
    }
}


-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    //[salaryTF_ becomeFirstResponder];
    [super beginLoad:dataModal exParam:exParam];
    
    //查询薪指的次数
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAlertView:nil msg:@"该功能需要登录后才能使用" btnTitle:@"确定"];
        return;
    }
    if (!_querySalaryCountCon) {
        _querySalaryCountCon = [self getNewRequestCon:NO];
    }
    [_querySalaryCountCon getSalaryQueryCountWithUserId:userId];
}


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
  
    switch (type) {
        case Request_GetQuerySalaryCount://查询薪指的次数
        {
            NSDictionary *dic = dataArr[0];
            NSString *salaryQueryCount = dic[@"last_select_nums"];
            _orderNum = dic[@"no_pay_cnt"];
            is_free = dic[@"is_free"];
            
            _orderCountLb.text = _orderNum;
            
            if ([is_free isEqualToString:@"1"] && [salaryQueryCount isEqualToString:@""])
            {
                _countLb.hidden = YES;
                _alertLabel.hidden = YES;
                _changeLabel.hidden = YES;
                
                _countLb.text = @"1";
                return;
            }
            
            if (salaryQueryCount) {
                if ([salaryQueryCount integerValue]) {
                    _countLb.text = salaryQueryCount;
                    _countLb.hidden = NO;
                    _alertLabel.hidden = NO;
                    _changeLabel.hidden = NO;
                    return;
                }
                else{
                    _countLb.text = @"0";
                    _countLb.hidden = YES;
                    _alertLabel.hidden = YES;
                    _changeLabel.hidden = YES;
                }
            }
        }
        default:
            break;
    }
}

//返回地区进行查询
- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    regionModel_ = regionModel;
    
    [regionBtn_ setTitle:regionModel.provinceName forState:UIControlStateNormal];
    [regionBtn_ setTitleColor:SalaryTextColor forState:UIControlStateNormal];
    [self refreshLoad:nil];
}


#pragma mark-  选择行业回调
-(void)updateTrade:(personTagModel *)personTagModel
{
    personModel_ = personTagModel;
    [tradeBtn_ setTitle:personTagModel.tagName_ forState:UIControlStateNormal];
    [tradeBtn_ setTitleColor:SalaryTextColor forState:UIControlStateNormal];
}


-(void)btnResponse:(id)sender
{
    [salaryTF_ resignFirstResponder];
    [jobTF_ resignFirstResponder];
    if(sender == regionBtn_)
    {
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        vc.navigationBarStatus = YES;
        vc.blockString = ^(SqlitData *regionModel)
        {
            NSLog(@"%@ %@",regionModel.provinceld, regionModel.provinceName);
            [self chooseCityToSearch:regionModel];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender == tradeBtn_)
    {
        RegInfoThreeCtl *regCtl = [[RegInfoThreeCtl alloc]init];
        [regCtl setType:@"0"];
        [regCtl beginLoad:nil exParam:nil];
        regCtl.delegate = self;
        [self.navigationController pushViewController:regCtl animated:YES];
    }
    else if (sender == commitBtn_)
    {
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [salaryTF_ resignFirstResponder];
            [jobTF_ resignFirstResponder];
        }

        else
        {
            NSString * regionid = [CondictionListCtl getRegionId:regionBtn_.titleLabel.text];
            if (!regionid||regionid == nil || [regionid isEqualToString: @""]) {
                if (![regionBtn_.titleLabel.text isEqualToString:@"全国"]) {
                    [BaseUIViewController showAutoDismissFailView:@"失败提示" msg:@"请选择地区"];
                    return;
                }
            }
            
            if ([jobTF_.text length] == 0) {
                [BaseUIViewController showAutoDismissFailView:@"失败提示" msg:@"请填写职位"];
                return;
            }
            
            if ([salaryTF_.text length] == 0) {
                [BaseUIViewController showAutoDismissFailView:@"失败提示" msg:@"请填写薪资状况"];
                return;
            }
            
            if ([salaryTF_.text intValue] <= 0) {
                [BaseUIViewController showAlertView:@"你骗我吗" msg:@"怎么可能白白帮人打工呢？" btnTitle:@"好好填！"];
                return;
                        
            }
            if ([salaryTF_.text intValue] < 500) {
                [BaseUIViewController showAlertView:@"不可能吧" msg:@"劳动法最低薪资标准可不是这么低哦" btnTitle:@"好好填！"];
                return;
            }
            if ([salaryTF_.text intValue] > 1000000) {
                [BaseUIViewController showAlertView:@"啥？" msg:@"亲，这个是月薪噢！" btnTitle:@"好好填！"];
                return;
            }
            [salaryTF_ resignFirstResponder];
            if (!modal_) {
                modal_ = [[User_DataModal alloc] init];
            }
            
            modal_.regionId_= regionid;
            modal_.salary_ = salaryTF_.text;
            modal_.zym_ = jobTF_.text;
            modal_.dutyCode_ = @"my";
            modal_.regiondetail_ = regionBtn_.titleLabel.text;
            if (personModel_.tagName_) {
                modal_.trade_ = personModel_.tagName_;
            }
            else
                modal_.trade_ = [Manager getUserInfo].tradeName;
            
            if (personModel_.tagId_) {
                modal_.tradeId = personModel_.tagId_;
            }
            else
                modal_.tradeId = [Manager getUserInfo].tradeId;
            
            NSString * regionId = [CondictionListCtl getRegionId:modal_.regiondetail_];
            SalaryCompareResultCtl * salaryCtl = [[SalaryCompareResultCtl alloc] init];
            salaryCtl.regionId_ = regionId;
            if (type_ == 1) {
                salaryCtl.kwFlag_ = @"1";
            }
            else
                salaryCtl.kwFlag_ = kwFlag_;
            
            [self.navigationController pushViewController:salaryCtl animated:YES];
            [salaryCtl beginLoad:modal_ exParam:nil];
        }
       
    }
    else if (sender == _leftButton){//返回
        [self backBarBtnResponse:sender];
    }
    else if (sender == _rightButton){//比拼记录
        SalaryCompareQueryListCtl *queryCtl = [[SalaryCompareQueryListCtl alloc]init];
        [self.navigationController pushViewController:queryCtl animated:YES];
        [queryCtl beginLoad:nil exParam:nil];
    }
    else if (sender == _querySalaryBtn){//查询薪酬
        [self rightBarBtnResponse:sender];
    }
    else if (sender == _orderBtn){//我的订单
        NSInteger count = self.navigationController.childViewControllers.count;
        BaseUIViewController *ctl  =self.navigationController.childViewControllers[count-2];
        if ([ctl isKindOfClass: [SalaryCompareOrderListCtl class]]) {
            [self.navigationController popToViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
            return;
        }
        SalaryCompareOrderListCtl *salaryCompareOrderListCtl = [[SalaryCompareOrderListCtl alloc]init];
        [salaryCompareOrderListCtl beginLoad:nil exParam:nil];
        [self.navigationController pushViewController:salaryCompareOrderListCtl animated:YES];
        return;
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [salaryTF_ resignFirstResponder];
        [jobTF_ resignFirstResponder];
    }
    else
    {
        NSString * regionid = [CondictionListCtl getRegionId:regionBtn_.titleLabel.text];
        if (!regionid||regionid == nil || [regionid isEqualToString: @""]) {
            if (![regionBtn_.titleLabel.text isEqualToString:@"全国"]) {
                [BaseUIViewController showAutoDismissFailView:@"失败提示" msg:@"请选择地区"];
                return;
            }
        }
 
        if ([jobTF_.text length] == 0) {
            [BaseUIViewController showAutoDismissFailView:@"失败提示" msg:@"请填写职位"];
            return;
        }
        
        if ([salaryTF_.text length] == 0) {
            [BaseUIViewController showAutoDismissFailView:@"失败提示" msg:@"请填写薪资状况"];
            return;
        }
        
        if ([salaryTF_.text intValue] <= 0) {
            [BaseUIViewController showAlertView:@"你骗我吗" msg:@"怎么可能白白帮人打工呢？" btnTitle:@"好好填！"];
            return;
            
        }
        if ([salaryTF_.text intValue] < 500) {
            [BaseUIViewController showAlertView:@"不可能吧" msg:@"劳动法最低薪资标准可不是这么低哦" btnTitle:@"好好填！"];
            return;
        }
        if ([salaryTF_.text intValue] > 1000000) {
            [BaseUIViewController showAlertView:@"啥？" msg:@"亲，这个是月薪噢！" btnTitle:@"好好填！"];
            return;
        }
        [salaryTF_ resignFirstResponder];
        if (!modal_) {
            modal_ = [[User_DataModal alloc] init];
        }
        
        modal_.regionId_= regionid;
        modal_.salary_ = salaryTF_.text;
        modal_.zym_ = jobTF_.text;
        modal_.dutyCode_ = @"my";
        modal_.regiondetail_ = regionBtn_.titleLabel.text;
        NSString * regionId = [CondictionListCtl getRegionId:modal_.regiondetail_];
        if (personModel_.tagName_) {
            modal_.trade_ = personModel_.tagName_;
        }
        else
            modal_.trade_ = [Manager getUserInfo].tradeName;
        
        if (personModel_.tagId_) {
            modal_.tradeId = personModel_.tagId_;
        }
        else
            modal_.tradeId = [Manager getUserInfo].tradeId;
        
        NSInteger salaryQueryCount = [_countLb.text intValue];
        
        if ([is_free isEqualToString:@"1"])
        {
            
            SalaryCompareResultCtl * salaryCtl = [[SalaryCompareResultCtl alloc] init];
            salaryCtl.regionId_ = regionId;
            if (type_ == 1) {
                salaryCtl.kwFlag_ = @"1";
            }
            else
                salaryCtl.kwFlag_ = kwFlag_;
            
            salaryCtl.orderId = _orderId;
            [self.navigationController pushViewController:salaryCtl animated:YES];
            [salaryCtl beginLoad:modal_ exParam:nil];

        }
        else if ([is_free isEqualToString:@"0"] || [is_free isEqualToString:@""])
        {
            if (salaryQueryCount > 0)
            {
                SalaryCompareResultCtl * salaryCtl = [[SalaryCompareResultCtl alloc] init];
                salaryCtl.regionId_ = regionId;
                if (type_ == 1) {
                    salaryCtl.kwFlag_ = @"1";
                }
                else{
                    salaryCtl.kwFlag_ = kwFlag_;
                }
                salaryCtl.orderId = _orderId;
                [self.navigationController pushViewController:salaryCtl animated:YES];
                [salaryCtl beginLoad:modal_ exParam:nil];
            }
            else
            {
                //没有查询的次数 跳转到购买的页面
                BuySalaryServiceCtl *buyCtl = [[BuySalaryServiceCtl alloc]init];
                buyCtl.orderNum = _orderNum;
                [self.navigationController pushViewController:buyCtl animated:YES];
                [buyCtl beginLoad:nil exParam:nil];
            }
        }
    }

}
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}
//aleteviewChoose
-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            break;
        default:
            break;
    }
}


#pragma CondictionListDelegate
-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal
{
    if( !dataModal ){
        dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.str_ = @"全国";
    }
    
    switch ( ctl.type_ ) {
        case CondictionType_Region:
        {
            [regionBtn_ setTitle:dataModal.str_ forState:UIControlStateNormal];
            [regionBtn_ setTitleColor:SalaryTextColor forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

#pragma ChooseHotCityDelegate
-(void)chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    [regionBtn_ setTitle:city forState:UIControlStateNormal];
    [regionBtn_ setTitleColor:SalaryTextColor forState:UIControlStateNormal];
    [self refreshLoad:nil];
}

#pragma UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if( textField == salaryTF_ ){
//        [jobTF_ becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == salaryTF_) {
        _placeLabel.hidden = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == salaryTF_) {
        
        if ([salaryTF_.text isEqualToString:@""]) {
            _placeLabel.hidden = NO;
        }
        else
            _placeLabel.hidden = YES;
    }
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [jobTF_ resignFirstResponder];
    [salaryTF_ resignFirstResponder];
}

- (void)viewSingleTap
{
    [jobTF_ resignFirstResponder];
    [salaryTF_ resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
