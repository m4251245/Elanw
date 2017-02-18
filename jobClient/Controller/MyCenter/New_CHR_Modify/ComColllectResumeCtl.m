//
//  ComColllectResumeCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/26.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ComColllectResumeCtl.h"
#import "Manager.h"
#import "CHRResumeCell.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "ELNewResumePreviewCtl.h"

#import "SelectTypeViewController.h"
#import "New_HeaderBtn.h"
#import "CondictionList_DataModal.h"
#import "TxtSearchView.h"

#import "ZoneSelViewController.h"
#import "sqlitData.h"
#import "ELResumeChangeCtl.h"

#define kSelBtnTag 98760
#define kMaxToBottom 93

@interface ComColllectResumeCtl ()<changeJobSearchCondictionDelegate,New_HeaderDelegate,searchViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,LoadDataBlockDelegate>
{
    NSString * companyId_;
    
    IBOutlet UIButton *_regionBtn;     /**<地区 */
    IBOutlet UIButton *_exprienceBtn;  /**<经验 */
    IBOutlet UIButton *_ageBtn;        /**<年龄 */
    IBOutlet UIButton *_eduBtn;        /**<学历要求 */
    
    NSMutableArray *_btnArr;   /**<存放按钮 */
    UIButton *_selectedBtn;    /**<选中按钮 */
    
    ELJobSearchCondictionChangeCtl *condictionChangeCtl;
//    SearchParam_DataModal   *_searchModel;
    
    NSArray *titleArr;
    NSArray *typeArr;
    UIView *bgView;//黑色透明背景
    SelectTypeViewController *selVC;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    TxtSearchView *seachView;
    ZoneSelViewController *zoneVC;
}
@property (nonatomic,strong)SearchParam_DataModal *searchParam;
@property(nonatomic, copy) NSString *regionId;
@end

@implementation ComColllectResumeCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
    }
    return self;
}
#pragma mark--初始化UI
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotify];
    [self setNavTitle:@"暂存简历"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _searchParam = [[SearchParam_DataModal alloc] init];
    
//    _btnArr = [[NSMutableArray alloc] initWithObjects:_regionBtn, _exprienceBtn, _ageBtn, _eduBtn, nil];
    
    [self loadData];
    [self configUI];
}

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
    [self.view addSubview:selVC.view];
    [self addChildViewController:selVC];
    
    UITapGestureRecognizer *bgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    bgtap.delegate = self;
    [selVC.view addGestureRecognizer:bgtap];
    
    zoneVC = [[ZoneSelViewController alloc]init];
    zoneVC.view.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, 0);
    zoneVC.isZone = YES;
    zoneVC.resumeType = _resumeType;
    [self.view addSubview:zoneVC.view];
    [self addChildViewController:zoneVC];
    
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
    [self configRight];

}

-(void)configSearch{
    seachView = [[TxtSearchView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, 44)];
    seachView.backgroundColor = [UIColor clearColor];
    seachView.delegate = self;
    seachView.txt.delegate = self;
    [self.navigationController.navigationBar addSubview:seachView];
}

-(void)configRight{
    myRightBarBtnItem_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:myRightBarBtnItem_];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8, 8, 24, 24);
    [btn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [myRightBarBtnItem_ addSubview:btn];
    [btn addTarget:self action:@selector(seachClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"暂存简历";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
//    [condictionChangeCtl hideView];
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
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getCompanyCollectionResume:companyId_ isGroup:@"" pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ searchModel:_searchParam];
}

#pragma mark - LoadDataBlockDelegate
-(void)requestLoadRequest:(RequestCon *)con{
    [con getCompanyCollectionResume:companyId_ isGroup:@"" pageSize:20 pageIndex:con.pageInfo_.currentPage_ searchModel:_searchParam];
}

-(void)loadData{
    titleArr = @[@"学历",@"地区",@"经验",@"年龄"];
    typeArr = @[@(EduType),@(ZoneType),@(ExperenceType),@(AgeType)];
}

#pragma mark--代理
#pragma mark--scrollView代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [seachView.txt resignFirstResponder];
}

