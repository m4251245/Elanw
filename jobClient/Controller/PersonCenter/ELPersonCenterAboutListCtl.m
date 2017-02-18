//
//  ELPersonCenterAboutListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/11/30.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELPersonCenterAboutListCtl.h"
#import "PhotoListCtl.h"
#import "InterviewDataModel.h"
#import "CustomTagButton.h"
#import "AlbumListCtl.h"
#import "personTagModel.h"
#import "ELGoodTradeChangeTwoCtl.h"
#import "ELBeGoodAtTradeChangeCtl.h"
#import "InterViewListCtl.h"
#import "NoLoginPromptCtl.h"
#import "EditorBasePersonInfoCtl.h"
#import "LearnTechniqueCtl.h"
#import "EditorTagCtl.h"

static int MARGIN_TOP = 8;
static int MARGIN_LEFT = 5;

@interface ELPersonCenterAboutListCtl () <PhotoListCtlDelegate,ChangeGoodTradeDelegate,BeGoodAtChangeDelegate,EditorBasePersonInfoCtlDelegate,LearnTechniqueProtocol>
{
     UIView *workPlaceView;
    
     UIView *tradeView;
     UIView *bardianLableVIew;
    
     UIView *wantSkillView;
    
     UIView *jobSpeakView;
     UIView *introduceView;
     UIView *interviewViewOne;
     UIView *interviewViewTwo;
     UIView *interviewViewThree;
    
     UIView *moreInterviewView;
    
     UIButton *moreInterviewBtn;
    
     UIView *beGoodViewOne;
    
    PhotoListCtl *photoListCtl_;
    
    UIView *beGoodTradeView;
    
    BOOL isMyCenter_;
    
    PersonCenterDataModel *personCenterModel_;
    
    NSString *userId_;
    
    NSInteger changeLableType;
    
    NSString *goodAtId;

    RequestCon *updateTagsCon_;
    RequestCon *sendMessageCon_;
    
    NSArray *arrTagData;
}
@end

@implementation ELPersonCenterAboutListCtl


-(instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    workPlaceView = [self getTypeOneViewWithName:@"现工作地" type:1];
    tradeView = [self getTypeOneViewWithName:@"所属行业" type:1];
    bardianLableVIew = [self getTypeOneViewWithName:@"个性标签" type:2];
    wantSkillView = [self getTypeOneViewWithName:@"想学技能" type:2];
    jobSpeakView = [self getTypeOneViewWithName:@"职业宣言" type:1];
    introduceView = [self getTypeOneViewWithName:@"个人简介" type:1];
    interviewViewOne = [self getTypeOneViewWithName:@"小编专访" type:3];
    interviewViewTwo = [self getTypeOneViewWithName:@"" type:3];
    interviewViewThree = [self getTypeOneViewWithName:@"" type:3];
    beGoodViewOne = [self getTypeOneViewWithName:@"擅长技能" type:2];
    beGoodTradeView = [self getTypeOneViewWithName:@"擅长行业" type:1];
    
    moreInterviewView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    moreInterviewView.backgroundColor = [UIColor whiteColor];
    [self addSubview:moreInterviewView];
    
    moreInterviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreInterviewBtn.frame = CGRectMake(0,7,105,15);
    [moreInterviewBtn setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [moreInterviewBtn setTitle:@"更多访谈内容" forState:UIControlStateNormal];
    [moreInterviewBtn setTitleColor:UIColorFromRGB(0x007AFF) forState:UIControlStateNormal];
    moreInterviewBtn.titleLabel.font = FOURTEENFONT_CONTENT;
    moreInterviewBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,0);
    moreInterviewBtn.imageEdgeInsets = UIEdgeInsetsMake(0,95,0,0);
    [moreInterviewBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [moreInterviewView addSubview:moreInterviewBtn];
    moreInterviewBtn.center = moreInterviewView.center;
}

-(UIView *)getTypeOneViewWithName:(NSString *)name type:(NSInteger)type{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10,4,66,21)];
    lable.textColor = UIColorFromRGB(0x999999);
    lable.font = FOURTEENFONT_CONTENT;
    lable.text = name;
    [view addSubview:lable];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(81,4,211,21)];
    lable1.textColor = [UIColor blackColor];
    lable1.font = FOURTEENFONT_CONTENT;
    [view addSubview:lable1];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-20,11,6,9)];
    image.image = [UIImage imageNamed:@"rightarrow"];
    [view addSubview:image];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(70,0,ScreenWidth-70,1)];
    image1.image = [UIImage imageNamed:@"gg_home_line2"];
    
    if (![name isEqualToString:@"现工作地"]) {
       [view addSubview:image1];
    }
    if (type == 1){
        lable1.tag = 100;
        image.tag = 101;
        image1.tag = 102;
    }else if (type == 2){
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(80,7,ScreenWidth-110,15)];
        contentView.backgroundColor = [UIColor whiteColor];
        [view addSubview:contentView];
        lable1.textColor = UIColorFromRGB(0x007AFF);
        lable1.font = FOURTEENFONT_CONTENT;
        lable1.text = @"填写一下增加人气哦";
        contentView.tag = 100;
        image.tag = 101;
        image1.tag = 102;
        lable1.tag = 105;
    }else if (type == 3){
        UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(80,30,ScreenWidth-110,21)];
        contentLable.textColor = UIColorFromRGB(0x666666);
        contentLable.font = FOURTEENFONT_CONTENT;
        [view addSubview:contentLable];
        lable1.tag = 100;
        contentLable.tag = 101;
        image.tag = 102;
        image1.tag = 103;
    }
    return view;
}

