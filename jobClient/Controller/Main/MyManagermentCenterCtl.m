//
//  MyManagermentCenterCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/10.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyManagermentCenterCtl.h"
#import "MyCollectionCell.h"
#import "ConsultantCenterCtl.h"
#import "MyAttentionCenterCtl.h"
#import "SysTemSetCtl.h"
#import "OwnGroupListCtl.h"
#import "PersonQRCodeCtl.h"
#import "CHRIndexCtl.h"
#import "HRLoginCtl.h"
#import "RecommendYLCtl.h"
#import "GiveAdviceCtl.h"
#import "MyFavoriteCenterCtl.h"
#import "YLMoreAppCtl.h"
#import "ELMyAccountCtl.h"
#import "ELMyAspectantDiscussCtl.h"
#import "ELMyAcrivityCenterCtl.h"
#import "ELRealNameAuthenticationCtl.h"
#import "SupplementaryView.h"
#import "NSString+URLEncoding.h"
#import "AlbumListCtl.h"
#import "CustomActionSheetCtl.h"
#import "TransparencyView.h"
#import "RecordViewCtl.h"
#import "ASIHTTPRequest.h"
#import "MyDelegateCtl.h"
#import "ELRealNameAuthenticationPrivilegeCtl.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "EditorBasePersonInfoCtl.h"
#import "MyResumeController.h"
#import "ExpertPublishCtl.h"

#import "ELOAWebCtl.h"
#import "AD_dataModal.h"

@interface MyManagermentCenterCtl ()<UICollectionViewDataSource,UICollectionViewDelegate,NoLoginDelegate,EditorBasePersonInfoCtlDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,/*PhotoSelectCtlDelegate,*/RecordViewCtlDelegate,UIAlertViewDelegate,LogoPhotoSelectCtlDelegate>
{
    NSMutableArray *titleMArr;
    NSMutableArray *imageMArr;
    RequestCon  *bindComCon_;
    RequestCon  *personInfoCon1;
    PersonCenterDataModel *personModel;
    ELRequest *elRequest;
    NSString *realNameStatusCode;
    RequestCon *uploadMyImgCon_;
    UIView  *actionSheetView;
    UIImageView *fullImageView;
    CGRect  frame_first;
    TransparencyView *transparency_;
    RecordViewCtl *recordCtl_;
    ASINetworkQueue             *queue;
    UIView *topView;
    AD_dataModal   *adModal;
    RequestCon  *adCon;
}
@property(nonatomic,copy)NSString * moreRedMark;
@end

@implementation MyManagermentCenterCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = NO;
    [self setUpCollection];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
}

-(void)viewDidLayoutSubviews{

    [self.view layoutSubviews];//iOS7上不加这句可能奔溃
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self setFd_prefersNavigationBarHidden:YES];
    [self realNameState];
    [self refreshLoad:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:YES];
    [super viewWillDisappear:animated];
    
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    NSLog(@"当前毫秒级时间6 = %@",[dateFormatter stringFromDate:[NSDate date]]);
}

