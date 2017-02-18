//
//  UpdateGroupPhotoCtl.m
//  jobClient
//
//  Created by 一览ios on 14-12-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "UpdateGroupPhotoCtl.h"
#import "AlbumListCtl.h"
#import "ELGroupDetailModal.h"

@interface UpdateGroupPhotoCtl () <PhotoSelectCtlDelegate,LogoPhotoSelectCtlDelegate>
@end

@implementation UpdateGroupPhotoCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       rightNavBarStr_ = @"提交"; 
//       rightNavBarRightWidth = @"16";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"社群头像";
    [self setNavTitle:@"社群头像"];
    
//    [tipsLb_ setFont:FOURTEENFONT_CONTENT];
//    [tipsLb_ setTextColor:GRAYCOLOR];
//    photoImgv_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
//    photoImgv_.layer.borderWidth = 0.5;
    UITapGestureRecognizer *tapGesutre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [photoImgv_ addGestureRecognizer:tapGesutre];
    
    if (_inType == CREATEGROUP) {
        [tipsLb_ setText:@"社群头像"];
        tipsLb_.font = [UIFont systemFontOfSize:20];
        lableTopHeight.constant = 55;
        imageTopHeight.constant = 147;
        imageWidh.constant = 150;
        imageHeight.constant = 150;
        tipsDetailLb.hidden = NO;
        photoImgv_.image = [UIImage imageNamed:@"creat_group_photo_image"];
        [self changeDataFillFinish];
    }else if(_inType == UPDATEGROUPPHOTO){
        [photoImgv_ sd_setImageWithURL:[NSURL URLWithString:inModel_.pic_] placeholderImage:[UIImage imageNamed:@"icon_zhiysq.png"]];
        [tipsLb_ setText:@"点击修改社群头像"];
        tipsLb_.font = [UIFont systemFontOfSize:14];
        lableTopHeight.constant = 150;
        imageTopHeight.constant = 50;
        imageWidh.constant = 84;
        imageHeight.constant = 84;
        tipsDetailLb.hidden = YES;
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if ([dataModal isKindOfClass:[ELGroupDetailModal class]]) {
        ELGroupDetailModal *modal = dataModal;
        inModel_ = [[Groups_DataModal alloc] init];
        inModel_.id_ = modal.group_id;
        inModel_.pic_ = modal.group_pic;
    }else{
        inModel_ = dataModal; 
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(id)sender
{
    
}

- (void)rightBarBtnResponse:(id)sender
{
    if (_inType == CREATEGROUP) {
        if (_groupMoal_.groupImg_ == nil) {
            return;
            //            UIAlertView *headAlert = [[UIAlertView alloc] initWithTitle:@"上传头像才能创建成功噢!" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//            [headAlert show];
        }
        else
        {
            if ([_groupMoal_.isPublic_ isEqualToString:@"3"]){
                NSData *imgData = UIImageJPEGRepresentation(_groupMoal_.groupImg_, 0.01);
                //以时间命名图片
                NSDate * now = [NSDate date];
                NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
                RequestCon *uploadCon = [self getNewRequestCon:NO];
                [uploadCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
//                if (_groupMoal_.groupImg_ !=nil) {
//                    
//                }else{
//                    if (!createCon_) {
//                        createCon_ = [self getNewRequestCon:NO];
//                    }
//                    int status = 3;
//                    [createCon_ createGroup:[Manager getUserInfo].userId_ name:_groupMoal_.groupName_ intro:@"" tags:nil openStatus:status photo:nil];
//                }
            }else{
                step2Ctl_ = [[CreateGroupStep2Ctl alloc]init];
                step2Ctl_.enterType_ = _enterType_;
                [self.navigationController pushViewController:step2Ctl_ animated:YES];
                [step2Ctl_ beginLoad:_groupMoal_ exParam:nil];
            }
        }
     }else if (_inType == UPDATEGROUPPHOTO){
        if (groupImg_ !=nil) {
            NSData *imgData = UIImageJPEGRepresentation(groupImg_, 0.01);
            //以时间命名图片
            NSDate * now = [NSDate date];
            NSString * timeStr = [now stringWithFormat:@"yyyy-MM-dd_HHmmss" timeZone:[NSTimeZone systemTimeZone] behavior:NSDateFormatterBehaviorDefault];
            RequestCon *uploadCon = [self getNewRequestCon:NO];
            [uploadCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
        }else{
            [BaseUIViewController showAlertView:@"请选择图片" msg:nil btnTitle:@"确定"];
        }
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    //修改头像
    UIActionSheet *uploadImgSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [uploadImgSheet showInView:self.view];
}

#pragma mark- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (buttonIndex) {
            case 0:
            {
                // 相机
                BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                if (!accessStatus) {
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
                break;
            case 1:
                // 相册
            {
                AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                albumListCtl.maxCount = 1;
                albumListCtl.logoDelegate = self;
                albumListCtl.imageType = 2;
                albumListCtl.isOnlyOneSel = YES;
                [self.navigationController pushViewController:albumListCtl animated:YES];
                [albumListCtl beginLoad:nil exParam:nil];
                return;
            }
                //sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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



- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    //    for (UIImage *image in imageArr) {
    //        [self.photoView reloadDataWithImage:image];
    //    }
    if (imageArr.count > 0) {
        @try {
            //base64编码上传头像
            UIImage *uploadImage = imageArr[0];
            [photoImgv_ setImage:uploadImage];
            
            if (_inType == CREATEGROUP) {
                _groupMoal_.groupImg_ = uploadImage;
                 [self changeDataFillFinish];
            }else{
                groupImg_ = uploadImage;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
        }
    }
   
}

- (void)hadFinishSelectPhoto:(NSArray *)imageArr{
    if (imageArr.count > 0) {
        @try {
            //base64编码上传头像
            UIImage *uploadImage = imageArr[0];
            [photoImgv_ setImage:uploadImage];
            
            if (_inType == CREATEGROUP) {
                _groupMoal_.groupImg_ = uploadImage;
                [self changeDataFillFinish];
            }else{
                groupImg_ = uploadImage;
            }
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
        [photoImgv_ setImage:uploadImage];
        
        if (_inType == CREATEGROUP) {
            _groupMoal_.groupImg_ = uploadImage;
            [self changeDataFillFinish];
        }else{
            groupImg_ = uploadImage;
        }
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

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    if (_inType == CREATEGROUP) {
        if ([_groupMoal_.isPublic_ isEqualToString:@"3"]) {
            [rightBarBtn_ setTitle:@"提交" forState:UIControlStateNormal];
            [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
            [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [rightBarBtn_ setTitle:@"下一步" forState:UIControlStateNormal];
            [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
        }
    }else if (_inType == UPDATEGROUPPHOTO){
        [rightBarBtn_ setTitle:@"提交" forState:UIControlStateNormal];
        [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
        [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 50, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

-(void)setDataFinish:(BOOL)isFinish{
    if (isFinish) {
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
    }
}

-(void)changeDataFillFinish{
    BOOL isFinish = NO;
    if(_groupMoal_.groupImg_){
        isFinish = YES;
    }
    [self setDataFinish:isFinish];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UploadPhotoFile:
        {
            Upload_DataModal *imgModel = [dataArr objectAtIndex:0];
            for (Upload_DataModal *model in imgModel.pathArr_) {
                //取140大小
                if ([model.size_ isEqualToString:@"140"]) {
                    groupImgUrl_ = model.path_;
                }
            }
            if (groupImgUrl_ == nil) {
                [BaseUIViewController showAutoDismissSucessView:@"修改社群头像失败" msg:@"请稍后在试" seconds:0.5];
                return;
            }
            
            if (_inType == CREATEGROUP) {
               if (!createCon_) {
                   createCon_ = [self getNewRequestCon:NO];
               }
               [createCon_ createGroup:[Manager getUserInfo].userId_ name:_groupMoal_.groupName_ intro:_groupMoal_.groupIntro tags:nil openStatus:[_groupMoal_.isPublic_ integerValue] photo:groupImgUrl_];
            }else if(_inType == UPDATEGROUPPHOTO){
                if (!updateImgCon_) {
                    updateImgCon_ = [self getNewRequestCon:NO];
                }
                [updateImgCon_ updateGroups:[Manager getUserInfo].userId_ groupId:inModel_.id_ groupName:nil groupIntro:nil groupTag:nil openStatus:nil groupPic:groupImgUrl_];
            }
        }
            break;
        case Request_UpdateGroups:
        {
            if ([[dataArr objectAtIndex:0] isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"修改社群头像成功" msg:nil seconds:0.5];
                inModel_.pic_ = groupImgUrl_;
                [self.navigationController popViewControllerAnimated:YES];
                [_delegate updateGroupPhotoSuccess:groupImgUrl_];
            }else{
                [BaseUIViewController showAutoDismissSucessView:@"修改社群头像失败" msg:@"请稍后在试" seconds:0.5];
            }
        }
            break;
        case Request_CreateGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"创建成功" msg:nil];
                User_DataModal *model = [Manager getUserInfo];
                NSInteger groupInt = [[Manager shareMgr].groupCount_ integerValue];
                groupInt --;
                [Manager shareMgr].groupCount_ = [NSString stringWithFormat:@"%ld",(long)groupInt];
                
                [CommonConfig setDBValueByKey:@"groupCreaterCnt" value:[NSString stringWithFormat:@"%ld",(long)model.groupsCreateCnt_]];
                [Manager setUserInfo:model];
                step3Ctl_ = [[CreateGroupStep3Ctl alloc]init];
                step3Ctl_.enteType_ = _enterType_;
                [self.navigationController pushViewController:step3Ctl_ animated:YES];
                [step3Ctl_ beginLoad:[dataArr objectAtIndex:1] exParam:nil];
            }
            else
            {
                [BaseUIViewController showAlertView:@"创建失败" msg:dataModal.des_ btnTitle:@"确定"];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