-(void)showPicker:(id)picker
{
    if ([picker isKindOfClass:[UIImagePickerController class]])
    {
        [[Manager shareMgr].centerNav_ presentViewController:picker animated:NO completion:nil];
    }
    else if([picker isKindOfClass:[AlbumListCtl class]])
    {
        [[Manager shareMgr].centerNav_ pushViewController:picker animated:YES];
    }
}
#pragma mark - 邀请上传图片成功
- (void)inviteUpdateImageSuccess
{
    if (personCenterModel_.userModel_.followStatus_ == 0)
    {
        //        [focusOnBtn setImage:[UIImage imageNamed:@"ios_icon_ok"] forState:UIControlStateNormal];
        //        [focusOnBtn setTitle:@"已关注" forState:UIControlStateNormal];
        personCenterModel_.userModel_.followStatus_ = 1;
        [_aboutDelegate refreshAllLoad];
    }
}

- (void)changImageSuccess
{
    [self refreshAboutListView];
}

-(void)refreshAboutListView:(PersonCenterDataModel *)personModal isMyCenter:(BOOL)isCenter
{
    personCenterModel_ = personModal;
    isMyCenter_ = isCenter;
    [self refreshAboutListView];
}

#pragma mark - 加载关于TA列表
-(void)loadGuanYuTa:(NSString *)userId personModal:(PersonCenterDataModel *)modal isMyCenter:(BOOL)isMyCenter
{
    if (isMyCenter)
    {
        [self addTapAboutView];
    }
    personCenterModel_ = modal;
    isMyCenter_ = isMyCenter;
    userId_ = userId;
    NSString *personId = @"";
    if ([Manager getUserInfo].userId_.length > 0)
    {
        personId = [Manager getUserInfo].userId_;
    }
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId_ forKey:@"user_id"];
    [searchDic setObject:personId forKey:@"login_person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@",searchDicStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"salarycheck_all_new_busi" func:@"getUserzoneAbout" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         NSDictionary *dicOne = dic[@"data"];
         [personCenterModel_ giveDataDicAbout:dicOne.count>0 ?dicOne:dic];
         [self refreshAboutListView];
         [Manager shareMgr].userCenterModel = personCenterModel_;
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         
     }];
}

