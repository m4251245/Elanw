 //
//  RegFirstCtl.m
//  jobClient
//
//  Created by 一览ios on 14/12/21.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RegInfoOneCtl.h"
#import "User_DataModal.h"
#import "NSString+URLEncoding.h"
#import "RegInfoTwoCtl.h"
#import "Upload_DataModal.h"
#import "TLoginTradeInputCtl.h"
#import "AlbumListCtl.h"
#import "RootTabBarViewController.h"
#import "AssociationAppDelegate.h"

@interface RegInfoOneCtl ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CondictionListDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,PhotoSelectCtlDelegate>
{
    User_DataModal          *   indaModal_;
    BOOL       haveImg_;
    NSString * base64Str_;
    NSString * userId_;
    NSString *_sex;
    BOOL bKeyboardShow_;
    UITapGestureRecognizer *_singleTapRecognizer;
    CGFloat _distance;
    RequestCon *_uploadImgCon;
}
@end

@implementation RegInfoOneCtl

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        rightNavBarStr_ = @"下一步";
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    if(![indaModal_.sex_ isEqualToString:@"女"]){
        indaModal_.sex_ = @"男";
    }
//    self.navigationItem.title = @"个人档案";
    [self setNavTitle:@"个人档案"];
    _nameInputTF.delegate = self;
    [self initAttr];
    
    if ([Manager shareMgr].isThridLogin_) {
        [self initThirdLogin];
    }
    
}

- (void)initThirdLogin
{
    indaModal_ = [Manager getUserInfo];
    if(indaModal_.img_ && ![indaModal_.img_ isEqualToString:@""]){
        [_userIconBtn sd_setImageWithURL:[NSURL URLWithString:indaModal_.img_] forState:UIControlStateNormal];
    }
    if (indaModal_.sex_ && ![indaModal_.sex_ isEqualToString:@""]) {
        if ([indaModal_.sex_ isEqualToString:@"女"]){
            _sexWomanBtn.selected = YES;
            _sex = @"女";
            _sexWomanBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
        }else{
            _sexManBtn.selected = YES;
            _sex = @"男";
            _sexManBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];

        }
    }
    if (indaModal_.name_) {
        _nameInputTF.text = indaModal_.name_;
    }
    [_agreeBtn setImage:[UIImage imageNamed:@"rememberPSW2.png"] forState:UIControlStateSelected];
    [_agreeBtn setImage:[UIImage imageNamed:@"rememberPSW.png"] forState:UIControlStateNormal];
}

- (void)initAttr
{
    CALayer *layer = _userIconBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.0;
    CALayer *sexLayer = _sexManBtn.layer;
    sexLayer.masksToBounds = YES;
    sexLayer.cornerRadius = 4.0;
    sexLayer.borderWidth = 1.0;
    sexLayer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    CALayer *gireBtnLayer = _sexWomanBtn.layer;
    gireBtnLayer.masksToBounds = YES;
    gireBtnLayer.cornerRadius = 4.0;
    gireBtnLayer.borderWidth = 1.0;
    gireBtnLayer.borderColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0].CGColor;
    CALayer *nextBtnLayer = _nextBtn.layer;
    nextBtnLayer.masksToBounds = YES;
    nextBtnLayer.cornerRadius = 4.0;
    [_sexManBtn setImage:[UIImage imageNamed:@"icon_boy_no.png"] forState:UIControlStateNormal];
    [_sexManBtn setImage:[UIImage imageNamed:@"icon_boy_yes.png"] forState:UIControlStateSelected];
    [_sexWomanBtn setImage:[UIImage imageNamed:@"icon_girl_no.png"] forState:UIControlStateNormal];
    [_sexWomanBtn setImage:[UIImage imageNamed:@"icon_girl_yes.png"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (!indaModal_) {
       indaModal_ = [[User_DataModal alloc] init];
    }
    indaModal_ = dataModal;
}

- (void)getDataFunction:(RequestCon *)con
{
    
}


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == _uploadImgCon) {
        Upload_DataModal *dataModel = dataArr[0];
        indaModal_.img_ = dataModel.path_;
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}


- (void)btnResponse:(id)sender
{
    if(sender == _sexManBtn){
        if (_sexWomanBtn.selected) {
            _sexWomanBtn.selected = NO;
            _sexWomanBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        }
        if (_sexManBtn.selected) {
            _sexManBtn.selected = NO;
            _sexManBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
            _sex = nil;
        }else{
            _sexManBtn.selected = YES;
            _sexManBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
            _sex = @"男";
        }
    }else if(sender == _sexWomanBtn){
        if (_sexManBtn.selected) {
            _sexManBtn.selected = NO;
            _sexManBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        }
        if (_sexWomanBtn.selected) {
            _sexWomanBtn.selected = NO;
            _sexWomanBtn.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
            _sex = nil;
        }else{
            _sexWomanBtn.selected = YES;
            _sexWomanBtn.backgroundColor = [UIColor colorWithRed:215.0/255 green:50.0/255 blue:50.0/255 alpha:1.0];
            _sex = @"女";
        }
        
    }else if (sender == _userIconBtn){
        //上传头像
        NSString * camaraStr = @"现在拍摄";
        NSString * albumStr = @"相册选取";
        if (haveImg_) {
            albumStr = @"从相册里换一张";
            camaraStr = @"重新拍摄";
        }
        UIActionSheet *uploadImgSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:albumStr,camaraStr,nil];
        [uploadImgSheet showInView:self.view];
    }else if (sender == _nextBtn){
        [self rightBarBtnResponse:_nextBtn];
    }else if (sender == _agreeBtn){
        _agreeBtn.selected = !_agreeBtn.selected;
    }else if (sender == _protocalBtn){
        AgreementCtl* agreementCtl_ = [[AgreementCtl alloc] init];
        [self.navigationController pushViewController:agreementCtl_ animated:YES];
    }
}


