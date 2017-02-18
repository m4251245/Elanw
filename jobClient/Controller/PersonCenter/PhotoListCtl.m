//
//  PhotoListCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "PhotoListCtl.h"
#import "MJPhoto.h"
#import "NoLoginPromptCtl.h"
#import "UIImage+FixOrientation.h"
#import "AlbumListCtl.h"
#import "UIButton+WebCache.h"

@interface PhotoListCtl () <NoLoginDelegate,PhotoSelectCtlDelegate
,MJPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    PersonCenterDataModel   *inModel_;
    MJPhotoBrowser          *photoBrowser_;
    NSString                *deleteIndex;
    NSMutableArray          *imgViewArray_;
    NSMutableArray          *imgButtonArray_;
    UIImage                 *uploadImage;       //相册选择的img
    RequestCon              *sendMessageCon_;
    NSInteger indexOne;
    NSString *imagePath;
    NSMutableArray *tempArr;
    RequestCon *deleteCon_;
    NSString   *inPhoto_;
}

@end

@implementation PhotoListCtl


-(instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        imgButtonArray_ = [[NSMutableArray alloc]init];
        
        CGFloat width = (ScreenWidth-38)/4.0;
        
        for (int i=0; i<2; i++) {
            for (int k=0; k<4; k++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor clearColor]];
                [button addTarget:self action:@selector(imgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [button setTag:100+i*4+k];
                button.layer.cornerRadius = 5.0;
                button.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
                button.layer.borderWidth = 0.5;
                button.layer.masksToBounds = YES;
                [button setFrame:CGRectMake(10+(width+6)*k, 15+(width+6)*i, width, width)];
                button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [imgButtonArray_ addObject:button];
                [self addSubview:button];
            }
        }
        
        UIView *updateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [updateView setTag:5000];
        updateView.layer.cornerRadius = 5.0;
        updateView.layer.masksToBounds = YES;
        [updateView setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0]];
        
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(31/2, 35/2-10, 39, 35)];
        [imgv setImage:[UIImage imageNamed:@"camera.png"]];
        imgv.center = CGPointMake(width/2, (width/2)-5);
        [updateView addSubview:imgv];
        
        UILabel *tipsLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, width, 20)];
        [tipsLb setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
        [tipsLb setTextColor:UIColorFromRGB(0xe13e3e)];
        [tipsLb setTextAlignment:NSTextAlignmentCenter];
        [tipsLb setTag:4003];
        tipsLb.center = CGPointMake(width/2, (width/2)+25);
        [updateView addSubview:tipsLb];
        
        UIButton *updateImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [updateImgBtn setFrame:CGRectMake(0, 0, width, width)];
        [updateImgBtn addTarget:self action:@selector(updateImgBtn:)forControlEvents:UIControlEventTouchUpInside];
        [updateView addSubview:updateImgBtn];
        
        [self addSubview:updateView];
    }
    return self;
}

- (void)updateImgBtn:(UIButton *)button
{
    if (_isMyCenter) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现在拍摄",@"选取相册图片", nil];
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        actionSheet.tag = 2000;
    }else{
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return;
        }
        
        if (!sendMessageCon_) {
            sendMessageCon_ = [self getNewRequestCon];
        }
        [sendMessageCon_ sendMessage:[Manager getUserInfo].userId_ type:@"501" inviteId:inModel_.userModel_.id_];
    }
}