#pragma mark - 关于TA列表刷新
-(void)refreshAboutListView
{
    //职业风采照
    if (!photoListCtl_) {
        photoListCtl_ = [[PhotoListCtl alloc]init];
        photoListCtl_.delegate_ = self;
        [self addSubview:photoListCtl_];
        [self sendSubviewToBack:photoListCtl_];
    }
    photoListCtl_.isMyCenter = isMyCenter_;
    [photoListCtl_ beginLoad:personCenterModel_ exParam:nil];
    
    //现工作地
    CGRect frame = workPlaceView.frame;
    frame.origin.y = CGRectGetMaxY(photoListCtl_.frame);
    UILabel *lable = (UILabel *)[workPlaceView viewWithTag:100];
    lable.text = personCenterModel_.userModel_.cityStr_.length > 0 ?personCenterModel_.userModel_.cityStr_:@"保密";
    workPlaceView.frame = frame;
    UIImageView *image = (UIImageView *)[workPlaceView viewWithTag:101];
    image.hidden = isMyCenter_?NO:YES;
    //行业
    frame = tradeView.frame;
    frame.origin.y = CGRectGetMaxY(workPlaceView.frame);
    lable = (UILabel *)[tradeView viewWithTag:100];
    lable.text = personCenterModel_.userModel_.tradeName.length>0 ? personCenterModel_.userModel_.tradeName:@"保密";
    tradeView.frame = frame;
    image = (UIImageView *)[tradeView viewWithTag:101];
    image.hidden = isMyCenter_?NO:YES;
    //个性标签
    frame = bardianLableVIew.frame;
    frame.origin.y = CGRectGetMaxY(tradeView.frame);
    bardianLableVIew.frame = frame;
    [self creatBardianLableVIew];
    //想学技能
    frame = wantSkillView.frame;
    frame.origin.y = CGRectGetMaxY(bardianLableVIew.frame);
    wantSkillView.frame = frame;
    [self creatWantSkill];
    //擅长行业
    frame = beGoodTradeView.frame;
    frame.origin.y = CGRectGetMaxY(wantSkillView.frame);
    NSString *goodTradeStr = personCenterModel_.userModel_.goodat_.length > 0 ?personCenterModel_.userModel_.goodat_:@"未知";
    lable = (UILabel *)[beGoodTradeView viewWithTag:100];
    lable.numberOfLines = 0;
    lable.text = goodTradeStr;
    CGSize size = [lable.text sizeNewWithFont:lable.font constrainedToSize:CGSizeMake(ScreenWidth-110,1000)];
    lable.frame = CGRectMake(80,4,ScreenWidth-110,size.height+5);
    frame.size.height = CGRectGetMaxY(lable.frame)+5;
    beGoodTradeView.frame = frame;
    
    image = (UIImageView *)[beGoodTradeView viewWithTag:101];
    frame = image.frame;
    frame.origin.y = (beGoodTradeView.frame.size.height - frame.size.height)/2;
    image.frame = frame;
    image.hidden = isMyCenter_?NO:YES;
    
    UIImageView *image2 = (UIImageView *)[beGoodTradeView viewWithTag:102];
    frame = image2.frame;
    frame.size.width = ScreenWidth-70;
    frame.origin.x =70;
    image2.frame = frame;
    
    //擅长领域
    frame = beGoodViewOne.frame;
    frame.origin.y = CGRectGetMaxY(beGoodTradeView.frame);
    beGoodViewOne.frame = frame;
    [self creatAboutBeGoodView];
    //职业宣言
    frame = jobSpeakView.frame;
    frame.origin.y = CGRectGetMaxY(beGoodViewOne.frame);
    jobSpeakView.frame = frame;
    [self creatViewHeight:jobSpeakView withString:personCenterModel_.userModel_.signature_];
    //个人简介
    frame = introduceView.frame;
    frame.origin.y = CGRectGetMaxY(jobSpeakView.frame);
    introduceView.frame = frame;
    [self creatViewHeight:introduceView withString:personCenterModel_.userModel_.expertIntroduce_];
    //小编专访
    frame = interviewViewOne.frame;
    frame.origin.y = CGRectGetMaxY(introduceView.frame);
    interviewViewOne.frame = frame;
    if (personCenterModel_.interviewArray_.count >= 1)
    {
        interviewViewOne.hidden = NO;
        [self creatInterViewFrame:interviewViewOne withModel:personCenterModel_.interviewArray_[0]];
    }
    else
    {
        frame.size.height = 0;
        interviewViewOne.frame = frame;
        interviewViewOne.hidden = YES;
    }
    
    frame = interviewViewTwo.frame;
    frame.origin.y = CGRectGetMaxY(interviewViewOne.frame);
    interviewViewTwo.frame = frame;
    if (personCenterModel_.interviewArray_.count >= 2)
    {
        interviewViewTwo.hidden = NO;
        [self creatInterViewFrame:interviewViewTwo withModel:personCenterModel_.interviewArray_[1]];
    }
    else
    {
        interviewViewTwo.hidden = YES;
        frame.size.height = 0;
        interviewViewTwo.frame = frame;
    }
    
    frame = interviewViewThree.frame;
    frame.origin.y = CGRectGetMaxY(interviewViewTwo.frame);
    interviewViewThree.frame = frame;
    if (personCenterModel_.interviewArray_.count >= 3)
    {
        interviewViewThree.hidden = NO;
        [self creatInterViewFrame:interviewViewThree withModel:personCenterModel_.interviewArray_[2]];
    }
    else
    {
        interviewViewThree.hidden = YES;
        frame.size.height = 0;
        interviewViewThree.frame = frame;
    }
    
    frame = moreInterviewView.frame;
    frame.origin.y = CGRectGetMaxY(interviewViewThree.frame);
    if ([personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
    {
        moreInterviewView.hidden = YES;
        frame.size.height = 0;
    }
    else
    {
        moreInterviewView.hidden = NO;
        frame.size.height = 30;
    }
    moreInterviewView.frame = frame;
    
    if (isMyCenter_)
    {
        [moreInterviewBtn setTitle:@"更多访谈内容" forState:UIControlStateNormal];
        [moreInterviewBtn setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateNormal];
    }else
    {
        if (personCenterModel_.interviewArray_.count > 0 && personCenterModel_.interviewArray_.count <= 3)
        {
            [moreInterviewBtn setTitle:@"邀请回答" forState:UIControlStateNormal];
            [moreInterviewBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        else
        {
            [moreInterviewBtn setTitle:@"更多访谈内容" forState:UIControlStateNormal];
            [moreInterviewBtn setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateNormal];
        }
    }
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(moreInterviewView.frame);
    self.frame = frame;
    
    [_aboutDelegate finishLoadWithHeight:self.frame.size.height];
}
#pragma mark - 创建个性标签卡片
-(void)creatBardianLableVIew
{
    UIView *tagView = (UIView *)[bardianLableVIew viewWithTag:100];
    NSArray *subViews = tagView.subviews;
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    CGFloat lastX = 0;
    CGFloat lastY = 10;
    for (int i=0; i<personCenterModel_.tagListArray_.count; i++)
    {
        CustomTagButton *button = [[CustomTagButton alloc]init];
        button.userInteractionEnabled = NO;
        personTagModel *tag = personCenterModel_.tagListArray_[i];
        [button setTitle:tag.tagName_ forState:UIControlStateNormal];
        button.titleLabel.font = TWEELVEFONT_COMMENT;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xffa6a6)];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY width:isMyCenter_?(ScreenWidth-110):(ScreenWidth-90)];
        button.frame = frame;
        [tagView addSubview:button];
    }
    
    CGRect frame = tagView.frame;
    frame.origin.y = 0;
    frame.size.width = ScreenWidth-110;
    frame.size.height = lastY + 30 +MARGIN_TOP;
    frame.origin.x = 80;
    
    
    UILabel *lable = (UILabel *)[bardianLableVIew viewWithTag:105];
    CGFloat height = 0;
    
    if (personCenterModel_.tagListArray_.count == 0)
    {
        bardianLableVIew.hidden = YES;
        frame.size.height = 0;
        if (isMyCenter_)
        {
            height = 30;
            lable.hidden = NO;
            bardianLableVIew.hidden = NO;
        }
    }
    else
    {
        lable.hidden = YES;
        bardianLableVIew.hidden = NO;
    }
    tagView.frame = frame;
    
    frame = bardianLableVIew.frame;
    frame.size.height = CGRectGetMaxY(tagView.frame)+height;
    bardianLableVIew.frame = frame;
    
    UIImageView *image = (UIImageView *)[bardianLableVIew viewWithTag:101];
    frame = image.frame;
    frame.origin.y = (bardianLableVIew.frame.size.height - frame.size.height)/2;
    image.frame = frame;
    image.hidden = isMyCenter_ ? NO:YES;
    
    image = (UIImageView *)[bardianLableVIew viewWithTag:102];
    [bardianLableVIew bringSubviewToFront:image];
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

#pragma mark - 创建想学技卡片
-(void)creatWantSkill
{
    UIView *tagView = (UIView *)[wantSkillView viewWithTag:100];
    NSArray *subViews = tagView.subviews;
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    CGFloat lastX = 0;
    CGFloat lastY = 10;
    for (int i=0; i<personCenterModel_.skillListArray_.count; i++)
    {
        CustomTagButton *button = [[CustomTagButton alloc]init];
        button.userInteractionEnabled = NO;
        personTagModel *tag = personCenterModel_.skillListArray_[i];
        [button setTitle:tag.tagName_ forState:UIControlStateNormal];
        button.titleLabel.font = TWEELVEFONT_COMMENT;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xff6464)];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY width:isMyCenter_?(ScreenWidth-110):(ScreenWidth-90)];
        button.frame = frame;
        [tagView addSubview:button];
    }
    
    CGRect frame = tagView.frame;
    frame.origin.y = 0;
    frame.size.width = ScreenWidth-110;
    frame.size.height = lastY + 30 +MARGIN_TOP;
    frame.origin.x = 80;
    
    UILabel *lable = (UILabel *)[wantSkillView viewWithTag:105];
    CGFloat height = 0;
    if (personCenterModel_.skillListArray_.count == 0)
    {
        wantSkillView.hidden = YES;
        if (isMyCenter_) {
            height = 30;
            lable.hidden = NO;
            wantSkillView.hidden = NO;
        }
        frame.size.height = 0;
    }
    else
    {
        lable.hidden = YES;
        wantSkillView.hidden = NO;
    }
    tagView.frame = frame;
    
    frame = wantSkillView.frame;
    frame.size.height = CGRectGetMaxY(tagView.frame)+height;
    wantSkillView.frame = frame;
    
    UIImageView *image = (UIImageView *)[wantSkillView viewWithTag:101];
    frame = image.frame;
    frame.origin.y = (wantSkillView.frame.size.height - frame.size.height)/2;
    image.frame = frame;
    image.hidden = isMyCenter_ ? NO:YES;
    
    image = (UIImageView *)[wantSkillView viewWithTag:102];
    [wantSkillView bringSubviewToFront:image];
}

