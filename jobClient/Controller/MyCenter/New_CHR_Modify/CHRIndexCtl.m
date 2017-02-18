
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
#import "UIImageView+WebCache.h"
//#import "ZBarScanLoginCtl.h"
#import "HRLoginCtl.h"
#import "InbiddingJobCtl.h"
#import "NewSettingViewController.h"
#import "ELSelectionViewController.h"
#import "MainConsultantViewController.h"
#import "ServiceInfoCtl.h"

#import "CHROfferPartyDetailCtl.h"
#import "OfferHeaderDataModel.h"
#import "OfferPartyTalentsModel.h"
#import "New_ELSelectionViewController.h"
#import "ELVIPRecommendViewController.h"

@interface CHRIndexCtl ()
{
    NSMutableArray *_menuArray;
    CompanyInfo_DataModal *_companyInfo;
    NSDictionary *_offerPartyDic;
    NSDictionary *_titleNameDic;
    NSString *tempTitle;
    OfferHeaderDataModel *offerHeaderVO;
}
@property (weak, nonatomic) IBOutlet UIView *notifyTipsShowView;
//@property (weak, nonatomic) IBOutlet UILabel *showDetailLB;
@property (weak, nonatomic) IBOutlet UIButton *showDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerToTop;
@property (weak, nonatomic) IBOutlet UILabel *YLSelDetailCountLb;
@property (weak, nonatomic) IBOutlet UIView *allHeaderHeight;



@end

@implementation CHRIndexCtl

- (instancetype)init
{
    if (self = [super init]) {
        bFooterEgo_= NO;
        bHeaderEgo_ = NO;
    }
    return self;
}

-(void)viewDidLayoutSubviews{
    [self.view layoutIfNeeded];//iOS7上不加这句可能奔溃
}

#pragma mark--初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    _headerToTop.constant = -48;
    CGRect headerRect = _allHeaderHeight.frame;
    headerRect.size.height = 436 - 48;
    _allHeaderHeight.frame = headerRect;
    if (_islogin) {
        self.fd_interactivePopDisabled = YES;
    }

    [self setNavTitle:@"我的招聘"];
   
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSArray *menuArray = @[@{@"title":@"扫描登录电脑", @"cnt":@"", @"isNew":@(NO) ,@"type":@"smdl", @"img":@"list-04.png"}, @{@"title":@"专属顾问", @"cnt":@"", @"isNew":@(NO) ,@"type":@"qyfw", @"img":@"list-05.png"}];
    
    //offer派 V聘会 快聘宝
    _offerPartyDic = @{@"title1":@"Offer派",@"title2":@"快聘宝",@"title3":@"V聘会",@"title4":@"Offer派 快聘宝",@"title5":@"Offer派 V聘会",@"title6":@"快聘宝 V聘会",@"title7":@"Offer派 快聘宝 V聘会", @"cnt":@"", @"isNew":@(YES) ,@"type":@"op", @"img":@"list-03.png"};
    
    _menuArray = [NSMutableArray arrayWithArray:menuArray];
    CGRect rect = tableView_.frame;
    rect.size.height = self.view.bounds.size.height;
    tableView_.frame = rect;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    CALayer *layer = _companyLogoImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2.f;
    layer.borderWidth = 0.5f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    
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
    
    _ReceivedNewImg.hidden = YES;
    _YLSelectNewImg.hidden = YES;
    _adviserNewImg.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"我的招聘";
    [self setFd_prefersNavigationBarHidden:NO];
    [self refreshLoad:requestCon_];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//头部offer派显示与隐藏
-(void)dealHeaderWithVO:(OfferHeaderDataModel *)headerVO{
    
    if ([headerVO.code isEqualToString:@"200"]) {
        [self dealTimeWithVO:headerVO];
        _headerToTop.constant = 0;
        CGRect rect = _allHeaderHeight.frame;
        rect.size.height = 436;
        _allHeaderHeight.frame = rect;
    }
    else{
        _headerToTop.constant = -48;
        CGRect rect = _allHeaderHeight.frame;
        rect.size.height = 436 - 48;
        _allHeaderHeight.frame = rect;
    }
    
    //是否隐藏找简历
    NSString *m_isDown = [CommonConfig getDBValueByKey:@"m_isDown"];
    if (m_isDown && [m_isDown isEqualToString:@"0"]) {
        _FindResumeHeight.constant = 0;
        _headBgViewHeight.constant = 227;

        [_findResumeBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _findResumeBgView.subviews[idx].hidden = YES;
        }];
        
        CGRect frame = _allHeaderHeight.frame;
        frame.size.height -= 50;
        _allHeaderHeight.frame = frame;
    }else{
        _FindResumeHeight.constant = 50;
        _headBgViewHeight.constant = 277;
        [_findResumeBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _findResumeBgView.subviews[idx].hidden = NO;
        }];
    }
    

    tableView_.tableHeaderView = _allHeaderHeight;
}


