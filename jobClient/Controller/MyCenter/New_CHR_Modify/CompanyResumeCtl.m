//
//  CompanyResumeCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CompanyResumeCtl.h"
#import "CHRResumeCell.h"
#import "ELRequest.h"
#import "TradeZWModel.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "SearchParam_DataModal.h"
#import "ELOfferRecommentWebDetailCtl.h"
#import "SelectTypeViewController.h"
#import "New_HeaderBtn.h"
#import "ELNewResumePreviewCtl.h"
#import "TxtSearchView.h"
#import "ZoneSelViewController.h"
#import "ELResumeChangeCtl.h"

#define kSelBtnTag 98760
#define kSelShowTableTag 999900
#define kMaxToBottom 93

//changeJobSearchCondictionDelegate,NewResumePreviewCtlDelegate
@interface CompanyResumeCtl ()<New_HeaderDelegate,searchViewDelegate,UIGestureRecognizerDelegate,SelDelegate,ZoneSelDelegate,UITextFieldDelegate,LoadDataBlockDelegate>
{
    NSString * companyId_;
    BOOL _isDown;
    jobChoiceViewController *jobChoiceCtl;
    NSMutableArray * zwNameArr;
    
    __weak IBOutlet UIButton *jobChangeBtn;
    
    __weak IBOutlet UIButton *regionChangeBtn;
    
    __weak IBOutlet UIButton *experienceBtn;
    __weak IBOutlet UIButton *moreChangeBtn;
    
    ELJobSearchCondictionChangeCtl *condictionCtl;
    
    __weak IBOutlet UIView *changeTitleView;
    
    __weak IBOutlet UIView *jobChangeView;
    __weak IBOutlet UIView *regionChangeView;
    __weak IBOutlet UIView *ExperienceView;
    __weak IBOutlet UIView *moreView;
    
    NSArray *typeArr;
    NSArray *titleArr;
    UIView *bgView;//黑色透明背景
    SelectTypeViewController *selVC;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    TxtSearchView *seachView;
    ZoneSelViewController *zoneSelectVC;
    
    BOOL selType;
    
}

@property (nonatomic,retain)SearchParam_DataModal *searchParam;
@property (weak, nonatomic) IBOutlet UIView *headerViewSel;
@property (nonatomic, strong)  NSMutableArray  *dataRctdArr;

@end

@implementation CompanyResumeCtl

@synthesize jobId_,delegate_,type_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    _dataRctdArr = [[NSMutableArray alloc]init];
    _titleLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _titleLb.font = FIFTEENFONT_TITLE;

    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchParam = [[SearchParam_DataModal alloc] init];

    [self configUI];
    
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:myRightBarBtnItem_];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
}

#pragma mark--初始化UI
-(void)configUI{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:headerView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTapClick:)];
    [bgView addGestureRecognizer:tap];
    
    selVC = [[SelectTypeViewController alloc]init];
    selVC.view.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, 0);
    selVC.companyId = companyId_;
    selVC.deliverType = type_;
    selVC.delegate = self;
    [self.view addSubview:selVC.view];
    [self addChildViewController:selVC];
    UITapGestureRecognizer *bgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    bgtap.delegate = self;
    [selVC.view addGestureRecognizer:bgtap];
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        if (i == titleArr.count - 1) {
            selBtn.rightLineView.hidden = YES;
        }
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
    
    [self configSearch];
    [self configRightView];
}

-(void)configSearch{
    seachView = [[TxtSearchView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, 44)];
    seachView.backgroundColor = [UIColor clearColor];
    seachView.delegate = self;
    seachView.txt.delegate = self;
    [self.navigationController.navigationBar addSubview:seachView];
}