#pragma mark - 创建关于TA擅长领域卡片
-(void)creatAboutBeGoodView
{
    if (!isMyCenter_) {
        CGRect frame = beGoodViewOne.frame;
        frame.size.height = 0;
        beGoodViewOne.frame = frame;
        beGoodViewOne.hidden = YES;
        return;
    }
    
    beGoodViewOne.hidden = NO;
    
    UIView *tagView = (UIView *)[beGoodViewOne viewWithTag:100];
    NSArray *subViews = tagView.subviews;
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    CGFloat lastX = 0;
    CGFloat lastY = 10;
    for (int i=0; i<personCenterModel_.fieldListArray_.count; i++)
    {
        CustomTagButton *button = [[CustomTagButton alloc]init];
        button.userInteractionEnabled = NO;
        personTagModel *tag = personCenterModel_.fieldListArray_[i];
        [button setTitle:tag.tagName_ forState:UIControlStateNormal];
        button.titleLabel.font = TWEELVEFONT_COMMENT;
        [button setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        button.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
        button.layer.borderWidth = 0.5;
        CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY width:isMyCenter_?(ScreenWidth-110):(ScreenWidth-90)];
        button.frame = frame;
        [tagView addSubview:button];
    }
    
    CGRect frame = tagView.frame;
    frame.origin.y = 0;
    frame.size.width = ScreenWidth-110;
    frame.size.height = lastY + 30 +MARGIN_TOP;
    frame.origin.x = 80;
    
    
    UILabel *lable = (UILabel *)[beGoodViewOne viewWithTag:105];
    CGFloat height = 0;
    
    if (personCenterModel_.fieldListArray_.count == 0)
    {
        beGoodViewOne.hidden = YES;
        frame.size.height = 0;
        if (isMyCenter_)
        {
            height = 30;
            lable.hidden = NO;
            beGoodViewOne.hidden = NO;
        }
    }
    else
    {
        lable.hidden = YES;
        beGoodViewOne.hidden = NO;
    }
    tagView.frame = frame;
    
    frame = beGoodViewOne.frame;
    frame.size.height = CGRectGetMaxY(tagView.frame)+height;
    beGoodViewOne.frame = frame;
    
    UIImageView *image = (UIImageView *)[beGoodViewOne viewWithTag:101];
    frame = image.frame;
    frame.origin.y = (beGoodViewOne.frame.size.height - frame.size.height)/2;
    image.frame = frame;
    image.hidden = isMyCenter_ ? NO:YES;
    
    image = (UIImageView *)[beGoodViewOne viewWithTag:102];
    [beGoodViewOne bringSubviewToFront:image];
}


