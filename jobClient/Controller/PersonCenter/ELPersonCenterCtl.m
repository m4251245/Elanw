//
//  ELPersonCenterCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELPersonCenterCtl.h"
#import "PersonQRCodeCtl.h"
#import "ShareMessageModal.h"
#import "TheContactListCtl.h"
#import "ELCommentStarCell.h"
#import "EGOViewCommon.h"
#import "EGORefreshTableFooterView.h"
#import "DynamicCtl.h"
#import "RewardAmountCtl.h"
#import "ELAspDisServiceCtl.h"
#import "RecommendJobCtl.h"
#import "ELPersonCenterAboutListCtl.h"
#import "ELRewardLuckyBagAnimationCtl.h"
#import "ELPersonCenterBackImageChangeCtl.h"
#import "MyDelegateCtl.h"
#import "EditorBasePersonInfoCtl.h"
#import "ModifyResumeViewController.h"
#import "ELPersonTitleView.h"

@interface ELPersonCenterCtl () <UIActionSheetDelegate,UIScrollViewDelegate,NoLoginDelegate,UITableViewDataSource,UITableViewDelegate,ELEGORefreshTableDelegate,PersonCenterAboutDelegate,ELShareManagerDelegate,PersonInfoViewDelegate>
{
    PersonQRCodeCtl *personQr; //个人主页二维码
    UIView *noCommentView; //评价列表没有评价的View
    ShareMessageModal *shareModal;  //分享给一览好友的Modal
    RequestCon *attentionCon_; //关注请求类
    RequestCon *sendMessageCon_;
    RequestCon *uploadMyImgCon_;
    
    NSString *userId_; //当前主页用户id
    PersonCenterDataModel *personCenterModel_;
    
    NSInteger scrollIndex;//记录当前列表的下标
    
    UIButton *changeImageBtn;
    
    BOOL isMyCenter_;
    
    UIScrollView *scrollView_; //主框架的scorllView
    UIImageView *titleBlackImage;//顶部导航栏背景图
    UIView *titleView; //顶部导航栏View
    UIButton *titleLeftBtn; //返回按钮
    UIButton *titleRightBtn; //分享按钮
    UIButton *titleZbarBtn; //二维码按钮
    UILabel *titleNameLb; //导航栏用户名
    UIImageView *titleBackImage; //大的用户背景图
    
    UIScrollView *contentScrollView; //动态、关于列表的导航栏
    UIScrollView *listScrollView; //动态、关于列表所在的ScrollView
    UIImageView *lineImage;
    UIImageView *lineImageOne;
    NSMutableArray *btnArr; //动态、关于、评价、约谈、推荐职位button数组
    NSMutableArray *btnArrOne;
    UIButton *selectBtnOne; ////动态、关于、评价、约谈、推荐职位当前选中的button
    BOOL isBtnClick;
    
   
    UIView *hideStatuBarView;
    
    UIScrollView *changeScroll;
    
    UIView *bottomView; //底部私信、关注View
    UIButton *dialogueBtn; //私信按钮
    UIButton *focusOnBtn; //关注按钮
    UIView *followLineImg;
    UIView *_delegateLine;
    UIButton *_delegateBtn;
    
    UIActivityIndicatorView *activity_;
    
    UITableView *commentTableView; //评价TbaleView
    
    EGORefreshTableFooterView *_refreshFooterView;//底部刷新控件
    
    PageInfo *pageInfo;
    NSMutableArray *commentDataArr; //评价列表数据
    DynamicCtl *dynamicCtl; //动态列表
    AppointmentCtl *appointCtl; //约谈列表
    RecommendJobCtl *recommendJobCtl; //推荐职位列表
    ELPersonCenterAboutListCtl *aboutListCtl; //关于TA列表
    ELPersonTitleView *personInfoView;
    
    BOOL isLoadComment;
    BOOL recommendCtlNoData;
    UIButton *rewardBtn; /**<打赏 */
}

@end

@implementation ELPersonCenterCtl

