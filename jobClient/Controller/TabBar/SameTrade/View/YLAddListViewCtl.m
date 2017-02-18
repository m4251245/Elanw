//
//  YLAddListViewCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/8/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLAddListViewCtl.h"
#import "ELBecomeExpertCtl.h"
//#import "ZBarScanLoginCtl.h"
#import "RecommendYLCtl.h"
#import "ELPublishActivityCtl.h"
#import "AlbumListCtl.h"
#import "ShareSalaryArticleCtl.h"
#import "SalaryListCtl.h"
#import "ELExpertCourseListCtl.h"
#import "PublishArticle.h"

@interface YLAddListViewCtl () <UIActionSheetDelegate,PhotoSelectCtlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PublishArticleDelegate,NoLoginDelegate>
{
    NSMutableDictionary *imageNameDic;
    NSMutableArray *dataArr;
    NSMutableArray *transfromArr;
    NSMutableDictionary *nameDataDic;
    NSMutableDictionary *imageNameDicTwo;
    __weak IBOutlet UIImageView *titleImage;
}
@end

@implementation YLAddListViewCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        transfromArr = [[NSMutableArray alloc] init];
        
        CGFloat btnWidth = 50;
        CGFloat width = (ScreenWidth-(btnWidth*3))/4;
        
        CGRect imageFrame = titleImage.frame;
        imageFrame.origin.x = (ScreenWidth-imageFrame.size.width)/2;
        titleImage.frame = imageFrame;
        
        for (NSInteger i = 0 ; i< 10; i++) 
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:101+i];
            UILabel *lable = (UILabel *)[self.view viewWithTag:201+i];
            
            CGRect btnF = btn.frame;
            btnF.origin.x = (i%3)*(width+btnWidth) + width;
            btnF.origin.y = 130+(40+btnWidth)*(i/3);
            btnF.size.width = btnWidth;
            btnF.size.height = btnWidth;
            btn.frame = btnF;
            
            CGRect lableF = lable.frame;
            lableF.origin.y = CGRectGetMaxY(btnF);
            lableF.size.width = 90;
            lable.frame = lableF;
            lable.font = FOURTEENFONT_CONTENT;
            
            CGPoint labelCenter = lable.center;
            labelCenter.x = btn.center.x;
            lable.center = labelCenter;
            
            NSValue *value = [NSValue valueWithCGAffineTransform:btn.transform];
            [transfromArr addObject:value];
        }
        
        [self clearView];
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = 20;
        self.view.frame = frame;
        imageNameDic = [[NSMutableDictionary alloc] init];
        [imageNameDic setObject:@"ios_icon_addwfx" forKey:@"weijl"];
        [imageNameDic setObject:@"ios_icon_addfcw" forKey:@"fawz"];
        [imageNameDic setObject:@"ios_icon_addtw" forKey:@"tiwt"];
        [imageNameDic setObject:@"ios_icon_addgxs" forKey:@"gxs"];
        [imageNameDic setObject:@"ios_icon_addfql" forKey:@"qunl"];
        [imageNameDic setObject:@"ios_icon_addcjsq" forKey:@"group"];
        [imageNameDic setObject:@"ios_icon_addbgz" forKey:@"baogz"];
        [imageNameDic setObject:@"ios_icon_addhangjia" forKey:@"expert"];
        [imageNameDic setObject:@"ios_icon_addsaoyisao" forKey:@"saoys"];
        [imageNameDic setObject:@"ios_icon_addfenxiang" forKey:@"tuij"];
        [imageNameDic setObject:@"fabuhuodong" forKey:@"fbhd"];
        
        imageNameDicTwo = [[NSMutableDictionary alloc] init];
        [imageNameDicTwo setObject:@"ios_icon_4wfx1" forKey:@"weijl"];
        [imageNameDicTwo setObject:@"ios_icon_5fcw1" forKey:@"fawz"];
        [imageNameDicTwo setObject:@"ios_icon_6tw1" forKey:@"tiwt"];
        [imageNameDicTwo setObject:@"ios_icon_7gxs1" forKey:@"gxs"];
        [imageNameDicTwo setObject:@"ios_icon_8fql1" forKey:@"qunl"];
        [imageNameDicTwo setObject:@"ios_icon_9cjsq1" forKey:@"group"];
        [imageNameDicTwo setObject:@"ios_icon_10bgz1" forKey:@"baogz"];
        [imageNameDicTwo setObject:@"ios_icon_11hangjia1" forKey:@"expert"];
        [imageNameDicTwo setObject:@"ios_icon_12saoyisao1" forKey:@"saoys"];
        [imageNameDicTwo setObject:@"ios_icon_13fenxiang1" forKey:@"tuij"];
        [imageNameDicTwo setObject:@"fabuhuodong" forKey:@"fbhd"];
        
        nameDataDic = [[NSMutableDictionary alloc] init];
        [nameDataDic setObject:@"微记录" forKey:@"weijl"];
        [nameDataDic setObject:@"发文章" forKey:@"fawz"];
        [nameDataDic setObject:@"提问题" forKey:@"tiwt"];
        [nameDataDic setObject:@"匿名灌薪水" forKey:@"gxs"];
        [nameDataDic setObject:@"发起群聊" forKey:@"qunl"];
        [nameDataDic setObject:@"创建社群" forKey:@"group"];
        [nameDataDic setObject:@"曝工资" forKey:@"baogz"];
        if ([Manager shareMgr].haveLogin)
        {
            if ([Manager getUserInfo].isExpert_)
            {
                [nameDataDic setObject:@"行家特权" forKey:@"expert"];
            }
            else
            {
                [nameDataDic setObject:@"申请成为行家" forKey:@"expert"];
            }
        }
        else
        {
            [nameDataDic setObject:@"申请成为行家" forKey:@"expert"];
        }
        [nameDataDic setObject:@"扫一扫" forKey:@"saoys"];
        [nameDataDic setObject:@"推荐给好友" forKey:@"tuij"];
        [nameDataDic setObject:@"发布活动" forKey:@"fbhd"];
        
    }
    return self;
}
- (IBAction)btnRespone:(UIButton *)sender{
    [self btnResponeWitnIndex:dataArr[sender.tag - 101]];
    [self hideView];
}