#pragma mark - 个人简介、职业宣言高度计算
-(void)creatViewHeight:(UIView *)view withString:(NSString *)str
{
    if(str.length > 0)
    {
        CGFloat width = ScreenWidth-(isMyCenter_?40:20);
        
        UILabel *lable = (UILabel *)[view viewWithTag:100];
        //lable.text = str;
        lable.numberOfLines = 0;
        
        lable.frame = CGRectMake(10,35,width,0);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        [lable setAttributedText:attributedString1];
        [lable sizeToFit];
        lable.frame = CGRectMake(10,35,width,lable.frame.size.height);
        // lable.frame = CGRectMake(80,3,210,size.height+5);
        
        CGRect frame = view.frame;
        frame.size.height = CGRectGetMaxY(lable.frame) + 6;
        view.frame = frame;
        
        UIImageView *image = (UIImageView *)[view viewWithTag:101];
        frame = image.frame;
        frame.origin.y = (view.frame.size.height - frame.size.height)/2;
        image.frame = frame;
        image.hidden = isMyCenter_ ? NO:YES;
        
        image = (UIImageView *)[view viewWithTag:102];
        frame = image.frame;
        frame.origin.x = 0;
        frame.size.width = ScreenWidth;
        frame.origin.y = 0;
        image.frame = frame;
    }
    else
    {
        CGRect frame = view.frame;
        frame.size.height = 0;
        view.frame = frame;
    }
}
#pragma mark - 小编专访高度计算
-(void)creatInterViewFrame:(UIView *)view withModel:(InterviewDataModel *)model
{
    InterviewDataModel *modelOne = personCenterModel_.interviewArray_[0];
    CGFloat widthLb = ScreenWidth-(isMyCenter_?40:20);
    CGFloat width = 0;
    if ([model.question_ isEqualToString:modelOne.question_])
    {
        width = 30;
    }
    
    UILabel *lable1 = (UILabel *)[view viewWithTag:100];
    lable1.numberOfLines = 0;
    
    lable1.frame = CGRectMake(10,5+width,widthLb,0);
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.question_];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.question_ length])];
    [lable1 setAttributedText:attributedString1];
    [lable1 sizeToFit];
    lable1.frame = CGRectMake(10,5+width,widthLb,lable1.frame.size.height);
    
    UILabel *lable2 = (UILabel *)[view viewWithTag:101];
    lable2.numberOfLines = 0;
    if (model.answer_.length > 0)
    {
        lable2.frame = CGRectMake(10,CGRectGetMaxY(lable1.frame)+5,widthLb,0);
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.answer_];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.answer_ length])];
        [lable2 setAttributedText:attributedString1];
        [lable2 sizeToFit];
        lable2.frame = CGRectMake(10,CGRectGetMaxY(lable1.frame)+5,widthLb,lable1.frame.size.height);
    }
    else
    {
        lable2.frame = CGRectMake(10,CGRectGetMaxY(lable1.frame)+5,0,0);
    }
    
    CGRect frame = view.frame;
    if ([personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
    {
        frame.size.height = 0;
        view.hidden = YES;
    }
    else
    {
        view.hidden = NO;
        frame.size.height = CGRectGetMaxY(lable2.frame) + 6;
    }
    view.frame = frame;
    
    UIImageView *image = (UIImageView *)[view viewWithTag:102];
    frame = image.frame;
    frame.origin.y = (view.frame.size.height - frame.size.height)/2;
    image.frame = frame;
    image.hidden = isMyCenter_?NO:YES;
    
    image = (UIImageView *)[view viewWithTag:103];
    frame = image.frame;
    frame.origin.y = 0;
    frame.origin.x = 0;
    frame.size.width = ScreenWidth;
    image.frame = frame;
}

#pragma mark - 关于TA列表点击事件
-(void)addTapAboutView
{
    [workPlaceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEditorCtl:)]];
    [tradeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEditorCtl:)]];
    [bardianLableVIew addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLableCtl:)]];
    [wantSkillView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWantstudent:)]];
    [jobSpeakView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEditorCtl:)]];
    [introduceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEditorCtl:)]];
    [beGoodViewOne addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGoodRespone:)]];
    [beGoodTradeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGoodChangeTrade:)]];
    
    interviewViewOne.tag = 300;
    interviewViewTwo.tag = 301;
    interviewViewThree.tag = 302;
    [interviewViewOne addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInterviewCtl:)]];
    [interviewViewTwo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInterviewCtl:)]];
    [interviewViewThree addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInterviewCtl:)]];
}

