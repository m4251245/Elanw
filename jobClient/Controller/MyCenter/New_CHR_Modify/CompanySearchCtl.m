//
//  companySearchCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-1-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CompanySearchCtl.h"
#import "ChangeRegionViewController.h"
#import "Manager.h"
#import "peopleResumeDataModal.h"
#import "CHRResumeCell.h"
#import "SearchParam_DataModal.h"
#import "ELNewResumePreviewCtl.h"
#import "SelectTypeViewController.h"
#import "New_HeaderBtn.h"
#import "ZoneSelViewController.h"
#import "sqlitData.h"
#import "ELResumeChangeCtl.h"

#define kSelBtnTag 98760
#define kMaxToBottom 93

#define SEARCHVIEW_HEIGHT searchCon.frame.size.height
#define SEARCHVIEW_WIDTH searchCon.frame.size.width
#define BTN_TAG 111111

@interface CompanySearchCtl ()<UISearchBarDelegate, UITextFieldDelegate, ConditionItemCtlDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,New_HeaderDelegate,ZoneSelDelegate,LoadDataBlockDelegate>

{
    BOOL shouldRefresh_;
    UIButton *rightBtn;
    UIView *searchView ;
    User_DataModal *userModelInfo;
    UITextField *_keyWorkTF;
    UIButton *leftBtn;
    UIView *searchCon;
    NSArray *btnSelArr;
    UIView *selConView;
    NSArray *placehoderArr;
    BOOL state;
    NSString *searchType;
    
    NSArray *titleArr;
    NSArray *typeArr;
    UIView *bgView;//黑色透明背景
    SelectTypeViewController *selVC;
    ZoneSelViewController *zoneVC;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
}

@end

@implementation CompanySearchCtl

-(id)init
{
    self = [super init];
    
    //self.title = @"搜简历";
    bFooterEgo_ = YES;
    _regionId = @"";
    searchType = @"key";
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotify];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    btnSelArr = @[@"关键字",@"职位",@"企业"];
    placehoderArr = @[@"搜索关键字或简历编号",@"搜索职位名称关键字",@"搜索企业名称关键字"];
    [self configUI];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 3, 10, 1, 20)];
    line1.backgroundColor = UIColorFromRGB(0xececec);
    [_conditionView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 3*2, 10, 1, 20)];
    line2.backgroundColor = UIColorFromRGB(0xececec);
    [_conditionView addSubview:line2];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ((requestCon_ && [Manager shareMgr].isFromMessage_)||[requestCon_.dataArr_ count] == 0) {
        [self refreshLoad:nil];
        [Manager shareMgr].isFromMessage_ = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
    [self hideSearchConView];
}
#pragma mark--配置界面--
-(void)configUI{
    
    if ([_regionId isEqualToString:@""]) {
        _regionId = @"100000";
    }
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 115, 44)];
    
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
    leftBtn.titleLabel.font = THIRTEENFONT_CONTENT;
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
    _keyWorkTF = [[UITextField alloc] initWithFrame:CGRectMake(62, 10, searchView.frame.size.width - 65, 24)];
    _keyWorkTF.returnKeyType = UIReturnKeySearch;
    _keyWorkTF.tintColor = UIColorFromRGB(0xe13e3e);
    _keyWorkTF.placeholder = @"搜索关键字或简历编号";
    [_keyWorkTF setFont:THIRTEENFONT_CONTENT];
    [_keyWorkTF setTextColor:BLACKCOLOR];
    _keyWorkTF.tintColor = UIColorFromRGB(0xe13e3e);
    _keyWorkTF.delegate = self;
    [_keyWorkTF setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:_keyWorkTF];
//    _keyWorkTF = keyWorkTF;
    
    //    右侧搜索按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:FIFTEENFONT_TITLE];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
    
    _paramDataModel = [[SearchParam_DataModal alloc]init];
    
    _informalMemberTiPView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_informalMemberTiPView];
    [_informalMemberTiPView setHidden:YES];
    
    //   关键字选择背景view
    searchCon = [[UIView alloc]initWithFrame:CGRectMake(52, 51, 60, 75)];
    searchCon.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [[UIApplication sharedApplication].keyWindow addSubview:searchCon];
    [self configBtnSel];
    searchCon.hidden = YES;
    
    [self configCondition];
}

