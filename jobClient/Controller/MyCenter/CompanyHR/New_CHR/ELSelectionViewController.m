//
//  ELSelectionViewController.m
//  jobClient
//
//  Created by 一览ios on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSelectionViewController.h"
#import "SelectTypeViewController.h"
#import "New_HeaderBtn.h"
#import "SearchParam_DataModal.h"
#import "CondictionList_DataModal.h"
#import "TxtSearchView.h"
#import "CHRResumeCell.h"
#import "ELNewResumePreviewCtl.h"
#import "ELResumeChangeCtl.h"

#define kSelBtnTag 98760
#define kMaxToBottom 93
//New_HeaderDelegate,UIGestureRecognizerDelegate,
@interface ELSelectionViewController ()<UITableViewDataSource,UITableViewDelegate,searchViewDelegate,UITextFieldDelegate,LoadDataBlockDelegate>{
    NSArray *titleArr;
    NSArray *typeArr;
    UIView *bgView;//黑色透明背景
    SelectTypeViewController *selVC;
    New_HeaderBtn *selectedBtn;//上一个选中按钮
    New_HeaderBtn *nowBtn;//当前选中的按钮
    TxtSearchView *seachView;
    NSString *companyId;
    NSMutableArray *dataArrary;
}

@property (nonatomic,strong)SearchParam_DataModal *searchParam;
@end

@implementation ELSelectionViewController

- (void)viewDidLoad {
    bFooterEgo_ = YES;
    [super viewDidLoad];
//    [self configUI];
    [self configSearch];
    [self configRight];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    seachView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 44);
    seachView.hidden = YES;
    myRightBarBtnItem_.hidden = NO;
    backBarBtn_.hidden = NO;
    [seachView.txt resignFirstResponder];
}

#pragma mark--初始化UI
-(void)configSearch{
    [self setNavTitle:@"转发给我"];
    _searchParam = [[SearchParam_DataModal alloc]init];
    tableView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
    seachView = [[TxtSearchView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, 44)];
    seachView.backgroundColor = [UIColor clearColor];
    seachView.delegate = self;
    seachView.txt.delegate = self;
    [self.navigationController.navigationBar addSubview:seachView];
    
    tableView_.tableFooterView = [[UIView alloc]init];
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

#pragma mark--加载数据
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    companyId = dataModal;
    [self loadData];
}

-(void)loadData{
    titleArr = @[@"学历",@"状态",@"经验",@"筛选"];
}

#pragma mark--请求数据
-(void)getDataFunction:(RequestCon *)con{
    [con getTurnToMeResume:companyId pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ searchModel:_searchParam];
}

#pragma mark - LoadDataBlockDelegate
-(void)requestLoadRequest:(RequestCon *)con{
    [con getTurnToMeResume:companyId pageSize:20 pageIndex:con.pageInfo_.currentPage_ searchModel:_searchParam];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (type == Request_GetCompanyTurnTomeResume) {
        dataArrary = [NSMutableArray arrayWithArray:dataArr];
        [tableView_ reloadData];
    }
}

#pragma mark--代理
#pragma mark-txtDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchParam.searchName = textField.text;
    [self refreshLoad:nil];
    [seachView.txt resignFirstResponder];
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [seachView.txt resignFirstResponder];
}

#pragma mark--tableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"CHRResumeCell";
    CHRResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLb.hidden = YES;
    }
    User_DataModal *userModel = dataArrary[indexPath.row];
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
        [cell.sexBtn setTitle:@"无" forState:UIControlStateNormal];
    }
    
    if ([sex isEqualToString:@"男"]) {
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }
    else if ([sex isEqualToString:@"女"]){
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }
    else{
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
    }
    else{
        cell.jobLb.text = @"";
    }
    
    if (userModel.updateTime.length>10) {
        cell.timeLb.text = [userModel.updateTime substringToIndex:10];
    }
    else{
        cell.timeLb.text = userModel.updateTime;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User_DataModal * dataModal = dataArrary[indexPath.row];
    //ELNewResumePreviewCtl
    ELResumeChangeCtl *resumePreviewCtl = [[ELResumeChangeCtl alloc] init];
    resumePreviewCtl.resumeListType = _resumeType;
    resumePreviewCtl.isRecommend = YES;
    resumePreviewCtl.forType = @"5000";
    
    resumePreviewCtl.selectRow = indexPath.row;
    resumePreviewCtl.loadDelegate = self;
    resumePreviewCtl.arrData = requestCon_.dataArr_;
    resumePreviewCtl.currentPage = requestCon_.pageInfo_.currentPage_;
    
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId];
}

