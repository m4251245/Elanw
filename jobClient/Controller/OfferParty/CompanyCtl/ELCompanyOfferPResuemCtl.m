//
//  ELCompanyOfferPResuemCtl.m
//  jobClient
//
//  Created by YL1001 on 16/9/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCompanyOfferPResuemCtl.h"
#import "ELOfferResumeCell.h"
#import "New_HeaderBtn.h"
#import "SBJsonWriter.h"
#import "OfferPartyCompanyResumeModel.h"
#import "ELOfferPartyCompanyResumePreviewCtl.h"
#import "OfferResumePreviewCtl.h"
#import "CHRSendInterviewNotificaCtl.h"
#import "ELNewResumePreviewCtl.h"
#import "ELResumeChangeCtl.h"

@interface ELCompanyOfferPResuemCtl ()<UITextFieldDelegate,ConditionItemCtlDelegate,New_HeaderDelegate,LoadDataBlockDelegate>
{
    UIView *_searchBgView;
    New_HeaderBtn *_typeBtn;
    UITextField *_searTextF;
    
    NSString *_keyWords;
    NSMutableDictionary *_searchDic;
    
    NSMutableArray *_positionArr;
    
    CHRSendInterviewNotificaCtl *_sendInterviewCtl;
    
    NSInteger      currentPage;//当前页
    BOOL     refreshData;//
    NSMutableArray *dataSource;//简历预览使用
}

@end

@implementation ELCompanyOfferPResuemCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    refreshData = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataSource = [NSMutableArray array];
    [self configUI];
    refreshData = YES;
}


- (void)configUI
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    backgroudView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroudView];
    
    _typeBtn = [[New_HeaderBtn alloc] initWithFrame:CGRectMake(0, 0, 70, 45) withTitle:@"全部" arrCount:0];
    _typeBtn.titleLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _typeBtn.markImg.hidden = YES;
    _typeBtn.delegate = self;
    [backgroudView addSubview:_typeBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenWidth - 50, 5, 42, 35);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:UIColorFromRGB(0x555B63)];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:searchBtn];
    
    _searchBgView = [[UIView alloc] init];
    _searchBgView.backgroundColor = [UIColor clearColor];
    _searchBgView.layer.borderWidth = 1.0;
    _searchBgView.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
    [backgroudView addSubview:_searchBgView];
    
    if (_counselorFlag) {
        if (_resumeListType == ComResumeListTypeToInterview && [self.fromtype isEqualToString:@"offer"]) {
            _typeBtn.hidden = YES;
        }
    }
    else
    {
               
        if (_resumeListType == ComResumeListTypeToInterview && [self.fromtype isEqualToString:@"vph"]) {
            _typeBtn.hidden = NO;
            _typeBtn.titleLb.text = @"职位";
        }
    }
    
    if (_typeBtn.hidden) {
        _searchBgView.frame = CGRectMake(10, 5, ScreenWidth-68, 35);
    }
    else {
        _searchBgView.frame = CGRectMake(78, 5, ScreenWidth-136, 35);
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 13, 13)];
    imageview.image = [UIImage imageNamed:@"offer_search.png"];
    [_searchBgView addSubview:imageview];
    
    _searTextF = [[UITextField alloc] initWithFrame:CGRectMake(26, 6, _searchBgView.frame.size.width - 34, 25)];
    _searTextF.font = [UIFont systemFontOfSize:14.0f];
    _searTextF.placeholder = @"搜索人才名";
    _searTextF.delegate = self;
    [_searchBgView addSubview:_searTextF];
    
}

- (void)beginLoad:(id)param exParam:(id)exParam
{
    [super beginLoad:param exParam:exParam];
    
    [self requestDeliverResume];
}

