//
//  CompanyName_settingViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/28.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "CompanyName_settingViewController.h"
#import "UIScrollView+touch.h"
@interface CompanyName_settingViewController ()<UITextFieldDelegate,UIScrollViewDelegate>{
    NSDictionary *numDic;
    NSDictionary *titleDic;
    NSDictionary *requestDic;
    NSDictionary *oldRequestDic;
}
@property (weak, nonatomic) IBOutlet UITextField *inputTxt;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CompanyName_settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_inputTxt];
    [self loadData];
    [self configUI];
    
}

#pragma mark--初始化UI

-(void)configUI{
    if(_nowCname.length > 0){
        _numLb.text = [NSString stringWithFormat:@"%ld",(long)([numDic[@(_cType)][_cType] intValue] - _nowCname.length)];
    }
    else{
        _numLb.text = numDic[@(_cType)][_cType];
    }
    
    [self setNavTitle:titleDic[@(_cType)][_cType]];
    [self rightButtonItemWithTitle:@"确定"];
    [self leftButtonItem:@"back_white_new"];
}

#pragma mark--加载数据
-(void)loadData{
    numDic = @{@(_cType):@[@"6",@"100",@"5",@"8",@"50"]};
    requestDic = @{@(_cType):@[@"cname_jc",@"http",@"pname",@"pnames",@"email"]};
    oldRequestDic = @{@(_cType):@[@"cname_jc_before",@"http_before",@"pname_before",@"pnames_before",@"email_before"]};
    titleDic = @{@(_cType):@[@"企业简称",@"企业主页",@"招聘负责人",@"负责人职位",@"简历接收邮箱"]};
    _inputTxt.text = _nowCname;
}

#pragma mark--请求数据
-(void)requestInfo{
    if (_cType == 1) {
        BOOL isSite = [self smartURLForString:_inputTxt.text];
        if (!isSite) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的网站" seconds:3.f];
            return;
        }
    }
    if (_cType == 4) {
        BOOL result = [MyCommon isValidateEmail:_inputTxt.text];
        if (!result) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请输入正确的邮箱" seconds:3.f];
            return;
        }
    }
   
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    if (_inputTxt.text.length > 0) {
        //组装请求参数
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:_nowCname forKey:oldRequestDic[@(_cType)][_cType]];
        [conditionDic setObject:_inputTxt.text forKey:requestDic[@(_cType)][_cType]];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
        NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&contact_arr=%@",_companyId,conDicStr];
        NSString *function = @"editCompanyInfo";
        NSString *op = @"company_info_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            NSString *status = result[@"status"];
            if ([status isEqualToString:@"TRUE"]) {
                _MyBlock(_inputTxt.text);
                [self.navigationController popViewControllerAnimated:YES];
            }
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        }];
    }
    else{
        [self showAlert:@"内容不能为空！"];
    }
}

#pragma mark--代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_inputTxt]) {
        NSArray *arr = numDic[@(_cType)];
        [MyCommon limitTextFieldTextNumberWithTextField:_inputTxt wordsNum:[arr[_cType] intValue] numLb:_numLb];
        return YES;
    }
    return NO;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark--事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)leftBtnClick:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick:(id)button{
    [_inputTxt resignFirstResponder];
    [self requestInfo];
}

#pragma mark--通知
//限制输入字数，包括联想字
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSArray *arr = numDic[@(_cType)];
    [MyCommon limitTextFieldTextNumberWithTextField:textField wordsNum:[arr[_cType] intValue] numLb:_numLb];
}

#pragma mark--业务逻辑
-(BOOL)showAlert:(NSString *)alertTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertTitle    delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil];
    [alert show];
    
    return NO;
}
//判断网站是否正确
- (BOOL)smartURLForString:(NSString *)str
{
    NSString *emailRegex = @"^[A-Za-z]+://[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&\?\\.=]+$";//http 开头
    NSString *urlStr = @"[A-Za-z0-9-_]+\\.[A-Za-z0-9-_%&\?\\.=]+$";//www开头
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    NSPredicate *urlTxt = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",urlStr];
    return [emailTest evaluateWithObject:str] | [urlTxt evaluateWithObject:str];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