//配置关键字
-(void)configBtnSel{
    
    for (int i = 0; i < btnSelArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, SEARCHVIEW_HEIGHT/3 * i, SEARCHVIEW_WIDTH, SEARCHVIEW_HEIGHT/3);
        [btn setTitle:btnSelArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [btn.titleLabel setFont:THIRTEENFONT_CONTENT];
        [searchCon addSubview:btn];
        btn.tag = BTN_TAG + i;
        [btn addTarget:self action:@selector(btnSelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SEARCHVIEW_HEIGHT/3 * i, SEARCHVIEW_WIDTH, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xececec);
        [searchCon addSubview:lineView];
    }
}

//配置条件搜索
-(void)configCondition{
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
    [self.view addSubview:selVC.view];
    [self addChildViewController:selVC];
    
    zoneVC = [[ZoneSelViewController alloc]init];
    zoneVC.view.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, 0);
    zoneVC.isZone = YES;
    zoneVC.resumeType = _resumeType;
    [self.view addSubview:zoneVC.view];
    [self addChildViewController:zoneVC];
    
    UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    taped.delegate = self;
    [selVC.view addGestureRecognizer:taped];
    
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44) withTitle:titleArr[i] arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/titleArr.count , 0, ScreenWidth/titleArr.count, 44);
        selBtn.tag = kSelBtnTag + i;
        if (i == titleArr.count - 1) {
            selBtn.rightLineView.hidden = YES;
        }
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
}


#pragma mark--数据处理--
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _companyId = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    [self loadData];
}

