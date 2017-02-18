//
//  EduBackGroudDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "EduBackGroudDetailCtl.h"
#import "PreCondictionListCtl.h"
#import "ELChangeDateCtl.h"
#import "EduResume_DataModal.h"
#import "Person_eduDataModel.h"

@interface EduBackGroudDetailCtl () <UITextViewDelegate,UITextFieldDelegate,CondictionChooseDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    __weak IBOutlet UITextField *schoolTextField;
    
    __weak IBOutlet UITextField *majorTextField;
    
    __weak IBOutlet UITextField *educationTextField;
    
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
    
    NSString                        *school_;
    NSString                        *startDate_;
    NSString                        *endDate_;
    NSString                        *edu_;
    NSString                        *zye_;
    NSString                        *zym_;
    NSString                        *des_;
    
    PreRequestCon                          *PreRequestCon_Update_;
    
    ELChangeDateCtl *changeDateCtl;
    NSDate *startDateOne;
    NSDate *endDateOne;
}
@end

@implementation EduBackGroudDetailCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    saveBtn.clipsToBounds = YES;
    saveBtn.layer.cornerRadius = 4.0;
    
    if (self.addOrEditor == 1)
    {
//        self.navigationItem.title = @"添加教育经历";
        [self setNavTitle:@"添加教育经历"];
        rightBarBtn_.hidden = YES;
    }
    else if (self.addOrEditor == 2)
    {
//        self.navigationItem.title = @"编辑教育经历";
        [self setNavTitle:@"编辑教育经历"];
        rightBarBtn_.hidden = NO;
        
        [self loadData];
        
        educationTextField.text = [PreCondictionListCtl getEduStr:_dataModal_.eduId_];
        schoolTextField.text = _dataModal_.school_;
        majorTextField.text = _dataModal_.zym_;
        
        if(_dataModal_.startDate_ && ![_dataModal_.startDate_ isEqualToString:@""] )
        {
            if(_dataModal_.startDate_.length >= 7)
            {
                startTimeTextField.text = [[NSString alloc] initWithFormat:@"%@",[_dataModal_.startDate_ substringWithRange:NSMakeRange(0,7)]];
                NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",_dataModal_.startDate_];
                
                startDateOne = [startTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
                
                startDate_ = _dataModal_.startDate_;
            }
        }
        if( _dataModal_.endDate_ && ![_dataModal_.endDate_ isEqualToString:@""] )
        {
            if(_dataModal_.endDate_.length >= 7)
            {
                endTimeTextField.text = [[NSString alloc] initWithFormat:@"%@",[_dataModal_.endDate_ substringWithRange:NSMakeRange(0,7)]];
                NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",_dataModal_.endDate_];
    
                endDateOne = [startTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
                
                endDate_ = _dataModal_.endDate_;
            }
        }
        //判断是否到至今
        if( _dataModal_.bToNow_ && [_dataModal_.bToNow_ isEqualToString:@"1"] )
        {
            endTimeTextField.text = @"至今";
            endDateOne = [NSDate date];
        }
        contentTextView.text = _dataModal_.des_;
        [self textViewDidChange:contentTextView];
    }
    
    backScrollView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    backScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    backScrollView.delegate = self;
    
    schoolTextField.delegate = self;
    majorTextField.delegate = self;
    educationTextField.delegate = self;
    startTimeTextField.delegate = self;
    endTimeTextField.delegate = self;
    contentTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    backScrollView.userInteractionEnabled = YES;
    [backScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
}

-(void)loadData{
    _dataModal_ = [EduResume_DataModal new];
    _dataModal_.id_ = _eduVO.edusId;
    _dataModal_.des_ = _eduVO.edus;
    _dataModal_.bToNow_ = _eduVO.istonow;
    _dataModal_.endDate_ = _eduVO.stopdate;
    _dataModal_.startDate_ = _eduVO.startdate;
    _dataModal_.school_ = _eduVO.school;
    _dataModal_.zye_ = _eduVO.zye;
    _dataModal_.zym_ = _eduVO.zym;
    _dataModal_.personId_ = _eduVO.personId;
    _dataModal_.eduId_ = _eduVO.eduId;
}

-(void)viewDidAppear:(BOOL)animated{
    backScrollView.contentSize = CGSizeMake(ScreenWidth, saveBtn.frame.origin.y + saveBtn.frame.size.height + 20);
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        rightBarItemStr_ = @"删除";
    }
    return self;
}

-(void)hideKeyBoardOne
{
    [schoolTextField resignFirstResponder];
    [majorTextField resignFirstResponder];
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
    [self hideKeyBoardOne];
    if (_allCount <= 1)
    {
        [PreBaseUIViewController showAlertView:nil msg:@"最后一个教育背景,不能被删除！" btnTitle:@"关闭"];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该教育背景?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
        alert.tag = 1001;
        [alert show];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
        [searchDic setObject:_dataModal_.id_ forKey:@"edusId"];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *searchStr = [jsonWriter stringWithObject:searchDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"array=%@",searchStr];
        [BaseUIViewController showLoadView:YES content:@"正在删除" view:self.view];
        [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"deletePersonEduDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
        {
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             NSDictionary *dic = result;
             NSString *status = dic[@"status"];
             if ([status isEqualToString:@"OK"])
             {
                 if (self.addOrEditorBlock)
                 {
                     self.addOrEditorBlock(@"delete");
                 }
                 [self.navigationController popViewControllerAnimated:YES];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除成功" seconds:1.0];
             }
             else
             {
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除失败" seconds:1.0];
             }
             
         }failure:^(NSURLSessionDataTask *operation, NSError *error){
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtnRespone:(UIButton *)sender
{
    [self hideKeyBoardOne];
    if ([self checkCanSave])
    {
        BOOL bToNow_ = NO;
        //        if (startTimeTextField.text.length >= 7)
        //        {
        //            NSString *date = [[NSString alloc] initWithFormat:@"%@-%@-01 00:00:00",[startTimeTextField.text substringWithRange:NSMakeRange(0,4)],[startTimeTextField.text substringWithRange:NSMakeRange(5,2)]];
        //            startDate_ = date;
        //        }
        
        if ([endTimeTextField.text isEqualToString:@"至今"]) {
            endDate_ = @"";
            bToNow_ = YES;
        }else{
            bToNow_ = NO;
        }
        //        else if (endTimeTextField.text.length >= 7)
        //        {
        //            NSString *date = [[NSString alloc] initWithFormat:@"%@-%@-01 00:00:00",[endTimeTextField.text substringWithRange:NSMakeRange(0,4)],[endTimeTextField.text substringWithRange:NSMakeRange(5,2)]];
        //            endDate_ = date;
        //        }
        school_ = schoolTextField.text;
        edu_ = educationTextField.text;
        zym_ = majorTextField.text;
        des_ = contentTextView.text;
        
        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        
        [searchDic setObject:startDate_ forKey:@"startdate"];
        [searchDic setObject:endDate_ forKey:@"stopdate"];
        [searchDic setObject:des_ forKey:@"edus"];
        [searchDic setObject:school_ forKey:@"school"];
        [searchDic setObject:[PreCondictionListCtl getEduId:edu_] forKey:@"eduId"];
        [searchDic setObject:@"" forKey:@"zye"];
        [searchDic setObject:zym_ forKey:@"zym"];
        
        if (bToNow_)
        {
            [searchDic setObject:@"1" forKey:@"istonow"];
        }
        else
        {
            [searchDic setObject:@"0" forKey:@"istonow"];
        }
        
        if (_addOrEditor == 1)
        {
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *searchStr = [jsonWriter stringWithObject:searchDic];
            
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&edusArr=%@",[Manager getUserInfo].userId_,searchStr];
            
            [BaseUIViewController showLoadView:YES content:@"正在添加" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"addEdus" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 
                 if ([result[@"code"] isEqualToString:@"200"])
                 {
                     if (!_dataModal_)
                     {
                         _dataModal_ = [[EduResume_DataModal alloc] init];
                     }
                     _dataModal_.school_ = school_;
                     if (startDate_.length >= 7)
                     {
                         _dataModal_.startDate_ = [startDate_ substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.startDate_ = startDate_;
                     }
                     if (endDate_.length >= 7)
                     {
                         _dataModal_.endDate_ = [endDate_ substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.endDate_ = endDate_;
                     }
                     _dataModal_.eduName_ = edu_;
                     _dataModal_.eduId_ = [PreCondictionListCtl getEduId:edu_];
                     _dataModal_.zye_ = zye_;
                     _dataModal_.zym_ = zym_;
                     _dataModal_.des_ = des_;
                     _dataModal_.bToNow_ = [NSString stringWithFormat:@"%d",bToNow_];
                     _dataModal_.id_ = ((NSDictionary *)result[@"itemInfo"])[@"edusId"];
                     if (self.addOrEditorBlock) {
                         self.addOrEditorBlock(@"add");
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"添加成功" seconds:1.0];

                 }
                 
             } failure:^(NSURLSessionDataTask *operation, NSError *error)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
                 NSLog(@"------------------------%@",error);
             }];
            
            
        }
        else
        {
            [searchDic setObject:_dataModal_.id_ forKey:@"edusId"];
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *searchStr = [jsonWriter stringWithObject:searchDic];
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&updateArr=%@",[Manager getUserInfo].userId_,searchStr];
            [BaseUIViewController showLoadView:YES content:@"正在修改" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"updateEdus" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                [BaseUIViewController showLoadView:NO content:nil view:nil];
                 NSString *str = result[@"status"];
                 if ([str isEqualToString:@"OK"])
                 {
                     if (!_dataModal_)
                     {
                         _dataModal_ = [[EduResume_DataModal alloc] init];
                     }
                     _dataModal_.school_ = school_;
                     if (startDate_.length >= 7)
                     {
                         _dataModal_.startDate_ = [startDate_ substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.startDate_ = startDate_;
                     }
                     if (endDate_.length >= 7)
                     {
                         _dataModal_.endDate_ = [endDate_ substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.endDate_ = endDate_;
                     }
                     _dataModal_.eduName_ = edu_;
                     _dataModal_.eduId_ = [PreCondictionListCtl getEduId:edu_];
                     _dataModal_.zye_ = zye_;
                     _dataModal_.zym_ = zym_;
                     _dataModal_.des_ = des_;
                     _dataModal_.bToNow_ = [NSString stringWithFormat:@"%d",bToNow_];
                     if (self.addOrEditorBlock) {
                         self.addOrEditorBlock(@"update");
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存成功" seconds:1.0];
                 }else{
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存失败" seconds:1.0];
                 }
             }
             failure:^(NSURLSessionDataTask *operation, NSError *error)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
             }];
        }
    }
}

//检查是否能保存
-(BOOL) checkCanSave
{
    if( [PreCommon checkStringIsNull:[schoolTextField.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"毕业院校不能为空"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        //恢复输入
        schoolTextField.text = @"";
        [schoolTextField becomeFirstResponder];
        
        return NO;
    }
    if( [PreCommon checkStringIsNull:[majorTextField.text UTF8String]] )
    {
        [PreBaseUIViewController showAlertView:nil msg:@"专业名称不能为空" btnTitle:@"关闭"];
        
        //恢复输入
        majorTextField.text = @"";
        [majorTextField becomeFirstResponder];
        
        return NO;
    }
    if( !educationTextField.text || [educationTextField.text isEqualToString:@""])
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择学历"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    if( !startTimeTextField.text || [startTimeTextField.text isEqualToString:@""])
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择开始时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    if( !endTimeTextField.text || [endTimeTextField.text isEqualToString:@""])
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == educationTextField)
    {
        [self hideKeyBoardOne];
        PreCondictionListCtl *condictionListCtl = [[PreCondictionListCtl alloc]init];
        [condictionListCtl beginGetData:nil exParam:nil type:GetEduType];
        condictionListCtl.delegate_ = self;
        [self.navigationController pushViewController:condictionListCtl animated:YES];
        return NO;
    }
    else if (textField == startTimeTextField)
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
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"就读起始时间大于毕业时间"    delegate:nil
                                                       cancelButtonTitle:@"关闭"
                                                       otherButtonTitles:nil];
                 [alert show];
                 return ;
             }
             startTimeTextField.text = dataModal.pId_;
             startDateOne = dataModal.changeDate;
             startDate_ = [NSString stringWithFormat:@"%@",dataModal.oldString];
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
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"就读起始时间大于毕业时间"    delegate:nil
                                                           cancelButtonTitle:@"关闭"
                                                           otherButtonTitles:nil];
                     [alert show];
                     return ;
                 }
                 endDateOne = dataModal.changeDate;
                 endTimeTextField.text = dataModal.pId_;
                 endDate_ = [NSString stringWithFormat:@"%@",dataModal.oldString];
             }
             else
             {
                 endTimeTextField.text = dataModal.pId_;
                 //                 endDate_ = @"";
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
            startTimeTextField.text = dataModal.pId_;
        }
            break;
            //获取结束时间
        case GetYearMonthDateHaveToNowType:
        {
            endTimeTextField.text = dataModal.pId_;
        }
            break;
            //获取学历
        case GetEduType:
        {
            educationTextField.text = dataModal.str_;
        }
            break;
        default:
            break;
    }
}

#pragma mark - TextViewDelegate
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

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == contentTextView)
    {
        [MyCommon dealLabNumWithTipLb:contentLable numLb:countLable textView:contentTextView wordsNum:2000];
    }
}

@end
