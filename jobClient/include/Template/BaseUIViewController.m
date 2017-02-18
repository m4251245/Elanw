//
//  BaseUIViewController.m
//  Template
//
//  Created by sysweal on 13-9-11.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BaseUIViewController ()<UIGestureRecognizerDelegate>
{
    RequestCon *_accessTokenCon;
    NoNetworkVIew *_noNetworkView;
}
@end

@implementation BaseUIViewController

@synthesize comInditify_,requestInditify_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        validateSeconds_ = 0;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

//    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
   

    //设置背景
    if( bInsertBG_ )
        bgImageView_ = [self setBG:[self getBGName]];
    
    //设置导航背景
    if( selfNavBGImageView_ )
       [self setSelfNavBG];
    
    //设置导航条左右按扭
    //左边
    if( myLeftBarBtnItem_ ){
        UIBarButtonItem *leftNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:myLeftBarBtnItem_];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -6;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftNavigationItem];
    }
    //右边
    if( myRightBarBtnItem_ ){
        UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:myRightBarBtnItem_];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -6;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
    }
    //如果给了左边的文字,则不使用返回按扭了
    if( leftNavBarStr_ ){
        leftBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setLeftBarBtnAtt];
        [leftBarBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn_];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                               target:nil action:nil];
            negativeSpacer.width = -10;
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftNavigationItem];
        }else{
            self.navigationItem.leftBarButtonItem = leftNavigationItem;
        }
    }else{
        //采用自定义的返回按扭
        if(!self.navigationItem.hidesBackButton && !myLeftBarBtnItem_)
        {
            backBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
            [backBarBtn_ setExclusiveTouch:YES];
            [backBarBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self setBackBarBtnAtt];
            
            UIView *backBtnView = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,35)];
            [backBtnView addSubview:backBarBtn_];
            backBarBtn_.origin = CGPointMake(0, backBtnView.center.y - backBarBtn_.frame.size.height/2);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
            //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
        }
    }
    
    rightNavBarRightWidth = @"16";
    //如果给了右边的文字
    if( rightNavBarStr_ ){
        rightBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setRightBarBtnAtt];
        [rightBarBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (rightNavBarRightWidth){
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn_];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            NSInteger width = [rightNavBarRightWidth integerValue];
            width = width-20;
            negativeSpacer.width = width;
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
//            self.navigationItem.rightBarButtonItem = buttonItem;
        }else{
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn_];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            NSInteger width = -10;
            negativeSpacer.width = width;
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
        }
    }
    
    //刷新一下界面
    @try {
        [self updateCom:nil];
    }
    @catch (NSException *exception) {
        [MyLog Log:@"updateCom happen error!!!" obj:self];
    }
    @finally {
        
    }
}

- (void)setNavTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake(ScreenWidth/2, self.navigationController.navigationBar.height/2);
    label.bounds = CGRectMake(0, 0, 150, 44);
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

- (void)setNavTitle:(NSString *)title withColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake(ScreenWidth/2, self.navigationController.navigationBar.height/2);
    label.bounds = CGRectMake(0, 0, 150, 44);
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

//根据状态栏调整大小
- (void) viewDidLayoutSubviews {
    @try {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.navigationController.viewControllers.count > 1) {
//        self.navigationController.hidesBottomBarWhenPushed = YES;
//    }
    
    NSLog(@"页面----- %@",self);
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@-%@",[self class],self.title]];
    NSDictionary *dict = @{@"Class" : [NSString stringWithFormat:@"%@_%@",[self class],self.title]};
    [MobClick event:@"new_statistic" attributes:dict];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [requestCon_ stopConnWhenBack];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@-%@",[self class],self.title]];
    //requestCon_.loadStats_ = InterruptLoad;
}

-(void)dealloc
{
    [requestCon_ stopConnWhenBack];
    //requestCon_.loadStats_ = InterruptLoad;
    NSLog(@"释放------ %@",self);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//show alert view(just one btn)
+(void) showAlertView:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle
{
    [self showAlertView:title msg:msg btnTitle:btnTitle delegate:nil];
}

//show alert view(just one btn)
+(void) showAlertView:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg    delegate:delegate
                                          cancelButtonTitle:btnTitle
                                          otherButtonTitles:nil];
    
    //避免冲突
    alert.tag = -1;
    
    [alert show];
}

