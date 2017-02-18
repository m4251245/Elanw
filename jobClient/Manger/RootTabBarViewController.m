//
//  RootTabBarViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "MessageCenterList.h"
#import "MyJobSearchCtl.h"
#import "TodayFocusListCtl.h"
#import "MyManagermentCenterCtl.h"
#import "ELMyGroupCenterCtl.h"
#import "TabBarView.h"
#import "RootNavigationController.h"
#import "MyJobGuideCtl.h"

@interface RootTabBarViewController ()<TabBarDelegate>{
    TabBarView *myTabBar;
    NSArray *tabCtlArr;
}

@property(nonatomic,assign)CGFloat tabBarHeight;
@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self registerNotify];
}

#pragma mark--配置UI
-(void)configUI{
//消息
    RootNavigationController *msgVC = [[RootNavigationController alloc]initWithRootViewController:[[MessageCenterList alloc]init]];
    
//职位
    MyJobSearchCtl *jobSearch = [[MyJobSearchCtl alloc]init];
    RootNavigationController *jobSearchVC = [[RootNavigationController alloc]initWithRootViewController:jobSearch];
//我
    MyManagermentCenterCtl *manager = [[MyManagermentCenterCtl alloc]init];
    RootNavigationController *managerMyVC = [[RootNavigationController alloc]initWithRootViewController:manager];
//今日看点
    TodayFocusListCtl *today = [[TodayFocusListCtl alloc]init];
    RootNavigationController *todayVC = [[RootNavigationController alloc]initWithRootViewController:today];
//社群
    MyJobGuideCtl *jobGuide = [[MyJobGuideCtl alloc] init];
    RootNavigationController *myGuideVC = [[RootNavigationController alloc]initWithRootViewController:jobGuide];
    
    
    self.viewControllers = @[todayVC,myGuideVC,jobSearchVC,msgVC,managerMyVC];
    tabCtlArr = @[todayVC,myGuideVC,jobSearchVC,msgVC,managerMyVC];
    [Manager shareMgr].centerNav_ = tabCtlArr[0];
    [self configTabBar];
}
//配置tabbar
-(void)configTabBar{
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    myTabBar = [[TabBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49) controllersNum:5];
    [self.tabBar addSubview:myTabBar];
    self.tabBarView = myTabBar;
    myTabBar.delegate = self;
    [self setTabBarLine];
}
//配置tabbar顶部线条
-(void)setTabBarLine
{
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xe0e0e0);
    [myTabBar addSubview:lineLabel];
}


#pragma mark--事件

-(void)buttonSelectedClick:(UIButton *)button{
    NSInteger index = button.tag-1000;
    [self showControllerIndex:index];
}

/**
 *  切换显示控制器
 *
 *  @param index 位置
 */
-(void)showControllerIndex:(NSInteger)index
{
    if(index < 0 || index > 4){
        return;
    }
    self.seleBtn.selected = NO;
    UIButton *button = (UIButton *)[myTabBar viewWithTag:1000+index];
    button.selected = YES;
    self.seleBtn = button;
    self.selectedIndex = index;
    [Manager shareMgr].centerNav_ = tabCtlArr[index];
}

#pragma mark--通知
/**
 *  tabbar上面消息红点提示
 */
-(void)registerNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numMsgShow:) name:@"msgNewsNum" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numMyManagerShow:) name:@"myManagerNum" object:Nil];
}
//消息 红点
-(void)numMsgShow:(NSNotification *)notify{
    NSLog(@"----------------%@",kAllNums);
    NSInteger allNumber = [getUserDefaults(kAllNums) integerValue];
    [myTabBar showBadgeMark:allNumber index:3];
   
    
    //DISPATCH_QUEUE_PRIORITY_DEFAULT
}
//我的 红点
-(void)numMyManagerShow:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    NSInteger otherAllNum = [dic[@"num"] integerValue];
    NSInteger oaNum = [dic[@"oaNum"] integerValue];
    if (otherAllNum > 0) {
        [myTabBar showBadgeMark:otherAllNum index:4];
    }
    else{
        [myTabBar showPointMark:oaNum Index:4];
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    for (NSInteger i=0;i<5;i++) {
        UIButton *button = (UIButton *)[myTabBar viewWithTag:1000+i];
        button.selected = NO;
    }
    super.selectedIndex = selectedIndex;
    UIButton *button = (UIButton *)[myTabBar viewWithTag:1000+selectedIndex];
    button.selected = YES;
    self.seleBtn = button;
    [Manager shareMgr].centerNav_ = tabCtlArr[selectedIndex];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
