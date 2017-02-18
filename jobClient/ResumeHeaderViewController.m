//
//  ResumeHeaderViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ResumeHeaderViewController.h"
#import "RecordViewCtl.h"
#import "MJPhotoBrowser.h"
#import <AudioToolbox/AudioFile.h>
#import "PersonDetailInfo_DataModal.h"
#import "New_PersonDataModel.h"
#import "VoiceFileDataModel.h"
#import "RequestViewCtl.h"
#import "ASINetworkQueue.h"
#import "PreRequestCon.h"
#import "TransparencyView.h"
#import <AVFoundation/AVFoundation.h>
#import "AlbumListCtl.h"
#import "NSString+URLEncoding.h"
#import "ASIHTTPRequest.h"


#define kIMG_BTN_TAG 123450
@interface ResumeHeaderViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RecordViewCtlDelegate,AVAudioPlayerDelegate,MJPhotoBrowserDelegate,RequestViewCtlDelegate,PhotoSelectCtlDelegate,UIAlertViewDelegate>{
    RequestViewCtl *requestVoiceAndPhotoCtl;
    NSMutableArray *photoVoiceArray_;//请求语音照片数组
    VoiceFileDataModel *voiceFileModel_;//语音model
    ASINetworkQueue *queue;
    NSMutableArray *buttonStatusArray_;//记录照片按钮状态数组
    TransparencyView * transparency_;
    RecordViewCtl * recordCtl_;//录音界面
    BOOL isplay_;
    AVAudioPlayer *player;
    BOOL isReplace_;
    NSMutableArray *imgBtnArr;//记录图片语音数组
    
    MJPhotoBrowser * photoBrowser_;//大图浏览
    NSInteger nowButtonTag_;
    NSString *deleteIndex;
    UIImage *uploadImage;       //相册选择的img
    
    RequestCon *uploadMyImgCon_;
    NSInteger nowPhotosNum;
    UIImagePickerController *imagePickerController;
}
@property (nonatomic,strong)New_PersonDataModel * myPersonDataResumeVO;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *conpleteLabel;

@property (weak, nonatomic) IBOutlet UIButton *addOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *addTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *addThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addFourBtn;

@property (weak, nonatomic) IBOutlet UIButton *imgOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *imgTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *imgThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *imgFourBtn;

@end

@implementation ResumeHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

#pragma mark--配置界面
-(void)configUI{
    _imgView.backgroundColor = [UIColor whiteColor];
    _conpleteLabel.textColor = UIColorFromRGB(0xaa1801);
    _iconImg.layer.cornerRadius = 42;
    _iconImg.layer.masksToBounds = YES;
    
    [self requestPhotoAndVoice];
    _imgOneBtn.tag = 0;
    _imgTwoBtn.tag = 1;
    _imgThreeBtn.tag = 2;
    _imgFourBtn.tag = 3;
    
    _addOneBtn.tag = kIMG_BTN_TAG ;
    _addTwoBtn.tag = kIMG_BTN_TAG + 1;
    _addThreeBtn.tag = kIMG_BTN_TAG + 2;
    _addFourBtn.tag = kIMG_BTN_TAG + 3;
//头部信息做持久化
    NSString *iconUrlStr = getUserDefaults(@"kUser_Icon");
    NSString *userVoiceStr = getUserDefaults(@"kUser_Voice");
    NSString *inameStr = getUserDefaults(@"kUser_Iname_Header");
    
    NSString *renCType = getUserDefaults(@"rcTypeStr");
    NSString *workType = getUserDefaults(@"workTypeStr");
    NSString *stateType = getUserDefaults(@"stateStr");
    if (iconUrlStr.length > 0) {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    }
    if (userVoiceStr.length > 0) {
        if ([userVoiceStr isEqualToString:@"语音简历"]) {
            [_voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [_voiceBtn setTitle:[NSString stringWithFormat:@"%@",userVoiceStr] forState:UIControlStateNormal];
        }
        else{
            [_voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
            [_voiceBtn setTitle:[NSString stringWithFormat:@"%@\"",userVoiceStr] forState:UIControlStateNormal];
        }
    }
    if (inameStr.length > 0) {
        _nameLabel.text = inameStr;
    }
    
    if (renCType.length > 0 && workType.length > 0 && stateType.length > 0) {
       _introLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",renCType,workType,stateType];
    }
}

//获取图片和语音并用代理返回
-(void)requestPhotoAndVoice{
    if (photoVoiceArray_) {
        [photoVoiceArray_ removeAllObjects];
    }
    if (imgBtnArr) {
        [imgBtnArr removeAllObjects];
    }
    if (requestVoiceAndPhotoCtl) {
        requestVoiceAndPhotoCtl = nil;
    }
    imgBtnArr = [@[_imgOneBtn,_imgTwoBtn,_imgThreeBtn,_imgFourBtn]mutableCopy];
    requestVoiceAndPhotoCtl = [[RequestViewCtl alloc]init];
    requestVoiceAndPhotoCtl.type_ = @"2";
    requestVoiceAndPhotoCtl.delegate_ = self;
    [requestVoiceAndPhotoCtl beginLoad:nil exParam:nil];
    voiceFileModel_ = [VoiceFileDataModel new];
    
    //    初始化播放器
    player = [[AVAudioPlayer alloc]init];
    isplay_ = NO;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"用户同意使用麦克风");
        } else {
            NSLog(@"用户不同意麦克风");
        }
    }];
}

