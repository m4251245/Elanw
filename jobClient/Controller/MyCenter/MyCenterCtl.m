//
//  MyCenterCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-11.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "MyCenterCtl.h"
#import "Manager.h"
#import "UIImageView+WebCache.h"
#import "AttentionCompanyListCtl.h"
#import "MobClick.h"
#import "AttentionCompanyListCtl.h"
#import "MyResumeCtl.h"
#import "MySchollCtl.h"
#import "PhotoVoiceDataModel.h"
#import "MyAudienceListCtl.h"

@interface MyCenterCtl ()


@end

@implementation MyCenterCtl
@synthesize imgBtn_,nameLb_,tradeLb_,jobLb_,identifyImg_,fansBtn_,followBtn_,publishBtn_,asscBtn_,detailBtn_,asscCntLb_,follCntLb_,fansCntLb_,follTitleLb_,fansTitleLb_,asscTitleLb_;

-(id)init
{
    self = [super init];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bton_mycenter.png"]];
    self.navigationItem.hidesBackButton = YES;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        validateSeconds_ = 24*3600;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyImage) name:@"CenterRefrushImage" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFollowCnt:) name:@"AddFollowCnt" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusFollowCnt:) name:@"MinusFollowCnt" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(voiceChangSuccess) name:@"ChangVoiceSuccess" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    fileModel_ = [[VoiceFileDataModel alloc]init];
    playBgView_.layer.cornerRadius = 25/2;
    playBgView_.layer.masksToBounds = YES;
    player = [[AVAudioPlayer alloc]init];
    isplay_ = @"0";
    [playView_ setHidden:YES];
    [meImageview_ setHidden:NO];
    
    CGRect rect = tableView_.frame;
    rect.size.height = rect.size.height-44;
    tableView_.frame = rect;
    
    tableView_.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    identifyImg_.alpha = 0.0;
    
    [self checkLogin];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateMyImage
{
    [imgBtn_ setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
}

-(void) updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
    [nameLb_        setFont:FIFTEENFONT_TITLE];
    [nameLb_        setTextColor:DARKBLACKCOLOR];
    [tradeLb_       setFont:NINEFONT_TIME];
    [tradeLb_       setTextColor:LIGHTGRAYCOLOR];
    [jobLb_         setFont:NINEFONT_TIME];
    [jobLb_         setTextColor:LIGHTGRAYCOLOR];
    [follCntLb_     setFont:TWEELVEFONT_COMMENT];
    [fansCntLb_     setFont:TWEELVEFONT_COMMENT];
    [asscCntLb_     setFont:TWEELVEFONT_COMMENT];
    [follTitleLb_   setFont:TWEELVEFONT_COMMENT];
    [fansTitleLb_   setFont:TWEELVEFONT_COMMENT];
    [asscTitleLb_   setFont:TWEELVEFONT_COMMENT];
    [follCntLb_     setTextColor:BLACKCOLOR];
    [fansCntLb_     setTextColor:BLACKCOLOR];
    [asscCntLb_     setTextColor:BLACKCOLOR];
    [follTitleLb_   setTextColor:BLACKCOLOR];
    [fansTitleLb_   setTextColor:BLACKCOLOR];
    [asscTitleLb_   setTextColor:BLACKCOLOR];
    
    User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:0];
    if (!dataModal.name_||[dataModal.name_ isEqualToString:@""]) {
        nameLb_.text = @"暂无";
    }
    else
        nameLb_.text = dataModal.name_;
    if (!dataModal.job_||[dataModal.job_ isEqualToString:@""]) {
        tradeLb_.text = @"职业：暂无";
    }
    else
        tradeLb_.text = [NSString stringWithFormat:@"职业：%@",dataModal.job_];
    if (!dataModal.zye_||[dataModal.zye_ isEqualToString:@""]) {
        jobLb_.text = @"头衔：暂无";
    }
    else
        jobLb_.text = [NSString stringWithFormat:@"头衔：%@",dataModal.zye_];
    
    follCntLb_.text = [NSString stringWithFormat:@"%ld",(long)dataModal.followCnt_];
    fansCntLb_.text = [NSString stringWithFormat:@"%ld",(long)dataModal.fansCnt_];
    asscCntLb_.text = [NSString stringWithFormat:@"%ld",(long)dataModal.groupsCnt_];
    
    [imgBtn_ setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    if (dataModal.isExpert_) {
        identifyImg_.alpha = 1.0;

    }
    else
    {
        identifyImg_.alpha = 0.0;
    }
    
    if(fileModel_.voiceId_ == nil)
    {
        [playView_ setHidden:YES];
        [timeLb_ setText:[NSString stringWithFormat:@"%@\"",fileModel_.duration_]];
        [meImageview_ setHidden:NO];
    }else{
        [playView_ setHidden:NO];
        [timeLb_ setText:[NSString stringWithFormat:@"%@\"",fileModel_.duration_]];
        [meImageview_ setHidden:YES];
    }
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
//    if (!isExpertCon_) {
//        isExpertCon_ = [self getNewRequestCon:NO];
//    }
//    
//    [self startLoad:isExpertCon_];
    
    

    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)refreshLoad:(RequestCon *)con
{
    [self checkLogin];
    [super refreshLoad:con];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getUserInfo:[Manager getUserInfo].userId_];
    if (!infoCon_) {
        infoCon_ = [self getNewRequestCon:NO];
    }
    [infoCon_ getResumePhotoAndVoice:[Manager getUserInfo].userId_];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_Image:
            break;
        case Request_UserInfo:
        {
            User_DataModal *userModal = [dataArr objectAtIndex:0];
            myDataModal_ = userModal;
            User_DataModal *defaultModal = [Manager getUserInfo];
            defaultModal.uname_ = userModal.uname_;
            defaultModal.name_ = userModal.name_;
            defaultModal.motto_ = userModal.motto_;
            defaultModal.identity_ = userModal.identity_;
            //defaultModal.groupsCreateCnt_ = userModal.groupsCreateCnt_;
        
            if( ![defaultModal.img_ isEqualToString:userModal.img_] ){
                //图像被更改了
                defaultModal.img_ = userModal.img_;
                defaultModal.imageData_ = nil;

            }

        }
            break;
        case Request_isExpert:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [identifyImg_ setImage:[UIImage imageNamed:@"bg__esperts"]];
                [Manager getUserInfo].isExpert_ = YES;
            }
            else{
                [identifyImg_ setImage:Nil];
                [Manager getUserInfo].isExpert_ = NO;
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
    [meImageview_ setHidden:YES];
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
    isplay_ = @"1";

    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:fileModel_.wavPath_]){
        return;
    }
    
    index_ = 1;
    player = [player initWithContentsOfURL:[NSURL URLWithString:fileModel_.wavPath_] error:nil];
    player.delegate = self;
    player.currentTime = 0;
    [player play];
    [self changeVoiceImage];
}

