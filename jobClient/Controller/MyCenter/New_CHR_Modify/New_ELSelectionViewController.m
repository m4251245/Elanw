 //
//  New_ELSelectionViewController.m
//  jobClient
//
//  Created by 一览ios on 16/9/22.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "New_ELSelectionViewController.h"
#import "Manager.h"
#import "CHRResumeCell.h"
#import "ELRequest.h"
#import "TradeZWModel.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "SearchParam_DataModal.h"

#import "SelectTypeViewController.h"
#import "New_HeaderBtn.h"

#import "TxtSearchView.h"
#import "ZoneSelViewController.h"

#import "ELVIPRecommendViewController.h"
#import "CHROfferPartyListCtl.h"

#define kSelBtnTag 98760
#define kSelShowTableTag 999900
#define kMaxToBottom 93

@interface New_ELSelectionViewController ()<New_HeaderDelegate,searchViewDelegate,UIGestureRecognizerDelegate,SelDelegate,ZoneSelDelegate,UITextFieldDelegate>
{
    NSString * companyId_;
    BOOL _isDown;

    NSMutableArray * zwNameArr;
 
    ELJobSearchCondictionChangeCtl *condictionCtl;

    NSArray *typeArr;
    NSArray *titleArr;
    UIView *bgView;//黑色透明背景
    SelectTypeViewController *selVC;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    ZoneSelViewController *zoneSelectVC;
    
    
    UIScrollView *conScrollView;
    UIButton *leftOfferBtn;
    UIButton *rightVipBtn;
    UIView *lineView;
    UIView *btnView;
    
    BOOL isLeftOfferShow;//yes左边 NO右边(暂时没用)
}

@property (nonatomic,retain)SearchParam_DataModal *searchParam;

@property (nonatomic, strong)  NSMutableArray  *dataRctdArr;
@end

@implementation New_ELSelectionViewController

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
    _searchParam = [[SearchParam_DataModal alloc] init];
    
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
    selVC.deliverType = _type;
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
    _seachView = [[TxtSearchView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, 44)];
    _seachView.backgroundColor = [UIColor clearColor];
    _seachView.delegate = self;
    _seachView.txt.delegate = self;
    [self.navigationController.navigationBar addSubview:_seachView];
}

//右边即将推出来的视图
-(void)configRightView{
    zoneSelectVC = [[ZoneSelViewController alloc]init];
    [self.view addSubview:zoneSelectVC.view];
    zoneSelectVC.delegate = self;
    zoneSelectVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    zoneSelectVC.resumeType = _resumeType;
    [self addChildViewController:zoneSelectVC];
}


#pragma mark--请求数据后，是否有offer派是否是VIP，重新布局  2016.12.19 去掉一览精选中交付业务
-(void)configScrollWithIsOffer:(NSString *)isOffer isVip:(NSString *)isVip{
      BOOL is_offer = [isOffer boolValue];
//    NSInteger is_vip = [isVip integerValue];
//    if (!(is_offer > 0) && !(is_vip > 0)) {
//        [self showNoDataOkView:YES];
//    }
//    else if(is_offer > 0 && is_vip > 0){
//        [self addLeftAndRightBtnViewWithHidden:NO];
//        [self addScrollViewWithToTop:2];
//        [self addVCToScrollWitnOffsetIdx:0];
//    }
//    else if(is_offer > 0 && !(is_vip > 0)){
//        [self addLeftAndRightBtnViewWithHidden:YES];
//        [self addScrollViewWithToTop:1];
//        [self addVCToScrollWitnOffsetIdx:1];
//    }
//    else if(is_vip > 0 && !(is_offer > 0)){
        [self addLeftAndRightBtnViewWithHidden:YES];
        [self addScrollViewWithToTop:1 showHint:is_offer];
        [self addVCToScrollWitnOffsetIdx:2];
//    }
    
    [self configUI];
}

-(void)addScrollViewWithToTop:(NSInteger)top showHint:(BOOL)show{
    
    if (show) {
        [self showOfferPartyHintView];
        top += 1;
    }
    
    if (!conScrollView) {
        conScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, top * 44, ScreenWidth, ScreenHeight - top * 44 - 64)];
        conScrollView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        conScrollView.contentSize = CGSizeMake(1 * ScreenWidth, ScreenHeight - top * 44 - 64);
        conScrollView.delegate = self;
        conScrollView.bounces = NO;
        conScrollView.pagingEnabled = YES;
        [self.view addSubview:conScrollView];
    }
}