-(void)tapGoodChangeTrade:(UITapGestureRecognizer *)sender
{
    ELGoodTradeChangeTwoCtl *ctl = [[ELGoodTradeChangeTwoCtl alloc] init];
    ctl.changeDelegate = self;
    [ctl beginLoad:nil exParam:nil];
    ctl.selectNameArr = personCenterModel_.goodTradeArr;
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}

-(void)changeGoodTradeWithArr:(NSArray *)arrData
{
    if (arrData.count > 0)
    {
        personCenterModel_.goodTradeArr = [[NSMutableArray alloc] init];
        personTagModel *model = arrData[0];
        NSString *tradeName = model.tagName_;
        NSString *tradeId = model.tagId_;
        [personCenterModel_.goodTradeArr addObject:model.tagName_];
        for (NSInteger i =1; i<arrData.count;i++)
        {
            personTagModel *modelOne = arrData[i];
            tradeName = [NSString stringWithFormat:@"%@,%@",tradeName,modelOne.tagName_];
            tradeId = [NSString stringWithFormat:@"%@,%@",tradeId,[modelOne.tagId_ isEqualToString:@"001"]?@"0":modelOne.tagId_];
            [personCenterModel_.goodTradeArr addObject:modelOne.tagName_];
        }
        personCenterModel_.userModel_.goodat_= tradeName;
        goodAtId = tradeId;
        
        NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
        [updateDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
        [updateDic setObject:tradeId forKey:@"good_at_trade"];
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        NSString *updateStr = [jsonWriter2 stringWithObject:updateDic];
        NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",updateStr];
        NSString * function = @"edit_card";
        NSString * op = @"person_info_api";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result)
         {
             NSDictionary *dic = result;
             NSString *str = [dic objectForKey:@"status"];
             NSString *desc = [dic objectForKey:@"status_desc"];
             if ([str isEqualToString:@"OK"])
             {
                 [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil seconds:0.5];
                 [_aboutDelegate refreshAllLoad];
                 [self refreshAboutListView];
             }
             else
             {
                 [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:desc seconds:0.5];
             }
         } failure:^(NSURLSessionDataTask *operation, NSError *error) {
             
         }];
    }
}

