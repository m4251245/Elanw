//
//  CHRIndexCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyOfferPartyDetailCtl.h"
#import "MyOfferPartyCompanyList_Cell.h"
#import "OfferPartyEmployJob_Cell.h"
#import "CompanyInfo_DataModal.h"
#import "MessageContact_DataModel.h"
#import "MyOfferPartyApplyDetail.h"
#import <objc/runtime.h>
#import "CHROfferPartyDetailCtl.h"
#import "YLOfferApplyPromptCtl.h"
#import "MyResumeController.h"
#import "ModifyResumeViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface MyOfferPartyDetailCtl ()<OfferApplyDelegate,NoLoginDelegate>
{
    OfferPartyTalentsModel *_offerPartyInfo;
    User_DataModal *_adviserInfo;
    RequestCon *_attentionCon;
    RequestCon *_applyCon;
    RequestCon *_deliverResumeCon;
    NSTimer *timer;
    
    YLOfferApplyPromptCtl *promptCtl;
    NSString *types;
    
    BOOL _isShowGuideImg;
    __weak IBOutlet NSLayoutConstraint *_tableBottomSpace;
}
@end

@implementation MyOfferPartyDetailCtl

- (instancetype)init
{
    if (self = [super init]) {
        bFooterEgo_= YES;
        bHeaderEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (_offerPartyDetailType != OfferPartyDetailTypeConsultant) {
        self.navigationItem.title = @"招聘会详情";
    }
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CALayer *layer = _adviserImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 20.f;
    layer.borderWidth = 1.f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    
    layer = _statusBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4.f;
    layer.borderWidth = 1.f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    
    [self isSignInCome:self.iscome join:self.isjoin];
    _toolbarView.hidden = YES;
    
    promptCtl = [[YLOfferApplyPromptCtl alloc] init];
    promptCtl.applyDelegare = self;
    promptCtl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    //定时器每隔两分钟刷新一次
    timer =[NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(repeatRefresh:) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUp:) name:@"MyOfferPartyDetailCtlSignUpOfferParty" object:nil];
    
    _isShowGuideImg = [self compareOfferPartyDate];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"OfferPartyEmployJob_Cell" bundle:nil]forCellReuseIdentifier:@"KOfferPartyEmployJob_Cell"];
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

