//
//  ProjectViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/17.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ProjectViewController.h"
#import "ELChangeDateCtl.h"
#import "CondictionList_DataModal.h"
#import "Person_projectDataModel.h"
#import "UIScrollView+touch.h"

@interface ProjectViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate>{
    ELChangeDateCtl *dataVC;
    NSDate *startDateOne;
    NSString *startTime;
    NSDate *endDateOne;
    NSString *endTime;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UITextField *starTimeTxt;
@property (weak, nonatomic) IBOutlet UITextField *finishTimeTxt;
@property (weak, nonatomic) IBOutlet UITextField *describTxt;
@property (weak, nonatomic) IBOutlet UITextView *descrTxtView;
@property (weak, nonatomic) IBOutlet UILabel *descrNumLb;
@property (weak, nonatomic) IBOutlet UILabel *descrPlaceLb;
@property (weak, nonatomic) IBOutlet UIView *descrbView;

@property (weak, nonatomic) IBOutlet UIView *gainView;
@property (weak, nonatomic) IBOutlet UITextView *gainTxtView;
@property (weak, nonatomic) IBOutlet UILabel *gainNumLb;
@property (weak, nonatomic) IBOutlet UILabel *gainPlaceLb;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}


-(void)viewDidAppear:(BOOL)animated{
    _bgScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 1.5);
}
#pragma mark--配置界面
-(void)configUI{
    _saveBtn.layer.cornerRadius = 3;
    _saveBtn.layer.masksToBounds = YES;
    if ([_proType isEqualToString:@"1"]) {
//        self.navigationItem.title = @"添加项目经验";
        [self setNavTitle:@"添加项目经验"];
    }
    else if([_proType isEqualToString:@"2"]){
//        self.navigationItem.title = @"编辑项目经验";
        [self setNavTitle:@"编辑项目经验"];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.frame = CGRectMake(0, 0, 30, 30);
        deleteBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-light" size:14];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    }
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    if (_proVO) {
        _starTimeTxt.text = [_proVO.person_projectstartdate substringWithRange:NSMakeRange(0, 7)];
        startTime = _proVO.person_projectstartdate;
        
        NSString *start = [NSString stringWithFormat:@"%@ 00:00:00",_proVO.person_projectstartdate];
        startDateOne = [start dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
        //add 2016.5.27
        if ([_proVO.person_projectistonow isEqualToString:@"1"]) {
            _finishTimeTxt.text = @"至今";
            endTime = @"至今";
            endDateOne = [NSDate date];
        }else if([_proVO.person_projectstopdate isKindOfClass:[NSString class]] && _proVO.person_projectstopdate.length > 0){
            if (_proVO.person_projectstopdate.length >= 7) {
                _finishTimeTxt.text = [_proVO.person_projectstopdate substringWithRange:NSMakeRange(0, 7)];
            }else{
                _finishTimeTxt.text = _proVO.person_projectstopdate;
            }
            endTime = _proVO.person_projectstopdate;
            NSString *end = [NSString stringWithFormat:@"%@ 00:00:00",_proVO.person_projectstopdate];
            endDateOne = [end dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
        }
        _describTxt.text = _proVO.person_projectName;
        _descrTxtView.text = _proVO.person_projectDesc;
        _gainTxtView.text = _proVO.person_projectGain;
        NSInteger desNum = 500 - _descrTxtView.text.length;
        NSInteger gainNum = 500 - _gainTxtView.text.length;
        _descrNumLb.text = [NSString stringWithFormat:@"%ld",(long)(desNum > 0 ?desNum:0)];
        _gainNumLb.text = [NSString stringWithFormat:@"%ld",(long)(gainNum > 0 ?gainNum:0)];
        if (_gainTxtView.text.length > 0){
            _gainPlaceLb.hidden = YES;
        }
        if (_descrPlaceLb.text.length > 0){
            _descrPlaceLb.hidden = YES;
        }
    }
    
    _bgScrollView.bounces = NO;
}
#pragma mark--加载数据
-(void)beginLoad:(id)param exParam:(id)exParam{
    [super beginLoad:param exParam:exParam];
}

#pragma mark--代理
#pragma mark-textFielDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_starTimeTxt]) {
        [self hideKeyBoard];
        if (!dataVC)
        {
            dataVC = [[ELChangeDateCtl alloc] init];
        }
        dataVC.showTodayBtn = NO;
        [dataVC showViewCtlCurrentDate:startDateOne WithBolck:^(CondictionList_DataModal *dataModal)
         {
             
             if ([dataModal.changeDate timeIntervalSinceDate:endDateOne] > 0 && ![_finishTimeTxt.text isEqualToString:@"至今"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"在职起始时间大于结束时间"    delegate:nil
                                                       cancelButtonTitle:@"关闭"
                                                       otherButtonTitles:nil];
                 [alert show];
                 return ;
             }
             startTime = dataModal.oldString;
             _starTimeTxt.text = [dataModal.oldString substringWithRange:NSMakeRange(0, 7)];
             startDateOne = dataModal.changeDate;
         }];
        
        return NO;
    }
    else if([textField isEqual:_finishTimeTxt]){
        [self hideKeyBoard];
        if (!dataVC)
        {
            dataVC = [[ELChangeDateCtl alloc] init];
        }
        dataVC.showTodayBtn = YES;
        [dataVC showViewCtlCurrentDate:endDateOne WithBolck:^(CondictionList_DataModal *dataModal)
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
                 _finishTimeTxt.text = [dataModal.oldString substringWithRange:NSMakeRange(0, 7)];
                 endDateOne = dataModal.changeDate;
             }
             else
             {
                 endTime = dataModal.pId_;
                 _finishTimeTxt.text = endTime;
             }
         }];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:_describTxt]){
        [_describTxt resignFirstResponder];    }
    return YES;
}