-(void)loadData{
    titleArr = @[@"地区",@"工作年限",@"学历"];
    typeArr = @[@(ZoneType),@(WorkAgeAll),@(EduType)];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *keywords = @"";
    if (_keyWorkTF.text.length) {
        keywords = [_keyWorkTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSString *eduId = @"";
    if (_paramDataModel.eduId_) {
        eduId = _paramDataModel.eduId_;
    }
   
    NSString *wokeAge = _paramDataModel.workAgeValue_;
    NSString *wokeAge1 = _paramDataModel.workAgeValue_1;
    if (!wokeAge) {
        wokeAge = @"";
    }
    if (!wokeAge1) {
        wokeAge1 = @"";
    }
    
    if(!con)
    {
        con = [self getNewRequestCon:NO];
    }
    if ([_regionId isEqualToString:@"100000"]) {
        _regionId = @"";
    }
    
    [con companySearchResumeCompanyId:_companyId regionId:_regionId eduId:eduId workeAge:wokeAge workeAge1:wokeAge1 keyWord:keywords pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20 searchType:searchType];
    
}

#pragma mark - LoadDataBlockDelegate
-(void)requestLoadRequest:(RequestCon *)con{
    NSString *keywords = @"";
    if (_keyWorkTF.text.length) {
        keywords = [_keyWorkTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    NSString *eduId = @"";
    if (_paramDataModel.eduId_) {
        eduId = _paramDataModel.eduId_;
    }
    NSString *wokeAge = _paramDataModel.workAgeValue_;
    NSString *wokeAge1 = _paramDataModel.workAgeValue_1;
    if (!wokeAge) {
        wokeAge = @"";
    }
    if (!wokeAge1) {
        wokeAge1 = @"";
    }
    if ([_regionId isEqualToString:@"100000"]) {
        _regionId = @"";
    }
//    if ([[CommonConfig getDBValueByKey:@"CMdownResume"] isEqualToString:@"0"]) {
//        [BaseUIViewController showAlertView:@"" msg:@"您没有搜索职位的权限哟!" btnTitle:@"关闭"];
//        return;
//    }
    [con companySearchResumeCompanyId:_companyId regionId:_regionId eduId:eduId workeAge:wokeAge workeAge1:wokeAge1 keyWord:keywords pageIndex:con.pageInfo_.currentPage_ pageSize:20 searchType:searchType];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_CompanySearchResume:
        {
            shouldRefresh_ = NO;
            
            userModelInfo = dataArr[0];
            if ([userModelInfo.code_ isEqualToString:@"1"]) {
                [requestCon_.dataArr_ removeAllObjects];
                [_informalMemberTiPView setHidden:NO];
                [_conditionView setHidden:YES];
                [tableView_ setHidden:YES];
                [self setNavTitle:@"简历搜索"];
                [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
            
            }else{
                [_informalMemberTiPView setHidden:YES];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
                [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
                self.navigationItem.titleView = searchView;
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark--代理--
#pragma mark--tableView delegate
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHRResumeCell";
    CHRResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLb.hidden = YES;
    }
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
   
    cell.userNameLb.text = userModel.name_;
    
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;
    
    NSString *sex = userModel.sex_;
    if (userModel.age_.length < 4) {
        [cell.sexBtn setTitle:userModel.age_ forState:UIControlStateNormal];
    }
    else{
        [cell.sexBtn setTitle:@"未知" forState:UIControlStateNormal];
    }
    if ([sex isEqualToString:@"男"]) {
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else if ([sex isEqualToString:@"女"]){
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }else{
        [cell.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    
    if ([userModel.kj isEqualToString:@"0"]) {
        [cell.isDownImgv setHidden:YES];
        [cell.statusLb setHidden:NO];
        [cell.statusLb setText:@"保密"];
    }else{
        if ([userModel.isDown isEqualToString:@"1"]) {
            cell.isDownImgv.hidden = NO;
        }else{
            cell.isDownImgv.hidden = YES;
        }
        [cell.statusLb setHidden:YES];
    }
    
    NSDictionary *nameAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
    if (city.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:city attributes:nameAttr]];
        if (workAge.length > 0 || eduName.length > 0) {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
    }
    if (workAge.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@年工作经验", workAge] attributes:nameAttr]];
        if (eduName.length > 0) {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
    }
    if (eduName.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", eduName] attributes:nameAttr]];
    }
    cell.summaryLb.attributedText = attrString;
    if (userModel.job_) {
        cell.jobLb.text =[NSString stringWithFormat:@"意向职位: %@", userModel.job_];
    }else{
        cell.jobLb.text = @"";
    }
    NSString *time = [self dealTime:userModel.sendtime_];
    cell.timeLb.text = time;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132.0f;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal *dataModal = (User_DataModal *)selectData;
    
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = _resumeType;
    resumePreviewCtl.forType = @"0";
    
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    resumePreviewCtl.selectRow = indexPath.row;
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:_companyId];
}
 
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_keyWorkTF resignFirstResponder];
}

#pragma mark--DownloadResumeDelegate
-(void)hideKeyboard
{
    [_keyWorkTF resignFirstResponder];
}
 

#pragma DownloadResumeDelegate
-(void)downloadResume:(User_DataModal *)dataModal
{
    dataModal.isDown = @"1";
    [tableView_ reloadData];
}

#pragma mark--textFiled Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _keyWorkTF) {
        [_keyWorkTF resignFirstResponder];
        [self refreshLoad:nil];
    }
    [self hideSearchConView];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (nowBtn.isSelected) {
        [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:-1];
        nowBtn.isSelected = !nowBtn.isSelected;
        bgView.hidden = YES;
    }

    [self hideSearchConView];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [self hideSearchConView];
    return YES;
}
#pragma mark--scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self hideSearchConView];
    [_keyWorkTF resignFirstResponder];
}


#pragma mark-New_HeaderDelegate点击
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    [_keyWorkTF resignFirstResponder];
    __weak typeof(self) weakSelf = self;
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
        
        [self dealSelectedAndUnSelectedIdx:idx];
        
        selectedBtn = btn;
        selectedBtn.isSelected = YES;
    }
    else{
        [self btnSetting:btn withIdx:idx];
    }

    if (idx == 0) {
        
    }
    else{
        selVC.selectBolck = ^(id data){
            CondictionList_DataModal *selectedVO = data;
            [weakSelf dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:idx];
            btn.isSelected = !btn.isSelected;
            if (idx == 1) {
                weakSelf.paramDataModel.workAgeName_ = selectedVO.str_;
                weakSelf.paramDataModel.workAgeValue_ = selectedVO.id_;
                weakSelf.paramDataModel.workAgeValue_1 = selectedVO.id_1;
                if ([selectedVO.str_ isEqualToString:@"不限"]) {
                    selectedVO.str_ = @"工作年限";
                }
            }
            else if(idx == 2){
                weakSelf.paramDataModel.eduName_ = selectedVO.str_;
                weakSelf.paramDataModel.eduId_ = selectedVO.id_;
                if ([selectedVO.str_ isEqualToString:@"不限"]) {
                    selectedVO.str_ = @"学历";
                }
            }
            btn.titleLb.text = selectedVO.str_;
            [weakSelf refreshLoad:nil];
        };

    }
}

-(void)dealSelectedAndUnSelectedIdx:(NSInteger)idx{
    if(idx == 0){
        zoneVC.moreSelType = [typeArr[idx] integerValue];
        [zoneVC loadData];
        selVC.view.frame = CGRectMake(0, -ScreenHeight, ScreenWidth,0);
        zoneVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        [UIView animateWithDuration:0.2 animations:^{
            zoneVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
    }
    else{
        selVC.selecType = [typeArr[idx] integerValue];
        [selVC loadData];
        zoneVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, 0);
        selVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
    }
}

#pragma mark--gestureRecognizer代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *view = touch.view;
    if ([view isEqual:selVC.view] || [view isEqual:zoneVC.view]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark--通知
-(void)registerNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify:) name:@"ZoneSelected_Already" object:nil];
}

-(void)receiveNotify:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    SqlitData *selectedVO = dic[@"ZoneSelected"];
    self.regionId = selectedVO.provinceld;
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag];
    btn.titleLb.text = selectedVO.provinceName;
    [self dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:0];
    nowBtn.isSelected = NO;
    [self refreshLoad:nil];
}

