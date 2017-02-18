//
//  ConsultantSearchCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantSearchCtl.h"
#import "ConsultantSearchCell.h"
#import "ExRequetCon.h"
#import "ELResumeTradeChangeCtl.h"
#import "ELSearchView.h"

#import "ELJobSearchCondictionChangeCtl.h"

#import "SelectTypeViewController.h"
#import "New_HeaderBtn.h"

#import "sqlitData.h"

#define kSelBtnTag 98760
#define kMaxToBottom 93
//TradeChangeDelegate
@interface ConsultantSearchCtl ()<UITextFieldDelegate,New_HeaderDelegate,changeJobSearchCondictionDelegate>
{
//    SearchParam_DataModal           *searchParam_;
    NSArray *workAgeArray_;
    NSArray  *workAgeValueArray_;
    NSArray  *workAgeValueArray_1;
    UIButton        *searchBtn;
    UITextField          *keyWorkTf;
    ConsultantHRDataModel *inModel;
    RequestCon     *requesntTest;
    BOOL shouldRefresh_;
    NSMutableArray           *tradeArray;
    NSArray *btnSelArr;
    NSArray *placehoderArr;
    UIView *searchCon;
    BOOL state;
    UIButton *leftBtn;
    NSString *searchType;
    NSMutableArray *dataSource;
    
    ELJobSearchCondictionChangeCtl *condictionCtl;
    NSArray *titleArr;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    UIView *bgView;
    
    UITapGestureRecognizer *navBarTap;
}
@property (nonatomic, retain)SearchParam_DataModal *paramDataModel;
@property(nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation ConsultantSearchCtl

#pragma mark LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [bgView removeFromSuperview];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self addObserVer];
    btnSelArr = @[@"关键字",@"职位",@"企业"];
    placehoderArr = @[@"搜索关键字或简历编号",@"搜索职位名称关键字",@"搜索企业名称关键字"];
    searchType = @"key";
    dataSource = [NSMutableArray arrayWithCapacity:10];
    tradeArray = [[NSMutableArray alloc] init];

    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    
    [self configUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [condictionCtl hideView];
    if (!bgView.hidden) {
        bgView.hidden = YES;
    }
    [self hideSearchConView];
    [keyWorkTf resignFirstResponder];
    [self.navigationController.navigationBar removeGestureRecognizer:navBarTap];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!navBarTap) {
        navBarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearchConView)];
    }
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self.navigationController.navigationBar addGestureRecognizer:navBarTap];
}

#pragma mark--配置界面--
-(void)configUI{
    if (!condictionCtl)
    {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,108,ScreenWidth,ScreenHeight - 108)];
        condictionCtl.delegate_ = self;
    }
    
   UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 115, 44)];
    searchView.layer.masksToBounds = YES;
    self.navigationItem.titleView = searchView;
    
    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth - 115, 24)];
    bgImgv.layer.cornerRadius = 2;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    //    添加左侧按钮
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"关键字" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(5, 10, 45, 24);
    leftBtn.titleLabel.font = FOURTEENFONT_CONTENT;
    [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [searchView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    添加图标
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, 6, 4)];
    img.image = [UIImage imageNamed:@"popoverArrowDown@2x"];
    [searchView addSubview:img];
    
    //    添加线条
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(59, 12, 1, 20)];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [searchView addSubview:lineView];
    
    //    搜索框
    keyWorkTf = [[UITextField alloc] initWithFrame:CGRectMake(62, 10, searchView.frame.size.width - 65, 24)];
    keyWorkTf.returnKeyType = UIReturnKeySearch;
    keyWorkTf.placeholder = @"搜索关键字或简历编号";
    [keyWorkTf setFont:THIRTEENFONT_CONTENT];
    [keyWorkTf setTextColor:BLACKCOLOR];
    keyWorkTf.delegate = self;
    [keyWorkTf setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:keyWorkTf];
//    _keyWorkTF = keyWorkTF;
    
    //    右侧搜索按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn.titleLabel setFont:FIFTEENFONT_TITLE];
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
    
    [self configCondition];
    
    //   关键字选择背景view
    searchCon = [[UIView alloc]initWithFrame:CGRectMake(52, 51, 60, 75)];
    searchCon.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [[UIApplication sharedApplication].keyWindow addSubview:searchCon];
    [self configBtnSel];
    searchCon.hidden = YES;
    
}

