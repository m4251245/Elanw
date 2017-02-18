//
//  ELTrainDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELTrainDetailCtl.h"
#import "PreCondictionListCtl.h"
#import "Person_trainDataModel.h"

@interface ELTrainDetailCtl () <UITextViewDelegate,UITextFieldDelegate,CondictionChooseDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    
    __weak IBOutlet UITextField *institutionTextField;
    
    __weak IBOutlet UITextField *courseTextField;
    __weak IBOutlet UITextField *startTimeTextField;
    
    __weak IBOutlet UITextField *endTimeTextField;
    
    __weak IBOutlet UITextView *contentTextView;
    
    __weak IBOutlet UILabel *contentLable;
    
    __weak IBOutlet UILabel *countLable;
    
    __weak IBOutlet UIButton *saveBtn;
    
    __weak IBOutlet UIScrollView *backScrollView;
    
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    
    UIView *viewTF;
    
    NSString *startTime;
    NSString *endTime;
    
    ELChangeDateCtl *changeDateCtl;
    NSDate *startDateOne;
    NSDate *endDateOne;
}
@end

@implementation ELTrainDetailCtl

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dealData];
    saveBtn.clipsToBounds = YES;
    saveBtn.layer.cornerRadius = 4.0;
    
    if (self.addOrEditor == 1)
    {
        [self setNavTitle:@"添加培训经历"];
        rightBarBtn_.hidden = YES;
    }
    else if (self.addOrEditor == 2)
    {
        [self setNavTitle:@"编辑培训经历"];
        rightBarBtn_.hidden = NO;
        
        institutionTextField.text = _dataModal_.gainDes_;
        courseTextField.text = _dataModal_.name_;
        
        if(_dataModal_.startDate_ && ![_dataModal_.startDate_ isEqualToString:@""] )
        {
            if(_dataModal_.startDate_.length >= 10)
            {
                startTimeTextField.text = [_dataModal_.startDate_ substringWithRange:NSMakeRange(0, 7)];
                startTime = [NSString stringWithFormat:@"%@ 00:00:00",_dataModal_.startDate_];
                
                startDateOne = [startTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
            }
        }
        if( _dataModal_.endDate_ && ![_dataModal_.endDate_ isEqualToString:@""] )
        {
            if(_dataModal_.endDate_.length >= 10)
            {
                endTimeTextField.text = [_dataModal_.endDate_ substringWithRange:NSMakeRange(0, 7)];
                endTime = [NSString stringWithFormat:@"%@ 00:00:00",_dataModal_.endDate_];
                if (![_dataModal_.bToNow_ isEqualToString:@"1"])
                {
                    endDateOne = [endTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
                }
            }
        }
        //判断是否到至今
        if( _dataModal_.bToNow_ && [_dataModal_.bToNow_ isEqualToString:@"1"] )
        {
            endTimeTextField.text = @"至今";
            endTime = @"至今";
            endDateOne = [NSDate date];
        }
        contentTextView.text = _dataModal_.des_;
        [self textViewDidChange:contentTextView];
    }
    
    backScrollView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    backScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    backScrollView.delegate = self;
    
    institutionTextField.delegate = self;
    courseTextField.delegate = self;
    startTimeTextField.delegate = self;
    endTimeTextField.delegate = self;
    contentTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    backScrollView.userInteractionEnabled = YES;
    [backScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];

}

-(void)dealData{
    _dataModal_ = [ProjectResume_DataModal new];
    _dataModal_.id_ = _trainVO.train_id;
    _dataModal_.gainDes_ = _trainVO.train_institution;
    _dataModal_.name_ = _trainVO.train_cource;
    _dataModal_.startDate_ = _trainVO.train_startdate;
    _dataModal_.endDate_ = _trainVO.train_enddate;
    _dataModal_.des_ = _trainVO.train_desc;
    _dataModal_.bToNow_ = _trainVO.train_istonow;
    _dataModal_.cellIndex = _cellIndex;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"删除";
    }
    return self;
}

