//
//  CompanyResumeCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CompanyResumeCtl.h"
#import "RecommendResumePreviewCtl.h"
#import "CHRResumeCell.h"
#import "TradeZWModel.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "SearchParam_DataModal.h"

#import "ELOfferRecommentWebDetailCtl.h"

@interface CompanyResumeCtl ()<changeJobSearchCondictionDelegate>
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
    SearchParam_DataModal           *searchParam_;
    
    __weak IBOutlet UIView *changeTitleView;
    
    __weak IBOutlet UIView *jobChangeView;
    __weak IBOutlet UIView *regionChangeView;
    __weak IBOutlet UIView *ExperienceView;
    __weak IBOutlet UIView *moreView;
    
}

@property (nonatomic, strong)  NSMutableArray  *dataRctdArr;
@end

@implementation CompanyResumeCtl

@synthesize jobId_,delegate_,type_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
        self.title = @"简历筛选";
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
    jobChoiceCtl = [[jobChoiceViewController alloc] init];
    jobChoiceCtl.dataRctdArr = _dataRctdArr;
    jobChoiceCtl.type = type_;
    _isDown = YES;
    jobChoiceCtl.delegate = self;
    
    [changeTitleView setHidden:NO];
    [self changeTitleViewWithSubviews];

    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchParam_ = [[SearchParam_DataModal alloc] init];
    if (_jobName.length > 0)
    {
        [jobChangeBtn setTitle:_jobName forState:UIControlStateNormal];
    }
    
}

- (void)changeTitleViewWithSubviews
{
    float width = ScreenWidth/4;
    CGRect frame = jobChangeView.frame;
    frame.size.width = width;
    frame.origin.x = 0;
    jobChangeView.frame = frame;
    
    frame.origin.x = width;
    regionChangeView.frame = frame;
    
    frame.origin.x = width*2;
    ExperienceView.frame = frame;
    
    frame.origin.x = width*3;
    moreView.frame = frame;
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
    
    if (type_ == 0) {//人才投递
        [self requestRctdData];
        
    }
    else if (type_ == 2){//顾问推荐
        [self requestGwtjData];
    }
}

#pragma mark - netWork 当前列表所包含的职位
-(void)requestGwtjData
{
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",companyId_];
    
    NSString *function = @"getZwlistbyTj";
    NSString *op = @"tjPerson_busi";
    
    [self.dataRctdArr removeAllObjects];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        for (NSDictionary *dict in result) {
            TradeZWModel *model = [[TradeZWModel alloc]init];
            model.zwid = dict[@"id"];
            model.zwName = dict[@"jtzw"];
            model.type = dict[@"zptype"];
            [self.dataRctdArr addObject:model];
        }
        
        TradeZWModel *model1 = [[TradeZWModel alloc]init];
        model1.zwid = @"0";
        model1.zwName = @"不限";
        model1.type = @"";
        [self.dataRctdArr insertObject:model1 atIndex:0];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)requestRctdData
{
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",companyId_,nil];
    NSString *function = @"mResumezwList";
    NSString *op = @"Cmailboxdeal";
    
    [self.dataRctdArr removeAllObjects];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        for ( NSMutableDictionary *dict in result)
        {
            TradeZWModel *model = [[TradeZWModel alloc]init];
            model.zwid = [dict objectForKey:@"id"];
            model.zwName = [dict objectForKey:@"job"];
            model.type = [dict objectForKey:@"zptype"];
            if (model.zwName.length > 0)
            {
                [self.dataRctdArr addObject:model];
            }
        }
        
        TradeZWModel *model1 = [[TradeZWModel alloc]init];
        model1.zwid = @"0";
        model1.zwName = @"不限";
        model1.type = @"";
        [self.dataRctdArr insertObject:model1 atIndex:0];
        
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
    [jobChoiceCtl hideJobChoiceList];
    [condictionCtl hideView];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if ([jobId_ isEqualToString:@"0"]) {
        jobId_ = @"";
    }
    if (type_ == 2) {//顾问推荐的简历
        [con getCompanyRecommendedResume:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10 jobid:jobId_ searchModal:searchParam_];
        return;
    }
    [con companyResume:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10 jobid:jobId_ searchModal:searchParam_];
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
        cell.joinStateLb.hidden = YES;
    }
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    cell.userNameLb.text = userModel.name_;
    
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;
    
    NSString *sex = userModel.sex_;
    [cell.sexBtn setTitle:userModel.age_ forState:UIControlStateNormal];
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
        
        if(type_ == 2){//推荐的简历预览
            [setCon_ setRecommendResumeReaded:dataModal.recommendId];
        }
        else{
            [setCon_ setNewMailRead:companyId_ personId:dataModal.userId_ cmailId:dataModal.emailId_];
        }
        
        dataModal.isNewmail_ = YES;
        [tableView_ reloadData];
        
        if(type_ == 2){
            [delegate_ recommendResumeBeRead];
        }
        else{
            [delegate_ resumeBeRead];
        }
        [self performSelector:@selector(delayFreshMssageCount) withObject:nil afterDelay:2];
    }
    
    OthersResumePreviewCtl * resumePreviewCtl = [[OthersResumePreviewCtl alloc] init];
    resumePreviewCtl.resumeType = _resumeType;
    resumePreviewCtl.delegate_ = self;