//让提示框自动消失
+(void) showAutoDismissAlertView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds
{
    [BaseUIViewController showAutoDismissSucessView:title msg:msg seconds:seconds];
}

//让提示框自动消失
+(void) showAutoDisappearAlertView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds
{
    if( seconds < 0 )
    {
        seconds = [CommonConfig getAlertViewReleaseSeconds];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil
                                              cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [BaseUIViewController performSelector:@selector(dimissAlertView:) withObject:alert afterDelay:seconds];
}

//时间到了让提示框消失
+(void) dimissAlertView:(UIAlertView *)alertView
{
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    }
}

//自动消失的操作成功视图
+(void) showAutoDismissSucessView:(NSString *)title msg:(NSString *)msg
{
    if (currentHud) {
        [currentHud hide:NO];
        currentHud = nil;
    }
    if( !title && !msg ){
        title = @"操作成功";
    }
    NSString *content = @"";
    if (title && ![title isEqualToString:@""]){
        content = [content stringByAppendingString:title];
    }
    if (msg && ![msg isEqualToString:@""]) {
        if (content.length > 0) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@",%@",msg]];
        }else{
            content = [content stringByAppendingString:msg];
        }
    }
     [BaseUIViewController showAlertViewContent:content toView:nil second:1.0 animated:YES];
//    [MBProgressHUD showAlertContent:content toView:nil withSecond:1.0 animated:YES];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithTitle:@"" status:@""];
//    [MMProgressHUD dismissWithSuccess:msg title:title afterDelay:1.5];
}
//可设置时间消失的操作成功视图
+(void) showAutoDismissSucessView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds
{
    if (currentHud) {
        [currentHud hide:NO];
        currentHud = nil;
    }
    if( !title && !msg ){
        title = @"操作成功";
    }
    NSString *content = @"";
    if (title && ![title isEqualToString:@""]){
        content = [content stringByAppendingString:title];
    }
    if (msg && ![msg isEqualToString:@""]) {
        if (content.length > 0) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@",%@",msg]];
        }else{
            content = [content stringByAppendingString:msg];
        }
    }
    [BaseUIViewController showAlertViewContent:content toView:nil second:seconds animated:YES];
//    [MBProgressHUD showAlertContent:content toView:nil withSecond:seconds animated:YES];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithTitle:@"" status:@""];
//    [MMProgressHUD dismissWithSuccess:msg title:title afterDelay:seconds];
}

//自动消息的操作失败视图
+(void) showAutoDismissFailView:(NSString *)title msg:(NSString *)msg
{
//    if (currentHud) {
//        [currentHud hide:NO];
//        currentHud = nil;
//    }
    if( !title && !msg ){
        title = @"操作失败";
    }
    NSString *content = @"";
    if (title && ![title isEqualToString:@""]){
        content = [content stringByAppendingString:title];
    }
    if (msg && ![msg isEqualToString:@""]) {
        if (content.length > 0) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@",%@",msg]];
        }else{
            content = [content stringByAppendingString:msg];
        }
    }
    [BaseUIViewController showAlertViewContent:content toView:nil second:1.0 animated:YES];
//    [MBProgressHUD showAlertContent:content toView:nil withSecond:1.0 animated:YES];
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithTitle:@"" status:@""];
//    [MMProgressHUD dismissWithError:msg title:title afterDelay:1.3];
}

//可设置时间自动消息的操作失败视图
+(void) showAutoDismissFailView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds
{
    if (currentHud) {
        [currentHud hide:NO];
        currentHud = nil;
    }
    if( !title && !msg ){
        title = @"操作失败";
    }
    NSString *content = @"";
    if (title && ![title isEqualToString:@""]){
        content = [content stringByAppendingString:title];
    }
    if (msg && ![msg isEqualToString:@""]) {
        if (content.length > 0) {
            content = [content stringByAppendingString:[NSString stringWithFormat:@",%@",msg]];
        }else{
            content = [content stringByAppendingString:msg];
        }
    }
    [BaseUIViewController showAlertViewContent:content toView:nil second:seconds animated:YES];
//    [MBProgressHUD showAlertContent:content toView:nil withSecond:seconds animated:YES];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithTitle:@"" status:@""];
//    [MMProgressHUD dismissWithError:msg title:title afterDelay:seconds];
}