-(void)hideKeyBoardOne
{
    [institutionTextField resignFirstResponder];
    [courseTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
}

-(void)keyBoardShow:(NSNotification *)notification
{
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboarfHeight = keyboardRect.size.height;
    
    CGRect rect1 = [viewTF convertRect:contentTextView.frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        backScrollView.contentOffset = CGPointMake(0,height + backScrollView.contentOffset.y);
    }
    backScrollView.contentInset = UIEdgeInsetsMake(0,0,keyboarfHeight,0);
}

-(void)keyBoardHide:(NSNotification *)notification
{
    showKeyBoard = NO;
    backScrollView.contentInset = UIEdgeInsetsZero;
}


-(void)rightBarBtnResponse:(id)sender
{
    [super rightBarBtnResponse:sender];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该培训经历?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
    alert.tag = 1001;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
        [searchDic setObject:_dataModal_.id_ forKey:@"train_id"];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *searchStr = [jsonWriter stringWithObject:searchDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"array=%@",searchStr];
        [BaseUIViewController showLoadView:YES content:@"正在删除" view:nil];
        [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"detelePersonTrain" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
         {
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             NSDictionary *dic = result;
             NSString *status = dic[@"status"];
             if ([status isEqualToString:@"OK"])
             {
                 if (self.addOrEditorBlock)
                 {
                     self.addOrEditorBlock(_dataModal_,@"delete");
                 }
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除成功" seconds:1.0];
             }
             else
             {
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除失败" seconds:1.0];
             }
            
             
         } failure:^(NSURLSessionDataTask *operation, NSError *error)
         {
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
         }];
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (IBAction)saveBtnRespone:(UIButton *)sender
{
    [self hideKeyBoardOne];
    if ([self checkCanSave])
    {
        BOOL bToNow_ = NO;
        
        if ([endTimeTextField.text isEqualToString:@"至今"]) {
            bToNow_ = YES;
        }
        
        NSString *startDate_ = startTime.length > 0 ? startTime:@"";
        NSString *endDate_ = endTime.length > 0 ? endTime:@"";
        NSString *institution = institutionTextField.text;
        NSString *course = courseTextField.text;
        NSString *des_ = @"";
        
        if (contentTextView.text.length > 0)
        {
            des_ = contentTextView.text;
        }
        
        if (_addOrEditor == 1)
        {
            NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
            
            [searchDic setObject:startDate_ forKey:@"train_startdate"];
            if ([endTimeTextField.text isEqualToString:@"至今"]) {
                [searchDic setObject:@"" forKey:@"train_enddate"];
            }else{
                [searchDic setObject:endDate_ forKey:@"train_enddate"];
            }
            
            [searchDic setObject:institution forKey:@"train_institution"];
            [searchDic setObject:course forKey:@"train_cource"];
            [searchDic setObject:des_ forKey:@"train_desc"];
            
            if (bToNow_) {
                [searchDic setObject:@"1" forKey:@"train_istonow"];
            }
            else
            {
                [searchDic setObject:@"0" forKey:@"train_istonow"];
            }
            
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *searchStr = [jsonWriter stringWithObject:searchDic];
            
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&trainArr=%@",[Manager getUserInfo].userId_,searchStr];
            [BaseUIViewController showLoadView:YES content:@"正在添加" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"addTrain" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
            {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                if (![result isKindOfClass:[NSDictionary class]]) {
                    return ;
                }
                NSDictionary *dicOne = (NSDictionary *)result;
                NSString *status = dicOne[@"status"];
                NSDictionary *dic = dicOne[@"itemInfo"];
                if ([status isEqualToString:@"OK"])
                {
                    ProjectResume_DataModal *dataModal = [[ProjectResume_DataModal alloc] init];
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        dataModal.id_ = dic[@"train_id"];
                        dataModal.gainDes_ = dic[@"train_institution"];
                        dataModal.name_ = dic[@"train_cource"];
                        dataModal.startDate_ = dic[@"train_startdate"];
                        dataModal.endDate_ = dic[@"train_enddate"];
                        dataModal.des_ = dic[@"train_desc"];
                        dataModal.bToNow_ = dic[@"train_istonow"];
                    }
                    
                    _dataModal_ = dataModal;
                    if (self.addOrEditorBlock) {
                        self.addOrEditorBlock(_dataModal_,@"add");
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"添加成功" seconds:1.0];
                }
                else
                {
                    [BaseUIViewController showAutoDismissAlertView:@"" msg:@"添加失败" seconds:1.0];
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error)
            {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
            }];
        }
        else
        {
            NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
            
            [searchDic setObject:startDate_ forKey:@"train_startdate"];
            if ([endTimeTextField.text isEqualToString:@"至今"]) {
                 [searchDic setObject:@"" forKey:@"train_enddate"];
            }else{
                [searchDic setObject:endDate_ forKey:@"train_enddate"];
            }
            
            [searchDic setObject:institution forKey:@"train_institution"];
            [searchDic setObject:course forKey:@"train_cource"];
            [searchDic setObject:des_ forKey:@"train_desc"];
            [searchDic setObject:_dataModal_.id_.length > 0 ? _dataModal_.id_:@"" forKey:@"train_id"];
            
            if (bToNow_) {
                [searchDic setObject:@"1" forKey:@"train_istonow"];
            }
            else
            {
                [searchDic setObject:@"0" forKey:@"train_istonow"];
            }
            
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *searchStr = [jsonWriter stringWithObject:searchDic];
            
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&updateArr=%@",[Manager getUserInfo].userId_,searchStr];
            [BaseUIViewController showLoadView:YES content:@"正在保存" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"updateTrain" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 NSDictionary *dicOne = result;
                 NSString *status = dicOne[@"status"];
                 NSDictionary *dic = dicOne[@"itemInfo"];
                 if ([status isEqualToString:@"OK"])
                 {
                     ProjectResume_DataModal *dataModal = [[ProjectResume_DataModal alloc] init];
                     dataModal.id_ = dic[@"train_id"];
                     dataModal.gainDes_ = dic[@"train_institution"];
                     dataModal.name_ = dic[@"train_cource"];
                     dataModal.startDate_ = dic[@"train_startdate"];
                     dataModal.endDate_ = dic[@"train_enddate"];
                     dataModal.des_ = dic[@"train_desc"];
                     dataModal.bToNow_ = dic[@"train_istonow"];
                     dataModal.cellIndex = _dataModal_.cellIndex;
                     _dataModal_ = dataModal;
                     if (self.addOrEditorBlock) {
                         self.addOrEditorBlock(_dataModal_,@"update");
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存成功" seconds:1.0];
                 }
                 else
                 {
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存失败" seconds:1.0];
                 }
                 
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
            }];
        }
    }
}


//检查是否能保存
-(BOOL) checkCanSave
{
    if(institutionTextField.text.length == 0)
    {
        return [self alertShow:@"培训机构不能为空"];
    }
    
    if(courseTextField.text.length == 0)
    {
        return [self alertShow:@"培训课程不能为空"];
    }
    
    if(startTimeTextField.text.length == 0)
        
    {
        return [self alertShow:@"请选择开始时间"];
    }
    
    if(endTimeTextField.text.length == 0)
        
    {
        return [self alertShow:@"请选择结束时间"];
    }

    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == startTimeTextField)
    {
        [self hideKeyBoardOne];
        if (!changeDateCtl)
        {
            changeDateCtl = [[ELChangeDateCtl alloc] init];
        }
        changeDateCtl.showTodayBtn = NO;
        [changeDateCtl showViewCtlCurrentDate:startDateOne WithBolck:^(CondictionList_DataModal *dataModal)
         {
             
             if ([dataModal.changeDate timeIntervalSinceDate:endDateOne] > 0 && ![endTimeTextField.text isEqualToString:@"至今"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"在职起始时间大于结束时间"    delegate:nil
                                                       cancelButtonTitle:@"关闭"
                                                       otherButtonTitles:nil];
                 [alert show];
                 return ;
             }
             startTime = dataModal.oldString;
             startTimeTextField.text = [dataModal.oldString substringWithRange:NSMakeRange(0, 7)];
              startDateOne = dataModal.changeDate;
        }];
        
        return NO;
    }
    else if (textField == endTimeTextField)
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
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"在职起始时间大于结束时间"    delegate:nil
                                                           cancelButtonTitle:@"关闭"
                                                           otherButtonTitles:nil];
                     [alert show];
                     return ;
                 }
                 endTime = dataModal.oldString;
                 endTimeTextField.text = [dataModal.oldString substringWithRange:NSMakeRange(0, 7)];
                 endDateOne = dataModal.changeDate;
             }
             else
             {
                 endTime = dataModal.pId_;
                 endTimeTextField.text = endTime;
             }
         }];
        return NO;
    }
    return YES;
}

