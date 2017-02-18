//
//  YLExpertListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/8/14.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLExpertListCtl.h"
#import "ExpertListCtl.h"
#import "ELSameTradeSearchCtl.h"
#import "ELBecomeExpertCtl.h"
#import "ELMyAspectantDiscussCtl.h"
#import "ELExpertCourseListCtl.h"

@interface YLExpertListCtl () <UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIScrollView *contentScrollView;
    
    __weak IBOutlet UIScrollView *listScrollView;
    
    __weak IBOutlet UIImageView *lineImage;
    NSMutableArray *contentDataArr;
    NSMutableArray *ctlViewArr;
    NSMutableArray *btnArr;
    UIButton *selectBtn;
    BOOL isBtnClick;
    ExpertListCtl *expertCtl;
    __weak IBOutlet UISearchBar *searchBar_;
    
    IBOutlet UIView *popView;
    BOOL isShowPopView;
    IBOutlet UIButton *rightMoreBtn;
    
    __weak IBOutlet UIButton *expertBtn;      /**<申请行家 */
    __weak IBOutlet UIButton *interviewBtn;   /**<我的约谈 */
}
@end


@implementation YLExpertListCtl

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        contentDataArr = [[NSMutableArray alloc] init];
        ctlViewArr = [[NSMutableArray alloc] init];
        btnArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *num = [MobClick getConfigParams:@"guide_type_size"];
//    
//    NSString *guideTypeOne = [MobClick getConfigParams:@"guide_type_one"];
//    NSString *guideTypeTwo = [MobClick getConfigParams:@"guide_type_two"];
//    NSString *guideTypeThree = [MobClick getConfigParams:@"guide_type_three"];
//    NSString *guideTypeFour = [MobClick getConfigParams:@"guide_type_four"];
    
//    NSArray *typeArray = [[NSArray alloc] initWithObjects:guideTypeOne, guideTypeTwo, guideTypeThree, guideTypeFour, nil];
    
//    for (NSInteger i = 0; i < [num integerValue]; i++) {
//        NSString *type = [typeArray objectAtIndex:i];
//        [contentDataArr addObject:type];
//    }

    [self setNavTitle:@"行家"];
    
    [contentScrollView addSubview:lineImage];
    CGRect frame = lineImage.frame;
    frame.origin.x = 13;
    frame.origin.y = 30;
    lineImage.frame = frame;
    
// 2016.8.4注释
//    @try {
//        NSString *guideTypeOne = [MobClick getConfigParams:@"job_manager_page"];
//        
//        NSData *jsonData = [guideTypeOne dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
//        
//        for (NSInteger i = 0;i<dic.count; i++) 
//        {
//            NSString *str= dic[[NSString stringWithFormat:@"%ld",(long)i]];
//            [contentDataArr addObject:str];
//        }
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:rightMoreBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
    
    popView.userInteractionEnabled = YES;
    
    if (contentDataArr.count <= 0) {
        [contentDataArr addObjectsFromArray:@[@"职业发展导师",@"职业经纪人"]];
    }
    
    searchBar_.delegate = self;
    [self.view bringSubviewToFront:contentScrollView];
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    if(contentDataArr.count <= 1)
    {
//        listScrollView.bounces = YES;
        
        expertCtl = [[ExpertListCtl alloc] init];
        CGRect rect = [UIScreen mainScreen].bounds;
        
        CGRect frame = listScrollView.frame;
        frame.origin.y = 0;
        frame.size.height = rect.size.height-66-42;
        listScrollView.frame = frame;
        
        frame = expertCtl.view.frame;
        frame.origin.y = 0;
        frame.size.height = rect.size.height-66-42;
        expertCtl.view.frame = frame;
        contentScrollView.hidden = YES;
        [listScrollView addSubview:expertCtl.view];
        [expertCtl beginLoad:nil exParam:nil];
    }
    else
    {
        [self creatView];
    }
    //默认当前选中的tab
    if (_selectedTab && _selectedTab.length > 0) 
    {
        NSInteger index = [contentDataArr indexOfObject:_selectedTab];
        if (index == 0) 
        {
            [self scrollViewDidScroll:listScrollView];
        }
        else
        {
           [listScrollView setContentOffset:CGPointMake(listScrollView.frame.size.width*index,0) animated:YES]; 
        }
    }
    else
    {
        [self scrollViewDidScroll:listScrollView];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view == popView) {
        [self hidePopView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([Manager shareMgr].haveLogin)
    {
        if([Manager getUserInfo].isExpert_)
        {
            [expertBtn setTitle:@"行家特权" forState:UIControlStateNormal];
        }
        else
        {
            [expertBtn setTitle:@"申请行家" forState:UIControlStateNormal];
        }
    }else{
        [expertBtn setTitle:@"申请行家" forState:UIControlStateNormal];
    }
}

-(void)showPopView{
    popView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:popView];
    [self.view bringSubviewToFront:popView];
    isShowPopView = YES;
}

