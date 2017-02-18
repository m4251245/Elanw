
//
//  CHRIndexCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CHRIndexCtl.h"
#import "CHRIndexCtl_Cell.h"
#import "CompanyHRCtl.h"
#import "CompanySearchCtl.h"
#import "CHROfferPartyListCtl.h"
#import "CompanyResumeCtl.h"
#import "ZBarScanLoginCtl.h"
#import "HRLoginCtl.h"
#import "InbiddingJobCtl.h"

@interface CHRIndexCtl ()
{
    NSMutableArray *_menuArray;
    CompanyInfo_DataModal *_companyInfo;
    NSDictionary *_offerPartyDic;
    NSDictionary *_titleNameDic;
    NSString *tempTitle;
}


@end

@implementation CHRIndexCtl

- (instancetype)init
{
    if (self = [super init]) {
        bFooterEgo_= NO;
        bHeaderEgo_ = NO;
        self.title = @"我的招聘";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if(_islogin){
        self.fd_interactivePopDisabled = YES;
    }
    NSArray *menuArray = @[@{@"title":@"已通知面试", @"cnt":@"", @"isNew":@(NO) ,@"type":@"yfms", @"img":@"chr_send_interview.png"}, @{@"title":@"人才提问", @"cnt":@"", @"isNew":@(NO) ,@"type":@"rctw", @"img":@"chr_question.png"},  @{@"title":@"扫描二维码", @"cnt":@"", @"isNew":@(NO) ,@"type":@"smdl", @"img":@"chr_scan_login.png"}, @{@"title":@"企业服务", @"cnt":@"", @"isNew":@(NO) ,@"type":@"qyfw", @"img":@"chr_company_service.png"}];
    
    //offer派 V聘会 快聘宝
    _offerPartyDic = @{@"title1":@"Offer派",@"title2":@"快聘宝",@"title3":@"V聘会",@"title4":@"Offer派 快聘宝",@"title5":@"Offer派 V聘会",@"title6":@"快聘宝 V聘会",@"title7":@"Offer派 快聘宝 V聘会", @"cnt":@"", @"isNew":@(YES) ,@"type":@"op", @"img":@"chr_offer_party.png"};
    
    _menuArray = [NSMutableArray arrayWithArray:menuArray];
    CGRect rect = tableView_.frame;
    rect.size.height = self.view.bounds.size.height;
    tableView_.frame = rect;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [MyCommon addTapGesture:_headMenuView target:self numberOfTap:1 sel:@selector(headMenuViewClick:)];
    CALayer *layer = _companyLogoImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2.f;
    layer.borderWidth = 0.5f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    [self refreshNewImgv];
    myRightBarBtnItem_.userInteractionEnabled = NO;
    
    float viewWidth = ScreenWidth/4;
    CGRect frame = _ReceivedView.frame;
    frame.origin.x = 0;
    frame.size.width = viewWidth;
    _ReceivedView.frame = frame;
    
    frame.origin.x = viewWidth;
    _adviserRecoView.frame = frame;
    
    frame.origin.x = viewWidth*2;
    _downView.frame = frame;
    
    frame.origin.x = viewWidth*3;
    _tempSaveView.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的招聘";
    [self setFd_prefersNavigationBarHidden:NO];
    [self refreshLoad:requestCon_];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark 判断是否显示新图标
- (void)refreshNewImgv
{
    NSString *clickTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"clickTime"];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  currTimeStr=[dateformatter stringFromDate:senddate];
    if (!clickTime) {
        _newerImgv.hidden = NO;
        //显示新
    }else{
        if ([currTimeStr compare:clickTime options:NSCaseInsensitiveSearch] == NSOrderedDescending) {//>
            //显示新的
            _newerImgv.hidden = NO;
        }else{//隐藏新的
            _newerImgv.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 点击菜单
- (void)headMenuViewClick:(UITapGestureRecognizer *)sender
{

   CGPoint point = [sender locationInView:_headMenuView];
    if (point.y >45 && point.y < 101) {//简历搜索
        CompanySearchCtl *resumeSearchCtl = [[CompanySearchCtl alloc] init];
        resumeSearchCtl.resumeType = ResumeTypeTempSearch;
        [self.navigationController pushViewController:resumeSearchCtl animated:YES];
        [resumeSearchCtl beginLoad:_companyId exParam:nil];
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMdd"];
        NSString *  currTimeStr=[dateformatter stringFromDate:senddate];
        [[NSUserDefaults standardUserDefaults] setObject:currTimeStr forKey:@"clickTime"];
        _newerImgv.hidden = YES;
    }else if(point.y > 101){ //职位管理
        InbiddingJobCtl *listCtl = [[InbiddingJobCtl alloc] init];
        listCtl.companyDetailModal = _companyInfo;
        [listCtl beginLoad:_companyId exParam:nil];
        [self.navigationController pushViewController:listCtl animated:YES];
    }else{
        float width = ScreenWidth/4;
        if (point.x<width) {//人才投递
            CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
            companyResumeCtl.type_ = 0;
            companyResumeCtl.jobId_ = @"";
            companyResumeCtl.resumeType = ResumeTypePersonDelivery;
            companyResumeCtl.title = @"人才投递简历";
            [self.navigationController pushViewController:companyResumeCtl animated:YES];
            [companyResumeCtl beginLoad:_companyId exParam:nil];
        }else if (point.x<width*2){//顾问推荐
            CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
            companyResumeCtl.type_ = 2;
            companyResumeCtl.resumeType = ResumeTypeAdviserRecommend;
            companyResumeCtl.jobId_ = @"";
            companyResumeCtl.title = @"顾问推荐简历";
            [self.navigationController pushViewController:companyResumeCtl animated:YES];
            [companyResumeCtl beginLoad:_companyId exParam:nil];
        }else if (point.x<width*3){//已下载
            DownloadResumeListCtl *downloadResumeListCtl = [[DownloadResumeListCtl alloc] init];
            downloadResumeListCtl.title = @"已下载简历";
            downloadResumeListCtl.resumeType = ResumeTypeDownload;
            [self.navigationController pushViewController:downloadResumeListCtl animated:YES];
            [downloadResumeListCtl beginLoad:_companyId exParam:nil];
        }else{//暂存简历
            ComColllectResumeCtl *resumeTempSaveCtl = [[ComColllectResumeCtl alloc] init];
            resumeTempSaveCtl.resumeType = ResumeTypeTempSaved;
            [self.navigationController pushViewController:resumeTempSaveCtl animated:YES];
            [resumeTempSaveCtl beginLoad:_companyId exParam:nil];
        }
    }
}

#pragma mark - netWork
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getCompanyInfoById:_companyId];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetCompanyInfo://企业信息详情
        {
            if (dataArr.count>0) {
                _companyInfo = dataArr[0];
                myRightBarBtnItem_.userInteractionEnabled = YES;
                [Manager getUserInfo].companyModal_ = _companyInfo;
                if (_companyInfo.offerPartyCnt>0 || _companyInfo.kpbCnt > 0 || _companyInfo.vphCnt > 0) {
                    
                    //offer派 V聘会 快聘宝
                    if ([_menuArray containsObject:_offerPartyDic]) {
                        [_menuArray removeObject:_offerPartyDic];
                    }
                    [_menuArray insertObject:_offerPartyDic atIndex:2];
                    
                }
                
                [tableView_ reloadData];
                
                [_companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:_companyInfo.companyLogo] placeholderImage:nil];
                _companyNameLb.text = _companyInfo.cname_;
                if (_companyInfo.address_) {
                    [ELUserDefault setCompanyAddress:_companyInfo.address_];
                }
                NSString *startDate = _companyInfo.startDate;
                if (startDate.length > 10) {
                    startDate = [startDate substringToIndex:10];
                }
                NSString *endDate = _companyInfo.endDate;
                if (endDate.length > 10) {
                    endDate = [endDate substringToIndex:10];
                }
                _statusLb.text = [NSString stringWithFormat:@"%@至%@", startDate, endDate];
                _versionLb.text = _companyInfo.serviceVersion;
                //人才投递简历数
                _ReceivedCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.resumeCnt_];
                //顾问推荐数
                _adviserRecoCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.adviserRecommendCnt];
                //已下载数
                _downCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.downloadRecommendCnt];
                //暂存简历数
                _tempSaveCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.tempSaveResumeCnt];
                //人才投递未读数
                if (_companyInfo.resumeUnReadCnt > 0) {
                    _receivedUnreadCntLb.hidden = NO;
                    _receivedUnreadCntLb.text = [NSString stringWithFormat:@"+%ld", (long)_companyInfo.resumeUnReadCnt];
                }else{
                    _receivedUnreadCntLb.hidden = YES;
                }
                //顾问推荐数
                if (_companyInfo.resumeRecommendUnreadCnt > 0) {
                    _adviserRecoUnreadCnt.hidden = NO;
                    _adviserRecoUnreadCnt.text = [NSString stringWithFormat:@"+%ld", (long)_companyInfo.resumeRecommendUnreadCnt];
                }else{
                    _adviserRecoUnreadCnt.hidden = YES;
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (void)updateCom:(RequestCon *)con
{
    
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _menuArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHRIndexCtl_Cell";
    CHRIndexCtl_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRIndexCtl_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isNewImgv.layer.cornerRadius = 3.5;
        cell.isNewImgv.layer.masksToBounds = YES;
    }

    NSDictionary *dataModel = _menuArray[indexPath.row];
    cell.titleImgv.image = [UIImage imageNamed:dataModel[@"img"]];
    
    if (indexPath.row == 2 && (_companyInfo.offerPartyCnt>0 || _companyInfo.kpbCnt > 0 || _companyInfo.vphCnt > 0)) {//offer派名称格式
        if (_companyInfo.offerPartyCnt && !_companyInfo.kpbCnt && !_companyInfo.vphCnt) {//offer派
            cell.titleLb.text = dataModel[@"title1"];
        }else if (!_companyInfo.offerPartyCnt && _companyInfo.kpbCnt && !_companyInfo.vphCnt){//快聘宝
            cell.titleLb.text = dataModel[@"title2"];
        }else if (!_companyInfo.offerPartyCnt && !_companyInfo.kpbCnt && _companyInfo.vphCnt){//V聘会
            cell.titleLb.text = dataModel[@"title3"];
        }else if (_companyInfo.offerPartyCnt && _companyInfo.kpbCnt && !_companyInfo.vphCnt){//offer派 快聘宝
            cell.titleLb.text = dataModel[@"title4"];
        }else if (_companyInfo.offerPartyCnt && !_companyInfo.kpbCnt && _companyInfo.vphCnt){//offer派 V聘会
            cell.titleLb.text = dataModel[@"title5"];
        }else if (_companyInfo.offerPartyCnt && !_companyInfo.kpbCnt && !_companyInfo.vphCnt){//快聘宝 V聘会
            cell.titleLb.text = dataModel[@"title6"];
        }else if (_companyInfo.offerPartyCnt && _companyInfo.kpbCnt && _companyInfo.vphCnt){//快聘宝 快聘宝 V聘会
            cell.titleLb.text = dataModel[@"title7"];
        }
        tempTitle = cell.titleLb.text;
        
    }else{
        cell.titleLb.text = dataModel[@"title"];
    }

    cell.countLb.text = dataModel[@"cnt"];
    NSString *type = dataModel[@"type"];
    cell.countLb.hidden = NO;
    
    if ([type isEqualToString:@"rctw"]) {//人才提问
        if (_companyInfo.questionCnt_ > 0) {
            cell.isNewImgv.hidden = NO;
        }else{
            cell.isNewImgv.hidden = YES;
        }
    }else if ([type isEqualToString:@"op"]) {//Offer派
        if(_companyInfo.offerNewMessage > 0){
            cell.isNewImgv.hidden = NO;
        }else{
            cell.isNewImgv.hidden = YES;
        }
    }else{
        cell.isNewImgv.hidden = YES;
    }
    
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NSDictionary *dataModel = _menuArray[indexPath.row];
    NSString *type = dataModel[@"type"];
    
    if ([type isEqualToString:@"jlgl"]) {//简历管理
        CompanyHRCtl *resumeManagerCtl = [[CompanyHRCtl alloc] init];
        [self.navigationController pushViewController:resumeManagerCtl animated:YES];
        [resumeManagerCtl beginLoad:_companyId exParam:nil];
        
    }else if ([type isEqualToString:@"yfms"]) {//已发面试
        CompanyInterviewCtl * companyInterviewCtl = [[CompanyInterviewCtl alloc] init];
        [self.navigationController pushViewController:companyInterviewCtl animated:YES];
        [companyInterviewCtl beginLoad:_companyId exParam:nil];
        
    }else if ([type isEqualToString:@"rctw"]) {//人才提问
        CompanyQuestionCtl  *personQuestionCtl  = [[CompanyQuestionCtl alloc] init];
        [self.navigationController pushViewController:personQuestionCtl animated:YES];
        [personQuestionCtl beginLoad:_companyId exParam:nil];
        
    }else if ([type isEqualToString:@"op"]) {//Offer派
        CHROfferPartyListCtl *offerPartyList = [[CHROfferPartyListCtl alloc]init];
        offerPartyList.title = tempTitle;
        offerPartyList.companyId = _companyId;
        offerPartyList.companyInfo = _companyInfo;
        [self.navigationController pushViewController:offerPartyList animated:YES];
        CHRIndexCtl_Cell *cell = (CHRIndexCtl_Cell *)[tableView_ cellForRowAtIndexPath:indexPath];
        cell.countLb.hidden = YES;
        [offerPartyList beginLoad:_companyId exParam:nil];
        
    }else if ([type isEqualToString:@"smdl"]) {//扫描登录
        CompanyInfo_DataModal *companyInfo = [[CompanyInfo_DataModal alloc]init];
        companyInfo.companyID_ = _companyId;
        companyInfo.cname_ = @"深圳市以普洱信息技术";
        ZBarScanLoginCtl *scanCtl = [[ZBarScanLoginCtl alloc]init];
        scanCtl.companyId = _companyId;
        scanCtl.isCompany = YES;
        scanCtl.inDataModel =  companyInfo;
        [self.navigationController pushViewController:scanCtl animated:YES];
        
    }else if ([type isEqualToString:@"qyfw"]) {//企业服务
        ServiceInfoCtl * serviceInfoCtl = [[ServiceInfoCtl alloc] init];
        [self.navigationController pushViewController:serviceInfoCtl animated:YES];
        [serviceInfoCtl beginLoad:_companyId exParam:nil];
    }
}