- (void)requestDeliverResume
{
    if (!_keyWords) {
        _keyWords = @"";
    }
    
    NSString *op = @"offerpai_busi";
    NSString *func = @"getJjrPersonList";
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld", (long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:_keyWords forKey:@"person_name"];
    [searchDic setObject:self.jobfair_id forKey:@"jobfair_id"];
    
    if (_searchDic) {
        NSString *key = _searchDic.allKeys[0];
        [searchDic setObject:_searchDic[key] forKey:key];
    }

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSString *personType;
    switch (_resumeListType) {
        case ComResumeListTypeAllPerson:
        {
            personType = @"";
        }
            break;
         case ComResumeListTypePrimaryElection:
        {
            personType = @"company_state";
        }
            break;
        case ComResumeListTypeHasPresent:
        {
            personType = @"join_state";
        }
            break;
        case ComResumeListTypeToInterview:
        {
            personType = @"wait_interview";
        }
            break;
        case ComResumeListTypeHasInterviewed:
        {
            personType = @"mianshi_state";
        }
            break;
        default:
            break;
    }
    
    NSString *bodyMsg = [NSString stringWithFormat:@"fromtype=%@&company_id=%@&type=%@&searchArr=%@&conditionArr=%@&", self.fromtype, _companyId,personType, searchStr, conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dic = result;
        [self parserPageInfo:dic];
        
        NSArray *array = dic[@"data"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in array) {
                /*
                OfferPartyCompanyResumeModel *model = [[OfferPartyCompanyResumeModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArray addObject:model];
                 */
                
                User_DataModal *model = [[User_DataModal alloc]init];
                @try {
                    model.userId_ = dataDic[@"person_id"];
                    model.jobfair_person_id = dataDic[@"jobfair_person_id"];
                    model.resumeId = dataDic[@"resume_id"];
                    model.recommendId = dataDic[@"tuijian_id"];
                    model.img_ = dataDic[@"pic"];
                    model.uname_ = dataDic[@"person_name"];
                    model.name_ = dataDic[@"person_name"];
                    model.regionCity_ = dataDic[@"region"];
                    model.gzNum_ = dataDic[@"gznum"];
                    model.eduName_ = dataDic[@"eduId"];
                    model.job_ = dataDic[@"job_tj"];
                    model.sendtime_ = dataDic[@"add_time"];
                    model.mobile_ = dataDic[@"shouji"];
                    model.sex_ = dataDic[@"sex"];
                    model.age_ = dataDic[@"nianling"];
                    model.filePath = dataDic[@"evaluate_filepath"];
                    model.pages = dataDic[@"pages"];
                    model.wait_mianshi = dataDic[@"wait_mianshi"];
                    model.report = dataDic[@"report"];
                    model.reportUrl = dataDic[@"reportUrl"];
                    model.zpId_ = [dataDic objectForKey:@"job_id"];
                    model.add_user = dataDic[@"add_user"];
                    
//                    model.recommendState = dataDic[@"tj_state"];//0未推荐；4人才投递；5顾问推荐
//                    if ([model.recommendState isEqualToString:@"4"]) {
//                        model.resumeType = OPResumeTypeInterviewSelfDeliver;
//                    }
//                    else if ([model.recommendState isEqualToString:@"5"]) {
//                        model.resumeType = OPResumeTypeAdvisersRecommend;
//                    }
                    
                    
                    if ([dataDic[@"work_state"] isEqualToString:@"1"]) {//已上岗
                        model.resumeType = OPResumeTypeWorked;
                    }
                    else if ([dataDic[@"luyong_state"] isEqualToString:@"1"]) {//已发offer
                        model.resumeType = OPResumeTypeSendOffer;
                    }
                    else if ([dataDic[@"mianshi_state"] isEqualToString:@"6"]) {//初面通过
                        model.resumeType = OPResumeTypeInterviewed;
                    }
                    else if ([dataDic[@"mianshi_state"] isEqualToString:@"7"]) {//初面不通过
                        model.resumeType = OPResumeTypeInterviewUnqualified;
                    }
                    else if ([dataDic[@"mianshi_state"] isEqualToString:@"60"]){//已放弃面试
                        model.resumeType = OPResumeTypeGivedUpInterview;
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"1"]) {//简历合适
                        model.resumeType = OPResumeTypeConfirmFit;
                        
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"2"]) {//简历不合适
                        model.resumeType = OPResumeTypeNoConfirFit;
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"3"]) {//待确定
                        model.resumeType = OPResumeTypeWait;
                        
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"0"] && ![dataDic[@"company_state"] isEqualToString:@""]){//待处理
                        model.resumeType = OPResumeTypenotOperating;
                    }
                    
                    
                    if ([dataDic[@"read_state"] isEqualToString:@"1"]) {
                        model.isNewmail_ = NO;
                    }else{
                        model.isNewmail_ = YES;
                    }
                    
                    model.joinState = dataDic[@"join_state"];//到场状态
                    model.interviewState = dataDic[@"mianshi_state"];//面试状态
                    model.leaveState = dataDic[@"leave_state"];
                    model.commentContent = dataDic[@"comment_content"];
                    model.jlType = dataDic[@"fromtype"];
                    model.role_id = dataDic[@"uId"];
                    model.isDown = dataDic[@"isdown"];
                    [_dataArray addObject:model];
                    
                 
                }
                @catch (NSException *exception) {
                    
                }
            }
          
        }
        [dataSource removeAllObjects];
        [dataSource addObjectsFromArray:_dataArray];
        [self.tableView reloadData];
        
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"ELOfferResumeCell";
    ELOfferResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ELOfferResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.noticeInterviewBtn addTarget:self action:@selector(noticeInterviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    User_DataModal *userModel = _dataArray[indexPath.row];
    
    cell.fromtype = _fromtype;
    cell.resumeListType = _resumeListType;
    cell.resumeType = _resumeType;
    cell.indexPathRow = indexPath.row;
    cell.noticeInterviewBtn.tag = indexPath.row;
    cell.dataModal = userModel;
    cell.expertsCommentBtn.tag = indexPath.row + 111111;
    [cell.expertsCommentBtn addTarget:self action:@selector(expertsCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.fromtype isEqualToString:@"offer"]) {
        if (_resumeListType == ComResumeListTypeToInterview && !_counselorFlag) {
            cell.delayInterviewBtn.hidden = NO;
            cell.delayInterviewBtn.tag = indexPath.row + 2222222;
            [cell.delayInterviewBtn addTarget:self action:@selector(delayInterviewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.delayInterviewBtn.hidden = YES;
        }

    }else{
        cell.delayInterviewBtn.hidden = YES;
        cell.noticeInterviewBtn.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searTextF isFirstResponder]) {
        [_searTextF resignFirstResponder];
        return;
    }
    
    User_DataModal *userModel = _dataArray[indexPath.row];
    //未阅处理
    if (userModel.isNewmail_) {
        [self readMarkWithRecommendId:userModel.recommendId];
        userModel.isNewmail_ = NO;
        [self.tableView reloadData];
    }
    
    if (_counselorFlag) {
        [self intoCounselorRec:userModel];
    }
    else {
        [self intoCompanyReport:userModel selectRow:indexPath.row];
    }
}

- (void)readMarkWithRecommendId:(NSString *)recommendId
{
    NSString * function = @"updateCompanyReadState";
    NSString * op = @"offerpai_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"tuijian_id=%@", recommendId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        //不用处理返回结果
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 点击
- (void)searchBtnClick:(UIButton *)sender
{
    [_searTextF resignFirstResponder];
    _keyWords = _searTextF.text;
    [self refreshLoad];
}
    
//点击进入顾问报告
- (void)expertsCommentBtnClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 111111;
    User_DataModal *userModel = _dataArray[tag];
    if (_counselorFlag) {//顾问
        [self intoCounselorRec:userModel];
    }
    else{//企业
        [self intoCompanyReport:userModel selectRow:tag];
    }
}
//延迟面试
- (void)delayInterviewBtnClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 2222222;
    User_DataModal *userModel = _dataArray[tag];
    if (!_counselorFlag) {
         [self changeDeliverResumeWithType:@"jumpline" State:@"" userModel:userModel];
    }
}