#pragma mark--数据请求
#pragma mark - netWork
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    //  请求头部最近offer派
    [self getHeaderOfferPaiById];
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getCompanyInfoById:_companyId];
}

-(void)getHeaderOfferPaiById{
    //    @"cm1442885576465"
    NSString * bodyMsg = [NSString stringWithFormat:@"uId=%@", _companyId];
    NSString *function = @"getJobfairNearByuId";
    NSString *op = @"offerpai_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dicData = result[@"data"];
        offerHeaderVO = [OfferHeaderDataModel new];
        [offerHeaderVO setValuesForKeysWithDictionary:dicData];
        [self dealHeaderWithVO:offerHeaderVO];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [self performSelector:@selector(delayLoad) withObject:self afterDelay:0.1];
    }];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    switch (type) {
        case Request_GetCompanyInfo://企业信息详情
        {
            if (dataArr.count>0) {
                _companyInfo = dataArr[0];
                myRightBarBtnItem_.userInteractionEnabled = YES;
                [Manager getUserInfo].companyModal_ = _companyInfo;
                [CommonConfig setDBValueByKey:@"companyID" value:_companyInfo.companyID_];
                //协同账号相关权限 找简历
                if (_companyInfo.m_isDown) {
                    [CommonConfig setDBValueByKey:@"m_isDown" value:_companyInfo.m_isDown];
                }else{
                    [CommonConfig setDBValueByKey:@"m_isDown" value:@""];
                }
                
                //发布职位
                if (_companyInfo.m_isAddZp) {
                    [CommonConfig setDBValueByKey:@"m_isAddZp" value:_companyInfo.m_isAddZp];
                }else{
                    [CommonConfig setDBValueByKey:@"m_isAddZp" value:@""];
                }
                if (_companyInfo.m_dept_id) {
                    [CommonConfig setDBValueByKey:@"m_dept_id" value:_companyInfo.m_dept_id];
                }else{
                    [CommonConfig setDBValueByKey:@"m_dept_id" value:@""];
                }
                
                 [self getHeaderOfferPaiById];
            
                if ((_companyInfo.offerPartyCnt>0 || _companyInfo.kpbCnt > 0 || _companyInfo.vphCnt > 0) ) {
                    
                    //offer派 V聘会 快聘宝
                    if ([_menuArray containsObject:_offerPartyDic]) {
                        [_menuArray removeObject:_offerPartyDic];
                    }
                    [_menuArray insertObject:_offerPartyDic atIndex:0];
                    
                    [tableView_ reloadData];
                }

                [_companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:_companyInfo.companyLogo] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
                [self saveCompanyLogo:_companyInfo.companyLogo companyId:_companyInfo.companyID_];
                
                _companyNameLb.text = [MyCommon translateHTML:_companyInfo.cname_];
                if (_companyInfo.address_) {
                    [ELUserDefault setCompanyAddress:[MyCommon translateHTML:_companyInfo.address_]];
                }
                NSString *startDate = _companyInfo.startDate;
                NSString *endDate = _companyInfo.endDate;
                if (startDate.length > 0 && endDate.length > 0) {
                    if (startDate.length > 10) {
                        startDate = [startDate substringToIndex:10];
                    }
                    if (endDate.length > 10) {
                        endDate = [endDate substringToIndex:10];
                    }
                    _statusLb.text = [NSString stringWithFormat:@"服务状态：%@至%@", startDate, endDate];
                }
                
                _versionLb.attributedText = [self dealNowTime:_companyInfo.endDate withVersion:_companyInfo.serviceVersion];
                
                //人才投递简历数
                _ReceivedCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.resumeCnt_];
                //转发给我
                _adviserRecoCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.sendToMeCnt];
                //一览精选
                _YLSelDetailCountLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.adviserRecommendCnt];
                //已下载数
                _downCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.downloadRecommendCnt];
                //暂存简历数
                _tempSaveCntLb.text = [NSString stringWithFormat:@"%ld", (long)_companyInfo.tempSaveResumeCnt];
                if (_companyInfo.recommand_no_read > 0) {
                    _YLSelectNewImg.hidden = NO;
                }
                if (_companyInfo.forword_no_read > 0) {
                    _adviserNewImg.hidden = NO;
                }
                if (_companyInfo.resumeUnReadCnt > 0)  {
                    _ReceivedNewImg.hidden = NO;
                }
                
                [self performSelector:@selector(delayLoad) withObject:self afterDelay:0.15];
            }
        }
            break;
        default:
            break;
    }
}