-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
            //获取开始时间
        case GetYearMonthDateType:
        {
            startTime = dataModal.oldString;
            startTimeTextField.text = [NSString stringWithFormat:@"%@.%@.%@",[startTime substringWithRange:NSMakeRange(0,4)],[startTime substringWithRange:NSMakeRange(5,2)],[startTime substringWithRange:NSMakeRange(8,2)]];
        }
            break;
            //获取结束时间
        case GetYearMonthDateHaveToNowType:
        {
            endTime = dataModal.oldString;
            endTimeTextField.text = [NSString stringWithFormat:@"%@.%@.%@",[endTime substringWithRange:NSMakeRange(0,4)],[endTime substringWithRange:NSMakeRange(5,2)],[endTime substringWithRange:NSMakeRange(8,2)]];
        }
            break;
        default:
            break;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    contentLable.hidden = YES;
    
    UIView *view = textView.superview;
    CGRect rect1 = [view convertRect:textView.frame toView:self.view];
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        backScrollView.contentOffset = CGPointMake(0,height + backScrollView.contentOffset.y);
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        contentLable.hidden = YES;
    }
    else
    {
        contentLable.hidden = NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger i = 2000;
    if ((textView.text.length + text.length) >= i)
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
        textView.text = [str substringWithRange:NSMakeRange(0,i)];
        countLable.text = @"0";
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == contentTextView)
    {
        if (textView.text.length >= 2000 || textView.text.length == 0)
        {
            countLable.text = @"2000";
        }
        else
        {
            countLable.text = [NSString stringWithFormat:@"%ld",(long)(2000-textView.text.length)];
        }
        if (textView.text.length > 0)
        {
            contentLable.hidden = YES;
        }
        else
        {
            contentLable.hidden = NO;
        }
    }
}

-(BOOL)alertShow:(NSString *)showMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:showMessage delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil];
    [alert show];
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