#pragma mark - UITableViewDelegate
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
        cell.statusLb.hidden = YES;
    }
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
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
        cell.jobLb.text =[NSString stringWithFormat:@"应聘: %@", userModel.job_];
    }else{
        cell.jobLb.text = @"";
    }
    if (userModel.updateTime.length>10) {
        cell.timeLb.text = [userModel.updateTime substringToIndex:10];
    }else{
        cell.timeLb.text = userModel.updateTime;
    }
    
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal * dataModal = selectData;
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = ResumeTypeTempSaved;
    resumePreviewCtl.forType = @"6000";
    resumePreviewCtl.idx = indexPath.row;
    
    resumePreviewCtl.selectRow = indexPath.row;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId_];
}

#pragma mark - New_HeaderDelegate(条件筛选按钮)点击
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
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
    
    selVC.selectBolck = ^(id data){
        CondictionList_DataModal *selectedVO = data;
        [weakSelf dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:idx];
        btn.isSelected = !btn.isSelected;
        if (idx == 0) {//学历
            weakSelf.searchParam.eduName_ = selectedVO.str_;
            weakSelf.searchParam.eduId_ = selectedVO.id_;
            if ([selectedVO.str_ isEqualToString:@"不限"]) {
                selectedVO.str_ = @"学历";
            }
        }
        else if(idx == 1){//状态
            
        }
        else if(idx == 2){//经验
            [weakSelf exp:selectedVO];
        }
        else if(idx == 3){//年龄
            [weakSelf age:selectedVO];
        }
        btn.titleLb.text = selectedVO.str_;
        [weakSelf refreshLoad:nil];
    };
}

#pragma mark-searchViewDelegate
-(void)searchViewClearBtnClick:(UIButton *)btn{
    seachView.txt.text = @"";
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
    if ([view isEqual:selVC.view] || [view isEqual:zoneVC.view]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark-txtDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchParam.searchName = textField.text;
    [self refreshLoad:nil];
    [seachView.txt resignFirstResponder];
    return YES;
}

#pragma mark--通知
-(void)dealloc{
    NSLog(@"-----%s",__func__);
    [seachView removeFromSuperview];
    seachView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)registerNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify:) name:@"ZoneSelected_Already" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notified:) name:@"DownLoadResumeSucess" object:nil];
}

-(void)receiveNotify:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    SqlitData *selectedVO = dic[@"ZoneSelected"];
    New_HeaderBtn *btn = [self.view viewWithTag:kSelBtnTag + 1];
    btn.titleLb.text = selectedVO.provinceName;
    [self dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more" idx:1];
    nowBtn.isSelected = NO;
    self.searchParam.regionId_ = selectedVO.provinceld;
    [self refreshLoad:nil];
}

