//
//  ELBecomeExpertFirstCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBecomeExpertFirstCtl.h"
#import "ELBecomeExpertTwoCtl.h"
#import "ELBeGoodAtTradeChangeCtl.h"
#import "ELTradeChangeCtl.h"
#import "ELGoodTradeChangeTwoCtl.h"
#import "LearnTechniqueCtl.h"
#import "ELBecomeExpertIntroCtl.h"

@interface ELBecomeExpertFirstCtl () <UITextFieldDelegate,LearnTechniqueProtocol,SelectTradeCtlDelegate,BeGoodAtChangeDelegate,EditorTradeDelegate,ChangeGoodTradeDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *personNameTF;
    
    __weak IBOutlet UITextField *goofFieldTF;
    
    __weak IBOutlet UITextField *phoneTF;
    
    __weak IBOutlet UITextField *emailTF;
    
    __weak IBOutlet UITextField *jobNameTF;
    __weak IBOutlet UITextField *companyNameTF;

    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UIView *backView;
    
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    
    UIView *viewTF;
    UITextField *textTF;
    ELBecomeExpertTwoCtl *expertTwoCtl;
    NSString *placeId;
    NSString *goodId;
    
    ELRequest *elRequest;
    
    NSString *personImagePic;
    
    NSString *userIntro;
    
    NSMutableArray *goodTradeArr;
}
@end

@implementation ELBecomeExpertFirstCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"申请成为行家";
    [self setNavTitle:@"申请成为行家"];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 4.0;
    nextBtn.clipsToBounds = YES;
    nextBtn.layer.cornerRadius = 4.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    scrollView.userInteractionEnabled = YES;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);

    [self creatRequest];
    
    [[self getNoNetworkView] removeFromSuperview];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"button_question_hangjia"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0,0,25,40);
    [rightButton addTarget:self action:@selector(rightButtonRespone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
}

-(void)rightButtonRespone:(UIButton *)sender{
    ELBecomeExpertIntroCtl *ctl = [[ELBecomeExpertIntroCtl alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)creatRequest
{

    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    NSString * function = @"getExpertApplyInfo";
    NSString * op = @"zd_ask_question_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         /*
          "person_iname": "粟刚",
          "person_pic": "http://img105.job1001.com/upload/faceimg/20140523/a41fbaae231dbe6fa170cf3fc31a9800_1400811174.jpeg",
          "person_gznum": "4.0",
          "person_zw": "php",
          "person_email": "gang_skye@163.com",
          "person_mobile": "13530747505",
          "good_at": "", // 擅长领域
          "good_at_tradeid": "", // 擅长领域编号
          "regionid": "440300", // 地区编号
          "person_region_name": "深圳市",  // 地区名称
          "person_intro"
          */
         NSDictionary *dic = result;
         NSString *personName = dic[@"person_iname"];
         NSString *personPic = dic[@"person_pic"];
         //NSString *personGznum = dic[@"person_gznum"];
        // NSString *personZw = dic[@"person_zw"];
         NSString *person_email = dic[@"person_email"];
         NSString *person_mobile = dic[@"person_mobile"];
         NSString *goodName = dic[@"good_at"];
         NSString *goodIdOne = dic[@"good_at_tradeid"];
        // NSString *regionid = dic[@"regionid"];
        // NSString *regionName = dic[@"person_region_name"];
         NSString *person_intro = dic[@"person_intro"];
         if(personName.length > 0)
         {
             personNameTF.text = personName;
         }
         if (personPic.length > 0) {
             personImagePic = personPic;
         }
         if (person_email.length > 0)
         {
             emailTF.text = person_email;
         }
         if (person_mobile.length > 0)
         {
             phoneTF.text = person_mobile;
         }
         if (goodName.length > 0 && goodIdOne.length > 0)
         {
             goofFieldTF.text = goodName;
             goodId = goodIdOne;
         }
         if (person_intro.length > 0)
         {
             userIntro = person_intro;
         }
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)hideKeyBoardOne
{
    [personNameTF resignFirstResponder];
    [companyNameTF resignFirstResponder];
    [goofFieldTF resignFirstResponder];
    [jobNameTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [emailTF resignFirstResponder];
}

-(void)keyBoardShow:(NSNotification *)notification
{
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboarfHeight = keyboardRect.size.height;
    
    CGRect rect1 = [viewTF convertRect:textTF.frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView.contentOffset = CGPointMake(0,height + scrollView.contentOffset.y);
    }
    scrollView.contentInset = UIEdgeInsetsMake(0,0,keyboarfHeight,0);
}

-(void)keyBoardHide:(NSNotification *)notification
{
    showKeyBoard = NO;
    scrollView.contentInset = UIEdgeInsetsZero;
}

-(void)editorSuccessWithTradeName:(NSString *)tradeName tradeId:(NSString *)tradeId
{
    goofFieldTF.text = tradeName;
    goodId = tradeId;
}

-(void)changeGoodTradeWithArr:(NSArray *)arrData
{
    if (arrData.count > 0)
    {
        if (!goodTradeArr)
        {
            goodTradeArr = [[NSMutableArray alloc] init];
        }
        [goodTradeArr removeAllObjects];
        personTagModel *model = arrData[0];
        NSString *tradeName = model.tagName_;
        NSString *tradeId = model.tagId_;
        [goodTradeArr addObject:model.tagName_];
        for (NSInteger i =1; i<arrData.count;i++)
        {
            personTagModel *modelOne = arrData[i];
            tradeName = [NSString stringWithFormat:@"%@,%@",tradeName,modelOne.tagName_];
            tradeId = [NSString stringWithFormat:@"%@,%@",tradeId,[modelOne.tagId_ isEqualToString:@"001"]?@"0":modelOne.tagId_];
            [goodTradeArr addObject:modelOne.tagName_];
        }
        goofFieldTF.text = tradeName;
        goodId = tradeId;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textTF = textField;
    if (textField == goofFieldTF)
    {
        ELGoodTradeChangeTwoCtl *ctl = [[ELGoodTradeChangeTwoCtl alloc]init];
        ctl.changeDelegate = self;
        ctl.selectNameArr = goodTradeArr;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
        [self hideKeyBoardOne];
        return NO;
    }
    
    UIView *view = textField.superview;
    CGRect rect1 = [view convertRect:textField.frame toView:self.view];
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView.contentOffset = CGPointMake(0,height + scrollView.contentOffset.y);
    }
    return YES;
}

-(void)updateTechniqueTags:(NSArray *)tags
{
    if (tags.count > 0)
    {
        personTagModel *tagModel = tags[0];
        goofFieldTF.text = tagModel.tagName_;
        goodId = tagModel.tagId_;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == personNameTF)
    {
        [personNameTF resignFirstResponder];
        [companyNameTF becomeFirstResponder];
    }
    else if (textField == companyNameTF)
    {
        [companyNameTF resignFirstResponder];
        [jobNameTF becomeFirstResponder];    }
    else if (textField == jobNameTF)
    {
        [jobNameTF resignFirstResponder];
        ELGoodTradeChangeTwoCtl *ctl = [[ELGoodTradeChangeTwoCtl alloc]init];
        ctl.changeDelegate = self;
        ctl.selectNameArr = goodTradeArr;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
    }
    else if (textField == phoneTF)
    {
        [phoneTF resignFirstResponder];
        [emailTF becomeFirstResponder];
    }
    else if (textField == emailTF)
    {
        [emailTF resignFirstResponder];
        [self btnRespone:nil];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 11 && textField == phoneTF)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (IBAction)btnRespone:(UIButton *)sender
{
    [self hideKeyBoardOne];

    if ([[personNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写姓名" btnTitle:@"确定"];
        return;
    }
    else if([[companyNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写公司名称" btnTitle:@"确定"];
        return;
    }
    else if([[jobNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写职位名称" btnTitle:@"确定"];
        return;
    }
    else if([[goofFieldTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请选择擅长行业" btnTitle:@"确定"];
        return;
    }
    else if([[phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写手机号码" btnTitle:@"确定"];
        return;
    }
    else if([[emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写邮箱" btnTitle:@"确定"];
        return;
    }
    
    if (![MyCommon isValidateEmail:emailTF.text])
    {
        [BaseUIViewController showAlertView:nil msg:@"输入的邮箱有误" btnTitle:@"确定"];
        return;
    }
    
    if(![MyCommon isMobile:phoneTF.text])
    {
        [BaseUIViewController showAlertView:nil msg:@"输入的手机号码有误" btnTitle:@"确定"];
        return;
    }
    
    if (!expertTwoCtl) {
        expertTwoCtl = [[ELBecomeExpertTwoCtl alloc] init];
    }
    expertTwoCtl.personName = personNameTF.text;
    expertTwoCtl.goodPlace = goodId;
    expertTwoCtl.personIntro = userIntro;
    expertTwoCtl.phone = phoneTF.text;
    expertTwoCtl.email = emailTF.text;
    expertTwoCtl.companyName = companyNameTF.text;
    expertTwoCtl.jobName = jobNameTF.text;
    
    [self.navigationController pushViewController:expertTwoCtl animated:YES];
}

-(void)updateTrade:(personTagModel *)personTagModel
{
    goofFieldTF.text = personTagModel.tagName_;
    goodId = personTagModel.tagId_;
}

- (IBAction)beGoodTradeBtnRespone:(UIButton *)sender {
    ELGoodTradeChangeTwoCtl *ctl = [[ELGoodTradeChangeTwoCtl alloc]init];
    ctl.changeDelegate = self;
    ctl.selectNameArr = goodTradeArr;
    [self.navigationController pushViewController:ctl animated:YES];
    [ctl beginLoad:nil exParam:nil];
    [self hideKeyBoardOne];
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