//判断人才有没有签到
- (void)isSignInCome:(BOOL)iscome join:(BOOL)isjoin
{
    if (iscome) {
        [_statusBtn setTitle:@"已签到" forState:UIControlStateDisabled];
        _statusBtn.enabled = NO;
    }
    else if (isjoin){
        [_statusBtn setTitle:@"已报名" forState:UIControlStateDisabled];
        _statusBtn.enabled = NO;
    }
    else{
        [_statusBtn setTitle:@"报名" forState:UIControlStateNormal];
        [_statusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//刷新人才报名状态
- (void)refreshSignUp:(NSNotification *)notification
{
    _statusBtn.enabled = NO;
    [_statusBtn setTitle:@"已报名" forState:UIControlStateDisabled];
    self.isjoin = YES;
}

-(void)repeatRefresh:(NSTimer *)time
{
    [self refreshLoad:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (timer.isValid) {
        [timer invalidate];//停止定时器
    }
    timer = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)getDataFunction:(RequestCon *)con
{
    if (_offerPartyDetailType == OfferPartyDetailTypeRecommend) {
        NSString *userId = [Manager getUserInfo].userId_;
        [con getUserOfferPartyCompanyList:userId offerPartyId:self.jobfair_id pageIndex:con.pageInfo_.currentPage_ pageSize:10];
    }
    else if (_offerPartyDetailType == OfferPartyDetailTypeAll || _offerPartyDetailType == OfferPartyDetailTypeConsultant){
        [con getOfferPartyCompanyList:self.jobfair_id pageIndex:con.pageInfo_.currentPage_ pageSize:10];
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetUserOfferPartyCompanyList://offer派company列表
        {
            OfferPartyTalentsModel *offerPartyModel = [requestCon_.dataArr_ lastObject];
            if ([offerPartyModel isKindOfClass:[OfferPartyTalentsModel class]]) {
                _offerPartyInfo = offerPartyModel;
                [requestCon_.dataArr_ removeLastObject];
                
                if (_offerPartyInfo.iscome) {
                    self.iscome = YES;
                }
                [self isSignInCome:_offerPartyInfo.iscome join:_offerPartyInfo.isjoin];
            }
            
            User_DataModal *userModel = [requestCon_.dataArr_ lastObject];
            if ([userModel isKindOfClass:[User_DataModal class]])
            {
                _adviserInfo = userModel;
                if (_adviserInfo.followStatus_ == 1) {
                    _adviserAttentionBtn.hidden = YES;
                }
                else{
                    _adviserAttentionBtn.hidden = NO;
                }
                
                if (!userModel.userId_ || [userModel.userId_ isEqualToString:@""]) {
                    
                    _toolbarView.hidden = YES;
                    _topTipsLb.text = @"职业经纪人正在为您配对企业，请耐心等待！";
                    tableView_.frame = self.view.bounds;
                    
                    _contactMeView.hidden = YES;
                    
                    _tableBottomSpace.constant = 0;
                }
                else{
                    _toolbarView.hidden = NO;
                    _tableBottomSpace.constant = 55;
                }
                
                [requestCon_.dataArr_ removeLastObject];
                [_adviserImgv sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
                _adviserNameLb.text = userModel.name_;
                
                [_adviserPhoneBtn setTitle:userModel.mobile_ forState:UIControlStateNormal];
            }
            
            if (!requestCon_.dataArr_.count) {
                tableView_.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                _noDataView.frame = tableView_.frame;
                tableView_.tableHeaderView = _noDataView;
                [self getNoDataView].hidden = YES;
            }
            
        }
            break;
        case Request_Follow://关注
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"关注成功" msg:nil];
                _adviserAttentionBtn.hidden = YES;
            }
            else{
                [BaseUIViewController showAutoDismissSucessView:model.des_ msg:nil];
            }
        }
            break;
        case Request_AddPersonToOffer://offer派报名
        {
            Status_DataModal *modal = dataArr[0];
            if ([modal.status_ isEqualToString:@"OK"])
            {
                [self performSelector:@selector(delay) withObject:nil afterDelay:1.0];
                _statusBtn.enabled = NO;
                [_statusBtn setTitle:@"已报名" forState:UIControlStateDisabled];
                self.isjoin = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YLOfferApplyUrlCtlSignUpOfferParty" object:nil];
            }
        }
            break;
        case Request_GetOfferPartyCompanyList://offer派所有公司列表
        {
            self.noDataTips = @"企业已就位，请随时关注信息更新";
            self.noDataImgStr = @"img_noData.png";
            _tableBottomSpace.constant = 0;
        }
            break;
        case Request_RecommendPersonToCompany://offer派投递简历
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"])
            {
                [BaseUIViewController showAutoDismissSucessView:@"投递成功" msg:nil];
                [self refreshLoad:nil];
            }
            else{
                [BaseUIViewController showAutoDismissSucessView:model.des_ msg:nil];
            }
        }
            break;
        case Request_DealResumeStates://申请面试
        {
            NSDictionary *resultDic = dataArr[0];
            if ([resultDic[@"result"] isEqualToString:@"1"]) {//操作成功
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"操作成功"];
                [self refreshLoad:requestCon_];
            }
        }
            break;
        default:
            break;
    }
}


- (void)delay
{
    if (_resumeComplete) {
        [promptCtl showApplyCtlViewType:3];
    }
    else {
        [promptCtl showApplyCtlViewType:2];
    }
}