//右边即将推出来的视图
-(void)configRightView{
    zoneSelectVC = [[ZoneSelViewController alloc]init];
    [self.view addSubview:zoneSelectVC.view];
    zoneSelectVC.delegate = self;
    zoneSelectVC.resumeType = _resumeType;
    zoneSelectVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    [self addChildViewController:zoneSelectVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark--请求数据
-(void)getDataFunction:(RequestCon *)con
{
    if ([jobId_ isEqualToString:@"0"]) {
        jobId_ = @"";
    }
    
    [con companyResume:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20 jobid:jobId_ searchModal:_searchParam];
}

#pragma mark - LoadDataBlockDelegate
-(void)requestLoadRequest:(RequestCon *)con{
    if ([jobId_ isEqualToString:@"0"]) {
        jobId_ = @"";
    }
    [con companyResume:companyId_ pageIndex:con.pageInfo_.currentPage_ pageSize:20 jobid:jobId_ searchModal:_searchParam];
}

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


#pragma mark - netWork 当前列表所包含的职位
-(void)requestGwtjData
{
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",companyId_];
    
    NSString *function = @"getJobfairAndZpName";
    NSString *op = @"company_person_busi";
    
    [self.dataRctdArr removeAllObjects];
    NSMutableArray *jobArr = [NSMutableArray array];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *jobFair = result[@"jobfair"];//场次
        NSDictionary *jobName = result[@"jobname"];//职位
        for (NSDictionary *dict in jobName) {
            CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
            model.id_ = [dict objectForKey:@"id"];
            model.str_ = [dict objectForKey:@"jobname"];
            model.positionMark = @"1";
            if (model.str_.length > 0)
            {
                [self.dataRctdArr addObject:model];
            }
        }
        CondictionList_DataModal *model1 = [[CondictionList_DataModal alloc]init];
        model1.id_ = @"0";
        model1.str_ = @"不限";
        model1.positionMark = @"";
        [self.dataRctdArr insertObject:model1 atIndex:0];
        
        for (NSDictionary *dict in jobFair) {
            CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
            model.id_ = [dict objectForKey:@"id"];
            model.str_ = [dict objectForKey:@"jobfair"];
            if (model.str_.length > 0)
            {
                [jobArr addObject:model];
            }
        }
        CondictionList_DataModal *model2 = [[CondictionList_DataModal alloc]init];
        model2.id_ = @"0";
        model2.str_ = @"场次不限";
        [jobArr insertObject:model2 atIndex:0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"position_data_success" object:nil userInfo:@{@"position_get":self.dataRctdArr}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JobTime_data_success" object:nil userInfo:@{@"JobTime_data":jobArr}];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)requestRctdData
{
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)requestCon_.pageInfo_.currentPage_] forKey:@"page_index"];
    [conditionDic setObject:[CommonConfig getDBValueByKey:@"synergy_id"] forKey:@"m_id"];
    [conditionDic setObject:[CommonConfig getDBValueByKey:@"m_dept_id"] forKey:@"m_dept_id"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",companyId_,conditionStr];
    NSString *function = @"mResumezwList";
    NSString *op = @"company_person_busi";
    
    [self.dataRctdArr removeAllObjects];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        for ( NSMutableDictionary *dict in result)
        {
            CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
            model.id_ = [dict objectForKey:@"id"];
            model.str_ = [dict objectForKey:@"jtzw"];
            model.positionMark = [dict objectForKey:@"zptype"];
            if (model.str_.length > 0)
            {
                [self.dataRctdArr addObject:model];
            }

        }
        
        CondictionList_DataModal *model1 = [[CondictionList_DataModal alloc]init];
        model1.id_ = @"0";
        model1.str_ = @"不限";
        model1.positionMark = @"";
        [self.dataRctdArr insertObject:model1 atIndex:0];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"position_data_success" object:nil userInfo:@{@"position_get":self.dataRctdArr}];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        _shouldRefresh = YES;
    }
    seachView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 44);
    seachView.hidden = YES;
    myRightBarBtnItem_.hidden = NO;
    backBarBtn_.hidden = NO;
    [seachView.txt resignFirstResponder];
}

#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    type_ = 0;

    [self requestRctdData];
    [self setNavTitle:@"投递应聘"];
    
    [self loadData];
}

