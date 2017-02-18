//
//  ELResumeChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/11/7.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELResumeChangeCtl.h"
#import "CompanyResumePrevierwModel.h"
#import "ELOfferPartyCompanyResumePreviewCtl.h"

@interface ELResumeChangeCtl ()<NewResumePreviewCtlDelegate,ELResumeLoadDelegate,UIScrollViewDelegate,CompanyResumePreviewDelegate>
{
    UIScrollView *_scrollView;
    User_DataModal *userModel;
    NSString *companyId_;
    NSInteger currentIndex;
    id currentCtl;
    NSMutableDictionary *urlModelDic;    
    NSMutableArray *dataModelArr;
    UIButton *_shareBtn;    /** 转发按钮 */
    UIButton *_appraiseBtn; /** 简历评价 */
    UIView *rightView;
    UIView *alertView;
}
@end

@implementation ELResumeChangeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"简历预览"];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(40, 0, 40, 40);
    _shareBtn.tag = 50;
    [_shareBtn setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:_shareBtn];
    
    _appraiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _appraiseBtn.frame = CGRectMake(0, 0, 40, 40);
    _appraiseBtn.tag = 51;
    [_appraiseBtn setImage:[UIImage imageNamed:@"mark-2"] forState:UIControlStateNormal];
    [_appraiseBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:_appraiseBtn];
    
    //调整item与右边的距离
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSInteger width = -10;
    negativeSpacer.width = width;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];

    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setFd_interactivePopDisabled:YES];
    currentIndex = -1;
    dataModelArr = [[NSMutableArray alloc] init];
    if ([_arrData isKindOfClass:[NSArray class]] ) {
        [dataModelArr addObjectsFromArray:_arrData];
    }
    
    [self creatUI];
    
    if (![self getAlertShowStatus]) {
        alertView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,312,180)];
        image.image = [UIImage imageNamed:@"resume_alert_image"];
        image.center = alertView.center;
        [alertView addSubview:image];
        
        alertView.userInteractionEnabled = YES;
        [alertView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlert)]];
        [self setAlertShowStatus];
        
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:alertView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interviewResumeSuccess:) name:@"ELResumeTranspondCtlSuccess" object:nil];
}

-(void)interviewResumeSuccess:(NSNotification *)notification{
    [urlModelDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)currentIndex]];
    ELNewResumePreviewCtl *resumeTypeCtl1 = currentCtl;
    resumeTypeCtl1.previewModel = nil;
    User_DataModal *model = dataModelArr[currentIndex];
    [resumeTypeCtl1 beginLoad:model exParam:companyId_];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoMoreData:) name:@"refreshResumeCount" object:nil];
    
}

#pragma mark - 第一次进入简历预览显示引导页相关
-(void)hideAlert{
    if (alertView) {
        [alertView removeFromSuperview];
        alertView = nil;
    }
}

-(BOOL)getAlertShowStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"resume_show_alert_status"];
}
-(void)setAlertShowStatus{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"resume_show_alert_status"];
}

#pragma mark - 导航栏右侧按钮点击事件
-(void)rightBtnClick:(UIButton *)sender
{
    if ([currentCtl isKindOfClass:[ELNewResumePreviewCtl class]]) {
        [((ELNewResumePreviewCtl *)currentCtl) rightBtnClick:sender];
    }else if ([currentCtl isKindOfClass:[ELOfferPartyCompanyResumePreviewCtl class]]){
        [((ELOfferPartyCompanyResumePreviewCtl *)currentCtl) rightBtnClick:sender];
    }
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    userModel = dataModal;
    companyId_ = exParam;
}

-(void)creatUI{
    urlModelDic = [[NSMutableDictionary alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(dataModelArr.count*ScreenWidth,0);
    if (_selectRow > 0) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth*_selectRow,0)];
    }
    [self scrollViewDidScroll:_scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger index = _scrollView.contentOffset.x/ScreenWidth;
        NSInteger indexOne = _scrollView.contentOffset.x-(ScreenWidth*index);
        if ((index != currentIndex) && indexOne == 0){
            if (_resumeEntry == 2) {
               
                [self loadOfferResumeDetailCtlWithIndex:index];
            }else{
                [self loadResumeDetailCtlWithIndex:index];
            }
            
            currentIndex = index;
            if (index == dataModelArr.count-1) {
                if (_resumeEntry == 2) {
                    [self requestMoreData];
                }else{
                    
                    [self requestLoadData];
                }
            }
        }
    }
}