-(void)tapEditorCtl:(UITapGestureRecognizer *)sender
{
    EditorBasePersonInfoCtl *editorCtl = [[EditorBasePersonInfoCtl alloc] init];
    editorCtl.delegate = self;
    [editorCtl beginLoad:personCenterModel_ exParam:nil];
    [[Manager shareMgr].centerNav_ pushViewController:editorCtl animated:YES];
}

-(void)tapLableCtl:(UITapGestureRecognizer *)sender
{
    changeLableType = 1;
    EditorTagCtl *tagCtl = [[EditorTagCtl alloc]init];
    tagCtl.block = ^(NSString *tags)
    {
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        NSArray *arr = [tags componentsSeparatedByString:@","];
        for (NSString *str in arr) {
            personTagModel *model = [[personTagModel alloc] init];
            model.tagName_ = str;
            [arrData addObject:model];
        }
        arrTagData = [[NSArray alloc] initWithArray:arrData];
        if (!updateTagsCon_)
        {
            updateTagsCon_ = [self getNewRequestCon];
        }
        [updateTagsCon_ updateTagsList:[Manager getUserInfo].userId_ tagListString:tags tagType:@"PERSON_LABEL"];
    };
    tagCtl.tagsType = [NSString stringWithFormat:@"PERSON_LABEL"];
    [tagCtl beginLoad:personCenterModel_ exParam:nil];
    [[Manager shareMgr].centerNav_ pushViewController:tagCtl animated:YES];
}

-(void)tapGoodRespone:(UITapGestureRecognizer *)sender
{
    changeLableType = 3;
    ELBeGoodAtTradeChangeCtl *ctl = [[ELBeGoodAtTradeChangeCtl alloc] init];
    ctl.delegate = self;
    ctl.tradeModel = [[personTagModel alloc] init];
    ctl.tradeModel.tagName_ = personCenterModel_.userModel_.tradeName;
    ctl.tradeModel.tagId_ = personCenterModel_.userModel_.tradeId;
    if (personCenterModel_.fieldListArray_.count > 0)
    {
        ctl.selectedTags = [[NSMutableArray alloc] init];
        [ctl.selectedTags addObjectsFromArray:personCenterModel_.fieldListArray_];
    }
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}

-(void)tapWantstudent:(UITapGestureRecognizer *)sender
{
    changeLableType = 2;
    LearnTechniqueCtl *learnTechniCtl = [[LearnTechniqueCtl alloc] init];
    learnTechniCtl.delegate = self;
    learnTechniCtl.selectedTags = personCenterModel_.skillListArray_;
   // learnTechniCtl.title = @"选择想学技能";
    [learnTechniCtl setNavTitle:@"选择想学技能"];
    [[Manager shareMgr].centerNav_ pushViewController:learnTechniCtl animated:YES];
}

-(void)tapInterviewCtl:(UITapGestureRecognizer *)sender
{
    InterviewDataModel *model = [personCenterModel_.interviewArray_ objectAtIndex:sender.view.tag-300];
    InterviewAnswerCtl *answerCtl = [[InterviewAnswerCtl alloc]init];
    answerCtl.block = ^()
    {
        [self loadGuanYuTa:userId_ personModal:personCenterModel_ isMyCenter:isMyCenter_];
    };
    [answerCtl beginLoad:model exParam:nil];
    [[Manager shareMgr].centerNav_ pushViewController:answerCtl animated:YES];
}

-(void)updateTechniqueTags:(NSArray *)tags
{
    if (!updateTagsCon_) {
        updateTagsCon_ = [self getNewRequestCon];
    }
    arrTagData = [NSArray arrayWithArray:tags];
    if (tags.count > 0)
    {
        NSString *tagsStr = @"";
        
        for (int i=0; i< [tags count]; i++) {
            personTagModel *tagModel = [tags objectAtIndex:i];
            NSString *temp = @"";
            if (i!= [tags count]-1) {
                temp =[NSString stringWithFormat:@"%@,",tagModel.tagName_];
            }else{
                temp = tagModel.tagName_;
            }
            tagsStr = [tagsStr stringByAppendingString:temp];
        }
        if(changeLableType == 2)
        {
            [updateTagsCon_ updateTagsList:[Manager getUserInfo].userId_ tagListString:tagsStr tagType:@"PERSON_SKILL"];
        }
        else if(changeLableType == 3)
        {
            [updateTagsCon_ updateTagsList:[Manager getUserInfo].userId_ tagListString:tagsStr tagType:@"PERSON_FIELD"];
        }
    }
    else{
        [updateTagsCon_ updateTagsList:[Manager getUserInfo].userId_ tagListString:@"" tagType:@"PERSON_FIELD"];
    }
}