//    resumePreviewCtl.hideBottomTwoBtnView = YES;
    if (type_ == 2) {
        resumePreviewCtl.bRecommended_ = YES;
        resumePreviewCtl.isRecommend = YES;
    }
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId_];
    
}

//延迟刷新小红点
- (void)delayFreshMssageCount
{
    if ([Manager shareMgr].haveLogin) {
        [[Manager shareMgr].messageRefreshCtl requestCount];
    }
}

-(void)recommendBtnClick:(UIButton *)btn{
    User_DataModal *dataModal = requestCon_.dataArr_[btn.tag];

    if (!dataModal.isNewmail_) {//未读
        if (!setCon_) {
            setCon_ = [self getNewRequestCon:NO];
        }
        
        if(type_ == 2){//推荐的简历预览
            [setCon_ setRecommendResumeReaded:dataModal.recommendId];
        }
        else{
            [setCon_ setNewMailRead:companyId_ personId:dataModal.userId_ cmailId:dataModal.emailId_];
        }
        
        dataModal.isNewmail_ = YES;
        [tableView_ reloadData];
        
        if(type_ == 2){
            [delegate_ recommendResumeBeRead];
        }
        else{
            [delegate_ resumeBeRead];
        }
        [self performSelector:@selector(delayFreshMssageCount) withObject:nil afterDelay:2];
    }
    
    OthersResumePreviewCtl * resumePreviewCtl = [[OthersResumePreviewCtl alloc] init];
    resumePreviewCtl.resumeType = _resumeType;
    resumePreviewCtl.delegate_ = self;
    resumePreviewCtl.hideBottomTwoBtnView = YES;
    if (type_ == 2) {
        resumePreviewCtl.bRecommended_ = YES;
        resumePreviewCtl.isRecommend = YES;
    }
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId_];
}

/*
-(IBAction)zwBtnClick:(id)sender
{
    UIButton * btn = sender;
    NSInteger index = btn.tag - 1000;
    User_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:index];
    CompanyResumeCtl * resumeCtl = [[CompanyResumeCtl alloc] init];
    resumeCtl.jobId_ = dataModal.zpId_;
    resumeCtl.type_ = 1;
    [self.navigationController pushViewController:resumeCtl animated:YES];
    [resumeCtl beginLoad:companyId_ exParam:nil];
    
}

-(void)setUILabelTitleStr:(NSString *)str
{
    NSString *title = str;
    if (title.length <= 0) {
        title = @"职位筛选";
    }
    CGSize titleSize = [title sizeNewWithFont:_titleLb.font constrainedToSize:CGSizeMake(270, 30)];
    CGRect rect = _titleLb.frame;
    rect.size.width = titleSize.width +5;
    
    _titleLb.frame = rect;
    _titleLb.center = CGPointMake(_titleView.frame.size.width/2, _titleView.frame.size.height/2);
    rect = _imgView.frame;
    rect.origin.x = CGRectGetMaxX(_titleLb.frame) + 5;
    _imgView.frame = rect;
    _titleLb.text = title;
    
}
*/
 