#pragma mark-searchViewDelegate
-(void)searchViewClearBtnClick:(UIButton *)btn{
    seachView.txt.text = @"";
}

-(void)cancelBtnClick:(UIButton *)btn{
    _searchParam = [[SearchParam_DataModal alloc] init];
    seachView.txt.text = nil;
    [self refreshLoad:nil];
    [UIView animateWithDuration:0.1 animations:^{
        seachView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, 44);
        myRightBarBtnItem_.hidden = NO;
        backBarBtn_.hidden = NO;
    }];
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
#pragma mark--通知
-(void)dealloc{
    [seachView removeFromSuperview];
    seachView = nil;
}

#if 0
-(void)loadData{
    typeArr = @[@(EduType),@(Turn_Status),@(ExperenceType),@(SelectType)];
    [tableView_ reloadData];
}

-(void)configUI{
    //    self.navigationItem.title = @"转发给我";
    
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
    
    UITapGestureRecognizer *taped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    taped.delegate = self;
    [selVC.view addGestureRecognizer:taped];
    
    for (int i = 0; i < titleArr.count; i++) {
        New_HeaderBtn *selBtn = [[New_HeaderBtn alloc]initWithFrame:CGRectMake(i * ScreenWidth/4 , 0, ScreenWidth/4, 44) withTitle:titleArr[i]arrCount:titleArr.count];
        selBtn.delegate = self;
        selBtn.frame = CGRectMake(i * ScreenWidth/4 , 0, ScreenWidth/4, 44);
        selBtn.tag = kSelBtnTag + i;
        [headerView addSubview:selBtn];
    }
    [self.view bringSubviewToFront:headerView];
    
}

#pragma mark-New_HeaderDelegate点击
-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender{
    __weak typeof(self) weakSelf = self;
    New_HeaderBtn *btn = (New_HeaderBtn *)sender.view;
    NSInteger idx = btn.tag - kSelBtnTag;
    selVC.selecType = [typeArr[idx] integerValue];
    nowBtn = btn;
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
    
    selVC.selectBolck = ^(id data){
        [weakSelf dealBtn:btn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
        btn.isSelected = !btn.isSelected;
        CondictionList_DataModal *selectedVO = (CondictionList_DataModal *)data;
        if (idx == 0) {
            if ([selectedVO.str_ isEqualToString:@"不限"]) {
                selectedVO.str_ = @"学历";
            }
        }
        if(idx == 1){
            if ([selectedVO.str_ isEqualToString:@"不限"]) {
                selectedVO.str_ = @"状态";
            }
        }
        if (idx == 2) {
            if ([selectedVO.str_ isEqualToString:@"不限"]) {
                selectedVO.str_ = @"经验";
            }
        }
        if(idx == 3){
            if ([selectedVO.str_ isEqualToString:@"全部"]) {
                selectedVO.str_ = @"筛选";
            }
        }
        btn.titleLb.text = selectedVO.str_;
    };
}

#pragma mark--gestureRecognizer代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *view = touch.view;
    if ([view isEqual:selVC.view]) {
        return YES;
    }
    else{
        return NO;
    }
}
#pragma mark--事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = NO;
}

//背景点击
-(void)bgTapClick:(UITapGestureRecognizer *)tap{
    [self dealBtn:nowBtn withColor:UIColorFromRGB(0x333333) bgStatus:YES imageName:@"小筛选下拉more"];
    nowBtn.isSelected = NO;
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
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