-(void)loadData{
    if (_entrance == POSITION) {
        if (!self.jobName) {
            self.jobName = @"";
        }
        titleArr = @[self.jobName,@"状态",@"经验",@"更多"];
        if (!_searchParam) {
            _searchParam = [[SearchParam_DataModal alloc] init];
            _searchParam.searchType_ = 3;
        }

    }else{
        titleArr = @[@"职位",@"状态",@"经验",@"更多"];
    }

        typeArr = @[@(PositionType),@(DeliverStatusType),@(ExperenceType),@(DeliverMoreType)];
}


#pragma mark--代理

#pragma mark-txtDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchParam.searchName = textField.text;
    [self refreshLoad:nil];
    [seachView.txt resignFirstResponder];
    return YES;
}

#pragma mark-scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [seachView.txt resignFirstResponder];
}

#pragma mark - tableview delegatge
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHRResumeCell";
    CHRResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    cell.userNameLb.text = userModel.name_;
    
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
            //已阅
            cell.statusLb.hidden = YES;
        }else{
            //未阅
            cell.statusLb.hidden = NO;
            cell.statusLb.text = @"未阅";
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
        if (type_ == 0) {
            cell.jobLb.text =[NSString stringWithFormat:@"应聘: %@", userModel.job_];
        }else if (type_ == 2){
            cell.jobLb.text =[NSString stringWithFormat:@"推荐职位: %@", userModel.job_];
        }else{
            cell.jobLb.text =[NSString stringWithFormat:@"意向职位: %@", userModel.job_];
        }
        
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
    cell.recomendReporterBtn.tag = indexPath.row;
    [cell.recomendReporterBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal * dataModal = selectData;
    if (!dataModal.isNewmail_) {//未读
        if (!setCon_) {
            setCon_ = [self getNewRequestCon:NO];
        }
        
        [setCon_ setNewMailRead:companyId_ personId:dataModal.userId_ cmailId:dataModal.emailId_];
        dataModal.isNewmail_ = YES;
        [tableView_ reloadData];
        
        [delegate_ resumeBeRead];
        [self performSelector:@selector(delayFreshMssageCount) withObject:nil afterDelay:2];
    }
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = _resumeType;
    resumePreviewCtl.forType = @"2000";
    resumePreviewCtl.selType = selType;
    resumePreviewCtl.idx = indexPath.row;
    
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    resumePreviewCtl.selectRow = indexPath.row;
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId_];
    
}

//延迟刷新小红点
- (void)delayFreshMssageCount
{
    [[Manager shareMgr].messageRefreshCtl requestCount];
}

-(void)recommendBtnClick:(UIButton *)btn{
    User_DataModal *dataModal = requestCon_.dataArr_[btn.tag];

    if (!dataModal.isNewmail_) {//未读
        if (!setCon_) {
            setCon_ = [self getNewRequestCon:NO];
        }
        
        [setCon_ setNewMailRead:companyId_ personId:dataModal.userId_ cmailId:dataModal.emailId_];
        dataModal.isNewmail_ = YES;
        [tableView_ reloadData];
        
            [delegate_ resumeBeRead];

        [self performSelector:@selector(delayFreshMssageCount) withObject:nil afterDelay:2];
    }
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = _resumeType;
    resumePreviewCtl.forType = @"2000";
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    resumePreviewCtl.selectRow = btn.tag;
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId_];
}

#pragma mark - NewResumePreviewCtlDelegate 简历评价合格／不合格
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

- (IBAction)jobChoiceClick:(id)sender
{
    if (_isDown == YES) {
        [jobChoiceCtl showJobChoiceList];
        _isDown = NO;
        
    } else {
        [jobChoiceCtl hideJobChoiceList];
        _isDown = YES;
        
    }
}

#pragma mark-New_HeaderDelegate点击
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    __weak typeof(self) weakSelf = self;
    New_HeaderBtn *btn = (New_HeaderBtn *)sender.view;
    NSInteger idx = btn.tag - kSelBtnTag;
    selVC.selecType = [typeArr[idx] integerValue];
    nowBtn = btn;
