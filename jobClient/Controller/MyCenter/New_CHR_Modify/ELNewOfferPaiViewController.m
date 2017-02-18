//
//  ELNewOfferPaiViewController.m
//  jobClient
//
//  Created by 一览ios on 16/10/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewOfferPaiViewController.h"
#import "CHRSendInterviewNotificaCtl.h"
#import "OfferPartyResumeEnumeration.h"
#import "ELOfferResumeCell.h"
#import "ELNewResumePreviewCtl.h"
#import "CHRResumeCell.h"
#import "ELResumeChangeCtl.h"

@interface ELNewOfferPaiViewController ()<NewResumePreviewCtlDelegate,LoadDataBlockDelegate>{
    NSString *companyId_;
    CHRSendInterviewNotificaCtl *sendInterviewNotifiCtl;
    NSString *interviewType;
    RequestCon *_sendInterviewCon;
    RequestCon *readMarkCon;
    NSString *tuijianId;
}

@property (nonatomic,retain)SearchParam_DataModal *searchParam;

@end

@implementation ELNewOfferPaiViewController

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addNotify];
    [self configUI];
    
    self.imgTopSpace = 60;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"KrefreshResumeList" object:nil];
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
    //    3000 交付 offer    3001 顾问 正常
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    if ([userModel.forType isEqualToString:@"3000"]) {
        static NSString *cellStr = @"ELOfferResumeCell";
        ELOfferResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ELOfferResumeCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.noticeInterviewBtn addTarget:self action:@selector(noticeInterviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.fromtype = userModel.fromType;
        cell.resumeListType = ComResumeListTypeAllPerson;
        cell.indexPathRow = 3;
        cell.resumeType = OPResumeTypeAdvisersRecommend;
        cell.noticeInterviewBtn.tag = indexPath.row;
        cell.dataModal = userModel;

        if ([userModel.wait_mianshi isEqualToString:@"1"]) {
            cell.noticeInterviewBtn.hidden = NO;
            cell.delayInterviewBtn.hidden = NO;
        }
        else{
            cell.noticeInterviewBtn.hidden = YES;
            cell.delayInterviewBtn.hidden = YES;
        }
        cell.expertsCommentBtn.tag = indexPath.row + 111111;
        [cell.expertsCommentBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.delayInterviewBtn.tag = indexPath.row + 2222222;
        [cell.delayInterviewBtn addTarget:self action:@selector(delayInterviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
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
    resumePreviewCtl.resumeEntry = 1;
    resumePreviewCtl.selectRow = indexPath.row;
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.loadDelegate = self;
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

#pragma mark - 刷新列表
- (void)refreshList:(NSNotificationCenter *)noti
{
    
}

#pragma mark--事件
//通知面试
-(void)noticeInterviewBtnClick:(UIButton *)sender{
    User_DataModal *userModel = requestCon_.dataArr_[sender.tag];
    if (!sendInterviewNotifiCtl) {
        sendInterviewNotifiCtl = [[CHRSendInterviewNotificaCtl alloc] init];
    }
    
    sendInterviewNotifiCtl.companyId = companyId_;
    sendInterviewNotifiCtl.jobfairId = userModel.jobfair_id;
    sendInterviewNotifiCtl.userModel = userModel;
}

//推荐报告
-(void)recommendBtnClick:(UIButton *)btn{
    
    NSInteger indexRow = btn.tag - 111111;
    User_DataModal *userModel = requestCon_.dataArr_[indexRow];
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
    
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.selectRow = indexRow;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.resumeEntry = 1;
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:userModel exParam:companyId_];
}

//延迟面试
- (void)delayInterviewBtnClick:(UIButton *)btn{
    NSInteger indexRow = btn.tag - 2222222;
    User_DataModal *userModel = requestCon_.dataArr_[indexRow];
    
    [self changeDeliverResumeWithType:@"jumpline" State:@"" userModel:userModel];
}

//修改简历状态
- (void)changeDeliverResumeWithType:(NSString *)type State:(NSString *)state userModel:(User_DataModal *)model
{
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"20" forKey:@"role"];
//    [conditionDic setObject:companyId_ forKey:@"role_id"];
//    
//    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
//    
//    NSString * bodyMsg = [NSString stringWithFormat:@"tuijian_id={\"id\":[\"%@\"]}&filetype=%@&state=%@&conditionArr=%@", model.recommendId, type, state, conditionStr];
//    
//    NSString * function = @"updateTjState";
//    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:companyId_ forKey:@"reid"];
    [tjresumeDic setObject:@"" forKey:@"id"];
    [tjresumeDic setObject:companyId_ forKey:@"company_id"];
    [tjresumeDic setObject:@"company" forKey:@"type"];
    [tjresumeDic setObject:@"2" forKey:@"state"];
    
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:@"" forKey:@"jobid"];
    [commentDic setObject:@"" forKey:@"commentContent"];
    [commentDic setObject:@"简历合适" forKey:@"comment_type"];
    [commentDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"20" forKey:@"role"];
    [conditionDic setObject:companyId_ forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=%@", tjresumeStr, commentStr, conditionStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";

    
    [BaseUIViewController showLoadView:YES content:@"正在处理" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result isEqual:@1]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
             [self refreshLoad:nil];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
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

@end