- (void)backBarBtnResponse:(id)sender
{
    NSInteger count = self.navigationController.childViewControllers.count;
    UIViewController *ctl = self.navigationController.childViewControllers[count-2];
    if ([ctl isKindOfClass:[HRLoginCtl class]]) {
        UIViewController *ctl = self.navigationController.childViewControllers[count-3];
        [self.navigationController popToViewController:ctl animated:YES];
    }else{
        [super backBarBtnResponse:sender];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.companyID_ = _companyInfo.companyID_;
    dataModel.companyName_ = _companyInfo.cname_;
    dataModel.companyLogo_ = _companyInfo.companyLogo;
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    positionCtl.type_ = 3;//公司详情
//    positionCtl.offerPartyFlag = YES;//offer派入口
    [self.navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:dataModel exParam:nil];
    return;

}

- (void)btnResponse:(id)sender
{
    if (sender == myRightBarBtnItem_) {
        ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
        dataModel.companyID_ = _companyInfo.companyID_;
        dataModel.companyName_ = _companyInfo.cname_;
        dataModel.companyLogo_ = _companyInfo.companyLogo;
        PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
        positionCtl.type_ = 3;//公司详情
        //    positionCtl.offerPartyFlag = YES;//offer派入口
        [self.navigationController pushViewController:positionCtl animated:YES];
        [positionCtl beginLoad:dataModel exParam:nil];
        return;

    }
}

@end