//修改简历状态
- (void)changeDeliverResumeWithType:(NSString *)type State:(NSString *)state userModel:(User_DataModal *)model
{
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"20" forKey:@"role"];
//    [conditionDic setObject:_companyId forKey:@"role_id"];
//    
//    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
//    
//    NSString * bodyMsg = [NSString stringWithFormat:@"tuijian_id={\"id\":[\"%@\"]}&filetype=%@&state=%@&conditionArr=%@", model.recommendId, type, state, conditionStr];
//    
//    NSString * function = @"updateTjState";
//    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:model.role_id forKey:@"reid"];
    [tjresumeDic setObject:model.recommendId forKey:@"id"];
    [tjresumeDic setObject:_companyId forKey:@"company_id"];
    [tjresumeDic setObject:type forKey:@"type"];
    [tjresumeDic setObject:state forKey:@"state"];
    
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:model.zpId_ forKey:@"jobid"];
    [commentDic setObject:@"" forKey:@"commentContent"];
    [commentDic setObject:@"延迟面试" forKey:@"comment_type"];
    [commentDic setObject:model.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"20" forKey:@"role"];
//    [conditionDic setObject:_companyId forKey:@"role_id"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@", tjresumeStr, commentStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";

    
    [BaseUIViewController showLoadView:YES content:@"正在处理" view:nil];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result isEqual:@1]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
            [self refreshLoad];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}


