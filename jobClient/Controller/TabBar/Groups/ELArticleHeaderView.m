//
//  ELArticleHeaderView.m
//  jobClient
//
//  Created by 一览iOS on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELArticleHeaderView.h"
#import "YLMediaModal.h"
#import "YLArticleAttachmentCtl.h"
#import "YLArticleAttachmentList.h"
#import "ExpertPublishCtl.h"
#import "ELGroupDetailCtl.h"

@interface ELArticleHeaderView()
{
    IBOutlet UIView *recommentArticleView;
    __weak IBOutlet UILabel *recommentArticleTitleLb;
    __weak IBOutlet UILabel *recommentArticleGroupLb;
    
    Article_DataModal *recommentArticleModal;
    
    __weak IBOutlet UIView *publishView;
    __weak IBOutlet UIImageView *titleImg;
    
    __weak IBOutlet UIImageView *isExpertImg;
    __weak IBOutlet UILabel *publishName;
    __weak IBOutlet UILabel *jobName;
    __weak IBOutlet UIButton *publishAllBtn;
    __weak IBOutlet UIButton *focusOn;
    __weak IBOutlet UIButton *msgDetailBtn;
    
    __weak IBOutlet UIView *commentView;
    
    __weak IBOutlet UIView *attachmentView;
    __weak IBOutlet UIImageView *attachmentImage;
    __weak IBOutlet UILabel *attachmentTitle;
    
    __weak IBOutlet UILabel *attachmentSize;
    
    __weak IBOutlet UIButton *attachmentBtn;
    
    __weak IBOutlet  UIView            *expertView_;
    __weak IBOutlet  UIImageView       *imgView_;
    __weak IBOutlet  UILabel           *nameLb_;
    __weak IBOutlet  UILabel           *jobLb_;
    __weak IBOutlet  UIButton          *askBtn_;
    __weak IBOutlet  UIButton          *expertBtn_;
    
    Expert_DataModal *expertModalOne;
    ELArticleDetailModel *myDataModal_;
}
@end

@implementation ELArticleHeaderView

-(void)setMyModal:(ELArticleDetailModel *)myModal
{
    myDataModal_ = myModal;
    
    [titleImg sd_setImageWithURL:[NSURL URLWithString:myDataModal_.person_detail.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    
    publishName.text = myDataModal_.person_detail.person_iname;
    CGRect frameName = publishName.frame;
    if ([myDataModal_.person_detail.is_expert isEqualToString:@"1"]) {
        frameName.origin.x = 74;
        isExpertImg.hidden = NO;
    }
    else
    {
        frameName.origin.x = 65;
        isExpertImg.hidden = YES;
    }
    publishName.frame = frameName;
    jobName.text = myDataModal_.person_detail.person_job_now;
    
    CGRect frameP = publishView.frame;
    if (myDataModal_.other_article && ![myDataModal_._is_majia isEqualToString:@"1"])
    {
        publishAllBtn.hidden = NO;
        frameP.size.height = 115;
    }
    else
    {
        publishAllBtn.hidden = YES;
        frameP.size.height = 90;
    }
    publishView.frame = frameP;
    
    if([myDataModal_.dicJoinName[@"status"] isEqualToString:@"OK"])
    {
        focusOn.hidden = YES;
        if ([myDataModal_.person_detail.person_id isEqualToString:[Manager getUserInfo].userId_])
        {
            msgDetailBtn.hidden = YES;
        }
        else
        {
            msgDetailBtn.hidden = NO;
        }
    }
    else
    {
        msgDetailBtn.hidden = YES;
        if ([myDataModal_.person_detail.person_id isEqualToString:[Manager getUserInfo].userId_] || [myDataModal_._is_majia isEqualToString:@"1"])
        {
            focusOn.hidden = YES;
        }else{
            if ([myDataModal_.person_detail.rel integerValue] == 1) {
                focusOn.hidden = YES;
                msgDetailBtn.hidden = NO;
            }
            else
            {
                focusOn.hidden = NO;
                [self attentionSuccessRefresh:NO];
            }
        }
    }
    
    if (myDataModal_._media.count == 1)
    {
        YLMediaModal *modal = myDataModal_._media[0];
        attachmentImage.image = [UIImage imageNamed:modal.titleImage];
        attachmentTitle.text = modal.title;
        attachmentSize.text = @"";
    }
    else if (myDataModal_._media.count > 1)
    {
        attachmentImage.image = [UIImage imageNamed:@"attachment7"];
        attachmentTitle.text = [NSString stringWithFormat:@"全部附件"];
        attachmentSize.text = [NSString stringWithFormat:@"%ld",(unsigned long)myDataModal_._media.count];
    }
    [self changeViewHeight];
}

-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ELArticleHeaderView" owner:self options:nil] lastObject];
    if (self)
    {
        _articleDetailCtl = articleCtl;
        titleImg.clipsToBounds = YES;
        titleImg.layer.cornerRadius = 4.0;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonCenterCtl:)];
        titleImg.userInteractionEnabled = YES;
        [titleImg addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonCenterCtl:)];
        publishName.userInteractionEnabled = YES;
        [publishName addGestureRecognizer:tap2];
        msgDetailBtn.clipsToBounds = YES;
        msgDetailBtn.layer.cornerRadius = 3.0;
        recommentArticleTitleLb.userInteractionEnabled = YES;
        [recommentArticleTitleLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recommentArticleDetailTap:)]];
        focusOn.layer.cornerRadius = 3.0;
        focusOn.layer.masksToBounds = YES;
    }
    return self;
}