@synthesize selectBtn,contentDataArr;

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.frame = [UIScreen mainScreen].bounds;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_isFromManagerCenterPop) {
        self.fd_interactivePopDisabled = YES;
    }
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.frame = [UIScreen mainScreen].bounds;
    
    personCenterModel_ = [[PersonCenterDataModel alloc] init];
    
    scrollView_ = [[UIScrollView alloc] init];
    scrollView_.delegate = self;
    scrollView_.contentSize = CGSizeMake(ScreenWidth,[UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:scrollView_];
    [self.view bringSubviewToFront:titleView];

    contentDataArr = [[NSMutableArray alloc] init];
    btnArr = [[NSMutableArray alloc] init];
    btnArrOne = [[NSMutableArray alloc] init];
    
    titleBackImage = [[UIImageView alloc] init];
    titleBackImage.image = [UIImage imageNamed:@"personcenter_back_image"];
    titleBackImage.frame = CGRectMake(0,0,ScreenWidth,(ScreenWidth*200)/320);
    [scrollView_ addSubview:titleBackImage];
       
    personInfoView = [[ELPersonTitleView alloc] init];
    personInfoView.personDelegate = self;
    [scrollView_ addSubview:personInfoView];
    
    CGFloat startY = -20;

    activity_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity_.hidesWhenStopped = YES;
    activity_.center = CGPointMake(self.view.center.x,100);
    [self.view addSubview:activity_];
    [activity_ startAnimating];
    
    rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rewardBtn setImage:[UIImage imageNamed:@"img_rewardBtn"] forState:UIControlStateNormal];
    rewardBtn.frame = CGRectMake(ScreenWidth-50,ScreenHeight-200,44,44);
    [rewardBtn addTarget:self action:@selector(rewardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rewardBtn];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0,startY,ScreenWidth,64)];
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    
    titleBlackImage = [[UIImageView alloc] initWithFrame:titleView.bounds];
    titleBlackImage.image = [UIImage imageNamed:@"icon_zhuye_23zhezhao"];
    [titleView addSubview:titleBlackImage];
    
    titleLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleLeftBtn setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
    titleLeftBtn.frame = CGRectMake(0,20,44,44);
    [titleLeftBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleLeftBtn];
    
    titleRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleRightBtn setImage:[UIImage imageNamed:@"share_white_new"] forState:UIControlStateNormal];
    titleRightBtn.frame = CGRectMake(ScreenWidth-38,20,44,44);
    [titleRightBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    titleRightBtn.hidden = YES;
    [titleView addSubview:titleRightBtn];
    
    titleZbarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleZbarBtn setImage:[UIImage imageNamed:@"code_white_new"] forState:UIControlStateNormal];
    titleZbarBtn.frame = CGRectMake(ScreenWidth-78,20,44,44);
    [titleZbarBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    titleZbarBtn.hidden = YES;
    [titleView addSubview:titleZbarBtn];
    
    changeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeImageBtn setImage:[UIImage imageNamed:@"cloth_white_new"] forState:UIControlStateNormal];
    changeImageBtn.frame = CGRectMake(ScreenWidth-120,20,44,44);
    [changeImageBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    changeImageBtn.hidden = YES;
    [titleView addSubview:changeImageBtn];
    
    titleNameLb = [[UILabel alloc] initWithFrame:CGRectMake(116,31,89,21)];
    titleNameLb.font = [UIFont systemFontOfSize:17];
    titleNameLb.textColor = [UIColor whiteColor];
    titleNameLb.textAlignment = NSTextAlignmentCenter;
    titleNameLb.hidden = YES;
    [titleView addSubview:titleNameLb];
    
    hideStatuBarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,20)];
    hideStatuBarView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:hideStatuBarView];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight,ScreenWidth,40)];
    bottomView.backgroundColor = UIColorFromRGB(0xfa3434);
    [self.view addSubview:bottomView];
    
    dialogueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dialogueBtn setImage:[UIImage imageNamed:@"ios_icon_liuyan"] forState:UIControlStateNormal];
    [dialogueBtn setTitle:@"私信" forState:UIControlStateNormal];
    dialogueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [dialogueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dialogueBtn.frame = CGRectMake(0,0,124,40);
    [dialogueBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    dialogueBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0);
    dialogueBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [bottomView addSubview:dialogueBtn];
    
    focusOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusOnBtn setImage:[UIImage imageNamed:@"ios_icon_add"] forState:UIControlStateNormal];
    [focusOnBtn setTitle:@"关注" forState:UIControlStateNormal];
    focusOnBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [focusOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    focusOnBtn.frame = CGRectMake(0,0,124,40);
    [focusOnBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    focusOnBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0);
    focusOnBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [bottomView addSubview:focusOnBtn];
    
    _delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_delegateBtn setImage:[UIImage imageNamed:@"delegate_btn"] forState:UIControlStateNormal];
    [_delegateBtn setTitle:@"委托TA" forState:UIControlStateNormal];
    _delegateBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_delegateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _delegateBtn.frame = CGRectMake(0,0,124,40);
    [_delegateBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    _delegateBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0);
    _delegateBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,5);
    [_delegateBtn setBackgroundColor:UIColorFromRGB(0xEBB42A)];
    [bottomView addSubview:_delegateBtn];
    
    followLineImg = [[UIView alloc] initWithFrame:CGRectMake(159,5,1,30)];
    followLineImg.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:followLineImg];
    
    _delegateLine = [[UIView alloc] initWithFrame:CGRectMake(159,5,1,30)];
    _delegateLine.backgroundColor = [UIColor whiteColor];
    _delegateLine.hidden = YES;
    [bottomView addSubview:_delegateLine];
    
    CGFloat height1 = 40;
    if (isMyCenter_){
        height1 = 0;
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    scrollView_.frame = CGRectMake(0,startY,ScreenWidth,frame.size.height-height1);
    bottomView.frame = CGRectMake(0,CGRectGetMaxY(scrollView_.frame),ScreenWidth,40);
    titleView.frame = CGRectMake(0,startY,ScreenWidth,64);
    changeScroll.frame = CGRectMake(0,CGRectGetMaxY(titleView.frame),ScreenWidth,35);
    
    contentScrollView.hidden = YES;
    listScrollView.hidden = YES;

    personCenterModel_ = [[PersonCenterDataModel alloc] init];
    
    
    [self loadPersonInformation];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    NSLog(@"当前毫秒级时间7 = %@",[dateFormatter stringFromDate:[NSDate date]]);
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

- (BOOL)fd_interactivePopDisabled
{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [personInfoView stopVoice];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([Manager shareMgr].isShowRewardAnimat) {
        [self starAnimation];
    }
  
    [self scrollViewDidScroll:scrollView_];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    NSLog(@"当前毫秒级时间8 = %@",[dateFormatter stringFromDate:[NSDate date]]);
    
}

#pragma mark - 加载用户信息
-(void)loadPersonInformation
{
    NSString *personId = @"";
    if ([Manager getUserInfo].userId_.length > 0)
    {
        personId = [Manager getUserInfo].userId_;
    }
    
    if ([personId isEqualToString:userId_]) {
        rewardBtn.hidden = YES;
    }
    if (!userId_) {
        userId_ = @"";
    }
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId_ forKey:@"user_id"];
    [searchDic setObject:personId forKey:@"login_person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@",searchDicStr];
    bottomView.hidden = YES;
    [ELRequest postbodyMsg:bodyMsg op:@"salarycheck_all_new_busi" func:@"getPersonUserzoneInfoNew1" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         [personCenterModel_ giveDataDicPerson:dic];
         [self refreshAllLoad];
         if(isMyCenter_){
             [Manager shareMgr].userCenterModel = personCenterModel_;
         }
         [activity_ stopAnimating];
         contentScrollView.hidden = NO;
         listScrollView.hidden = NO;
         [self btnScrollViewContent:selectBtn];
         [self layoutBottomView];
         bottomView.hidden = NO;
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [activity_ stopAnimating];
         [BaseUIViewController showAutoDismissFailView:@"加载失败，请稍后再试" msg:nil seconds:1];
     }];
}

#pragma MARK 设置底部的view
- (void)layoutBottomView
{
    Expert_DataModal *userModel = personCenterModel_.userModel_;
    if(isMyCenter_){
        return;
    }
    if ([userModel.myselfIsAgenter isEqualToString:@"1"]) {//自己是职业经纪人
        
        CGFloat width = ScreenWidth/2.0;
        dialogueBtn.frame = CGRectMake(0, 0, width, 40);
        focusOnBtn.frame  = CGRectMake(width, 0, width, 40);
        followLineImg.frame = CGRectMake(CGRectGetMaxX(dialogueBtn.frame), 5, 1, 30);
        _delegateLine.hidden = YES;
        _delegateBtn.hidden = YES;
        return;
    }
    
    if ([userModel.is_jjr isEqualToString:@"1"] || [userModel.is_guWen isEqualToString:@"1"]) {//对方不是职业经纪人
        _delegateLine.hidden = NO;
        _delegateBtn.hidden = NO;
        CGFloat width = ScreenWidth/3.0;
        dialogueBtn.frame = CGRectMake(0, 0, width, bottomView.height);
        focusOnBtn.frame  = CGRectMake(width, 0, width, bottomView.height);
        _delegateBtn.frame = CGRectMake(width*2, 0, width, bottomView.height);
        followLineImg.frame = CGRectMake(CGRectGetMaxX(dialogueBtn.frame), 5, 1, 30);
        _delegateLine.frame = CGRectMake(CGRectGetMaxX(focusOnBtn.frame), 5, 1, 30);
        if ([userModel.myselfIsAgented isEqualToString:@"1"]) {//已经委托
            [_delegateBtn setTitle:@"已委托" forState:UIControlStateNormal];
        }
    }else{
        CGFloat width = ScreenWidth/2.0;
        dialogueBtn.frame = CGRectMake(0, 0, width, 40);
        focusOnBtn.frame  = CGRectMake(width, 0, width, 40);
        followLineImg.frame = CGRectMake(CGRectGetMaxX(dialogueBtn.frame), 5, 1, 30);
        _delegateLine.hidden = YES;
        _delegateBtn.hidden = YES;
    }
}