//顾问
-(void)intoCounselorRec:(User_DataModal *)userModel
{
    OfferResumePreviewCtl *offResumeCtl = [[OfferResumePreviewCtl alloc] init];
    if (userModel.report.length > 0 && userModel.report.integerValue == 1) {
        offResumeCtl.isRecommend = YES;
    }
    else{
        offResumeCtl.isRecommend = NO;
    }
    //从当前页面跳转过去是 resumeListType 没什么作用
    offResumeCtl.resumeListType = OPResumeListTypeConfirmToAttend;
    offResumeCtl.jobfair_id = self.jobfair_id;
    offResumeCtl.consultantCompanyFlag = YES;
    
    [self.navigationController pushViewController:offResumeCtl animated:YES];
    [offResumeCtl beginLoad:userModel exParam:_companyId];
}

//企业
-(void)intoCompanyReport:(User_DataModal *)userModel selectRow:(NSInteger)selectRow
{
    ELResumeChangeCtl *previewCtl = [[ELResumeChangeCtl alloc] init];
    if (userModel.report.length > 0 && userModel.report.integerValue == 1) {
        previewCtl.isRecommend = YES;
    }
    else{
        previewCtl.isRecommend = NO;
    }

//    previewCtl.offerModel = _fromtype;
    previewCtl.resumeSelectType = _resumeListType;
    previewCtl.loadDelegate = self;
    previewCtl.currentPage = self.pageInfo.currentPage_;
    previewCtl.selectRow = selectRow;
    previewCtl.arrData = _dataArray;
    previewCtl.resumeEntry = 2;
    previewCtl.totalCount = self.pageInfo.totalCnt_;
    previewCtl.fromtype = _fromtype;
//    previewCtl.resumeListType = _resumeListType;
//    previewCtl.delegate = self;

    [self.navigationController pushViewController:previewCtl animated:YES];

    [previewCtl beginLoad:userModel exParam:_companyId];
    
}

