//
//  SalaryCtl2.m
//  jobClient
//
//  Created by 一览ios on 15/4/24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
// 薪指入口页面

#import "SalaryCtl2.h"
#import "salaryListFrame.h"
#import "SalaryCtl2_Cell.h"
#import "NoNamePublishSalary_Cell.h"
#import "SalaryBao_Cell.h"
#import "SalaryBaoDetail_Cell.h"
//#import "SalaryNavView.h"
#import "BuySalaryServiceCtl.h"
#import "NoLoginPromptCtl.h"
#import "SalaryFutureListCtl.h"
#import "YLTheTopicCell.h"
#import "YLOfferListCtl.h"
#import "SalaryChangeTypeCtl.h"
#import "SalaryIrrigationCtl.h"
#import "SalaryIrrigationCtl_Cell.h"
#import "ELPersonCenterCtl.h"
#import "NewCareerTalkDataModal.h"
#import "ELSalaryModel.h"
#import "ELSalaryResultModel.h"
#import "SalaryCompeteCtl.h"
#import "SalaryGuideCtl.h"
#import "SalaryListCtl.h"

#define kTagIdOffSet 1001

@interface SalaryCtl2 ()<UISearchBarDelegate,ELShareManagerDelegate,NoLoginDelegate,SalaryIrrigationDetailDelegate,YLTheTopicCellDeletage>
{
    BOOL _isSearch;
    BOOL shouldRefresh_;
    BOOL isBeginLoad;
    UITapGestureRecognizer *singleTapRecognizer_;
    RequestCon *_getSalaryNavCon;
    
    CGPoint scrollSet;
    ELSalaryModel *_shareArticle;
    RequestCon *_shareCon;
    RequestCon *_addlikeCon;
    RequestCon *_addAdClickCount;
    NSDictionary *_salaryCntDict;
    
    NSArray *_adArray;
    RequestCon *_adCon;
    RequestCon *voteCon;
    NSIndexPath *changPath;
    
    NSArray *headTitleArr;
    NSArray *headImageArr;
    
    IBOutlet UIView *headView_;
    __weak IBOutlet UIButton *mySalaryBtn;
    
    __weak IBOutlet UIButton *searchSalaryBtn;
    
    IBOutlet UIButton *publishBtn_;
    __weak IBOutlet UIButton *TopPostsBtn;
    __weak IBOutlet UIButton *MyPostBtn;
    __weak IBOutlet UIButton *InterActiveBtn;
    __weak IBOutlet UILabel *TopPostsLabel;
    __weak IBOutlet UILabel *InterActiveLabel;
    __weak IBOutlet UILabel *MyPostLabel;
}
@end

@implementation SalaryCtl2
#pragma mark - LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