-(void)hidePopView{
    [popView removeFromSuperview];
    isShowPopView = NO;
}



-(void)btnResponse:(id)sender{
    
    NSString *dictStr;
    if (sender == rightMoreBtn) {
        if (isShowPopView) {
            [self hidePopView];
        }else{
            [self showPopView];
        }
    }
    else if (sender == expertBtn)
    {
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_ZhiYeJingJiRenRight;
            [NoLoginPromptCtl getNoLoginManager].button = expertBtn;
            return;
        }
        dictStr = [NSString stringWithFormat:@"%@_%@", @"申请行家", [self class]];
        if ([Manager getUserInfo].isExpert_) {
            ELExpertCourseListCtl *CourseListCtl = [[ELExpertCourseListCtl alloc] init];
            [self.navigationController pushViewController:CourseListCtl animated:YES];
            [CourseListCtl beginLoad:nil exParam:nil];
        }else{
            ELBecomeExpertCtl *becomExpertCtl = [[ELBecomeExpertCtl alloc] init];
            [self.navigationController pushViewController:becomExpertCtl animated:YES];
        }
        [self hidePopView];
    }
    else if (sender == interviewBtn)
    {//我的约谈
        if (![Manager shareMgr].haveLogin)
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_ZhiYeJingJiRenRight;
            [NoLoginPromptCtl getNoLoginManager].button = interviewBtn;
            return;
        }
        dictStr = [NSString stringWithFormat:@"%@_%@", @"我的约谈", [self class]];
        ELMyAspectantDiscussCtl *myAspCtl = [[ELMyAspectantDiscussCtl alloc] init];
        [myAspCtl beginLoad:nil exParam:nil];
        [self.navigationController pushViewController:myAspCtl animated:YES];
        [self hidePopView];
    }
    if (dictStr) {
        //记录友盟统计模块使用量
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
    }
}
#pragma mark - NoLoginDelegate
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_ZhiYeJingJiRenRight:
        {
            [self btnResponse:[NoLoginPromptCtl getNoLoginManager].button]; 
        }
            break;
        default:
            break;
    }
}

-(void)creatView
{
    CGRect frame = listScrollView.frame;
    frame.size.height = ScreenHeight-66-35-42;
    frame.size.width = ScreenWidth;
    listScrollView.frame = frame;
    
    listScrollView.contentSize = CGSizeMake(ScreenWidth*contentDataArr.count,frame.size.height);
//    listScrollView.bounces = YES;
    listScrollView.showsHorizontalScrollIndicator = NO;
    listScrollView.showsVerticalScrollIndicator = NO;
    listScrollView.pagingEnabled = YES;
    listScrollView.delegate = self;
    
    
    contentScrollView.bounces = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    
    contentScrollView.delegate = self;
    
    CGFloat width = 0;
    for (NSInteger i = 0; i < contentDataArr.count ;i++)
    {
        NSString *strName = contentDataArr[i];
        CGSize size = [strName sizeNewWithFont:THIRTEENFONT_CONTENT];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = THIRTEENFONT_CONTENT;
        [btn setTitle:strName forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            [btn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        }
        contentScrollView.contentSize = CGSizeMake(20+((size.width+10)*i),frame.size.height);
        
        btn.frame = CGRectMake(15+width,0,size.width,35);
        width = CGRectGetMaxX(btn.frame);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnScrollViewContent:) forControlEvents:UIControlEventTouchUpInside];
        [contentScrollView addSubview:btn];
        [btnArr addObject:btn];
        
        ExpertListCtl *ctl = [[ExpertListCtl alloc] init];
        
        if ([Manager getUserInfo].isExpert_ || ![strName isEqualToString:@"职业发展导师"])
        {
            ctl.showApplyExpertView = NO;
        }
        else
        {
            ctl.showApplyExpertView = YES;
        }
        
        if ([strName isEqualToString:@"职业发展导师"]) {
            ctl.productType = 1;
        }
        else if([strName isEqualToString:@"职业经纪人"])
        {
             ctl.productType = 2;
        }
        else
        {
            ctl.productType = 0;
        }
        ctl.view.frame = CGRectMake(ScreenWidth*i,0,frame.size.width,listScrollView.frame.size.height);
        [listScrollView addSubview:ctl.view];
        [self addChildViewController:ctl];
        [ctlViewArr addObject:ctl];
//        [ctl beginLoad:nil exParam:nil];
    }
    UIButton *btn = btnArr[0];
