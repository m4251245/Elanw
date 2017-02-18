//
//  ELVIPRecommendViewController.m
//  jobClient
//
//  Created by 一览ios on 16/10/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELVIPRecommendViewController.h"
#import "OfferPartyResumeEnumeration.h"
#import "ELOfferResumeCell.h"
#import "ELNewResumePreviewCtl.h"
#import "CHRResumeCell.h"
#import "ELResumeChangeCtl.h"

#define kSelBtnTag 98760
#define kSelShowTableTag 999900
#define kMaxToBottom 93

@interface ELVIPRecommendViewController ()<NewResumePreviewCtlDelegate,LoadDataBlockDelegate>{
    NSString *companyId_;
//    CHRSendInterviewNotificaCtl *sendInterviewNotifiCtl;
    NSString *interviewType;
    RequestCon *_sendInterviewCon;
    RequestCon *readMarkCon;
    NSString *tuijianId;
    
}
@property (nonatomic,retain)SearchParam_DataModal *searchParam;

@end

@implementation ELVIPRecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgTopSpace = 60;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addNotify];
    [self configUI];
}

#pragma mark--初始化UI
-(void)configUI{
    
}

#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    _searchParam = [[SearchParam_DataModal alloc] init];
}

-(void)getDataFunction:(RequestCon *)con
{
    if ([_jobId_ isEqualToString:@"0"]) {
        _jobId_ = @"";
    }
    [con getCompanyRecommendedResume:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20 jobid:_jobId_ searchModal:_searchParam];
    
}

#pragma mark - LoadDataBlockDelegate
-(void)requestLoadRequest:(RequestCon *)con{
    if ([_jobId_ isEqualToString:@"0"]) {
        _jobId_ = @"";
    }
    [con getCompanyRecommendedResume:companyId_ pageIndex:con.pageInfo_.currentPage_ pageSize:20 jobid:_jobId_ searchModal:_searchParam];
}

#pragma mark--请求数据
-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_CompanyRecommendedResume:
            _shouldRefresh = NO;
            break;
        case Request_CompanyResume:
            _shouldRefresh = NO;
            break;
        default:
            break;
    }
}

#pragma mark--代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)downloadResume:(User_DataModal*)dataModal{
    [self refreshLoad:nil];
}

#pragma mark - tableview delegatge
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    if ([userModel.forType isEqualToString:@"3000"]) {
        return 130;
    }
    return 132;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    
    static NSString *cellStr = @"ELOfferResumeCell";
    ELOfferResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ELOfferResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.fromtype = userModel.fromType;
    cell.resumeListType = ComResumeListTypeAllPerson;
    cell.indexPathRow = 3;
    cell.resumeType = OPResumeTypeAdvisersRecommend;
    cell.noticeInterviewBtn.tag = indexPath.row;
    cell.dataModal = userModel;
    cell.expertsCommentBtn.userInteractionEnabled = NO;
    return cell;
    
//    return [self tableView:tableView dataModel:userModel indexPath:indexPath];
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal *userModel = selectData;
    //未阅处理
    if (userModel.isNewmail_) {
        if (!readMarkCon) {
            readMarkCon = [self getNewRequestCon:NO];
        }
        [readMarkCon readMarkWithTuijianId:userModel.recommendId];
        userModel.isNewmail_ = NO;
        [tableView_ reloadData];
    }
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = _resumeType;
    resumePreviewCtl.delegate = self;
    resumePreviewCtl.isRecommend = YES;
    resumePreviewCtl.forType = userModel.forType; 
    
    resumePreviewCtl.selectRow = indexPath.row;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:userModel exParam:companyId_];
    
}

//延迟刷新小红点
- (void)delayFreshMssageCount
{
    [[Manager shareMgr].messageRefreshCtl requestCount];
}

#pragma mark - OtherResumePreviewCtlDelegate 简历评价合格／不合格
-(void)ModifyResume:(User_DataModal *)dataModal passed:(BOOL)bePassed
{
    for (User_DataModal * modal in requestCon_.dataArr_) {
        if ([modal.emailId_ isEqualToString:dataModal.emailId_]) {
            if (bePassed == NO) {
                modal.tongguo = @"2";
                break;
            }
        }
    }
    [tableView_ reloadData];
}