-(id)init
{
    self = [super init];
    validateSeconds_ = 600;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bFooterEgo_ = YES;
    _searchBar.tintColor = UIColorFromRGB(0xe13e3e);
    [self setNavTitle:@"灌薪水"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    _redDotLb.layer.cornerRadius = 7.0;
    _redDotLb.layer.masksToBounds = YES;
    tableView_.tableHeaderView = headView_;
    
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn_];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
    [publishBtn_ addTarget:self action:@selector(publishSalary:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
        
    }
    [_searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateUserInfo" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (requestCon_ && ([requestCon_.dataArr_  count] == 0 || shouldRefresh_) ) {
        [self refreshLoad:nil];
        shouldRefresh_ = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated{

}

- (void)userInfoChange:(NSNotification *)info
{
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)updateCom:(RequestCon *)con
{
    if (con == requestCon_) {
        if ([Manager shareMgr].haveLogin) {
            [_userImg sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"bt_ch"]];
            [_personCenterBtn setTitle:@"" forState:UIControlStateNormal];
            _userImg.layer.cornerRadius = 11.0;
            _userImg.layer.masksToBounds = YES;
            _userImg.layer.borderWidth = 1.f;
            _userImg.layer.borderColor = [UIColor whiteColor].CGColor;
            if ([Manager getUserInfo].haveNewMessage_) {
                _redDotLb.alpha = 1.0;
                _redDotLb.text = [Manager shareMgr].totalCount;
            }
            else
                _redDotLb.alpha = 0.0;
        }
        else
        {
            _userImg.layer.cornerRadius = 11.0;
            _userImg.layer.masksToBounds = YES;
            [_userImg setImage:[UIImage imageNamed:@"bt_ch"]];
            [_personCenterBtn setTitle:@"我" forState:UIControlStateNormal];
            _redDotLb.alpha = 0.0;
        }
        
    }
    
    [super updateCom:con];
}

- (void)updateLoadingCom:(RequestCon *)con
{
    [super updateLoadingCom:con];
    //防止中断请求后没有加载更多的刷新
    if( [requestCon_.dataArr_ count] > 0 ){
        if( requestCon_.pageInfo_.currentPage_ > requestCon_.pageInfo_.pageCnt_ ){
            [self showNoMoreDataView:YES];
        }
        //还有更多数据
        else{
            [self showFooterRefreshView:YES];
        }
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    isBeginLoad = YES;
}

- (void)getDataFunction:(RequestCon *)con
{
    [self updateCom:con];
    
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    
    if ((!_adCon || !_adView1) && _adArray == nil) {
        _adCon = [self getNewRequestCon:NO];
        [_adCon getTopAD:userId Type:@"app_xs"];
    }
    
    NSString * kw = _searchBar.text;
    if (_isSearch && ![[kw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ] isEqualToString:@""])
    {//搜索
        [con getSalaryArticleListWithUserId: userId pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10];
    }
    else
    {
        [con getSalaryArticleListWithUserId: userId pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10];
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetSalaryArticleListByES://列表
        {
            if (!dataArr.count) {
                return;
            }
            shouldRefresh_ = NO;
            if (requestCon_.pageInfo_.currentPage_ == 1) { //第一页
                //先删除
                _salaryCntDict = [dataArr lastObject];
                [requestCon.dataArr_ removeLastObject];
                NSMutableArray *mArray = (NSMutableArray *)dataArr;
                [mArray removeLastObject];            }
            for (ELSalaryModel *articleModel in dataArr) {
                if ([articleModel isKindOfClass:[ELSalaryResultModel class]]) {
                    continue;
                }
                SalaryListFrame *frame = [[SalaryListFrame alloc]init];
                frame.articleModel = articleModel;
                articleModel.cellFrame = frame;
            }
            if (requestCon_.pageInfo_.currentPage_ == 1) { //第一页
                if (requestCon.dataArr_.count>=5) {//插入曝工资的入口
                    [requestCon_.dataArr_ insertObject:@{} atIndex:5];
                }
                if (requestCon.dataArr_.count>=10) {//插入曝工资的入口
                    [requestCon_.dataArr_ insertObject:@{} atIndex:10];
                }
            }
            [tableView_ reloadData];
        }
            break;
        case Request_TopAD:
        {
            _adArray = [NSArray arrayWithArray:dataArr];
        }
            break;
        case Request_GetQuerySalaryCount://查询薪指的次数
        {
            //友盟统计点击数
            NSDictionary * dict = @{@"Function":@"看看我能打败多少人"};
            [MobClick event:@"vsPay" attributes:dict];
            
            SalaryCompeteCtl * salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
            salaryCompeteCtl_.type_ = 2;
            [salaryCompeteCtl_ beginLoad:[Manager getUserInfo].zym_ exParam:nil];
            
            [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
        }
            break;
        case Request_shareArticleDyanmic://分享结果
        {
            Status_DataModal *dataModal = dataArr[0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                if ([dataModal.code_ isEqualToString:@"200"]) {
                    [BaseUIViewController showAutoDismissAlertView:nil msg:@"分享成功" seconds:2.0];
                }else{
                    [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
                }
            }else if( [dataModal.status_ isEqualToString:Fail_Status] ){
                [BaseUIViewController showAutoDismissAlertView:nil msg:dataModal.des_ seconds:2.0];
            }else{
                [BaseUIViewController showAlertView:nil msg:@"分享失败,请稍后再试" btnTitle:@"确定"];
            }
        }
            break;
        case Request_AddVoteLogs:
        {
            NSDictionary *dicVote = dataArr[0];
            if ([dicVote[@"status"] isEqualToString:@"OK"])
            {
                Article_DataModal *dataModal = requestCon_.dataArr_[changPath.row];
                dataModal.isVote = dicVote[@"is_vote"];
                dataModal.canVote = dicVote[@"can_vote"];
                dataModal.status = dicVote[@"status"];
                dataModal.allVote = dicVote[@"all_vote"];
                NSArray *voteArr = dicVote[@"option_info"];
                if (!dataModal.resultDataArr) {
                    dataModal.resultDataArr = [[NSMutableArray alloc] init];
                }
                [dataModal.resultDataArr removeAllObjects];
                for (NSDictionary *dicTwo in voteArr) {
                    YLVoteDataModal *voteModal = [[YLVoteDataModal alloc] init];
                    voteModal.gaapName = dicTwo[@"gaap_name"];
                    voteModal.gaapId = dicTwo[@"gaap_id"];
                    voteModal.sort = dicTwo[@"sort"];
                    voteModal.isBest = dicTwo[@"is_best"];
                    voteModal.result = dicTwo[@"result"];
                    [dataModal.resultDataArr addObject:voteModal];
                }
                [tableView_ reloadData];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - NoLoginDelegate
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_MyGuanXinShui:
        {
            [self btnTypePush:MyPostBtn];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5 || indexPath.row == 10) {
        return 150;
    }
    
    id dataModel = requestCon_.dataArr_[indexPath.row];
    if ([dataModel isKindOfClass:[ELSalaryResultModel class]]) {//曝工资
        return 185;
    }
    
    ELSalaryModel *article = requestCon_.dataArr_[indexPath.row];
    
    if ([article.status isEqualToString:@"OK"])
    {
        CGSize size = [article.content sizeNewWithFont:[UIFont systemFontOfSize:17]];
        CGFloat height = 0;
        if (size.width > 288) {
            height = 40;
        }
        else
        {
            height = 20;
        }
        return height + 60 + 45 * article.resultDataArr.count + 60;
    }
    
    CGFloat heightLabel = 25;
    
    if (article.is_jing && ![article.is_jing isEqualToString:@""]) {
        heightLabel = 31 + 25;
    }
    
    if (article.is_system && ![article.is_system isEqualToString:@""]) {
        
        heightLabel += 16 + 15;
    }
    
    MLEmojiLabel *emoji = [self emojiLabel:article.content numberOfLines:5 textColor:UIColorFromRGB(0x333333)];
    emoji.frame = CGRectMake(30,heightLabel,ScreenWidth-60,0);
    [emoji sizeToFit];
    
    return 60 + heightLabel + emoji.frame.size.height;
}

-(MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = FIFTEENFONT_TITLE;
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.lineSpacing = 10.0;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:text];
    return emojiLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dataModel = requestCon_.dataArr_[indexPath.row];
    
    if ([dataModel isKindOfClass:[Article_DataModal class]])
    {
        ELSalaryModel *articleModel = (ELSalaryModel *)dataModel;
        if ([articleModel.status isEqualToString:@"OK"])
        {
            static NSString *cellStr = @"YLTheTopicCell";
            
            YLTheTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"YLTheTopicCell" owner:self options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.likeBtn.tag = kTagIdOffSet + indexPath.row;
            cell.shareBtn.tag = kTagIdOffSet + indexPath.row;
            [cell.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.cellDelegate = self;
            articleModel.indexpath = indexPath;
            [cell giveDateModal:articleModel];
            return cell;
        }
    }
    
    static NSString *reusePublishSalaryIdentifier = @"NoNamePublishSalary_Cell";
    if (indexPath.row == 5 ) {//匿名发表灌薪水单元格
        NoNamePublishSalary_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reusePublishSalaryIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"NoNamePublishSalary_Cell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.publishbtn addTarget:self action:@selector(publishSalary:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    
    static NSString *reuseBaoSalaryIdentifier = @"SalaryBao_Cell";
    if (indexPath.row == 10 ) {//引导发表曝工资单元格
        SalaryBao_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseBaoSalaryIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SalaryBao_Cell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.lookAtBtn addTarget:self action:@selector(lookAtBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.myselfBtn addTarget:self action:@selector(myselfBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.tradeNumLb.text = [NSString stringWithFormat:@"目前已有 %@ 个行业", _salaryCntDict[@"trade_cnt"]];
        cell.userNumLb.text = [NSString stringWithFormat:@"目前已有 %@ 个用户曝出了自己的工资", _salaryCntDict[@"user_cnt"]];
        return cell;
    }
    
    static NSString *reuseBaoSalaryDetailIdentifier = @"SalaryBaoDetail_Cell";
    
    if ([dataModel isKindOfClass:[ELSalaryResultModel class]]) {//曝工资详情列表
        SalaryBaoDetail_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseBaoSalaryDetailIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"SalaryBaoDetail_Cell" owner:self options:nil][0];
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xfafafa);
        }
        cell.salaryResultModel = dataModel;
        return cell;
    }
    
    
    ELSalaryModel *articleModelOne = (ELSalaryModel *)dataModel;
    
    static NSString *CellIdentifier = @"SalaryIrrigationCtlCell";
    
    SalaryIrrigationCtl_Cell *cell = (SalaryIrrigationCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryIrrigationCtl_Cell" owner:self options:nil] lastObject];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xfafafa);
    }
    [cell giveDataCellWithModal:articleModelOne];
    
    cell.likeBtn_.tag = indexPath.row + kTagIdOffSet;
    cell.commentCntBtn_.tag = indexPath.row + 2000;
    cell.shareBtn_.tag = indexPath.row + kTagIdOffSet;
    
    if (!articleModelOne.isLike_) {
        [cell.likeBtn_ addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.shareBtn_ addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (articleModelOne.is_system && ![articleModelOne.is_system isEqualToString:@""])
    {
        cell.sourceLb_.userInteractionEnabled = YES;
        cell.sourceLb_.tag = 50 + indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSource:)];
        [cell.sourceLb_ addGestureRecognizer:tap];
    }
    CGRect frame = cell.imageLine.frame;
    frame.origin.y = cell.backGroudView.frame.size.height -1;
    cell.imageLine.frame = frame;
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if(indexPath.row == 5 || indexPath.row == 10){
        return;
    }
    if ([selectData isKindOfClass:[ELSalaryModel class]]) {
        ELSalaryModel *articleModel = selectData;
        articleModel.bgColor_ = WhiteColor;
        SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
        detailCtl.salaryDetailDelegate = self;
        detailCtl.path = indexPath.row;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:articleModel exParam:nil];
    }
    if ([selectData isKindOfClass:[ELSalaryResultModel class]]) {
        NSDictionary * dict = @{@"Function":@"薪指"};
        [MobClick event:@"personused" attributes:dict];
        [super loadDetail:selectData exParam:exParam indexPath:indexPath];
        SalaryGuideCtl *salaryGuideCtl = [[SalaryGuideCtl alloc] init];
        [self.navigationController pushViewController:salaryGuideCtl animated:YES];
        ELSalaryResultModel *dataModel = selectData;
        salaryGuideCtl.kwFlag_ = @"1";
        salaryGuideCtl.regionId_ = @"";
        salaryGuideCtl.noFromMessage_ = YES;
        [salaryGuideCtl beginLoad:dataModel exParam:exParam];
    }
}


-(void)tapSource:(UITapGestureRecognizer *)sender
{
    Article_DataModal *modal = requestCon_.dataArr_[sender.view.tag - 50];
    
    ELSalaryModel * dataModal = [[ELSalaryModel alloc] init];
    
    dataModal.article_id = modal.zhiyeId_;
    dataModal.bgColor_ = WhiteColor;
    
    SalaryIrrigationDetailCtl *detailCtl = [[SalaryIrrigationDetailCtl alloc] init];
    detailCtl.salaryDetailDelegate = self;
    detailCtl.path = sender.view.tag - 50;
    
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal exParam:nil];
}

-(void)changeBtnModal:(YLVoteDataModal *)modal indexPath:(NSIndexPath *)path
{
    changPath = path;
    Article_DataModal *dataModal = requestCon_.dataArr_[path.row];
    dataModal.isVote = @"1";
    if (!voteCon) {
        voteCon = [self getNewRequestCon:NO];
    }
    [voteCon sendAddVoteLogsGaapId:modal.gaapId personId:[Manager getUserInfo].userId_ clientId:[MyCommon getAddressBookUUID]];
}


-(void)refreshAddLikeIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if (requestCon_.dataArr_.count > indexPathRow) {
        ELSalaryModel *modal = requestCon_.dataArr_[indexPathRow];
        modal.like_cnt = count;
        [tableView_ reloadData];
    }
}

-(void)refreshActivityCell:(ELSalaryModel *)modal index:(NSInteger)row
{
    [requestCon_.dataArr_ replaceObjectAtIndex:row withObject:modal];
    [tableView_ reloadData];
}

-(void)refreshCommentIndex:(NSInteger)indexPathRow Count:(NSInteger)count
{
    if (requestCon_.dataArr_.count > indexPathRow) {
        ELSalaryModel *modal = requestCon_.dataArr_[indexPathRow];
        modal.c_cnt = count;
        [tableView_ reloadData];
    }
}

#pragma mark 分享
- (void)shareBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagIdOffSet;
    ELSalaryModel *shareArticle = [requestCon_.dataArr_ objectAtIndex:index];
    _shareArticle = shareArticle;
    NSString * sharecontent = shareArticle.content;
    if (!shareArticle.title_) {
        shareArticle.title_ = @"分享了一条灌薪水";
    }
    NSString * titlecontent = [NSString stringWithFormat:@"%@",shareArticle.title_];
    sharecontent = [sharecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    titlecontent = [titlecontent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/article/%@.htm",shareArticle.article_id];
    if (shareArticle.articleType_ == Article_Group) {
        url = [NSString stringWithFormat:@"http://m.yl1001.com/group_article/%@.htm",shareArticle.article_id];
    }else if(shareArticle.articleType_==Article_GXS){
        url = [NSString stringWithFormat:@"http://m.yl1001.com/gxs_article/%@.htm",shareArticle.article_id];
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell* cell = [tableView_ cellForRowAtIndexPath:indexPath];
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(cell.frame.size);
    }
    //获取图像
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (shareArticle.articleType_ == Article_Group || shareArticle.articleType_==Article_GXS) {
        //调用分享 不分享到一览动态中
        [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];
        return;
    }
    //可以分享到一览动态
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url shareType:ShareTypeTwo];
    [[ShareManger sharedManager] setShareDelegare:self];
}

//myShareManager的代理方法
-(void)shareYlBtn
{
    if (!_shareCon) {
        _shareCon = [self getNewRequestCon:NO];
    }
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        [BaseUIViewController showAlertView:nil msg:@"请先登录" btnTitle:@"确定"];
        return;
    }
    [_shareCon shareArticleDynamicArticleId:_shareArticle.article_id andPersonId:userId];
}

#pragma mark 点赞
- (void)likeBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagIdOffSet;
    ELSalaryModel *article = [requestCon_.dataArr_ objectAtIndex:index];
    if (article.isLike_) {
        return;
    }
    article.isLike_ = YES;
    article.like_cnt++;
    [Manager saveAddLikeWithAticleId:article.article_id];
    [tableView_ reloadData];
    if (!_addlikeCon) {
        _addlikeCon = [self getNewRequestCon:NO];
    }
    [_addlikeCon addArticleLike:article.article_id];
}

#pragma mark 匿名发表灌薪水
- (void)publishSalary:(id)sender
{
    ShareSalaryArticleCtl * shareArticleCtl = [[ShareSalaryArticleCtl alloc] init];
    [self.navigationController pushViewController:shareArticleCtl animated:YES];
    [shareArticleCtl beginLoad:nil exParam:nil];
}

#pragma mark 马上看一看曝工资
- (void)lookAtBtnClick:(id)sender
{
    SalaryListCtl *salaryCompareCtl = [[SalaryListCtl alloc]init];
    [self.navigationController pushViewController:salaryCompareCtl animated:YES];
    [salaryCompareCtl beginLoad:nil exParam:nil];
}

#pragma mark 我也要曝工资
- (void)myselfBtnClick:(id)sender
{
    SalaryListCtl *salaryCompareCtl = [[SalaryListCtl alloc]init];
    [self.navigationController pushViewController:salaryCompareCtl animated:YES];
    salaryCompareCtl.shouldShowExposureSalary = YES;
    [salaryCompareCtl beginLoad:nil exParam:nil];
}

#pragma mark SearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""] && _isSearch) {
        _isSearch = NO;
        [self refreshLoad:nil];
    }
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    //跳转到灌薪水列表
    SalaryIrrigationCtl *salaryCtl = [[SalaryIrrigationCtl alloc]init];
    salaryCtl.keywords = searchBar.text;
    salaryCtl->isSearch = YES;
    [self.navigationController pushViewController:salaryCtl animated:YES];
    [salaryCtl beginLoad:nil exParam:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}

#pragma mark scrollviewdelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollSet = scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_searchBar resignFirstResponder];
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [_searchBar resignFirstResponder];
}

#pragma UIKeyboardNotification
-(void)mykeyboardWillShow:(NSNotification *)notification
{
    //添加点击事件
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
}

-(void)mykeyboardWillHide:(NSNotification *)notification
{
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
}

-(NSArray*)buttonDicArr:(NSArray*)arr
{
    if (!arr) {
        NSArray *navArray = @[@{@"title":@"查工资", @"type":@"bao"}, @{@"title":@"灌薪水", @"type":@"guan"}, @{@"title":@"比薪资", @"type":@"bi"}, @{@"title":@"说薪闻", @"type":@"shuo"}, @{@"title":@"看钱景", @"type":@"kanqj"}];
        return navArray;
    }
    NSMutableArray * buttonDicArr = [[NSMutableArray alloc] init];
    for (NSString * str in  arr) {
        NSDictionary * dic;
        if ([str isEqualToString:@"baogz"]) {
            dic = @{@"title":@"查工资", @"type":@"bao"};
        } else if ([str isEqualToString:@"guanxs"]) {
            dic = @{@"title":@"灌薪水", @"type":@"guan"};
        } else if ([str isEqualToString:@"bixz"]) {
            dic = @{@"title":@"比薪资", @"type":@"bi"};
        } else if ([str isEqualToString:@"shuoxw"]) {
            dic = @{@"title":@"说薪闻", @"type":@"shuo"};
        }else if ([str isEqualToString:@"kanqj"]) {
            dic = @{@"title":@"看钱景", @"type":@"kanqj"};
        }else{
            continue;
        }
        
        [buttonDicArr addObject:dic];
    }
    
    return buttonDicArr;
}

-(void)btnResponse:(id)sender
{
    if (sender == _personCenterBtn) {
        
    }
    else if(sender == searchSalaryBtn)
    {
        SalaryIrrigationCtl *ctl = [[SalaryIrrigationCtl alloc] init];
        ctl.isSalarySearch = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}

#pragma mark - Action
- (IBAction)btnTypePush:(UIButton *)sender
{
    int type = 0;
    switch (sender.tag) {
        case 100:
            type = 1;
            break;
        case 200:
            type = 2;
            break;
        case 300:
            type = 3;
            break;
        default:
            break;
    }
    
    if(sender.tag == 300)
    {
        if ([Manager shareMgr].haveLogin) {
            SalaryChangeTypeCtl *ctl = [[SalaryChangeTypeCtl alloc] init];
            ctl.salaryType = type;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
        }else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType =LoginType_MyGuanXinShui;
        }
    }
    else
    {
        SalaryChangeTypeCtl *ctl = [[SalaryChangeTypeCtl alloc] init];
        ctl.salaryType = type;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:nil exParam:nil];
    }
}

-(void)showNoDataOkView:(BOOL)flag
{
    if(flag){
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if(noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
            rect.origin.x = (int)((noDataOkSuperView.frame.size.width - rect.size.width)/2.0);
            rect.origin.y = headView_.frame.size.height;
            [noDataOkView setFrame:rect];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }else{
        [[self getNoDataView] removeFromSuperview];
    }
}


@end