static MBProgressHUD *currentHud;
//显示模态正在加载的视图
+(void) showModalLoadingView:(BOOL)flag title:(NSString *)title status:(NSString *)status
{
    if (currentHud) {
        [currentHud hide:NO];
        currentHud = nil;
    }
    if( flag){
        if(!title){
            title = @"正在加载...";
        }
        currentHud = [MBProgressHUD showProgressContent:title toView:nil animated:YES];
    }
}

+(void)showLoadView:(BOOL)flag content:(NSString *)content view:(UIView *)view{
    if (currentHud) {
        [currentHud hide:NO];
        currentHud = nil;
    }
    if(flag){
        currentHud = [MBProgressHUD showProgressContent:content toView:view animated:YES];
    }
}

+(void)showAlertViewContent:(NSString *)content toView:(UIView *)view second:(CGFloat)second animated:(BOOL)animated{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [MBProgressHUD showAlertContent:content toView:view withSecond:second animated:animated];
    });
} 

//show choose alert view
-(UIAlertView *) showChooseAlertView:(int)type title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:okBtnTitle,cancelBtnTitle,nil];
    alert.tag = type;
	[alert show];
    
    return alert;
}

//alert view choosed
-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed. Type=>%d Index=>%d",index,type] obj:self];
    
    switch ( type ) {
        default:
            break;
    }
}

//alert view choosed cancel
-(void) alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Cancel. Type=>%d Index=>%d",index,type] obj:self];
    
    switch ( type ) {
        default:
            
            break;
    }
}

#pragma mark alertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Cancel. Type=>%ld",(long)alertView.tag] obj:self];
	
	//不起做用
    if( alertView.tag < 0 )
    {
        [MyLog Log:@"Alert View Choosed , But is null, please check it" obj:self];
    }else
    {
        if( buttonIndex == 0 ){
            [self alertViewChoosed:alertView index:buttonIndex type:alertView.tag];
        }else
            [self alertViewCancel:alertView index:buttonIndex type:alertView.tag];
    }
}

//获取背景图片的name
-(NSString *) getBGName
{
    static NSString *bgDefaultName = nil;
    
    if( !bgDefaultName ){
        bgDefaultName = [CommonConfig getValueByKey:@"CtlView_BG" category:@"Resources"];
    }
    
    return bgDefaultName;
}

//获取背景图片的SuperView
-(UIView *) getBGSuperView
{
    return self.view;
}

//设置背景
-(UIImageView *) setBG:(NSString *)bgName
{
    UIImageView *bgImageView = nil;
    UIView *bgSuperView = [self getBGSuperView];
    if( bgName && ![bgName isEqualToString:@""] && bgSuperView ){
        bgImageView = [[UIImageView alloc] initWithFrame:bgSuperView.bounds];
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if( bgType_ == BG_Fill ){
            [bgImageView setImage:[UIImage imageNamed:bgName]];
        }else
            bgImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:bgName]];
        
        [bgSuperView insertSubview:bgImageView atIndex:0];
        
        [MyLog Log:[NSString stringWithFormat:@"setBG OK! name=%@",bgName] obj:self];
    }
    
    return bgImageView;
}

//获取导航背景name
-(NSString *) getSelfNavBGName
{
    static NSString *bgNavDefaultName = nil;
    
    if( !bgNavDefaultName ){
        bgNavDefaultName = [CommonConfig getValueByKey:@"CtlView_Nav_BG" category:@"Resources"];
    }
    
    return bgNavDefaultName;
}

//设置自定义的navBg
-(void) setSelfNavBG{
    NSString *navBGName = [self getSelfNavBGName];
    
    if( navBGName && ![navBGName isEqualToString:@""] )
    {
        selfNavBGImageView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:navBGName]];
        CALayer *layer = selfNavBGImageView_.layer;
        layer.shadowOffset = CGSizeMake(0, 1.5); //设置阴影的偏移量
        layer.shadowRadius = 1.5;  //设置阴影的半径
        layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        layer.shadowOpacity = 0.6; //设置阴影的不透明度
        layer.shadowPath = [UIBezierPath bezierPathWithRect:selfNavBGImageView_.bounds].CGPath;
    }
}

//获取返回按扭的背景
-(NSString *) getBackBarBtnBGName
{
    static NSString *bgNavBackBtnDefaultName = nil;
    
    if( !bgNavBackBtnDefaultName ){
        bgNavBackBtnDefaultName = [CommonConfig getValueByKey:@"CtlView_Nav_BackBtn_BG" category:@"Resources"];
    }
    
    return bgNavBackBtnDefaultName;
}