- (void)requestLoadRequest:(RequestCon *)con
{

    if (!_keyWords) {
        _keyWords = @"";
    }
    NSString *personType = [NSString stringWithFormat:@"%ld", (long)_resumeListType];
    
    NSString *op = @"offerpai_busi";
    NSString *func = @"getPersonList";
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld", (long)con.pageInfo_.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:_keyWords forKey:@"search_name"];
    if (_searchDic) {
        [conditionDic setDictionary:_searchDic];
    }
    
    if ([Manager getHrInfo].userName) {
        [conditionDic setObject:[Manager getHrInfo].userName forKey:@"u_user"];
    }
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&uId=%@&person_type=%@&conditionArr=%@&", self.jobfair_id, _companyId, personType, conditionStr];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        
        NSDictionary *dic = result;
        
        NSArray *array = dic[@"data"];
      
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDic in array) {
                
                User_DataModal *model = [[User_DataModal alloc]init];
                @try {
                    model.userId_ = dataDic[@"person_id"];
                    model.jobfair_person_id = dataDic[@"jobfair_person_id"];
                    model.resumeId = dataDic[@"resume_id"];
                    model.recommendId = dataDic[@"tuijian_id"];
                    model.img_ = dataDic[@"pic"];
                    model.uname_ = dataDic[@"person_name"];
                    model.name_ = dataDic[@"person_name"];
                    model.regionCity_ = dataDic[@"region"];
                    model.gzNum_ = dataDic[@"gznum"];
                    model.eduName_ = dataDic[@"eduId"];
                    model.job_ = dataDic[@"job_tj"];
                    model.sendtime_ = dataDic[@"add_time"];
                    model.mobile_ = dataDic[@"shouji"];
                    model.sex_ = dataDic[@"sex"];
                    model.age_ = dataDic[@"nianling"];
                    model.filePath = dataDic[@"evaluate_filepath"];
                    model.pages = dataDic[@"pages"];
                    model.wait_mianshi = dataDic[@"wait_mianshi"];
                    model.report = dataDic[@"report"];
                    model.reportUrl = dataDic[@"reportUrl"];
                    model.zpId_ = [dataDic objectForKey:@"job_id"];
                    
                    model.recommendState = dataDic[@"tj_state"];//0未推荐；4人才投递；5顾问推荐
                    if ([model.recommendState isEqualToString:@"4"]) {
                        model.resumeType = OPResumeTypeInterviewSelfDeliver;
                    }
                    else if ([model.recommendState isEqualToString:@"5"]) {
                        model.resumeType = OPResumeTypeAdvisersRecommend;
                    }
                    
                    model.notOperating = NO;
                    if ([dataDic[@"work_state"] isEqualToString:@"1"]) {
                        model.resumeType = OPResumeTypeWorked;
                    }
                    else if ([dataDic[@"luyong_state"] isEqualToString:@"1"]) {
                        model.resumeType = OPResumeTypeSendOffer;
                    }
                    else if ([dataDic[@"mianshi_state"] isEqualToString:@"6"]) {
                        model.resumeType = OPResumeTypeInterviewed;
                    }
                    else if ([dataDic[@"mianshi_state"] isEqualToString:@"7"]) {
                        model.resumeType = OPResumeTypeInterviewUnqualified;
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"0"]) {
                        model.notOperating = YES;
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"1"]) {
                        model.resumeType = OPResumeTypeConfirmFit;
                        
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"2"]) {
                        model.resumeType = OPResumeTypeNoConfirFit;
                    }
                    else if ([dataDic[@"company_state"] isEqualToString:@"3"]) {
                        model.resumeType = OPResumeTypeWait;
                        model.notOperating = YES;
                    }
                    
                    if ([dataDic[@"read_state"] isEqualToString:@"1"]) {
                        model.isNewmail_ = NO;
                    }else{
                        model.isNewmail_ = YES;
                    }
                    
                    model.joinState = dataDic[@"join_state"];//到场状态
                    model.interviewState = dataDic[@"mianshi_state"];//面试状态
                    model.leaveState = dataDic[@"leave_state"];
                    model.commentContent = dataDic[@"comment_content"];
                    model.jlType = dataDic[@"fromtype"];
                    model.role_id = dataDic[@"uId"];
                    model.isDown = dataDic[@"isdown"];
                    [dataSource addObject:model];
                    
                    
                }
                @catch (NSException *exception) {
                    
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResumeCount" object:nil userInfo:@{@"key":dataSource}];
        }
        
        [self finishReloadingData];
        [self refreshEGORefreshView];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];

    
    
}
#pragma mark 通知面试
/**
 * userModel.interviewState,40 //不愿意参加面试
 * userModel.interviewState,20 //面试中
 * userModel.interviewState,30 //企业取消面试
 */
- (void)noticeInterviewBtnClick:(UIButton *)sender
{
    if (!_sendInterviewCtl) {
        _sendInterviewCtl = [[CHRSendInterviewNotificaCtl alloc] init];
    }
    
    _sendInterviewCtl.companyId = _companyId;
    _sendInterviewCtl.jobfairId = self.jobfair_id;
    _sendInterviewCtl.userModel = _dataArray[sender.tag];
}

#pragma mark - 代理
//UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnClick:nil];
    return YES;
}

#pragma mark CompanyResumePreviewDelegate
- (void)operationSuccessful
{
    [self refreshLoad];
}

