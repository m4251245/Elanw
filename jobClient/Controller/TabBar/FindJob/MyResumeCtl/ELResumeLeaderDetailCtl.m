//
//  ELResumeLeaderDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELResumeLeaderDetailCtl.h"
#import "PreCondictionListCtl.h"
#import "ELChangeDateCtl.h"

@interface ELResumeLeaderDetailCtl () <UITextViewDelegate,UITextFieldDelegate,CondictionChooseDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UITextField *nameTextFiled;
    
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
    PreRequestCon                          *PreRequestCon_Update_;
    
    ELChangeDateCtl *changeDateCtl;
    NSDate *startDateOne;
    NSDate *endDateOne;
}
@end

@implementation ELResumeLeaderDetailCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    saveBtn.clipsToBounds = YES;
    saveBtn.layer.cornerRadius = 4.0;
    
    if (self.addOrEditor == 1)
    {
//        self.navigationItem.title = @"添加干部经历";
        [self setNavTitle:@"添加干部经历"];
        rightBarBtn_.hidden = YES;
    }
    else if (self.addOrEditor == 2)
    {
//        self.navigationItem.title = @"编辑干部经历";
        [self setNavTitle:@"编辑干部经历"];
        rightBarBtn_.hidden = NO;
        
        nameTextFiled.text = _dataModal_.name_;
        
        if(_dataModal_.startDate_ && ![_dataModal_.startDate_ isEqualToString:@""] )
        {
            if(_dataModal_.startDate_.length >= 7)
            {
                startTimeTextField.text = [[NSString alloc] initWithFormat:@"%@-%@",[_dataModal_.startDate_ substringWithRange:NSMakeRange(0,4)],[_dataModal_.startDate_ substringWithRange:NSMakeRange(5,2)]];
                NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",_dataModal_.startDate_];
                startDateOne = [startTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
            }
        }
        if( _dataModal_.endDate_ && ![_dataModal_.endDate_ isEqualToString:@""] )
        {
            if(_dataModal_.endDate_.length >= 7)
            {
                endTimeTextField.text = [[NSString alloc] initWithFormat:@"%@-%@",[_dataModal_.endDate_ substringWithRange:NSMakeRange(0,4)],[_dataModal_.endDate_ substringWithRange:NSMakeRange(5,2)]];
                NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",_dataModal_.endDate_];

                endDateOne = [startTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
            }
        }
        //判断是否到至今
        if( _dataModal_.bToNow_ && [_dataModal_.bToNow_ isEqualToString:@"1"] )
        {
            endTimeTextField.text = @"至今";
        }
        contentTextView.text = _dataModal_.des_;
        [self textViewDidChange:contentTextView];
    }
    
    backScrollView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    backScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    backScrollView.delegate = self;
    
    nameTextFiled.delegate = self;
    startTimeTextField.delegate = self;
    endTimeTextField.delegate = self;
    contentTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    backScrollView.userInteractionEnabled = YES;
    [backScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
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
    [nameTextFiled resignFirstResponder];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该干部经历?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
    alert.tag = 1001;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
        [searchDic setObject:_dataModal_.id_ forKey:@"person_studengLeaderId"];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *searchStr = [jsonWriter stringWithObject:searchDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"array=%@",searchStr];
        [BaseUIViewController showLoadView:YES content:@"正在删除" view:nil];
        [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"deletePersonStudentLeaderDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
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

- (IBAction)saveBtnRespone:(UIButton *)sender
{
    [self hideKeyBoardOne];
    if ([self checkCanSave])
    {
        BOOL bToNow_ = NO;
        
        NSString *name = @"";
        NSString *startTime = @"";
        NSString *endTime = @"";
        NSString *des = @"";
        
        if (startTimeTextField.text.length >= 7)
        {
            NSString *date = [[NSString alloc] initWithFormat:@"%@-%@-01 00:00:00",[startTimeTextField.text substringWithRange:NSMakeRange(0,4)],[startTimeTextField.text substringWithRange:NSMakeRange(5,2)]];
            startTime = date;
        }
        
        if ([endTimeTextField.text isEqualToString:@"至今"]) {
            endTime = @"";
            bToNow_ = YES;
        }
        else if (endTimeTextField.text.length >= 7)
        {
            NSString *date = [[NSString alloc] initWithFormat:@"%@-%@-01 00:00:00",[endTimeTextField.text substringWithRange:NSMakeRange(0,4)],[endTimeTextField.text substringWithRange:NSMakeRange(5,2)]];
            endTime = date;
        }
        name = nameTextFiled.text;
        des = contentTextView.text;
        
        if (_addOrEditor == 1)
        {
            NSString * bodyMsg = [NSString stringWithFormat:@"leaderName=%@&des=%@&startDate=%@&endDate=%@&bToNow=%@&personId=%@",name,des,startTime,endTime,bToNow_?@"1":@"0",[Manager getUserInfo].userId_];
            [BaseUIViewController showLoadView:YES content:@"正在添加" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"addPersonStudentLeader" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 NSDictionary *dic = result;
                 NSString *status = dic[@"status"];
                 if ([status isEqualToString:@"OK"])
                 {
                     if (!_dataModal_)
                     {
                         _dataModal_ = [[LeaderResume_DataModal alloc] init];
                     }
                     if (startTime.length >= 7)
                     {
                         _dataModal_.startDate_ = [startTime substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.startDate_ = startTime;
                     }
                     if (endTime.length >= 7)
                     {
                         _dataModal_.endDate_ = [endTime substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.endDate_ = endTime;
                     }
                     _dataModal_.name_ = name;
                     _dataModal_.des_ = des;
                     _dataModal_.bToNow_ = [NSString stringWithFormat:@"%d",bToNow_];
                     _dataModal_.id_ = dic[@"insert_id"];
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
             }
             failure:^(NSURLSessionDataTask *operation, NSError *error)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
             }];
        }
        else
        {
            NSString * bodyMsg = [NSString stringWithFormat:@"leaderId=%@&leaderName=%@&des=%@&startDate=%@&endDate=%@&bToNow=%@&personId=%@",_dataModal_.id_,name,des,startTime,endTime,bToNow_?@"1":@"0",[Manager getUserInfo].userId_];
            [BaseUIViewController showLoadView:YES content:@"正在保存" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"updatePersonStudentLeader" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 NSDictionary *dic = result;
                 NSString *status = dic[@"status"];
                 if ([status isEqualToString:@"OK"])
                 {
                     if (!_dataModal_)
                     {
                         _dataModal_ = [[LeaderResume_DataModal alloc] init];
                     }
                     if (startTime.length >= 7)
                     {
                         _dataModal_.startDate_ = [startTime substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.startDate_ = startTime;
                     }
                     if (endTime.length >= 7)
                     {
                         _dataModal_.endDate_ = [endTime substringWithRange:NSMakeRange(0,7)];
                     }
                     else
                     {
                         _dataModal_.endDate_ = endTime;
                     }
                     _dataModal_.name_ = name;
                     _dataModal_.des_ = des;
                     _dataModal_.bToNow_ = [NSString stringWithFormat:@"%d",bToNow_];
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
             }
             failure:^(NSURLSessionDataTask *operation, NSError *error)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
             }];
        }
    }
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
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"任职起始时间大于结束时间"    delegate:nil
                                                       cancelButtonTitle:@"关闭"
                                                       otherButtonTitles:nil];
                 [alert show];
                 return ;
             }
             startTimeTextField.text = dataModal.pId_;
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
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"任职起始时间大于结束时间"    delegate:nil
                                                           cancelButtonTitle:@"关闭"
                                                           otherButtonTitles:nil];
                     [alert show];
                     return ;
                 }
                 endTimeTextField.text = dataModal.pId_;
                 endDateOne = dataModal.changeDate;
             }
             else
             {
                 endTimeTextField.text = dataModal.pId_;
             }
         }];
        return NO;
    }
    return YES;
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
    NSInteger i = 500;
    if ((textView.text.length + text.length) >= i)
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
        textView.text = [str substringWithRange:NSMakeRange(0,i)];
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == contentTextView)
    {
        if (textView.text.length >= 500 || textView.text.length == 0)
        {
            countLable.text = @"500字";
        }
        else
        {
            countLable.text = [NSString stringWithFormat:@"%ld字",(long)(500-textView.text.length)];
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

//检查是否能保存
-(BOOL) checkCanSave
{
    if(nameTextFiled.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"职务名称不能为空"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    if(startTimeTextField.text.length == 0)
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择开始时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    if(endTimeTextField.text.length == 0)
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    if(contentTextView.text.length < 10)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"职位描术长度不能少于10个字符"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}
-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case UpdateResume_StudentLeader_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    if (self.addOrEditorBlock) {
                        self.addOrEditorBlock(_dataModal_,@"update");
                    }
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"保存成功" seconds:2.0];
                    [self.navigationController popViewControllerAnimated:YES];
                }else
                {
                    [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请您稍候再试" btnTitle:@"关闭"];
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
        case AddResume_StudentLeader_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"保存成功" seconds:2.0];
                    _dataModal_.id_ = dataModal.id_;
                    if (self.addOrEditorBlock) {
                        self.addOrEditorBlock(_dataModal_,@"add");
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else
                {
                    [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请您稍候再试" btnTitle:@"关闭"];
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
        case DelResume_StudentLeader_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"删除成功" seconds:2.0];
                    if (self.addOrEditorBlock)
                    {
                        self.addOrEditorBlock(_dataModal_,@"delete");
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [PreBaseUIViewController showAlertView:@"删除失败" msg:@"请您稍候再试" btnTitle:@"关闭"];
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"删除失败" msg:@"请您稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
        default:
            break;
    }
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
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