#pragma mark--加载数据
-(void)loadData{
    if (!_myPersonDataResumeVO) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"sendData" object:nil];
    }
}

#pragma mark- 请求返回图片语音数组
- (void)getResumePhotoAndVoiceSuccess:(NSArray *)dataArray
{
    photoVoiceArray_ = [[NSMutableArray alloc]init];
    photoVoiceArray_ = [dataArray mutableCopy];
    
    NSMutableArray *voiceArr = [photoVoiceArray_ objectAtIndex:1];
    if ([voiceArr count] != 0) {
        PhotoVoiceDataModel *model = voiceArr.firstObject;
        voiceFileModel_.duration_ = model.voiceTime_;
        voiceFileModel_.voiceId_ =  model.voiceId_;
        voiceFileModel_.voiceCateId_ = model.voicePmcId_;
        voiceFileModel_.serverFilePath_ = model.voicePath_;
        //如果是amr后缀，将地址修改
        NSString *houzuiStr = [[voiceFileModel_.serverFilePath_ componentsSeparatedByString:@"."] lastObject];
        if ([houzuiStr isEqualToString:@"amr"]) {
            voiceFileModel_.serverFilePath_ = [voiceFileModel_.serverFilePath_ stringByReplacingOccurrencesOfString:@"audio" withString:@"audio_acc"];
            voiceFileModel_.serverFilePath_ = [voiceFileModel_.serverFilePath_ stringByReplacingOccurrencesOfString:@"amr" withString:@"aac"];
        }
        if (model.voiceId_ != nil) {
            queue = [[ASINetworkQueue alloc]init];
            [queue setShowAccurateProgress:YES];
            [queue setShouldCancelAllRequestsOnFailure:NO];
            queue.delegate = self;
            [queue setQueueDidFinishSelector:@selector(finishOver:)];
            BOOL mark = NO;
            NSString *fileName = [[voiceFileModel_.serverFilePath_  componentsSeparatedByString:@"/"]lastObject];
            NSString *fileNameNoAmr = [[fileName componentsSeparatedByString:@"."]objectAtIndex:0];
            NSString *filePath = [VoiceRecorderBaseVC getPathByFileName:fileNameNoAmr ofType:@"aac"];
            NSFileManager *fileManager = [[NSFileManager alloc]init];
            if (![fileManager fileExistsAtPath:filePath]) {
                //文件不存在
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:voiceFileModel_.serverFilePath_]];
                [request setDownloadDestinationPath:filePath];
                [queue addOperation:request];
                mark = YES;
            }
            voiceFileModel_.wavPath_ = filePath;
            if (mark){
                [queue go];
            }else{
                [self finishOver:nil];
            }
        }
    }
    else{
        [self showVoice];
        [self updateViewWithDataArray:photoVoiceArray_];
    }
    
}

