//
//  ShareSalaryArticleCtl.m
//  Association
//
//  Created by YL1001 on 14-7-2.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ShareSalaryArticleCtl.h"
#import "FaceScrollView.h"
#import "NSString+URLEncoding.h"
#import "SalaryChangeTypeCtl.h"
#import "AlbumListCtl.h"
#import "SalaryCtl2.h"

@interface ShareSalaryArticleCtl () <UITextViewDelegate, PhotoSelectCtlDelegate>
{
    NSString * sourceId_;
    NSMutableArray  *   imgUrlArr_;
    int         currentOperateIndex_;
    FaceScrollView *_faceScrollView;
    CGRect oldFrame;
    BOOL isKeyBoardShow;
}

@end

@implementation ShareSalaryArticleCtl
@synthesize deletate_;
#pragma mark -lifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"提交";
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    self.navigationItem.title = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_contentTV_ resignFirstResponder];
    if (_faceScrollView.isShow) {
        [self hideFaceView:YES];
    }
    _faceScrollView = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"匿名灌薪水";
}


- (void)viewDidLoad
{
    [self sharePhotoview];
//    self.navigationItem.title = @"匿名灌薪水";
    [self setNavTitle:@"匿名灌薪水"];
    [super viewDidLoad];
    imgUrlArr_ = [[NSMutableArray alloc] init];
    _tipsLb_.text = @"来说点跟薪水相关的吧～\n（可以爆料公司环境、薪酬福利、人事内幕等）";
    
    [_facebtn setImage:[UIImage imageNamed:@"icon_keyboard.png"] forState:UIControlStateSelected];
    
//    [contentTV_.layer setCornerRadius:4.0];
    [addimgView_.layer setBorderWidth:0.5];
    [addimgView_.layer setBorderColor:[UIColor colorWithRed:112.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:0.5].CGColor];
    [self initFaceView];
    
    _contentTV_.delegate = self;
    
    CGRect frame = addimgView_.frame;
    frame.size.width = ScreenWidth;
    oldFrame = frame;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    self.scrollView_.userInteractionEnabled = YES;
    [self.scrollView_ addGestureRecognizer:tap];
    
//    self.view.backgroundColor = PINGLUNHONG;
//    self.navigationBarView.backgroundColor = PINGLUNHONG;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)tap:(UITapGestureRecognizer *)sender
{
    [self hideFaceView:YES];
    [_contentTV_ resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sharePhotoview
{
    if (!self.photoView)
    {
        self.photoView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0.0f,
                                                                           _contentTV_.frame.origin.y + _contentTV_.frame.size.height + 8,
                                                                           CGRectGetWidth(self.view.frame), 60)];
        [self.scrollView_ addSubview:self.photoView];
        self.photoView.delegate = self;
        self.photoView.alpha = 0.0;
        
        
    }
}

//实现代理方法
-(void)addPicker:(ZYQAssetPickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)addUIImagePicker:(UIImagePickerController *)picker
{
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)setViewAlpha:(BOOL)alpha
{
    if (alpha && self.photoView.alpha == 0.0) {
        self.photoView.alpha = 1.0;
        CGRect rect = addimgView_.frame;
        rect.origin.y = self.photoView.frame.origin.y + self.photoView.frame.size.height;
        addimgView_.frame = rect;
    }
    if (!alpha && self.photoView.alpha == 1.0) {
        self.photoView.alpha = 0.0;
        CGRect rect = addimgView_.frame;
        rect.origin.y = self.photoView.frame.origin.y;
        addimgView_.frame = rect;
    }
    oldFrame = addimgView_.frame;
}

-(void)deleteImage:(NSInteger)index
{
    @try {
        [imgUrlArr_ removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

#pragma mark - netWork
-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    sourceId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)submit
{
    NSString *contentStr = [_contentTV_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [BaseUIViewController showLoadView:YES content:@"正在发表" view:nil];
    if (!submitCon_) {
        submitCon_ = [self getNewRequestCon:NO];
    }
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    NSString * title = @"";
    @try {
        title = [contentStr substringToIndex:20];
    }
    @catch (NSException *exception) {
        title = contentStr;
    }
    @finally {
        
    }
    
    //添加图片在文章内容
    NSMutableString * thumStr = [NSMutableString stringWithFormat:@""];
    for (NSString * thum in imgUrlArr_) {
        [thumStr appendString:[NSString stringWithFormat:@"<img src=\\'%@\\'><br>",thum]];
    }
    
    NSMutableString *webStr = [[NSMutableString alloc] initWithString:contentStr];
    [webStr appendString:thumStr];
    NSString* unicodewebStr = [MyCommon utf8ToUnicode:webStr];
    title = [MyCommon utf8ToUnicode:title];
    if (!sourceId_) {
        sourceId_ = @"";
    }
    [submitCon_ shareSalaryArticle:userId job:nil title:title content:unicodewebStr sourceId:sourceId_];
}

-(void)uploadPhoto
{
    @try {
        if (currentOperateIndex_ == 0) {
            [BaseUIViewController showLoadView:YES content:@"正在上传图片" view:nil];
        }
        id image = [self.photoView.photoMenuItems objectAtIndex:currentOperateIndex_];
        UIImage * photo;
        if ([image isMemberOfClass:[ALAsset class]]) {
            ALAsset * alasset = image;
            photo = [UIImage imageWithCGImage:alasset.defaultRepresentation.fullScreenImage];
        }
        else{
            photo = image;
        }
        NSData *imgData = UIImageJPEGRepresentation(photo, 0.1);
        NSString* base64Str_ = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] URLEncodedForString];
        RequestCon * con  = [self getNewRequestCon:NO];
        [con uploadImgData:base64Str_];
        ++currentOperateIndex_;
    }
    @catch (NSException *exception) {
        [self submit];
    }
    @finally {
        
    }
    
}

-(void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    [BaseUIViewController showLoadView:NO content:nil view:nil];
    switch (type) {
        case Request_UploadImgData:
        {
            [self uploadPhoto];
        }
            break;
        case Request_ShareSalaryArticle:
        {
            rightBarBtn_.enabled = YES;
            [BaseUIViewController showAutoDismissFailView:@"发表失败" msg:@"请稍后再试"];
            currentOperateIndex_ = 0;
            [imgUrlArr_ removeAllObjects];
        }
            break;
        
        default:
            break;
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    [BaseUIViewController showLoadView:NO content:nil view:nil];
    switch (type) {
        case Request_ShareSalaryArticle:
        {
            rightBarBtn_.enabled = YES;
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status])
            {
                [BaseUIViewController showAutoDismissSucessView:@"发表成功" msg:nil];
                if (_fromTodayList)
                {
                    [self.navigationController popViewControllerAnimated:NO];
                    if ([Manager shareMgr].haveLogin)
                    {
                        SalaryChangeTypeCtl *ctl = [[SalaryChangeTypeCtl alloc] init];
                        ctl.salaryType = 3;
                        [self.navigationController pushViewController:ctl animated:YES];
                        [ctl beginLoad:nil exParam:nil];
                    }
                    else
                    {
                        SalaryCtl2 *salaryIrrigationCtl = [[SalaryCtl2 alloc]init];
                        [self.navigationController pushViewController:salaryIrrigationCtl animated:YES];
                        [salaryIrrigationCtl beginLoad:nil exParam:nil];
                    }
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareSalaryArticleOK" object:nil];
                [_contentTV_ resignFirstResponder];
                _contentTV_.text = @"";
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"" msg:dataModal.des_];
                currentOperateIndex_  = 0;
                [imgUrlArr_ removeAllObjects];
            }
        }
            break;
        case Request_UploadImgData:
        {
            
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [imgUrlArr_ addObject:dataModal.exObj_];
            }
            [self uploadPhoto];
        }
            break;
        default:
            break;
    }
}