#pragma mark - offer派入口
- (void)showOfferPartyHintView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 48)];
    label.backgroundColor = UIColorFromRGB(0xfff3bb);
    label.text = @"offer派、V聘会、快聘宝和猎头的简历点这里>";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorFromRGB(0xd4973f);
    label.textAlignment = NSTextAlignmentCenter;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = label.frame;
    [btn addTarget:self action:@selector(jumpToOffer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:label];
    [self.view addSubview:btn];
}

- (void)jumpToOffer
{
    CHROfferPartyListCtl *offerPartyList = [[CHROfferPartyListCtl alloc]init];
    //offerPartyList.navigationItem.title = tempTitle;
    [offerPartyList setNavTitle:@"Offer派 快聘宝 V聘会"];
    offerPartyList.companyId = companyId_;
    offerPartyList.companyInfo = _companyInfo;
    [self.navigationController pushViewController:offerPartyList animated:YES];
    [offerPartyList beginLoad:companyId_ exParam:nil];
}

-(void)addLeftAndRightBtnViewWithHidden:(BOOL)isHidden{
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 44)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    bottomLine.backgroundColor = UIColorFromRGB(0xe0e0e0);
    [btnView addSubview:bottomLine];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth/2, 2)];
    lineView.backgroundColor = UIColorFromRGB(0xe13e3e);
    [btnView addSubview:lineView];
    
    leftOfferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftOfferBtn setTitle:@"Offer派 快聘宝 V聘会" forState:UIControlStateNormal];
    [leftOfferBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    leftOfferBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 44);
    leftOfferBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnView addSubview:leftOfferBtn];
    
    rightVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightVipBtn setTitle:@"会员推荐" forState:UIControlStateNormal];
    [rightVipBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
    rightVipBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 44);
    rightVipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnView addSubview:rightVipBtn];
    
    [leftOfferBtn addTarget:self action:@selector(SelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightVipBtn addTarget:self action:@selector(SelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bgView.hidden = isHidden;
}

-(void)addVCToScrollWitnOffsetIdx:(NSInteger)idx{
    
    ELVIPRecommendViewController *vipVC = [self configVipVC];
    vipVC.view.frame =  CGRectMake(0, 0, ScreenWidth, conScrollView.frame.size.height);
}

-(ELVIPRecommendViewController *)configVipVC{
    ELVIPRecommendViewController *vipVC = [[ELVIPRecommendViewController alloc]init];
    [conScrollView addSubview:vipVC.view];
    vipVC.jobId_ = _jobId_;
    [self addChildViewController:vipVC];
    [vipVC beginLoad:companyId_ exParam:nil];
    return vipVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark--数据请求
-(void)getDataFunction:(RequestCon *)con
{
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}
//请求企业是否参加Offer派，是否是会员
-(void)requestComType{
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)requestCon_.pageInfo_.currentPage_] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",companyId_,conditionStr];
    NSString *function = @"getIs3000And3001";
    NSString *op = @"company_person_busi";
    [BaseUIViewController showLoadView:YES content:nil view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
        NSString *is_3000 = result[@"is_3000"];
        NSString *is_3001 = result[@"is_3001"];
        [self configScrollWithIsOffer:is_3000 isVip:is_3001];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
        [self showNoDataOkView:YES];
    }];

}

#pragma mark - netWork 当前列表所包含的职位
-(void)requestGwtjData
{
    //组装请求参数
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[CommonConfig getDBValueByKey:@"synergy_id"] forKey:@"m_id"];
    [conditionDic setObject:[CommonConfig getDBValueByKey:@"m_dept_id"] forKey:@"m_dept_id"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@&type=%@",companyId_,conditionStr,@"open"];
    
    NSString *function = @"getZpNameForSearch";
    NSString *op = @"company_person_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if (![result isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in result) {
                CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
                model.id_ = [dic objectForKey:@"id"];
                model.str_ = [dic objectForKey:@"jtzw"];
                model.positionMark = @"1";
                if (model.str_.length > 0)
                {
                    [self.dataRctdArr addObject:model];
                }
            }
        }
        
        CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
        model.id_ = @"";
        model.str_ = @"不限";
        model.positionMark = @"2";
        [self.dataRctdArr insertObject:model atIndex:0];
        
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
    _seachView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 44);
    _seachView.hidden = YES;
    myRightBarBtnItem_.hidden = NO;
    backBarBtn_.hidden = NO;
    [_seachView.txt resignFirstResponder];
}

