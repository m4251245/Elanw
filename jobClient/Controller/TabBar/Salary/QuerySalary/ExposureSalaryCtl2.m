//
//  ExposureSalaryCtl2.m
//  jobClient
//
//  Created by 一览ios on 15/5/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ExposureSalaryCtl2.h"
#import "ChangeRegionViewController.h"
#import "NoLoginPromptCtl.h"

@interface ExposureSalaryCtl2 ()<NoLoginDelegate>
{
    UITapGestureRecognizer *singleTapRecognizer_;
    RequestCon *_getExposureTitleCon;//获取曝工资的标题
    RequestCon *_saveExposureSalaryCon;//保存曝工资
    NSString *_articleId;
    
    __weak IBOutlet NSLayoutConstraint *contentViewHeight;
    
}
@end

@implementation ExposureSalaryCtl2


- (void)viewDidLoad {
    [super viewDidLoad];
    _companyTF.delegate = self;
    _jobTF.delegate = self;
    _salaryTF.delegate = self;
    _cityTF.delegate = self;
    _commentTF.delegate = self;
    NSString *locCity = [Manager shareMgr].regionName_;
    if (locCity && ![locCity isEqualToString:@""]) {
        NSString *regionId = [CondictionListCtl getRegionId:locCity];
        _cityTF.text = locCity;
        _selectRegionId = regionId;
    }
    CALayer *layer = _companyview.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _jobView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _salaryView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _commentView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _cityView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer = _noNamePublishBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    _edgeImgv.image = [[UIImage imageNamed:@"icon_salary_edge.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:2];
//    _edgeImgv.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_edgeImgv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_cotentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];
//    [self.view addConstraint:constraint];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MyCommon  addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewTaped:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow1:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide1:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if(!_getExposureTitleCon){
        _getExposureTitleCon = [self getNewRequestCon:NO];
    }
    [_getExposureTitleCon getExposureTitle];
}

- (void)getDataFunction:(RequestCon *)con
{
    [super updateCom:con];
    
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_ExposureTitle://曝工资标题
        {
            if (dataArr.count) {
                NSDictionary *data = dataArr[0];
                NSString *title = data[@"title"];
                _titleLb.text = title;
                _commentTF.placeholder = data[@"tip"];
                
                _articleId = data[@"article_id"];
//                CGSize size = [title sizeWithFont:THIRTEENFONT_CONTENT];
//                if (size.width>262) {
//                    size.width = 262;
//                }
//                CGRect frame = _titleLb.frame;
//                frame.size.width = size.width;
//                _titleLb.frame = frame;
//                CGFloat addBtnX = CGRectGetMaxX(_titleLb.frame);
//                frame = _addBtn.frame;
//                frame.origin.x = addBtnX;
//                _addBtn.frame = frame;
            }
           
        }
            break;
         case Request_SaveExposureSalary://保存曝工资的信息
        {
            Status_DataModal *status = dataArr[0];
            if( [status.code_ isEqualToString:@"200"] ){
                if ([status.status_ isEqualToString:Success_Status]) {
                    [BaseUIViewController showAutoDismissAlertView:nil msg:@"曝工资成功" seconds:2.0];
                }else{
                    [BaseUIViewController showAutoDismissAlertView:nil msg:status.des_ seconds:2.0];
                }
                
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
                if (_finishBlock) {
                    _finishBlock(YES);
                }
                
            }else{
                [BaseUIViewController showAlertView:nil msg:@"保存失败,请稍后再试" btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
}




#pragma mark - Responding to keyboard events
- (void)keyboardWillShow1:(NSNotification *)notification {
    
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
    [MyCommon  addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewTaped:)];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (_currentTF) {
        CGPoint point = [_currentTF.superview convertPoint:_currentTF.frame.origin toView:self.view];
        CGFloat temp = 45;
        point.y = point.y +temp;
        CGFloat move;
        CGFloat keyboardH = CGRectGetHeight(keyboardRect);
        CGFloat selfH = CGRectGetHeight(self.view.frame);
        if (point.y>selfH - keyboardH) {
            move = point.y - (selfH - keyboardH);
            CGRect frame = self.view.frame;
            frame.origin.y = 0-move;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = frame;
            }];
        }
        
    }
    
}

#pragma mark
- (void)viewTaped:(UIGestureRecognizer *)sender
{
    if ([_currentTF isFirstResponder]) {
        [_currentTF resignFirstResponder];
        _currentTF = nil;
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
        return;
    }
    
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0-self.view.bounds.size.height-200, ScreenWidth, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (_finishBlock) {
            _finishBlock(NO);
        }
    }];
}