- (void)getDataFunction:(RequestCon *)con
{
    if (![Manager shareMgr].haveLogin) {
        return;
    }
    if (!personInfoCon1) {
        personInfoCon1 = [self getNewRequestCon:NO];
    }
    [personInfoCon1 getPersonCenter1:[Manager getUserInfo].userId_ loginPersonId:[Manager getUserInfo].userId_];
    
    //原更多应用请求 2017-1-7
    if (!adCon) {
        adCon = [self getNewRequestCon:NO];
    }
    [adCon getApplicationList:[Manager getUserInfo].userId_ page:requestCon_.pageInfo_.currentPage_ pageSize:15 phoneType:1];
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if ([Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ != nil) {
        //语音存在
        SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
        
        [view.voicePlayView_ setHidden:NO];
        [view.voiceBtn_ setHidden:YES];
        [view.voiceTimeLb_ setText:[NSString stringWithFormat:@"%@\"",[Manager shareMgr].userCenterModel.voiceModel_.duration_]];
    }else{
        SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
        [view.voicePlayView_ setHidden:YES];
        [view.voiceBtn_ setHidden:NO];
#pragma mark - 设置为录制语音
//        [view.voiceBtn_ setImage:[UIImage imageNamed:@"wo_novoice.png"] forState:UIControlStateNormal];
    }
}

/*
//自定义遮罩
-(void)customActionSheet
{
    if (!actionSheetView) {
        actionSheetView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIView *maskView = [[UIView alloc] initWithFrame:actionSheetView.frame];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.tag = 100;
        [actionSheetView addSubview:maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSender:)];
        [maskView addGestureRecognizer:tap];
        CustomActionSheetCtl *ctl = [[CustomActionSheetCtl alloc] init];
        [ctl.view setFrame:CGRectMake(0, actionSheetView.frame.origin.y+actionSheetView.frame.size.height, actionSheetView.frame.size.width, 185)];
        ctl.view.tag = 200;
        
        [ctl.btn1 addTarget:self action:@selector(actionSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [ctl.btn2 addTarget:self action:@selector(actionSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [ctl.btn3 addTarget:self action:@selector(actionSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [ctl.btn4 addTarget:self action:@selector(actionSheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        ctl.btn1.tag = 2000;
        ctl.btn2.tag = 3000;
        ctl.btn3.tag = 4000;
        ctl.btn4.tag = 5000;
        [actionSheetView addSubview:ctl.view];
    }
    UIView *mask = [actionSheetView viewWithTag:100];
    mask.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        mask.alpha = 0.5;
        UIView *optionView = [actionSheetView viewWithTag:200];
        CGRect frame = optionView.frame;
        frame.origin.y -= 185;
        optionView.frame = frame;
    }];
    [self.navigationController.view.window addSubview:actionSheetView];
    
}

 
-(void)actionSheetBtnClick:(UIButton *)btn
{
    if (btn.tag == 2000) {
        
        //点击变大
        SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
        frame_first = view.photoBtn.frame;
        fullImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        fullImageView.backgroundColor = [UIColor blackColor];
        fullImageView.userInteractionEnabled = YES;
        [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
        fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (![fullImageView superview]) {
            fullImageView.image = view.personPhotoImage.image;
            [self.view.window addSubview:fullImageView];
            fullImageView.frame = frame_first;
            fullImageView.layer.cornerRadius = 65/2;
            fullImageView.layer.masksToBounds = YES;
            [UIView animateWithDuration:0.3 animations:^{
                fullImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                fullImageView.layer.cornerRadius = 0;
            } completion:^(BOOL finished) {
            }];
        }
        
        [self tapSender:nil];
        return;
    }
    
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (btn.tag) {
            case 3000:
                // 相机
                BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                if (!accessStatus) {
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 4000:
                // 相册 sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            {
                AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                albumListCtl.maxCount = 1;
                albumListCtl.logoDelegate = self;
                albumListCtl.isOnlyOneSel = YES;
                albumListCtl.imageType = 1;
                albumListCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:albumListCtl animated:YES];
                [albumListCtl beginLoad:nil exParam:nil];
                [self tapSender:nil];
                return;
            }
                break;
            case 5000:
                // 取消
                [self tapSender:nil];
                return;
        }
    }
    else {
        [self tapSender:nil];
        return;
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:NO completion:nil];
    
    [self tapSender:nil];
}
*/

-(void)actionTap2:(UITapGestureRecognizer *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        fullImageView.frame = frame_first;
        fullImageView.layer.cornerRadius = 65/2;
        fullImageView.layer.masksToBounds = YES;
    } completion:^(BOOL finished) {
        [fullImageView removeFromSuperview];
    }];
}

/*
-(void)tapSender:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        UIView *mask = actionSheetView.subviews[0];
        mask.alpha = 0.0;
        UIView *optionView = actionSheetView.subviews[1];
        CGRect frame = optionView.frame;
        frame.origin.y += 185;
        optionView.frame = frame;
    } completion:^(BOOL finished) {
        [actionSheetView removeFromSuperview];
    }];
    
}
 */