#pragma mark - 加载动态列表
-(void)loadDongtai
{
    dynamicCtl.otherUserId = userId_;
    
    __weak DynamicCtl *ctl = dynamicCtl;
    __weak ELPersonCenterCtl *personCtl = self;
    
    dynamicCtl.finishBlock = ^(CGFloat height, BOOL isNoData)
    {
        CGRect frame = ctl.frame;
        frame.size.height = height>0?height:250;
        ctl.frame = frame;
        if ([personCtl.selectBtn.titleLabel.text containsString:@"动态"])
        {
            if (isNoData) {
                [personCtl btnScrollViewContent:personCtl.aboutChangeBtn];
            }else{
                [personCtl btnScrollViewContent:personCtl.selectBtn];
            }
        }
    };
    [ctl requestLoadData];
}
#pragma mark - 加载约谈
-(void)loadYuetanData
{
    __weak ELPersonCenterCtl *personCtl = self;
    appointCtl.otherUserId = userId_;
    __weak AppointmentCtl *ctlOne = appointCtl;
    
    appointCtl.finishBlock = ^(CGFloat height, BOOL isNoData)
    {
        if (isNoData) {
            height = 400;
        }
        CGRect frame = ctlOne.frame;
        frame.size.height = height;
        ctlOne.frame = frame;
        if ([personCtl.selectBtn.titleLabel.text containsString:@"约谈"])
        {
            [personCtl btnScrollViewContent:personCtl.selectBtn];
        }
    };
    [appointCtl beginLoad:nil exParam:nil];
}

#pragma mark - 加载关于TA列表
-(void)loadGuanYuTa
{
    [aboutListCtl loadGuanYuTa:userId_ personModal:personCenterModel_ isMyCenter:isMyCenter_];
}

-(void)finishLoadWithHeight:(CGFloat)height
{
    CGRect frame = aboutListCtl.frame;
    frame.size.height = height;
    frame.size.width = ScreenWidth;
    aboutListCtl.frame = frame;
    if ([self.selectBtn.titleLabel.text containsString:@"关于"])
    {
        [self btnScrollViewContent:selectBtn];
    }
}

#pragma mark - 加载评价列表
-(void)loadCommentList
{
    NSString *personId = @"";
    if ([Manager getUserInfo].userId_.length > 0)
    {
        personId = [Manager getUserInfo].userId_;
    }
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId_ forKey:@"target_person_id"];
//    [searchDic setObject:personId forKey:@"login_person_id"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:@"yl_person_comment_busi" func:@"getPersonAllCommentList" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dic = result;
         if (!commentDataArr) {
             commentDataArr = [[NSMutableArray alloc] init];
         }
         NSDictionary * dicPage = [dic objectForKey:@"pageparam"];
         pageInfo.totalCnt_ = [[dicPage objectForKey:@"sums"] intValue];
         
         NSArray *dataArr = dic[@"data"];
         
         if ([dataArr isKindOfClass:[NSArray class]]) {
             for (NSDictionary *dataDic in dataArr) {
                 Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
                 @try {
                     dataModal.commentList = [[Comment_DataModal alloc] init];
                     dataModal.appraiser = [[Author_DataModal alloc] init];
                     dataModal.commentList.zpcId = dataDic[@"comment_id"];
                     dataModal.commentList.zpcPersonId = dataDic[@"person_id"];
                     dataModal.commentList.content_ = dataDic[@"content"];
                     dataModal.commentList.datetime_ = dataDic[@"idatetime"];
                     dataModal.commentList.zpcStar = dataDic[@"star"];
                     if ([dataDic[@"_person_detail"] isKindOfClass:[NSDictionary class]])
                     {
                         dataModal.appraiser.id_ = dataDic[@"_person_detail"][@"personId"];
                         dataModal.appraiser.iname_ = dataDic[@"_person_detail"][@"person_iname"];
                         dataModal.appraiser.nickname_ = dataDic[@"_person_detail"][@"person_nickname"];
                         dataModal.appraiser.img_ = dataDic[@"_person_detail"][@"person_pic"];
                         dataModal.appraiser.zw_ = dataDic[@"_person_detail"][@"person_zw"];
                     }
                     /**
                      *"type": 1表示个人评价 没有_product_info为空
                      *        10表示为问答评论
                      *        20表示为约谈评论、
                      */
                     dataModal.commentList.zpcType = dataDic[@"type"];
                     if ([dataDic[@"_product_info"] isKindOfClass:[NSDictionary class]])
                     {
                         dataModal.commentList.zpcProductId = dataDic[@"_product_info"][@"product_id"];
                         dataModal.commentList.zpcTitle = dataDic[@"_product_info"][@"product_title"];
                     }
                    
                 }
                 @catch (NSException *exception) {
                 }
                 @finally {
                 }
                 [commentDataArr addObject:dataModal];
                 [commentTableView reloadData];
             }
            }
            CGRect frame = commentTableView.frame;
            frame.size.width = ScreenWidth;
            if (commentDataArr.count > 0) {
                frame.size.height = commentTableView.contentSize.height;
                commentTableView.tableHeaderView = nil;
            }
            else
            {
                if (!noCommentView) {
                    noCommentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,200)];
                    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-40)/2.0,60,40,40)];
                    [image setImage:[UIImage imageNamed:@"icon_zhuye_20wupingjia"]];    
                    [noCommentView addSubview:image];
                    
                    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,image.bottom+8,ScreenWidth,20)];
                    lable.textAlignment = NSTextAlignmentCenter;
                    lable.font = [UIFont systemFontOfSize:15];
                    lable.textColor = UIColorFromRGB(0xaaaaaa);
                    lable.text = @" 暂无评价！";
                    [noCommentView addSubview:lable];
                }
                commentTableView.tableHeaderView = noCommentView;
                frame.size.height = 200;
            }
            commentTableView.frame = frame;
            if ([self.selectBtn.titleLabel.text containsString:@"评价"])
            {
                [self btnScrollViewContent:selectBtn];
            }
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
     }];
}