- (void)finishOver:(ASINetworkQueue*)queue1 {
    [self updateComInfo:nil];
    [self updateViewWithDataArray:photoVoiceArray_];
}

#pragma mark-设置语音按钮的title
-(void) updateComInfo:(PreRequestCon *)con{
    if (voiceFileModel_.serverFilePath_ !=nil) {
        [_voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 55, 0, 0)];
        NSString *userVoiceStr = getUserDefaults(@"kUser_Voice");
        if (![userVoiceStr isEqualToString:voiceFileModel_.duration_]) {
           [_voiceBtn setTitle:[NSString stringWithFormat:@"%@\"",voiceFileModel_.duration_] forState:UIControlStateNormal];
            kUserDefaults(voiceFileModel_.duration_, @"kUser_Voice");
            kUserSynchronize;
        }
    }else{
        [self showVoice];
    }
}

-(void)showVoice{
    [_voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_voiceBtn setTitle:@"语音简历" forState:UIControlStateNormal];
    kUserDefaults(@"语音简历", @"kUser_Voice");
    kUserSynchronize;
}

- (void)updateViewWithDataArray:(NSArray *)dataArray
{
    NSMutableArray *photoArr = [dataArray objectAtIndex:0];
    nowPhotosNum = photoArr.count;
    [buttonStatusArray_ removeAllObjects];
    for (int i= 0; i<[photoArr count]; i++) {
        NSString *status = @"notsetimage";
        if (i != [photoArr count]-1) {
            status = @"havesetimage";
        }
        [buttonStatusArray_ addObject:status];
    }
    
    //根据图片个数显示
    [self arrangeImg:buttonStatusArray_ withImgArr:photoArr];
    
}
 
#pragma mark--通知
-(void)notify:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    NSArray *arr = dic[@"array"];
    if (arr.count > 0) {
        _myPersonDataResumeVO = arr.firstObject;
        [self reloadUI];
    }
    else{
        return;
    }
}
//得到头部数据重新配置头部UI
-(void)reloadUI{
    NSString *iconUrlStr = getUserDefaults(@"kUser_Icon");
    if (![iconUrlStr isEqualToString:_myPersonDataResumeVO.pic]) {
        [_iconImg sd_setImageWithURL:[NSURL URLWithString:_myPersonDataResumeVO.pic]];
        if (_myPersonDataResumeVO.pic.length > 0) {
            kUserDefaults(_myPersonDataResumeVO.pic, @"kUser_Icon");
            kUserSynchronize;
        }
    }
    
    _nameLabel.text = _myPersonDataResumeVO.iname;
    if (_myPersonDataResumeVO.iname.length > 0) {
        kUserDefaults(_myPersonDataResumeVO.iname, @"kUser_Iname_Header");
        kUserSynchronize;
    }
    
    _introLabel.text = [self status:_myPersonDataResumeVO.resume_status type:_myPersonDataResumeVO.rctypeId workAge:_myPersonDataResumeVO.gznum];
    _conpleteLabel.text = [NSString stringWithFormat:@"简历完整度：%@%%",_myPersonDataResumeVO.percentage];
}