//    if (_entrance == POSITION) {
//        CondictionList_DataModal *dataModel = [[CondictionList_DataModal alloc] init];
//        dataModel.bSelected_ = YES;
//        dataModel.str_ = self.jobName;
//        dataModel.id_ = self.jobId_;
//        selVC.condictionList_DataModal = dataModel;
//    }
    if (![btn isEqual:selectedBtn]) {
        bgView.hidden = NO;
        btn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
        btn.markImg.hidden = NO;
        btn.titleLb.textColor = UIColorFromRGB(0xe13e3e);
        selectedBtn.markImg.hidden = YES;
        selectedBtn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more"];
        selectedBtn.titleLb.textColor = UIColorFromRGB(0x333333);
        [selVC loadData];
        selVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
        selectedBtn = btn;
        selectedBtn.isSelected = YES;
    }
    else{
        [self btnSetting:btn];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        zoneSelectVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    }];
    
    selVC.selectBolck = ^(id data){
        
        [weakSelf dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        btn.isSelected = !btn.isSelected;
        if (type_ == 0) {
            if (idx == 0) {
                NSMutableArray *arr = (NSMutableArray *)data;
                [weakSelf positionBtnSetting:arr withBtn:btn];
            }
            else if(idx == 2){//经验
                CondictionList_DataModal *modal = data;
                weakSelf.searchParam.experienceName = modal.str_;
                weakSelf.searchParam.experienceValue1 = modal.id_;
                weakSelf.searchParam.experienceValue2 = modal.id_1;
                if([modal.str_ isEqualToString:@"不限"]){
                    modal.str_ = @"经验";
                }
                [weakSelf refreshLoad:nil];
                btn.titleLb.text = modal.str_;
            }
            else if(idx == 3){//更多
                [weakSelf moreSelClick:data];
                return;
            }
            else{//状态
                [weakSelf statuSelClick:data withBtn:btn];
            }
        }
    };
}

-(void)positionBtnSetting:(NSMutableArray *)selectedArr withBtn:(New_HeaderBtn *)btn{
    NSString *titleStr;
    NSString *idStr;
    _isDown = YES;
    if (selectedArr.count == 0) {
        titleStr = @"职位";
        jobId_ = @"";
    }else{
        for (int i = 0; i < selectedArr.count; i++) {
            CondictionList_DataModal *dataVO = selectedArr[i];
            if (titleStr == nil ) {
                titleStr = dataVO.str_;
            }else{
                titleStr = [titleStr stringByAppendingFormat:@" + %@ ",dataVO.str_];
            }
            NSString *jobIdStr = dataVO.id_;
            if (i == 0) {
                idStr = dataVO.id_;
            }else{
                idStr = [idStr stringByAppendingFormat:@",%@",jobIdStr];
            }
        }
        jobId_ = idStr;
    }
    btn.titleLb.text = titleStr;
    [self refreshLoad:nil];
}

#pragma mark-searchViewDelegate
-(void)searchViewClearBtnClick:(UIButton *)btn{
    seachView.txt.text = nil;
}

-(void)cancelBtnClick:(UIButton *)btn{
    _searchParam.searchName = @"";
    seachView.txt.text = nil;
    [self refreshLoad:nil];
    [UIView animateWithDuration:0.1 animations:^{
        seachView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 44);
        myRightBarBtnItem_.hidden = NO;
        backBarBtn_.hidden = NO;
    }];
}

