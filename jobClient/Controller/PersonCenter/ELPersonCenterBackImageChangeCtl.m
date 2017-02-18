//
//  ELPersonCenterBackImageChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELPersonCenterBackImageChangeCtl.h"
#import "ELChangeImageCell.h"
#import "AlbumListCtl.h"

@interface ELPersonCenterBackImageChangeCtl () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PhotoSelectCtlDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoBrowerDelegate>
{
    NSMutableArray *dataModalArr;
    Logo_DataModal *selectDataModal;
    
    __weak IBOutlet UICollectionView *collectionView_;
    UIImage *shareImage;
    
}
@end

@implementation ELPersonCenterBackImageChangeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"设置主页背景";
    [self setNavTitle:@"设置主页背景"];
    
    collectionView_.dataSource = self;
    collectionView_.delegate = self;
    
    [collectionView_ registerNib:[UINib nibWithNibName:@"ELChangeImageCell" bundle:nil] forCellWithReuseIdentifier:@"ELChangeImageCell"];
   
    dataModalArr = [[NSMutableArray alloc] init];
    
    NSString *requestType = @"PERSON_COVER";
    if (_isFromGroup) 
    {
        Logo_DataModal *modal = [[Logo_DataModal alloc] init];
        modal.name_ = @"add";
        [dataModalArr addObject:modal];
        requestType = @"GROUP_COVER";
    }
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"0" forKey:@"page"];
    [searchDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    
    NSMutableDictionary *searchDicOne = [[NSMutableDictionary alloc] init];
    [searchDicOne setObject:requestType forKey:@"type"];
    SBJsonWriter * jsonWriter1 = [[SBJsonWriter alloc] init];
    NSString * searchDicStrOne = [jsonWriter1 stringWithObject:searchDicOne];
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@&searchArr=%@",searchDicStr,searchDicStrOne];
    
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"getCoverList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
    {
        NSDictionary *dic = result;
       
        if ([dic isKindOfClass:[NSDictionary class]])
        {
            for (NSDictionary *subDic in dic[@"data"])
            {
                Logo_DataModal *modal = [[Logo_DataModal alloc] init];
                modal.name_ = subDic[@"ylp_name"];
                modal.path_ = subDic[@"ylp_path"];
                modal.id_ = subDic[@"ylp_id"];
                modal.url_ = subDic[@"ylp_small_pic"];
                [dataModalArr addObject:modal];
                
                if ([modal.path_ isEqualToString:_imageType] || [modal.url_ isEqualToString:_imageType])
                {
                    selectDataModal = modal;
                }
            }
        }
        if (!selectDataModal)
        {
            if (_isFromGroup){
                selectDataModal = dataModalArr[1];
            }else{
                selectDataModal = dataModalArr[0];
            }
        }
        [collectionView_ reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error)
    {
        
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        rightNavBarStr_ = @"保存";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"设置主页背景";
}

-(void)rightBarBtnResponse:(id)sender
{
    [super rightBarBtnResponse:sender];
    
    if (_isFromGroup) 
    {
        if (selectDataModal.photoImage) {
            [self uploadPhoto];
        }
        else
        {
            [self requestUpdateGroupBackImage];
        }
    }
    else
    {
        [self requestPersonCenterBackImage];
    }
}

-(void)requestPersonCenterBackImage
{
    [BaseUIViewController showLoadView:YES content:@"正在保存" view:nil];
    [ELRequest postbodyMsg:[NSString stringWithFormat:@"person_id=%@&cover_path=%@",[Manager getUserInfo].userId_,selectDataModal.path_] op:@"person_info_busi" func:@"setPersonCover" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *dic = result;
         NSString *status = dic[@"status"];
         NSString *status_desc = dic[@"status_desc"];
         if ([status isEqualToString:@"OK"])
         {
             [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存成功" seconds:1.0];
             if (_changeImageBolck)
             {
                 _changeImageBolck(selectDataModal);
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
         else
         {
             [BaseUIViewController showAutoDismissAlertView:@"" msg:status_desc seconds:1.0];
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网路" seconds:1.0];
     }];

}

-(void)requestUpdateGroupBackImage
{
    [BaseUIViewController showLoadView:YES content:@"正在修改" view:nil];
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&group_id=%@&bg_url=%@",[Manager getUserInfo].userId_,_groupDataModal.group_id,selectDataModal.path_];
    [ELRequest postbodyMsg:bodyMsg op:@"groups_busi" func:@"setGroupsBackground" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         NSDictionary *dic = result;
         NSString *status = dic[@"status"];
         NSString *status_desc = dic[@"status_desc"];
         if ([status isEqualToString:@"OK"]){
             [BaseUIViewController showAutoDismissAlertView:@"" msg:status_desc seconds:1.0];
             if (_changeImageBolck){
                 _changeImageBolck(selectDataModal);
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }else{
             [BaseUIViewController showAutoDismissAlertView:@"" msg:status_desc seconds:1.0];
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [BaseUIViewController showLoadView:NO content:nil view:nil];
         [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网路" seconds:1.0];
     }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([dataModalArr count]!=0)
    {
        return  [dataModalArr count];
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
    CGFloat width = (ScreenWidth/2)-15;
    CGFloat height = ((width-10)*85/135)+32;    
    return CGSizeMake(width,height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"ELChangeImageCell";
    ELChangeImageCell *cell = (ELChangeImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    Logo_DataModal *modal = dataModalArr[indexPath.row];
    
    if ([modal.name_ isEqualToString:@"add"])
    {
        cell.addImageBtn.hidden = NO;
        cell.titleImageView.hidden = YES;
        cell.selectImageView.hidden = YES;
        cell.nameLable.text = @"自定义背景";
    }
    else
    {
        cell.addImageBtn.hidden = YES;
        cell.titleImageView.hidden = NO;
        cell.selectImageView.hidden = NO;
        if (modal.photoImage) {
            cell.titleImageView.image = modal.photoImage;
        }else
        {
            [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:modal.path_] placeholderImage:[UIImage imageNamed:@""]];
        }
        
        if ([selectDataModal.id_ isEqualToString:modal.id_])
        {
            cell.selectImageView.image = [UIImage imageNamed:@"icon_ios_xuanzhong"];
        }
        else
        {
            cell.selectImageView.image = [UIImage imageNamed:@"icon_ios_xuanzhong2"];
        }
        cell.nameLable.text = modal.name_;
    }
    return cell;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Logo_DataModal *modal = dataModalArr[indexPath.row];
    if ([modal.name_ isEqualToString:@"add"])
    {
        UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"现在拍摄",@"相册选取", nil];
        [myActionSheet showInView:self.view];
    }
    else
    {
        selectDataModal = dataModalArr[indexPath.row];
        [collectionView_ reloadData];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(9.9,9.9,9.9,9.9);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 1)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        switch (buttonIndex) {
            case 0:
            {
                BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{}];
                if (!accessStatus) {
                    return;
                }
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
                break;
            case 1:
            {
                AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                albumListCtl.maxCount = 1;
                albumListCtl.delegate = self;
                albumListCtl.fromTodayList = YES;
                albumListCtl.sizeType = Type16_9;
                [self.navigationController pushViewController:albumListCtl animated:YES];
                [albumListCtl beginLoad:nil exParam:nil];
                return;
            }
                //imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                break;
        }
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    shareImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    shareImage = [shareImage fixOrientation];
    
    if (!shareImage) {
        return;
    }
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    [arr addObject:shareImage];
//    
//    PhotoBrowerCtl *browerCtl = [[PhotoBrowerCtl alloc]init];
//    browerCtl.fromPublishArticle = YES;
//    browerCtl.browerDelegate = self;
//    browerCtl.selectedAssets = [NSMutableArray arrayWithArray:arr];
//    browerCtl.sizeType = Type16_9;
//    [self.navigationController pushViewController:browerCtl animated:YES];
    //    [self uploadPhoto];
    
    PhotoEditorCtl *editorCtl = [[PhotoEditorCtl alloc]init];
    editorCtl.sourceImage = shareImage;
    [editorCtl reset:NO];
    editorCtl.rotateEnabled = NO;
    editorCtl.sizeType = Type16_9;
    [self.navigationController pushViewController:editorCtl animated:YES];
    editorCtl.doneCallback = ^(UIImage *image, BOOL param){
        shareImage = image;
        if (!shareImage) {
            return;
        }
        [self reloadCollectionView];
    };
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
        [self reloadCollectionView];
    }
}

-(void)finishWithImageArr:(NSArray *)arr
{
    if (arr.count > 0)
    {
        shareImage = arr[0];
        [self reloadCollectionView];
    }
}

-(void)reloadCollectionView
{
    Logo_DataModal *modal2 = [[Logo_DataModal alloc] init];
    modal2.name_ = @"自定义背景";
    modal2.photoImage = shareImage;
    modal2.id_ = [MyCommon getNowTime];
    [dataModalArr insertObject:modal2 atIndex:1];
    selectDataModal = modal2;
    [collectionView_ reloadData];
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
//            NSArray *arr = [modal.pathArr_ filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"size_ = %@", @"960"]];
//            Upload_DataModal *modal1 = arr[0];
            if(modal.path_.length <= 0)
            {
                [BaseUIViewController showAutoDismissFailView:@"" msg:@"上传失败" seconds:1.0];
                return;
            }
            selectDataModal.path_ = modal.path_;
            [self requestUpdateGroupBackImage];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