- (void)saveCompanyLogo:(NSString *)companyLogo companyId:(NSString *)companyId
{
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"companyAccount"]];
    
    for (NSInteger i = 0, count = mArray.count; i<count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mArray[i]];
        if ([[dic objectForKey:@"companyId"] isEqualToString:companyId]) {
            
            [dic setObject:companyLogo forKey:@"companyLogo"];
            NSDictionary *tempDic = dic;
            [mArray removeObjectAtIndex:i];
            [mArray insertObject:tempDic atIndex:i];
            NSArray *array = mArray;
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"companyAccount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            return ;
        }
 
    }

    
}

- (void)updateCom:(RequestCon *)con
{
    
}

-(void)delayLoad{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
}

#pragma mark--事件
#pragma mark 点击菜单
//投递应聘
- (IBAction)deliverTap:(id)sender {
    [self type:0 resumeType:ResumeTypePersonDelivery title:nil];
    _ReceivedNewImg.hidden = YES;
}
//一览精选
- (IBAction)selectedDetailTap:(id)sender {
    _YLSelectNewImg.hidden = YES;
    New_ELSelectionViewController *companyResumeCtl = [[New_ELSelectionViewController alloc] init];
    companyResumeCtl.jobId_ = @"";
    companyResumeCtl.companyInfo = _companyInfo;
    companyResumeCtl.resumeType = ResumeTypeAdviserRecommend;
    [self.navigationController pushViewController:companyResumeCtl animated:YES];
    [companyResumeCtl beginLoad:_companyId exParam:nil];
}

//主动下载
- (IBAction)downloadTap:(id)sender {
    DownloadResumeListCtl *downloadResumeListCtl = [[DownloadResumeListCtl alloc] init];
    //downloadResumeListCtl.navigationItem.title = @"已下载简历";
    [downloadResumeListCtl setNavTitle:@"已下载简历"];
    downloadResumeListCtl.resumeType = ResumeTypeDownload;
    [self.navigationController pushViewController:downloadResumeListCtl animated:YES];
    [downloadResumeListCtl beginLoad:_companyId exParam:nil];
}
//转发给我
- (IBAction)turnTap:(id)sender {
    _adviserNewImg.hidden = YES;
    ELSelectionViewController *selectDetailVC = [[ELSelectionViewController alloc]init];
    selectDetailVC.resumeType = ResumeTypeTranspondForMe;
    [self.navigationController pushViewController:selectDetailVC animated:YES];
    [selectDetailVC beginLoad:_companyId exParam:nil];
}
//暂存简历
- (IBAction)tempTap:(id)sender {
    ComColllectResumeCtl *resumeTempSaveCtl = [[ComColllectResumeCtl alloc] init];
    resumeTempSaveCtl.resumeType = ResumeTypeTempSaved;
    [self.navigationController pushViewController:resumeTempSaveCtl animated:YES];
    [resumeTempSaveCtl beginLoad:_companyId exParam:nil];
}
//找简历
- (IBAction)findResumeTap:(id)sender {
    CompanySearchCtl *resumeSearchCtl = [[CompanySearchCtl alloc] init];
    resumeSearchCtl.resumeType = ResumeTypeTempSearch;
    [self.navigationController pushViewController:resumeSearchCtl animated:YES];
    [resumeSearchCtl beginLoad:_companyId exParam:nil];

}
//职位管理
- (IBAction)managerTap:(id)sender {
    InbiddingJobCtl *listCtl = [[InbiddingJobCtl alloc] init];
    listCtl.companyDetailModal = _companyInfo;
    [listCtl beginLoad:_companyId exParam:nil];
    [self.navigationController pushViewController:listCtl animated:YES];
}