//获取自定义左按扭的背景
-(NSString *) getLeftBarBtnBGName
{
    static NSString *bgNavLeftBtnDefaultName = nil;
    
    if( !bgNavLeftBtnDefaultName ){
        bgNavLeftBtnDefaultName = [CommonConfig getValueByKey:@"CtlView_Nav_LeftBtn_BG" category:@"Resources"];
    }
    
    return bgNavLeftBtnDefaultName;
}

//获取自定义右按扭的背景
-(NSString *) getRightBarBtnBGName
{
    static NSString *bgNavRightBtnDefaultName = nil;
    
    if( !bgNavRightBtnDefaultName ){
        bgNavRightBtnDefaultName = [CommonConfig getValueByKey:@"CtlView_Nav_RightBtn_BG" category:@"Resources"];
    }
    
    return bgNavRightBtnDefaultName;
}

//设置返回按扭的属性
-(void) setBackBarBtnAtt
{
    if( backBarBtn_ ){
        [backBarBtn_ setTitle:@"" forState:UIControlStateNormal];
        [backBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBarBtn_ setFrame:CGRectMake(0, 0,40,40)];
        backBarBtn_.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];//[UIFont boldSystemFontOfSize:14];
        
        NSString *bgName = [self getBackBarBtnBGName];
        if( bgName && ![bgName isEqualToString:@""] ){
            //[backBarBtn_ setImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
            
            [backBarBtn_ setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
        }
    }
//    if ([[UIDevice currentDevice].systemVersion  floatValue] >= 7.0) {
//        [backBarBtn_ setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
//    }
}

//设置左按扭的属性
-(void) setLeftBarBtnAtt
{
    if( leftBarBtn_ ){
        [leftBarBtn_ setTitle:leftNavBarStr_ forState:UIControlStateNormal];
        [leftBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBarBtn_ setFrame:CGRectMake(0, 0, 30, 30)];
        leftBarBtn_.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];//[UIFont boldSystemFontOfSize:14];
        
        NSString *bgName = [self getLeftBarBtnBGName];
        if( bgName && ![bgName isEqualToString:@""] )
            [leftBarBtn_ setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
    }
    if ([[UIDevice currentDevice].systemVersion  floatValue] >= 7.0) {
        [leftBarBtn_ setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    }

}

//设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:rightNavBarStr_ forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if( [rightNavBarStr_ length] >= 4 ){
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 65, 31)];
    }else
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 50, 31)];
    
    rightBarBtn_.titleLabel.font = [UIFont systemFontOfSize:15];
    
    NSString *bgName = [self getRightBarBtnBGName];
    if( bgName && ![bgName isEqualToString:@""] )
        rightBarBtn_.backgroundColor = [UIColor clearColor];
//        [rightBarBtn_ setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
}

//获取正在加载时所显示的文字
-(NSString *) getLoadingTxt
{
    //sub class can rewreite it
    static NSString *inReloadStr = nil;
    
    if( !inReloadStr ){
        inReloadStr = [CommonConfig getValueByKey:@"ReLoad_Text" category:@"Data"];
    }
    
    return inReloadStr;
}

//获取异常视图的父视图
-(UIView *) getErrorSuperView
{
    return self.view;
}