-(void)notified:(NSNotification *)notify{
    NSNumber *selIdx = notify.object;
    NSInteger idx = [selIdx integerValue];
    [requestCon_.dataArr_ removeObjectAtIndex:idx];
    [tableView_ reloadData];
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


-(void)seachClick:(UIButton *)btn{
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

#pragma mark--业务逻辑
-(void)exp:(CondictionList_DataModal *)selectedVO{
    self.searchParam.experienceName = selectedVO.str_;
    self.searchParam.experienceValue1 = selectedVO.id_;
    self.searchParam.experienceValue2 = selectedVO.id_1;
    if ([selectedVO.str_ isEqualToString:@"不限"]) {
        selectedVO.str_ = @"经验";
    }
}

-(void)age:(CondictionList_DataModal *)selectedVO{
    self.searchParam.workAgeName_ = selectedVO.str_;
    self.searchParam.workAgeValue_ = selectedVO.id_;
    self.searchParam.workAgeValue_1 = selectedVO.id_1;
    if ([selectedVO.str_ isEqualToString:@"不限"]) {
        selectedVO.str_ = @"年龄";
    }
}

#pragma mark--业务逻辑--
-(void)dealSelectedAndUnSelectedIdx:(NSInteger)idx{
    if(idx == 1){
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

-(void)btnSetting:(New_HeaderBtn *)btn withIdx:(NSInteger)idx{
    if (!btn.isSelected) {
        if (idx == 1) {
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
        if (idx == 1) {
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

#if 0
- (void)confiBtnTitleFrame
{
    CGFloat btnWidth = ScreenWidth / 4;
    
    for (UIButton *btn in _btnArr) {
        if (btn == _selectedBtn) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btnWidth - btn.imageView.frame.size.width
                                                         - btn.titleLabel.intrinsicContentSize.width) / 2, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, (btnWidth - btn.imageView.frame.size.width
                                                       - btn.titleLabel.intrinsicContentSize.width) / 2 + btn.titleLabel.intrinsicContentSize.width, 0, 0);
            return;
        }
    }
}
#endif


#if 0
- (void)btnResponse:(id)sender
{
    if (sender == _regionBtn) {
        
        sqlitData *data = [[sqlitData alloc] init];
        data.provinceld = _searchParam.regionId_;
        
        [self showCondictionChangeView:RegionChange selectModal:data];
    }
    else if (sender == _exprienceBtn)
    {
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = _searchParam.experienceName;
        data.id_ = _searchParam.experienceValue1;
        data.id_1 = _searchParam.experienceValue2;
        
        [self showCondictionChangeView:ExperienceChange selectModal:data];
    }
    else if (sender == _ageBtn)
    {
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = _searchParam.workAgeName_;
        data.id_ = _searchParam.workAgeValue_;
        data.id_1 = _searchParam.workAgeValue_1;
        [self showCondictionChangeView:AgeChange selectModal:data];
    }
    else if (sender == _eduBtn)
    {
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = _searchParam.eduName_;
        data.id_ = _searchParam.eduId_;
        [self showCondictionChangeView:EducationChange selectModal:data];
    }
    
    _selectedBtn = (UIButton *)sender;
}

//下拉菜单
- (void)showCondictionChangeView:(CondictionChangeType)changeType selectModal:(id)selectModal
{
    if (!condictionChangeCtl)
    {
        condictionChangeCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,104,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 104)];
        condictionChangeCtl.delegate_ = self;
    }
    
    if (condictionChangeCtl.currentType == changeType)
    {
        [condictionChangeCtl hideView];
        return;
    }
    
    [condictionChangeCtl hideView];
    [condictionChangeCtl creatViewWithType:changeType selectModal:selectModal];
    [condictionChangeCtl showView];
}

#pragma mark - changeJobSearchCondictionDelegate
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case RegionChange:
        {
            sqlitData *modal = dataModel;
            _searchParam.regionStr_ = modal.provinceName;
            _searchParam.regionId_ = modal.provinceld;
            [_regionBtn setTitle:modal.provinceName forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        case ExperienceChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            [_exprienceBtn setTitle:modal.str_ forState:UIControlStateNormal];
            _searchParam.experienceName = modal.str_;
            _searchParam.experienceValue1 = modal.id_;
            _searchParam.experienceValue2 = modal.id_1;
            [self refreshLoad:nil];
        }
            break;
        case AgeChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            [_ageBtn setTitle:modal.str_ forState:UIControlStateNormal];
            _searchParam.workAgeName_ = modal.str_;
            _searchParam.workAgeValue_ = modal.id_;
            _searchParam.workAgeValue_1 = modal.id_1;
            [self refreshLoad:nil];
        }
            break;
        case EducationChange:
        {
            CondictionList_DataModal *modal = dataModel;
            [_eduBtn setTitle:modal.str_ forState:UIControlStateNormal];
            _searchParam.eduName_ = modal.str_;
            _searchParam.eduId_ = modal.id_;
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
    
    [self confiBtnTitleFrame];
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