-(void)hideView
{
    [self.view removeFromSuperview];
    [_addBtnDelegate hideBtnAndView:YES];
    [self clearView];
}

-(void)showViewCtl
{
    [_addBtnDelegate hideBtnAndView:NO];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger i = 0; i < dataArr.count ; i++)
        {
            UIButton *btn = (UIButton *)[self.view viewWithTag:101+i];
            if (btn.frame.size.width < 10)
            {
                btn.transform = CGAffineTransformScale(btn.transform,12.5,12.5);
            }
            else
            {
                btn.transform = CGAffineTransformScale( [transfromArr[i] CGAffineTransformValue],1.25,1.25);
            }
            
        }
    } completion:^(BOOL finished)
     {
         for (NSInteger i = 0; i < dataArr.count ; i++)
         {
             UIButton *btn = (UIButton *)[self.view viewWithTag:101+i];
             btn.transform = [transfromArr[i] CGAffineTransformValue];
         }
     }];
}

-(void)giveDataArr:(NSMutableArray *)arrData
{
    dataArr = arrData;
    for (NSInteger i = 0; i < 10;i++)
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:101+i];
        UILabel *lable = (UILabel *)[self.view viewWithTag:201+i];
        if (i < arrData.count)
        {
            lable.hidden = NO;
            btn.hidden = NO;
            //btn.selected = NO;
            lable.text = nameDataDic[arrData[i]];
            lable.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f];
            [btn setImage:[UIImage imageNamed:imageNameDicTwo[arrData[i]]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageNameDic[arrData[i]]] forState:UIControlStateHighlighted];
        }
        else
        {
            lable.hidden = YES;
            btn.hidden = YES;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideView];
}