- (void)changeVoiceImage
{
    if (index_ >3) {
        index_ = 1;
    }
    if (!player.isPlaying) {
        isplay_ = @"0";
    }
    if ([isplay_ isEqualToString:@"0"]) {
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
    isplay_ = @"0";
}

-(void)showNoDataOkView:(BOOL)flag
{
    [super showNoDataOkView:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 8)];
    view.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    return view;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cnt = 0;
    if( section == 0 ){
        cnt = 4;
    }else if( section == 1 ){
        cnt = 2;
    }
    else if (section == 2){
        cnt = 1;
    }
    return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    
    MyCenterCtl_Cell *cell = (MyCenterCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCtl_Cell" owner:self options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLb_.text = @"";
    [cell.textLb_ setFont:FIFTEENFONT_TITLE];
    [cell.textLb_ setTextColor:DARKBLACKCOLOR];
    [cell.coutLb setFont:FIFTEENFONT_TITLE];
    [cell.coutLb setTextColor:GRAYCOLOR];
    [cell.coutLb setHidden:YES];
    if( indexPath.section == 0 ){
        if (indexPath.row == 0) {
            cell.textLb_.text = [NSString stringWithFormat:@"我的发表"];
            [cell.coutLb setText:[NSString stringWithFormat:@"(%ld)",(long)myDataModal_.publishCnt_]];
            [cell.coutLb setHidden:NO];
            [cell.img_ setImage:[UIImage imageNamed:@"ico_mypublish.png"]];
        }
        else if(indexPath.row == 1)
        {
            cell.textLb_.text = @"我的简历";
            [cell.img_ setImage:[UIImage imageNamed:@"ico_resume.png"]];
        }else if(indexPath.row == 2){
            cell.textLb_.text = [NSString stringWithFormat:@"关注企业"];
            [cell.coutLb setText:[NSString stringWithFormat:@"(%ld)",(long)myDataModal_.companyAttenCnt_]];
            [cell.coutLb setHidden:NO];
            [cell.img_ setImage:[UIImage imageNamed:@"ico_myattention.png"]];
        }
        else if (indexPath.row == 3){
            cell.textLb_.text = [NSString stringWithFormat:@"关注学校"];
            [cell.img_ setImage:[UIImage imageNamed:@"icon_myxuexiao"]];
            [cell.lineImg_ setHidden:YES];
        }
    }else if( indexPath.section == 1 ){
        if( indexPath.row == 2 ){
            cell.textLb_.text = @"我的私信";
            [cell.img_ setImage:[UIImage imageNamed:@"icon_私信36"]];
            
        }else if( indexPath.row == 0 ){
            cell.textLb_.text = [NSString stringWithFormat:@"我的提问"];
            [cell.coutLb setText:[NSString stringWithFormat:@"(%ld)",(long)myDataModal_.questionCnt_]];
            [cell.coutLb setHidden:NO];
            [cell.img_ setImage:[UIImage imageNamed:@"ico_myquestion.png"]];
            
        }
        else if (indexPath.row == 1){
            cell.textLb_.text = [NSString stringWithFormat:@"我的回答"];
            [cell.coutLb setText:[NSString stringWithFormat:@"(%ld)",(long)myDataModal_.answerCnt_]];
            [cell.coutLb setHidden:NO];
            [cell.img_ setImage:[UIImage imageNamed:@"ico_myanswer.png"]];
            [cell.lineImg_ setHidden:YES];
        }
    }
    else if(indexPath.section == 2)
    {
        cell.textLb_.text = @"通用设置";
        [cell.img_ setImage:[UIImage imageNamed:@"ico_set"]];
        cell.lineImg_.alpha = 0.0;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
}

-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    //记录友盟统计模块使用数
    NSDictionary * dict = @{@"Function":@"我"};
    [MobClick event:@"personused" attributes:dict];
    [self stopVoice];
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            if (!myPublishCtl_) {
                myPublishCtl_ = [[MyPubilshCtl alloc] init];
                
            }
            [self.navigationController pushViewController:myPublishCtl_ animated:YES];
            [myPublishCtl_ beginLoad:nil exParam:nil];
        }else if (indexPath.row == 1){
            if (![Manager shareMgr].resumeCenterCtl_) {
                [Manager shareMgr].resumeCenterCtl_ = [[ResumeCenterCtl alloc] init];
            }
            [[Manager shareMgr].centerNav_ pushViewController:[Manager shareMgr].resumeCenterCtl_ animated:YES];
            [[Manager shareMgr].resumeCenterCtl_ setNewBadge:NO];
            [[Manager shareMgr].resumeCenterCtl_ beginLoad:nil exParam:nil];
        }else if (indexPath.row == 2){
            AttentionCompanyListCtl *attentionListCtl = [[AttentionCompanyListCtl alloc]init];
            [self.navigationController pushViewController:attentionListCtl animated:YES];
            [attentionListCtl beginLoad:nil exParam:nil];
        }
        else if (indexPath.row == 3)
        {
            MySchollCtl *schoolCtl = [[MySchollCtl alloc]init];
            [self.navigationController pushViewController:schoolCtl animated:YES];
            [schoolCtl beginLoad:nil exParam:nil];
        }
    }
    else if( indexPath.section == 1 ){
        if ( indexPath.row == 0 )
        {
            if (![Manager shareMgr].myAskQuestionCtl_) {
                [Manager shareMgr].myAskQuestionCtl_ = [[MyAskQuestionCtl alloc] init];
            }
            [self.navigationController pushViewController:[Manager shareMgr].myAskQuestionCtl_ animated:YES];
            [[Manager shareMgr].myAskQuestionCtl_ beginLoad:nil exParam:nil];
        }
        else if (indexPath.row == 1){
            if (![Manager shareMgr].myAnswerCenterCtl_) {
                [Manager shareMgr].myAnswerCenterCtl_ = [[MyAnswerCenterCtl alloc] init];
            }
            [self.navigationController pushViewController:[Manager shareMgr].myAnswerCenterCtl_ animated:YES];
            [[Manager shareMgr].myAnswerCenterCtl_ beginLoad:nil exParam:nil];
        }
    }
    else if (indexPath.section == 2)
    {
        if( ![Manager shareMgr].setCtl_ ){
            [Manager shareMgr].setCtl_ = [[SetCtl alloc] init];
        }
        [Manager shareMgr].registeType_ = FromMore;
        [[Manager shareMgr].centerNav_ pushViewController:[Manager shareMgr].setCtl_ animated:YES];
        [[Manager shareMgr].setCtl_ beginLoad:nil exParam:nil];
    }
    

}