#pragma mark New_HeaderDelegate
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender;
{
    //企业hr
    NSArray *optionTypes = nil;
    
    if ([self.fromtype isEqualToString:@"offer"]) {
        if(_resumeListType == ComResumeListTypeAllPerson){
            optionTypes = @[@[@"全部", @"待处理",@"待确定",@"简历合适",@"简历不合适", @"初面通过", @"初面不通过", @"放弃面试",@"已发offer",@"已上岗"], @[@"", @"company_state",@"company_state",@"company_state", @"company_state", @"mianshi_state",@"mianshi_state",@"company_state",@"luyong_state",@"work_state"],@[@"",@"0",@"3",@"1",@"2",@"6",@"7",@"60",@"1",@"1"]];
        }
        else if (_resumeListType == ComResumeListTypePrimaryElection) {
            optionTypes = @[@[@"全部", @"待处理", @"待确定",@"简历合适",@"简历不合适"], @[@"", @"company_state", @"company_state",@"company_state",@"company_state"],@[@"",@"0",@"3",@"1",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeToInterview){
            optionTypes = @[@[@"全部",@"简历合适",@"主动申请",@"顾问推荐",@"待确定",@"简历不合适"],@[@"",@"company_state",@"add_user",@"add_user",@"company_state",@"company_state"],@[@"",@"1",@"0",@"1",@"3",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeHasInterviewed){
            optionTypes = @[@[@"全部", @"初面通过", @"初面不通过", @"放弃面试",@"已发offer", @"已上岗"], @[@"",@"mianshi_state", @"mianshi_state", @"company_state", @"luyong_state",@"work_state"],@[@"",@"6",@"7",@"60",@"1",@"1"]];
        }
        else if (_resumeListType == ComResumeListTypeHasPresent){
            optionTypes = @[@[@"全部",@"待处理",@"待确定", @"简历合适",@"简历不合适"], @[@"",@"company_state",@"company_state",@"company_state",@"company_state"],@[@"",@"0",@"3",@"1",@"2"]];
        }
        
        if (!optionTypes) {
            return;
        }
        
    }
    else if ([self.fromtype isEqualToString:@"kpb"])
    {
        if(_resumeListType == ComResumeListTypeAllPerson){
            optionTypes = @[@[@"全部", @"待处理", @"待确定",@"简历合适",@"简历不合适",@"初面通过", @"初面不通过",@"已发offer",@"已上岗"], @[@"", @"company_state", @"company_state",@"company_state",@"company_state",@"mianshi_state",@"mianshi_state",@"luyong_state",@"work_state"],@[@"",@"0",@"3",@"1",@"2",@"6",@"7",@"1",@"1"]];
        }
        else if (_resumeListType == ComResumeListTypePrimaryElection){
            optionTypes = @[@[@"全部",@"待处理",@"待确定",@"简历合适",@"简历不合适"],@[@"",@"company_state",@"company_state",@"company_state",@"company_state"],@[@"",@"0",@"3",@"1",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeToInterview){
            optionTypes = @[@[@"全部",@"待处理",@"简历合适",@"顾问推荐",@"待确定",@"简历不合适"],@[@"",@"company_state",@"company_state",@"add_user",@"company_state",@"company_state"],@[@"",@"0",@"1",@"1",@"3",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeHasInterviewed){
            optionTypes = @[@[@"全部", @"初面通过", @"初面不通过", @"已发offer", @"已上岗"], @[@"",@"mianshi_state", @"mianshi_state", @"luyong_state", @"work_state"],@[@"",@"6",@"7",@"1",@"1"]];
        }
        
    }
    else if ([self.fromtype isEqualToString:@"vph"])
    {
        if(_resumeListType == ComResumeListTypeAllPerson){
              optionTypes = @[@[@"全部", @"待处理", @"待确定",@"简历合适",@"简历不合适",@"初面通过", @"初面不通过",@"已发offer",@"已上岗"], @[@"", @"company_state", @"company_state",@"company_state",@"company_state",@"mianshi_state",@"mianshi_state",@"luyong_state",@"work_state"],@[@"",@"0",@"3",@"1",@"2",@"6",@"7",@"1",@"1"]];
        }
        else if (_resumeListType == ComResumeListTypePrimaryElection){
            optionTypes = @[@[@"全部", @"待处理", @"待确定", @"简历合适", @"简历不合适"], @[@"",@"company_state", @"company_state", @"company_state", @"company_state"],@[@"",@"0",@"3",@"1",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeToInterview)
        {
            optionTypes = [_positionArr copy];
        }
        else if (_resumeListType == ComResumeListTypeHasInterviewed){
             optionTypes = @[@[@"全部", @"初面通过", @"初面不通过", @"已发offer", @"已上岗"], @[@"",@"mianshi_state", @"mianshi_state", @"luyong_state", @"work_state"],@[@"",@"6",@"7",@"1",@"1"]];
        }
    }
    else if ([self.fromtype isEqualToString:@"hunter"]){
    
        if(_resumeListType == ComResumeListTypeAllPerson){
            optionTypes = @[@[@"全部", @"待处理", @"待确定",@"简历合适",@"简历不合适",@"初面通过", @"初面不通过",@"已发offer",@"已上岗"], @[@"", @"company_state", @"company_state",@"company_state",@"company_state",@"mianshi_state",@"mianshi_state",@"luyong_state",@"work_state"],@[@"",@"0",@"3",@"1",@"2",@"6",@"7",@"1",@"1"]];
        }
        else if (_resumeListType == ComResumeListTypePrimaryElection){
             optionTypes = @[@[@"全部", @"待处理", @"待确定", @"简历合适", @"简历不合适"], @[@"",@"company_state", @"company_state", @"company_state", @"company_state"],@[@"",@"0",@"3",@"1",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeToInterview){
            optionTypes = @[@[@"全部", @"待处理", @"简历合适",@"顾问推荐",@"待确定", @"简历不合适"], @[@"",@"company_state", @"company_state", @"add_user", @"company_state",@"company_state"],@[@"",@"0",@"1",@"1",@"3",@"2"]];
        }
        else if (_resumeListType == ComResumeListTypeHasInterviewed){
             optionTypes = @[@[@"全部", @"初面通过", @"初面不通过", @"已发offer", @"已上岗"], @[@"",@"mianshi_state", @"mianshi_state", @"luyong_state", @"work_state"],@[@"",@"6",@"7",@"1",@"1"]];
        }
    }
    
    ConditionItemCtl *conditionCtl = [[ConditionItemCtl alloc]init];
    conditionCtl.delegate_ = self;
    [self.navigationController pushViewController:conditionCtl animated:YES];
    [conditionCtl beginLoad:optionTypes exParam:nil];

}

#pragma mark ConditionItemCtlDelegate
- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1
{
    NSLog(@"------  %u  - %@  - %@ -%@",type,conditionName,conditionValue,conditionValue1);
    _typeBtn.titleLb.text = conditionName;
    
    
    //企业hr
    if (!_searchDic) {
        _searchDic = [NSMutableDictionary dictionary];
    }
    [_searchDic removeAllObjects];
    [_searchDic setObject:conditionValue1 forKey:conditionValue];
    
//    if ([conditionValue isEqualToString:@"1"] || [conditionValue isEqualToString:@"2"]) {
//        _searchDic[@"join_state"] = conditionValue;
//        _searchDic[@"ztai"] = @"";
//        _searchDic[@"leave_state"] = @"";
//    }
//    else if ([conditionValue isEqualToString:@"5"] || [conditionValue isEqualToString:@"6"] || [conditionValue isEqualToString:@"7"]|| [conditionValue isEqualToString:@"8"]|| [conditionValue isEqualToString:@"9"] || [conditionValue isEqualToString:@"11"] || [conditionValue isEqualToString:@"12"])
//    {
//        _searchDic[@"ztai"] = conditionValue;
//        _searchDic[@"join_state"] = @"";
//        _searchDic[@"leave_state"] = @"";
//    }
//    else if ([conditionValue isEqualToString:@"13"])
//    {
//        _searchDic[@"join_state"] = @"";
//        _searchDic[@"ztai"] = @"";
//        _searchDic[@"leave_state"] = @"1";
//    }
//    else if (_resumeType == OPResumeTypeToInterview && [self.fromtype isEqualToString:@"vph"])
//    {
//        _searchDic[@"job_id"] = conditionValue;
//    }
//    else{
//        _searchDic[@"join_state"] = @"";
//        _searchDic[@"ztai"] = @"";
//        _searchDic[@"leave_state"] = @"";
//    }
    
    [self refreshLoad];
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