#pragma mark--代理
#pragma MJPhotoBrowserDelegate
-(void) photoBrowserHide:(MJPhotoBrowser *)photoBrowser
{
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
                {
                    [self isCamara];
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                
                }
                    break;
                case 1:
                {
                    // 相册
                    AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                    albumListCtl.maxCount = 4 - nowPhotosNum;
                    albumListCtl.delegate = self;
                    [self.navigationController pushViewController:albumListCtl animated:YES];
                    [albumListCtl beginLoad:nil exParam:nil];

                    return;
                }
                    break;
                case 2:
                    // 取消
                    return;
            }
            
        }else{
            switch (buttonIndex) {
                case 0:
                {
                    PhotoVoiceDataModel *model = [[photoVoiceArray_ objectAtIndex:0]objectAtIndex:nowButtonTag_-kIMG_BTN_TAG];
                    requestVoiceAndPhotoCtl = [[RequestViewCtl alloc]init];
                    requestVoiceAndPhotoCtl.delegate_ = self;
                    requestVoiceAndPhotoCtl.type_ = @"3";
                    [requestVoiceAndPhotoCtl beginLoad:model.photoId_ exParam:nil];
                }
                    break;
                case 1:
                {
                    [self isCamara];
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                }
                    break;
                case 2:
                {   // 相册
                    AlbumListCtl *albumListCtl = [[AlbumListCtl alloc]init];
                    albumListCtl.maxCount = 1;
                    albumListCtl.delegate = self;
                    [self.navigationController pushViewController:albumListCtl animated:YES];
                    [albumListCtl beginLoad:nil exParam:nil];
                }
                    break;
                case 3:
                    // 取消
                    return;
            }
        }
        
    }
    // 跳转到相机或相册页面
    if (actionSheet.tag != 2000 && buttonIndex == 0) {
        return;
    }
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if (actionSheet.tag != 2000) {
        isReplace_ = YES;
    }else{
        isReplace_ = NO;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - PhotoSelectCtlDelegate
- (void)didFinishSelectPhoto:(NSArray *)imageArr
{
    if (imageArr.count > 0)
    {
        @try {
            NSMutableArray *imgDataArr = [NSMutableArray array];
            for (uploadImage in imageArr) {
                NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
                [imgDataArr addObject:imgData];
            }
            
            uploadImage = [uploadImage fixOrientation];
            //图片上传/替换
            if (!requestVoiceAndPhotoCtl) {
                requestVoiceAndPhotoCtl = [[RequestViewCtl alloc]init];  //用于上传图片的Ctl
                requestVoiceAndPhotoCtl.delegate_ = self;
            }
            requestVoiceAndPhotoCtl.type_ = @"1";
            requestVoiceAndPhotoCtl.requestType = @"2";
            requestVoiceAndPhotoCtl.replacePhotoId_ = nil;
            [requestVoiceAndPhotoCtl beginLoad:imgDataArr exParam:nil];
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    uploadImage = [uploadImage fixOrientation];
    NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.3);
    NSArray *photoDataArr = [[NSArray alloc] initWithObjects:imgData, nil];
    
    //图片上传/替换
    if (!requestVoiceAndPhotoCtl) {
        requestVoiceAndPhotoCtl = [[RequestViewCtl alloc]init];  //用于上传图片的Ctl
        requestVoiceAndPhotoCtl.delegate_ = self;
    }
    requestVoiceAndPhotoCtl.type_ = @"1";
    requestVoiceAndPhotoCtl.requestType = @"2";
    requestVoiceAndPhotoCtl.replacePhotoId_ = nil;
    [requestVoiceAndPhotoCtl beginLoad:photoDataArr exParam:nil];
}

#pragma mark - 图片上传成功代理返回图片ID
- (void)upLoadImageSuccess:(NSString *)photoId withImagePath:(NSString *)imagePathStr Image:(UIImage *)image
{
    NSMutableArray *photoArray = [photoVoiceArray_ objectAtIndex:0];
    
    PhotoVoiceDataModel *model = [[PhotoVoiceDataModel alloc]init];
    model.photoId_ = photoId;
    model.photoSmallPath140_ = imagePathStr;
    model.image_ = image;
    
    [photoArray addObject:model];
    [self arrangeImg:nil withImgArr:photoArray];
}

#pragma mark- 删除图片回调
- (void)resumeDelegatePhotoSuccess:(NSString *)index
{
    deleteIndex = index;
    if (photoVoiceArray_ == nil) {
        return;
    }else{
        NSArray *array = [photoVoiceArray_ objectAtIndex:0];
        if ([deleteIndex intValue] >= [array count]) {
            return;
        }
    }
    PhotoVoiceDataModel *model = [[photoVoiceArray_ objectAtIndex:0]objectAtIndex:[deleteIndex intValue]];
    requestVoiceAndPhotoCtl = [[RequestViewCtl alloc]init];
    requestVoiceAndPhotoCtl.delegate_ = self;
    requestVoiceAndPhotoCtl.type_ = @"3";
    [requestVoiceAndPhotoCtl beginLoad:model.photoId_ exParam:nil];
}

- (void)delegatePhotoSuccess
{
    //刷新
    [photoBrowser_ setViewHiden];
    [self configDeletedImg];
}

#pragma mark-录音 RecordViewCtlDelegate
- (void)removeView{
    [transparency_ removeFromSuperview];
}

- (void)updateView:(VoiceFileDataModel *)fileModel{
    voiceFileModel_ = fileModel;
    [self updateComInfo:nil];
}


#pragma mark -播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isplay_ = NO;
    [self handleNotification:NO];
}


#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    //在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state];
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark--事件
//返回
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//语音按钮
- (IBAction)voiceBtnClick:(id)sender {
    NSLog(@"语音");
    if (voiceFileModel_.serverFilePath_ !=nil) {
        if (!transparency_) {
            transparency_ = [[TransparencyView alloc]init];
        }
        if (!recordCtl_) {
            recordCtl_ = [[RecordViewCtl alloc]init];
        }
        recordCtl_.type = @"1";    //2表示个人中心   1表示简历中心
        recordCtl_.delegate_ = self;
        [recordCtl_ beginLoad:[Manager shareMgr].userCenterModel.voiceModel_ exParam:nil];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:recordCtl_.view];
        [recordCtl_ playVoiceWhenViewShow];  //有语音自动播放语音
    }
    else{
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                
            } else {
                
            }
        }];
        
        if (!transparency_) {
            transparency_ = [[TransparencyView alloc]init];
        }
        if (!recordCtl_) {
            recordCtl_ = [[RecordViewCtl alloc]init];
            recordCtl_.delegate_ = self;
            recordCtl_.type = @"1";
        }
        [recordCtl_ beginLoad:voiceFileModel_ exParam:nil];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:recordCtl_.view];
    }
}
//添加图片
-(IBAction)addBtnClick:(UIButton *)button{
    NSLog(@"tianjia");
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"现在拍摄",@"选取相册图片", nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 2000;
    nowButtonTag_ = button.tag;
}