#pragma mark - 加载推荐职位列表
-(void)recommendListData
{
    recommendJobCtl.otherUserId = userId_;
    [recommendJobCtl beginLoad:nil exParam:nil];
    __weak ELPersonCenterCtl *personCtl = self;
    __weak RecommendJobCtl *ctlOne = recommendJobCtl;
    
    recommendJobCtl.finishBlock = ^(CGFloat height, BOOL isNoData)
    {
        recommendCtlNoData = isNoData;
        CGRect frame = ctlOne.view.frame;
        frame.origin.y = 0;
        frame.size.height = height;
        ctlOne.view.frame = frame;
        ctlOne.tableView.frame = CGRectMake(0,0,ScreenWidth,frame.size.height);
        if ([personCtl.selectBtn.titleLabel.text containsString:@"职位推荐"])
        {
            [personCtl btnScrollViewContent:personCtl.selectBtn];
        }
    };
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 50) {//取消委托
        //确认委托
        NSString *reason = @"";
        if (buttonIndex == 0) {
            reason = @"1";
        }else if (buttonIndex == 1) {
            reason = @"2";
        }else if (buttonIndex == 2) {
            reason = @"3";
        }else if (buttonIndex == 3) {
            reason = @"100";
        }else if (buttonIndex == 4){
            return;
        }
        
        NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&broker_user_id=%@&conditionArr={\"logs_remark\":\"%@\"}&", [Manager getUserInfo].userId_, userId_, reason];
        [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:@"doEntrust" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            if ([result[@"code"] isEqualToString:@"200"]) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"] seconds:2.f];
                [_delegateBtn setTitle:@"已委托" forState:UIControlStateNormal];
                personCenterModel_.userModel_.myselfIsAgented = @"1";
                if(personCenterModel_.userModel_.followStatus_ != 1)
                {
                    personCenterModel_.userModel_.fansCnt_++;
                    [personInfoView refreshFollowLable:personCenterModel_.userModel_.fansCnt_];
                    personCenterModel_.userModel_.followStatus_ = 1;
                    [self refreshFollewView];
                }
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"] seconds:2.f];
            }
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        return;
    }
    
    if (actionSheet.tag == 51) {//取消委托
        NSString *reason = @"";
        if (buttonIndex == 0) {
            reason = @"1";
        }else if (buttonIndex == 1) {
            reason = @"2";
        }else if (buttonIndex == 2) {
            reason = @"3";
        }else if (buttonIndex == 3) {
            reason = @"100";
        }else{
            return;
        }
        NSString *bodyMsg = [NSString stringWithFormat:@"client_user_id=%@&broker_user_id=%@&conditionArr={\"logs_remark\":\"%@\"}&", [Manager getUserInfo].userId_, userId_, reason];
        [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:@"cancelEntrust" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            if ([result[@"code"] isEqualToString:@"200"]) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"] seconds:2.f];
                [_delegateBtn setTitle:@"委托TA" forState:UIControlStateNormal];
                personCenterModel_.userModel_.myselfIsAgented = @"0";
            }else{
                [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"] seconds:2.f];
            }
        
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
        return;
    }
    switch (buttonIndex) {
        case 0:
        {
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
            [NoLoginPromptCtl getNoLoginManager].noLoginDelegare = self;
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            break;
        default:
            break;
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    userId_ = dataModal;
    if ([userId_ isEqualToString:[Manager getUserInfo].userId_]){
        isMyCenter_ = YES;
    }else{
        isMyCenter_ = NO;
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SendMessage:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.code_ isEqualToString:@"200"])
            {
                if (personCenterModel_.userModel_.followStatus_ == 0)
                {
                    personCenterModel_.userModel_.followStatus_ = 1;
                    [_delegate addLikeSuccess];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addLikeSuccessNotification" object:nil];
                }
                [self refreshFollewView];
                [BaseUIViewController showAutoDismissSucessView:@"邀请成功" msg:nil seconds:0.5];
            }else if([model.code_ isEqualToString:@"4"]){
                [BaseUIViewController showAutoDismissFailView:@"今天已经邀请过!" msg:nil seconds:0.5];
            }
        }
            break;
        case Request_UploadMyImg:
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [Manager getUserInfo].imageData_ = nil;
                [Manager getUserInfo].img_ = dataModal.exObj_;
                personCenterModel_.userModel_.img_ = dataModal.exObj_;
                [personInfoView setPersonImageWithUrl:personCenterModel_.userModel_.img_];
                //上传成功写入数据库
                [CommonConfig setDBValueByKey:Config_Key_UserImg value:[Manager getUserInfo].img_];
                [BaseUIViewController showAutoDismissSucessView:@"上传成功" msg:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
            }
            else
            {
                [BaseUIViewController showAutoDismissFailView:@"上传失败" msg:nil];
            }
        }
        case Request_Follow:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"] || [model.code_ isEqualToString:@"200"]) {
                personCenterModel_.userModel_.followStatus_ = 1;
                [self refreshFollewView];
                [_delegate addLikeSuccess];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addLikeSuccessNotification" object:nil];
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"关注成功" seconds:0.5];
                [_attentionDelegate attentionSuccessRefresh:YES];
                
                personCenterModel_.userModel_.fansCnt_++;
                [personInfoView refreshFollowLable:personCenterModel_.userModel_.fansCnt_];                
            }else{
                [BaseUIViewController showAutoDismissFailView:@"关注失败" msg:model.des_ seconds:0.5];
            }
        }
            break;
        case Request_CancelFollow:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                personCenterModel_.userModel_.followStatus_ = 0;
                [self refreshFollewView];
                [_delegate leslikeSuccess];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leslikeSuccessNotification" object:nil];
                [BaseUIViewController showAutoDismissSucessView:@"" msg:@"取消关注成功" seconds:0.5];
                [_attentionDelegate attentionSuccessRefresh:NO];
                personCenterModel_.userModel_.fansCnt_--;
                [personInfoView refreshFollowLable:personCenterModel_.userModel_.fansCnt_]; 
            }else{
                [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:0.5];
            }
        }
            break;
        default:
            break;
    }
}

-(void)sendInterviewRequest
{
    if (!sendMessageCon_) {
        sendMessageCon_ = [self getNewRequestCon:NO];
    }
    [sendMessageCon_ sendMessage:[Manager getUserInfo].userId_ type:@"500" inviteId:personCenterModel_.userModel_.id_];
}

-(void)updateLoadImageWithString:(NSString *)string{
    if (!uploadMyImgCon_) {
        uploadMyImgCon_ = [self getNewRequestCon:NO];
    }
    [uploadMyImgCon_ uploadMyImg:[Manager getUserInfo].userId_ uname:[Manager getUserInfo].name_ imgStr:string];
}