#pragma mark-textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _descrTxtView)
    {
        [MyCommon dealLabNumWithTipLb:_descrPlaceLb numLb:_descrNumLb textView:_descrTxtView wordsNum:500];
    }
    else if(textView == _gainTxtView){
        [MyCommon dealLabNumWithTipLb:_gainPlaceLb numLb:_gainNumLb textView:_gainTxtView wordsNum:500];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView isEqual:_gainTxtView]) {
        _gainPlaceLb.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    if([textView isEqual:_descrTxtView]){
        _descrPlaceLb.hidden = YES;
        [self hideKeyBoard];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView isEqual:_gainTxtView]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    if (_gainTxtView.text.length == 0) {
        _gainPlaceLb.hidden = NO;
    }
    if (_descrTxtView.text.length == 0) {
        _descrPlaceLb.hidden = NO;
    }
    return YES;
}
 
#pragma mark-alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//删除
        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
        [searchDic setObject:_proVO.person_projectId forKey:@"person_projectId"];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *searchStr = [jsonWriter stringWithObject:searchDic];
        NSString * bodyMsg = [NSString stringWithFormat:@"delArr=%@",searchStr];
        
        [BaseUIViewController showLoadView:YES content:@"正在删除" view:nil];
        [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"deletePersonProjectDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
         {
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             NSDictionary *dicOne = result;
             NSString *status = dicOne[@"status"];
             if ([status isEqualToString:@"OK"])
             {
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除成功" seconds:1.0];
                 if (self.addOrEditorBlock) {
                     self.addOrEditorBlock(@"delete");
                 }
                 [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark-scrollview代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark--通知
-(void)keyboardWillShow:(NSNotification *)notif{
    self.bgScrollView.contentOffset = CGPointMake(0,300);
}

-(void)keyboardWillHide:(NSNotification *)notif{
    self.bgScrollView.contentOffset = CGPointMake(0, 0);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark--事件
//保存
- (IBAction)saveBtnClick:(id)sender {
    [self.view endEditing:YES];
    if([self checkCanSave]){
        if([_proType isEqualToString:@"1"]){
            [self addPro];
        }
        else if([_proType isEqualToString:@"2"]){
            [self editPro];
        }
    }
}
//删除
-(IBAction)rightBtnClick:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该培训经历?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
    alert.tag = 1001;
    [alert show];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



#pragma mark--业务逻辑
//隐藏键盘
-(void)hideKeyBoard{
    [self.view endEditing:YES];
}

//添加
-(void)addPro{
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    
    [searchDic setObject:startTime forKey:@"person_projectstartdate"];
    if ([_finishTimeTxt.text isEqualToString:@"至今"]) {
         [searchDic setObject:@"" forKey:@"person_projectstopdate"];
    }else{
         [searchDic setObject:endTime forKey:@"person_projectstopdate"];
    }
   
    [searchDic setObject:_describTxt.text forKey:@"person_projectName"];
    [searchDic setObject:_descrTxtView.text forKey:@"person_projectDesc"];
    [searchDic setObject:_gainTxtView.text forKey:@"person_projectGain"];
    
    if ([_isYjs isEqualToString:@"0"]) {
        [searchDic setObject:@"1" forKey:@"isyjs"];
    }
    else if([_isYjs isEqualToString:@"1"]) {
        [searchDic setObject:@"0" forKey:@"isyjs"];
    }
    if ([endTime isEqualToString:@"至今"]) {
        [searchDic setObject:@"1" forKey:@"person_projectistonow"];
    }
    else
    {
        [searchDic setObject:@"0" forKey:@"person_projectistonow"];
    }
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&insertArr=%@",[Manager getUserInfo].userId_,searchStr];
    [BaseUIViewController showLoadView:YES content:@"正在添加" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"addPersonProject" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *dicOne = result;
         NSString *status = dicOne[@"status"];
         if ([status isEqualToString:@"OK"])
         {
             [BaseUIViewController showAutoDismissAlertView:@"" msg:@"添加成功" seconds:1.0];
             if (self.addOrEditorBlock) {
                 self.addOrEditorBlock(@"add");
             }
             [self.navigationController popViewControllerAnimated:YES];
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
//编辑
-(void)editPro{
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    
    [searchDic setObject:startTime forKey:@"person_projectstartdate"];
    if ([_finishTimeTxt.text isEqualToString:@"至今"]) {
        [searchDic setObject:@"" forKey:@"person_projectstopdate"];
    }else{
         [searchDic setObject:endTime forKey:@"person_projectstopdate"];
    }
    [searchDic setObject:_describTxt.text forKey:@"person_projectName"];
    [searchDic setObject:_descrTxtView.text forKey:@"person_projectDesc"];
    [searchDic setObject:_gainTxtView.text forKey:@"person_projectGain"];
    [searchDic setObject:_proVO.person_projectId forKey:@"person_projectId"];
    if ([endTime isEqualToString:@"至今"]) {
        [searchDic setObject:@"1" forKey:@"person_projectistonow"];
    }
    else
    {
        [searchDic setObject:@"0" forKey:@"person_projectistonow"];
    }
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&updateArr=%@",[Manager getUserInfo].userId_,searchStr];
    [BaseUIViewController showLoadView:YES content:@"更新..." view:nil];
    [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"updatePersonProject" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *dicOne = result;
         NSString *status = dicOne[@"status"];
         if ([status isEqualToString:@"OK"])
         {
             [BaseUIViewController showAutoDismissAlertView:@"" msg:@"更新成功" seconds:1.0];
             if (self.addOrEditorBlock) {
                 self.addOrEditorBlock(@"add");
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [BaseUIViewController showAutoDismissAlertView:@"" msg:@"更新失败" seconds:1.0];
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
     }];

}
//检查能否保存
-(BOOL)checkCanSave
{
    if(_starTimeTxt.text.length == 0)
    {
        return [self showAlert:@"开始时间不能为空"];
    }
    
    if(_finishTimeTxt.text.length == 0)
    {
        return [self showAlert:@"结束时间不能为空"];
    }
    if (_describTxt.text.length <= 0) {
        return [self showAlert:@"项目名称不能为空"];
    }
    if (_descrTxtView.text.length <= 0) {
        return [self showAlert:@"项目描述不能为空"];
    }
    return YES;
}

-(BOOL)showAlert:(NSString *)alertTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertTitle    delegate:nil
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
