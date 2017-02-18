//
//  EditorWorkExperienceCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "EditorWorkExperienceCtl.h"
#import "WorkResume_DataModal.h"
#import "ELChangeDateCtl.h"
#import "SBJson.h"
#import "Person_workDataModel.h"

#import "PositonType.h"

typedef enum
{
    WorkStart,
    WorkEnd,
}TimeType;

@interface EditorWorkExperienceCtl ()<UIScrollViewDelegate>
{
    Person_workDataModel *workVO;
    WorkResume_DataModal *model;
    PreCondictionListCtl    *preCondictionListCtl;
    TimeType    timeType;
    NSString            *newFlag;
    BOOL                showDetailFlag;
    UIView              *superView;
    
    __weak IBOutlet UITextField *_startTimeTf;
    __weak IBOutlet UITextField *_endTimeTf;
    __weak IBOutlet UITextView *_jobDesTv;
    __weak IBOutlet UILabel *_wordsNumLb;
    __weak IBOutlet UILabel *_tipsLb;
    
    NSInteger addOrEditor;
    
    ELChangeDateCtl *changeDateCtl;
    NSDate *startDateOne;
    NSDate *endDateOne;
    
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    UIView *viewTF;
    id currentTF;
    
    NSString *timeStart;
    NSString *timeEnd;
    int btnClickTag;
}

@property (weak, nonatomic) IBOutlet UIButton *jobType;


@end

@implementation EditorWorkExperienceCtl
#pragma mark - LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        rightNavBarStr_ = @"删除";
        
    }
    return self;
}

//设置右按扭的属性
//- (void)setRightBarBtnAtt
//{
//    [rightBarBtn_ setTitle:@"删除" forState:UIControlStateNormal];
//    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
//    [rightBarBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (addOrEditor == 1) {
//        self.navigationItem.title = @"编辑工作经历";
        [self setNavTitle:@"编辑工作经历"];
        rightBarBtn_.hidden = NO;
    }
    else
    {
//        self.navigationItem.title = @"添加工作经历";
        [self setNavTitle:@"添加工作经历"];
        rightBarBtn_.hidden = YES;
    }
    self.toolbarHolder.hidden = YES;
    _saveBtn.clipsToBounds = YES;
    _saveBtn.layer.cornerRadius = 4.0;
    [self configUI];
}