#pragma mark - 刷新用户信息
-(void)refreshAllLoad
{
    personInfoView.userId_ = userId_;
    personInfoView.isMyCenter_ = isMyCenter_;
    [personInfoView setPersonCenterModel_:personCenterModel_];
#pragma mark - 顶部背景图片
    
    if (personCenterModel_.userModel_.jobPeopleBackImage.length > 0)
    {
        [titleBackImage sd_setImageWithURL:[NSURL URLWithString:personCenterModel_.userModel_.jobPeopleBackImage] placeholderImage:[UIImage imageNamed:@"personcenter_back_image"]];
    }
    else
    {
        titleBackImage.image = [UIImage imageNamed:@"personcenter_back_image"];
    }
    
#pragma mark - 修改背景图片判断
    
    if(isMyCenter_ && ![personCenterModel_.userModel_.is_jjr isEqualToString:@"1"] && ![personCenterModel_.userModel_.is_ghs isEqualToString:@"1"] && ![personCenterModel_.userModel_.is_pxs isEqualToString:@"1"])
    {
        changeImageBtn.hidden = NO;
        CGRect titieFrame = titleNameLb.frame;
        titieFrame.size.width = ScreenWidth-230;
        titleNameLb.frame = titieFrame;
        titleNameLb.center = CGPointMake(ScreenWidth/2,titleNameLb.center.y);
    }
    else
    {
        CGRect titieFrame = titleNameLb.frame;
        titieFrame.size.width = ScreenWidth-160;
        titleNameLb.frame = titieFrame;
        titleNameLb.center = CGPointMake(ScreenWidth/2,titleNameLb.center.y);
        changeImageBtn.hidden = YES;
    }
#pragma mark - 滚动栏计算
    
    if (contentDataArr.count == 0)
    {
        if ([personCenterModel_.userModel_.is_jjr isEqualToString:@"1"] || [personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
        {
            if (isMyCenter_)
            {
                [contentDataArr addObjectsFromArray:@[@"约谈",@"动态",@"评价",@"关于我"]];
            }
            else
            {
                [contentDataArr addObjectsFromArray:@[@"约谈",@"动态",@"评价",@"职位推荐",@"关于TA"]];
                if(personCenterModel_.userModel_.has_jobs <= 0)
                {
                    [contentDataArr removeObject:@"职位推荐"];
                }
            }
            if (![personCenterModel_.userModel_.is_ghs isEqualToString:@"1"])
            {
                [contentDataArr removeObject:@"约谈"];
            }
            else if (personCenterModel_.userModel_.yuetan_cnt <= 0 && !isMyCenter_)
            {
                [contentDataArr removeObject:@"约谈"];
            }
            
            [self creatView];
            
            if ([contentDataArr containsObject:@"约谈"])
            {
                 [self loadYuetanData];
            }
            if ([contentDataArr containsObject:@"职位推荐"]) {
                [self recommendListData];
            }
            [self loadCommentList];
        }
        else
        {
            if (isMyCenter_) {
                [contentDataArr addObjectsFromArray:@[@"动态",@"关于我"]];
            }
            else
            {
                [contentDataArr addObjectsFromArray:@[@"动态",@"关于TA"]];
            }
            [self creatView];
        }
        [self loadGuanYuTa];
        [self loadDongtai];
    }
    
    CGRect frame = contentScrollView.frame;
    frame.origin.y = personInfoView.bottom;
    contentScrollView.frame = frame;
    
    [scrollView_ addSubview:contentScrollView];
    
    frame = listScrollView.frame;
    frame.origin.y = CGRectGetMaxY(contentScrollView.frame);
    listScrollView.frame = frame;
    
    titleRightBtn.hidden = NO;
    titleZbarBtn.hidden = NO;
    
    titleNameLb.text = personCenterModel_.userModel_.iname_;

    [self refreshFollewView];
    
    if (!isMyCenter_)
    {
        if ([contentDataArr containsObject:@"约谈"])
        {
            [dialogueBtn setTitle:@"1对1约谈" forState:UIControlStateNormal];
            [dialogueBtn setImage:[UIImage imageNamed:@"ios_icon_expert_liuyan"] forState:UIControlStateNormal];
        }
        else
        {
            [dialogueBtn setTitle:@"私信" forState:UIControlStateNormal];
            [dialogueBtn setImage:[UIImage imageNamed:@"ios_icon_liuyan.png"] forState:UIControlStateNormal];
        }
    }
}
-(void)btnResponse:(id)sender
{
    if (sender == titleLeftBtn)//返回按钮
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender == titleRightBtn)//分享按钮
    {
        NSString  *imagePath = personCenterModel_.userModel_.img_;
        NSString  *sharecontent;
        if(personCenterModel_.userModel_.job_.length > 0)
        {
            sharecontent = personCenterModel_.userModel_.job_;
        }
        else if (personCenterModel_.userModel_.zw_.length > 0)
        {
            sharecontent = personCenterModel_.userModel_.zw_;
        }
        else
        {
            sharecontent = personCenterModel_.userModel_.signature_;
        }
        sharecontent = [NSString stringWithFormat:@"%@\n点击查看更多",sharecontent];
        NSString  *titlecontent = [NSString stringWithFormat:@"%@的一览主页",personCenterModel_.userModel_.iname_];
        NSString  *url = [NSString stringWithFormat:@"http://m.yl1001.com/u/%@",personCenterModel_.userModel_.id_];
        UIImage   *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
#pragma mark - 发私信
            //[self sendMessage];
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeThree];
        [[ShareManger sharedManager] setShareDelegare:self];
        
        if (!shareModal) {
            shareModal = [[ShareMessageModal alloc] init];
        }
        shareModal.personId = personCenterModel_.userModel_.id_;
        shareModal.personName = personCenterModel_.userModel_.iname_;
        shareModal.person_pic = personCenterModel_.userModel_.img_;
        shareModal.person_zw = personCenterModel_.userModel_.job_;
        if (!shareModal.personName) {
            shareModal.personName = @"";
        }
        if (!shareModal.person_pic) {
            shareModal.person_pic = @"";
        }
        if (shareModal.person_zw.length == 0)
        {
            shareModal.person_zw = personCenterModel_.userModel_.zw_;
            if(shareModal.person_zw.length == 0)
            {
                shareModal.person_zw = @"";
            }
        }
    }
    else if (sender == titleZbarBtn)//二维码
    {
        User_DataModal *modal = [[User_DataModal alloc] init];
        modal.img_ = personCenterModel_.userModel_.img_;
        modal.name_ = personCenterModel_.userModel_.iname_;
        modal.job_ = personCenterModel_.userModel_.job_;
        if (modal.job_.length == 0) {
            modal.job_ = personCenterModel_.userModel_.zw_;
        }
        if (modal.job_.length == 0) {
            modal.job_ = @"未填写";
        }
        modal.userId_ = userId_;
        personQr = [[PersonQRCodeCtl alloc] initWithDataModal:modal];
        [personQr show];
    }
    else if (sender == dialogueBtn)//私信入口
    {
        [self sendMessage];
    }
    else if (sender == focusOnBtn)//关注入口
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
            return;
        }
        if (personCenterModel_.userModel_.id_.length == 0)
        {
            return;
        }
        if (personCenterModel_.userModel_.followStatus_ == 1) {
            //取消关注
            [self changLike];
            return;
        }
        [self addLike];
    }
    else if (sender == _delegateBtn){//委托
        //谷歌分析 创建事件并发送
        NSMutableDictionary *event = [[GAIDictionaryBuilder createEventWithCategory:@"Action"        //事件分类
                                                                             action:@"ButtonPress"   //事件动作
                                                                              label:@"delegateBtn"   //事件标签
                                                                              value:nil] build];
        [[GAI sharedInstance].defaultTracker send:event];
        [[GAI sharedInstance] dispatch]; //发送
        
        _delegateBtn.enabled = NO;
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
            _delegateBtn.enabled = YES;
            return;
        }
        
        //1.查询是否已经委托过
        [self queryIsDelegated];
    }
    else if (sender == changeImageBtn)
    {
        if (isMyCenter_)
        {
            ELPersonCenterBackImageChangeCtl *ctl = [[ELPersonCenterBackImageChangeCtl alloc] init];
            ctl.imageType = personCenterModel_.userModel_.jobPeopleBackImage;
            ctl.changeImageBolck = ^(Logo_DataModal *dataModal)
            {
                if (dataModal.path_.length > 0)
                {
                    [titleBackImage sd_setImageWithURL:[NSURL URLWithString:dataModal.path_] placeholderImage:[UIImage imageNamed:@"personcenter_back_image"]];
                    personCenterModel_.userModel_.jobPeopleBackImage = dataModal.path_;
                }
            };
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
}

#pragma mark - 查询是否已经委托过
/**
 *{"yjwtl":"1","jlbws":"1","hybpp":"2","yjywt":"2","ywtcnt":"5"}
 */

- (void)queryIsDelegated
{
    NSString *bodyMsg = [NSString stringWithFormat:@"client_user_id=%@&broker_id=%@&", [Manager getUserInfo].userId_, userId_];
    [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:@"getMyBrokersCnt" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result[@"ywtcnt"] integerValue] >= 6)
        {//已经委托其他的职业经纪人
            [self showChooseAlertView:53 title:@"" msg:@"抱歉，为了让我们能更好地为你提供针对性的服务，你最多可委托6位职业经纪人，如想继续委托TA，请先确定是否取消之前的委托" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
        }
        else if([result[@"yjwtl"] isEqualToString:@"2"])
        {//已经委托当前职业经纪人
            [self showCancelDelegateWithTag:51];
        }
        else if([result[@"jlbws"] isEqualToString:@"2"]){//当前用户简历不完善
            [self showChooseAlertView:52 title:@"" msg:@"由于您的简历未完善，暂不能委托该职业经纪人" okBtnTitle:@"完善简历" cancelBtnTitle:@"取消"];
        }
        else if([result[@"hybpp"] isEqualToString:@"2"]){//经纪人行业 与当前用户行业 不匹配
            [self showChooseAlertView:50 title:@"" msg:@"当前职业经纪人擅长行业与您的行业不是很匹配，是否确认委托？" okBtnTitle:@"确认委托" cancelBtnTitle:@"暂不委托"];
        }
        else {
            [self showChooseAlertView:50 title:@"委托TA当专属职业经纪人" msg:@"委托后，可查看你的简历，期待TA与你的沟通吧~" okBtnTitle:@"确认委托" cancelBtnTitle:@"取消"];
        }
        _delegateBtn.enabled = YES;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        _delegateBtn.enabled = YES;
    }];
}