-(void)showLoginCtl:(NoLoginCtl *)ctl
{
    [[Manager shareMgr] loginOut];
}

-(void)btnResponse:(id)sender
{
    //记录友盟统计模块使用数

    NSDictionary * dict = @{@"Function":@"我"};
    [MobClick event:@"personused" attributes:dict];
    
    User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:0];
    if (sender == detailBtn_) {
            [self stopVoice];
//        if (!userInfoCtl_) {
//            userInfoCtl_ = [[UserInfoCtl alloc] init];
//        }
//        User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:0];
//        [self.navigationController pushViewController:userInfoCtl_ animated:YES];
//        [userInfoCtl_ beginLoad:dataModal exParam:nil];
        Expert_DataModal * expertModal = [[Expert_DataModal alloc] init];
        expertModal.id_ = dataModal.userId_;
        expertModal.goodat_ = dataModal.zym_;
        expertModal.job_ = dataModal.zye_;
        expertModal.signature_ = dataModal.motto_;
        expertModal.iname_ = dataModal.name_;
        expertModal.img_ = dataModal.img_;
        expertModal.imageData_ = dataModal.imageData_;
        expertModal.isExpert_ = dataModal.isExpert_;
        expertModal.publishCnt_ = dataModal.publishCnt_;
        expertModal.answerCnt_ = dataModal.answerCnt_;
        expertModal.groupsCreateCnt_ = dataModal.groupsCreateCnt_;
        
        ExpertDetailCtl * detailCtl = [[ExpertDetailCtl alloc] init];
        detailCtl.isMine_ = YES;
        detailCtl.delegate_ = self;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:expertModal  exParam:nil];
    }
    if (sender == asscBtn_) {
            [self stopVoice];
        if (dataModal.groupsCnt_ == 0) {
            return;
        }
        if (![Manager shareMgr].myGroupCtl_) {
            [Manager shareMgr].myGroupCtl_ = [[MyGroupsCtl alloc] init];
            
        }
        [Manager shareMgr].myGroupCtl_.type_ = 2;
        [self.navigationController pushViewController:[Manager shareMgr].myGroupCtl_ animated:YES];
        [[Manager shareMgr].myGroupCtl_ beginLoad:nil exParam:nil];
        [[Manager shareMgr].myGroupCtl_ refresh];
    }
    if (sender == publishBtn_) {
            [self stopVoice];
        if (dataModal.publishCnt_ == 0) {
            return;
        }
        if (!myPublishCtl_) {
            myPublishCtl_ = [[MyPubilshCtl alloc] init];
            
        }
        [self.navigationController pushViewController:myPublishCtl_ animated:YES];
        [myPublishCtl_ beginLoad:nil exParam:nil];
    }
    if (sender == followBtn_) {
            [self stopVoice];
        if (dataModal.followCnt_ == 0) {
            return;
        }
//        if (!myFollowerCtl_) {
//            myFollowerCtl_ = [[MyFollowerCtl alloc] init];
//        }
       MyFollowerCtl *followerCtl_ = [[MyFollowerCtl alloc] init];

        followerCtl_.delegate_ = self;
        [self.navigationController pushViewController:followerCtl_ animated:YES];
        [followerCtl_ beginLoad:@"1" exParam:nil];
        
    }
    if (sender == fansBtn_) {
            [self stopVoice];
        if (dataModal.fansCnt_ == 0) {
            return;
        }
//        if (!myFollowerCtl_) {
//            myFollowerCtl_ = [[MyFollowerCtl alloc] init];
//        }
//        MyFollowerCtl *followerCtl_ = [[MyFollowerCtl alloc] init];
//        
//        [self.navigationController pushViewController:followerCtl_ animated:YES];
//        [followerCtl_ beginLoad:@"2" exParam:nil];
        
        //谁关注了我列表
        MyAudienceListCtl *audienceListCtl = [[MyAudienceListCtl alloc]init];
        [self.navigationController pushViewController:audienceListCtl animated:YES];
        [audienceListCtl beginLoad:nil exParam:nil];
    }
    if (sender == playBtn_) {
        if ([isplay_ isEqualToString:@"1"]) {
            [self stopVoice];
        }else{
            [self voicePlay];
        }
    }
}

