//
//  ELRealNameAuthenticationCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELRealNameAuthenticationCtl.h"
#import "PhotoBrowerCtl.h"
#import "AlbumListCtl.h"
#import "HistoryTableView.h"

@interface ELRealNameAuthenticationCtl () <UITextFieldDelegate,UINavigationControllerDelegate,PhotoBrowerDelegate,UIImagePickerControllerDelegate,PhotoSelectCtlDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *backView;
    
    __weak IBOutlet UITextField *realNameTF;
    __weak IBOutlet UITextField *idcardTF;

    __weak IBOutlet UITextField *phoneTF;

    __weak IBOutlet UIButton *deleteBtn;
    __weak IBOutlet UIImageView *addImage;
    
    __weak IBOutlet UIButton *finishBtn;
    
    __weak IBOutlet UILabel *reasonLable;
    BOOL showKeyBoard;
    CGFloat keyboarfHeight;
    
    UIView *viewTF;
    UITextField *textTF;
    
    __weak IBOutlet UIButton *getAuthCodeBtn;
    ELRequest *mobileRequest;
    
    __weak IBOutlet UITextField *authCodeTF;
    
    __weak IBOutlet UILabel *authcodeLb;
    
    __weak IBOutlet UIView *addImageView;
    
    IBOutlet UIView *sheetView;
    
    UIImage *shareImage;
    
    __weak IBOutlet UIButton *beginApplyBtn;
    NSString *shareImageUrl;
    BOOL isAuthentication;
    
    __weak IBOutlet UIImageView *idcordImage;
    
    BOOL alreadySendMessage;
    NSInteger timeCount;
    NSTimer *currentTimer;
}
@end

@implementation ELRealNameAuthenticationCtl


-(void)animationTimeBtn:(NSTimer *)timer
{
    timeCount -= 1;
    NSString *str;
    if (timeCount <= 0)
    {
        [currentTimer invalidate];
        str = @"获取验证码";
        alreadySendMessage = NO;
    }
    else
    {
        str = [NSString stringWithFormat:@"%ld",(long)timeCount];
        alreadySendMessage = YES;
    }
    
    [getAuthCodeBtn setTitle:str forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    scrollView.userInteractionEnabled = YES;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
    scrollView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight-NavBarHeight);
    
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    
    deleteBtn.hidden = YES;
//    self.navigationItem.title = @"实名认证";
    [self setNavTitle:@"实名认证"];
    
    getAuthCodeBtn.layer.cornerRadius = 4.0;
    getAuthCodeBtn.layer.masksToBounds = YES;
    
    finishBtn.layer.cornerRadius = 4.0;
    finishBtn.layer.masksToBounds = YES;
    
    backView.layer.cornerRadius = 8.0;
    backView.layer.masksToBounds = YES;
    
    [self creatView];
}

-(void)tapImage:(UITapGestureRecognizer *)sender
{
    [self hideKeyBoardOne];
    sheetView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight - NavBarHeight);
    
    CGRect frame = idcordImage.frame;
    frame.origin.y = ([UIScreen mainScreen].bounds.size.height - 184 - 245)/2;
    idcordImage.frame = frame;
    [self.view addSubview:sheetView];
    [self.view bringSubviewToFront:sheetView];
}
- (IBAction)changeImageBtn:(UIButton *)sender
{
    if (sender.tag == 100 || sender.tag == 200)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        if (sender.tag == 100)
        {
            BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
            if (!accessStatus) {
                return;
            }
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else if (sender.tag == 200)
        {
            //imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
            albumListCtl.maxCount = 1;
            albumListCtl.delegate = self;
            albumListCtl.fromTodayList = YES;
            [self.navigationController pushViewController:albumListCtl animated:YES];
            [albumListCtl beginLoad:nil exParam:nil];
            [sheetView removeFromSuperview];
            return;
        }
        [self presentViewController:imagePickerController animated:YES completion:^{}];
       
    }
    [sheetView removeFromSuperview];
}

- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    if (imageArr.count > 0)
    {
        shareImage = imageArr[0];
        shareImage = [shareImage fixOrientation];
        if (!shareImage) {
            return;
        }
        [self uploadPhoto];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    shareImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    shareImage = [shareImage fixOrientation];
    if (!shareImage) {
        return;
    }
    [self uploadPhoto];
}

-(void)finishWithImageArr:(NSArray *)arr
{
    if (arr.count > 0)
    {
        shareImage = arr[0];
        [self uploadPhoto];
    }
}