#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    _type = 2;
    [self requestComType];
//顾问推荐（一览精选）
    [self requestGwtjData];
    [self setNavTitle:@"一览精选"];
    [self loadData];
}

-(void)loadData{
    if (_entrance == POSITION) {
        if (!_positionName) {
            _positionName = @"";
        }
       titleArr = @[@"阅读状态",_positionName,@"学历",@"更多"];
        if (!_searchParam) {
            _searchParam = [[SearchParam_DataModal alloc] init];
            _searchParam.searchType_ = 3;
        }
        [self postNotify];
    }else{
        titleArr = @[@"阅读状态",@"职位",@"学历",@"更多"];
    }
//
//    typeArr = @[@(ELTimesType),@(DeliverStatusType),@(PositionType),@(DeliverMoreType)];
    
//    titleArr = @[@"阅读状态",@"职位",@"学历",@"更多"];
    typeArr = @[@(read_Status),@(PositionType),@(EduType),@(DeliverMoreType)];
}

#pragma mark--代理
#pragma mark-txtDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchParam.searchName = textField.text;
    [self postNotify];
    [_seachView.txt resignFirstResponder];
    return YES;
}

#pragma mark-scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_seachView.txt resignFirstResponder];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x == 0) {
        isLeftOfferShow = YES;
        lineView.frame = CGRectMake(0, 42, ScreenWidth/2, 2);
        [leftOfferBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [rightVipBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
    }
    else{
        isLeftOfferShow = NO;
        lineView.frame = CGRectMake(ScreenWidth/2, 42, ScreenWidth/2, 2);
        [rightVipBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [leftOfferBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
    }
}

#pragma mark-New_HeaderDelegate点击
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    __weak typeof(self) weakSelf = self;
    New_HeaderBtn *btn = (New_HeaderBtn *)sender.view;
    NSInteger idx = btn.tag - kSelBtnTag;
    selVC.selecType = [typeArr[idx] integerValue];
    nowBtn = btn;
    if (_entrance == POSITION) {
        CondictionList_DataModal *dataModel = [[CondictionList_DataModal alloc] init];
        dataModel.bSelected_ = YES;
        dataModel.str_ = _positionName;
        dataModel.id_ = _jobId_;
        selVC.condictionList_DataModal = dataModel;
    }
    if (![btn isEqual:selectedBtn]) {
        bgView.hidden = NO;
        btn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
        btn.markImg.hidden = NO;
        btn.titleLb.textColor = UIColorFromRGB(0xe13e3e);
        selectedBtn.markImg.hidden = YES;
        selectedBtn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more"];
        selectedBtn.titleLb.textColor = UIColorFromRGB(0x333333);
        [selVC loadData];
        selVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64);
        }];
        selectedBtn = btn;
        selectedBtn.isSelected = YES;
    }
    else{
//        bgView.hidden = YES;
        [self btnSetting:btn];
    }

    
    [UIView animateWithDuration:0.2 animations:^{
        zoneSelectVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    }];
    
    selVC.selectBolck = ^(id data){
        [weakSelf dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        btn.isSelected = !btn.isSelected;
     
        if(idx == 0){
            CondictionList_DataModal *selectedVO = (CondictionList_DataModal *)data;
            weakSelf.searchParam.workTypeValue_ = selectedVO.id_;
            if ([selectedVO.str_ isEqualToString:@"不限"]) {
                selectedVO.str_ = @"阅读状态";
            }
            btn.titleLb.text = selectedVO.str_;
        }
        else if(idx == 1 && _resumeType == 1){//投递应聘状态
            [weakSelf statuSelClick:data withBtn:btn];
        }
        else if (idx == 1 && _resumeType == 2) {//职位
            NSMutableArray *arr = (NSMutableArray *)data;
            [weakSelf positionBtnSetting:arr withBtn:btn];
        }
        else if (idx == 2){//学历
            CondictionList_DataModal *selectedVO = (CondictionList_DataModal *)data;
            weakSelf.searchParam.eduId_ = selectedVO.id_;
            btn.titleLb.text = selectedVO.str_;
        }
        else{//更多
            [weakSelf moreSelClick:data];
        }
        [weakSelf postNotify];
    };
}