-(void)addHeaderPhotoImage
{
//    [self customActionSheet];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看头像大图", @"拍照换头像", @"从相册选择新头像", nil];
    [actionSheet showInView:self.view];
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //点击变大
            SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
            frame_first = view.photoBtn.frame;
            fullImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            fullImageView.backgroundColor = [UIColor blackColor];
            fullImageView.userInteractionEnabled = YES;
            [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
            fullImageView.contentMode = UIViewContentModeScaleAspectFit;
            if (![fullImageView superview]) {
                fullImageView.image = view.personPhotoImage.image;
                [self.view.window addSubview:fullImageView];
                fullImageView.frame = frame_first;
                fullImageView.layer.cornerRadius = 65/2;
                fullImageView.layer.masksToBounds = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    fullImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    fullImageView.layer.cornerRadius = 0;
                } completion:^(BOOL finished) {
                }];
            }
            return;

        }
            break;
        case 1:
        case 2:
        {
            NSUInteger sourceType = 0;
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                if (buttonIndex == 1) {
                    // 相机
                    BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                    if (!accessStatus) {
                        return;
                    }
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                else {
                        AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                        albumListCtl.maxCount = 1;
                        albumListCtl.logoDelegate = self;
                        albumListCtl.isOnlyOneSel = YES;
                        albumListCtl.imageType = 1;
                        albumListCtl.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:albumListCtl animated:YES];
                        [albumListCtl beginLoad:nil exParam:nil];
                        return;
                }
            }
            
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:NO completion:nil];
        }
            break;
        default:
            break;
    }
}

#if 0
#pragma mark--照片选取完成
//暂时用不上
- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    if (imageArr.count > 0)
    {
        @try {
            //base64编码上传头像
            UIImage *uploadImage = imageArr[0];
            NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.01);
            
            NSString *base64String = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] URLEncodedForString];
            
            if (!uploadMyImgCon_) {
                uploadMyImgCon_ = [self getNewRequestCon:NO];
            }
            [uploadMyImgCon_ uploadMyImg:[Manager getUserInfo].userId_ uname:[Manager getUserInfo].name_ imgStr:base64String];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    }
}
#endif

#pragma mark--照片选取完成
- (void)hadFinishSelectPhoto:(NSArray *)imageArr{
    if (imageArr.count > 0)
    {
        @try {
            //base64编码上传头像
            UIImage *uploadImage = imageArr[0];
            NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.01);
            
            NSString *base64String = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] URLEncodedForString];
            
            if (!uploadMyImgCon_) {
                uploadMyImgCon_ = [self getNewRequestCon:NO];
            }
            [uploadMyImgCon_ uploadMyImg:[Manager getUserInfo].userId_ uname:[Manager getUserInfo].name_ imgStr:base64String];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try {
        [picker dismissViewControllerAnimated:YES completion:nil];
        //base64编码上传头像
        UIImage *uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.01);
        
        NSString *base64String = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]URLEncodedForString];;
        
        if (!uploadMyImgCon_) {
            uploadMyImgCon_ = [self getNewRequestCon:NO];
        }
        [uploadMyImgCon_ uploadMyImg:[Manager getUserInfo].userId_ uname:[Manager getUserInfo].name_ imgStr:base64String];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)refreshTableView
{
    SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
    [view changFrame];
    [myConllection reloadData];
}

-(void)setUpCollection{
    titleMArr = [[NSMutableArray alloc] initWithObjects:@"我的简历",@"我的招聘",@"我的委托",@"我的发表",@"我的社群",@"我的问答",@"我的收藏",@"我的关注",@"我的账户",@"我的约谈",@"我的活动",@"实名认证",@"推荐给好友",@"意见反馈",@"我的OA", nil];
    //@"设置",@"ios_icon_15sz.png"
    imageMArr = [[NSMutableArray alloc] initWithObjects:@"my_icon1.png",@"my_icon2.png",@"my_icon3.png",@"my_icon4.png",@"my_icon5.png",@"my_icon6.png",@"my_icon7.png",@"my_icon8.png",@"my_icon9.png",@"my_icon10.png",@"my_icon11.png",@"my_icon12.png",@"share_green",@"my_icon14.png",@"oa.png", nil];
    [myConllection registerNib:[UINib nibWithNibName:@"MyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionCell"];
    //注册headerView Nib的view需要继承UICollectionReusableView
    [myConllection registerNib:[UINib nibWithNibName:@"SupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SupplementaryView"];

    for (int i=0; i<2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3*(i+1), 238 , 1, ScreenWidth/3*0.8*5)];
        view.backgroundColor = UIColorFromRGB(0xecedec);
        
        [myConllection addSubview:view];
    }

    for (int j=0; j<5; j++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,(j+1)*ScreenWidth/3*0.8+238, ScreenWidth, 1)];
        view.backgroundColor = UIColorFromRGB(0xecedec);
        
        [myConllection addSubview:view];
    }

    myConllection.delegate = self;
    myConllection.dataSource = self;
}