-(void)tapPersonCenterCtl:(UITapGestureRecognizer *)sender
{
    [_articleDetailCtl tapPersonCenterCtl:nil];
}

-(void)recommentArticleDetailTap:(UITapGestureRecognizer *)sender
{
    ArticleDetailCtl * articleDetailCtl = [[ArticleDetailCtl alloc] init];
    [[Manager shareMgr].centerNav_ pushViewController:articleDetailCtl animated:YES];
    [articleDetailCtl beginLoad:recommentArticleModal exParam:nil];
}

-(void)loadDataWithIsFromNews:(BOOL)isNew
{
    _isFromNews = isNew;
    if (isNew) {
        [self loadExpertDetail];
    }
    [self loadRecommentArticle];
}

#pragma mark - 请求看了又看文章
-(void)loadRecommentArticle
{
    if (!_articleId) {
        return;
    }
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:_articleId forKey:@"article_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:condictionDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionDicStr];
    [ELRequest postbodyMsg:bodyMsg op:@"groups_busi" func:@"getGroupHotArticle" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         NSArray *arr = dic[@"data"];
         if ([arr isKindOfClass:[NSArray class]])
         {
             NSDictionary *dicData = dic[@"data"][0];
             recommentArticleModal = [[Article_DataModal alloc] init];
             recommentArticleModal.id_ = dicData[@"article_id"];
             recommentArticleModal.title_ = dicData[@"title"];
             recommentArticleModal.groupId_ = dicData[@"_group_info"][@"group_id"];
             recommentArticleModal.groupName_ = dicData[@"_group_info"][@"group_name"];
             recommentArticleModal.groups_communicate_mode = dicData[@"_group_info"][@"groups_communicate_mode"];
             
             recommentArticleTitleLb.text = recommentArticleModal.title_;
             
             NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自 %@",recommentArticleModal.groupName_]];
             [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:108.0/255.0 blue:162.0/255.0 alpha:1.0] range:NSMakeRange(2,string.string.length -2)];
             recommentArticleGroupLb.attributedText = string;
             recommentArticleGroupLb.userInteractionEnabled = YES;
             [recommentArticleGroupLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recommentArticleGroupTap:)]];
             [self changeViewHeight];
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)loadExpertDetail
{
    [ELRequest postbodyMsg:@" " op:@"salarycheck_all" func:@"busi_getAppXwRecomendExpert" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         expertModalOne = [[Expert_DataModal alloc] initWithExpertDetailDictionary:dic];
         
         if (expertModalOne && _isFromNews)
         {
             askBtn_.layer.cornerRadius = 4.0;
             [nameLb_ setText:expertModalOne.iname_];
             [jobLb_ setText:expertModalOne.job_];
             
             [imgView_ sd_setImageWithURL:[NSURL URLWithString:expertModalOne.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
             imgView_.layer.masksToBounds = YES;
             imgView_.contentMode = UIViewContentModeScaleAspectFill;
             imgView_.layer.cornerRadius = 4.0;
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)attentionSuccessRefresh:(BOOL)isSuccess
{
    if (isSuccess){
        [focusOn setTitle:@"已关注" forState:UIControlStateNormal];
        [focusOn setBackgroundColor:UIColorFromRGB(0xeeeeee)];
        [focusOn setTitleColor:UIColorFromRGB(0x9e9e9e) forState:UIControlStateNormal];
//        [focusOn setImage:[UIImage imageNamed:@"ios_icon_article_attentioned"] forState:UIControlStateNormal];
        focusOn.selected = YES;
    }
    else
    {
        [focusOn setTitle:@"关注" forState:UIControlStateNormal];
        [focusOn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
        [focusOn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [focusOn setImage:[UIImage imageNamed:@"ios_icon_article_attention"] forState:UIControlStateNormal];
        focusOn.selected = NO;
    }
}

-(void)recommentArticleGroupTap:(UITapGestureRecognizer *)sender
{
    ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
    [[Manager shareMgr].centerNav_ pushViewController:detaliCtl animated:YES];
    Groups_DataModal * dataModal = [[Groups_DataModal alloc] init];
    dataModal.id_ = recommentArticleModal.groupId_;
    [detaliCtl beginLoad:dataModal exParam:nil];
}

-(void)changeViewHeight
{
    recommentArticleView.hidden = YES;
    publishView.hidden = YES;
    commentView.hidden = YES;
    expertView_.hidden = YES;
    attachmentView.hidden = YES;
    
    CGFloat height = 0;
    CGRect frame;
    
    if (myDataModal_._media.count > 0) {
        attachmentView.hidden = NO;
        frame = attachmentView.frame;
        frame.origin.y = height;
        attachmentView.frame = frame;
        height += attachmentView.frame.size.height;
    }
    
    if (_isFromNews) {
        expertView_.hidden = NO;
        frame = expertView_.frame;
        frame.origin.y = height;
        expertView_.frame = frame;
        height += expertView_.frame.size.height;
    }
    else if (![myDataModal_._is_majia isEqualToString:@"1"]) {
//        publishView.hidden = YES;
        frame = publishView.frame;
        frame.origin.y = height;
        publishView.frame = frame;
//        height += publishView.frame.size.height;
    }
    BOOL showRecomment = ([myDataModal_._group_info.groups_communicate_mode integerValue] == 10 && ![myDataModal_._group_info.group_open_status isEqualToString:@"3"]);
    if (recommentArticleModal.title_.length > 0 && recommentArticleModal.groupName_.length > 0 && !_isFromNews && showRecomment)
    {
        recommentArticleView.hidden = NO;
        frame = recommentArticleView.frame;
        frame.origin.y = height;
        recommentArticleView.frame = frame;
        height += recommentArticleView.frame.size.height;
    }
    
    if (_haveComment) {
        commentView.hidden = NO;
        frame = commentView.frame;
        frame.origin.y = height;
        commentView.frame = frame;
        height += commentView.frame.size.height;
    }
    
    self.frame = CGRectMake(0,0,ScreenWidth,height);
    _viewHeight = height;
    [_articleDetailCtl tableReloadData];
}

- (IBAction)btnRespone:(UIButton *)sender 
{
    if (sender == askBtn_)
    {
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
            return;
        }
        AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
        askDefaultCtl_.backCtlIndex = [Manager shareMgr].centerNav_.viewControllers.count-1;
        [[Manager shareMgr].centerNav_ pushViewController:askDefaultCtl_ animated:YES];
        [askDefaultCtl_ beginLoad:expertModalOne.id_ exParam:nil];
    }
    
    else if (sender == expertBtn_) {
        if (![Manager shareMgr].haveLogin) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
            return;
        }
        ExpertAnswerCtl *ctl = [[ExpertAnswerCtl alloc] init];
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        [ctl beginLoad:expertModalOne exParam:nil];
    }
    else if (sender == attachmentBtn)
    {
        if (myDataModal_._media.count == 1) {
            YLArticleAttachmentCtl *ctl = [[YLArticleAttachmentCtl alloc]init];
            ctl.dataModal = myDataModal_._media[0];
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        }
        else if(myDataModal_._media.count > 1)
        {
            YLArticleAttachmentList *ctl = [[YLArticleAttachmentList alloc] init];
            ctl.dataArr = myDataModal_._media;
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        }
    }
    else if (sender == focusOn)
    {
        if ([Manager shareMgr].haveLogin) {
            if(!focusOn.selected)
            {
                [self addExpertAttention];
            }
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
        }
        
    }
    else if (sender == publishAllBtn)
    {
        if (myDataModal_.person_detail.person_id.length > 0) {
            ExpertPublishCtl *ctl = [[ExpertPublishCtl alloc]init];
            Expert_DataModal *modal = [[Expert_DataModal alloc] init];
            modal.id_ = myDataModal_.person_detail.person_id;
            
            BOOL iscenter = NO;
            if ([[Manager getUserInfo].userId_ isEqualToString:myDataModal_.person_detail.person_id]) {
                iscenter = YES;
            }
            [ctl setIsMyCenter:iscenter];
            [ctl beginLoad:modal exParam:nil];
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        }
    }
    else if (sender == msgDetailBtn)
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:_articleDetailCtl] showNoLoginCtlView];
            return;
        }
        MessageContact_DataModel *modal = [[MessageContact_DataModel alloc] init];
        modal.userId = myDataModal_.person_detail.person_id;
        modal.userIname = myDataModal_.person_detail.person_iname;
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        [ctl beginLoad:modal exParam:nil];
    }
}