- (void)keyboardWillHide1:(NSNotification *)notification {
    
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
//    NSDictionary* userInfo = [notification userInfo];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnResponse:(id)sender
{
    if (sender == _addBtn) {//添加工资评论
        if (_commentView.hidden) {
            _commentView.hidden = NO;
            contentViewHeight.constant = 388;
            [UIView animateWithDuration:0.3 animations:^
            {
                [self.view layoutIfNeeded];
//                CGFloat btnY = CGRectGetMaxY(_commentView.frame) +15;
//                CGRect frame = _noNamePublishBtn.frame;
//                frame.origin.y = btnY;
//                _noNamePublishBtn.frame = frame;
//                
//                CGFloat contentViewH = CGRectGetMaxY(_noNamePublishBtn.frame) +50;
//                frame = _cotentView.frame;
//                frame.size.height = contentViewH;
//                _cotentView.frame = frame;
            }];
        }
        else
        {
            contentViewHeight.constant = 338;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
                //                CGFloat btnY = CGRectGetMinY(_commentView.frame);
//                CGRect frame = _noNamePublishBtn.frame;
//                frame.origin.y = btnY;
//                _noNamePublishBtn.frame = frame;
//                
//                CGFloat contentViewH = CGRectGetMaxY(_noNamePublishBtn.frame) +50;
//                frame = _cotentView.frame;
//                frame.size.height = contentViewH;
//                _cotentView.frame = frame;
            } completion:^(BOOL finished) {
                _commentView.hidden = YES;
            }];
        }
        
    }else if (sender == _noNamePublishBtn){//匿名发表曝工资
        if (![self validateForm]) {
            return;
        }
        NSString *userId = [Manager getUserInfo].userId_;
        if (![Manager shareMgr].haveLogin)
        {
            userId = @"";
        }
        if (!_saveExposureSalaryCon) {
            _saveExposureSalaryCon = [self getNewRequestCon:NO];
        }
        
        if (!_articleId) {
            _articleId = @"";
        }
        
        NSString *comment = _commentTF.text;
        if (!comment) {
            comment = @"";
        }
        _selectRegionId = [CondictionListCtl getRegionId:_cityTF.text];
        if (_selectRegionId.length <= 0)
        {
            _selectRegionId = @"100000";
        }
       
        [_saveExposureSalaryCon saveExposureSalaryInfo:_companyTF.text job:_jobTF.text salary:_salaryTF.text regionId:_selectRegionId userId:userId article:_articleId comment:comment clientId:[Common idfvString]];
        
        
    }else if (sender == _cityBtn){
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        __weak typeof(ExposureSalaryCtl2) *weakSelf = self;
        vc.blockString = ^(SqlitData *regionModel)
        {
            NSLog(@"%@ %@",regionModel.provinceld, regionModel.provinceName);
            weakSelf.cityTF.text = regionModel.provinceName;
            weakSelf.selectRegionId = regionModel.provinceld;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 验证
- (BOOL)validateForm
{
    if([[_companyTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        [BaseUIViewController showAlertView:nil msg:@"请填写公司名称" btnTitle:@"确定"];
        [_companyTF becomeFirstResponder];
        return false;
    }else if([[_jobTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        [BaseUIViewController showAlertView:nil msg:@"请填写职位名称" btnTitle:@"确定"];
        [_jobTF becomeFirstResponder];
        return false;
    }else if([[_salaryTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        [BaseUIViewController showAlertView:nil msg:@"请填写税前月薪" btnTitle:@"确定"];
        [_salaryTF becomeFirstResponder];
        return false;
    }else if([[_cityTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        [BaseUIViewController showAlertView:nil msg:@"请选择城市" btnTitle:@"确定"];
        return false;
    }
    
    if (!([_salaryTF.text integerValue] >0)) {
        [BaseUIViewController showAlertView:nil msg:@"月薪需大于0" btnTitle:@"确定"];
        return false;
    }
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTF = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == _companyTF){
        [_jobTF becomeFirstResponder];
    }else if (textField == _jobTF){
        [_salaryTF becomeFirstResponder];
    }
    return YES;
}

#pragma mark 退出登录
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

@end
