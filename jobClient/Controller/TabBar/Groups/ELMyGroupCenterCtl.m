//
//  ELMyGroupCenterCtl.m
//  jobClient
//
//  Created by 王新建 on 15/10/28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//  社群模块中心视图

#import "ELMyGroupCenterCtl.h"
#import "GroupsChangeTypeCtl.h"
//#import "ZBarScanLoginCtl.h"
#import "ELGroupSearchCtl.h"
#import "ELGroupListTypeCountModel.h"
#import "ELOwnGroupListCtl.h"
#import "OwnGroupListCtl.h"

@interface ELMyGroupCenterCtl () <UIScrollViewDelegate,NoLoginDelegate,UISearchBarDelegate>
{
    UIScrollView *contentScrollView;//顶部列表view
    
//    __weak IBOutlet UIScrollView *listScrollView;//内容存放view
    UIScrollView *listScrollView;//内容存放view
    UIImageView *lineImage; //顶部按钮下方的红线
    NSMutableArray *contentDataArr;//顶部列表数据
    NSMutableArray *ctlViewArr;//控制器存放数组
    NSMutableArray *btnArr;//顶部按钮存放数组
    UIButton *selectBtn;//当前选中的按钮
    
    UIButton * createBtn_;//左上角创建社群按钮
    UIButton *zbarBtn_;//左上角扫码加群按钮
    UIButton *moreBtn_;//左上角+号按钮
    
    BOOL isPop_;  //标识右上角弹框的显示状态 YES为显示、NO为隐藏

    UIView *tapView; //用于点击隐藏右上角弹框
    UISearchBar *searchBar_;//顶部搜索框
}
@end

@implementation ELMyGroupCenterCtl

#pragma mark - LifeCycle
- (void)dealloc{
    NSLog(@"%s",__func__);
}

-(instancetype)init{
    self = [super init];
    if (self){
        contentDataArr = [[NSMutableArray alloc] init];
        ctlViewArr = [[NSMutableArray alloc] init];
        btnArr = [[NSMutableArray alloc] init];
        self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight-64);
        self.view.backgroundColor = UIColorFromRGB(0xe9e9e9);
    }
    return self;
}
#pragma mark 双击底部导航按钮及单机状态栏所执行的通知
- (void)statusBarTouchedAction{
    NSInteger i = [contentDataArr indexOfObject:selectBtn.titleLabel.text];
    id ctl = ctlViewArr[i];
    if ([ctl isKindOfClass:[ELOwnGroupListCtl class]]) {
        ELOwnGroupListCtl *ownGroup = ctl;
        [ownGroup tableViewContentSizeZero];
    }else if ([ctl isKindOfClass:[GroupsChangeTypeCtl class]]){
        GroupsChangeTypeCtl *changeCtl = ctl;
        [changeCtl tableViewContentSizeZero];
    }
}

-(void)refreshLoad:(RequestCon *)con{
    for (id ctl in ctlViewArr){
        [ctl refreshLoad:nil];
    }
}

-(void)refreshBtnList{
    return;
}

- (void)viewDidLoad {
    
    backBarBtn_.hidden = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
    view.backgroundColor = [UIColor clearColor];
    
    moreBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn_ setImage:[UIImage imageNamed:@"more_white_new"] forState:UIControlStateNormal];
    moreBtn_.backgroundColor = [UIColor clearColor];
    moreBtn_.frame = CGRectMake(0,0,49,40);
    [moreBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreBtn_];
    
    myRightBarBtnItem_ = view;
    
    [super viewDidLoad];
   
    tapView = [[UIView alloc] initWithFrame:self.view.bounds];
    tapView.hidden = YES;
    [self.view addSubview:tapView];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-145,8,135,103)];
    image.image = [UIImage imageNamed:@"back_button_image"];
    [tapView addSubview:image];
    
    createBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn_ setImage:[UIImage imageNamed:@"group_creatgroup_image"] forState:UIControlStateNormal];
    createBtn_.backgroundColor = [UIColor clearColor];
    createBtn_.frame = CGRectMake(ScreenWidth-145,16,135,46);
    [createBtn_ setTitle:@"创建社群" forState:UIControlStateNormal];
    [createBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    createBtn_.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,15);
    [tapView addSubview:createBtn_];
    
    zbarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [zbarBtn_ setImage:[UIImage imageNamed:@"group_zbarcode_image"] forState:UIControlStateNormal];
    zbarBtn_.backgroundColor = [UIColor clearColor];
    zbarBtn_.frame = CGRectMake(ScreenWidth-145,65,135,46);
    [zbarBtn_ setTitle:@"扫码加群" forState:UIControlStateNormal];
    [zbarBtn_ addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    zbarBtn_.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,15);
    [tapView addSubview:zbarBtn_];
    