-(void)clearView
{
    for (NSInteger i = 0; i < 10 ; i++){
        UIButton *btn = (UIButton *)[self.view viewWithTag:101+i];
        btn.transform = CGAffineTransformScale([transfromArr[i] CGAffineTransformValue],0.1,0.1);
    }
}

-(void)btnResponeWitnIndex:(NSString *)str{
    NSString *index = str;
    if([str isEqualToString:@"weijl"])//微记录
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Add;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":index};
            return;
        }
        UIActionSheet* myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"现在拍摄",@"相册选取", nil];
        [myActionSheet showInView:self.view];
    }
    else if([str isEqualToString:@"fawz"])//发表文章
    {
        if ([Manager shareMgr].haveLogin) {
            PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
            publishArticleCtl.type_ = Article;
            publishArticleCtl.delegate_ = self;
            publishArticleCtl.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr].centerNav_ pushViewController:publishArticleCtl animated:YES];
            [publishArticleCtl beginLoad:nil exParam:nil];
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Add;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":index};
            return;
        }
    }
    else if([str isEqualToString:@"tiwt"])//提问题
    {
        if ([Manager shareMgr].haveLogin)
        {
            AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
            askDefaultCtl_.fromTodayList = YES;
            askDefaultCtl_.hidesBottomBarWhenPushed = YES;
            askDefaultCtl_.backCtlIndex = [Manager shareMgr].centerNav_.viewControllers.count-1;
            [[Manager shareMgr].centerNav_ pushViewController:askDefaultCtl_ animated:YES];
            [askDefaultCtl_ beginLoad:nil exParam:nil];
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Add;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":index};
            return;
        }
    }
    else if([str isEqualToString:@"gxs"])//匿名灌薪水
    {
        ShareSalaryArticleCtl * shareArticleCtl = [[ShareSalaryArticleCtl alloc] init];
        shareArticleCtl.fromTodayList = YES;
        shareArticleCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:shareArticleCtl animated:YES];
        [shareArticleCtl beginLoad:nil exParam:nil];
    }
    else if([str isEqualToString:@"qunl"])//群聊
    {
        
    }
    else if([str isEqualToString:@"group"])//创建社群
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Add;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":index};
            return;
        }
        if ([Manager getUserInfo].isExpert_) {
            if ([[Manager shareMgr].groupCount_ integerValue] <= 0) {
                [BaseUIViewController showAlertView:@"行家最多创建5个社群" msg:nil btnTitle:@"确定"];
                return;
            }
        }
        else
        {
            if ([[Manager shareMgr].groupCount_ integerValue] <= 0) {
                [BaseUIViewController showAlertView:@"普通用户最多创建3个社群" msg:nil btnTitle:@"确定"];
                return;
            }
        }
        [Manager shareMgr].groupCreateCtl_ = [[CreaterGroupCtl alloc] init];
        [Manager shareMgr].creatGroupStartIndex = [Manager shareMgr].centerNav_.viewControllers.count;
        [Manager shareMgr].groupCreateCtl_.enterType_ = 0;
        [Manager shareMgr].groupCreateCtl_.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:[Manager shareMgr].groupCreateCtl_ animated:YES];
        [[Manager shareMgr].groupCreateCtl_ beginLoad:nil exParam:nil];
    }
    else if([str isEqualToString:@"baogz"])//曝工资
    {
        SalaryListCtl *salaryCompareCtl = [[SalaryListCtl alloc]init];
        salaryCompareCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:salaryCompareCtl animated:YES];
        salaryCompareCtl.shouldShowExposureSalary = YES;
        [salaryCompareCtl beginLoad:nil exParam:nil];
    }
    else if([str isEqualToString:@"expert"])//申请行家
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Add;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":index};
            return;
        }
        
        if ([Manager getUserInfo].isExpert_) {
            ELExpertCourseListCtl *CourseListCtl = [[ELExpertCourseListCtl alloc] init];
            CourseListCtl.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr].centerNav_ pushViewController:CourseListCtl animated:YES];
            [CourseListCtl beginLoad:nil exParam:nil];
        }else{
            ELBecomeExpertCtl *expertCtl = [[ELBecomeExpertCtl alloc] init];
            expertCtl.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr].centerNav_ pushViewController:expertCtl animated:YES];
        }
    }
    else if([str isEqualToString:@"saoys"])//扫一扫
    {
//        ZBarScanLoginCtl *ctl = [[ZBarScanLoginCtl alloc] init];
        ELScanQRCodeCtl *ctl= [[ELScanQRCodeCtl alloc] init];
        ctl.type = @"1";
        ctl.isZbar = YES;
        ctl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        
    }
    else if([str isEqualToString:@"tuij"])//推荐给好友
    {
        RecommendYLCtl * recommendYLCtl = [[RecommendYLCtl alloc] init];
        recommendYLCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:recommendYLCtl animated:YES];
        [recommendYLCtl beginLoad:nil exParam:nil];
    }
    else if([str isEqualToString:@"fbhd"])//发布活动
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginFollow_Today_Add;
            [NoLoginPromptCtl getNoLoginManager].noLoginDic = @{@"type":index};
            return;
        }
        if (![Manager getUserInfo].isExpert_) {
            [BaseUIViewController showAlertView:nil msg:@"只有行家才能发布报名活动" btnTitle:@"确定"];
            return;
        }
        ELPublishActivityCtl *publishCtl = [[ELPublishActivityCtl alloc] init];
        publishCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:publishCtl animated:YES];
    }
}

