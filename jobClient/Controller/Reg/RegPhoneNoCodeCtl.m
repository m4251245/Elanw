 //
//  RegPhoneNoCodeCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//无验证码注册

#import "RegPhoneNoCodeCtl.h"
#import "ServiceCode_DataModal.h"
#import "RegInfoOneCtl.h"

@interface RegPhoneNoCodeCtl ()<UITextFieldDelegate>
{
    ServiceCode_DataModal *_serviceCode;
}
@end

@implementation RegPhoneNoCodeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"注册一览";
    [self setNavTitle:@"注册一览" withColor:[UIColor blackColor]];
    _pwdTF.delegate = self;
    CALayer *btnLayer = _registBtn.layer;
    btnLayer.masksToBounds = YES;
    btnLayer.cornerRadius = 3.0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0xe0e0e0);
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"请输入6-20位密码" attributes:attrs];
    _pwdTF.attributedPlaceholder = string;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextFieldTextDidChangeNotification object:nil];
    
    [self refreshButtonStatus];
}

#pragma mark - 动态改变社群名称输入框的高度和位置
-(void)textChanged:(NSNotification *)textView{
    [self refreshButtonStatus];
}

-(void)setBackBarBtnAtt{
    [super setBackBarBtnAtt];
    [backBarBtn_ setImage:[UIImage imageNamed:@"back_grey_new_back"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//-----------数据请求与刷新－－－－－－－－－－

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (requestCon_ == nil) {
        requestCon_ = [self getNewRequestCon:NO];
    }
    [requestCon_ registNoCodeWithPhone:_phone pwd:_pwdTF.text code:_serviceCode.code snumber:_serviceCode.number];
}


-(void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_RegistNoCode:
        {
            User_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.code_ isEqualToString:@"200"] ){
                //记录友盟统计注册来源数量
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"registerSource" attributes:dict];
                
                //记录友盟统计注册总数
                NSDictionary *dict1 = @{@"Source" : @"注册总数"};
                [MobClick event:@"registerAmount" attributes:dict1];
                [BaseUIViewController showAlertViewContent:@"注册成功" toView:nil second:1.0 animated:YES];
                dataModal.uname_ = _phone;
                dataModal.pwd_ = _pwdTF.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistSuccess" object:nil userInfo:@{@"key":dataModal}];
                [self performSelector:@selector(startLogin) withObject:nil afterDelay:1.0];
            }else{
                NSString *str = dataModal.des_;
                if( !str || ![str isKindOfClass:[NSString class]] ){
                    str = @"请稍候再试";
                }
                
                [BaseUIViewController showAlertView:@"注册失败" msg:str btnTitle:@"确定"];
            }
        }
            break;

        default:
            break;
    }
}

-(void)startLogin
{
    [[Manager shareMgr].loginCtl_ login:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)btnResponse:(id)sender
{
    if (sender == _registBtn) {
        if ([_pwdTF.text length] < 6 ||[_pwdTF.text length] >20 ||[MyCommon checkSpacialCharacter:@"\"`'#-& " inString:_pwdTF.text]) {
            [BaseUIViewController showAlertView:@"请输入6-20位字符（\"`' # - & 除外），区分大小写" msg:nil btnTitle:@"确定"];
            [_pwdTF becomeFirstResponder];
            return;
        }
        [self beginLoad:nil exParam:nil];
    }
}

- (void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    NSLog(@"%d",  code);
}

#pragma mark - 密码的明文密文状态
- (IBAction)passWordBtnRespone:(UIButton *)sender {
    if (!_pwdTF.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"code_nosee"] forState:UIControlStateNormal];
        _pwdTF.secureTextEntry = YES;
    }
    else{
        [sender setImage:[UIImage imageNamed:@"code_cansee"] forState:UIControlStateNormal];
        _pwdTF.secureTextEntry = NO;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _pwdTF){
        [MyCommon dealTxtFiled:textField maxLength:20];
    }
    return YES;
}
#pragma mark - 修改注册按钮状态
-(void)refreshButtonStatus{
    NSString *str1 = [_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!str1 || [str1 isEqualToString:@""]){
        _registBtn.userInteractionEnabled = NO;
        [_registBtn setTitleColor:UIColorFromRGB(0xFFBEBE) forState:UIControlStateNormal];
    }else{
        _registBtn.userInteractionEnabled = YES;
        [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_pwdTF resignFirstResponder];
}

@end