//获取异常视图
-(UIView *) getErrorView
{
    if( !_noNetworkView ){
        _noNetworkView = [[NoNetworkVIew alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    }
    return _noNetworkView;
}

//获取正在加载视图的父视图
-(UIView *) getLoadingSuperView
{
    return self.view;
}

//获取正在加载视图
-(UIView *) getLoadingView
{
    if( !inLoadingCtl_ ){
        inLoadingCtl_ = [[InLoadingCtl alloc] init];
    }
    
    return inLoadingCtl_.view;
}

//显示加载出错的视图
-(void) showErrorView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showErrorView flag=%d",flag] obj:self];
    
    if( [RequestCon getRequestStr:requestCon_.requestType_] ){
        return;
    }
    
    //显示
    if( flag ){
        UIView *superView = [self getErrorSuperView];
        UIView *myView = [self getErrorView];
        
        if( superView && myView ){
			[myView removeFromSuperview];
			[superView addSubview:myView];
            
            if(_noNetworkView == myView ) {
                _noNetworkView.tipStr = [ErrorInfo getErrorMsg:requestCon_.errorCode_];
            }
            
			//set the rect
			CGRect rect = myView.frame;
			rect.origin.x = (int)((superView.frame.size.width - rect.size.width)/2.0);
			rect.origin.y = (int)((superView.frame.size.height - rect.size.height)/2.0);
			[myView setFrame:rect];
        }else{
            [MyLog Log:@"error view's super view or error view is null" obj:self];
        }
    }
    //不显示
    else{
        [[self getErrorView] removeFromSuperview];
    }
}

//显示正在加载的视图
-(void) showLoadingView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showLoadingView flag=%d",flag] obj:self];
    
    if( [RequestCon getRequestStr:requestCon_.requestType_] ){
        return;
    }
    
    //显示
    if( flag ){
        UIView *superView = [self getLoadingSuperView];
        UIView *myView = [self getLoadingView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            NSString *loadingStr = [self getLoadingTxt];
            if( myView == inLoadingCtl_.view ){
                if( loadingStr ){
                    inLoadingCtl_.txtLb_.text = loadingStr;
                }else
                    inLoadingCtl_.txtLb_.text = @"";
            }
            
            //set the rect
            CGRect rect = myView.frame;
			rect.origin.x = (int)((superView.frame.size.width - rect.size.width)/2.0);
			rect.origin.y = (int)((superView.frame.size.height - rect.size.height)/2.0);
			[myView setFrame:rect];
        }else{
            [MyLog Log:@"loading view's super view or loading view is null" obj:self];
        }
    }
    //不显示
    else{
        [[self getLoadingView] removeFromSuperview];
    }
}

//刷新界面
-(void) updateCom:(RequestCon *)con
{
    [MyLog Log:@"updateCom..." obj:self];
    
    //如果自定义的title存在
    if( titleBarLb_ ){
        titleBarLb_.text = self.title;
    }
    
//    @try {
//        [self updateLoadingCom:con];
//    }
//    @catch (NSException *exception) {
//        [MyLog Log:@"updateLoadingCom happen error!!!" obj:self];
//    }
//    @finally {
//        
//    }
}

//刷新一下加载界面
-(void) updateLoadingCom:(RequestCon *)con
{
    if( (!con || con == requestCon_) && requestCon_ ){
        [MyLog Log:@"updateLoadingCom..." obj:self];
        
        switch ( requestCon_.loadStats_ ) {
                //加载完成
            case FinishLoad:
            {
                [self showLoadingView:NO];
                [self showErrorView:NO];
            }
                break;
                //加载出错
            case ErrorLoad:
            {
                [self showLoadingView:NO];
                [self showErrorView:YES];
            }
                break;
                //正在加载
            case InReload:
            {
                [self showLoadingView:YES];
                [self showErrorView:NO];
            }
                break;
                //正在加载更多
            case InLoadMore:
            {
                //不用处理
            }
                break;
            case InterruptLoad:
            {
                [self showLoadingView:NO];
                [self showErrorView:NO];
            }
                break;
            default:
                break;
        }
    }
}

//获取某个连接的数据有效期
-(long) getRequestConValidateSeconds:(RequestCon *)con
{
    if( con == requestCon_ ){
        return validateSeconds_;
    }
    
    return 0;
}

//获取一个请求类(validateSeconds数据有效期)
-(RequestCon *) getNewRequestCon:(BOOL)bDefault
{
    RequestCon *con = [[RequestCon alloc] init];
    if( bDefault ){
        requestCon_ = con;
    }
    
    con.validateSeconds_ = [self getRequestConValidateSeconds:con];
    con.delegate_ = self;
        
    return con;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self setExclusiveTouchForButtons:self.view];
}


//开始加载数据
-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    [MyLog Log:@"beginLoad..." obj:self];
    
    [self performSelector:@selector(realLoad:) withObject:[NSString stringWithFormat:@"%@+%@",dataModal,exParam] afterDelay:0.2];
}

//私有方法,用于延迟加载
-(void) realLoad:(NSString *)inditify{
    //如果请求还未初始化，则获取一个
    if( requestCon_ == NULL ){
        requestCon_ = [self getNewRequestCon:YES];
    }
    requestCon_.delegate_ = self;
    //set requestInditify_
    self.requestInditify_ = inditify;
    
    //开始加载
    [self startLoad:requestCon_];
    
    if( !self.comInditify_ || ![self.comInditify_ isEqualToString:inditify] ){
        //刷新一下界面
        @try {
            [self updateCom:nil];
        }
        @catch (NSException *exception) {
            [MyLog Log:@"updateCom happen error!!!" obj:self];
        }
        @finally {
            
        }
    }
    
    //set conInditify
    self.comInditify_ = inditify;
}