//取消委托
- (void)showCancelDelegateWithTag:(NSInteger)tag
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"我想委托其他职业经纪人", @"已找到工作", @"服务不满意", @"其他原因", nil];
    actionSheet.tag = tag;
    [actionSheet showInView:self.view];
}

#pragma mark - 编辑个人信息成功的代理
-(void)edtorBaseSuccess
{
    personCenterModel_ = [Manager shareMgr].userCenterModel;
    [self refreshAllLoad];
    [aboutListCtl refreshAboutListView:personCenterModel_ isMyCenter:isMyCenter_];
}

//打赏成功动画
- (void)starAnimation
{
    ELRewardLuckyBagAnimationCtl *luckyBagCtl = [[ELRewardLuckyBagAnimationCtl alloc] init];
    luckyBagCtl.view.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:luckyBagCtl.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:luckyBagCtl.view];
    [luckyBagCtl initBagView];
    [Manager shareMgr].isShowRewardAnimat = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == scrollView_)
    {
        CGRect frame = titleBackImage.frame;
        CGFloat titleHeight = (ScreenWidth*200)/320.0;
        if (scrollView_.contentOffset.y < 0)
        {
            frame.origin.y = scrollView_.contentOffset.y;
            frame.size.height = titleHeight-scrollView_.contentOffset.y;
            frame.size.width = (frame.size.height * ScreenWidth)/titleHeight;
            frame.origin.x = -(frame.size.width -ScreenWidth)/2.0;
        }
        else
        {
            frame.origin.y = 0;
            frame.size.height = titleHeight;
            frame.size.width = ScreenWidth;
            frame.origin.x = 0;
        }
         titleBackImage.frame = frame;
        if (scrollView_.contentOffset.y > personInfoView.headMinY)
        {
            titleNameLb.hidden = NO;
            titleBlackImage.hidden = YES;
            titleView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [titleLeftBtn setImage:[UIImage imageNamed:@"back_grey_new"] forState:UIControlStateNormal];
            [titleRightBtn setImage:[UIImage imageNamed:@"share_grey_new"] forState:UIControlStateNormal];
            [titleZbarBtn setImage:[UIImage imageNamed:@"code_grey_new"] forState:UIControlStateNormal];
            [changeImageBtn setImage:[UIImage imageNamed:@"cloth_grey_new"] forState:UIControlStateNormal];
            titleNameLb.textColor = UIColorFromRGB(0x21212);
        }
        else
        {
            titleNameLb.hidden = YES;
            titleBlackImage.hidden = NO;
            titleView.backgroundColor = [UIColor clearColor];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [titleLeftBtn setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
            [titleRightBtn setImage:[UIImage imageNamed:@"share_white_new"] forState:UIControlStateNormal];
            [titleZbarBtn setImage:[UIImage imageNamed:@"code_white_new"] forState:UIControlStateNormal];
            [changeImageBtn setImage:[UIImage imageNamed:@"cloth_white_new"] forState:UIControlStateNormal];
            titleNameLb.textColor = [UIColor whiteColor];
        }
        
        if (scrollView_.contentOffset.y+64 >= CGRectGetMinY(contentScrollView.frame))
        {
            contentScrollView.hidden = YES;
            changeScroll.hidden = NO;
        }
        else
        {
            contentScrollView.hidden = NO;
            changeScroll.hidden = YES;
        }
    }
    
    if ((scrollView_.contentOffset.y > (scrollView_.contentSize.height - scrollView_.frame.size.height + 50) && [selectBtn.titleLabel.text containsString:@"评价"]) || [selectBtn.titleLabel.text containsString:@"职位推荐"])
    {
        if (_refreshFooterView) {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView_];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ((scrollView_.contentOffset.y > (scrollView_.contentSize.height - scrollView_.frame.size.height + 50) && [selectBtn.titleLabel.text containsString:@"评价"]) || [selectBtn.titleLabel.text containsString:@"职位推荐"])
    {
        if (_refreshFooterView) {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView_];
        }
    }
}

#pragma mark - 创建滚动栏