-(void)uploadPhoto
{
    if(![MyCommon IsEnable3G] && ![MyCommon IsEnableWIFI])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络访问" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    @try
    {
        NSData *imgData = UIImageJPEGRepresentation(shareImage, 0.1);
        NSDate * now = [NSDate date];
        NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
        RequestCon *uploadCon = [self getNewRequestCon:NO];
        
        [uploadCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally {
        
    }
}
-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UploadPhotoFile:
        {
            Upload_DataModal *modal = dataArr[0];
            shareImageUrl = modal.path_;
            if(shareImageUrl.length == 0)
            {
                [BaseUIViewController showAutoDismissFailView:@"" msg:@"上传失败" seconds:1.0];
                return;
            }
            CGPoint center = addImage.center;
            CGSize size = [MyCommon creatHeightWidthSize:shareImage.size andSize:CGSizeMake(ScreenWidth-65,123)];
            addImage.frame = CGRectMake(0,0,size.width, size.height);
            addImage.center = center;
            
            CGRect frame = deleteBtn.frame;
            frame.origin.x = addImage.frame.size.width + addImage.frame.origin.x - 25;
            frame.origin.y = addImage.frame.origin.y - 5;
            deleteBtn.frame = frame;
            
            addImage.image = shareImage;
            deleteBtn.hidden = NO;
            addImage.userInteractionEnabled = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    switch (type) {
        case Request_UploadPhotoFile:
        {
            [self uploadPhoto];
        }
            break;
    }
}

-(void)creatView
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString * function = @"isVerifyMobile";
    NSString * op = @"yl_bill_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    Status_DataModal *statusModal = [[Status_DataModal alloc] init];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        statusModal.status_ = [dic objectForKey:@"status_desc"];
        statusModal.code_ = [dic objectForKey:@"code"];
        NSString *mobile = dic[@"info"][@"person_mobile"];
        if (mobile == nil) {
            mobile = @"";
        }
        
        if ([statusModal.code_ isEqualToString:@"200"])
        {
            isAuthentication = YES;
            getAuthCodeBtn.backgroundColor = PINGLUNHUI;
            getAuthCodeBtn.userInteractionEnabled = NO;
            [getAuthCodeBtn setTitle:@"已认证" forState:UIControlStateNormal];
            [getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phoneTF.text = mobile;
            
            authCodeTF.hidden = YES;
            authcodeLb.hidden = YES;
            CGRect frame = backView.frame;
            frame.size.height = 350;
            backView.frame = frame;
            
            frame = addImageView.frame;
            frame.origin.y = 137;
            addImageView.frame = frame;
//            phoneTF.returnKeyType = DefaultType;
            phoneTF.returnKeyType = UIReturnKeyDefault;
        }
        else
        {
            isAuthentication = NO;
            getAuthCodeBtn.backgroundColor = PINGLUNHONG;
            getAuthCodeBtn.userInteractionEnabled = YES;
            [getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [getAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phoneTF.text = mobile;
            
            authCodeTF.hidden = NO;
            authcodeLb.hidden = NO;
            CGRect frame = backView.frame;
            frame.size.height = 380;
            backView.frame = frame;
            
            frame = addImageView.frame;
            frame.origin.y = 167;
            addImageView.frame = frame;
            
            phoneTF.returnKeyType = UIReturnKeyNext;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)hideKeyBoardOne
{
    [realNameTF resignFirstResponder];
    [idcardTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [authCodeTF resignFirstResponder];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textTF = textField;
    
    UIView *view = textField.superview;
    CGRect rect1 = [view convertRect:textField.frame toView:self.view];
    viewTF = view;
    
    if (textField == phoneTF && isAuthentication) {
        return NO;
    }
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView.contentOffset = CGPointMake(0,height + scrollView.contentOffset.y);
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == realNameTF)
    {
        [realNameTF resignFirstResponder];
        [idcardTF becomeFirstResponder];
    }
    else if (textField == idcardTF)
    {
        [idcardTF resignFirstResponder];
        [phoneTF becomeFirstResponder];
    }
    else if (textField == phoneTF)
    {
        if (!isAuthentication)
        {
            [phoneTF resignFirstResponder];
            [authCodeTF becomeFirstResponder];
        }
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
    if (sender == getAuthCodeBtn)
    {
        if (alreadySendMessage)
        {
            return;
        }
        
        if ([[phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:nil msg:@"请输入手机号码" btnTitle:@"确定"];
            return;
        }
        if (![MyCommon isMobile:phoneTF.text])
        {
            [BaseUIViewController showAlertView:nil msg:@"输入的手机号码有误" btnTitle:@"确定"];
            return;
        }
        
        [phoneTF resignFirstResponder];
        
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&mobile=%@",[Manager getUserInfo].userId_,phoneTF.text];
        [BaseUIViewController showLoadView:YES content:@"正在发送" view:self.view];
        [ELRequest postbodyMsg:bodyMsg op:@"yl_verify_code_busi" func:@"sendShimingCode" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
        {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            NSDictionary *dic = result;
            NSString *status = dic[@"status"];
            NSString *desc = dic[@"status_desc"];
            if ([status isEqualToString:@"OK"])
            {
                [BaseUIViewController showAutoDismissSucessView:@"" msg:desc seconds:1.0];
                timeCount = 60;
                currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animationTimeBtn:) userInfo:nil repeats:YES];
            }
            else
            {
                [BaseUIViewController showAutoDismissSucessView:@"" msg:desc seconds:1.0];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        }];
    }
    else if (sender == deleteBtn)
    {
        addImage.frame = CGRectMake(25,43,ScreenWidth-65,123);
        deleteBtn.frame = CGRectMake(ScreenWidth-72,43,32,28);
        deleteBtn.hidden = YES;
        addImage.image = [UIImage imageNamed:@"realnameaddimage.png"];
        addImage.userInteractionEnabled = YES;
        shareImageUrl = @"";
    }
    else if (sender == finishBtn)
    {
         if(!isAuthentication)
         {
            if ([[realNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入姓名" btnTitle:@"确定"];
                return;
            }
            else if ([[idcardTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入身份证号" btnTitle:@"确定"];
                return;
            }
            else if ([[phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入手机号码" btnTitle:@"确定"];
                return;
            }
            else if ([[authCodeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入手机验证码" btnTitle:@"确定"];
                return;
            }
            else if (shareImageUrl.length == 0)
            {
                [BaseUIViewController showAlertView:nil msg:@"请上传你的证件照" btnTitle:@"确定"];
                return;
            }
            if (![MyCommon isMobile:phoneTF.text])
            {
                [BaseUIViewController showAlertView:nil msg:@"输入的手机号码有误" btnTitle:@"确定"];
                return;
            }
           

            NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&mobile=%@&code=%@",[Manager getUserInfo].userId_,phoneTF.text,authCodeTF.text];
            [ELRequest postbodyMsg:bodyMsg op:@"yl_verify_code_busi" func:@"verifyShimingCode" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
            {
                NSDictionary *dic = result;
                if ([dic[@"status"] isEqualToString:@"OK"])
                {
                    [self finishRequest];
                }
                else
                {
                    [BaseUIViewController showAutoDismissFailView:@"" msg:dic[@"status_desc"] seconds:1.0];
                }
                
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                
            }];
        }
        else
        {
            if ([[realNameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入姓名" btnTitle:@"确定"];
                return;
            }
            else if ([[idcardTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [BaseUIViewController showAlertView:nil msg:@"请输入身份证号" btnTitle:@"确定"];
                return;
            }
            else if (shareImageUrl.length == 0)
            {
                [BaseUIViewController showAlertView:nil msg:@"请上传你的证件照" btnTitle:@"确定"];
                return;
            }
            [self finishRequest];
        }
        
    }
    else if (sender == beginApplyBtn)
    {
        CGRect frame = backView.frame;
        frame.origin.x = 8;
        frame.origin.y = 146;
        backView.frame = frame;
        backView.hidden = NO;
    }
    
}

-(void)finishRequest
{

    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:realNameTF.text forKey:@"sl_name"];
    [conditionDic setObject:idcardTF.text forKey:@"sl_code"];
    [conditionDic setObject:shareImageUrl forKey:@"sl_pic"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&arr=%@",userId,conditionDicStr];
    
    [BaseUIViewController showLoadView:YES content:@"正在处理..." view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"add_shiming_sumibt" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
    {
        [BaseUIViewController showLoadView:NO content:@"提交成功" view:self.view];
        NSDictionary *dic = result;
        NSString *desc = dic[@"status_desc"];
        if ([dic[@"status"] isEqualToString:@"OK"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"" msg:desc seconds:1.0];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)dealloc
{
    if (currentTimer)
    {
        timeCount = 0;
        [self animationTimeBtn:currentTimer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
