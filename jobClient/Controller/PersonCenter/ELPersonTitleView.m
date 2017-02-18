//
//  ELPersonTitleView.m
//  jobClient
//
//  Created by 一览iOS on 16/10/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELPersonTitleView.h"
#import "RecordViewCtl.h"
#import "PersonCenterDataModel.h"
#import "EditorBasePersonInfoCtl.h"
#import "MyDelegateCtl.h"
#import "CustomTagButton.h"
#import "ELMyRewardRecordListCtl.h"
#import "RewardAmountCtl.h"
#import "ELPersonCenterCtl.h"
#import "AlbumListCtl.h"
#import "NSString+URLEncoding.h"
#import "ASIHTTPRequest.h"

static int MARGIN_LEFT = 5;
static int MARGIN_TOP = 8;

@interface ELPersonTitleView() <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVAudioPlayerDelegate,LogoPhotoSelectCtlDelegate,EditorBasePersonInfoCtlDelegate,RecordViewCtlDelegate,NoLoginDelegate>
{
    
    UIButton          *voicePlayBtn_;
    UILabel           *voiceTimeLb_;
    UIView            *voicePlayView_;
    UIButton          *voiceBtn_;
    UIImageView       *playImgView_;

    TransparencyView *transparency_;
    RecordViewCtl *recordCtl_;  //语音录制页面
    BOOL _toLoginFlag;
    BOOL isplay_;
    NSInteger index_;
    AVAudioPlayer *player;
    ASINetworkQueue *queue;

    
    CGRect frame_first;  //头像放大frame
    UIImageView *fullImageView;
    UIImageView       *photoImgv_;
    UIImageView *realNameImage; //实名认证图标
    UIView *headView;  //姓名头衔View
    UIImageView *expertImage;
    UILabel *personNameLb;
    UIImageView *titleBlackImage;//顶部导航栏背景图
    UILabel *jobLb;
    UIView *beGoodView; //擅长领域View
    UIView *countView; //约谈、关注、问答个数View
    UIButton *yuetanBtn;
    UIButton *questCountBtn;
    UIButton *followCountBtn;
    UILabel *yuetanLb;
    UILabel *followLb;
    UILabel *questionLb;
    UIImageView *yuetanImage;
    UIImageView *questionImage;
    UIImageView *followImage;
    UIView *dashangView; //打赏View
    UIButton *editorBtn; //编辑资料按钮
    BOOL isBtnClick;
    UIView *hideStatuBarView;
    UIView *ageBackView;
    UIView *followLineImg;
    BOOL isLoadComment;
    UIView *actionSheetView;  //自己的主页点击头像弹出的选择View
    UILabel *beGoodTradeLb;
    UIImageView *jobLableOne; //职导经纪人、发展导师标签
    UIImageView *jobLableTwo; //职导经纪人、发展导师标签
}
@end

@implementation ELPersonTitleView