//开始请求
-(void) startLoad:(RequestCon *)con
{
    [self getDataFunction:con];
}

//刷新加载
-(void) refreshLoad:(RequestCon *)con
{
    [MyLog Log:@"refreshLoad..." obj:self];
    
    //如果请求还未初化，则获取一个
    if( requestCon_ == NULL ){
        requestCon_ = [self getNewRequestCon:YES];
    }
    requestCon_.delegate_ = self;
    [requestCon_ setFresh:YES];
    [self startLoad:requestCon_];
    [requestCon_ setFresh:NO];
}

//加载数据的方法
-(void) getDataFunction:(RequestCon *)con
{
    [MyLog Log:@"please rewrite getDataFunction..." obj:self];
}

//error get data
-(void) errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [MyLog Log:@"errorGetData, I'll handle it, If you want to process it , you can rewrite this function" obj:self];
//    NSString *loadStr = [RequestCon getRequestStr:requestCon.requestType_];
    [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
//    if( loadStr ){
//        NSString *title = [NSString stringWithFormat:@"%@失败",loadStr];
//        NSString *msg = [ErrorInfo getErrorMsg:code];
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//             [BaseUIViewController showAutoDismissFailView:title msg:msg];
//        });
//    }
}

//finish get data
-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [MyLog Log:@"finishGetData" obj:self];
    [BaseUIViewController showModalLoadingView:NO title:nil status:nil];
}

/*
#pragma ErrorCtlDelegate
-(void) reloadData:(ErrorCtl *)ctl sender:(id)sender
{
    [self startLoad:requestCon_];
}
*/
 
#pragma LoadDataDelegate
-(NSString *) getRequestInditify:(RequestCon *)con
{
    return self.requestInditify_;
}

-(void) dataChanged:(RequestCon *)con
{
    [MyLog Log:[NSString stringWithFormat:@"con<%@> dataChanged",con] obj:self];
}

-(void) loadDataBegin:(RequestCon *)con requestType:(int)type
{
    [MyLog Log:@"loadDataBegin" obj:self];
    
    //如果请求含有字符串,则代表需要显示模态加载Loading界面
    NSString *loadingStr = [RequestCon getRequestStr:type];
    if( loadingStr ){
        loadingStr = [NSString stringWithFormat:@"%@",loadingStr];
        [BaseUIViewController showModalLoadingView:YES title:loadingStr status:nil];
    }
    
    if( con == requestCon_ ){
        @try {
            [self updateLoadingCom:con];
        }
        @catch (NSException *exception) {
            [MyLog Log:@"updateLoadingCom happen error!!!" obj:self];
        }
        @finally {
            
        }
    }
}