-(void)addExpertAttention
{
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@",[Manager getUserInfo].userId_,myDataModal_.person_detail.person_id];
    [ELRequest postbodyMsg:bodyMsg op:@"zd_person_follow_rel" func:@"addPersonFollow" requestVersion:NO progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         Status_DataModal * dataModal = [[Status_DataModal alloc] init];
         
         dataModal.code_ = [dic objectForKey:@"code"];
         dataModal.status_ = [dic objectForKey:@"status"];
         dataModal.des_ = [dic objectForKey:@"status_desc"];
         if ([dataModal.status_ isEqualToString:Success_Status]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFollowCnt" object:nil];
         }
         if([dataModal.status_ isEqualToString:@"OK"])
         {
             [[Manager shareMgr] showSayViewWihtType:4];
         }
         if ([dataModal.status_ isEqualToString:@"OK"]) {
             [_articleDetailCtl attentionSuccessRefresh:YES];
             [BaseUIViewController showAutoDismissSucessView:@"关注成功" msg:nil seconds:1.0];
         }else{
             [BaseUIViewController showAutoDismissFailView:@"关注失败" msg:nil seconds:1.0];
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)setHaveComment:(BOOL)haveComment{
    _haveComment = haveComment;
    [self changeViewHeight];
}

@end
