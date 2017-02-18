//
//  ExpertDetailCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-18.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ExpertDetailCtl.h"
#import "MyPubilshCtl_Cell.h"
#import "Article_DataModal.h"
#import "Manager.h"
#import "ExpertAnswerCtl_Cell.h"
#import "HomeCtl_Cell.h"
#import "RecommendGroups_Cell.h"
#import "Common.h"
#import "MobClick.h"
#import "Manager.h"
#import "PhotoVoiceDataModel.h"
#import "NoLoginPromptCtl.h"

@interface ExpertDetailCtl () <NoLoginDelegate>
{
    NSInteger fansCnt_;
    NSInteger currentIndex;
    NSInteger btnTag_;
    AVAudioPlayer                      *player;
}
@end

@implementation ExpertDetailCtl

@synthesize photoImgv_,nameLb_,tradeLb_,jobLb_,followBtn_,sendLetterBtn_,mottoLb_,delegate_,type_,askBtn_,isExpertImg_,segButtonLeft_,segButtonMiddle_,segButtonRight_,scrollView_,inType_,leftLb_,middleLb_,rightLb_,backBtn_,imgBgView_,tradeJobLb_,isMine_;


-(id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    self.title = @"个人中心";
    
    expertPublishCtl_ = [[ExpertPublishCtl alloc] init];
    expertGroupsCtl_ = [[ExpertGroupsCtl alloc] init];
    expertDetailAnswerCtl_ = [[ExpertDetailAnswerCtl alloc] init];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange:) name:@"USERINFOCHANGOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"LOGINSUCCESS" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVoice) name:@"STOPVOICE" object:nil];
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [isExpertImg_ setHidden:YES];
    
    if (isMine_) {
        followBtn_.alpha = 0.0;
        askBtn_.alpha = 0.0;
        expertFansBtn_.alpha = 0.0;
        expertMsgBtn_.frame = followBtn_.frame;
        [expertMsgBtn_ setImage:[UIImage imageNamed:@"editor_myInfo"] forState:UIControlStateNormal];
        [expertFansBtn_ setImage:[UIImage imageNamed:@"bton_wogzhu"] forState:UIControlStateNormal];
        
        [playView_ setHidden:NO];
        fileModel_ = [[VoiceFileDataModel alloc]init];
        playBgView_.layer.cornerRadius = 25/2;
        playBgView_.layer.masksToBounds = YES;
        player = [[AVAudioPlayer alloc]init];
    }else{
        [playView_ setHidden:YES];
    }

    sendLetterBtn_.alpha = 0.0 ;
    tableView_.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0];
    //tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [segButtonLeft_ addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventTouchUpInside];
    [segButtonMiddle_ addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventTouchUpInside];
    [segButtonRight_ addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventTouchUpInside];
    [segButtonLeft_ setTag:100];
    [segButtonMiddle_ setTag:101];
    [segButtonRight_ setTag:102];
    
    
    topView_.layer.shadowColor = [UIColor blackColor].CGColor;
    topView_.layer.shadowOffset = CGSizeMake(0,2);
    topView_.layer.shadowOpacity = 0.8;
    
    [backBtn_ setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [backBtn_ setImage:[UIImage imageNamed:@"bton_expertbackseleted.png"] forState:UIControlStateHighlighted];
    
    [shareBtn_ setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [shareBtn_ setImage:[UIImage imageNamed:@"bton_expertshareseleted.png"] forState:UIControlStateHighlighted];
    
    [segButtonLeft_ setTitleColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftLb_ setTextColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0/255.0 alpha:1.0]];
    [segButtonMiddle_ setTitleColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [middleLb_ setTextColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0]];
    [segButtonRight_ setTitleColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightLb_ setTextColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0]];
    
    CGRect rect = scrollView_.frame;
    rect.size.height = rect.size.height-20;
    scrollView_.frame = rect;
    
    scrollView_.delegate = self;
    scrollView_.pagingEnabled = YES;
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.showsVerticalScrollIndicator = NO;
    [scrollView_ setContentSize:CGSizeMake(scrollView_.frame.size.width * 3, 1)];
    
    [expertPublishCtl_.view setFrame:scrollView_.bounds];
    [expertDetailAnswerCtl_.view setFrame:scrollView_.bounds];
    [expertGroupsCtl_.view setFrame:scrollView_.bounds];
    
    rect = expertDetailAnswerCtl_.view.frame;
    rect.origin.x = rect.size.width;
    [expertDetailAnswerCtl_.view setFrame:rect];
    
    CGRect rect1 = expertGroupsCtl_.view.frame;
    rect1.origin.x = rect1.size.width*2;
    [expertGroupsCtl_.view setFrame:rect1];
    
    [scrollView_ addSubview:expertDetailAnswerCtl_.view];
    [scrollView_ addSubview:expertGroupsCtl_.view];
    [scrollView_ addSubview:expertPublishCtl_.view];
    
    [scrollView_ setContentOffset:CGPointMake(currentIndex*scrollView_.frame.size.width, 0) animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (IOS7) {
       [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (IOS7) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)valueChange:(UIButton *)sender
{

    btnTag_ = sender.tag;
    switch (sender.tag) {
        case 100:
        {
            [self changeModel:0];
            break;
        }
        case 101:
        {
            [self changeModel:1];
            break;
        }
        case 102:
        {
            [self changeModel:2];
            break;
        }
        default:
            break;
    }
}

-(void)updateCom:(RequestCon *)con
{
    
    [super updateCom:con];
    
    if (fileModel_.voiceId_ == nil) {
        [playView_ setHidden:YES];
    }else{
        [playView_ setHidden:NO];
    }
    if (myDataModal_ == nil) {
        return;
    }
    if (myDataModal_.isExpert_) {
        //是专家
        [isExpertImg_ setHidden:NO];
        [expertMsgBtn_ setHidden:NO];
        CGRect expertImgRect = isExpertImg_.frame;
        CGRect expertNameRect = nameLb_.frame;
        expertNameRect.origin.x = expertImgRect.origin.x + expertImgRect.size.width + 1;
        [nameLb_ setFrame:expertNameRect];
    }else{
        //非专家
        [isExpertImg_ setHidden:YES];
        if (!isMine_) {
            [expertMsgBtn_ setHidden:YES];
        }
        CGRect expertImgRect = isExpertImg_.frame;
        CGRect expertNameRect = nameLb_.frame;
        expertNameRect.origin.x = expertImgRect.origin.x;
        [nameLb_ setFrame:expertNameRect];
    }
    
    photoImgv_.contentMode = UIViewContentModeScaleToFill;
    [photoImgv_ setImageWithURL:[NSURL URLWithString:myDataModal_.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];

    if (myDataModal_.followStatus_ == 1) {
        [followBtn_ setTitle:[NSString stringWithFormat:@"%ld关注",(long)myDataModal_.fansCnt_] forState:UIControlStateNormal];
        [followBtn_ setBackgroundImage:[UIImage imageNamed:@"bton_guanzhu_selected.png"] forState:UIControlStateNormal];
        [followBtn_ setUserInteractionEnabled:NO];
    }else if (myDataModal_.followStatus_ == 0) {
        [followBtn_.titleLabel setText:@""];
        [followBtn_ setBackgroundImage:[UIImage imageNamed:@"bton_guanzhu_nor.png"] forState:UIControlStateNormal];
        [followBtn_ setUserInteractionEnabled:YES];
    }
    
    CALayer *imgBglayer=[imgBgView_ layer];
    [imgBglayer setMasksToBounds:YES];
    [imgBglayer setBorderWidth:1.0];
    [imgBglayer setCornerRadius:2.0];
    [imgBglayer setBorderColor:[UIColor clearColor].CGColor];
    
    nameLb_.text = myDataModal_.iname_;
    if (myDataModal_.goodat_ == nil) {
        myDataModal_.goodat_ = @"";
    }
    if (myDataModal_.zw_ == nil) {
        myDataModal_.zw_ = @"";
    }
    if (![myDataModal_.goodat_ isEqualToString:@""] && ![myDataModal_.zw_ isEqualToString:@""]) {
        tradeJobLb_.text = [NSString stringWithFormat:@"%@ %@",myDataModal_.goodat_,myDataModal_.zw_];
    }else{
        tradeJobLb_.text = [NSString stringWithFormat:@"%@ %@",myDataModal_.goodat_,myDataModal_.zw_];
    }
    
//    tradeLb_.text = [NSString stringWithFormat:@"%@",myDataModal_.goodat_];
//    jobLb_.text = [NSString stringWithFormat:@"%@",myDataModal_.zw_];
//
//    float temp = 5.0;
//    
//    if ([tradeLb_.text isEqualToString:@""]) {
//        temp = 0;
//    }
//    
//    CGSize tradeNameSize = [tradeLb_.text sizeWithFont:[UIFont systemFontOfSize:9] constrainedToSize:CGSizeMake(0, 0) lineBreakMode:NSLineBreakByWordWrapping];
//    CGSize jobNameSize = [jobLb_.text sizeWithFont:[UIFont systemFontOfSize:9] constrainedToSize:CGSizeMake(0, 0) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    if (tradeNameSize.width + jobNameSize.width >179) {
//        jobNameSize.width = 179-tradeNameSize.width;
//    }
//    CGRect tradeRect = tradeLb_.frame;
//    tradeRect.size.width = tradeNameSize.width;
//    [tradeLb_ setFrame:tradeRect];
//    
//    CGRect jobRect = jobLb_.frame;
//    jobRect.origin.x = tradeLb_.frame.origin.x + tradeLb_.frame.size.width + temp;
//    jobRect.size.width = jobNameSize.width;
//    [jobLb_ setFrame:jobRect];
    
    mottoLb_.text = myDataModal_.signature_;
    
    [leftLb_ setText:[NSString stringWithFormat:@"%ld",(long)myDataModal_.publishCnt_]];
    [middleLb_ setText:[NSString stringWithFormat:@"%ld",(long)myDataModal_.answerCnt_]];
    [rightLb_ setText:[NSString stringWithFormat:@"%ld",(long)myDataModal_.groupsCreateCnt_]];
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    type_ = List_Publish;
    inDataModal_ = dataModal;
    fansCnt_ = inDataModal_.fansCnt_;
    [self changeModel:0];
    [expertGroupsCtl_ beginLoad:inDataModal_ exParam:nil];
    [expertDetailAnswerCtl_ beginLoad:inDataModal_ exParam:nil];
    [expertPublishCtl_ beginLoad:inDataModal_ exParam:nil];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    [con getPersonDetailWithPersonId:inDataModal_.id_ userId:[Manager getUserInfo].userId_];
    
    if (isMine_) {
        if (!infoCon_) {
            infoCon_ = [self getNewRequestCon:NO];
        }
        [infoCon_ getResumePhotoAndVoice:[Manager getUserInfo].userId_];
    }
}

//change model
-(void) changeModel:(int)index
{
    [scrollView_ setContentOffset:CGPointMake(index*scrollView_.frame.size.width, 0) animated:YES];
    
    currentIndex = index;
    
    [self changeBtnStatus:index];
}

//change btn status
-(void) changeBtnStatus:(int)index
{
    [segButtonLeft_ setTitleColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [segButtonMiddle_ setTitleColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [segButtonRight_ setTitleColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [leftLb_ setTextColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0]];
    [middleLb_ setTextColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0]];
    [rightLb_ setTextColor:[UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0]];
    
    switch (index) {
        case 0:
        {
            [segButtonLeft_ setTitleColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [leftLb_ setTextColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0 alpha:1.0]];
        }
            break;
        case 1:
        {
            [segButtonMiddle_ setTitleColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [middleLb_ setTextColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0 alpha:1.0]];
        }
            break;
            
        case 2:
        {
            [segButtonRight_ setTitleColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [rightLb_ setTextColor:[UIColor colorWithRed:241/255.0 green:42.0/255.0 blue:19.0/255.0 alpha:1.0]];
        }
            break;
        default:
            break;
    }
}

#pragma UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( scrollView_ == scrollView )
    {
        CGFloat pageWidth = scrollView_.frame.size.width;
        int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
        
        if( pageIndex != currentIndex ){
            [self changeModel:pageIndex];
        }
    }
}

-(void)followExpert:(NSInteger)status  expertID:(NSString*)expertID
{
    if (!followCon_) {
        followCon_ = [self getNewRequestCon:NO];
    }
    if (status == 0) {
        [followCon_ followExpert:[Manager getUserInfo].userId_ expert:expertID];
    }
    else if(status == 1){
        [followCon_ cancelFollowExpert:[Manager getUserInfo].userId_ expert:expertID];
    }
    
    
}




-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_GetPersonDetail:
        {
            myDataModal_ = [dataArr objectAtIndex:0];
            
            if ([Manager getUserInfo].userId_ && ![[Manager getUserInfo].userId_ isEqualToString:myDataModal_.id_]) {
                if (!visitLogsCon_) {
                    [visitLogsCon_ myCenterVisitLog:[Manager getUserInfo].userId_ visitorId:myDataModal_.id_];
                }
            }
        }
            break;
        case Request_Follow:
        {
            @try {
                Status_DataModal * datamodal = [dataArr objectAtIndex:0];
                if ([datamodal.status_ isEqualToString:Success_Status]) {
                    [BaseUIViewController showAutoDismissSucessView:@"已关注" msg:Nil];
                    myDataModal_.followStatus_ = 1;
                    fansCnt_ = fansCnt_+1;
                    myDataModal_.fansCnt_ ++;
                    [self updateCom:nil];
                    [delegate_ followOk:self];
                }
                else{
                    [BaseUIViewController showAutoDismissFailView:@"关注失败" msg:@"请稍后再试"];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
            break;
            
        case Request_CancelFollow:
        {
            @try {
                Status_DataModal * datamodal = [dataArr objectAtIndex:0];
                if ([datamodal.status_ isEqualToString:Success_Status]) {
                    [BaseUIViewController showAutoDismissSucessView:@"已取消" msg:Nil];
                    myDataModal_.followStatus_ = 0;
                    fansCnt_ = fansCnt_-1;
                    myDataModal_.fansCnt_ --;
                    [self updateCom:nil];
                    [delegate_ followOk:self];
                }
                else{
                    [BaseUIViewController showAutoDismissFailView:@"取消关注失败" msg:@"请稍后再试"];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            } 
            
        }
            break;
            
        case Request_GetResumePhotoAndVoice:
        {
            NSMutableArray *voiceArr = [dataArr objectAtIndex:1];
            if ([voiceArr count] != 0) {
                PhotoVoiceDataModel *model = [voiceArr objectAtIndex:0];
                fileModel_.duration_ = model.voiceTime_;
                fileModel_.voiceId_ =  model.voiceId_;
                fileModel_.voiceCateId_ = model.voicePmcId_;
                fileModel_.serverFilePath_ = model.voicePath_;
                if (model.voiceId_ != nil) {
                    queue = [[ASINetworkQueue alloc]init];
                    [queue setShowAccurateProgress:YES];
                    [queue setShouldCancelAllRequestsOnFailure:NO];
                    queue.delegate = self;
                    [queue setQueueDidFinishSelector:@selector(finishOver:)];
                    [queue setRequestDidFinishSelector:@selector(requestFinished:)];
                    BOOL mark = NO;
                    
                    NSString *fileName = [[fileModel_.serverFilePath_  componentsSeparatedByString:@"/"]lastObject];
                    NSString *fileNameNoAmr = [[fileName componentsSeparatedByString:@"."]objectAtIndex:0];
                    NSString *filePath = [VoiceRecorderBaseVC getPathByFileName:fileNameNoAmr ofType:@"amr"];
                    NSFileManager *fileManager = [[NSFileManager alloc]init];
                    if (![fileManager fileExistsAtPath:filePath]) {
                        //文件不存在
                        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:fileModel_.serverFilePath_]];
                        [request setDownloadDestinationPath:filePath];
                        [queue addOperation:request];
                        mark = YES;
                    }
                    fileModel_.amrFilePath_ = filePath;
                    if (mark){
                        [queue go];
                    }else{
                        [self finishOver:nil];
                    }
                }
            }else{
                fileModel_.voiceId_ = nil;
            }
        }
            break;
        default:
            break;
    }
}

- (void)finishOver:(ASINetworkQueue*)queue1 {
    
    [self amrToWav:fileModel_.amrFilePath_];
    [playView_ setHidden:NO];
    [timeLb_ setText:[NSString stringWithFormat:@"%@\"",fileModel_.duration_]];
}

//转码Wav
- (void)amrToWav:(NSString *)amrPath
{
    NSString *fileName = [[[[amrPath componentsSeparatedByString:@"/"]lastObject]componentsSeparatedByString:@"."]objectAtIndex:0];
    NSString *convertWavFilePath = [VoiceRecorderBaseVC getPathByFileName:[fileName stringByAppendingString:@"amrToWav"] ofType:@"wav"];
    [VoiceConverter amrToWav:amrPath wavSavePath:convertWavFilePath];
    fileModel_.wavPath_ = convertWavFilePath;
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
}

#pragma mark -开始播放
-(void)voicePlay
{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:fileModel_.wavPath_]){
        return;
    }
    
    index_ = 1;
    player = [player initWithContentsOfURL:[NSURL URLWithString:fileModel_.wavPath_] error:nil];
//    player.delegate = self;
    player.currentTime = 0;
    [player play];
    isplay_ = YES;
    [self changeVoiceImage];
}

- (void)changeVoiceImage
{
    if (!player.isPlaying) {
        isplay_ = NO;
    }
    if (index_ >3) {
        index_ = 1;
    }
    if (isplay_ == NO) {
        [playBtn_ setImage:[UIImage imageNamed:@"bton_yuyinbofang1.png"] forState:UIControlStateNormal];
        return;
    }
    [playBtn_ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bton_%d.png",index_]]forState:UIControlStateNormal];
    index_ ++;
    [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
}

#pragma mark -播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isplay_ = NO;
}

-(void)btnResponse:(id)sender
{
    if (sender == followBtn_) {
            [self stopVoice];
        if ([Manager shareMgr].haveLogin) {
            [self followExpert:myDataModal_.followStatus_ expertID:myDataModal_.id_];
            [followBtn_ setTitle:@"" forState:UIControlStateNormal];
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            //[self showChooseAlertView:1 title:@"无法添加关注" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
        }
    }
    
    if (sender == askBtn_) {
            [self stopVoice];
        if ([Manager shareMgr].haveLogin) {
            AskExpertCtl *askCtl = [[AskExpertCtl alloc]init];
            askCtl.type_ =3;
            [self.navigationController pushViewController:askCtl animated:YES];
            [askCtl beginLoad:myDataModal_ exParam:nil];
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            //[self showChooseAlertView:1 title:@"无法咨询" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
        }
    }
    
    if (sender == backBtn_) {
            [self stopVoice];
        [super backBarBtnResponse:nil];
    }
    
    if (sender == expertMsgBtn_) {
            [self stopVoice];
        if (isMine_) {
            UserInfoCtl *infoCtl = [[UserInfoCtl alloc]init];
            infoCtl.delegate_ = self;
            [infoCtl beginLoad:myDataModal_.id_ exParam:nil];
            [self.navigationController pushViewController:infoCtl animated:YES];
        }
        else
        {
            UserInfoCtl *infoCtl = [[UserInfoCtl alloc]init];
            infoCtl.type_ = @"2";
            [infoCtl beginLoad:myDataModal_.id_ exParam:nil];
            [self.navigationController pushViewController:infoCtl animated:YES];
        }
    }
    
    if (sender == expertFansBtn_) {
            [self stopVoice];
        MyFollowerCtl *followerCtl = [[MyFollowerCtl alloc]init];
        followerCtl.userId_ = myDataModal_.id_;
        [followerCtl beginLoad:@"3" exParam:nil];
        [self.navigationController pushViewController:followerCtl animated:YES];
    }
    
    if (sender == shareBtn_) {
            [self stopVoice];
        
        NSString *imagePath = myDataModal_.img_;
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
        
        NSString * sharecontent = myDataModal_.signature_;
        
        NSString * titlecontent = [NSString stringWithFormat:@"%@的主页",myDataModal_.iname_];
        
        NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/u/%@",myDataModal_.id_];

        //调用分享
        [[ShareManger sharedManager] shareWithCtl:[Manager shareMgr].centerNav_ title:titlecontent content:sharecontent image:image url:url];
    }
    if (sender ==playBtn_) {
        if (isplay_ == YES) {
            [self stopVoice];
        }else{
            [self voicePlay];
        }
    }
}

- (void)stopVoice
{
    if (isplay_) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [playBtn_ setImage:[UIImage imageNamed:@"bton_yuyinbofang1.png"] forState:UIControlStateNormal];
        [player stop];
        isplay_ = NO;
    }
    
}

-(void)userInfoChange:(NSNotification *)notification
{
    User_DataModal *userModel = [Manager getUserInfo];
    myDataModal_.iname_ = userModel.name_;
    myDataModal_.img_ = userModel.img_;
    myDataModal_.goodat_ = userModel.trade_;
    myDataModal_.zw_ = userModel.zye_;
    [self updateCom:nil];
}

-(void)loginDelegateCtl
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark -登录成功刷新
-(void)loginSuccess:(NSNotificationCenter *)notification
{
    [self refreshLoad:nil];
}

- (void)photoChangSuccess
{
    [self refreshLoad:nil];
    [delegate_ photoChang];
}

@end
