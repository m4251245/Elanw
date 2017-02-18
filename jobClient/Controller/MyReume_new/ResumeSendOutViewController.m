//
//  ResumeSendOutViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ResumeSendOutViewController.h"
#import "RecorderViewController.h"

//,UIPickerViewDelegate,UIPickerViewDataSource
@interface ResumeSendOutViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>{
    UIView *bgView;
    UIPickerView *picker;
    NSDictionary *typeDic;
    UIView *allBgView;
    UIView *alphaView;
    NSString *resumeTypeStr;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UITextField *mailTxt;
@property (weak, nonatomic) IBOutlet UITextField *positionTxt;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTxtView;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UIButton *sendResumBtn;
@property (weak, nonatomic) IBOutlet UIView *wranPickerView;

@end

@implementation ResumeSendOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self textViewDidChange:_contentTxtView];
}

-(void)viewDidAppear:(BOOL)animated{
    _bgScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 2);
}

#pragma mark-- 配置界面
-(void)configUI{
    _sendResumBtn.layer.cornerRadius = 3;
    _sendResumBtn.layer.masksToBounds = YES;
    [_sendResumBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xe13e3e)] forState:UIControlStateNormal];
    [_sendResumBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xbb3434)] forState:UIControlStateHighlighted];
    
    [_wranPickerView bringSubviewToFront:_placeLb];
    self.view.backgroundColor = UIColorFromRGB(0xecedec);
    [self setNavTitle:@"简历外发"];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [rightBarBtn setTitle:@"记录" forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    
    _bgScrollView.bounces = NO;
    
    _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

-(void)actionSheetShow{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSString *key in _dataArray) {
        NSString *title = typeDic[key];
        [sheet addButtonWithTitle:title];
    }
    [sheet showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"简历外发";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


#pragma mark-- 加载数据
-(void)beginLoad:(id)param exParam:(id)exParam {
    [super beginLoad:param exParam:exParam];
    [self loadData];
}

-(void)loadData{
    [self requestResumeType];
}

-(void)requestResumeType{
    [ELRequest postbodyMsg:[NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_] op:@"person_sub_busi" func:@"get_sendout_type" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        if([result isKindOfClass:[NSDictionary class]]){
            typeDic = result;
            _dataArray = [NSMutableArray arrayWithArray:[typeDic allKeys]];
//            [picker reloadAllComponents];
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark-- 事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
//    [self pickerHide];
}

//简历类型选择
- (IBAction)typeBtnSelect:(id)sender {
    [self.view endEditing:YES];
//    [self pickerShow];
    [self actionSheetShow];
}

//简历外发
- (IBAction)btnClicked:(id)sender {
    NSString *type = @"0";
    NSString *title = _typeBtn.titleLabel.text;
    for (NSString *key in _dataArray) {
        if ([title isEqualToString:typeDic[key]]) {
            type = key;
        }
    }
    NSString *myMes = @"这是我的简历，感谢查收";
    [self.view endEditing:YES];
    if([self checkSave]){
        NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&jobname=%@&companyemail=%@&resume_type=%@&mes=%@&mailtext=%@",[Manager getUserInfo].userId_,_positionTxt.text,_mailTxt.text,type,myMes,_contentTxtView.text];
        NSString * function = @"resumeSendOut";
        NSString * op = @"person_sub_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"正在发送" success:^(NSURLSessionDataTask *operation, id result) {
            NSString *statu = result[@"status"];
            NSString *desc = result[@"desc"];
            if ([statu isEqualToString:@"OK"]) {
                [PreBaseUIViewController showAutoLoadingView:@"发送成功" msg:nil seconds:1.0];
            }
            else{
                [PreBaseUIViewController showAutoLoadingView:desc msg:nil seconds:1.0];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

//记录
-(IBAction)rightBtnClick:(id)sender{
    RecorderViewController *recorderVC = [[RecorderViewController alloc]init];
    [self.navigationController pushViewController:recorderVC animated:YES];
}
#pragma mark-- 代理

#pragma mark--action代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0) {
        [_typeBtn setTitle:typeDic[_dataArray[buttonIndex - 1]] forState:UIControlStateNormal];
        [_typeBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
}

#pragma mark-scrollview代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark-text代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_mailTxt]) {
        [_mailTxt resignFirstResponder];
        [_positionTxt becomeFirstResponder];
    }
    else if([textField isEqual:_positionTxt]){
        [_positionTxt resignFirstResponder];
        [_contentTxtView becomeFirstResponder];
    }
    else if([textField isEqual:_contentTxtView]){
        [_contentTxtView resignFirstResponder];
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _contentTxtView)
    {
        if ( textView.text.length == 0)
        {
            _numLB.text = @"300";
            
        }else if (textView.text.length >= 300 ){
            _numLB.text = @"0";
            
        }else
        {
            _numLB.text = [NSString stringWithFormat:@"%ld",(long)(300 - textView.text.length)];
        }
        
        if (textView.text.length > 0)
        {
            _placeLb.hidden = YES;
        }
        else
        {
            _placeLb.hidden = NO;
        }
    }
}


#pragma mark-- 业务逻辑
//check是否可以发送
-(BOOL)checkSave{
    if (_mailTxt.text.length <= 0) {
        return [self alertShow:@"邮箱不能为空"];
    }
    else{
        BOOL flag = [self validateEmail:_mailTxt.text];
        if (!flag) {
            return [self alertShow:@"请输入正确的邮箱"];
        }
    }
    if (_positionTxt.text.length <= 0) {
        return [self alertShow:@"职位名称不能为空"];
    }
    if(_typeBtn.titleLabel.text.length <= 0 || [_typeBtn.titleLabel.text isEqualToString:@"请选择"]){
        return [self alertShow:@"请选择简历类型"];
    }
    if (_contentTxtView.text.length <= 0) {
        return [self alertShow:@"描述不能为空"];
    }
    if (_contentTxtView.text.length > 300) {
        return [self alertShow:@"字数超过限制"];
    }
    return YES;
}

-(BOOL)alertShow:(NSString *)message{
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
    [view show];
    return NO;
}
//邮箱格式
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#if 0
//pickerview
-(void)configPicker{
    allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, ScreenHeight)];
    allBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:allBgView];
    
    alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.5;
    [allBgView addSubview:alphaView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 205 - 64, ScreenWidth, 205)];
    bgView.backgroundColor = [UIColor whiteColor];
    [allBgView addSubview:bgView];
    
    picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 165)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    [bgView addSubview:picker];
    [self pickerBtn];
}
//确定取消按钮
-(void)pickerBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.backgroundColor = UIColorFromRGB(0xe13e3e);
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    btn.frame = CGRectMake(ScreenWidth - 55, 5, 50, 30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = UIColorFromRGB(0xf0f0f0);
    cancelBtn.frame = CGRectMake(5, 5, 50, 30);
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    [cancelBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    [allBgView insertSubview:bgView aboveSubview:alphaView];
    
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    cancelBtn.layer.cornerRadius = 2;
    cancelBtn.layer.masksToBounds = YES;
}

#pragma mark-picker代理
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return typeDic[_dataArray[row]];
}
//确定
-(void)btnSureClick:(UIButton *)sender{
    NSInteger selectedSec = [picker selectedRowInComponent:0];
    [_typeBtn setTitle:typeDic[_dataArray[selectedSec]] forState:UIControlStateNormal];
    [_typeBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self pickerHide];
}
//取消
-(void)btnCancelClick:(UIButton *)sender{
    [self pickerHide];
}
//显示picker
-(void)pickerShow{
    [UIView animateWithDuration:0.2 animations:^{
        allBgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}
//隐藏picker
-(void)pickerHide{
    [UIView animateWithDuration:0.2 animations:^{
        allBgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    }];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [pickerView selectedRowInComponent:0];
}
#endif


@end