#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (buttonIndex) {
            case 1:
            {
                // 相机
                BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                if (!accessStatus) {
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
                break;
            case 0:
                // 相册
            {
                AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                albumListCtl.maxCount = 1;
                albumListCtl.delegate = self;
                [self.navigationController pushViewController:albumListCtl animated:YES];
                [albumListCtl beginLoad:nil exParam:nil];
                return;
            }
                // sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                // 取消
                return;
        }
    }
    else {
        if (buttonIndex == 0) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //base64编码上传头像
    UIImage *uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [_userIconBtn setImage:nil forState:UIControlStateNormal];
    [_userIconBtn setBackgroundImage:uploadImage forState:UIControlStateNormal];
    [_userIconDescLb setText:@"重新上传"];
    [_userIconDescLb setTextColor:[UIColor colorWithRed:226.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0]];
    [_userIconDescLb setBackgroundColor:[UIColor whiteColor]];
    haveImg_ = YES;
    NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.01);
    base64Str_ = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]URLEncodedForString];
    
    if (_uploadImgCon == nil) {
        _uploadImgCon = [self getNewRequestCon:NO];
    }
    //以时间命名图片
    NSDate * now = [NSDate date];
    NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
    [_uploadImgCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
}

- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    //    for (UIImage *image in imageArr) {
    //        [self.photoView reloadDataWithImage:image];
    //    }
    if (imageArr.count > 0)
    {
        UIImage *uploadImage = imageArr[0];
        [_userIconBtn setImage:nil forState:UIControlStateNormal];
        [_userIconBtn setBackgroundImage:uploadImage forState:UIControlStateNormal];
        [_userIconDescLb setText:@"重新上传"];
        [_userIconDescLb setTextColor:[UIColor colorWithRed:226.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:1.0]];
        [_userIconDescLb setBackgroundColor:[UIColor whiteColor]];
        haveImg_ = YES;
        NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.01);
        base64Str_ = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]URLEncodedForString];
        
        if (_uploadImgCon == nil) {
            _uploadImgCon = [self getNewRequestCon:NO];
        }
        //以时间命名图片
        NSDate * now = [NSDate date];
        NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
        [_uploadImgCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameInputTF resignFirstResponder];
    [self rightBarBtnResponse:nil];
    return YES;
}

#pragma mark 下一步
- (void)rightBarBtnResponse:(id)sender
{
    if (!_sex) {
        [BaseUIViewController showAlertView:@"请选择性别" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([[_nameInputTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"请填写名字" msg:nil btnTitle:@"确定"];
        return;
    }
//    if (!_agreeBtn.selected) {
//         [BaseUIViewController showAlertView:@"您必须同意一览的用户协议才能进行下一步操作" msg:nil btnTitle:@"确定"];
//        return;
//    }
    
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9 ]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *temp = [_nameInputTF.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"，" withString:@""];
    if(![pred evaluateWithObject: temp]){
        [BaseUIViewController showAlertView:@"名字只能由中文,字母或者数字组成" msg:nil btnTitle:@"确定"];
        [_nameInputTF becomeFirstResponder];
        return;
    }
    indaModal_.sex_ = _sex;
    indaModal_.name_ = _nameInputTF.text;
    
    if (_type == ThirdLogin) {
        if (!_agreeBtn.selected) {
            [BaseUIViewController showAlertView:@"您必须选择同意一览的用户协议" msg:nil btnTitle:@"确定"];
            return;
        }
        TLoginTradeInputCtl *tLoginCtl = [[TLoginTradeInputCtl alloc]init];
        tLoginCtl.inDataModal = indaModal_;
        [self.navigationController pushViewController:tLoginCtl animated:YES];
        return;
    }
    RegInfoTwoCtl *regInfoTwoCtl = [[RegInfoTwoCtl alloc] init];
    [self.navigationController pushViewController:regInfoTwoCtl animated:YES];
    [regInfoTwoCtl beginLoad:indaModal_ exParam:nil];
}

- (void)backBarBtnResponse:(id)sender
{
    if ([Manager shareMgr].haveLogin) {//已登录 未完善信息
        if(_type == ThirdLogin){
            if(_isNeedBack){
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
#if 0
//  信息未完善时候使用
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTip"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *thirdlogin = [NSString stringWithFormat:@"%@_isNeedShow",[CommonConfig getDBValueByKey:Config_Key_UserID]];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:thirdlogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
                [self login];
            }
        }
        else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }else{//注册
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Manager shareMgr].isPublishReginfoCtl = NO;
        if (indaModal_) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistSuccess" object:nil userInfo:@{@"key":indaModal_}]; 
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        if (![Manager shareMgr].haveLogin) {
            [[Manager shareMgr].loginCtl_ login:0];
        }
    }
}

-(void)login{
    AssociationAppDelegate *delegate = (AssociationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([Manager shareMgr].isNeedRefresh || [Manager shareMgr].isFirstLoading) {
        [Manager shareMgr].tabVC = [[RootTabBarViewController alloc]init];
        [Manager shareMgr].isNeedRefresh = NO;
    }
    if (![Manager shareMgr].tabVC) {
        [Manager shareMgr].tabVC = [[RootTabBarViewController alloc] init];
    }
    delegate.window.rootViewController = [Manager shareMgr].tabVC;
    for (id vc in [Manager shareMgr].tabVC.viewControllers) {
        if ([vc childViewControllers].count > 1) {
            [Manager shareMgr].tabVC.tabBar.hidden = YES;
        }
    }
}

@end