- (void)stopVoice
{
    if ([isplay_ isEqualToString:@"1"]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [playBtn_ setImage:[UIImage imageNamed:@"bton_yuyinbofang1.png"] forState:UIControlStateNormal];
        [player stop];
        isplay_ = @"0";
    }

}
-(void)pushToMyPublish
{
    if (!myPublishCtl_) {
        myPublishCtl_ = [[MyPubilshCtl alloc] init];
        
    }
    if ([Manager shareMgr].centerNav_.topViewController!=myPublishCtl_ ) {
        [self.navigationController pushViewController:myPublishCtl_ animated:YES];
    }
    
    [myPublishCtl_ beginLoad:nil exParam:nil];
}

-(void)pushToMyGroups
{
    if (![Manager shareMgr].myGroupCtl_) {
        [Manager shareMgr].myGroupCtl_ = [[MyGroupsCtl alloc] init];
        
    }
    [Manager shareMgr].myGroupCtl_.type_ = 2;
    if ([Manager shareMgr].centerNav_.topViewController != [Manager shareMgr].myGroupCtl_) {
        [self.navigationController pushViewController:[Manager shareMgr].myGroupCtl_ animated:YES];
    }
    
    [[Manager shareMgr].myGroupCtl_ beginLoad:nil exParam:nil];
}