-(void)btnResponse:(id)sender
{
    SupplementaryView *sview = (SupplementaryView *)[self.view viewWithTag:1000];
    if (sender == sview.voicePlayBtn_) {
        if (!transparency_) {
            transparency_ = [[TransparencyView alloc]init];
        }
        if (!recordCtl_) {
            recordCtl_ = [[RecordViewCtl alloc]init];
        }
        recordCtl_.type = @"2";    //2表示个人中心   1表示简历中心
        recordCtl_.delegate_ = self;
        [recordCtl_ beginLoad:[Manager shareMgr].userCenterModel.voiceModel_ exParam:nil];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:recordCtl_.view];
        [recordCtl_ playVoiceWhenViewShow];  //有语音自动播放语音
    }
    else if(sender == sview.voiceBtn_)
    {
        if (!transparency_) {
            transparency_ = [[TransparencyView alloc]init];
        }
        if (!recordCtl_) {
            recordCtl_ = [[RecordViewCtl alloc]init];
        }
        recordCtl_.type = @"2";
        recordCtl_.delegate_ = self;
        [recordCtl_ beginLoad:[Manager shareMgr].userCenterModel.voiceModel_ exParam:nil];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:recordCtl_.view];
        [recordCtl_ playVoiceWhenViewShow];  //有语音自动播放语音
    }
}

- (void)updateView:(VoiceFileDataModel *)fileModel
{
    [Manager shareMgr].userCenterModel.voiceModel_ = fileModel;
    [self updateCom:nil];
}