//头部查看更多点击(offer派)
- (IBAction)showDetailBtnClick:(id)sender {
    CHROfferPartyDetailCtl *offerDetailVC = [[CHROfferPartyDetailCtl alloc]init];
    offerDetailVC.companyId = _companyId;
    if (offerHeaderVO.jobfairInfo) {
        OfferPartyTalentsModel *offerPVO = offerHeaderVO.jobfairInfo;
        offerDetailVC.jobfair_id = offerPVO.jobfair_id;
        offerDetailVC.jobfair_time = offerPVO.jobfair_time;
        offerDetailVC.jobfair_name = offerPVO.jobfair_name;
        offerDetailVC.fromtype = offerPVO.fromtype;
        offerDetailVC.place_name = offerPVO.place_name;
        [self.navigationController pushViewController:offerDetailVC animated:YES];
    }
}

//右侧item点击公司介绍（企业详情）
- (IBAction)companyClick:(id)sender {
    [self companyDetail];
}
//设置
- (IBAction)settingClick:(id)sender {
    NewSettingViewController *settingVC = [[NewSettingViewController alloc]init];
    settingVC.companyId = _companyId;
    [self.navigationController pushViewController:settingVC animated:YES];
}
//企业详情
- (IBAction)companyIntroClicked:(id)sender {
    [self companyDetail];
}