//    self.navigationItem.title = @"社群";
    [self setNavTitle:@"社群"];

    tapView.userInteractionEnabled = YES;
    
    searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0,-1,ScreenWidth,44)];
    searchBar_.translucent = YES;
    searchBar_.barTintColor = UIColorFromRGB(0xE9E9E9);
    searchBar_.placeholder = @"输入感兴趣的公司名称、职位、职业领域";
    [self.view addSubview:searchBar_];
    searchBar_.delegate = self;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    [self hidePopView];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view == tapView) {
        [self hidePopView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"社群";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //开始请求数据
    if (contentDataArr.count == 0){
        [contentDataArr addObjectsFromArray:@[@"我的社群",@"精选群",@"公司群",@"职业群"]];
        [self creatView];
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchedAction) name:@"statusBarTouchedAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePopView) name:@"tabBarButtonStatus" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"statusBarTouchedAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabBarButtonStatus" object:nil];
}


#pragma mark - 创建4个列表
-(void)creatView{
    if(contentDataArr.count == 0){
        return;
    }
    CGRect rect = [UIScreen mainScreen].bounds;

    if (!listScrollView) {
        listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,82, self.view.frame.size.width, self.view.frame.size.height-82)];
        [self.view addSubview:listScrollView];
        listScrollView.contentSize = CGSizeMake(self.view.frame.size.width*4, self.view.frame.size.height-87);
    }
    
    if (!contentScrollView) {
        contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,41,ScreenWidth,40)];
        [self.view addSubview:contentScrollView];
    }
    
    listScrollView.contentSize = CGSizeMake(rect.size.width*contentDataArr.count,listScrollView.frame.size.height);
    listScrollView.bounces = YES;
    listScrollView.showsHorizontalScrollIndicator = NO;
    listScrollView.showsVerticalScrollIndicator = NO;
    listScrollView.pagingEnabled = YES;
    listScrollView.delegate = self;
    
    contentScrollView.bounces = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.scrollEnabled = NO;
    contentScrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 0;
    for (NSInteger i = 0; i < contentDataArr.count ;i++){
        NSString *strName  = contentDataArr[i];
       // CGSize size = [strName sizeNewWithFont:FIFTEENFONT_TITLE];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = FIFTEENFONT_TITLE;//FOURTEENFONT_CONTENT;
        [btn setTitle:strName forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            [btn setTitleColor:PINGLUNHONG forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
        }
        [btn sizeToFit];
        btn.frame = CGRectMake(0,0,btn.frame.size.width+5,40);
        width += btn.frame.size.width;
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnScrollViewContent:) forControlEvents:UIControlEventTouchUpInside];
        [contentScrollView addSubview:btn];
        [btnArr addObject:btn];
        
        if([strName isEqualToString:@"我的社群"]){
            OwnGroupListCtl *ctl = [[OwnGroupListCtl alloc] init];
            ctl.hideSearchBar = YES;
            ctl.view.frame = CGRectMake(rect.size.width*i,0,rect.size.width,rect.size.height-64-82);
            [listScrollView addSubview:ctl.view];
            [ctlViewArr addObject:ctl];
            [self addChildViewController:ctl];
            [ctl beginLoad:nil exParam:nil];
            [ctl viewWillAppear:NO];
        }
        else
        {
            GroupsChangeTypeCtl *ctl = [[GroupsChangeTypeCtl alloc] init];
            if([strName isEqualToString:@"精选群"]){
                ctl.groupType = 1;
                ctl.showAdView = YES;
            }else if([strName isEqualToString:@"公司群"]){
                ctl.groupType = 3;
                ctl.isHaveTradeChange = YES;
            }else if([strName isEqualToString:@"职业群"]){
                ctl.groupType = 2;
                ctl.showTypeChangeList = YES;
            }
            ctl.hideSearchBar = YES;
            ctl.view.frame = CGRectMake(rect.size.width*i,0,rect.size.width,rect.size.height-64-82);
            [listScrollView addSubview:ctl.view];
            [self addChildViewController:ctl];
            [ctlViewArr addObject:ctl];
        }
    }
    
    CGFloat btnWidth = (ScreenWidth-32-width)/3.0;
    width = 16;
    for (UIButton *btn in btnArr) {
        CGRect frame = btn.frame;
        frame.origin.x = width;
        btn.frame = frame;
        width = CGRectGetMaxX(frame)+btnWidth;
    }
    
    [contentScrollView addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(0,40,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    
    if(!lineImage){
        lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,39,40,2)];
        lineImage.backgroundColor = PINGLUNHONG;
        [contentScrollView addSubview:lineImage];
    }
    [contentScrollView bringSubviewToFront:lineImage];
    UIButton *btn = btnArr[0];
    [self changeLineImageFrameWithButton:btn];
    selectBtn = btn;
}

#pragma mark - 修改红色线条的位置和大小
-(void)changeLineImageFrameWithButton:(UIButton *)button{
    CGRect frame = lineImage.frame;
    frame.size.width = button.frame.size.width;
    lineImage.frame = frame;
    
    CGPoint center = lineImage.center;
    center.x = button.center.x;
    
    CGFloat contentY = 0;
    if (center.x > 1600)
    {
        contentY = center.x - 160;
    }
    [UIView animateWithDuration:0.2 animations:^{
        lineImage.center = center;
        contentScrollView.contentOffset = CGPointMake(contentY,0);
    }];
}