- (void)toLoadVoice
{
    //下载语音
    if ([Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ != nil) {
        
        //如果是amr后缀，将地址修改
        NSString *houzuiStr = [[[Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ componentsSeparatedByString:@"."] lastObject];
        if ([houzuiStr isEqualToString:@"amr"]) {
            [Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ = [[Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ stringByReplacingOccurrencesOfString:@"audio" withString:@"audio_acc"];
            [Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ = [[Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_ stringByReplacingOccurrencesOfString:@"amr" withString:@"aac"];
        }
        [self loadVoice];
    }
}


- (void)loadVoice
{
    queue = [[ASINetworkQueue alloc]init];
    [queue setShowAccurateProgress:YES];
    [queue setShouldCancelAllRequestsOnFailure:NO];
    queue.delegate = self;
    [queue setQueueDidFinishSelector:@selector(finishOver:)];
    BOOL mark = NO;
    NSString *fileName = [[[Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_  componentsSeparatedByString:@"/"]lastObject];
    NSString *fileNameNoAmr = [[fileName componentsSeparatedByString:@"."]objectAtIndex:0];
    NSString *filePath = [VoiceRecorderBaseVC getPathByFileName:fileNameNoAmr ofType:@"aac"];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:filePath]) {
        //文件不存在
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[Manager shareMgr].userCenterModel.voiceModel_.serverFilePath_]];
        [request setDownloadDestinationPath:filePath];
        [queue addOperation:request];
        mark = YES;
    }
    [Manager shareMgr].userCenterModel.voiceModel_.wavPath_ = filePath;
    if (mark){
        [queue go];
    }else{
        [self finishOver:nil];
    }
}

- (void)finishOver:(ASINetworkQueue*)queue1 {
    
    
}

#pragma mark - RecordViewCtlDelegate
- (void)removeView
{
    [transparency_ removeFromSuperview];
}

- (void)bianzBtnClick:(UIButton *)btn
{
    if (![Manager shareMgr].userCenterModel)
    {
        return;
    }
    EditorBasePersonInfoCtl *editorCtl = [[EditorBasePersonInfoCtl alloc] init];
    editorCtl.delegate = self;
    [editorCtl beginLoad:[Manager shareMgr].userCenterModel exParam:nil];
    editorCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editorCtl animated:YES];
    
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"编辑资料",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

- (void)edtorBaseSuccess
{
    SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
    [view changFrame];
}

#pragma mark --UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([titleMArr count]!=0) {
        return  [titleMArr count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake(106*ScreenWidth/320, 84*ScreenWidth/320);
    return CGSizeMake((self.view.frame.size.width)/3.0, (self.view.frame.size.width)/3*0.8);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"SupplementaryView" forIndexPath:indexPath];
    view.tag = 1000;
    SupplementaryView *sview = (SupplementaryView *)view;
    [sview.bianzBtn addTarget:self action:@selector(bianzBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [sview.voicePlayBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sview.voiceBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sview.photoBtn addTarget:self action:@selector(addHeaderPhotoImage) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

//返回头headerView的大小`
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.view.frame.size.width,238};
    return size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCellID = @"MyCollectionCell";
    
    MyCollectionCell *cell = (MyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = bgView;
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe0e0e0);
    
    cell.messageCountLb.clipsToBounds = YES;
    cell.messageCountLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"info_01"]];
    cell.messageCountLb.layer.cornerRadius = 10.0;
//    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    NSString *titleStr = titleMArr[indexPath.row];
    NSString *imageStr = imageMArr[indexPath.row];
    
    if ([titleStr isEqualToString:@"设置"]) {
        cell.imagev.hidden = YES;
        cell.titleLb.hidden = YES;
    }
    else
    {
        cell.imagev.hidden = NO;
        cell.titleLb.hidden = NO;
    }
    
    UIImage  *image = [UIImage imageNamed:imageStr];
    cell.imagev.image = image;
    cell.titleLb.text = titleStr;
    
    if ([titleStr isEqualToString:@"实名认证"] && [Manager shareMgr].haveLogin)
    {
        cell.realNameImage.hidden = NO;
        if ([realNameStatusCode isEqualToString:@"200"])//已认证
        {
            cell.realNameImage.image = [UIImage imageNamed:@"menu_is certification"];
        }
        else if ([realNameStatusCode isEqualToString:@"600"])//审核中
        {
            cell.realNameImage.image = [UIImage imageNamed:@"menu_in certification"];
        }
        else if ([realNameStatusCode isEqualToString:@"500"])//未通过
        {
            cell.realNameImage.image = [UIImage imageNamed:@"menu_off _line_certification"];
        }
        else
        {
           cell.realNameImage.image = [UIImage imageNamed:@"menu_no certification"];
        }
    }
    else
    {
        cell.realNameImage.hidden = YES;
    }
    
    cell.messageCountLb.hidden = YES;
    cell.redImg.hidden = YES;
    
    if ([Manager shareMgr].haveLogin)
    {
        if ([titleStr isEqualToString:@"我的简历"] && [Manager shareMgr].messageCountDataModal.resumeCnt > 0)
        {
            [cell.messageCountLb setHidden:NO];
            [cell.messageCountLb setText:[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.resumeCnt]];
        }
        if ([titleStr isEqualToString:@"我的招聘"] && [Manager shareMgr].messageCountDataModal.companyCnt > 0) {
            [cell.messageCountLb setHidden:NO];
            [cell.messageCountLb setText:[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.companyCnt]];
        }
        if ([titleStr isEqualToString:@"我的问答"] && [Manager shareMgr].messageCountDataModal.questionCnt > 0) {
            [cell.messageCountLb setHidden:NO];
            [cell.messageCountLb setText:[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.questionCnt]];
        }
        if ([titleStr isEqualToString:@"我的约谈"] && [Manager shareMgr].messageCountDataModal.myInterViewCnt > 0) {
            [cell.messageCountLb setHidden:NO];
            [cell.messageCountLb setText:[NSString stringWithFormat:@"%ld",(long)[Manager shareMgr].messageCountDataModal.myInterViewCnt]];
        }
        
        if ([titleStr isEqualToString:@"我的OA"]){
            NSInteger allNum = [Manager shareMgr].messageCountDataModal.resumeCnt + [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt;
            if (allNum == 0) {
                if(_moreRedMark.length > 0 && ![_moreRedMark isEqualToString:@""]){
                    NSInteger redNumLast = [_moreRedMark integerValue];
                    [Manager shareMgr].messageCountDataModal.oaMsgCount = redNumLast;
                   cell.redImg.hidden = NO;
                }
                else if((_moreRedMark.length == 0 && [_moreRedMark isEqualToString:@""])){
                    if (([Manager shareMgr].messageCountDataModal.oaMsgCount > 0)) {
                        [Manager shareMgr].messageCountDataModal.oaMsgCount = 0;
                    }
                    cell.redImg.hidden = YES;
                }
                else{
                    if (([Manager shareMgr].messageCountDataModal.oaMsgCount > 0)) {
                        cell.redImg.hidden = NO;
                    }
                    else{
                        cell.redImg.hidden = YES;
                    }
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
            }
            
        }
    }
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [Manager shareMgr].isNeedRefresh = NO;
    switch (indexPath.row) {
        case 0:
        {
            if ([Manager shareMgr].haveLogin) {
                MyResumeController *myResumeVC = [[MyResumeController alloc]init];
                myResumeVC.hidesBottomBarWhenPushed = YES;
                myResumeVC.isMyResumePop = YES;
                [self.navigationController pushViewController:myResumeVC animated:YES];
                [myResumeVC beginLoad:nil exParam:nil];
            }
            else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
            
            //红点处理
            [Manager shareMgr].messageCountDataModal.resumeCnt = 0;
            NSInteger allNum = [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.resumeCnt;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
            [myConllection reloadData];
        }
            break;
        case 1:
        {
            if ([Manager shareMgr].haveLogin) {
                [Manager shareMgr].registeType_ = FromCompany;
                if(!bindComCon_)
                {
                    bindComCon_ = [self getNewRequestCon:NO];
                }
                [bindComCon_ bingdingStatusWith:[Manager getUserInfo].userId_];
                
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 2: //我的委托
        {
            if (![Manager shareMgr].haveLogin) {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
                return;
            }
            MyDelegateCtl *delegateCtl = [[MyDelegateCtl alloc]init];
            delegateCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:delegateCtl animated:YES];
            [delegateCtl beginLoad:nil exParam:nil];
            
        }
            break;
        case 3: //我的发表
        {
            if ([Manager shareMgr].haveLogin) {
                ExpertPublishCtl *ctl = [[ExpertPublishCtl alloc]init];
                [ctl setIsMyCenter:YES];
                [ctl beginLoad:[Manager getUserInfo] exParam:nil];
                ctl.hidesBottomBarWhenPushed = YES;
                ctl.stateType = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 4: //我的社群
        {
            if ([Manager shareMgr].haveLogin)
            {
                OwnGroupListCtl *ownGroupList = [[OwnGroupListCtl alloc]init];
                [ownGroupList beginLoad:nil exParam:nil];
                ownGroupList.hidesBottomBarWhenPushed = YES;
                ownGroupList.stateType = YES;
                [self.navigationController pushViewController:ownGroupList animated:YES];
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 5: //我的问答
        {
            if ([Manager shareMgr].haveLogin)
            {
                MyAQListCtl *myAQList = [[MyAQListCtl alloc] init];
                myAQList.type_ = 1;
                [myAQList beginLoad:[Manager getUserInfo].userId_ exParam:nil];
                myAQList.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myAQList animated:YES];
            }
            else
            {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;                                
            }
            //红点处理
            [Manager shareMgr].messageCountDataModal.questionCnt = 0;
            NSInteger allNum = [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.resumeCnt;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
            [myConllection reloadData];
        }
            break;
        case 6: //我的收藏
        {
            if ([Manager shareMgr].haveLogin) {
                MyFavoriteCenterCtl *favoriteCenterClt = [[MyFavoriteCenterCtl alloc] init];
                [favoriteCenterClt beginLoad:nil exParam:nil];
                favoriteCenterClt.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:favoriteCenterClt animated:YES];
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 7: //我的关注
        {
            if ([Manager shareMgr].haveLogin) {
                MyAttentionCenterCtl *listCtl = [[MyAttentionCenterCtl alloc]init];
                [listCtl beginLoad:@"1" exParam:nil];  //关注列表（包括公司学校）
                listCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listCtl animated:YES];
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 8: //我的账户
        {
            if ([Manager shareMgr].haveLogin) {
                ELMyAccountCtl *myAccountCtl = [[ELMyAccountCtl alloc]init];
                [myAccountCtl beginLoad:nil exParam:nil];
                myAccountCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myAccountCtl animated:YES];
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 9: //我的约谈
        {
            if ([Manager shareMgr].haveLogin) {
                [Manager shareMgr].yuetanListBackCtl = self;
                ELMyAspectantDiscussCtl *aspectantDisCtl = [[ELMyAspectantDiscussCtl alloc] init];
                [aspectantDisCtl beginLoad:[Manager getUserInfo].userId_ exParam:nil];
                aspectantDisCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aspectantDisCtl animated:YES];
            }else{
                [Manager shareMgr].yuetanListBackCtl = self;
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
            
            //红点处理
            [Manager shareMgr].messageCountDataModal.myInterViewCnt = 0;
            NSInteger allNum = [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.resumeCnt;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
            [myConllection reloadData];
        }
            break;
        case 10://我的活动
        {
            if(![Manager shareMgr].haveLogin)
            {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
                return;
            }
            ELMyAcrivityCenterCtl *ctl = [[ELMyAcrivityCenterCtl alloc] init];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 11://实名认证
        {
            if ([Manager shareMgr].haveLogin) {
                ELRealNameAuthenticationPrivilegeCtl *ctl = [[ELRealNameAuthenticationPrivilegeCtl alloc] init];
                ctl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }
            else
            {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }
        }
            break;
        case 12: //推荐给好友
        {
            RecommendYLCtl * recommendYLCtl = [[RecommendYLCtl alloc] init];
            recommendYLCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recommendYLCtl animated:YES];
            [recommendYLCtl beginLoad:nil exParam:nil];
        }
            break;
        case 13: //意见反馈
        {
            if (![Manager shareMgr].haveLogin) {
                GiveAdviceCtl *giveAdviceCtl = [[GiveAdviceCtl alloc] init];
                giveAdviceCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:giveAdviceCtl animated:YES];
                [giveAdviceCtl beginLoad:nil exParam:nil];
            }else{
                MessageContact_DataModel * dataModal = [[MessageContact_DataModel alloc] init];
                dataModal.userId = @"15476338";
                dataModal.isExpert = @"1";
                dataModal.userIname = @"一览小助手";
                dataModal.pic = @"http://img105.job1001.com/myUpload2/201503/10/1425978515_391.gif";
               dataModal.gzNum = @"10.0";
                dataModal.userZW = @"产品经理";
                dataModal.age = @"10";
                dataModal.sameCity = @"1";
                dataModal.sex = @"女";
                MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
                ctl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ctl animated:YES];
                [ctl beginLoad:dataModal exParam:nil];

            }
        }
            break;
        
        case 14: //更多应用
        {
//            __weak typeof(self) weakSelf = self;
//            YLMoreAppCtl *moreAppCtl = [[YLMoreAppCtl alloc] init];
//            moreAppCtl.hidesBottomBarWhenPushed = YES;
//            moreAppCtl.MyBlock = ^(NSString *redNumMark){
//                weakSelf.moreRedMark = redNumMark;
//                [myConllection reloadData];
//            };
//            [self.navigationController pushViewController:moreAppCtl animated:YES];
//            [moreAppCtl beginLoad:[Manager getUserInfo].userId_ exParam:nil];
            
            if ([Manager shareMgr].haveLogin) {
                WS(weakSelf)
                ELOAWebCtl *oaWebCtl = [[ELOAWebCtl alloc] init];
                oaWebCtl.myBlock = ^(BOOL isRefresh){
                    weakSelf.moreRedMark = 0;
                    [Manager shareMgr].messageCountDataModal.oaMsgCount = 0;
                    [myConllection reloadData];
                };
                oaWebCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:oaWebCtl animated:YES];
                [oaWebCtl beginLoad:adModal exParam:nil];
                
            }else{
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl  getNoLoginManager].loginType = LoginType_MyPersonCenter;
                [NoLoginPromptCtl  getNoLoginManager].indexPath = indexPath;
            }

        }
            break;
        case 15: //设置
        {
            
        }
            break;
        
        default:
            break;
    }
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",titleMArr[indexPath.row],NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetPersonCenter1:
        {
            [Manager shareMgr].userCenterModel = [dataArr objectAtIndex:0];
            [self loadVoice];
            SupplementaryView *view = (SupplementaryView *)[self.view viewWithTag:1000];
            [view changFrame];
        }
            break;
        case Request_isExpert:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [Manager getUserInfo].isExpert_ = YES;
            }else{
                [Manager getUserInfo].isExpert_ = NO;
            }
        }
            break;
        case Request_GetMessageCtn:
        {
            [Manager shareMgr].messageCountDataModal = [dataArr objectAtIndex:0];
        }
            break;
        case Request_UploadMyImg:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [Manager getUserInfo].imageData_ = nil;
                [Manager getUserInfo].img_ = dataModal.exObj_;
                [self refreshTableView];
                //上传成功写入数据库
                [CommonConfig setDBValueByKey:Config_Key_UserImg value:[Manager getUserInfo].img_];
                [BaseUIViewController showAutoDismissSucessView:@"上传成功" msg:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:nil];
            }
        }
            break;
        case requestBingdingStatusWith:
        {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            //企业HR
            if ([dataArr count] != 0) {
                if ([dataArr[0] isKindOfClass:[CompanyInfo_DataModal class]])
                {
                    CompanyInfo_DataModal *model = dataArr[0];
                    CHRIndexCtl * chrIndexCtl = [[CHRIndexCtl alloc] init];
                    chrIndexCtl.companyId =  model.companyID_;
                    
                    //synergy_id 返回为0 所以将判断条件改为 >1
                    if (model.synergy_id && model.synergy_id.length > 1) {
                        chrIndexCtl.synergy_id = model.synergy_id;
                        [CommonConfig setDBValueByKey:@"synergy_id" value:model.synergy_id];
                    }else{
                         [CommonConfig setDBValueByKey:@"synergy_id" value:@""];
                    }
                    chrIndexCtl.hidesBottomBarWhenPushed = YES;
                    if (self.navigationController) {
                        [self.navigationController pushViewController:chrIndexCtl animated:YES];
                    }else{
                        [[Manager shareMgr].centerNav_ pushViewController:chrIndexCtl animated:YES];
                    }
                    
                    [chrIndexCtl beginLoad:model.companyID_ exParam:nil];
                    
                }
                else if ([dataArr[0] isKindOfClass:[ConsultantHRDataModel class]])
                {//顾问
                    ConsultantHRDataModel *model = dataArr[0];
                    [Manager setHrInfo:model];
                    ConsultantCenterCtl *consultantCtl = [[ConsultantCenterCtl alloc] init];
                    if ([Manager shareMgr].isFromMessage_) {
//                        [[Manager shareMgr] tabViewModalChanged:[Manager shareMgr].tabView_ type:Tab_Third];
                    }
                    consultantCtl.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:consultantCtl animated:YES];
                    [consultantCtl beginLoad:model exParam:nil];
                }
                if ([Manager shareMgr].haveLogin) {
                    [[Manager shareMgr].messageRefreshCtl requestCount];
                }
            }
            else
            {
                HRLoginCtl * hrLoginCtl = [[HRLoginCtl alloc] init];
                hrLoginCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:hrLoginCtl animated:YES];
                [hrLoginCtl beginLoad:nil exParam:nil];
            }
            //红点处理
            [Manager shareMgr].messageCountDataModal.companyCnt = 0;
            NSInteger allNum = [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.resumeCnt;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
            [myConllection reloadData];
        }
            break;
        case Request_GetBindingCompany:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                NSString * companyId = dataModal.exObj_;
                CHRIndexCtl * chrIndexCtl = [[CHRIndexCtl alloc] init];
                chrIndexCtl.companyId =  companyId;
                if ([Manager shareMgr].isFromMessage_) {
//                    [[Manager shareMgr] tabViewModalChanged:[Manager shareMgr].tabView_ type:Tab_Third];
                }
                chrIndexCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chrIndexCtl animated:YES];
                [chrIndexCtl beginLoad:companyId exParam:nil];
            }
            else
            {
                HRLoginCtl * hrLoginCtl = [[HRLoginCtl alloc] init];
                if ([Manager shareMgr].isFromMessage_) {
//                    [[Manager shareMgr] tabViewModalChanged:[Manager shareMgr].tabView_ type:Tab_Third];
                }
                hrLoginCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:hrLoginCtl animated:YES];
                [hrLoginCtl beginLoad:nil exParam:nil];
            }
        }
            break;
        case Request_GetApplicationList:
        {
            adModal = [[AD_dataModal alloc] init];
            adModal = dataArr[0];
        }
            break;
        default:
            break;
    }
}