-(void)positionBtnSetting:(NSMutableArray *)selectedArr withBtn:(New_HeaderBtn *)btn{
    NSString *titleStr;
    NSString *idStr;
    _isDown = YES;
    if (selectedArr.count == 0) {
        titleStr = @"职位";
        _jobId_ = @"";
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
        _jobId_ = idStr;
    }
    btn.titleLb.text = titleStr;
}

#pragma mark-searchViewDelegate
-(void)searchViewClearBtnClick:(UIButton *)btn{
    _seachView.txt.text = nil;
}

-(void)cancelBtnClick:(UIButton *)btn{
    _searchParam.searchName = @"";
    _seachView.txt.text = nil;
    [self postNotify];
    [UIView animateWithDuration:0.1 animations:^{
        _seachView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 44);
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

#pragma mark --ZoneSelDelegate
-(void)backBtnClicked:(UIButton *)btn{
    [self hideRightSel];
}

-(void)rightCellSelected{
    [self hideRightSel];
}

#pragma mark--事件
//左右按钮点击
-(void)SelBtnClick:(UIButton *)sender{
    [_seachView.txt resignFirstResponder];
    if (sender == leftOfferBtn) {
        isLeftOfferShow = YES;
        lineView.frame = CGRectMake(0, 42, ScreenWidth/2, 2);
        [leftOfferBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [rightVipBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        conScrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
        isLeftOfferShow = NO;
        lineView.frame = CGRectMake(ScreenWidth/2, 42, ScreenWidth/2, 2);
        [rightVipBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
        [leftOfferBtn setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        conScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }
}

//背景点击
-(void)tapClick:(UITapGestureRecognizer *)tap{
    kUserDefaults(@(YES), @"bottomBtn_isSelected");
    kUserSynchronize;
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = NO;
}

//背景点击
-(void)bgTapClick:(UITapGestureRecognizer *)tap{
    kUserDefaults(@(YES), @"bottomBtn_isSelected");
    kUserSynchronize;
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    [self hideRightSel];
    nowBtn.isSelected = NO;
}
//搜搜按钮点击
- (IBAction)searchBtnClick:(id)sender {
    if (_seachView.hidden) {
        _seachView.hidden = NO;
    }
    [UIView animateWithDuration:0.1 animations:^{
        _seachView.frame = CGRectMake(0, 0, ScreenWidth, 44);
        myRightBarBtnItem_.hidden = YES;
        backBarBtn_.hidden = YES;
    } completion:^(BOOL finished) {
        [_seachView.txt becomeFirstResponder];
    }];
}
#pragma mark--通知
-(void)postNotify{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailSelWithELConditionSelection" object:nil userInfo:@{@"searchVO":_searchParam,@"jobIdSlected":_jobId_}];
}

-(void)dealloc{
    [_seachView removeFromSuperview];
    _seachView = nil;
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
            selVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64);
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
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
}

-(void)statuSelClick:(id)data withBtn:(New_HeaderBtn *)btn{
    
    CondictionList_DataModal *selectedVO;
    if ([data isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)data count] > 0) {
            selectedVO = data[0];
        }
    }
    else if ([data isKindOfClass:[CondictionList_DataModal class]]){
        selectedVO = data;
    }
    self.searchParam.process_state = selectedVO.id_;
    if ([selectedVO.str_ isEqualToString:@"不限"]) {
        selectedVO.str_ = @"状态";
    }
    btn.titleLb.text = selectedVO.str_;
}

-(void)hideRightSel{
    [UIView animateWithDuration:0.2 animations:^{
        zoneSelectVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
    }];
}

-(void)showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if(flag){
        UIView *noDataOkView = [self getNoDataView];
        if(self.view && noDataOkView ){
            [self.view addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
            rect.origin.x = (int)((self.view.frame.size.width - rect.size.width)/2.0);
            rect.origin.y = 0;
            [noDataOkView setFrame:rect];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"111111111");
}

@end