-(void)backBarBtnResponse:(id)sender
{
    if ([[_contentTV_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]> 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有内容未提交，确定退出？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"退出",@"取消",nil];
        alert.tag = 11;
        [alert show];
    }
    else
    {
        [super backBarBtnResponse:sender];
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == chooseImgBtn_) {
        if (self.photoView.photoMenuItems.count < 4) {
            //在这里呼出下方菜单按钮项
            [_contentTV_ resignFirstResponder];
            UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                            delegate:self
                                            cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                            otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
            [myActionSheet showInView:self.view];
        }
        
    }
    else if(sender == _facebtn)
    {
        if (!_facebtn.selected) {
            [self showFaceView];
             _faceScrollView.isShow = YES;
            [_contentTV_ resignFirstResponder];
            _facebtn.selected = YES;
        }
        else
        {
//            [self hideFaceView:YES];
            [_contentTV_ becomeFirstResponder];
            _facebtn.selected = NO;
        }
    }
    
}

//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self addImage];
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
        if (!accessStatus) {
            return;
        }        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        if (buttonIndex == 0) {
            [super backBarBtnResponse:nil];
        }
    }
}

/*
 调用系统相册的方法
 */
-(void)addImage{
//    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
//    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = NO;
//    imagePickerController.sourceType = sourceType;
//    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
    NSInteger selectedCnt = self.photoView.photoMenuItems.count;
    albumListCtl.maxCount = 4-selectedCnt;
    albumListCtl.delegate = self;
    [self.navigationController pushViewController:albumListCtl animated:YES];
    [albumListCtl beginLoad:nil exParam:nil];
}

- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    [self.photoView assetPickerController:nil didFinishPickingAssets:imageArr];
}


//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissPickerController:picker];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //如果是 来自照相机的image，那么先保存
        UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(original_image, self,
                                       nil,
                                       nil);
    }
    //当选择的类型是图片
    if([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage *uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        uploadImage = [uploadImage fixOrientation];
        [self.photoView reloadDataWithImage:uploadImage];
    
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self.delegate dismissPickerController:picker];
}

#pragma mark - UIScrollViewDelegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_contentTV_ resignFirstResponder];
    [self hideFaceView:YES];
}

#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification
{
    //[self hideFaceView:YES];
    
    isKeyBoardShow = YES;
    _facebtn.selected = NO;
    _tipsLb_.text = @"";
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self.scrollView_ bringSubviewToFront:addimgView_];
    
    CGRect frame = addimgView_.frame;
    frame.origin.y = keyboardRect.origin.y - frame.size.height - 64 + self.scrollView_.contentOffset.y;
    frame.size.width = ScreenWidth;
    addimgView_.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isKeyBoardShow = NO;
    
    if (!_faceScrollView.isShow)
    {
        addimgView_.frame = oldFrame;
        [self hideFaceView:YES];
    }
    if ([_contentTV_.text isEqualToString:@""] && !_faceScrollView.isShow) {
        _tipsLb_.text = @"来说点跟薪水相关的吧～\n（可以爆料公司环境、薪酬福利、人事内幕等）";
    }
}

//显示表情
- (void)showFaceView{
    
    _tipsLb_.text = @"";
    _facebtn.selected = YES;
    
    if (_faceScrollView == nil) {
        [self initFaceView];
    }
    _faceScrollView.isShow = YES;
    CGRect frame = _faceScrollView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    
    CGRect frameOne = addimgView_.frame;
    frameOne.origin.y = frame.origin.y - frameOne.size.height + self.scrollView_.contentOffset.y;

    [UIView animateWithDuration:0.25 animations:^{
        _faceScrollView.frame = frame;
        addimgView_.frame = frameOne;
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = textView.text;
    if(range.length == 1 && [text isEqualToString:@""]) {
        NSString *result = [MyCommon substringExceptLastEmoji:content];
        if (![content isEqualToString:result]) {
            textView.text = result;
            if ([textView.text isEqualToString:@""])
            {
                
            }
            return NO;
        }
    }
    return YES;
}

- (void)initFaceView
{
    __weak ShareSalaryArticleCtl *this = self;
    _faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
        if ([faceName isEqualToString:@"delete"]) {
            NSString *text = this.contentTV_.text;
            if (!text || [text isEqualToString:@""]) {
                return ;
            }
            NSString *result = [MyCommon substringExceptLastEmoji:text];
            if (![text isEqualToString:result]) {
                this.contentTV_.text = result;
            }else{
                this.contentTV_.text = [text substringToIndex:text.length-1];
            }
            return;
        }
        NSString *temp = this.contentTV_.text;
        this.contentTV_.text = [temp stringByAppendingFormat:@"%@", faceName];
    }];
    _faceScrollView.backgroundColor = [UIColor whiteColor];
    _faceScrollView->faceView.backgroundColor = [UIColor whiteColor];
    _faceScrollView.frame = CGRectMake(0, ScreenHeight, 0, 0);
    [self.view addSubview:_faceScrollView];
}

//隐藏表情,是否隐藏工具栏
- (void)hideFaceView:(BOOL)hideToolBar{
    if ( !_faceScrollView.isShow) {
        return;
    }
    _faceScrollView.isShow = NO;
    _facebtn.selected = NO;
    CGRect frame = _faceScrollView.frame;
    frame.origin.y = ScreenHeight+30;
    [UIView animateWithDuration:0.25 animations:^{
        _faceScrollView.frame = frame;
        addimgView_.frame = oldFrame;
    }];
    if ([_contentTV_.text isEqualToString:@""] && !isKeyBoardShow) {
        _tipsLb_.text = @"来说点跟薪水相关的吧～\n（可以爆料公司环境、薪酬福利、人事内幕等）";
    }
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarBtnResponse:(id)sender
{
    NSString *contentStr = [_contentTV_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([contentStr length] == 0) {
        [BaseUIViewController showAlertView:@"内容不得为空" msg:nil btnTitle:@"确定"];
        return;
    }
    [_contentTV_ resignFirstResponder];
    
    rightBarBtn_.enabled = NO;
    if ([self.photoView.photoMenuItems count] > 0) {
        [self uploadPhoto];
    }
    else
    {
        [self submit];
    }

}

- (IBAction)tijiaoBtn:(id)sender
{
    
}


@end