-(instancetype)init{
    self = [super init];
    if (self) {
        CGFloat width = ScreenWidth;
        self.backgroundColor = [UIColor clearColor];
        
        voiceBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn_.frame = CGRectMake(width-65,165,31,31);
        [voiceBtn_ setImage:[UIImage imageNamed:@"recordIntever"] forState:UIControlStateNormal];
        [voiceBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        voiceBtn_.hidden = YES;
        [self addSubview:voiceBtn_];
        
        voicePlayView_ = [[UIView alloc] initWithFrame:CGRectMake(width-65,165,60,30)];
        voicePlayView_.backgroundColor = [UIColor clearColor];
        voicePlayView_.hidden = YES;
        [self addSubview:voicePlayView_];
        
        playImgView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,30)];
        playImgView_.image = [UIImage imageNamed:@"voicePlayNormal"];
        [voicePlayView_ addSubview:playImgView_];
        
        voicePlayBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        voicePlayBtn_.frame = CGRectMake(0,0,60,30);
        [voicePlayBtn_ setTitle:@"" forState:UIControlStateNormal];
        [voicePlayBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [voicePlayView_ addSubview:voicePlayBtn_];
        
        voiceTimeLb_ = [[UILabel alloc] initWithFrame:CGRectMake(30,4,26,21)];
        voiceTimeLb_.font = [UIFont systemFontOfSize:13];
        voiceTimeLb_.textColor = [UIColor whiteColor];
        voiceTimeLb_.textAlignment = NSTextAlignmentCenter;
        [voicePlayView_ addSubview:voiceTimeLb_];
        
        headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,60)];
        headView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headView];
        
        ageBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,120,22)];
        [headView addSubview:ageBackView];
        
        expertImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4,13,14)];
        expertImage.image = [UIImage imageNamed:@"expertsmark"];
        [ageBackView addSubview:expertImage];
    
        personNameLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 1,62,21)];
        personNameLb.font = SEVENTEENFONT_FRISTTITLE;
        personNameLb.textColor = [UIColor blackColor];
        [ageBackView addSubview:personNameLb];
        
        jobLb = [[UILabel alloc] initWithFrame:CGRectMake(0,25,width,18)];
        jobLb.font = ELEVEN_TIME;
        jobLb.textColor = [UIColor blackColor];
        jobLb.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:jobLb];
        
        beGoodTradeLb = [[UILabel alloc] initWithFrame:CGRectMake(0,42,width,18)];
        beGoodTradeLb.font = ELEVEN_TIME;
        beGoodTradeLb.textColor = [UIColor blackColor];
        beGoodTradeLb.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:beGoodTradeLb];
        
        beGoodView = [[UIView alloc] initWithFrame:CGRectMake(0,256,width,25)];
        beGoodView.backgroundColor = [UIColor whiteColor];
        [self addSubview:beGoodView];
        
        countView = [[UIView alloc] initWithFrame:CGRectMake(0,280,width,40)];
        [self addSubview:countView];
        
        yuetanLb = [[UILabel alloc] initWithFrame:CGRectMake(32,5,80,20)];
        yuetanLb.font = ELEVEN_TIME;
        yuetanLb.textColor = UIColorFromRGB(0xaaaaaa);
        [countView addSubview:yuetanLb];
        
        questionLb = [[UILabel alloc] initWithFrame:CGRectMake(32,5,80,20)];
        questionLb.font = ELEVEN_TIME;
        questionLb.textColor = UIColorFromRGB(0xaaaaaa);
        [countView addSubview:questionLb];
        
        followLb = [[UILabel alloc] initWithFrame:CGRectMake(32,5,80,20)];
        followLb.font = ELEVEN_TIME;
        followLb.textColor = UIColorFromRGB(0xaaaaaa);
        [countView addSubview:followLb];
        
        yuetanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yuetanBtn.frame = CGRectMake(0,0,80,40);
        [yuetanBtn setTitle:@"" forState:UIControlStateNormal];
        [yuetanBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:yuetanBtn];
    
        questCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        questCountBtn.frame = CGRectMake(0,0,80,40);
        [questCountBtn setTitle:@"" forState:UIControlStateNormal];
        [questCountBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:questCountBtn];
        
        followCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followCountBtn.frame = CGRectMake(0,0,80,40);
        [followCountBtn setTitle:@"" forState:UIControlStateNormal];
        [followCountBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [countView addSubview:followCountBtn];
        
        yuetanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,7,13,13)];
        yuetanImage.image = [UIImage imageNamed:@"yuetangeshu"];
        [countView addSubview:yuetanImage];
        
        questionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,7,13,13)];
        questionImage.image = [UIImage imageNamed:@"questioncount"];
        [countView addSubview:questionImage];
        
        followImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,7,13,13)];
        followImage.image = [UIImage imageNamed:@"followcount"];
        [countView addSubview:followImage];
        
        dashangView = [[UIView alloc] initWithFrame:CGRectMake(0,318,width,40)];
        [self addSubview:dashangView];
        [dashangView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,0,width,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
        
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(width-20,16,6,9)];
        rightImage.image = [UIImage imageNamed:@"rightarrow"];
        [dashangView addSubview:rightImage];
        
        UILabel *dashangLb = [[UILabel alloc] initWithFrame:CGRectMake(188,10,96,21)];
        dashangLb.tag = 300;
        dashangLb.font = ELEVEN_TIME;
        dashangLb.textColor = UIColorFromRGB(0xaaaaaa);
        [dashangView addSubview:dashangLb];
        
        for (NSInteger i = 0;i<5;i++) {
            UIImageView *dashangImage = [[UIImageView alloc] initWithFrame:CGRectMake(10+(35*i),6,30,30)];
            dashangImage.tag = 220+i;
            [dashangView addSubview:dashangImage];
        }
        
        editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editorBtn.frame = CGRectMake(width-75,208,70,18);
        [editorBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        editorBtn.titleLabel.font = ELEVEN_TIME;
        [editorBtn setTitle:@" 编辑资料" forState:UIControlStateNormal];
        [editorBtn setImage:[UIImage imageNamed:@"icon_zhuye_13bianji"] forState:UIControlStateNormal];
        editorBtn.hidden = YES;
        [editorBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editorBtn];
        
        jobLableOne = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,67,20)];
        [self addSubview:jobLableOne];
        
        jobLableTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0,88,67,20)];
        [self addSubview:jobLableTwo];
        
        photoImgv_ = [[UIImageView alloc] initWithFrame:CGRectMake(130,168,60,60)];
        [self addSubview:photoImgv_];
        
        realNameImage = [[UIImageView alloc] initWithFrame:CGRectMake(179,173,19,14)];
        realNameImage.image = [UIImage imageNamed:@"realnamesametrade"];
        realNameImage.hidden = YES;
        [self addSubview:realNameImage];
        
        photoImgv_.userInteractionEnabled = YES;
        photoImgv_.clipsToBounds = YES;
        photoImgv_.layer.borderWidth = 1.0;
        photoImgv_.layer.borderColor = [UIColor whiteColor].CGColor;
        photoImgv_.layer.cornerRadius = 10.0;
        photoImgv_.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [photoImgv_ addGestureRecognizer:tapGesture];
        
        CGFloat backHeight = (ScreenWidth*200)/320;
        photoImgv_.frame = CGRectMake((ScreenWidth-60)/2,backHeight-30,60,60);
        voicePlayView_.frame = CGRectMake(ScreenWidth-65,backHeight-35,60,30);
        editorBtn.frame = CGRectMake(ScreenWidth-75,backHeight+8,67,18);
        voiceBtn_.frame = CGRectMake(ScreenWidth-65,backHeight-35,30,30);
        
        UITapGestureRecognizer *tapDs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDashangList:)];
        [dashangView addGestureRecognizer:tapDs];
        headView.hidden = YES;
        beGoodView.hidden = YES;
        countView.hidden = YES;
        dashangView.hidden = YES;
        photoImgv_.hidden = YES;
        editorBtn.hidden = YES;

    }
    return self;
}