- (void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
}

#pragma mark - NoLoginDelegate
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_MyPersonCenter:
        {
            NSIndexPath *index = [NoLoginPromptCtl getNoLoginManager].indexPath;
            if (index.row < titleMArr.count) {
                [self collectionView:myConllection didSelectItemAtIndexPath:index];
            }        
        }
            break;
        default:
            break;
    }
}

-(void)jumpToCompany
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    [Manager shareMgr].registeType_ = FromCompany;
    
    if(!bindComCon_)
    {
        bindComCon_ = [self getNewRequestCon:NO];
    }
    [bindComCon_ bingdingStatusWith:[Manager getUserInfo].userId_];
}

-(void)realNameState
{
    if (![Manager shareMgr].haveLogin)
    {
        return;
    }
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"get_shiming_info" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         realNameStatusCode = dic[@"code"];
         [myConllection reloadData];
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!topView) {
        topView = [[UIView alloc] init];
    }
    if (scrollView.contentOffset.y < 0) {
        topView.frame = CGRectMake(0, 0, ScreenWidth, fabs(scrollView.contentOffset.y));
    }else{
        topView.frame = CGRectZero;
    }
    
    topView.backgroundColor = UIColorFromRGB(0xEF4646);
    [self.view addSubview:topView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"22222");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
