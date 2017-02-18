//
//  PrestigeController.m
//  jobClient
//
//  Created by 一览iOS on 15-2-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyOfferPartyIndexCtl.h"
//#import "ZBarScanLoginCtl.h"
#import "ELOfferMianView.h"
#import "ELNewOfferListCtl.h"
#import "ELAboutOfferPartyCtl.h"
#import "ELOfferPartyGroupsCtl.h"

@interface MyOfferPartyIndexCtl ()<NoLoginDelegate>
{
    __weak IBOutlet UIImageView *_adImg;
    ELOfferMianView *offerMianView;
    NSInteger currentListTag;
    
    BOOL showKeyBoard;
    
    NSArray *_controllerArr;
}

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@end

@implementation MyOfferPartyIndexCtl

-(id)init
{
    if (self = [super init]) {
        bFooterEgo_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavTitle:@"offer派"];
    [self addNotify];
    [_adImg sd_setImageWithURL:[NSURL URLWithString:@"http://img105.job1001.com/upload/adminnew/2015-08-05/1438763443-PV6SCVE.png"] placeholderImage:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([NoLoginPromptCtl getNoLoginManager].loginType > 0) {
        [self performSelector:@selector(refresh:) withObject:nil afterDelay:1.f];
    }
}

- (void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:nil exParam:nil];

}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SignInOfferParty://签到结果
        {
            Status_DataModal *model = dataArr[0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [self.navigationController popViewControllerAnimated:NO];
                [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
                
                OfferPartyDetailIndexCtl *offerPartyDetailCtl = [[OfferPartyDetailIndexCtl alloc]init];
                OfferPartyTalentsModel * offerPartyModel = [[OfferPartyTalentsModel alloc]init];
                offerPartyModel.jobfair_id = _offerPartyId;
                offerPartyModel.iscome = YES;
                offerPartyModel.isjoin = YES;
                offerPartyDetailCtl.offerPartyModel = offerPartyModel;
                offerPartyDetailCtl.isFromZbar = YES;
                [ self.navigationController pushViewController:offerPartyDetailCtl animated:YES];
                [offerPartyDetailCtl beginLoad:nil exParam:nil];
                [self refresh:nil];
                
                NSString *date = [[NSDate date] stringWithFormat:@"YYYY-MM-dd hh:mm:ss"];
                [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"offerpaiSignDate"];

            }else{
                [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
            }
        }
            
        default:
            break;
    }
}

#pragma mark--代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat tabOffsetY = [tableView_ rectForSection:0].origin.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (yOffset >= tabOffsetY) {//顶部
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;//不让底部的table动，只让当前列表动
    }else{//不在顶部
        _isTopIsCanNotMoveTabView = NO;
    }
    
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {//不在顶部
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //滑动到顶端
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            tableView_.showsVerticalScrollIndicator = NO;
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //离开顶端
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                tableView_.showsVerticalScrollIndicator = YES;
            }
        }
    }
    
    tableView_.showsVerticalScrollIndicator = NO;
}

#pragma mark - UITableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"systemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.contentView addSubview:[self configMianView]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight;
}

- (UIView *)configMianView
{
    ELNewOfferListCtl *newestVC = [[ELNewOfferListCtl alloc] init];
    ELNewOfferListCtl *beforVC = [[ELNewOfferListCtl alloc] init];
    ELNewOfferListCtl *signInVC = [[ELNewOfferListCtl alloc] init];
    ELOfferPartyGroupsCtl *groupVC = [[ELOfferPartyGroupsCtl alloc] init];
    ELAboutOfferPartyCtl *aboutVC = [[ELAboutOfferPartyCtl alloc] init];
    _controllerArr = [NSArray arrayWithObjects:newestVC, beforVC, signInVC, groupVC, aboutVC, nil];
    
    NSArray *titleArray =@[@"最近", @"往期", @"已报名", @"社群", @"关于"];
    
    if (!offerMianView) {
        offerMianView = [[ELOfferMianView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) TitleArr:titleArray Controllers:_controllerArr ParentController:self];
        offerMianView.isFromHome = _isFromHome;
    }
    
    return offerMianView;
}

#pragma mark - 事件
- (IBAction)rightBtnClick:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_OfferRightZbar;
        return;
    }
    
//    ZBarScanLoginCtl *scanCtl = [[ZBarScanLoginCtl alloc]init];
    ELScanQRCodeCtl *scanCtl = [[ELScanQRCodeCtl alloc] init];
    __weak typeof(MyOfferPartyIndexCtl) *weakSelf = self;
    scanCtl.scanResultBlock = ^(NSString *result){
        NSLog(@"%@", result);
        if (!weakSelf.signInCon) {
            weakSelf.signInCon = [self getNewRequestCon:NO];
        }
        if (!result) {
            return ;
        }
        _offerPartyId = result;
        NSString *userId = [Manager getUserInfo].userId_;
        if (!userId) {
            return;
        }
        [weakSelf.signInCon signInOfferPartyId:result userId:userId roleId:userId role:@"10"];
    };
    [self.navigationController pushViewController:scanCtl animated:YES];
}

#pragma mark--通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"selectVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPullDownRefresh:) name:@"stopPullDownRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

-(void)notify:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"leaveTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
        }
    }
    else if ([notification.name isEqualToString:@"selectVC"])
    {
        UIButton *btn = notification.object;
        currentListTag = btn.tag - 50;
        
//        if (currentListTag < 3) {
//            //offer派列表刷新
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadOfferData" object:btn userInfo:nil];
//        }
//        else if (currentListTag == 3)
//        {//社群
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadGroupsData" object:btn userInfo:nil];
//        }
    }
}

-(void)keyBoardShow:(NSNotification *)notification
{
    NSLog(@"-------keyBoardShow---------");
    showKeyBoard = YES;
    if (!_isTopIsCanNotMoveTabView) {
        tableView_.contentOffset = CGPointMake(0, tableView_.tableHeaderView.frame.size.height);
    }
}
 
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshLoad:(RequestCon *)con
{
    if (currentListTag < 3) {
        //offer派列表刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:[NSString stringWithFormat:@"%ld", (long)currentListTag] userInfo:nil];
        ELNewOfferListCtl *offerlistCtl = [_controllerArr objectAtIndex:currentListTag];
        [offerlistCtl refreshLoad];
    }
    else if (currentListTag == 3)
    {//社群
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil userInfo:nil];
    }
    else
    {//关于
        [self doneLoadingTableViewData:refreshHeaderView_];
    }
}

- (void)stopPullDownRefresh:(NSNotification *)notify
{
    [self doneLoadingTableViewData:refreshHeaderView_];
}

- (void)refresh:(RequestCon *)request
{
    [self refreshLoad:nil];
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_OfferRightZbar:
        {
            [self rightBtnClick:nil];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