-(void)setPersonCenterModel_:(PersonCenterDataModel *)personCenterModel_{
    _personCenterModel_ = personCenterModel_;
    [self loadFinshFreshView];
    if(_isMyCenter_){
        editorBtn.hidden = NO;
    }else{
        editorBtn.hidden = YES;
    }
    beGoodView.hidden = NO;
    countView.hidden = NO;
    dashangView.hidden = NO;
    headView.hidden = NO;
    photoImgv_.hidden = NO;
    
    if ([personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
    {
        voicePlayView_.hidden = YES;
        voiceBtn_.hidden = YES;
    }
    else
    {
        if (_isMyCenter_)
        {
            if (personCenterModel_.voiceModel_.serverFilePath_ != nil) {
                //语音存在
                [voicePlayView_ setHidden:NO];
                [voiceBtn_ setHidden:YES];
                [voiceTimeLb_ setText:[NSString stringWithFormat:@"%@\"",personCenterModel_.voiceModel_.duration_]];
            }else{
                [voicePlayView_ setHidden:YES];
                [voiceBtn_ setHidden:NO];
#pragma mark - 设置为录制语音
                [voiceBtn_ setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
            }
        }else{
            if (personCenterModel_.voiceModel_.serverFilePath_ != nil) {
                [voicePlayView_ setHidden:NO];
                [voiceBtn_ setHidden:YES];
                [voiceTimeLb_ setText:[NSString stringWithFormat:@"%@\"",personCenterModel_.voiceModel_.duration_]];
            }else{
                [voicePlayView_ setHidden:YES];
                [voiceBtn_ setHidden:NO];
#pragma mark - 设置为邀请录制语音
                [voiceBtn_ setImage:[UIImage imageNamed:@"recordIntever.png"] forState:UIControlStateNormal];
            }
        }
        
    }
#pragma mark - 用户头像
    
    if (personCenterModel_.userModel_.img_ == nil || [personCenterModel_.userModel_.img_ isEqualToString:@"http://img.job1001.com/myUpload/pic.gif"] )
    {
        [photoImgv_ sd_setImageWithURL:[NSURL URLWithString:@"http://img.job1001.com/myUpload/pic.gif"] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        
    }else
    {
        photoImgv_.contentMode = UIViewContentModeScaleAspectFill;
        [photoImgv_ sd_setImageWithURL:[NSURL URLWithString:personCenterModel_.userModel_.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
#pragma mark - 职业经纪人、规划规划师
    if ([personCenterModel_.userModel_.is_jjr isEqualToString:@"1"] && [personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
    {
        jobLableOne.hidden = NO;
        jobLableTwo.hidden = NO;
        jobLableOne.image = [UIImage imageNamed:@"zhiyejingjiren"];
        jobLableTwo.image = [UIImage imageNamed:@"zhiyefazhandaoshi"];
        jobLableOne.frame = CGRectMake(0,65,67,20);
        jobLableTwo.frame = CGRectMake(0,88,75,20);
    }
    else if([personCenterModel_.userModel_.is_jjr isEqualToString:@"1"])
    {
        jobLableOne.hidden = NO;
        jobLableTwo.hidden = YES;
        jobLableOne.image = [UIImage imageNamed:@"zhiyejingjiren"];
        jobLableOne.frame = CGRectMake(0,65,67,20);
    }
    else if ([personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
    {
        jobLableOne.hidden = NO;
        jobLableTwo.hidden = YES;
        jobLableOne.image = [UIImage imageNamed:@"zhiyefazhandaoshi"];
        jobLableOne.frame = CGRectMake(0,65,75,20);
    }
    else
    {
        jobLableOne.hidden = YES;
        jobLableTwo.hidden = YES;
    }
    
#pragma mark - 实名认证图标显示判断
    realNameImage.frame = CGRectMake(CGRectGetMaxX(photoImgv_.frame)-9,CGRectGetMaxY(photoImgv_.frame)-14,21,14);
    realNameImage.hidden = NO;
    if ([personCenterModel_.userModel_.is_shiming isEqualToString:@"1"])
    {
        realNameImage.image = [UIImage imageNamed:@"yes_realname_image"];
    }
    else{
        realNameImage.image = [UIImage imageNamed:@"no_realname_image"];
    }
    
    if (personCenterModel_.userModel_.zw_.length > 0) {
        jobLb.text = personCenterModel_.userModel_.zw_;
    }
    else
    {
        jobLb.text = personCenterModel_.userModel_.job_;
    }
    
    CGRect headF = headView.frame;
    headF.origin.y = CGRectGetMaxY(photoImgv_.frame);
    _headMinY = headF.origin.y;
    if (personCenterModel_.userModel_.good_at.length > 0)
    {
        
        beGoodTradeLb.text = [NSString stringWithFormat:@"擅长领域：%@",personCenterModel_.userModel_.good_at];
    }
    else
    {
        beGoodTradeLb.text = [NSString stringWithFormat:@"擅长领域：未填写"];
    }
    headView.frame = headF;
    
    [self refreshSelectedTag];
    CGFloat startY = CGRectGetMaxY(beGoodView.frame);
    
#pragma mark - 约谈、关注、问答个数
    NSInteger followCnt = personCenterModel_.userModel_.fansCnt_;
    if (personCenterModel_.userModel_.yuetabCnt_ > 0 || personCenterModel_.userModel_.questionCnt_>0 || followCnt >0 || personCenterModel_.userModel_.wtc_cnt > 0)
    {
        countView.hidden = NO;
        countView.frame = CGRectMake(0,startY,ScreenWidth,25);
        NSString *yuetanStr = @"";
        NSString *string1 = @"";
        if (personCenterModel_.userModel_.wtc_cnt > 0) {
            yuetanStr = [NSString stringWithFormat:@"%ld",(long)personCenterModel_.userModel_.wtc_cnt];
            string1 = [NSString stringWithFormat:@"%@人已委托",yuetanStr];
            yuetanImage.image = [UIImage imageNamed:@"icon_zhuye_weituo"];
        }
        else
        {
            yuetanStr = [NSString stringWithFormat:@"%ld",(long)personCenterModel_.userModel_.yuetabCnt_];
            string1 = [NSString stringWithFormat:@"%@人已约谈",yuetanStr];
            yuetanImage.image = [UIImage imageNamed:@"yuetangeshu"];
        }
        
        NSString *questionStr = [NSString stringWithFormat:@"%ld",(long)personCenterModel_.userModel_.questionCnt_];
        NSString *followStr = [NSString stringWithFormat:@"%ld",(long)followCnt];
        
        NSString *string = [NSString stringWithFormat:@"%@次回答",questionStr];
        NSString *string2 = [NSString stringWithFormat:@"%@人已关注",followStr];
        
        CGFloat floatX = 10;
        if (personCenterModel_.userModel_.yuetabCnt_ > 0 || personCenterModel_.userModel_.wtc_cnt > 0)
        {
            CGSize size = [string1 sizeNewWithFont:yuetanLb.font];
            yuetanImage.hidden = NO;
            yuetanBtn.hidden = NO;
            yuetanLb.hidden = NO;
            yuetanBtn.frame = CGRectMake(floatX,0,size.width+20,40);
            
            yuetanImage.frame = CGRectMake(CGRectGetMinX(yuetanBtn.frame),4,13,13);
            
            floatX = CGRectGetMaxX(yuetanBtn.frame)+10;
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:string1];
            [str1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe13e3e) range:NSMakeRange(0,yuetanStr.length)];
            
            yuetanLb.frame = CGRectMake(CGRectGetMinX(yuetanBtn.frame)+15,0,size.width+5,20);
            [yuetanLb setAttributedText:str1];
            
        }
        else
        {
            yuetanImage.hidden = YES;
            yuetanBtn.hidden = YES;
            yuetanLb.hidden = YES;
        }
        if (personCenterModel_.userModel_.questionCnt_ > 0)
        {
            CGSize size = [string sizeNewWithFont:questionLb.font];
            
            questCountBtn.hidden = NO;
            questionLb.hidden = NO;
            questionImage.hidden = NO;
            questCountBtn.frame = CGRectMake(floatX,0,size.width+20,25);
            
            questionImage.frame = CGRectMake(CGRectGetMinX(questCountBtn.frame),4,13,13);
            
            floatX = CGRectGetMaxX(questCountBtn.frame)+10;
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:string];
            [str2 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe13e3e) range:NSMakeRange(0,questionStr.length)];
            
            questionLb.frame = CGRectMake(CGRectGetMinX(questCountBtn.frame)+15,0,size.width+5,20);
            [questionLb setAttributedText:str2];
            
        }
        else
        {
            questionImage.hidden = YES;
            questCountBtn.hidden = YES;
            questionLb.hidden = YES;
        }
        
        if (followCnt > 0)
        {
            CGSize size = [string2 sizeNewWithFont:followLb.font];
            followCountBtn.hidden = NO;
            followLb.hidden = NO;
            followImage.hidden = NO;
            followCountBtn.frame = CGRectMake(floatX,0,size.width+20,25);
            
            followImage.frame = CGRectMake(CGRectGetMinX(followCountBtn.frame),4,13,13);
            
            floatX = CGRectGetMaxX(followCountBtn.frame);
            NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:string2];
            [str3 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe13e3e) range:NSMakeRange(0,followStr.length)];
            
            followLb.frame = CGRectMake(CGRectGetMinX(followCountBtn.frame)+15,0,size.width+5,20);
            [followLb setAttributedText:str3];
            
        }
        else
        {
            followImage.hidden = YES;
            followCountBtn.hidden = YES;
            followLb.hidden = YES;
        }
    }
    else
    {
        countView.frame = CGRectMake(0,startY,ScreenWidth,0);
        countView.hidden = YES;
    }
    startY = CGRectGetMaxY(countView.frame);
    [self refreshDaShang];
    startY = CGRectGetMaxY(dashangView.frame);
    self.frame = CGRectMake(0,0,ScreenWidth,startY);
    
#pragma mark - 姓名、性别显示
    personNameLb.text = personCenterModel_.userModel_.iname_;
    float titleFrameX = 0;
    
    if (personCenterModel_.userModel_.isExpert_)
    {
        titleFrameX += 18;
        expertImage.hidden = NO;
    }
    else
    {
        expertImage.hidden = YES;
    }
    
    CGSize size = [personCenterModel_.userModel_.iname_ sizeNewWithFont:SEVENTEENFONT_FRISTTITLE constrainedToSize:CGSizeMake(200, 21)];
    
    CGRect  rect = personNameLb.frame;
    rect.size.width = size.width+5;
    rect.origin.x = titleFrameX;
    [personNameLb setFrame:rect];
    
    titleFrameX = CGRectGetMaxX(personNameLb.frame);
    rect = ageBackView.frame;
    rect.origin.x = (ScreenWidth-titleFrameX)/2;
    rect.size.width = titleFrameX;
    ageBackView.frame = rect;
}

-(void)setPersonImageWithUrl:(NSString *)url
{
     [photoImgv_ sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)refreshFollowLable:(NSInteger)count{
    NSString *followStr = [NSString stringWithFormat:@"%ld",(long)count];
    NSString *string2 = [NSString stringWithFormat:@"%@人已关注",followStr];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:string2];
    [str3 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe13e3e) range:NSMakeRange(0,followStr.length)];
    [followLb setAttributedText:str3];
}

#pragma mark - 打赏卡片刷新
-(void)refreshDaShang
{
    if (YES)
    {
        dashangView.hidden = NO;
        dashangView.frame = CGRectMake(0,CGRectGetMaxY(countView.frame),ScreenWidth,40);
        UILabel *lable = (UILabel *)[dashangView viewWithTag:300];
        if (_personCenterModel_.daShangPeopleArr.count > 0)
        {
            CGFloat lableX = 0;
            for (NSInteger i = 0; i<5; i++)
            {
                UIImageView *imageView = (UIImageView *)[dashangView viewWithTag:220+i];
                if (i<_personCenterModel_.daShangPeopleArr.count)
                {
                    imageView.hidden = NO;
                    imageView.clipsToBounds = YES;
                    imageView.layer.cornerRadius = 3.0;
                    personTagModel *model = _personCenterModel_.daShangPeopleArr[i];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:model.tagName_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
                    lableX = CGRectGetMaxX(imageView.frame) + 10;
                }
                else
                {
                    imageView.hidden = YES;
                }
            }
            
            lable.text = [NSString stringWithFormat:@"%@%ld次打赏",_personCenterModel_.userModel_.dashang_cnt > 5 ? @"等":@"",(long)_personCenterModel_.userModel_.dashang_cnt];
            CGRect frame = lable.frame;
            frame.origin.x = lableX;
            lable.frame = frame;
        }
        else
        {
            if (_isMyCenter_)
            {
                lable.text = @"还没有人打赏哦";
            }
            else
            {
                lable.text = @"你可成为第一位打赏TA的人哟";
            }
            CGRect frame = lable.frame;
            frame.origin.x = 10;
            frame.size.width = 200;
            lable.frame = frame;
            
        }
    }
    else
    {
        dashangView.hidden = YES;
        dashangView.frame = CGRectMake(0,CGRectGetMaxY(countView.frame),ScreenWidth,0);
    }
    
}

#pragma mark - 创建擅长领域卡片
- (void)refreshSelectedTag
{
    NSArray *subViews = beGoodView.subviews;
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    CGFloat lastX = 5;
    CGFloat lastY = 5;
    
    CGFloat maxX = 0;
    
    for (int i=0; i<_personCenterModel_.fieldListArray_.count; i++)
    {
        CustomTagButton *button = [[CustomTagButton alloc]init];
        button.userInteractionEnabled = NO;
        personTagModel *tag = _personCenterModel_.fieldListArray_[i];
        [button setTitle:tag.tagName_ forState:UIControlStateNormal];
        button.titleLabel.font = TWEELVEFONT_COMMENT;
        [button setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        button.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
        button.layer.borderWidth = 0.5;
        CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY width:ScreenWidth-40];
        button.frame = frame;
        [beGoodView addSubview:button];
        if (CGRectGetMaxX(frame) > maxX)
        {
            maxX = CGRectGetMaxX(frame);
        }
    }
    
    CGRect frame = beGoodView.frame;
    frame.origin.y = CGRectGetMaxY(headView.frame);
    frame.size.width = maxX + 10;
    frame.size.height = lastY + 30 +5;
    frame.origin.x = (ScreenWidth-maxX)/2;
    if (_personCenterModel_.fieldListArray_.count == 0)
    {
        frame.size.height = 0;
    }
    beGoodView.frame = frame;
}
#pragma mark 计算根据文字计算宽度 返回frame
-(CGRect) setButtonTitle:(NSString *)title button:(UIButton*) button lastX:(CGFloat *)lastX lastY:(CGFloat *)lastY width:(CGFloat)maxW
{
    CGSize titleSize = [title sizeNewWithFont:button.titleLabel.font];
    titleSize.height = 26;
    button.layer.cornerRadius = 13;
    titleSize.width += 20;
    if (*lastX + titleSize.width + MARGIN_LEFT> maxW) {
        *lastX = 0;
        *lastY += titleSize.height + MARGIN_TOP;
    }
    CGRect frame = CGRectMake(*lastX, *lastY, titleSize.width, titleSize.height);
    [button setFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    *lastX += titleSize.width + MARGIN_LEFT;
    return frame;
}


-(void)btnResponse:(id)sender
{
    if (sender == voiceBtn_)
    {
        if (_isMyCenter_) {
            if (!transparency_) {
                transparency_ = [[TransparencyView alloc]init];
            }
            if (!recordCtl_) {
                recordCtl_ = [[RecordViewCtl alloc]init];
            }
            recordCtl_.type = @"2";
            recordCtl_.delegate_ = self;
            [recordCtl_ beginLoad:_personCenterModel_.voiceModel_ exParam:nil];
            [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
            [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:recordCtl_.view];
            [recordCtl_ playVoiceWhenViewShow];  //有语音自动播放语音
        }else{
            //邀请完善语音
            if (![Manager shareMgr].haveLogin) {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
                return;
            }
            [_personDelegate sendInterviewRequest];
        }
    }else if (sender == voicePlayBtn_){
        if (_isMyCenter_) {
            if (!transparency_) {
                transparency_ = [[TransparencyView alloc]init];
            }
            if (!recordCtl_) {
                recordCtl_ = [[RecordViewCtl alloc]init];
            }
            recordCtl_.type = @"2";    //2表示个人中心   1表示简历中心
            recordCtl_.delegate_ = self;
            [recordCtl_ beginLoad:_personCenterModel_.voiceModel_ exParam:nil];
            [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:transparency_];
            [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:recordCtl_.view];
            [recordCtl_ playVoiceWhenViewShow];  //有语音自动播放语音
        }else{
            if (isplay_ == YES) {
                [self stopVoice];
            }else{
                [self voicePlay];
            }
        }
    }
    else if (sender == editorBtn)//编辑按钮
    {
        EditorBasePersonInfoCtl *editorCtl = [[EditorBasePersonInfoCtl alloc] init];
        editorCtl.delegate = self;
        [editorCtl beginLoad:_personCenterModel_ exParam:nil];
        [[Manager shareMgr].centerNav_ pushViewController:editorCtl animated:YES];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"编辑资料",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
    else if (sender == followCountBtn) //听众个数按钮
    {
        MyAudienceListCtl *listCtl = [[MyAudienceListCtl alloc]init];
        [listCtl beginLoad:@"2" exParam:nil];  //我的听众 2
        listCtl.isOthercenterFlag = !_isMyCenter_;
        listCtl.isMyCenter = YES;
        listCtl.hideDynamic = YES;
        listCtl.personModel = _personCenterModel_;
        [[Manager shareMgr].centerNav_ pushViewController:listCtl animated:YES];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"我的听众",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
    else if (sender == questCountBtn) //问答个数按钮
    {
        AnswerList_Ctl *ctl = [[AnswerList_Ctl alloc] init];
        ctl.formMyAnswer = YES;
        [ctl beginLoad:_userId_ exParam:nil];
        ctl.isMyCenter = _isMyCenter_;
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"我的问答",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
    else if (sender == yuetanBtn)
    {
        if(_isMyCenter_ && _personCenterModel_.userModel_.wtc_cnt > 0)
        {
            MyDelegateCtl *delegateCtl = [[MyDelegateCtl alloc]init];
            [[Manager shareMgr].centerNav_ pushViewController:delegateCtl animated:YES];
            [delegateCtl beginLoad:nil exParam:nil];
        }
    }
}

#pragma mark - 打赏列表跳转
-(void)tapDashangList:(UITapGestureRecognizer *)sender
{
    /*
     有人打赏跳打赏记录列表
     无人打赏登录情况下打赏列表
     */
    if (_personCenterModel_.daShangPeopleArr.count > 0)
    {
        ELMyRewardRecordListCtl *ctl = [[ELMyRewardRecordListCtl alloc] init];
        ctl.personId = _userId_;
        ctl.personImg = _personCenterModel_.userModel_.img_;
        
        [Manager shareMgr].dashangBackCtlIndex = [Manager shareMgr].centerNav_.viewControllers.count-1;
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
    }
    else
    {
        if ([Manager shareMgr].haveLogin)
        {
            if ([_personCenterModel_.userModel_.id_ isEqualToString:[Manager getUserInfo].userId_]) {
                ELMyRewardRecordListCtl *ctl = [[ELMyRewardRecordListCtl alloc] init];
                ctl.personId = _userId_;
                ctl.personImg = _personCenterModel_.userModel_.img_;
                
                [Manager shareMgr].dashangBackCtlIndex = [Manager shareMgr].centerNav_.viewControllers.count-1;
                [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
                [ctl beginLoad:nil exParam:nil];
            }
            else
            {
                RewardAmountCtl *rewardAmountCtl = [[RewardAmountCtl alloc] init];
                rewardAmountCtl.personPic = _personCenterModel_.userModel_.img_; 
                rewardAmountCtl.personId = _userId_;
                rewardAmountCtl.personName = _personCenterModel_.userModel_.iname_;
                rewardAmountCtl.productId = _userId_;   
                rewardAmountCtl.productType = @"30";
                [Manager shareMgr].dashangBackCtlIndex = [Manager shareMgr].centerNav_.viewControllers.count-1;
                [[Manager shareMgr].centerNav_ pushViewController:rewardAmountCtl animated:YES];
            }
            
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
            return;
        }
    }
}

#pragma mark - 用户头像点击事件
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    //修改头像
    if (_isMyCenter_)
    {
        //        [self customActionSheet];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看头像大图", @"拍照换头像", @"从相册选择新头像", nil];
        actionSheet.tag = 20000;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else{
        //点击变大
        [self showHeadPhoto];
    }
}

-(void)showHeadPhoto{
    frame_first = photoImgv_.frame;
    fullImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    fullImageView.backgroundColor = [UIColor blackColor];
    fullImageView.userInteractionEnabled = YES;
    [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
    fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (![fullImageView superview]) {
        fullImageView.image = photoImgv_.image;
        [[UIApplication sharedApplication].keyWindow addSubview:fullImageView];
        fullImageView.frame = frame_first;
        fullImageView.layer.cornerRadius = 46.0;
        fullImageView.layer.masksToBounds = YES;
        [UIView animateWithDuration:0.5 animations:^{
            fullImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            fullImageView.layer.cornerRadius = 0;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)actionTap2:(UITapGestureRecognizer *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        fullImageView.frame = frame_first;
        fullImageView.layer.cornerRadius = 46.0;
        fullImageView.layer.masksToBounds = YES;
    } completion:^(BOOL finished) {
        [fullImageView removeFromSuperview];
    }];
}

-(void)edtorBaseSuccess{
    [_personDelegate edtorBaseSuccess];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_PersonCenterRefresh:
        {
            if ([_personDelegate respondsToSelector:@selector(refreshData)]) {
                [_personDelegate refreshData];
            }
        }
            break;
        default:
            break;
    }
}

-(void)loginSuccess
{
    
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 20000) {
        switch (buttonIndex) {
            case 0:
            {
                //点击变大
               // [self showHeadPhoto]; 
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
                        [[Manager shareMgr].centerNav_ pushViewController:albumListCtl animated:YES];
                        [albumListCtl beginLoad:nil exParam:nil];
                        return;
                    }
                }
                
                // 跳转到相机或相册页面
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = sourceType;
                [[Manager shareMgr].centerNav_ presentViewController:imagePickerController animated:NO completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 20000){
        switch (buttonIndex) {
            case 0:
            {
                //点击变大
                [self showHeadPhoto]; 
                return;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - PhotoSelectCtlDelegate
- (void)hadFinishSelectPhoto:(NSArray *)imageArr{
    if (imageArr.count > 0)
    {
        @try {
            //base64编码上传头像
            UIImage *uploadImage = imageArr[0];
            NSData *imgData = UIImageJPEGRepresentation(uploadImage, 0.01);
            
            NSString *base64String = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] URLEncodedForString];;
            
            [_personDelegate updateLoadImageWithString:base64String];
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
        
        NSString *base64String = [[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] URLEncodedForString];
        [_personDelegate updateLoadImageWithString:base64String];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark - 语音

- (void)loadFinshFreshView
{
    //    [activity_ stopAnimating];
    _personCenterModel_.userModel_.id_ = _userId_;
    //下载语音
    if (_personCenterModel_.voiceModel_.serverFilePath_ != nil) {
        
        //如果是amr后缀，将地址修改
        NSString *houzuiStr = [[_personCenterModel_.voiceModel_.serverFilePath_ componentsSeparatedByString:@"."] lastObject];
        if ([houzuiStr isEqualToString:@"amr"]) {
            _personCenterModel_.voiceModel_.serverFilePath_ = [_personCenterModel_.voiceModel_.serverFilePath_ stringByReplacingOccurrencesOfString:@"audio" withString:@"audio_acc"];
            _personCenterModel_.voiceModel_.serverFilePath_ = [_personCenterModel_.voiceModel_.serverFilePath_ stringByReplacingOccurrencesOfString:@"amr" withString:@"aac"];
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
    NSString *fileName = [[_personCenterModel_.voiceModel_.serverFilePath_  componentsSeparatedByString:@"/"]lastObject];
    NSString *fileNameNoAmr = [[fileName componentsSeparatedByString:@"."]objectAtIndex:0];
    NSString *filePath = [VoiceRecorderBaseVC getPathByFileName:fileNameNoAmr ofType:@"aac"];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:filePath]) {
        //文件不存在
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_personCenterModel_.voiceModel_.serverFilePath_]];
        [request setDownloadDestinationPath:filePath];
        [queue addOperation:request];
        mark = YES;
    }
    _personCenterModel_.voiceModel_.wavPath_ = filePath;
    if (mark){
        [queue go];
    }else{
        [self finishOver:nil];
    }
}
- (void)finishOver:(ASINetworkQueue*)queue1 {
    
    
}

#pragma mark - 开始播放
-(void)voicePlay
{
    player = [[AVAudioPlayer alloc]init];
    isplay_ = NO;
    [self handleNotification:NO];
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                            sizeof(sessionCategory),
//                            &sessionCategory);
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
//                             sizeof (audioRouteOverride),
//                             &audioRouteOverride);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                    error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if (![fileManager fileExistsAtPath:_personCenterModel_.voiceModel_.wavPath_]){
        NSLog(@"文件不存在");
    }
    
    index_ = 1;
    
    player = [player initWithContentsOfURL:[NSURL URLWithString:_personCenterModel_.voiceModel_.wavPath_] error:nil];
    
    player.meteringEnabled = YES;
    
    player.delegate = self;
    player.currentTime = 0;
    
    [player play];
    isplay_ = YES;
    [self changeVoiceImage];
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

- (void)changeVoiceImage
{
    if (index_ >3) {
        index_ = 1;
    }
    if (isplay_ == NO) {
        [playImgView_ setImage:[UIImage imageNamed:@"voicePlayNormal.png"]];
        return;
    }
    [playImgView_ setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pvoicePlay%ld.png",(long)index_]]];
    index_ ++;
    [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
}

#pragma mark - 播放结束 AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self handleNotification:NO];
    isplay_ = NO;
}

-(void)stopVoice
{
    if (isplay_) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [playImgView_ setImage:[UIImage imageNamed:@"voicePlayNormal.png"]];
        [player stop];
        player = nil;
        isplay_ = NO;
    }
}

#pragma mark - RecordViewCtlDelegate

- (void)updateView:(VoiceFileDataModel *)fileModel
{
    _personCenterModel_.voiceModel_= fileModel;
    [self setPersonCenterModel_:_personCenterModel_];
}
#pragma mark - TransparencyViewDelegate
- (void)removeView
{
    [transparency_ removeFromSuperview];
}


@end