- (void)updateCom:(RequestCon *)con
{
    
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
    if(_offerPartyDetailType == OfferPartyDetailTypeAll || _offerPartyDetailType == OfferPartyDetailTypeConsultant){
        return 65;
    }
    
    CompanyInfo_DataModal *dataModel = requestCon_.dataArr_[indexPath.row];
    if(dataModel.jobStatus == UserOPStatusTypeInterview || dataModel.jobStatus == UserOPStatusTypeLeaved || dataModel.jobStatus == UserOPStatusTypeNoFilter  || [dataModel.userModal.interviewState isEqualToString:@"7"] || dataModel.jobStatus == UserOPStatusTypeGiveup)
    {//排队，面试，过号，不通过初选，面试不合格
//        return 170 + 15;
        return 168;
    }
    
    //普通
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"KOfferPartyEmployJob_Cell" cacheByIndexPath:indexPath configuration:^(OfferPartyEmployJob_Cell * cell) {
        cell.addressLb.numberOfLines = 2;
        cell.addressLb.text = [NSString stringWithFormat:@"公司地点: %@", [MyCommon translateHTML:dataModel.address_]];
    }];
    return height + 15 - 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyInfo_DataModal *dataModel = requestCon_.dataArr_[indexPath.row];
    if(_offerPartyDetailType == OfferPartyDetailTypeAll || _offerPartyDetailType == OfferPartyDetailTypeConsultant)
    {//全部企业
        static NSString *reuseIdentifier = @"MyOfferPartyCompanyList_Cell";
        MyOfferPartyCompanyList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"MyOfferPartyCompanyList_Cell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.redDotLb.hidden = YES;
            [cell.statusBtn addTarget:self action:@selector(deliverResume:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.statusBtn.hidden = YES;
        cell.jobLb.hidden = YES;
        
        CGRect frame = cell.separateLine.frame;
        frame.origin.y = 64;
        cell.separateLine.frame = frame;
        
        frame = cell.arrowImgv.frame;
        frame.origin.y = 29;
        cell.arrowImgv.frame = frame;
        
        frame = cell.titleLb.frame;
        frame.size.width = ScreenWidth-100;
        cell.titleLb.frame = frame;
        
        cell.titleLb.text = [MyCommon translateHTML:dataModel.cname_];
        cell.addressLb.text = [NSString stringWithFormat:@"公司地点: %@", dataModel.address_];
        cell.jobLb.text = [NSString stringWithFormat:@"招聘岗位: %@", dataModel.job];
        [cell.companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:dataModel.logoPath_] placeholderImage:nil];
        return cell;
    }
    else {//应聘岗位
//        static NSString *reuseIdentifier = @"OfferPartyEmployJob_Cell";
//        OfferPartyEmployJob_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        OfferPartyEmployJob_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"KOfferPartyEmployJob_Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.statusBtn addTarget:self action:@selector(deliverResume:) forControlEvents:UIControlEventTouchUpInside];
        cell.guidImg.tag = 10001;
        
//        if (cell == nil) {
//            cell = [[NSBundle mainBundle] loadNibNamed:@"OfferPartyEmployJob_Cell" owner:self options:nil][0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//           cell.redDotLb.hidden = YES;
//            [cell.statusBtn addTarget:self action:@selector(deliverResume:) forControlEvents:UIControlEventTouchUpInside];
//            cell.guidImg.tag = 10001;
//        }
        cell.statusBtn.hidden = NO;
        cell.statusBtn.tag = indexPath.row;
        cell.addressLb.numberOfLines = 2;
        cell.interviewDetailLb.textAlignment = NSTextAlignmentLeft;
        cell.interviewStatusImgv.hidden = YES;
        cell.interviewDetailLb.hidden = YES;
        
        /**
         * 0.可投递简历
         * 1.确认录用
         * 2.通过初选(1.顾问推荐 ，2主动投递)
         * 3.面试合格
         * 4:人才自己投递(等待面试)
         * 5:顾问推荐
         * 7.等待面试
         * 10.不通过初选
         * 11.面试不合格
         * 12.待确定
         * 14.企业端放弃面试
         */
        switch (dataModel.jobStatus) {
            case 0:
            {
                cell.statusBtn.userInteractionEnabled = YES;
                if (self.iscome) {//已签到
                    [cell.statusBtn setTitle:@"申请面试" forState:UIControlStateNormal];
                }else{
                    [cell.statusBtn setTitle:@"投递简历" forState:UIControlStateNormal];
                }
            }
                break;
            case 1:
            {//1.确认录用
                cell.statusBtn.userInteractionEnabled = NO;
                [cell.statusBtn setTitle:@"确认录用" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {//通过初选(1.顾问推荐 ，2主动投递)
                if (self.iscome) {//已签到
                    cell.statusBtn.userInteractionEnabled = YES;
                    [cell.statusBtn setTitle:@"申请面试" forState:UIControlStateNormal];
                }else{
                    cell.statusBtn.userInteractionEnabled = NO;
                    [cell.statusBtn setTitle:@"通过初选" forState:UIControlStateNormal];
                }
            }
                break;
            case 3:
            {//面试合格
                cell.statusBtn.userInteractionEnabled = NO;
                [cell.statusBtn setTitle:@"面试合格" forState:UIControlStateNormal];
            }
                break;
            case 4:
            {//人才自己投递(等待面试)
                cell.statusBtn.userInteractionEnabled = NO;
                [cell.statusBtn setTitle:@"等候面试" forState:UIControlStateNormal];
            }
                break;
            case 5:
            {//顾问推荐
                if (self.iscome) {
                    cell.statusBtn.userInteractionEnabled = YES;
                    [cell.statusBtn setTitle:@"申请面试" forState:UIControlStateNormal];
                }
                else
                {
                    cell.statusBtn.userInteractionEnabled = NO;
                    [cell.statusBtn setTitle:@"已推荐" forState:UIControlStateNormal];
                }
            }
                break;
            case 7:
            {//等待面试
                cell.statusBtn.userInteractionEnabled = NO;
                [cell.statusBtn setTitle:@"等候面试" forState:UIControlStateNormal];
            }
                break;
            case 10: //不通过初选
            case 11: //面试不合格
            case 14://放弃面试
            {
                
                cell.interviewStatusImgvLeading.constant = 0;
                [cell.interviewStatusImgv layoutIfNeeded];
                cell.statusBtn.userInteractionEnabled = NO;
                [cell.statusBtn setTitle:@"暂不合适" forState:UIControlStateNormal];
                
                cell.interviewDetailLb.textAlignment = NSTextAlignmentLeft;
                
                cell.interviewStatusImgv.hidden = YES;
                cell.interviewDetailLb.hidden = NO;
                cell.interviewDetailLb.text = @"你与公司用人需求不符合，暂不合适！";
            }
                break;
            case 12:
            {//待确定
                if (self.iscome) {
                    cell.statusBtn.userInteractionEnabled = YES;
                    [cell.statusBtn setTitle:@"申请面试" forState:UIControlStateNormal];
                }
                else
                {
                    cell.statusBtn.userInteractionEnabled = NO;
                    [cell.statusBtn setTitle:@"已推荐" forState:UIControlStateNormal];
                }
            }
                break;
            default:
                break;
        }
        
        //显示引导标签
        cell.guidImg.hidden = YES;
        if (indexPath.row == 0 && [cell.statusBtn.titleLabel.text isEqualToString:@"申请面试"]) {
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            BOOL isShow = [userdefault boolForKey:@"showOfferListTip"];
            if (isShow) {
                if (_isShowGuideImg) {
                    cell.guidImg.hidden = NO;
                    [userdefault setBool:NO forKey:@"showOfferListTip"];
                    [userdefault synchronize];
                }
            }
        }
        
        //等候面试显示排队信息
        if (dataModel.jobStatus == 4 || dataModel.jobStatus == 7) {
            User_DataModal *userModal = dataModel.userModal;
            int waiteNum = userModal.waiteNum.intValue;
            cell.interviewStatusImgv.hidden = NO;
            cell.interviewDetailLb.hidden = NO;
            cell.interviewStatusImgvLeading.constant = 64;
            [cell.interviewStatusImgv layoutIfNeeded];
            
            
            if (dataModel.userModal.joinstate == 1) {//已离场
                cell.interviewStatusImgv.hidden = NO;
                cell.interviewStatusImgv.image = [UIImage imageNamed:@"icon_offer_five"];
                cell.interviewDetailLb.hidden = NO;
                cell.interviewDetailLb.text = @"你已离场";
            }
            else if (waiteNum > 0) {
                cell.interviewStatusImgv.image = [UIImage imageNamed:@"waite_to_Interview.png"];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                paragraphStyle.lineSpacing = 4;
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
                NSDictionary *textAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor], NSParagraphStyleAttributeName:paragraphStyle};
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"正在排队等候" attributes:textAttr]];
                NSDictionary *numberAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor colorWithRed:240.f/255 green:95.f/255 blue:95.f/255 alpha:1.f], NSParagraphStyleAttributeName:paragraphStyle};
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%d", waiteNum] attributes:numberAttr]];
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"个人排在你前面" attributes:textAttr]];
                cell.interviewDetailLb.attributedText = attrString;
            }
            else if (waiteNum == 0){
                cell.interviewStatusImgv.image = [UIImage imageNamed:@"in_interview.png"];
                cell.interviewDetailLb.text = @"将轮到你面试，请耐心等候通知";
            }
            else if (waiteNum < 0){
                cell.interviewStatusImgv.image = [UIImage imageNamed:@"expire_interview.png"];
                cell.interviewStatusImgv.image = [UIImage imageNamed:@"waite_to_Interview.png"];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
                NSDictionary *textAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"过号了" attributes:textAttr]];
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"还有" attributes:textAttr]];
                NSDictionary *numberAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor colorWithRed:240.f/255 green:95.f/255 blue:95.f/255 alpha:1.f]};
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",  abs(waiteNum)] attributes:numberAttr]];
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@"人排在你前面\n请留意当前队伍的情况" attributes:textAttr]];
                cell.interviewDetailLb.attributedText = attrString;
            }
        }
        
        if (cell.interviewDetailLb.hidden && cell.interviewStatusImgv.hidden) {
            cell.lineToBottom.constant = -5;
        }
        else
        {
            cell.lineToBottom.constant = 42;
        }
        
        cell.titleLb.text = [MyCommon translateHTML:dataModel.cname_];
        cell.addressLb.text = [NSString stringWithFormat:@"公司地点: %@", [MyCommon translateHTML:dataModel.address_]];
        cell.jobLb.text = [NSString stringWithFormat:@"招聘岗位: %@", [MyCommon translateHTML:dataModel.job]];
        [cell.companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:dataModel.logoPath_] placeholderImage:nil];
        NSDictionary *salaryAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor colorWithRed:240.f/255 green:95.f/255 blue:95.f/255 alpha:1.f]};
        NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        NSDictionary *gzNumAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
        User_DataModal *userModal = dataModel.userModal;
        NSString *salary = [MyCommon translateHTML:userModal.salary_];
        NSString *gzNum = [MyCommon translateHTML:userModal.gzNum_];
        NSString *education = [MyCommon translateHTML:userModal.eduName_];
        
        if (salary  && ![salary isEqualToString:@""]) {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:salary attributes:salaryAttr]];
        }
        if (gzNum && ![gzNum isEqualToString:@""]) {
            if (gzNum) {
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
            }
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:gzNum attributes:gzNumAttr]];
        }
        if (education && ![education isEqualToString:@""]) {
            if (salary || gzNum) {
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
            }
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:education attributes:gzNumAttr]];
        }
        cell.summaryLb.attributedText = attrString;
        return cell;
    }
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    CompanyInfo_DataModal *companyModel = selectData;
    if(_offerPartyDetailType == OfferPartyDetailTypeAll){
        //企业详情
        
        ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
        dataModel.companyID_ = companyModel.companyID_;
        dataModel.companyName_ = companyModel.cname_;
        dataModel.companyLogo_ = companyModel.logoPath_;
        PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
        positionCtl.type_ = 3;//公司详情
        positionCtl.offerPartyFlag = YES;//offer派入口
        [self.navigationController pushViewController:positionCtl animated:YES];
        [positionCtl beginLoad:dataModel exParam:nil];
        return;
    }
    else if ( _offerPartyDetailType == OfferPartyDetailTypeConsultant){//顾问后台企业列表
        CHROfferPartyDetailCtl *offerDetailCtl = [[CHROfferPartyDetailCtl alloc]init];
        offerDetailCtl.jobfair_id = _jobfair_id;
        offerDetailCtl.jobfair_time = _jobfair_time;
        offerDetailCtl.jobfair_name = _jobfair_name;
        offerDetailCtl.fromtype = _fromtype;
        offerDetailCtl.place_name = _place_name;
        offerDetailCtl.companyInfomModel = companyModel;
        offerDetailCtl.consultantCompanyFlag = YES;
        offerDetailCtl.guWenRequestFlag = YES;
        offerDetailCtl.companyId = companyModel.companyID_;
        [ self.navigationController pushViewController:offerDetailCtl animated:YES];
        [offerDetailCtl beginLoad:nil exParam:nil];
        return;
    }
    
    /**
     * 1.确认录用
     * 2.通过初选(1.顾问推荐 ，2主动投递)
     * 3.面试合格
     * 4:人才自己投递(等待面试)
     * 5:顾问推荐
     * 7.等待面试
     * 10.不通过初选
     * 11.面试不合格
     * 12.待确定
     * 14.放弃面试
     */
    if (self.isjoin || self.iscome) {//offer派
        if (companyModel.jobStatus == 1 || companyModel.jobStatus == 2 || companyModel.jobStatus == 3 ||companyModel.jobStatus == 4 ||companyModel.jobStatus == 5 || companyModel.jobStatus == 7 || companyModel.jobStatus == 10 || companyModel.jobStatus == 11  || companyModel.jobStatus == 12 || companyModel.jobStatus == 14)
        {
            MyOfferPartyApplyDetail *applyDetailCtl = [[MyOfferPartyApplyDetail alloc]init];
            applyDetailCtl.companyModel = selectData;
            [self.navigationController pushViewController:applyDetailCtl animated:YES];
            [applyDetailCtl beginLoad:nil exParam:nil];
        }
        else{
            [self jumpToPositionDetailCtl:companyModel];
        }
    }
    else{
        [self jumpToPositionDetailCtl:companyModel];
    }
}