#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (actionSheet.tag == 2000) {
            switch (buttonIndex) {
                case 0:
                {    // 相机
                    BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                    if (!accessStatus) {
                        return;
                    }
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                    break;
                case 1:
                {
                    AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                    albumListCtl.maxCount = 8- [inModel_.photoListArray_ count];
                    albumListCtl.delegate = self;
                    [self.delegate_ showPicker:albumListCtl];
                    [albumListCtl beginLoad:nil exParam:nil];
                    return;
                }
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    [self.delegate_ showPicker:imagePickerController];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SendMessage:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.code_ isEqualToString:@"200"]) {
                [_delegate_ inviteUpdateImageSuccess];
                [BaseUIViewController showAutoDismissSucessView:@"邀请成功" msg:nil seconds:0.5];
            }else if([model.code_ isEqualToString:@"4"]){
                [BaseUIViewController showAutoDismissFailView:@"今天已经邀请过!" msg:nil seconds:0.5];
            }
        }
            break;
        case Request_UploadPhotoFile:
        {
            SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
            //photo_info
            Upload_DataModal *model = [dataArr objectAtIndex:0];
            
            NSMutableDictionary * photoInfoDic = [[NSMutableDictionary alloc] init];
            [photoInfoDic setObject:model.name_ forKey:@"name"];
            [photoInfoDic setObject:model.size_ forKey:@"size"];
            [photoInfoDic setObject:model.exe_ forKey:@"exe"];
            [photoInfoDic setObject:model.path_ forKey:@"path"];
            for (Upload_DataModal *dataModel in model.pathArr_) {
                if ([dataModel.size_ isEqualToString:@"960"]) {
                    [photoInfoDic setObject:dataModel.path_ forKey:@"path_960"];
                }else if ([dataModel.size_ isEqualToString:@"670"]){
                    [photoInfoDic setObject:dataModel.path_ forKey:@"path_670"];
                }else if ([dataModel.size_ isEqualToString:@"220"]){
                    [photoInfoDic setObject:dataModel.path_ forKey:@"path_220"];
                }else if ([dataModel.size_ isEqualToString:@"140"]){
                    [photoInfoDic setObject:dataModel.path_ forKey:@"path_140"];
                    imagePath = dataModel.path_;
                }else if ([dataModel.size_ isEqualToString:@"80"]){
                    [photoInfoDic setObject:dataModel.path_ forKey:@"path_80"];
                }
            }
            NSString * photoInfoStr = [jsonWriter stringWithObject:photoInfoDic];
            
            NSMutableDictionary * conditionArr = [[NSMutableDictionary alloc] init];
            [conditionArr setObject:@"1" forKey:@"scene"];
            NSString * conditionStr = [jsonWriter stringWithObject:conditionArr];
            
            //设置请求参数
            
            NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&photo_info=%@&condition_arr=%@",[Manager getUserInfo].userId_,photoInfoStr,conditionStr];
            
            NSString * function = @"addPersonPhoto";
            NSString * op   =   @"person_sub_busi";
            
            [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 NSDictionary *dic = result;
                 Status_DataModal *model = [[Status_DataModal alloc]init];
                 model.status_ = [dic objectForKey:@"status"];
                 model.exObj_ = [[dic objectForKey:@"info"] objectForKey:@"id"];
                 
                 if ([model.status_ isEqualToString:@"OK"]) {

                    [self upLoadImageSuccess:model.exObj_ withImage:[UIImage imageWithData:tempArr[indexOne]]];
                     
                     indexOne += 1;
                     [self performSelector:@selector(upLoadPhotoToService) withObject:self afterDelay:0.1];//延时处理
                 }else{
                     [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:nil];
                 }
                 
             } failure:^(NSURLSessionDataTask *operation, NSError *error) {}];
        }
            
            break;
        case Request_DeleteResumeImage:
        {
            if ([[dataArr objectAtIndex:0] isEqualToString:@"OK"]) {
                [self delegatePhotoSuccess];
                [BaseUIViewController showAutoDismissSucessView:@"删除成功" msg:nil];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"删除失败" msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 相册选取照片代理方法
- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    NSMutableArray *imgDataArr = [NSMutableArray array];
    for (uploadImage in imageArr) {
        NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
        [imgDataArr addObject:imgData];
    }
    
    uploadImage = [uploadImage fixOrientation];
    
    tempArr = [[NSMutableArray alloc] initWithArray:imgDataArr];
    indexOne = 0;
    [self upLoadPhotoToService];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
    uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    uploadImage = [uploadImage fixOrientation];
    NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
    NSArray *photoDataArr = [[NSArray alloc] initWithObjects:imgData, nil];
    tempArr = [[NSMutableArray alloc] initWithArray:photoDataArr];
    indexOne = 0;
    [self upLoadPhotoToService];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    [_delegate_ photoCancelRefresh];
}

#pragma mark - 上传生成图片url
-(void)upLoadPhotoToService
{
    if (indexOne == tempArr.count)
    {
        return;
    }
    //以时间命名图片
    NSDate * now = [NSDate date];
    NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
    RequestCon *uploadCon = [self getNewRequestCon];
    [uploadCon uploadPhotoData:tempArr[indexOne] name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
    
}
#pragma mark - 删除图片
- (void)deleteResumePhoto
{
    if (!deleteCon_) {
        deleteCon_ = [self getNewRequestCon];
    }
    [deleteCon_ deleteResumeImage:[Manager getUserInfo].userId_ photoId:inPhoto_];
}

#pragma mark -图片上传成功刷新
- (void)upLoadImageSuccess:(NSString *)photoId withImage:(UIImage *)image
{
    NSMutableArray *imgArr = inModel_.photoListArray_;
    PhotoVoiceDataModel *model = [[PhotoVoiceDataModel alloc]init];
    model.photoId_ = photoId;
    model.image_ = image;
    [imgArr addObject:model];

    [self updateView];
    [_delegate_ changImageSuccess];
}

#pragma mark - 刷新页面Frame
- (void)updateView
{
    for (UIButton *button in imgButtonArray_) {
        [button setHidden:YES];
    }
    for (int i=0; i<[inModel_.photoListArray_ count];i++){
        UIButton    *imgButton = [imgButtonArray_ objectAtIndex:i];
        PhotoVoiceDataModel *model = [inModel_.photoListArray_ objectAtIndex:i];
        if (model.photoBigPath_ !=nil) {
            [imgButton sd_setImageWithURL:[NSURL URLWithString:model.photoSmallPath140_] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        }else{
            [imgButton setImage:model.image_ forState:UIControlStateNormal];
        }
        [imgButton setHidden:NO];
    }
    UIView *updateView = (UIView *)[self viewWithTag:5000];
    CGFloat width = (ScreenWidth-38)/4.0;
    if ([inModel_.photoListArray_ count] == 0) {
        [updateView setFrame:CGRectMake(10, 15, width, width)];
        [updateView setHidden:NO];
    }else if ([inModel_.photoListArray_ count] <= 7){
        UIButton *imgButton = [imgButtonArray_ objectAtIndex:[inModel_.photoListArray_ count]];
        [imgButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [updateView setFrame:imgButton.frame];
        [updateView setHidden:NO];
    }else{
        [updateView setHidden:YES];
    }
    
    UILabel *tipsLb = (UILabel *)[self viewWithTag:4003];
    if (_isMyCenter) {
        [tipsLb setText:@"马上上传"];
    }else{
        [tipsLb setText:@"邀请上传"];
    }
}

#pragma mark - 图片点击事件
- (void)imgButtonClick:(UIButton *)button
{
    if ([inModel_.photoListArray_ count] != 0) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[inModel_.photoListArray_ count]];
        for (int i=0; i<[inModel_.photoListArray_ count]; i++) {
            PhotoVoiceDataModel *model = [inModel_.photoListArray_ objectAtIndex:i];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:model.photoBigPath_]; // 图片路径
            photo.image = model.image_;
            [photos addObject:photo];
        }
        NSInteger indexInt = button.tag - 100;
        photoBrowser_ = [[MJPhotoBrowser alloc] init];
        photoBrowser_.type_ = 2;   //2个人中心   1简历
        photoBrowser_.delegate = self;
        photoBrowser_.currentPhotoIndex = indexInt; // 弹出相册时显示的第一张图片是？
        photoBrowser_.photos = photos; // 设置所有的图片
        photoBrowser_.isMyCenter = _isMyCenter;
        [photoBrowser_ show];
    }
}

#pragma mark- 个人中心选择删除图片
- (void)personCenterDelegateSuccess:(NSString *)index
{
    deleteIndex = index;
    @try {
        if (inModel_.photoListArray_ == nil || [deleteIndex integerValue] >= [inModel_.photoListArray_ count]) {
            return;
        }
        PhotoVoiceDataModel *model = [inModel_.photoListArray_ objectAtIndex:[deleteIndex integerValue]];
        inPhoto_ = model.photoId_;
        [self deleteResumePhoto];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

#pragma mark - 删除图片成功回调
- (void)delegatePhotoSuccess
{
    [inModel_.photoListArray_ removeObjectAtIndex:[deleteIndex intValue]];
    [self updateView];
    [_delegate_ changImageSuccess];
    [photoBrowser_ setViewHiden];
}

#pragma MJPhotoBrowserDelegate
-(void) photoBrowserHide:(MJPhotoBrowser *)photoBrowser
{
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModel_ = dataModal;
    
    CGFloat width = (ScreenWidth-38)/4.0;
    if ([inModel_.photoListArray_ isKindOfClass:[NSMutableArray class]]) {
        if ([inModel_.photoListArray_ count] >=4) {
            self.frame = CGRectMake(0,0,ScreenWidth,width*2 + 35);
        }else{
            self.frame = CGRectMake(0,0,ScreenWidth,width+30);
        }
    }else{
        self.frame = CGRectMake(0,0,ScreenWidth,width+30);
    }
    [self updateView];
}

-(void)loginDelegateCtl
{
    [_delegate_ addNologinNotification];
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)getResumePhotoAndVoiceSuccess:(NSArray *)dataArray
{
}

-(void)loginSuccess{
}

@end