#pragma mark--gestureRecognizer代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *view = touch.view;
    if ([view isEqual:selVC.view] || [view isEqual:zoneSelectVC.view]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma SelDelegate
-(void)moreSelBtnClick:(NSIndexPath *)indexPath{
    if (_resumeType == ResumeTypePersonDelivery) {
        if (indexPath.row == 0) {
            zoneSelectVC.moreSelType = ZoneType;
            [zoneSelectVC loadData];
        }
        else if(indexPath.row == 1){
            zoneSelectVC.moreSelType = More_EduType;
            [zoneSelectVC loadData];
        }
        else if(indexPath.row == 2){
            zoneSelectVC.moreSelType = More_AgeType;
            [zoneSelectVC loadData];
        }
        else if(indexPath.row == 3){
            zoneSelectVC.moreSelType = More_ReadStatusType;
            [zoneSelectVC loadData];
        }
        else{
            return;
        }

    }else if (_resumeType == ResumeTypeAdviserRecommend){
        if (indexPath.row == 0) {
            zoneSelectVC.moreSelType = ZoneType;
            [zoneSelectVC loadData];
        }
        else if(indexPath.row == 1){
            zoneSelectVC.moreSelType = More_AgeType;
            [zoneSelectVC loadData];
        }
    }
    
       [UIView animateWithDuration:0.2 animations:^{
        zoneSelectVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    }];
}

#pragma mark -- ZoneSelDelegate
-(void)backBtnClicked:(UIButton *)btn{
    [self hideRightSel];
}

-(void)rightCellSelected{
    [self hideRightSel];
}

#pragma mark--事件
//背景点击
-(void)tapClick:(UITapGestureRecognizer *)tap{
    kUserDefaults(@(YES), @"bottomBtn_isSelected");
    kUserSynchronize;
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = NO;
    
    [self.view endEditing:YES];
}

//背景点击
-(void)bgTapClick:(UITapGestureRecognizer *)tap{
    kUserDefaults(@(YES), @"bottomBtn_isSelected");
    kUserSynchronize;
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    [self hideRightSel];
    nowBtn.isSelected = NO;
    
    [self.view endEditing:YES];
}

- (IBAction)searchBtnClick:(id)sender {
    if (seachView.hidden) {
        seachView.hidden = NO;
    }
    [UIView animateWithDuration:0.1 animations:^{
        seachView.frame = CGRectMake(0, 0, ScreenWidth, 44);
        myRightBarBtnItem_.hidden = YES;
        backBarBtn_.hidden = YES;
    } completion:^(BOOL finished) {
        [seachView.txt becomeFirstResponder];
    }];
}
#pragma mark--通知
-(void)dealloc{
    [seachView removeFromSuperview];
    seachView = nil;
}

#pragma mark--业务逻辑
-(void)btnSetting:(New_HeaderBtn *)btn{
    if (!btn.isSelected) {
        [selVC loadData];
        [self dealBtn:btn withColor:UIColorFromRGB(0xe13e3e) bgStatus:NO imageName:@"小筛选下拉more-sel"];
    }
    else{
        [self dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    }
    btn.isSelected = !btn.isSelected;
}

-(void)dealBtn:(New_HeaderBtn *)btn withColor:(UIColor *)color bgStatus:(BOOL)bgState imageName:(NSString *)imgName{
    bgView.hidden = bgState;
    btn.titleImg.image = [UIImage imageNamed:imgName];
    btn.titleLb.textColor = color;
    btn.markImg.hidden = bgState;
    if (!bgState) {
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
    }
    
}
//更多点击回调
-(void)moreSelClick:(id)data{
    SearchParam_DataModal *modal = data;
    self.searchParam.regionId_ = modal.regionId_;
    self.searchParam.eduId_ = modal.eduId_;
    self.searchParam.workAgeValue_ = modal.age1;
    self.searchParam.workAgeValue_1 = modal.age2;
    self.searchParam.workTypeValue_ = modal.workTypeName_;
    if (modal.isRepeat) {
        self.searchParam.timeStr_ = @"2";
    }
    else{
        self.searchParam.timeStr_ = @"1";
    }
    [self refreshLoad:nil];
}

-(void)statuSelClick:(id)data withBtn:(New_HeaderBtn *)btn{
    CondictionList_DataModal *selectedVO = (CondictionList_DataModal *)data;
    self.searchParam.process_state = selectedVO.id_;
    if ([selectedVO.str_ isEqualToString:@"不限"]) {
        selectedVO.str_ = @"状态";
        selType = YES;
    }
    else{
        selType = NO;
    }
    [self refreshLoad:nil];
    btn.titleLb.text = selectedVO.str_;
}

-(void)hideRightSel{
    [UIView animateWithDuration:0.2 animations:^{
        zoneSelectVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    }];
}

@end