//配置关键字
-(void)configBtnSel{
    
    double width = searchCon.frame.size.width;
    double height = searchCon.frame.size.height;
    for (int i = 0; i < btnSelArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, height/3 * i, width, height/3);
        [btn setTitle:btnSelArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [btn.titleLabel setFont:THIRTEENFONT_CONTENT];
        [searchCon addSubview:btn];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnSelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, height/3 * i, width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xececec);
        [searchCon addSubview:lineView];
    }
}

//配置条件搜索
-(void)configCondition{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:headerView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, ScreenWidth, ScreenHeight - 64 - 44)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    titleArr = @[@"地区",@"学历",@"经验",@"年龄"];
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
}



//左侧关键字选择btnClick
-(void)leftBtnClick:(UIButton *)btn{
    
    if (!state) {
        searchCon.hidden = NO;
    }
    else{
        searchCon.hidden = YES;
    }
    NSLog(@"%d",state);
    state = !state;
}
//关键字选择
-(void)btnSelClick:(UIButton *)btn{
    [leftBtn setTitle:btnSelArr[btn.tag - 1000] forState:UIControlStateNormal];
    keyWorkTf.placeholder = placehoderArr[btn.tag - 1000];
    //    keyWorkTF.text = @"";
    if (btn.tag == 1000) {
        searchType = @"key";
    }
    else if(btn.tag == 1001){
        searchType = @"job";
    }
    else{
        searchType = @"company";
    }
    state = !state;
    searchCon.hidden = YES;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
    _paramDataModel = [[SearchParam_DataModal alloc] init];
//    if (!requesntTest) {
//        requesntTest = [self getNewRequestCon:NO];
//    }
   // [requesntTest gunwenTrade:[Manager getUserInfo].userId_];
//    conFlag = YES;
}

#pragma mark - 简历下载成功回调
- (void)loadRcResumeSuccess
{
    [tableView_ reloadData];
}