//    [ctlViewArr[0] refreshLoad:nil];
    
    CGRect lineFrame = lineImage.frame;
    lineFrame.size.width = btn.frame.size.width;
    
    CGPoint center = lineImage.center;
    center.x = btn.center.x;
    
    CGFloat contentY = 0;
    if (center.x > 160)
    {
        contentY = center.x - 160;
    }
    [UIView animateWithDuration:0.2 animations:^{
        lineImage.frame = lineFrame;
        lineImage.center = center;
        contentScrollView.contentOffset = CGPointMake(contentY,0);
    }];
    selectBtn = btn;
}

-(void)btnScrollViewContent:(UIButton *)sender
{
    //记录友盟统计模块使用量
    NSString *dictStr;
    switch (sender.tag - 100) {
        case 0:
        {
            dictStr = [NSString stringWithFormat:@"%@_%@", @"推荐行家", [self class]];
        }
            break;
        case 1:
        {
            dictStr = [NSString stringWithFormat:@"%@_%@", @"职业发展导师", [self class]];
        }
            break;
        case 2:
        {
            dictStr = [NSString stringWithFormat:@"%@_%@", @"职业经纪人", [self class]];
        }
            break;
        default:
            break;
    }
    if (dictStr.length > 0) {
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
    }
    [listScrollView setContentOffset:CGPointMake(listScrollView.frame.size.width*(sender.tag-100),0) animated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (scrollView == listScrollView)
    {
        NSInteger index = scrollView.contentOffset.x/ScreenWidth;
        CGFloat offSetX = (scrollView.contentOffset.x - (ScreenWidth*index))/1;
        if (offSetX == 0)
        {
            ExpertListCtl *ctl = ctlViewArr[index];
            
            if (!ctl.alreadyRefresh) {
                [ctl beginLoad:nil exParam:nil];
            }
            
            UIButton *btn = btnArr[index];
            if (selectBtn) {
                [selectBtn setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
            }
            [btn setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
            
            CGRect frame = lineImage.frame;
            frame.size.width = btn.frame.size.width;
            
            CGPoint center = lineImage.center;
            center.x = btn.center.x;
            
            CGFloat contentY = 0;
            if (center.x > 1600)
            {
                contentY = center.x - 160;
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                lineImage.frame = frame;
                lineImage.center = center;
                contentScrollView.contentOffset = CGPointMake(contentY,0);
            }];
            
            selectBtn = btn;
            
            if ([selectBtn.titleLabel.text isEqualToString:@"职业发展导师"]) {
                searchBar_.placeholder = @"从职业发展导师中搜索";
            }
            else if ([selectBtn.titleLabel.text isEqualToString:@"职业经纪人"])
            {
                searchBar_.placeholder = @"从职业经纪人中搜索";
            }
            else
            {
                searchBar_.placeholder = @"从所有行家中搜索";
            }
        }
    }
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    ELSameTradeSearchCtl *ctl = [[ELSameTradeSearchCtl alloc] init];
    ctl.getExpertFlag = @"1";
    if ([selectBtn.titleLabel.text isEqualToString:@"职业发展导师"]) {
        ctl.jobType = 2;
    }
    else if ([selectBtn.titleLabel.text isEqualToString:@"职业经纪人"])
    {
        ctl.jobType = 1;
    }
    
    [self.navigationController pushViewController:ctl animated:YES];
    return NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        NSLog(@"ScrollView在滚动");
//        if (listScrollView.contentOffset.x < ScreenWidth) {
//            NSArray *gestureArray = listScrollView.gestureRecognizers;
//            // 当是侧滑手势的时候设置scrollview需要此手势失效即可
//            for (UIGestureRecognizer *gesture in gestureArray) {
//                if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//                    [listScrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
//                    break;
//                }
//            }
//        }

    }else if ([scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"TableView在滚动");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