-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    //如果请求中的被中断者存在,需要恢复中断了
    if(con && con.conBeInterrupt_ ){
        //将安全凭证取出来
        AccessToken_DataModal *dataModal = nil;
        @try {
            dataModal = [dataArr objectAtIndex:0];
            if( dataModal.accessToken_ && dataModal.sercet_ ){
                
                [Manager shareMgr].accessTokenModal = dataModal;
                //accessTokenModal.lastDate_ = [NSDate date];
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
            //恢复到中断点
            [con.conBeInterrupt_ dataConnRecover:dataModal.sercet_ token:dataModal.accessToken_];
            con.conBeInterrupt_ = nil;
        }
        return;
    }
    //如果数据解发生了错误,则将accessTokenModal赋空(requestType_=0代表是图片的加载)
    if( code >= Fail && type != 0 &&!con.bUploadFile_ ){
//        [Manager shareMgr].accessTokenModal = nil;
    }
    //NSLog(@"code=%d type=%d %d",code,type,!con.bUploadFileCallBack_);
    //如果请求含有字符串,则代表需要取消正在显示的模态加载Loading界面
    NSString *loadingStr = [RequestCon getRequestStr:type];
    if( loadingStr )
        [BaseUIViewController showModalLoadingView:YES title:nil status:nil];
    @try {
        NSInteger cnt = 0;
        if( dataArr ){
            cnt = [dataArr count];
        }
        [MyLog Log:[NSString stringWithFormat:@"loadDataComplete code=%d dataArrCnt=%ld",code,(long)cnt] obj:self];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    @try {
        if( code >= Fail ){
            [self errorGetData:con code:code type:type];
        }else{
            [self finishGetData:con code:code type:type dataArr:dataArr];
        }
    }
    @catch (NSException *exception) {
        [MyLog Log:[NSString stringWithFormat:@"handle loadDataComplete happen error!!!"] obj:self];
    }
    @finally {
        //刷新一下界面
        @try {
            [self updateCom:con];
        }
        @catch (NSException *exception) {
            [MyLog Log:@"updateCom happen error!!!" obj:self];
        }
        @finally {
            
        }
        
        //刷新加载界面
        @try {
            [self updateLoadingCom:con];
        }
        @catch (NSException *exception) {
            [MyLog Log:@"updateLoadingCom happen error!!!" obj:self];
        }
        @finally {
            
        }
    }
}

//request should be interrupt
-(BOOL) dataConnShouldInterrupt:(RequestCon *)con aciton:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method
{
    //return NO;
    
    BOOL flag = NO;
    if( con.conBeInterrupt_ ){
        flag = NO;
    }else if( ![Manager shareMgr].accessTokenModal ){
        flag = YES;
    }
    else if (con.bUploadFileCallBack_)
    {
        flag = YES;
    }
//    //安全凭证的有效期已经过了(12个小时)
//    else if( [[NSDate date] timeIntervalSinceDate:accessTokenModal.lastDate_] > 12*3600 ){
//        flag = YES;
//    }
    
    if( flag ){
        [MyLog Log:@"dataConnShouldInterrupt is true" obj:self];
        
        con.bInterrupt_ = flag;
        
        //去请求安全凭证
        _accessTokenCon = [self getNewRequestCon:NO];
        _accessTokenCon.conBeInterrupt_ = con;
        [_accessTokenCon getAccessToken:WebService_User pwd:WebService_Pwd time:[NSDate timeIntervalSinceReferenceDate]];
    }else{
        con.bInterrupt_ = flag;
    }
    
    return flag;
}

//判断是否需要响应事件
-(BOOL) canBtnResponse:(id)sender
{
    [MyLog Log:@"check btn need response, default value is true" obj:self];
    
    return YES;
}

//返回按扭点击的响应事件
-(void) backBarBtnResponse:(id)sender{
    [MyLog Log:@"back bar btn response" obj:self];
    if (requestCon_.loadStats_ == InReload || requestCon_.loadStats_ == InLoadMore) {
        requestCon_.loadStats_ = InterruptLoad;
        [requestCon_ stopConn];
    }
    [ELRequest cancelAllRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

//左按扭点击的响应事件
-(void) leftBarBtnResponse:(id)sender{
    [MyLog Log:@"left bar btn response" obj:self];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self haveDismiss];
    }];
}

//已经完全dismiss了
-(void) haveDismiss
{
    [MyLog Log:@"haveDismiss, you can do something here" obj:self];
}

//右按扭点击的响应事件
-(void) rightBarBtnResponse:(id)sender{
    
}

//其它按扭的点击事件
-(void) btnResponse:(id)sender
{
    [MyLog Log:@"btnResponse, you can do what you want to do here" obj:self];
}

//按扭事件
-(IBAction) btnClick:(id)sender
{
    [MyLog Log:@"button clicked!" obj:self];

    if( sender == backBarBtn_ || sender == selfBackBtn_ ){
        [self backBarBtnResponse:sender];
    }else if( sender == leftBarBtn_ ){
        [self leftBarBtnResponse:sender];
    }else if( sender == rightBarBtn_ ){
        [self rightBarBtnResponse:sender];
    }else{
        //检测一下是否可以响应
        if( [self canBtnResponse:sender] )
            [self btnResponse:sender];
    }
}


//设置页面上的按钮无法同时点击
-(void)setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * v in [myView subviews]) {
        if([v isKindOfClass:[UIButton class]])
            [((UIButton *)v) setExclusiveTouch:YES];
        else if ([v isKindOfClass:[UIView class]]){
            [self setExclusiveTouchForButtons:v];
        }

    }

}


//获取ip的线程
-(void) getIP
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@""];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@",ip);
}

@end