- (void)rightBarBtnResponse:(id)sender
{
    [self hideSearchConView];
    [keyWorkTf resignFirstResponder];
    [self refreshLoad:nil];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    if (!_paramDataModel) {
        _paramDataModel = [[SearchParam_DataModal alloc] init];
    }
    
    //处理为空
    NSString *wokeAge = _paramDataModel.workAgeValue_;
    NSString *wokeAge1 = _paramDataModel.workAgeValue_1;
    if (!wokeAge) {
        wokeAge = @"";
    }
    if (!wokeAge1) {
        wokeAge1 = @"";
    }
    
    if (!keyWorkTf.text) {
        keyWorkTf.text = @"";
    }
    if (!_paramDataModel.tradeId_) {
        _paramDataModel.tradeId_ = @"1000";
    }
    
    if (!_paramDataModel.regionId_ || [_paramDataModel.regionId_ isEqualToString:@"100000"]) {
        _paramDataModel.regionId_ = @"";
    }
    [con guwenSearchConWithKeyword:keyWorkTf.text salarid:inModel.salerId pageSize:20 page:requestCon_.pageInfo_.currentPage_ model:_paramDataModel searchType:searchType];
    /*
    
    New_HeaderBtn *gzNumBtn = [self.view viewWithTag:kSelBtnTag + 2];
    NSString *rctypes;
    if ([gzNumBtn.titleLb.text isEqualToString:@"应届毕业生"]) {
        
        rctypes = @"0";
       
        [con gunwenSearchResume:keyWorkTf.text tradeId:_paramDataModel.tradeId_ regionId:_paramDataModel.regionId_ gznum:wokeAge gznum1:wokeAge1 rctypes:@"0" personId:[Manager getUserInfo].userId_ pageSize:10 pageIndex:requestCon_.pageInfo_.currentPage_ withIsTotal:_paramDataModel.isTotalTrade searchType:searchType salerName:[Manager getHrInfo].userName];
        
    }else{
        [con gunwenSearchResume:keyWorkTf.text tradeId:_paramDataModel.tradeId_ regionId:_paramDataModel.regionId_ gznum:wokeAge gznum1:wokeAge1 rctypes:nil personId:[Manager getUserInfo].userId_ pageSize:10 pageIndex:requestCon_.pageInfo_.currentPage_ withIsTotal:_paramDataModel.isTotalTrade searchType:searchType salerName:[Manager getHrInfo].userName];
        rctypes = nil;
    }
     */
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GunwenTrade:
        {
//            [tradeArray removeAllObjects];
            NSMutableArray *tradeArr;
            New_HeaderBtn *tradeBtn = [self.view viewWithTag:kSelBtnTag + 1];
            if (dataArr.count > 0)
            {
                CondictionList_DataModal *model = dataArr[0];
//                [_tradeBtn setTitle:model.str_ forState:UIControlStateNormal];
                tradeBtn.titleLb.text = model.str_;
                _paramDataModel.tradeId_ = model.id_;
                _paramDataModel.tradeStr_ = model.str_;
                _paramDataModel.isTotalTrade = model.isTotalTrade;
                tradeArr = [NSMutableArray arrayWithArray:dataArr];
            }
            else
            {
                CondictionList_DataModal *model = [[CondictionList_DataModal alloc] init];
                model.str_ = @"所有行业";
                model.id_ = nil;
                model.bParent_ = NO;
//                [_tradeBtn setTitle:model.str_ forState:UIControlStateNormal];
                tradeBtn.titleLb.text = model.str_;
                _paramDataModel.tradeId_ = model.id_;
                _paramDataModel.tradeStr_ = model.str_;
                _paramDataModel.isTotalTrade = model.isTotalTrade;
                tradeArr = [@[model]mutableCopy];
            }
            
//            [tradeArray addObjectsFromArray:dataArr];
            [self refreshLoad:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gwTradeData" object:nil userInfo:@{@"gwTrade":tradeArr}];
        }
            break;
        case Request_ConsultantSearchResume:
        {
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

//隐藏关键字选择
-(void)hideSearchConView{
    if (state) {
        searchCon.hidden = YES;
        state = !state;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == keyWorkTf) {
        [keyWorkTf resignFirstResponder];
        [self refreshLoad:nil];
    }
    [self hideSearchConView];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (nowBtn.isSelected) {
        [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        nowBtn.isSelected = !nowBtn.isSelected;
        [condictionCtl hideView];
    }
    return YES;
}

-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case RegionChange:
        {
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            SqlitData *modal = (SqlitData *)dataModel;
            _paramDataModel.regionStr_ = modal.provinceName;
            _paramDataModel.regionId_ = modal.provinceld;
            _paramDataModel.isSelected = modal.selected;
            if ([modal.provinceName isEqualToString:@"不限"]) {
                selectedBtn.titleLb.text = @"地区";
            }else{
                selectedBtn.titleLb.text = _paramDataModel.regionStr_; 
            }
            //地区参数改变后自动请求
            [self refreshLoad:nil];        
        }
            break;
        case EducationChange:
        {
             [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            CondictionList_DataModal *modal = dataModel;
            _paramDataModel.eduId_ = modal.id_;
            _paramDataModel.eduName_ = modal.str_;
            if ([modal.str_ isEqualToString:@"不限"]){
                nowBtn.titleLb.text = @"学历";
            }else{
                nowBtn.titleLb.text = modal.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        case ExperienceChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            _paramDataModel.experienceName = modal.str_;
            _paramDataModel.experienceValue1 = modal.id_;
            _paramDataModel.experienceValue2 = modal.id_1;
            if ([modal.str_ isEqualToString:@"不限"]){
                nowBtn.titleLb.text = @"经验";
            }else{
                nowBtn.titleLb.text = modal.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        case AgeChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
            nowBtn.isSelected = !nowBtn.isSelected;
            _paramDataModel.workAgeName_ = modal.str_;
            _paramDataModel.workAgeValue_ = modal.id_;
            _paramDataModel.workAgeValue_1 = modal.id_1;
            if ([modal.str_ isEqualToString:@"不限"]){
                nowBtn.titleLb.text = @"年龄";
            }else{
                nowBtn.titleLb.text = modal.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark--通知
-(void)addObserVer{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moreCacel:) name:@"moreCacel" object:nil];
}

-(void)moreCacel:(NSNotification *)notyfi{
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = !nowBtn.isSelected;
    bgView.hidden = YES;
}
#pragma mark--New_HeaderDelegate

-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    [self hideSearchConView];
    [keyWorkTf resignFirstResponder];
    New_HeaderBtn *btn = (New_HeaderBtn *)sender.view;
    NSInteger idx = btn.tag - kSelBtnTag;
    nowBtn = btn;
    if (![btn isEqual:selectedBtn]) {
        bgView.hidden = NO;
        btn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
        btn.markImg.hidden = NO;
        btn.titleLb.textColor = UIColorFromRGB(0xe13e3e);
        selectedBtn.markImg.hidden = YES;
        selectedBtn.titleImg.image = [UIImage imageNamed:@"小筛选下拉more"];
        selectedBtn.titleLb.textColor = UIColorFromRGB(0x333333);
        
        selectedBtn = btn;
        selectedBtn.isSelected = YES;
    }
    else{
        [self btnSetting:btn];
    }

    switch (idx) {
        case 0://地区
        {
            SqlitData *data = [[SqlitData alloc] init];
            data.provinceld = _paramDataModel.regionId_;
            data.selected = _paramDataModel.isSelected;
            [self selectedType:RegionChange Model:data nowSelBtn:btn];
        }
            break;
        case 1://学历
        {
            CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
            data.str_ = _paramDataModel.eduName_;
            data.id_ = _paramDataModel.eduId_;
            [self selectedType:EducationChange Model:data nowSelBtn:btn];
        }
            break;
        case 2://经验
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = _paramDataModel.experienceName;
            modal.id_ = _paramDataModel.experienceValue1;
            modal.id_1 = _paramDataModel.experienceValue2;
            [self selectedType:ExperienceChange Model:modal nowSelBtn:btn];
        }
            break;
        case 3://年龄
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = _paramDataModel.workAgeName_;
            modal.id_ = _paramDataModel.workAgeValue_;
            modal.id_1 = _paramDataModel.workAgeValue_1;
            [self selectedType:AgeChange Model:modal nowSelBtn:btn];
        }
            break;

        default:
            break;
    }
}


#pragma mark--业务逻辑
-(void)btnSetting:(New_HeaderBtn *)btn{
    if (!btn.isSelected) {
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
}

-(void)selectedType:(CondictionChangeType)conditionType Model:(id)model nowSelBtn:(New_HeaderBtn *)selBtn{
    if (!condictionCtl)
    {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,108,ScreenWidth,ScreenHeight - 108)];
        condictionCtl.delegate_ = self;
    }
    if (condictionCtl.currentType == conditionType)
    {
        [condictionCtl hideView];
        return;
    }
    [condictionCtl hideView];
    [condictionCtl creatViewWithType:conditionType selectModal:model];
    [condictionCtl showView];
}

#pragma mark - tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ConsultantSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantSearchCell" owner:self options:nil] lastObject];
        cell.redMark.layer.cornerRadius = 2.0;
        cell.redMark.layer.masksToBounds = YES;
    }
    User_DataModal *model = requestCon_.dataArr_[indexPath.row];
    
    [cell.photoImagv sd_setImageWithURL:[NSURL URLWithString:model.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [cell.name setText:model.name_];
    NSString *descStr = nil;
    if ([model.gzNum_ isEqualToString:@"0.0"] || [model.gzNum_ isEqualToString:@""]) {
        model.gzNum_ = @"0";
    }
    NSString *edu = nil;
    if ([model.eduName_ isEqualToString:@""] || !model.eduName_) {
        edu = @"";
    }else{
        edu = [NSString stringWithFormat:@"| %@",model.eduName_];
    }
    if ([model.regionCity_ isEqualToString:@""] || !model.regionCity_) {
        descStr = [NSString stringWithFormat:@"%@年经验 %@",model.gzNum_,edu];
    }else{
        descStr = [NSString stringWithFormat:@"%@ | %@年经验 %@",model.regionCity_,model.gzNum_,edu];
    }
    [cell.contentDescLb setText:descStr];
    [cell.jobLb setText:[NSString stringWithFormat:@"意向职位:%@",model.job_]];
    
    
    if ([model.kj isEqualToString:@"0"]) {
        [cell.redMark setText:@"保密"];
        [cell.redMark setHidden:NO];
    }
    else{
        if (!model.isDown) {
            model.isDown = @"0";
        }
        if ([model.isDown isEqualToString:@"0"]) {
            [cell.redMark setHidden:YES];
        }else{
            [cell.redMark setHidden:NO];
        }
    }
    
    NSString *time = [model.sendtime_ substringToIndex:10];
    [cell.timeLb setText:time];
    if ([model.sex_ isEqualToString:@"男"]) {
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else{
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }
    [cell.gender setTitle:model.age_ forState:UIControlStateNormal];
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if ([keyWorkTf isFirstResponder]) {
        [keyWorkTf resignFirstResponder];
        return;
    }
    
    [self hideSearchConView];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal *model = selectData;
    ConsultantResumePreviewCtl *consultantResumePreviewCtl = [[ConsultantResumePreviewCtl alloc] init];
    consultantResumePreviewCtl.searchFlag = _searchFlag;
    [self.navigationController pushViewController:consultantResumePreviewCtl animated:YES];
    consultantResumePreviewCtl.salerId = inModel.salerId;
    [consultantResumePreviewCtl beginLoad:model exParam:inModel.salerId];
    consultantResumePreviewCtl.delegate = self;
}

#pragma mark scrollview delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideSearchConView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if 0
- (void)btnResponse:(id)sender
{
    [keyWorkTf resignFirstResponder];
    if (sender == _regionBtn) {
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        vc.blockString = ^(SqlitData *regionModel)
        {
            [self chooseCityToSearch:regionModel];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender == _tradeBtn)
    {
        ELResumeTradeChangeCtl *ctl = [[ELResumeTradeChangeCtl alloc] init];
        ctl.arrDataList = [[NSMutableArray alloc] init];
        [ctl.arrDataList addObjectsFromArray:tradeArray];
        
        ctl.changeDelegate = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (sender == _gznumBtn){
        ConditionItemCtl *conditionItemCtl_ = [[ConditionItemCtl alloc]init];
        conditionItemCtl_.delegate_ = self;
        NSArray *tempArray = [[NSArray alloc]initWithObjects:workAgeArray_,workAgeValueArray_,workAgeValueArray_1, nil];
        [conditionItemCtl_ beginLoad:tempArray exParam:nil];
        [conditionItemCtl_ setConditionType_:condition_WorkAge];
        [self.navigationController pushViewController:conditionItemCtl_ animated:YES];
    }
}

-(void)tradeChangeDelegateModa:(CondictionList_DataModal *)Modal
{
    [_tradeBtn setTitle:Modal.str_ forState:UIControlStateNormal];
    _paramDataModel.tradeId_ = Modal.id_;
    _paramDataModel.tradeStr_ = Modal.str_;
    _paramDataModel.isTotalTrade = Modal.isTotalTrade;
    [self refreshLoad:nil];
}
#pragma mark-返回地区
- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = regionModel.provinceName;
    dataModal.id_ = regionModel.provinceld;
    //地区参数添加道搜索参数
    _paramDataModel.regionStr_ = dataModal.str_;
    _paramDataModel.regionId_ = dataModal.id_;
    NSString *tempRegionStr = nil;
    if (_paramDataModel.regionStr_.length > 5) {
        tempRegionStr = [_paramDataModel.regionStr_ substringToIndex:5];
        [_regionBtn setTitle:tempRegionStr forState:UIControlStateNormal];
    }else{
        [_regionBtn setTitle:_paramDataModel.regionStr_ forState:UIControlStateNormal];
    }
    //地区参数改变后自动请求
    [self refreshLoad:nil];
}

#pragma mark - 搜索条件代理
- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1
{
    _paramDataModel.workAgeValue_ = conditionValue;
    _paramDataModel.workAgeValue_1 = conditionValue1;
    _paramDataModel.workAgeName_ = conditionName;
    
    [_gznumBtn setTitle:_paramDataModel.workAgeName_ forState:UIControlStateNormal];
    [self refreshLoad:nil];
}

#pragma mark 行业选择回调
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetTradeType:
        {
            if( !dataModal || dataModal.id_ == nil ){
                [_tradeBtn setTitle:@"所有行业" forState:UIControlStateNormal];
                _paramDataModel.tradeId_ = @"1000";
                _paramDataModel.tradeStr_ = @"所有行业";
            }else{
                [_tradeBtn setTitle:dataModal.str_ forState:UIControlStateNormal];
                _paramDataModel.tradeId_ = dataModal.id_;
                _paramDataModel.tradeStr_ = dataModal.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

#endif

@end