#pragma mark - OtherResumePreviewCtlDelegate 简历评价合格／不合格
-(void)rejectResume:(User_DataModal *)dataModal passed:(BOOL)bePassed
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

#pragma mark -jobChoiceDelegate
-(void)jobChoiceCtl:(jobChoiceViewController *)jobChoiceCtl selectedArr:(NSMutableArray *)selectedArr
{
    NSString *titleStr;
    _isDown = YES;
    if (selectedArr.count == 0) {
        titleStr = @"职位筛选";
    }else{
        zwNameArr = [[NSMutableArray alloc]initWithArray:[selectedArr objectAtIndex:1]];
        for (NSString *str in zwNameArr) {
            if (titleStr == nil ) {
                titleStr = str;
            }else{
                titleStr = [titleStr stringByAppendingFormat:@" + %@ ",str];
            }
        }
        
        NSMutableArray *jobIdArr = [selectedArr objectAtIndex:0];
        NSString *idStr;
        for (int i = 0; i < jobIdArr.count; i++) {
            NSString *jobIdStr = jobIdArr[i];
            if (i == 0) {
                idStr = [jobIdArr objectAtIndex:0];
            }else{
                idStr = [idStr stringByAppendingFormat:@",%@",jobIdStr];
            }
        }
        jobId_ = idStr;
    }

    [jobChangeBtn setTitle:titleStr forState:UIControlStateNormal];
    _titleLb.text = titleStr;
    
    [self refreshLoad:nil];
    
}

-(void)btnResponse:(id)sender
{
    if (sender == moreChangeBtn)//更多
    {
        [jobChoiceCtl hideJobChoiceList];
        _isDown = YES;
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,104,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 104)];
            condictionCtl.delegate_ = self;
        }
        
        if (condictionCtl.currentType == ResumePeopleMoreChange)
        {
            [condictionCtl hideView];
            return;
        }
        
        [condictionCtl hideView];
        [condictionCtl creatViewWithType:ResumePeopleMoreChange selectModal:searchParam_];
        [condictionCtl showView];
    }
    else if (sender == jobChangeBtn)//职位筛选
    {
        [condictionCtl hideView];
        [self jobChoiceClick:jobChangeBtn];
    }
    else if (sender == regionChangeBtn)//地区选择
    {
        [jobChoiceCtl hideJobChoiceList];
        _isDown = YES;
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,104,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 104)];
            condictionCtl.delegate_ = self;
        }
        
        if (condictionCtl.currentType == RegionChange)
        {
            [condictionCtl hideView];
            return;
        }
        
        [condictionCtl hideView];
        SqlitData *data = [[SqlitData alloc] init];
        data.provinceld = searchParam_.regionId_;
        [condictionCtl creatViewWithType:RegionChange selectModal:data];
        [condictionCtl showView];
    }
    else if (sender == experienceBtn)//经验筛选
    {
        [jobChoiceCtl hideJobChoiceList];
        _isDown = YES;
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,104,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 104)];
            condictionCtl.delegate_ = self;
        }
        
        if (condictionCtl.currentType == ExperienceChange)
        {
            [condictionCtl hideView];
            return;
        }
        
        [condictionCtl hideView];
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = searchParam_.experienceName;
        data.id_ = searchParam_.experienceValue1;
        data.id_1 = searchParam_.experienceValue2;
        [condictionCtl creatViewWithType:ExperienceChange selectModal:data];
        [condictionCtl showView];
    }
}

#pragma mark - changeJobSearchCondictionDelegate
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case ResumePeopleMoreChange:
        {
            [self refreshLoad:nil];
        }
            break;
        case RegionChange:
        {
            SqlitData *modal = dataModel;
            searchParam_.regionStr_ = modal.provinceName;
            searchParam_.regionId_ = modal.provinceld;
            [regionChangeBtn setTitle:modal.provinceName forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        case ExperienceChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            [experienceBtn setTitle:modal.str_ forState:UIControlStateNormal];
            searchParam_.experienceName = modal.str_;
            searchParam_.experienceValue1 = modal.id_;
            searchParam_.experienceValue2 = modal.id_1;
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

@end