-(void)pushToMyFans
{
    if (!myFollowerCtl_) {
        myFollowerCtl_ = [[MyFollowerCtl alloc] init];
    }
    [self.navigationController pushViewController:myFollowerCtl_ animated:YES];
    [myFollowerCtl_ beginLoad:@"2" exParam:nil];
}



#pragma MyFollowerCtlDelegate
-(void)followSuccess:(int)status
{
//    User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:0];
//    if (status == 1) {
//        ++dataModal.followCnt_;
//    }
//    else if(status == 2){
//        --dataModal.followCnt_;
//    }
//    follCntLb_.text = [NSString stringWithFormat:@"%d",dataModal.followCnt_];
}



-(void)checkLogin
{
    if (![Manager shareMgr].haveLogin) {
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    else
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn_];
}


#pragma FollowNotification
-(void)addFollowCnt:(NSNotification*)notification
{
    User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:0];
    ++dataModal.followCnt_;
    follCntLb_.text = [NSString stringWithFormat:@"%ld",(long)dataModal.followCnt_];
}

-(void)minusFollowCnt:(NSNotification*)notification
{
    User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:0];
    if (dataModal.followCnt_ > 0) {
         --dataModal.followCnt_;
    }
    follCntLb_.text = [NSString stringWithFormat:@"%ld",(long)dataModal.followCnt_];
}

- (void)photoChang
{
    [self refreshLoad:nil];
}

- (void)voiceChangSuccess
{
    [self refreshLoad:nil];
}


-(void)followOk:(ExpertDetailCtl *)ctl
{
    
}
@end