//点击图片放大
-(IBAction)imgBtnClick:(UIButton *)button{
    
    NSLog(@"dianji");
        NSMutableArray *photoArray = [photoVoiceArray_ objectAtIndex:0];
        if ([photoArray count] != 0) {
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[photoArray count]];
            for (int i=0; i<[photoArray count]; i++) {
                PhotoVoiceDataModel *model = [photoArray objectAtIndex:i];
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:model.photoBigPath_]; // 图片路径
                photo.image = model.image_;
                [photos addObject:photo];
            }
            NSInteger indexInt = button.tag;
            photoBrowser_ = [[MJPhotoBrowser alloc] init];
            photoBrowser_.type_ = 1;
            photoBrowser_.isMyCenter = YES;
            photoBrowser_.delegate = self;
            photoBrowser_.isposition_ = YES;
            photoBrowser_.currentPhotoIndex = indexInt; // 弹出相册时显示的第一张图片是？
            photoBrowser_.photos = photos; // 设置所有的图片
            [photoBrowser_ show];
    }
}

#pragma mark--业务逻辑
//头部卡片的工作经验，状态，人才类型
-(NSString *)status:(NSString *)resumeState type:(NSString *)rcType workAge:(NSString *)workAge
{
    //人才类型
    NSString *rcTypeStr = @"";
    if ([rcType isEqualToString:@"1"]) {
        rcTypeStr = @"社会人才";
    }else if ([rcType isEqualToString:@"0"]){
        rcTypeStr = @"应届生";
    }
    
    //工作经验
    NSString *workStr = @"";
    if ([workAge isEqualToString:@"0.0"] || workAge.length <= 0) {
        workStr = @"暂无经验";
    }
    else
    {
        workStr = [NSString stringWithFormat:@"%@年经验",workAge];
    }
    
    //求职状态
    NSString *stateStr = @"";
    if ([resumeState isEqualToString:@"4"]){
        stateStr = @"已离职，即可到岗";
    }else if ([resumeState isEqualToString:@"5"]){
        stateStr = @"仍在职，欲换工作";
    }else if ([resumeState isEqualToString:@"6"]){
        stateStr = @"暂不跳槽";
    }else if ([resumeState isEqualToString:@"7"]){
        stateStr = @"寻找新机会";
    }
    else{
        stateStr = @"求职状态未填写";
    }
    
    NSString *renCType = getUserDefaults(@"rcTypeStr");
    NSString *workType = getUserDefaults(@"workTypeStr");
    NSString *stateType = getUserDefaults(@"stateStr");
    
    if (![renCType isEqualToString:rcTypeStr]) {
        kUserDefaults(rcTypeStr, @"rcTypeStr");
        kUserSynchronize;
    }
    if (![workType isEqualToString:workStr]) {
        kUserDefaults(workStr, @"workTypeStr");
        kUserSynchronize;
    }
    if (![stateType isEqualToString:stateStr]) {
        kUserDefaults(stateStr, @"stateStr");
        kUserSynchronize;
    }
    return [NSString stringWithFormat:@"%@ | %@ | %@",rcTypeStr,workStr,stateStr];
}