-(void)creatView
{
    listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-66-35-42)];
    listScrollView.contentSize = CGSizeMake(ScreenWidth*contentDataArr.count,listScrollView.height);
    listScrollView.bounces = NO;
    listScrollView.showsHorizontalScrollIndicator = NO;
    listScrollView.showsVerticalScrollIndicator = NO;
    listScrollView.pagingEnabled = YES;
    listScrollView.scrollEnabled = NO;
    listScrollView.delegate = self;
    [scrollView_ addSubview:listScrollView];
    
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,45)];
    contentScrollView.bounces = NO;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.scrollEnabled = NO;
    lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,43,40,2)];
    lineImage.image = [UIImage imageNamed:@"bg_title"];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,5)];
    lineView.backgroundColor = UIColorFromRGB(0xEFEFF4);
    [contentScrollView addSubview:lineView];
    [contentScrollView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,44,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    [contentScrollView addSubview:lineImage];
    [scrollView_ addSubview:contentScrollView];
    
    changeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,ScreenWidth,45)];
    changeScroll.hidden = YES;
    changeScroll.bounces = NO;
    changeScroll.scrollEnabled = NO;
    changeScroll.showsHorizontalScrollIndicator = NO;
    changeScroll.showsVerticalScrollIndicator = NO;
    changeScroll.delegate = self;
    changeScroll.backgroundColor = [UIColor whiteColor];
    lineImageOne = [[UIImageView alloc] initWithFrame:CGRectMake(10,43,40,2)];
    lineImageOne.image = [UIImage imageNamed:@"bg_title"];
    [changeScroll addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    [changeScroll addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,44,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    [changeScroll addSubview:lineImageOne];
    [self.view addSubview:changeScroll];
    [self.view bringSubviewToFront:changeScroll];
    
    for (NSInteger i = 0; i < contentDataArr.count ;i++)
    {
        NSString *strName = contentDataArr[i];
        UIButton *btn = [self getButtonWithName:strName withIndex:i count:contentDataArr.count];
        [changeScroll addSubview:btn];
        changeScroll.contentSize = CGSizeMake(20+((btn.width+10)*i),listScrollView.height);
        [btnArrOne addObject:btn];
        if ([strName containsString:@"动态"])
        {
            selectBtnOne = btn;
        }
    }
    
    for (NSInteger i = 0; i < contentDataArr.count ;i++)
    {
        NSString *strName = contentDataArr[i];
        UIButton *btn = [self getButtonWithName:strName withIndex:i count:contentDataArr.count];
        [contentScrollView addSubview:btn];
        [btnArr addObject:btn];
        contentScrollView.contentSize = CGSizeMake(20+((btn.width+10)*i),listScrollView.height);
        if ([strName containsString:@"关于"])
        {
            if (!aboutListCtl) {
                aboutListCtl = [[ELPersonCenterAboutListCtl alloc] init];
                aboutListCtl.aboutDelegate = self;
            }
            CGRect frameAbout = aboutListCtl.frame;
            frameAbout.origin.x = ScreenWidth*i;
            frameAbout.origin.y = 0;
            aboutListCtl.frame = frameAbout;
            [listScrollView addSubview:aboutListCtl];
            self.aboutChangeBtn = btn;
        }
        else if([strName containsString:@"评价"])
        {
            if(!commentTableView){
                commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
                commentTableView.delegate = self;
                commentTableView.dataSource = self;
                commentTableView.bounces = NO;
                commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                pageInfo = [[PageInfo alloc] init];
                pageInfo.currentPage_ = 0;
            }
            CGRect frameAbout = commentTableView.frame;
            frameAbout.origin.x = ScreenWidth*i;
            commentTableView.frame = frameAbout;
            [listScrollView addSubview:commentTableView];
        }
        else if ([strName containsString:@"动态"])
        {
            if (!dynamicCtl) {
                dynamicCtl = [[DynamicCtl alloc] init];
            }
            CGRect frameAbout = dynamicCtl.frame;
            frameAbout.origin.x = ScreenWidth*i;
            frameAbout.origin.y = 0;
            dynamicCtl.frame = frameAbout;
            [listScrollView addSubview:dynamicCtl];
            self.dongtaiChangeBtn = btn;
            if (![contentDataArr containsObject:@"约谈"])
            {
                  selectBtn = btn;
            }
        }
        else if([strName containsString:@"约谈"])
        {
            if (!appointCtl) {
                appointCtl = [[AppointmentCtl alloc] init];
            }
            CGRect frameAbout = appointCtl.frame;
            frameAbout.origin.x = ScreenWidth*i;
            frameAbout.origin.y = 0;
            appointCtl.frame = frameAbout;
            [listScrollView addSubview:appointCtl];
            selectBtn = btn;
        }
        else if([strName containsString:@"职位推荐"])
        {
            if (!recommendJobCtl) {
                recommendJobCtl = [[RecommendJobCtl alloc] init];
            }
            [self addChildViewController:recommendJobCtl];
            CGRect frameAbout = recommendJobCtl.view.frame;
            frameAbout.origin.x = ScreenWidth*i;
            frameAbout.origin.y = 0;
            recommendJobCtl.view.frame = frameAbout;
            [listScrollView addSubview:recommendJobCtl.view];
        }
    }
//    [self btnScrollViewContent:selectBtn];
}

-(UIButton *)getButtonWithName:(NSString *)name withIndex:(NSInteger)index count:(NSInteger)count{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FOURTEENFONT_CONTENT;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:name forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    [btn sizeToFit];
    CGFloat btnX = (ScreenWidth/count)*index + ((ScreenWidth/count)-btn.width-5)/2;
    btn.frame = CGRectMake(btnX,5,btn.width+5,40);
    btn.tag = 100+index;
    [btn addTarget:self action:@selector(btnScrollViewContent:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)refreshListCtlFrame
{
    if (selectBtn) {
        [self btnScrollViewContent:selectBtn];
    }
}

#pragma mark - 动态、关于、评价、约谈按钮点击事件
-(void)btnScrollViewContent:(UIButton *)sender
{
    UIButton *btn = btnArr[sender.tag -100];
    if (selectBtn) {
        [selectBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    }
    [btn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    CGPoint center = lineImage.center;
    center.x = btn.center.x;
    selectBtn = btn;
    
    UIButton *btnOne = btnArrOne[sender.tag -100];
    if (selectBtnOne) {
        [selectBtnOne setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    }
    [btnOne setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    CGPoint centerOne = lineImageOne.center;
    centerOne.x = btnOne.center.x;
    selectBtnOne = btnOne;
    
    [UIView animateWithDuration:0.2 animations:^{
        lineImage.center = center;
        lineImageOne.center = centerOne;
    }];
    
    
    CGRect frame;
    if ([sender.titleLabel.text containsString:@"关于"])
    {
        frame = aboutListCtl.frame;
        frame.origin.y = 0;
        aboutListCtl.frame = frame;
    }
    else if([sender.titleLabel.text containsString:@"评价"])
    {
        frame = commentTableView.frame;
        frame.origin.y = 0;
        commentTableView.frame = frame;
    }
    else if ([sender.titleLabel.text containsString:@"动态"])
    {
        frame = dynamicCtl.frame;
        frame.origin.y = 0;
        dynamicCtl.frame = frame;
    }
    else if([sender.titleLabel.text containsString:@"约谈"])
    {
        frame = appointCtl.frame;
        [Manager shareMgr].yuetanListBackCtl = self;
        frame.origin.y = 0;
        appointCtl.frame = frame;
    }
    else if([sender.titleLabel.text containsString:@"职位推荐"])
    {
        frame = recommendJobCtl.view.frame;
        frame.origin.y = 0;
        recommendJobCtl.view.frame = frame;
    }
    else
    {
        return;
    }

    CGRect frame1 = listScrollView.frame;
    frame1.size.height = frame.size.height;
    listScrollView.frame = frame1;
    scrollView_.contentSize = CGSizeMake(ScreenWidth,CGRectGetMaxY(listScrollView.frame)>scrollView_.frame.size.height ? CGRectGetMaxY(listScrollView.frame):scrollView_.frame.size.height+5);

    [scrollView_ setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    
    if ((sender.tag-100 != scrollIndex) && (scrollView_.contentOffset.y > CGRectGetMinY(contentScrollView.frame)-64))
    {
        [scrollView_ setContentOffset:CGPointMake(0,CGRectGetMinY(contentScrollView.frame)-63) animated:NO];
    }
     scrollIndex = sender.tag - 100;

    [listScrollView setContentOffset:CGPointMake(listScrollView.frame.size.width*(sender.tag-100),0) animated:YES];
    
    if ([sender.titleLabel.text containsString:@"评价"] && pageInfo.totalCnt_ > commentDataArr.count)
    {
        [self setFooterView];
    }
    else if([sender.titleLabel.text containsString:@"职位推荐"] && !recommendCtlNoData)
    {
        [self setFooterView];
    }
    else
    {
        [self removeFooterView];
    }
    
}

#pragma mark - 分享

-(void)shareYLFriendBtn
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    TheContactListCtl *contact = [[TheContactListCtl alloc] init];
    contact.isPersonChat = YES;
    contact.isPushShareCtl = YES;
    shareModal.shareType = @"1";
    shareModal.shareContent = @"名片";
    contact.shareDataModal = shareModal;
    [self.navigationController pushViewController:contact animated:YES];
    [contact beginLoad:nil exParam:nil];
}

-(void)copyChaining
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/u/%@",personCenterModel_.userModel_.id_];
    pasteboard.string = url;
    if(url.length > 0)
    {
        [BaseUIViewController showAutoDismissSucessView:nil msg:@"复制链接成功" seconds:1.0];
    }
}

-(void)loginDelegateCtl
{
    _toLoginFlag = YES;
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_PersonCenterRefresh:
        {
            if ([userId_ isEqualToString:[Manager getUserInfo].userId_])
            {
                isMyCenter_ = YES;
            }
            else
            {
                isMyCenter_ = NO;
            }
            [self loadPersonInformation];
        }
            break;
        default:
            break;
    }
}

-(void)refreshData{
    if ([userId_ isEqualToString:[Manager getUserInfo].userId_])
    {
        isMyCenter_ = YES;
    }
    else
    {
        isMyCenter_ = NO;
    }
    [self loadPersonInformation];
}

-(void)loginSuccess
{
    
}

#pragma mark - 底部私信关注

- (void)sendMessage
{
    if (![Manager shareMgr].haveLogin)
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
        return;
    }
    if ([personCenterModel_.userModel_.is_ghs isEqualToString:@"1"] && !isMyCenter_)
    {
        ELAspDisServiceCtl* aspDisCtl = [[ELAspDisServiceCtl alloc]init];
        [Manager shareMgr].yuetanListBackCtl = self;
        aspDisCtl.isShowCourse = YES;
        [self.navigationController pushViewController:aspDisCtl animated:YES];
        Expert_DataModal *expertDataModal_ = [[Expert_DataModal alloc] init];
        expertDataModal_.id_ = userId_;
        [aspDisCtl beginLoad:expertDataModal_ exParam:nil];
        return;
    }
    
    
    MessageContact_DataModel *model = [[MessageContact_DataModel alloc]init];
    model.userId = personCenterModel_.userModel_.id_;
    model.userIname = personCenterModel_.userModel_.iname_;
    model.sex = personCenterModel_.userModel_.sex_;
    model.age = personCenterModel_.userModel_.age_;
    model.sameSchool = personCenterModel_.userModel_.sameSchool_;
    model.gzNum = personCenterModel_.userModel_.gznum_;
    model.userZW = personCenterModel_.userModel_.job_;
    model.pic = personCenterModel_.userModel_.img_;
    MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
    [ctl beginLoad:model exParam:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 50){
        switch (buttonIndex) {
            case 0:
            {
                //确认委托
                NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&broker_user_id=%@&conditionArr={\"logs_remark\":\"100\"}&", [Manager getUserInfo].userId_, userId_];
                [ELRequest postbodyMsg:bodyMsg op:@"broker_entrust_busi" func:@"doEntrust" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
                    if ([result[@"code"] isEqualToString:@"200"]) {
                        [BaseUIViewController showAutoDismissSucessView:nil msg:result[@"status_desc"] seconds:2.f];
                        [_delegateBtn setTitle:@"已委托" forState:UIControlStateNormal];
                        personCenterModel_.userModel_.myselfIsAgented = @"1";
                        if(personCenterModel_.userModel_.followStatus_ == 1){}else{
                            personCenterModel_.userModel_.fansCnt_++;
                            [personInfoView refreshFollowLable:personCenterModel_.userModel_.fansCnt_];
                            personCenterModel_.userModel_.followStatus_ = 1;
                            [self refreshFollewView];
                        }
                    }else{
                        [BaseUIViewController showAutoDismissFailView:nil msg:result[@"status_desc"] seconds:2.f];
                    }
                    
                } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                    
                }];
            }
                break;
            default:
                break;
        }
    }
    else if(alertView.tag == 52)//当前用户简历不完善
    {
        if (buttonIndex == 0) {
            ModifyResumeViewController *modifyResumeVC = [[ModifyResumeViewController alloc]init];
            [modifyResumeVC beginLoad:nil exParam:nil];
            [self.navigationController pushViewController:modifyResumeVC animated:YES];
        }
    }
    else if(alertView.tag == 53)//前往我的委托列表
    {
        if (buttonIndex == 0) {
            MyDelegateCtl *delegateCtl = [[MyDelegateCtl alloc]init];
            [self.navigationController pushViewController:delegateCtl animated:YES];
            [delegateCtl beginLoad:nil exParam:nil];
        }
    }
}


#pragma mark - 加关注
- (void)addLike
{
    if (!attentionCon_) {
        attentionCon_ = [self getNewRequestCon:NO];
    }
    
    //谷歌分析 创建事件并发送
    NSMutableDictionary *event = [[GAIDictionaryBuilder createEventWithCategory:@"Action"        //事件分类
                                                                         action:@"ButtonPress"   //事件动作
                                                                          label:@"addCare"       //事件标签(加关注)
                                                                          value:nil] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch]; //发送
    [attentionCon_ followExpert:[Manager getUserInfo].userId_ expert:personCenterModel_.userModel_.id_];
}

#pragma mark - 取消关注
- (void)changLike
{
    if (!attentionCon_) {
        attentionCon_ = [self getNewRequestCon:NO];
    }
    [attentionCon_ cancelFollowExpert:[Manager getUserInfo].userId_ expert:personCenterModel_.userModel_.id_];
}

#pragma mark - 刷新关注状态
-(void)refreshFollewView
{
    if (personCenterModel_.userModel_.followStatus_ == 1){
        [focusOnBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [focusOnBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
}

-(void)setFooterView
{
    CGFloat height = MAX(scrollView_.contentSize.height, scrollView_.frame.size.height);
    if (_refreshFooterView) {
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              scrollView_.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         scrollView_.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [scrollView_ addSubview:_refreshFooterView];
    }
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(ELEGORefreshPos)aRefreshPos{

    if(aRefreshPos == ELEGORefreshFooter)
    {
        if ([selectBtn.titleLabel.text containsString:@"职位推荐"])
        {
            [self performSelector:@selector(recommendListData) withObject:self afterDelay:0.1];
        }
        else
        {
            pageInfo.currentPage_ ++;
            [self performSelector:@selector(loadCommentList) withObject:self afterDelay:0.1];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ELCommentStarCell";
    
    ELCommentStarCell *cell = (ELCommentStarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELCommentStarCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Expert_DataModal *model = commentDataArr[indexPath.row];
    [cell giveDataModal:model];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentDataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Expert_DataModal *model = commentDataArr[indexPath.row];
    CGSize size = [model.commentList.content_ sizeNewWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(265,100000)];
    if ([model.commentList.zpcTitle isEqualToString:@""] || [model.commentList.zpcType isEqualToString:@"1"]) {
        return size.height + 52 + 10;
    }
    else
    {
        return size.height + 52 + 10 + 21;
    }
}

-(void)addGoodJobSuccess
{
    personCenterModel_.userModel_.followStatus_ = 1;
    [self refreshFollewView];
}

- (void)rewardBtnClick:(id)sender {
    
    //友盟统计模块使用量
    NSDictionary *dict = @{@"Function":@"打赏"};
    [MobClick event:@"buttonClick" attributes:dict];
    
    if ([Manager shareMgr].haveLogin){
        RewardAmountCtl *rewardCtl = [[RewardAmountCtl alloc] init];
        rewardCtl.isRewardPop = YES;
        rewardCtl.personPic = personCenterModel_.userModel_.img_; 
        rewardCtl.personId = userId_;
        rewardCtl.personName = personCenterModel_.userModel_.iname_;
        rewardCtl.productId = userId_;   
        rewardCtl.productType = @"30";
        [Manager shareMgr].dashangBackCtlIndex = self.navigationController.viewControllers.count-1;
        [self.navigationController pushViewController:rewardCtl animated:YES];
    }
    else
    {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_PersonCenterRefresh;
        return;
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