#pragma mark - 顶部按钮的点击事件
-(void)btnScrollViewContent:(UIButton *)sender
{
    //记录友盟统计模块使用量 @"关注",@"公司群",@"职业群",@"JAVA",@"销售"
    NSDictionary * dict;
    NSString *btnName = [NSString stringWithFormat:@"%@_ELMyGroupCenterCtl",sender.titleLabel.text];
    dict = @{@"Function":btnName};
    [MobClick event:@"buttonClick" attributes:dict];
    
    [listScrollView setContentOffset:CGPointMake(listScrollView.frame.size.width*(sender.tag-100),0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (scrollView == listScrollView){
        NSInteger index = scrollView.contentOffset.x/ScreenWidth;
        CGFloat offSetX = (scrollView.contentOffset.x - (ScreenWidth*index))/1;
        if (offSetX == 0){
            id ctl = ctlViewArr[index];
            if ([ctl isKindOfClass:[ELOwnGroupListCtl class]]){
                ELOwnGroupListCtl *groupCtl = ctl;
                if (!groupCtl.finishRefresh) {
                    [groupCtl refreshLoad];
                }
            }else if ([ctl isKindOfClass:[GroupsChangeTypeCtl class]]){
                GroupsChangeTypeCtl *typeCtl = ctl;
                if (!typeCtl.finishRefresh) {
                    if (!typeCtl.finishBeginLoad) {
                        [typeCtl beginLoad:nil exParam:nil];
                        typeCtl.finishBeginLoad = YES;
                    }else{
                        [typeCtl refreshLoad:nil];
                    }
                }
            }
            [ctl viewWillAppear:NO];
            
            UIButton *btn = btnArr[index];
            if (selectBtn) {
                [selectBtn setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
            }
            [btn setTitleColor:PINGLUNHONG forState:UIControlStateNormal];
            [self changeLineImageFrameWithButton:btn];
             selectBtn = btn;
        }
    }
}

-(void)showPopView{
    tapView.hidden = NO;
    [self.view bringSubviewToFront:tapView];
    isPop_ = YES;
}

-(void)hidePopView{
    tapView.hidden = YES;
    isPop_ = NO;
}

-(void)btnResponse:(id)sender{
    if (sender == moreBtn_){//右上角+号的点击事件
        NSDictionary * dict = @{@"Function":@"rightBarItem(社群_ELMyGroupCenterCtl)"};
        [MobClick event:@"buttonClick" attributes:dict];
        if (isPop_) {
            [self hidePopView];
        }else{
            [self showPopView];
        }
    }else if (sender == zbarBtn_){//右上角弹框中扫码加群点击事件
        NSDictionary * dict = @{@"Function":@"扫码加群_ELMyGroupCenterCtl"};
        [MobClick event:@"buttonClick" attributes:dict];
//        ZBarScanLoginCtl *ctl = [[ZBarScanLoginCtl alloc] init];

        ELScanQRCodeCtl *ctl = [[ELScanQRCodeCtl alloc] init];
        ctl.isZbar = YES;
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        [self hidePopView];
    }else if (sender == createBtn_){//右上角弹框中创建社群点击事件
        NSDictionary * dict = @{@"Function":@"创建社群_ELMyGroupCenterCtl"};
        [MobClick event:@"buttonClick" attributes:dict];
        if (![Manager shareMgr].haveLogin){
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_CreatGroup;
            return;
        }
        NSInteger groupCount = [[Manager shareMgr].groupCount_ integerValue];
        if ([Manager getUserInfo].isExpert_) {
            if (groupCount <= 0) {
                [BaseUIViewController showAlertView:@"行家最多创建5个社群" msg:nil btnTitle:@"确定"];
                return;
            }
        }else{
            if (groupCount <= 0){
                [BaseUIViewController showAlertView:@"普通用户最多创建3个社群" msg:nil btnTitle:@"确定"];
                return;
            }
        }
        [Manager shareMgr].groupCreateCtl_ = [[CreaterGroupCtl alloc] init];
        [Manager shareMgr].groupCreateCtl_.hidesBottomBarWhenPushed = YES;
        [Manager shareMgr].creatGroupStartIndex = self.navigationController.viewControllers.count;
        [Manager shareMgr].groupCreateCtl_.enterType_ = 0;
        [self.navigationController pushViewController:[Manager shareMgr].groupCreateCtl_ animated:YES];
        [[Manager shareMgr].groupCreateCtl_ beginLoad:nil exParam:nil];
        [self hidePopView];
    }
}

#pragma mark - 未登录判断代理方法
-(void)loginDelegateCtl{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_CreatGroup:
        {
            [self btnResponse:createBtn_];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    ELGroupSearchCtl *ctl = [[ELGroupSearchCtl alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    
    switch (selectBtn.tag) {
        case 100:
        {
            ctl.searchFrom = @"mygroup";
        }
            break;
        case 101:
        {
            ctl.searchFrom = @"jingxuan";
        }
            break;
        case 102:
        {
            ctl.searchFrom = @"company";
        }
            break;
        case 103:
        {
            ctl.searchFrom = @"jobs";
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:ctl animated:YES];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBarBtnResponse:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