-(void)edtorBaseSuccess
{
    personCenterModel_ = [Manager shareMgr].userCenterModel;
    [_aboutDelegate refreshAllLoad];
    [self refreshAboutListView:personCenterModel_ isMyCenter:isMyCenter_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UpdateTagsList:
        {
            NSString *status = [dataArr objectAtIndex:0];
            if ([status isEqualToString:@"OK"])
            {
                if (changeLableType == 2)
                {
                    if (!personCenterModel_.skillListArray_) {
                        personCenterModel_.skillListArray_ = [[NSMutableArray alloc] init];
                    }
                    [personCenterModel_.skillListArray_ removeAllObjects];
                    [personCenterModel_.skillListArray_ addObjectsFromArray:arrTagData];
                }
                else if(changeLableType == 1)
                {
                    if (!personCenterModel_.tagListArray_) {
                        personCenterModel_.tagListArray_ = [[NSMutableArray alloc] init];
                    }
                    [personCenterModel_.tagListArray_ removeAllObjects];
                    [personCenterModel_.tagListArray_ addObjectsFromArray:arrTagData];
                }
                else if(changeLableType == 3)
                {
                    if (!personCenterModel_.fieldListArray_) {
                        personCenterModel_.fieldListArray_ = [[NSMutableArray alloc] init];
                    }
                    [personCenterModel_.fieldListArray_ removeAllObjects];
                    [personCenterModel_.fieldListArray_ addObjectsFromArray:arrTagData];
                    [_aboutDelegate refreshAllLoad];
                }
                
                [self refreshAboutListView];
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil seconds:0.5];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:nil seconds:0.5];
            }
        }
            break;
        case Request_SendMessage:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.code_ isEqualToString:@"200"])
            {
                if (personCenterModel_.userModel_.followStatus_ == 0)
                {
                    personCenterModel_.userModel_.followStatus_ = 1;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addLikeSuccessNotification" object:nil];
                }
                [_aboutDelegate refreshAllLoad];
                [BaseUIViewController showAutoDismissSucessView:@"邀请成功" msg:nil seconds:0.5];
            }else if([model.code_ isEqualToString:@"4"]){
                [BaseUIViewController showAutoDismissFailView:@"今天已经邀请过!" msg:nil seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == moreInterviewBtn)//小编专访更多入口
    {
        if (isMyCenter_)
        {
            InterViewListCtl *listCtl = [[InterViewListCtl alloc]init];
            listCtl.block = ^(){
                [self loadGuanYuTa:userId_ personModal:personCenterModel_ isMyCenter:isMyCenter_];
            };
            [listCtl setIsMyCenter:isMyCenter_];
            [listCtl beginLoad:personCenterModel_.userModel_.id_ exParam:nil];
            [[Manager shareMgr].centerNav_ pushViewController:listCtl animated:YES];
        }
        else
        {
            if (personCenterModel_.interviewArray_.count > 0 && personCenterModel_.interviewArray_.count <=3) {
                if (![Manager shareMgr].haveLogin)
                {
                    [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                    return;
                }
                
                if (!sendMessageCon_) {
                    sendMessageCon_ = [self getNewRequestCon];
                }
                [sendMessageCon_ sendMessage:[Manager getUserInfo].userId_ type:@"503" inviteId:personCenterModel_.userModel_.id_];
            }
            else
            {
                InterViewListCtl *listCtl = [[InterViewListCtl alloc]init];
                [listCtl setIsMyCenter:isMyCenter_];
                [listCtl beginLoad:personCenterModel_.userModel_.id_ exParam:nil];
                [[Manager shareMgr].centerNav_ pushViewController:listCtl animated:YES];
            }
        }
    }
}

-(void)photoCancelRefresh
{
    [self performSelector:@selector(deleteRefresh) withObject:nil afterDelay:0.1];
}

-(void)deleteRefresh
{
    [_aboutDelegate refreshListCtlFrame];
}

- (void)loginSuccess
{
    [_aboutDelegate refreshListCtlFrame];
}

-(void)addNologinNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LOGINSUCCESS" object:nil];
    self.toLoginFlag = YES;
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

@end