//static char alertViewKey;

#pragma mark 投递简历
- (void)deliverResume:(UIButton *)sender
{
    long tag = sender.tag;
    CompanyInfo_DataModal *dataModel = requestCon_.dataArr_[tag];
    
    /*
    if (![dataModel.zpType isEqualToString:@"1"]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"该职位已经删除"];
        return;
    }
    */
    types = @"0";
    //已推荐 或 通过初选可直接申请面试
    if ((dataModel.jobStatus == UserOPStatusTypeRecommend || dataModel.jobStatus == UserOPStatusTypeConfirmFit || dataModel.jobStatus == 12)  && self.iscome) {//已推荐、通过初选、待确定则可申请面试
        types = @"1";
        [self showChooseAlertView:(int)tag title:nil msg:@"确定申请面试" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
//        objc_setAssociatedObject(alertView, &alertViewKey, @"1", OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        return;
    }
    
    if (!self.iscome || !self.isjoin) {//未报名、签到
        [BaseUIViewController showAlertView:@"温馨提示" msg:@"需要报名且现场签到后方可投递简历" btnTitle:@"确定"];
        return;
    }
    //顾问推荐,确认参加
    if (dataModel.jobStatus == UserOPStatusTypeRecommend) {
        return;
    }
    
    if(dataModel.jobStatus != UserOPStatusTypeUndeliver){//可投递
        return;
    }
    
    [self showChooseAlertView:(int)tag title:nil msg:@"确定申请面试" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    if (alertView.tag == 2000) {
        //报名offer派
        if (!_applyCon) {
            _applyCon = [self getNewRequestCon:NO];
        }
        [_applyCon addPersonToOfferPersonId:[Manager getUserInfo].userId_ jobFairId:self.jobfair_id];
    }
    else
    {
        NSInteger tag = alertView.tag;
        CompanyInfo_DataModal *dataModel = requestCon_.dataArr_[tag];
        dataModel.uid = dataModel.companyID_;
        dataModel.userModal.zpId_ = dataModel.jobId;
        dataModel.userModal.companyId = dataModel.companyID_;
        if (!_deliverResumeCon) {
            _deliverResumeCon = [self getNewRequestCon:NO];
        }
        NSString *userId = [Manager getUserInfo].userId_;
//        NSString *types = objc_getAssociatedObject(alertView, &alertViewKey);
        
        //已推荐 或 通过初选可直接申请面试
        if ([types isEqualToString:@"1"]) {//申请面试
            NSString *recommendId = dataModel.userModal.recommendId;
            [_deliverResumeCon dealResumeStates:@[recommendId] state:@"mianshi" type:@"3" role:@"10" roleId:[Manager getUserInfo].userId_];

            return;
        }
        
        //人才主动投递简历接口
        [_deliverResumeCon recommendPersonToCompany:dataModel.offerPartyId companyID:@[dataModel] personID:userId salerId:nil isLineUPFlag:YES];
    }
}


- (void)jumpToPositionDetailCtl:(CompanyInfo_DataModal *)companyModel
{
    if ([companyModel.zpType isEqualToString:@""]) {
        [BaseUIViewController showAutoDismissFailView:nil msg:@"该职位已经删除"];
        return;
    }
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.zwID_ = companyModel.jobId;
    dataModel.zwName_ = companyModel.job;
    dataModel.companyID_ = companyModel.companyID_;
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    positionCtl.offerPartyFlag = YES;//offer派入口
    [self.navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:dataModel exParam:nil];
}

- (void)btnResponse:(id)sender
{
    if (sender == _adviserPhoneBtn) {//电话联系
        //NSString *phone = _adviserInfo.mobile_;
        
    }else if (sender == _adviserAttentionBtn) {//关注顾问
        NSString *userId = _adviserInfo.userId_;
        if (!_attentionCon) {
            _attentionCon = [self getNewRequestCon:NO];
        }
        [_attentionCon followExpert:[Manager getUserInfo].userId_ expert:userId];
    }
    else if (sender == _adviserMessageBtn||sender == _adviserMessageBtn2) {//私信联系顾问
        MessageContact_DataModel *contactModel = [[MessageContact_DataModel alloc]init];
        contactModel.userId = _adviserInfo.userId_;
        contactModel.userIname = _adviserInfo.name_;
        
        MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:contactModel exParam:nil];
        
    }
    else if (sender == _statusBtn){//报名
        if (self.isjoin){//已报名
            return;
        }
        
        if (![Manager shareMgr].haveLogin) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^
            {
                [promptCtl showApplyCtlViewType:1];
            });
            return;
        }
        
        [self showChooseAlertView:2000 title:@"温馨提示" msg:@"是否确定报名" okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
    }
}