-(void)publishSuccess
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //在指定时间后,要做的事情
        [_addBtnDelegate refreshDelegateCtl];
    });
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
        
        [[Manager shareMgr].centerNav_ presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

/*
 调用系统相册的方法
 */
-(void)addImage{
    AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
    albumListCtl.maxCount = 6;
    albumListCtl.fromTodayList = YES;
    albumListCtl.delegate = self;
    albumListCtl.hidesBottomBarWhenPushed = YES;
    [[Manager shareMgr].centerNav_ pushViewController:albumListCtl animated:YES];
    [albumListCtl beginLoad:nil exParam:nil];
}

#pragma mark 相册图片选择delegate
- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
    publishArticleCtl.canImageCount = 6;
    publishArticleCtl.delegate_ = self;
    publishArticleCtl.type_ = Article;
    publishArticleCtl.fromTodayList = YES;
    publishArticleCtl.hidesBottomBarWhenPushed = YES;
    [[Manager shareMgr].centerNav_ pushViewController:publishArticleCtl animated:YES];
    [publishArticleCtl beginLoad:nil exParam:nil];
    [publishArticleCtl fromTodayListRefreshWithType:2 imageArr:imageArr];
}

//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
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
        
        PublishArticle * publishArticleCtl = [[PublishArticle alloc] init];
        publishArticleCtl.fromTodayList = YES;
        publishArticleCtl.canImageCount = 6;
        publishArticleCtl.delegate_ = self;
        publishArticleCtl.type_ = Article;
        publishArticleCtl.hidesBottomBarWhenPushed = YES;
        [[Manager shareMgr].centerNav_ pushViewController:publishArticleCtl animated:YES];
        [publishArticleCtl beginLoad:nil exParam:nil];
        [publishArticleCtl fromTodayListRefreshWithType:1 imageArr:@[uploadImage]];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginFollow_Today_Add:
        {
            NSDictionary *dic = [NoLoginPromptCtl getNoLoginManager].noLoginDic;
            [self btnResponeWitnIndex:dic[@"type"]];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