-(void)configUI{
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.scrollView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    _memberCountBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.f];
    _companyNatureBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.f];
    
    _memberCountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _companyNatureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [_memberCountBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [_companyNatureBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    
    [_salaryTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewDidAppear:(BOOL)animated{
//    self.scrollView_.contentSize = CGSizeMake(ScreenWidth, 100 + ScreenHeight);
}

-(void)viewSingleTap:(id)sender
{
    [super viewSingleTap:sender];
    [self hideKeyBoardOne];
}

#pragma mark - NetWork
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    workVO = dataModal;
    //    model = dataModal;
    newFlag = exParam;
    
    addOrEditor = [exParam integerValue];
    [self loadData];
}

-(void)loadData{
    model = [WorkResume_DataModal new];
    model.companyName_ = workVO.company;
    model.startDate_ = workVO.startdate;
    model.endDate_ = workVO.stopdate;
    model.des_ = workVO.workdesc;
    model.monthSalary_ = workVO.salarymonth;
    model.cxz_ = workVO.cxz;
    model.yuangong_ = workVO.yuangong;
    model.zw_ = workVO.jtzwtype;
    model.zwName_ = workVO.jtzw;
    model.workId_ = workVO.workId;
    model.bCompanySercet_ = workVO.companykj;
    
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (workVO) {
        [_companyNameTf setText:workVO.company];
        if ([workVO.companykj isEqualToString:@"1"]) {
            [_secretBtn setImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
        }else{
            [_secretBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
        }
        
        [_positionNameTf setText:workVO.jtzw];
        timeStart = workVO.startdate;
        NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",workVO.startdate];
        _startTimeTf.text = [workVO.startdate substringWithRange:NSMakeRange(0, 7)];
        
        startDateOne = [startTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
    
        if (workVO.istonow && [workVO.istonow isEqualToString:@"1"] )
        {
            _endTimeTf.text = @"至今";
            endDateOne = [NSDate date];
        }
        else
        {
            if (workVO.stopdate.length < 7) {
                return;
            }
            timeEnd = workVO.stopdate;
            NSString *endTime = [NSString stringWithFormat:@"%@ 00:00:00",workVO.stopdate];
            _endTimeTf.text = [workVO.stopdate substringWithRange:NSMakeRange(0, 7)];
            
            endDateOne = [endTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
        }
        if (workVO.workdesc == nil) {
            _tipsLb.hidden = NO;
            _jobDesTv.text = @"";
        }
        else
        {
            _tipsLb.hidden = YES;
            _jobDesTv.text = workVO.workdesc;
        }
        
        if (workVO.yuangong == nil) {
            [_memberCountBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [_memberCountBtn setTintColor:UIColorFromRGB(0xcccccc)];
            [_memberCountBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
        }
        else
        {
            [_memberCountBtn setTitle:workVO.yuangong forState:UIControlStateNormal];
            [_memberCountBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }
        
        if (workVO.cxz == nil) {
            [_companyNatureBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [_companyNatureBtn setTintColor:UIColorFromRGB(0xcccccc)];
            [_companyNatureBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
        }
        else
        {
            [_companyNatureBtn setTitle:workVO.cxz forState:UIControlStateNormal];
            [_companyNatureBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }
        if(workVO.jtzwtype.length > 0){
            [_jobType setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [_jobType setTitle:workVO.jtzwtype forState:UIControlStateNormal];
        }
        else{
            [_jobType setTitle:@"请选择" forState:UIControlStateNormal];
            [_jobType setTintColor:UIColorFromRGB(0xcccccc)];
            [_jobType setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
        }
        _salaryTextField.text = workVO.salarymonth;
        [self textViewDidChange:_jobDesTv];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [super textFieldShouldBeginEditing:textField];
    superView = [textField superview];
    if (textField == _startTimeTf)
    {
        [self hideKeyBoardOne];
        if (!changeDateCtl)
        {
            changeDateCtl = [[ELChangeDateCtl alloc] init];
        }
        changeDateCtl.showTodayBtn = NO;
        [changeDateCtl showViewCtlCurrentDate:startDateOne WithBolck:^(CondictionList_DataModal *dataModal)
         {
             if ([dataModal.changeDate timeIntervalSinceDate:endDateOne] > 0 && ![_endTimeTf.text isEqualToString:@"至今"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"入职时间大于离职时间"    delegate:nil
                                                       cancelButtonTitle:@"关闭"
                                                       otherButtonTitles:nil];
                 [alert show];
                 return ;
             }
             model.startDate_ = dataModal.oldString;
             model.startDate_ = [model.startDate_ substringToIndex:7];
             _startTimeTf.text = model.startDate_;
             startDateOne = dataModal.changeDate;
             timeStart = dataModal.oldString;
         }];
        
        return NO;
    }
    else if (textField == _endTimeTf)
    {
        [self hideKeyBoardOne];
        if (!changeDateCtl)
        {
            changeDateCtl = [[ELChangeDateCtl alloc] init];
        }
        changeDateCtl.showTodayBtn = YES;
        [changeDateCtl showViewCtlCurrentDate:endDateOne WithBolck:^(CondictionList_DataModal *dataModal)
         {
             if(![dataModal.pId_ isEqualToString:@"至今"])
             {
                 if ([startDateOne timeIntervalSinceDate:dataModal.changeDate] > 0)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"入职时间大于离职时间"    delegate:nil
                                                           cancelButtonTitle:@"关闭"
                                                           otherButtonTitles:nil];
                     [alert show];
                     return ;
                 }
                 
                 model.endDate_ = dataModal.oldString;
                 model.endDate_ = [model.endDate_ substringToIndex:7];
                 _endTimeTf.text = model.endDate_;
                 endDateOne = dataModal.changeDate;
                 timeEnd = dataModal.oldString;
             }
             else
             {
                 _endTimeTf.text = dataModal.pId_;
                 model.endDate_ = dataModal.pId_;
             }
         }];
        return NO;
    }
    else if (textField == _salaryTextField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    UIView *view = textField.superview;
    CGRect rect1 = [view convertRect:textField.frame toView:self.view];
    viewTF = view;
    currentTF = textField;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        self.scrollView_.contentOffset = CGPointMake(0,height + self.scrollView_.contentOffset.y);
    }
    return YES;
}

-(void)hideKeyBoardOne
{
    [_salaryTextField resignFirstResponder];
    [_companyNameTf resignFirstResponder];
    [_positionNameTf resignFirstResponder];
    [_startTimeTf resignFirstResponder];
    [_endTimeTf resignFirstResponder];
    [_jobDesTv resignFirstResponder];
}

#pragma mark - UITextViewDelegate
-(void)textFieldDidChange:(UITextField *)textField{
    if ([textField isEqual:_salaryTextField]){
        if (textField.text.length > 9) {
            textField.text = [textField.text substringToIndex:9];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"输入的数字太长"    delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _jobDesTv)
    {
        [MyCommon dealLabNumWithTipLb:_tipsLb numLb:_wordsNumLb textView:_jobDesTv wordsNum:2000];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _tipsLb.hidden = YES;
    superView = [textView superview];
    
    UIView *view = textView.superview;
    CGRect rect1 = [view convertRect:textView.frame toView:self.view];
    viewTF = view;
    currentTF = textView;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        self.scrollView_.contentOffset = CGPointMake(0,height + self.scrollView_.contentOffset.y);
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _tipsLb.hidden = NO;
    }
    
    return YES;
}

- (void)btnResponse:(id)sender
{
    [self hideKeyBoardOne];
    
    if (sender == _secretBtn) {
        if ([model.bCompanySercet_ isEqualToString:@"1"]) {
            model.bCompanySercet_ = @"0";
            [_secretBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
        }else{
            model.bCompanySercet_ = @"1";
            [_secretBtn setImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
        }
    }
    else if (sender == _saveBtn)
    {//保存
//        if (btnClickTag == 0) {
            [_positionNameTf resignFirstResponder];
            [_companyNameTf resignFirstResponder];
            if (![self checkCanSave]) {
                return;
            }
            //model 赋值
            model.companyName_ = [MyCommon removeSpaceAtSides:_companyNameTf.text];
            model.zwName_ = _positionNameTf.text;
            model.startDate_ =  _startTimeTf.text;
            model.endDate_ = _endTimeTf.text;
            model.des_ = _jobDesTv.text;
            model.monthSalary_ = _salaryTextField.text;
            
            if ([newFlag isEqualToString:@"1"]) {//更新数据
                [self updateWorkExperience:model];
            }else{//新增数据
                [self addWorkExperience:model];
            }
//            btnClickTag++;
//        }
    }
    else if (sender == _memberCountBtn)
    {//公司规模
        if (!preCondictionListCtl) {
            preCondictionListCtl = [[PreCondictionListCtl alloc] init];
            preCondictionListCtl.delegate_ = self;
        }
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetCompanyEmployeType];
        [_memberCountBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
    }
    else if (sender == _companyNatureBtn)
    {//公司性质
        if (!preCondictionListCtl) {
            preCondictionListCtl = [[PreCondictionListCtl alloc] init];
            preCondictionListCtl.delegate_ = self;
        }
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetCompanyAttType];
        [_companyNatureBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
    }
    else if(sender == _jobType){
        PositonType *positionTypeVC = [[PositonType alloc]init];
        ZWModel *zwmodel = [[ZWModel alloc]init];
        zwmodel.zp_urlId = @"1000";
        positionTypeVC.inzwmodel = zwmodel;
        positionTypeVC.block = ^(ZWModel *VO){
            if (VO.job_child.length > 0) {
                workVO.jtzwtype = VO.job_child;
            }
            else if(VO.job.length > 0){
                workVO.jtzwtype = VO.job;
            }
            else{
                 workVO.jtzwtype = @"";
            }
            
            [_jobType setTitle:VO.job_child forState:UIControlStateNormal];
            [_jobType setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:positionTypeVC animated:YES];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    [self showChooseAlertView:2 title:@"提示" msg:@"确定要删除此段工作经历吗？" okBtnTitle:@"删除" cancelBtnTitle:@"取消"];
}

//检查是否能保存
-(BOOL) checkCanSave
{
    if( !_startTimeTf.text || [_startTimeTf.text isEqualToString:@""] || [_startTimeTf.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择开始时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if( !_endTimeTf.text || [_endTimeTf.text isEqualToString:@""] || [_endTimeTf.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if( [PreCommon checkStringIsNull:[_companyNameTf.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"公司名称不能为空"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        //恢复输入
        _companyNameTf.text = @"";
        [_companyNameTf becomeFirstResponder];
        return NO;
    }
    if(!(_jobType.titleLabel.text.length > 0) || ([_jobType.titleLabel.text isEqualToString:@"请选择"])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择职位类型"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if( [PreCommon checkStringIsNull:[_positionNameTf.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入职位名称"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        _positionNameTf.text = @"";
        [_positionNameTf becomeFirstResponder];
        return NO;
    }
    if( [PreCommon checkStringIsNull:[_jobDesTv.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写工作内容和职责"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        _jobDesTv.text = @"";
        [_jobDesTv becomeFirstResponder];
        return NO;
    }
    return YES;
}

// YES 表示时间异常
- (BOOL)checkDateWithStartTime:(NSString *)startString endTime:(NSString *)endString
{
    startString = [NSString stringWithFormat:@"%@-01",startString];
    endString = [NSString stringWithFormat:@"%@-01",endString];
    NSDate *startDate = [startString dateFormStringFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [endString dateFormStringFormat:@"yyyy-MM-dd"];
    NSDate *tempDate = [startDate laterDate:endDate];
    if ([tempDate isEqualToDate:startDate]) {
        return YES;  //时间异常
    }else{
        return NO;
    }
}

//检查是否能保存
-(BOOL) checkCanSaveNoAlert
{
    if( [PreCommon checkStringIsNull:[_companyNameTf.text UTF8String]] )
    {
        _companyNameTf.text = @"";
        return NO;
    }
    
    if( !_startTimeTf.text || [_startTimeTf.text isEqualToString:@""] || [_startTimeTf.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        return NO;
    }
    if( !_endTimeTf.text || [_endTimeTf.text isEqualToString:@""] || [_endTimeTf.text isEqualToString:ChooseResume_Null_DefaultValue] )
        
    {
        return NO;
    }
    
    if( [PreCommon checkStringIsNull:[_positionNameTf.text UTF8String]] )
        
    {
        _positionNameTf.text = @"";
        return NO;
    }
    if( [PreCommon checkStringIsNull:[_jobDesTv.text UTF8String]] )
    {
        return NO;
    }
    return YES;
}

#pragma mark - 更新成功回调
//- (void)updateResumeWorkSuccess
//{
//    [_delegate editorSuccess];
//    [self.navigationController popViewControllerAnimated:YES];
//    [_companyNameTf resignFirstResponder];
//    [_positionNameTf resignFirstResponder];
//}

#pragma mark - 删除成功回调
- (void)delegateResumeWorkSuccess
{
    [_delegate editorSuccess];
    [self.navigationController popViewControllerAnimated:YES];
}

// 是否为空或者nil类型
- (BOOL)checkString:(NSString *)string
{
    if (string != nil) {
        if ([[MyCommon removeSpaceAtSides:string] isEqualToString:@""]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

#pragma mark - 条件选择回调
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetCompanyEmployeType:
        {
            model.yuangong_ = dataModal.str_;
            [_memberCountBtn setTitle:model.yuangong_ forState:UIControlStateNormal];
        }
            break;
        case GetCompanyAttType:
        {
            model.cxz_ = dataModal.str_;
            [_companyNatureBtn setTitle:model.cxz_ forState:UIControlStateNormal];
        }
            break;
        case GetBirthDayDateType:
        {
            switch (timeType) {
                case  WorkStart:
                {
                    if(dataModal != nil )
                    {
                        model.startDate_ = dataModal.str_;
                        model.startDate_ = [model.startDate_ substringToIndex:7];
                        _startTimeTf.text = model.startDate_;
                    }
                }
                    break;
                case WorkEnd:
                {
                    if(dataModal != nil )
                    {
                        model.endDate_ = dataModal.str_;
                        model.endDate_ = [model.endDate_ substringToIndex:7];
                        _endTimeTf.text = model.endDate_;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [_positionNameTf resignFirstResponder];
    [_companyNameTf resignFirstResponder];
//    //0新增
//    if ([newFlag isEqualToString:@"0"]) {
//        if ([self checkCanSaveNoAlert]) {
//            [self rightBarBtnResponse:nil];
//        }else{
//            if(_startTimeTf.text.length == 0 && _endTimeTf.text.length == 0 && _companyNameTf.text.length == 0 && [_companyNatureBtn.titleLabel.text isEqualToString:@"请选择"] && [_memberCountBtn.titleLabel.text isEqualToString:@"请选择"] && _positionNameTf.text.length == 0 && _jobDesTv.text.length == 0){
//                [self.navigationController popViewControllerAnimated:YES];
//                return;
//            }
//            else{
//                [self showChooseAlertView:1 title:@"提示" msg:@"你的工作经历还未填写完整，确定要放弃吗？" okBtnTitle:@"放弃" cancelBtnTitle:@"继续填写"];
//            }
//            
//        }
//    }else{
//        [super backBarBtnResponse:sender];
//        [_positionNameTf resignFirstResponder];
//        [_companyNameTf resignFirstResponder];
//    }
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {//放弃修改简历
            if (index == 0) {
                [_positionNameTf resignFirstResponder];
                [_companyNameTf resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 2:
        {//删除工作经历
            if (index == 0) {
                if (_allCount == 1) {
                    [self showChooseAlertView:3 title:@"" msg:@"最后一条工作经历，不能被删除" okBtnTitle:@"确定" cancelBtnTitle:nil];
                }
                else
                {
                    [self deleteWorkExperience];
                }
                
            }
        }
            break;
        default:
            break;
    }
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboarfHeight = keyboardRect.size.height;
    
    CGRect rect1;
    if ([currentTF isKindOfClass:[UITextView class]])
    {
        UITextView *currentTextView = currentTF;
        rect1 = [viewTF convertRect:currentTextView.frame toView:self.view];
    }
    else
    {
        UITextField *currentTextField = currentTF;
        rect1 = [viewTF convertRect:currentTextField.frame toView:self.view];
    }
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        self.scrollView_.contentOffset = CGPointMake(0,height + self.scrollView_.contentOffset.y);
    }
    self.scrollView_.contentInset = UIEdgeInsetsMake(0,0,keyboarfHeight,0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    showKeyBoard = NO;
    self.scrollView_.contentInset = UIEdgeInsetsZero;
    
}

#pragma mark - 更新工作经历信息
- (void)updateWorkExperience:(WorkResume_DataModal *)workModel
{
    BOOL bToNow_ = NO;
    if ([workModel.endDate_ isEqualToString:@"至今"]) {
        bToNow_ = YES;
        NSString *  locationString=[[NSDate date] stringWithFormat:@"YYYY-MM-dd"];
        workModel.endDate_ = locationString;
    }
    

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:workVO.sysUpdatetime forKey:@"sysUpdatetime"];
    [paramDic setObject:workVO.tradeid forKey:@"tradeid"];
    [paramDic setObject:workVO.yearbonus forKey:@"yearbonus"];
    [paramDic setObject:workVO.jtzwtype forKey:@"jtzwtype"];
    [paramDic setObject:workVO.isforeign forKey:@"isforeign"];
    [paramDic setObject:workVO.workdesc forKey:@"workdesc"];
    [paramDic setObject:workVO.totalid forKey:@"totalid"];
    [paramDic setObject:workVO.salaryKj forKey:@"salaryKj"];
    [paramDic setObject:workVO.salaryyear forKey:@"salaryyear"];
    
    [paramDic setObject:workModel.companyName_ forKey:@"company"];
    [paramDic setObject:workModel.zwName_ forKey:@"jtzw"];
    [paramDic setObject:timeStart forKey:@"startdate"];
    if ([_endTimeTf.text isEqualToString:@"至今"]) {
        [paramDic setObject:@"" forKey:@"stopdate"];
    }else{
        [paramDic setObject:timeEnd forKey:@"stopdate"];
    }
    
    [paramDic setObject:workModel.yuangong_ forKey:@"yuangong"];
    [paramDic setObject:workModel.cxz_ forKey:@"cxz"];
    [paramDic setObject:workModel.des_ forKey:@"workdesc"];
    [paramDic setObject:workModel.monthSalary_ forKey:@"salarymonth"];
    [paramDic setObject:workModel.workId_ forKey:@"workId"];
    [paramDic setObject:workModel.bCompanySercet_ forKey:@"companykj"];
//    [paramDic setObject:userId forKey:@"personId"];
    
    if (bToNow_)
    {
        [paramDic setObject:@"1" forKey:@"istonow"];
    }
    else
    {
        [paramDic setObject:@"0" forKey:@"istonow"];
    }
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWrite stringWithObject:paramDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&updateArr=%@",[Manager getUserInfo].userId_,paramStr];
    [BaseUIViewController showLoadView:YES content:@"正在修改" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"updateWork" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
//        NSString *resultStr = [NSString stringWithFormat:@"%@",result];
        
        if ([result[@"status"] isEqualToString:@"OK"]) {
//            if ([_delegate respondsToSelector:@selector(editorSuccess)]) {
//                [_delegate editorSuccess];
//            }
            if (_myBlock) {
                _myBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [BaseUIViewController showLoadView:NO content:@"正在修改" view:nil];
        }
        else
        {
            [BaseUIViewController showLoadView:NO content:@"修改失败" view:nil];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}

#pragma mark - 添加工作经历信息
- (void)addWorkExperience:(WorkResume_DataModal *)newWorkModel
{
    if ([newWorkModel.endDate_ isEqualToString:@"至今"]) {
        NSString *locationString=[[NSDate date] stringWithFormat:@"YYYY-MM-dd"];
        newWorkModel.endDate_ = locationString;
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:newWorkModel.companyName_ forKey:@"company"];
    [paramDic setObject:newWorkModel.zwName_ forKey:@"jtzw"];
    [paramDic setObject:timeStart forKey:@"startdate"];
    if ([_endTimeTf.text isEqualToString:@"至今"]) {
         [paramDic setObject:@"" forKey:@"stopdate"];
        [paramDic setObject:@"1" forKey:@"istonow"];
    }else{
        [paramDic setObject:timeEnd forKey:@"stopdate"];
        [paramDic setObject:@"0" forKey:@"istonow"];
    }
    
    
//    [paramDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    
    if (newWorkModel.yuangong_.length > 0) {
        [paramDic setObject:newWorkModel.yuangong_ forKey:@"yuangong"];
    }
    
    if (newWorkModel.cxz_.length > 0) {
        [paramDic setObject:newWorkModel.cxz_ forKey:@"cxz"];
    }
    
    
    if (newWorkModel.des_.length > 0) {
        [paramDic setObject:newWorkModel.des_ forKey:@"workdesc"];
    }
    
    if (newWorkModel.monthSalary_.length > 0) {
        [paramDic setObject:newWorkModel.monthSalary_ forKey:@"salarymonth"];
    }
    
    if (newWorkModel.bCompanySercet_.length > 0) {
        [paramDic setObject:newWorkModel.bCompanySercet_ forKey:@"companykj"];
    }
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWrite stringWithObject:paramDic];
     [BaseUIViewController showLoadView:YES content:@"正在添加" view:nil];
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&workArr=%@",[Manager getUserInfo].userId_,paramStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"addWork" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSString *resultStr = [NSString stringWithFormat:@"%@",result];
        
        if (resultStr.length > 0) {
           
//            if ([_delegate respondsToSelector:@selector(editorSuccess)]) {
//                [_delegate editorSuccess];
//            }
            if (_myBlock) {
                _myBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
              [BaseUIViewController showLoadView:NO content:@"添加成功" view:nil];
        }
        else
        {
            [BaseUIViewController showLoadView:NO content:@"添加失败" view:nil];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 删除工作经历信息
- (void)deleteWorkExperience
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:workVO.workId forKey:@"workId"];
    [paramDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWrite stringWithObject:paramDic];
    [BaseUIViewController showLoadView:YES content:@"正在删除" view:nil];
    NSString *bodyMsg = [NSString stringWithFormat:@"array=%@",paramStr];
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"deletePersonWorkDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSString *str = result[@"status"];
        if ([str isEqualToString:@"OK"]) {
            if (_myBlock) {
                _myBlock();
            }
            [BaseUIViewController showLoadView:YES content:@"删除成功" view:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
           [BaseUIViewController showLoadView:NO content:@"删除成功" view:nil];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