#pragma mark - OfferApplyDelegate
-(void)applyDelegateCtlWithType:(NSInteger)type
{
    switch (type) {
        case 1:
        {
            [Manager shareMgr].showLoginBackBtn = YES;
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
            [Manager shareMgr].isNeedRefresh = NO;
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_OfferDetail;
            [NoLoginPromptCtl getNoLoginManager].noLoginDelegare = self;
        }
            break;
        case 2:
        {
            ModifyResumeViewController *modifyResumeVC = [[ModifyResumeViewController alloc]init];
            [modifyResumeVC beginLoad:nil exParam:nil];
            [self.navigationController pushViewController:modifyResumeVC animated:YES];
        }
            break;
        case 3:
        default:
            break;
    }
}

#pragma mark - NoLoginDelegate
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_OfferDetail:
        {
            if (!_applyCon) {
                _applyCon = [self getNewRequestCon:NO];
            }
            [_applyCon addPersonToOfferPersonId:[Manager getUserInfo].userId_ jobFairId:self.jobfair_id];
        }
            break;
        default:
            break;
    }
}

//比较offer派时间
- (BOOL)compareOfferPartyDate
{
    // 当前时间字符串格式
    NSDate *nowDate = [[NSDate alloc] init];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:nowDate];
    nowDate = [nowDate  dateByAddingTimeInterval:interval];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //当前offer派时间
    NSString* string = self.jobfair_time;
    NSDate* inputDate = [inputFormatter dateFromString:string];
    inputDate = [inputDate  dateByAddingTimeInterval:interval];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [cal components:unitFlags fromDate:nowDate toDate:inputDate options:0];
    
    if (dateCom.day == 0) {
        if ((dateCom.minute >= 0 && dateCom.minute <= 15) || (dateCom.hour > -4 && dateCom.hour < 0)) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}


@end