//显示图片
-(void)arrangeImg:(NSArray *)imgStateArr withImgArr:(NSArray *)imgNameArr{
    NSMutableArray *imgBtnDataModelArr = [NSMutableArray array];
    nowPhotosNum = imgNameArr.count;
    for (int i = 0; i < imgNameArr.count; i++) {
        PhotoVoiceDataModel *model = imgNameArr[i];
        [imgBtnDataModelArr addObject:model];
    }
    
    if (imgNameArr.count == 0) {
        _addOneBtn.hidden = NO;
    }
    else if(imgNameArr.count == 1){
        _addTwoBtn.hidden = NO;
        _imgOneBtn.hidden = NO;
        [self imgSetImg:imgBtnDataModelArr];
    }
    else if(imgNameArr.count == 2){
        _addThreeBtn.hidden = NO;
        _imgTwoBtn.hidden = NO;
        _imgOneBtn.hidden = NO;
        [self imgSetImg:imgBtnDataModelArr];
    }
    else if(imgNameArr.count == 3){
        _addFourBtn.hidden = NO;
        _imgThreeBtn.hidden = NO;
        _imgTwoBtn.hidden = NO;
        _imgOneBtn.hidden = NO;
        [self imgSetImg:imgBtnDataModelArr];
    }
    else{
        _imgFourBtn.hidden = NO;
        _imgThreeBtn.hidden = NO;
        _imgTwoBtn.hidden = NO;
        _imgOneBtn.hidden = NO;
        [self imgSetImg:imgBtnDataModelArr];
    }
}
-(void)imgSetImg:(NSArray *)imgBtnDataModelArr{
    for (int i = 0; i < imgBtnDataModelArr.count; i++) {
        PhotoVoiceDataModel *model = imgBtnDataModelArr[i];
        UIButton *btn = imgBtnArr[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photoSmallPath140_] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"weifenxiangbtnadd.png"]];
    }
}
//删除图片后显示处理
-(void)configDeletedImg{
    _imgFourBtn.hidden = YES;
    _imgThreeBtn.hidden = YES;
    _imgTwoBtn.hidden = YES;
    _imgOneBtn.hidden = YES;
    _addTwoBtn.hidden = YES;
    _addThreeBtn.hidden = YES;
    _addFourBtn.hidden = YES;
    _addOneBtn.hidden = NO;
    [_imgOneBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    [_imgTwoBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    [_imgThreeBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    [_imgFourBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    
    [self deleteDeal];
}

-(void)deleteDeal{
    if (photoVoiceArray_ == nil) {
        return;
    }else{
        NSMutableArray *array = [photoVoiceArray_ objectAtIndex:0];
        if (   [deleteIndex intValue] >= [array count]  ) {
            return;
        }
        [array removeObjectAtIndex:[deleteIndex intValue]];
        [self arrangeImg:nil withImgArr:array];
    }
    
}

-(void)isCamara{
    // 相机
    [[Manager shareMgr] getTheCameraAccessWithCancel:^{
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