#pragma mark--事件--
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:-1];
    nowBtn.isSelected = NO;
}

//背景点击
-(void)bgTapClick:(UITapGestureRecognizer *)tap{
    NSInteger idx = selectedBtn.tag - kSelBtnTag;
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:idx];
    nowBtn.isSelected = NO;
}

- (void)rightBarBtnResponse:(id)sender
{
    [_keyWorkTF resignFirstResponder];
    [self hideSearchConView];
    [self refreshLoad:nil];
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
    [leftBtn setTitle:btnSelArr[btn.tag - BTN_TAG] forState:UIControlStateNormal];
    _keyWorkTF.placeholder = placehoderArr[btn.tag - BTN_TAG];
    if (btn.tag == BTN_TAG) {
        searchType = @"key";
    }
    else if(btn.tag == BTN_TAG + 1){
        searchType = @"job";
    }
    else{
        searchType = @"company";
    }
    state = !state;
    searchCon.hidden = YES;
//    [self refreshLoad:nil];
}

#pragma mark--业务逻辑--
-(void)btnSetting:(New_HeaderBtn *)btn withIdx:(NSInteger)idx{
    if (!btn.isSelected) {
        if (idx == 0) {
            [zoneVC loadData];
        }
        else{
            [selVC loadData];
        }
        [self dealBtn:btn withColor:UIColorFromRGB(0xe13e3e) bgStatus:NO imageName:@"小筛选下拉more-sel" idx:idx];
    }
    else{
        [self dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:idx];
    }
    btn.isSelected = !btn.isSelected;
}

-(void)dealBtn:(New_HeaderBtn *)btn withColor:(UIColor *)color bgStatus:(BOOL)bgState imageName:(NSString *)imgName idx:(NSInteger)idx{
    bgView.hidden = bgState;
    btn.titleImg.image = [UIImage imageNamed:imgName];
    btn.titleLb.textColor = color;
    btn.markImg.hidden = bgState;
    if (!bgState) {
        if (idx == 0) {
            selVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, 0);
            [UIView animateWithDuration:0.2 animations:^{
                zoneVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
            }];
        }
        else{
            zoneVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, 0);
            [UIView animateWithDuration:0.2 animations:^{
                selVC.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
            }];
        }
       
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            selVC.view.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            zoneVC.view.frame = CGRectMake(0, -(ScreenHeight - kMaxToBottom - 64 - 44 - 44), ScreenWidth, ScreenHeight - kMaxToBottom - 64 - 44);
        }];
    }
    
}

#pragma mark--时间处理 
-(NSString *)dealTime:(NSString *)timeLb{
    NSArray *currentDateArr = [self currentTime];
//    当前天
    NSInteger currentDayNum = [currentDateArr[2] integerValue];
//    当前分钟
    NSInteger currentMinute = [currentDateArr[4] integerValue];
//    当前小时
    NSInteger currentHour = [currentDateArr[3] integerValue];
    
    NSArray *arr = [timeLb componentsSeparatedByString:@" "];
    NSString *dateStr = arr[0];
    NSString *timeStr = arr[1];
    NSArray *dataArr = [dateStr componentsSeparatedByString:@"-"];
    NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
    NSString *lastDataStr = dataArr[2];
    NSInteger lastDayNum = [lastDataStr integerValue];
    if (currentDayNum - lastDayNum == 0) {
        NSInteger lastHour = [timeArr[0] integerValue];
        NSInteger lastMinute = [timeArr[1] integerValue];
        if (currentHour - lastHour == 0) {

            if (currentMinute - lastMinute == 0) {
                return [NSString stringWithFormat:@"刚刚"];
            }else{
                NSInteger min = currentMinute - lastMinute;
                return [NSString stringWithFormat:@"%ld分钟前",(long)min];
            }
        }
        else if(currentHour - lastHour == 1){
            if (currentMinute >= lastMinute){
                return [NSString stringWithFormat:@"1小时前"];
            }
            else{
                return [NSString stringWithFormat:@"%ld分钟前",(long)(60 + currentMinute - lastMinute)];
            }
        }
        else{
            NSInteger hourN = currentHour - lastHour;
            hourN = labs(hourN);
            NSString *hour = [NSString stringWithFormat:@"%ld小时前",(long)hourN];
            return hour;
        }
    }
    else{
        return dateStr;
    }
}

#pragma mark--获取当前时间 
-(NSArray *)currentTime{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY MM dd HH mm ss"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    NSString *dateString = [formatter stringFromDate:currentDate];
    NSArray *arr = [dateString componentsSeparatedByString:@" "];
    return arr;
}
//隐藏关键字选择
-(void)hideSearchConView{
    if (state) {
        searchCon.hidden = YES;
        state = !state;
    }
}
@end