#pragma mark - 加载简历预览页面
-(void)loadResumeDetailCtlWithIndex:(NSInteger)index{
    ELNewResumePreviewCtl *resumeTypeCtl1 = [[ELNewResumePreviewCtl alloc] init];
    resumeTypeCtl1.resumeListType = _resumeListType;
    resumeTypeCtl1.delegate = self;
    resumeTypeCtl1.loadDelegate = self;
    resumeTypeCtl1.isRecommend = _isRecommend;
    resumeTypeCtl1.selType = _selType;
    resumeTypeCtl1.idx = index;//_idx;
    resumeTypeCtl1.forType = _forType;
    [_scrollView addSubview:resumeTypeCtl1.view];
    User_DataModal *model = dataModelArr[index];
    resumeTypeCtl1.view.frame = CGRectMake(ScreenWidth*index,0,ScreenWidth,ScreenHeight-64);
    
    CompanyResumePrevierwModel *preModel = [urlModelDic objectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    if(preModel){
        resumeTypeCtl1.previewModel = preModel;
    }
    [self addChildViewController:resumeTypeCtl1];
    [resumeTypeCtl1 beginLoad:model exParam:companyId_];
    [((ELNewResumePreviewCtl *)currentCtl).view removeFromSuperview];
    currentCtl = resumeTypeCtl1;
    [BaseUIViewController showLoadView:YES content:@"" view:self.view];
}

- (void)loadOfferResumeDetailCtlWithIndex:(NSInteger)index
{
    ELOfferPartyCompanyResumePreviewCtl *previewCtl = [[ELOfferPartyCompanyResumePreviewCtl alloc] init];
    previewCtl.isRecommend = _isRecommend;
    previewCtl.fromtype = _fromtype;
    previewCtl.resumeSelectType = _resumeSelectType;
    previewCtl.delegate = self;
    
    previewCtl.currentPage = _currentPage;
    previewCtl.idx = index;
    
    [_scrollView addSubview:previewCtl.view];
    User_DataModal *model = dataModelArr[index];
    previewCtl.view.frame = CGRectMake(ScreenWidth*index,0,ScreenWidth,ScreenHeight-64);
    
    [self addChildViewController:previewCtl];
    
#warning 11
    model.fromType = _fromtype;
    
    
    [previewCtl beginLoad:model exParam:companyId_];
    [((ELOfferPartyCompanyResumePreviewCtl *)currentCtl).view removeFromSuperview];
    currentCtl = previewCtl;
    [BaseUIViewController showLoadView:YES content:@"" view:self.view];
    

}

#pragma mark - NewResumePreviewCtlDelegate
-(void)downloadResume:(User_DataModal*)dataModal{
    if ([_delegate respondsToSelector:@selector(downloadResume:)]) {
        [_delegate downloadResume:dataModal];
    }
}
-(void)ModifyResume:(User_DataModal*)dataModal passed:(BOOL)bePassed{
    if ([_delegate respondsToSelector:@selector(ModifyResume:passed:)]) {
        [_delegate ModifyResume:dataModal passed:bePassed];
    }
}

#pragma mark - 简历加载完成相关代理
-(void)finishLoadWithModel:(id)model{
    if (model) {
        [urlModelDic setObject:model forKey:[NSString stringWithFormat:@"%ld",(long)currentIndex]];
    }
}

-(void)finishLoad{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
}

#pragma mark - 请求下一组数据 一览精选
-(void)requestLoadData{
    if ([_loadDelegate respondsToSelector:@selector(requestLoadRequest:)]) {
        if (!requestCon_) {
           requestCon_ = [self getNewRequestCon:NO]; 
           requestCon_.pageInfo_ = [[PageInfo alloc] init];
        }
        requestCon_.pageInfo_.currentPage_ = _currentPage;
        [_loadDelegate requestLoadRequest:requestCon_];
        _currentPage ++;
    }
}
#pragma mark - 请求下一组数据 老offer派
- (void)requestMoreData
{
    if (dataModelArr.count == _totalCount) {
        return;
    }
    if ([_loadDelegate respondsToSelector:@selector(requestLoadRequest:)]) {
        if (!requestCon_) {
            requestCon_ = [self getNewRequestCon:NO];
            requestCon_.pageInfo_ = [[PageInfo alloc] init];
        }
        requestCon_.pageInfo_.currentPage_ = _currentPage;
        [_loadDelegate requestLoadRequest:requestCon_];
        _currentPage ++;
    }
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    //[super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_CompanyRecommendedResume:
        case Request_CompanyResume:
        case Request_DownloadResumeList:
        case Request_GetCompanyCollectionResume:
        case Request_GetCompanyTurnTomeResume:
        case Request_CompanySearchResume:
        {
            @try {
                User_DataModal *dataModel = [dataModelArr firstObject];
                NSInteger sums = dataModel.totalCnt_;
                if (dataModelArr.count < sums) {
                    [dataModelArr addObjectsFromArray:dataArr];
                    _scrollView.contentSize = CGSizeMake(ScreenWidth*dataModelArr.count,0);
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)getNoMoreData:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    NSArray *array = [dic objectForKey:@"key"];
    if (array.count > 0) {
        [dataModelArr removeAllObjects];
        [dataModelArr addObjectsFromArray:array];
        _scrollView.contentSize = CGSizeMake(ScreenWidth*dataModelArr.count,0);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