//#pragma mark--事件
//-(void)noticeInterviewBtnClick:(UIButton *)sender{
//    User_DataModal *userModel = requestCon_.dataArr_[sender.tag];
//    if (!sendInterviewNotifiCtl) {
//        sendInterviewNotifiCtl = [[CHRSendInterviewNotificaCtl alloc] init];
//    }
//    
//    sendInterviewNotifiCtl.companyId = companyId_;
//    sendInterviewNotifiCtl.jobfairId = userModel.jobfair_id;
//    sendInterviewNotifiCtl.userModel = userModel;
//}

-(void)recommendBtnClick:(UIButton *)btn{
    
    NSInteger index = btn.tag - 111111;
    User_DataModal *userModel = requestCon_.dataArr_[index];
    //未阅处理
    if (userModel.isNewmail_) {
        if (!readMarkCon) {
            readMarkCon = [self getNewRequestCon:NO];
        }
        [readMarkCon readMarkWithTuijianId:userModel.recommendId];
        userModel.isNewmail_ = NO;
        [tableView_ reloadData];
    }
    
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = _resumeType;
    resumePreviewCtl.delegate = self;
    resumePreviewCtl.isRecommend = YES;
    resumePreviewCtl.forType = userModel.forType;
    
    resumePreviewCtl.selectRow = index;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:userModel exParam:companyId_];
}


#pragma mark--通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"DetailSelWithELConditionSelection" object:nil];
}

-(void)notify:(NSNotification *)notified{
    NSDictionary *dic = notified.userInfo;
    _searchParam = dic[@"searchVO"];
    _jobId_ = dic[@"jobIdSlected"];
    [self refreshLoad:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView dataModel:(User_DataModal *)userModel indexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"CHRResumeCell";
    CHRResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    cell.userNameLb.text = userModel.uname_;
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;
    
    NSString *sex = userModel.sex_;
    if(userModel.age_.length < 4){
        if([userModel.age_ isEqualToString:@"暂无"]){
            [cell.sexBtn setTitle:@"无" forState:UIControlStateNormal];
        }
        else{
            [cell.sexBtn setTitle:userModel.age_ forState:UIControlStateNormal];
        }
    }
    else{
        [cell.sexBtn setTitle:@"无" forState:UIControlStateNormal];
    }
    if ([sex isEqualToString:@"男"]) {
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else if ([sex isEqualToString:@"女"]){
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }else{
        [cell.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    
    if (![userModel.tongguo isEqualToString:@"2"]) {//2表示不通过
        //合格
        if (userModel.isNewmail_) {
            //未阅
            cell.statusLb.hidden = NO;
            cell.statusLb.text = @"未阅";
        }else{
            //已阅
            cell.statusLb.hidden = YES;
        }
    }
    else
    {
        //不合格
        cell.statusLb.hidden = NO;
        cell.statusLb.text = @"不合格";
        cell.statuLbWidth.constant = 40;
    }
    
    NSDictionary *nameAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
    if (city.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:city attributes:nameAttr]];
    }
    if (workAge.length > 0) {
        if (attrString.length > 0)
        {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@年工作经验", workAge] attributes:nameAttr]];
    }
    if (eduName.length > 0) {
        if (attrString.length > 0)
        {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", eduName] attributes:nameAttr]];
    }
    cell.summaryLb.attributedText = attrString;
    
    if (userModel.job_) {
        cell.jobLb.text =[NSString stringWithFormat:@"推荐职位: %@", userModel.job_];
    }else{
        cell.jobLb.text = @"";
    }
    if (userModel.sendtime_.length>10) {
        cell.timeLb.text = [userModel.sendtime_ substringToIndex:10];
    }else{
        cell.timeLb.text = userModel.sendtime_;
    }
    if (userModel.report.length > 0 && userModel.report.integerValue == 1) {
        cell.recomendReporterBtn.hidden = NO;
    }
    else{
        cell.recomendReporterBtn.hidden = YES;
    }
    cell.recomendReporterBtn.tag = indexPath.row + 111111;
    [cell.recomendReporterBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

@end