- (void)backBarBtnResponse:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark--代理
#pragma mark-scrollView代理
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat scrollY = scrollView.contentOffset.y;
//    
//    if (scrollY >= 34) {
//        scrollY = 34;
//    }
//    _headerToTop.constant = -scrollY;
//}

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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHRIndexCtl_Cell";
    CHRIndexCtl_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRIndexCtl_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSDictionary *dataModel = _menuArray[indexPath.row];
    cell.titleImgv.image = [UIImage imageNamed:dataModel[@"img"]];
  
    if (indexPath.row == 0 && (_companyInfo.offerPartyCnt>0 || _companyInfo.kpbCnt > 0 || _companyInfo.vphCnt > 0)) {//offer派名称格式
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
            cell.right_gray.hidden = YES;
        }else{
            cell.isNewImgv.hidden = YES;
            cell.right_gray.hidden = NO;
        }
    }else if ([type isEqualToString:@"op"]) {//Offer派
        if(_companyInfo.offerNewMessage > 0){
            cell.isNewImgv.hidden = NO;
            cell.right_gray.hidden = YES;
        }else{
            cell.isNewImgv.hidden = YES;
            cell.right_gray.hidden = NO;
        }
    }else{
        cell.isNewImgv.hidden = YES;
        cell.right_gray.hidden = NO;
    }
    if (indexPath.row == _menuArray.count - 1) {
        cell.line.hidden = YES;
    }
    else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NSDictionary *dataModel = _menuArray[indexPath.row];
    NSString *type = dataModel[@"type"];
    
    if ([type isEqualToString:@"jlgl"]) {//简历管理
//        CompanyHRCtl *resumeManagerCtl = [[CompanyHRCtl alloc] init];
//        [self.navigationController pushViewController:resumeManagerCtl animated:YES];
//        [resumeManagerCtl beginLoad:_companyId exParam:nil];
        
    }else if ([type isEqualToString:@"rctw"]) {//人才提问
//        CompanyQuestionCtl  *personQuestionCtl  = [[CompanyQuestionCtl alloc] init];
//        [self.navigationController pushViewController:personQuestionCtl animated:YES];
//        [personQuestionCtl beginLoad:_companyId exParam:nil];
    }
    else if ([type isEqualToString:@"op"]) {//Offer派
        CHROfferPartyListCtl *offerPartyList = [[CHROfferPartyListCtl alloc]init];
        //offerPartyList.navigationItem.title = tempTitle;
        offerPartyList.synergy_id = _synergy_id;
        [offerPartyList setNavTitle:tempTitle];
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
//        ZBarScanLoginCtl *scanCtl = [[ZBarScanLoginCtl alloc]init];
        ELScanQRCodeCtl *scanCtl = [[ELScanQRCodeCtl alloc] init];

        scanCtl.companyId = _companyId;
        scanCtl.inDataModel = companyInfo;
        scanCtl.isCompany = YES;
        [self.navigationController pushViewController:scanCtl animated:YES];
        
    }else if ([type isEqualToString:@"qyfw"]) {//企业服务
        ServiceInfoCtl *serviceVC = [[ServiceInfoCtl alloc]init];
        [self.navigationController pushViewController:serviceVC animated:YES];
        [serviceVC beginLoad:_companyId exParam:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000000001;
}

#pragma mark--业务逻辑
//投递应聘和顾问推荐
-(void)type:(NSInteger)type resumeType:(ResumeType)resumeType title:(NSString *)title{
    CompanyResumeCtl *companyResumeCtl = [[CompanyResumeCtl alloc] init];
    companyResumeCtl.type_ = type;
    companyResumeCtl.jobId_ = @"";
    companyResumeCtl.resumeType = resumeType;
    [self.navigationController pushViewController:companyResumeCtl animated:YES];
    [companyResumeCtl beginLoad:_companyId exParam:nil];
}
//企业详情
-(void)companyDetail{
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.companyID_ = _companyInfo.companyID_;
    dataModel.companyName_ = _companyInfo.cname_;
    dataModel.companyLogo_ = _companyInfo.companyLogo;
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    positionCtl.type_ = 3;//公司详情
    //positionCtl.offerPartyFlag = YES;//offer派入口
    [self.navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:dataModel exParam:nil];
}
//头部offer派时间处理
-(void)dealTimeWithVO:(OfferHeaderDataModel *)headerVO{
    if (headerVO.jobfairInfo) {
        OfferPartyTalentsModel *offerPVO = headerVO.jobfairInfo;
        NSString* string = offerPVO.jobfair_time;
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* inputDate = [inputFormatter dateFromString:string];
        NSTimeInterval time = [inputDate timeIntervalSince1970];
        NSTimeInterval reactTime = time + 8 * 60 * 60;
        NSDate *reactDate = [NSDate dateWithTimeIntervalSince1970:reactTime];
    
        NSLog(@"--------%@",[self compareDate:reactTime withReactDate:reactDate]);
        NSString *jobFairStr = offerPVO.jobfair_name;
        if (jobFairStr) {
            jobFairStr = [self dealjobFairStr:jobFairStr];
        }
    
        [_showDetailBtn setTitle:[NSString stringWithFormat:@"%@ offer派%@,查看详情>",[self compareDate:time withReactDate:reactDate],jobFairStr] forState:UIControlStateNormal];
    }
}
//时间处理
-(NSString *)compareDate:(NSTimeInterval)nowGetDate withReactDate:(NSDate *)reactDate{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:today];
    NSInteger weaks = [comp weekOfYear];
    
    NSDateComponents *reactComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:reactDate];
    NSInteger reactWeaks = [reactComp weekOfYear];
    
    NSTimeInterval todayTime = [today timeIntervalSince1970];
    NSTimeInterval desTime = nowGetDate - todayTime;
    if (desTime / secondsPerDay <= 1) {
        return @"今天";
    }
    else if(desTime / secondsPerDay > 1 && desTime / secondsPerDay < 2){
        return @"明天";
    }
    else if(weaks == reactWeaks){
        if (desTime / secondsPerDay >= 2 && desTime / secondsPerDay < 7) {
            return @"本周";
        }
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:nowGetDate];
    return [date stringWithFormatCurrent:@"yyyy-MM-dd"];
}
//服务版本设置
-(NSAttributedString *)dealNowTime:(NSString *)endDataStr withVersion:(NSString *)version{
    NSDate *today = [[NSDate alloc] init];
    NSTimeInterval todaytime = [today timeIntervalSince1970];
    NSDate *endDate = [endDataStr dateFormStringCurrentLocaleFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    NSInteger lastTime = (endTime - todaytime)/24/60/60;
    NSString *warnStr;
    if (lastTime > 0) {
        warnStr = [NSString stringWithFormat:@" %ld天到期",(long)lastTime];
    }
    else{
        warnStr = @" 已到期";
    }
    if (version.length == 0) {
        version = @"暂无版本";
    }
    NSString *serviceString = [NSString stringWithFormat:@"服务版本：%@ ",version];
    
    NSString *servinceStr = [NSString stringWithFormat:@"%@|%@", serviceString,warnStr];
    
    NSRange range = {serviceString.length,1};
    
    NSMutableAttributedString *serviceAttString = [[NSMutableAttributedString alloc]initWithString:servinceStr];
    [serviceAttString setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xe0e0e0)} range:range];
    return serviceAttString;
}

-(NSString *)dealjobFairStr:(NSString *)jobFairStr{
    if ([jobFairStr containsString:@">"] || [jobFairStr containsString:@"》"]) {
        NSArray *arr = [jobFairStr componentsSeparatedByString:@">"];
        NSString *str = [arr componentsJoinedByString:@""];
        return str;
    }
    return jobFairStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
