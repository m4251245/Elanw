//
//  PreBaseUIViewController.m
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PreBaseUIViewController.h"
//#import "ManagerCtl.h"
#import "DataManger.h"
//#import "BaiduMobStat.h"
#import "BaseUIViewController.h"

//DB
PreMyDataBase *myDB;

//show loading con
PreRequestCon *currentShowLoadingCon;

@implementation PreBaseUIViewController

@synthesize searchBar_,searchBtn_,cancelSearchView_,leftBarItemStr_,PreRequestCon_,loadStats_,interruptId_,interruptIndex_,interruptSel_,rightBarItemStr_;

- (void)dealloc
{
    NSLog(@"释放--- %@",self);
}

-(id) init
{
    if (self = [super init]) {
        if( !PreRequestCon_ ){
            PreRequestCon_ = [[PreRequestCon alloc] init];
            PreRequestCon_.delegate_ = self;
        }
        
        loadStats_ = FinishLoad;
        interruptIndex_ = -1;
        bPreRequestCon_ = YES;
    }
	return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) ) {
        
    }
	
	if( !PreRequestCon_ ){
		PreRequestCon_ = [[PreRequestCon alloc] init];
        PreRequestCon_.delegate_ = self;
	}
	
	loadStats_ = FinishLoad;
    interruptIndex_ = -1;
    bPreRequestCon_ = YES;
    
    if( !myDB ){
        myDB = [[PreMyDataBase alloc] init];
    }
	
    return self;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarController.tabBar.hidden = YES;
	//init res
	[self initResources];
    
    //set bg
    bgView_ = [self setBG:[self getBGName]];
    
    //set searchBar's delegate
    searchBar_.delegate = self;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    //set searchBar BG
    [self setSearchBarBG:[PreCommonConfig getSearchBarBgName]];
    
    //returnInterrupt
    [self returnInterrupt];
    
    //初始化导航左右按扭
    if( leftBarItemStr_ )
    {
        leftBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBarBtn_ setTitle:leftBarItemStr_ forState:UIControlStateNormal];
        [leftBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBarBtn_ setFrame:CGRectMake(0, 0, 60, 44)];
        [leftBarBtn_.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:12]];
        [leftBarBtn_.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [leftBarBtn_ addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBarItem_ = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn_];
        self.navigationItem.leftBarButtonItem = leftBarItem_;
    }else{
        if( !self.navigationItem.hidesBackButton ){
            //设置返回按扭
            backBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
            [backBarBtn_ setTitle:@"" forState:UIControlStateNormal];
            [backBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backBarBtn_ setFrame:CGRectMake(0, 0, 30, 30)];
            backBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [backBarBtn_ setImage:[UIImage imageNamed:@"back_white_new.png"] forState:UIControlStateNormal];
//            [backBarBtn_ setBackgroundImage:[UIImage imageNamed:@"back_white_new.png"] forState:UIControlStateHighlighted];
            [backBarBtn_ addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//            backBarItem_ = [[UIBarButtonItem alloc] initWithCustomView:backBarBtn_];
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarBtn_];
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            NSInteger width = -10;
            negativeSpacer.width = width;
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
            
//            self.navigationItem.leftBarButtonItem = backBarItem_;
        }
    }
    
    
    if( rightBarItemStr_ )
    {
        rightBarBtn_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBarBtn_ setTitle:rightBarItemStr_ forState:UIControlStateNormal];
        [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBarBtn_.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-light" size:14]];
        [rightBarBtn_.titleLabel setTextAlignment:NSTextAlignmentRight];
        if( [rightBarItemStr_ length] == 4 ){
            [rightBarBtn_ setFrame:CGRectMake(0, 0, 60, 44)];
        }else
            [rightBarBtn_ setFrame:CGRectMake(0, 0, 45, 31)];
        [rightBarBtn_ addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn_];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        NSInteger width = -10;
        negativeSpacer.width = width;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
//        rightBarItem_ = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn_];
//        self.navigationItem.rightBarButtonItem = rightBarItem_;
    }
    
    //update com info
    [self updateComInfo:nil];
}

-(BOOL) isViewLoaded
{
    BOOL flag = [super isViewLoaded];
    
    if( flag && bNeedUpdateComInfo_ ){
        
        
    	//update com info
        [self updateComInfo:nil];
    }
    
    return flag;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
    
    //[DataManger clearDataToIndex:10];
}


//让提示框自动消失
+(void) showAutoLoadingView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds
{
    [BaseUIViewController showAutoDismissAlertView:title msg:msg seconds:2.0];
    return;
    
    if( seconds < 0 )
    {
        seconds = [PreCommonConfig getAlertViewReleaseSeconds];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil 
                                          cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    [PreBaseUIViewController performSelector:@selector(dimissAlertView:) withObject:alert afterDelay:seconds];
}

//时间到了让提示框消失
+(void) dimissAlertView:(UIAlertView *)alertView
{
    if(alertView)
    {
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    }
}

//show/hide loading view
+(void) showLoadingView:(BOOL)flag title:(NSString *)title
{
    [BaseUIViewController showModalLoadingView:flag title:title status:@"请稍候"];
    return;
    
    static UIActivityIndicatorView *activityIndicatorView;
    static UIAlertView *loadingAlertView;
    if( !activityIndicatorView ){
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.alpha = 1.0;
        [activityIndicatorView startAnimating];
    }

    if( flag && title ){
        [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
        loadingAlertView = nil;
        loadingAlertView= [[UIAlertView alloc] initWithTitle:title message:@"\n"    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil];
        [loadingAlertView show];
        
        //加入activityIndicatorView
        [loadingAlertView addSubview:activityIndicatorView];
        
        //改变大小，位置
        CGRect myRect = activityIndicatorView.frame;
        myRect.origin.x = 122;
        myRect.origin.y = 58;
        [activityIndicatorView setFrame:myRect];
    }else
    {
        [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
        loadingAlertView = nil;
        [activityIndicatorView removeFromSuperview];
    }
}

//show alert view(just one btn)
+(void) showAlertView:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle
{
//	static UIAlertView *alert = nil;
//	if( alert ){
//		[alert release];
//	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg    delegate:nil 
                                          cancelButtonTitle:btnTitle
                                          otherButtonTitles:nil];
    [alert show];
}

//显示
-(void) show
{
    self.view.alpha = 1.0;
}

//隐藏
-(void) hide
{
    self.view.alpha = 0.0;
}

//打电话
-(void) giveCall:(NSString *)number
{
    if( !number || [number isEqualToString:@""] )
    {
        [PreBaseUIViewController showAlertView:nil msg:@"电话号码错误,暂无法拔打该电话" btnTitle:@"关闭"];
        return;
    }
    //去除电话中的"("与")"与"-"等符号
    NSMutableString *phoneNum = [[NSMutableString alloc] initWithString:[[number componentsSeparatedByString:@","] objectAtIndex:0]];
    
    NSRange rang;
    rang.length = [phoneNum length];
    rang.location = 0;
    [phoneNum replaceOccurrencesOfString:@"(" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [phoneNum length];
    rang.location = 0;
    [phoneNum replaceOccurrencesOfString:@")" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    rang.length = [phoneNum length];
    rang.location = 0;
    [phoneNum replaceOccurrencesOfString:@"-" withString:@"" options:NSUTF8StringEncoding range:rang];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
}

//获取显示loading时的text
-(NSString *) getLoadingText:(PreRequestCon *)con type:(XMLParserType)type
{
    NSString *text = nil;
    if( (text = [PreRequestCon getRequestStr:type]) ){
        text = [NSString stringWithFormat:@"正在%@",text];
    }
    
    return text;
}

//更改背景
-(void) changeBG:(NSString *)imageName
{
    if( imageName && ![imageName isEqualToString:@""] )
    {
        [bgView_ setImage:[UIImage imageNamed:imageName]];
    }
}

//获取背景图片的name
-(NSString *) getBGName
{
    return [PreCommonConfig getBgName];
}

//设置背景
-(UIImageView *) setBG:(NSString *)imageName
{
    UIImageView *bgImageView = nil;
    if( imageName && ![imageName isEqualToString:@""] ){
        bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [bgImageView setImage:[UIImage imageNamed:imageName]];
        [self.view insertSubview:bgImageView atIndex:0];
    }
    
    return bgImageView;
}

//设置searchBar BG
-(UIImageView *) setSearchBarBG:(NSString *)imageName
{
    UIImageView *searchBarBG = nil;
    
//    //更改searchBar的变景
//    if( searchBar_ && imageName && ![imageName isEqualToString:@""] )
//    {
//        searchBarBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//        searchBarBG.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        CGRect searchBarRect = searchBar_.frame;
//        searchBarRect.origin.x = 0;
//        searchBarRect.origin.y = 0;
//        [searchBarBG setFrame:searchBarRect];
//        [searchBar_ insertSubview:searchBarBG atIndex:1];
//    }
    
    return searchBarBG;
}

//show choose alert view
-(void) showChooseAlertView:(ChooseAlertViewType)type title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:okBtnTitle,cancelBtnTitle,nil];
    alert.tag = type;
	[alert show];
}

//show/hide cancel searchBarView
-(void) showCancelSearchBarView:(BOOL)flag animated:(BOOL)animated
{
    bShowCancelView_ = flag;
    
    if( searchBar_ ){
        if( flag ){
            [cancelSearchView_ removeFromSuperview];
            [self.view addSubview:cancelSearchView_];
            
            //cancelSearchView_.backgroundColor = [UIColor blackColor];
            cancelSearchView_.alpha = 0.0;
            
            //显示在searchBar下面
            CGRect rect = cancelSearchView_.frame;
            rect.origin.y = searchBar_.frame.origin.y + searchBar_.frame.size.height;
            [cancelSearchView_ setFrame:rect];
            
            if( animated ){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                cancelSearchView_.alpha = 0.8;
                [UIView commitAnimations];
            }else
                cancelSearchView_.alpha = 0.8;
            
        }else{
            if( animated ){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                cancelSearchView_.alpha = 0.0;
                [UIView commitAnimations];
            }else
            {
                cancelSearchView_.alpha = 0.0;
            }
            
        }
    }
}

#pragma UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self showCancelSearchBarView:YES animated:YES];

    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self showCancelSearchBarView:NO animated:YES];
    [searchBar_ resignFirstResponder];
    
    [self beginSearch];
}

#pragma UIView Touches
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:cancelSearchView_]; 
    
    //如果点击在cancelView上
    if( point.y > 0 ){
        [self showCancelSearchBarView:NO animated:YES];
        [searchBar_ resignFirstResponder];
    }
}

//alert view choosed
-(void) alertViewChoosed:(UIAlertView *)alertView index:(NSInteger)index type:(ChooseAlertViewType)type
{
	NSLog(@"[%@] : Alert View Choosed. Type=>%ld Index=>%d",[self class],(long)index,type);
    
    switch ( type ) {
        case ChooseLogin:
        {
            [self showLoginCtl];
        }
            break;
        case Choose_DoneResume:
        {
//            [self.navigationController pushViewController:manager.mainCtl_.myCenterCtl_.myResumeCtl_ animated:YES];
//            [manager.mainCtl_.myCenterCtl_.myResumeCtl_ beginLoad:nil exParam:nil];
        }
            break;
        default:
            break;
    }
}

//alert view choosed cancel
-(void) alertViewCancel:(UIAlertView *)alertView index:(NSInteger)index type:(ChooseAlertViewType)type
{
    NSLog(@"[%@] : Alert View Choosed Cancel. Type=>%ld Index=>%d",[self class],(long)index,type);
    
    switch ( type ) {
        case ChooseLogin:
        {
            //manager.loginCtl_.interruptId_ = nil;
        }
            break;
        default:
            
            break;
    }
}

#pragma mark alertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"[%@] : Alert View Tag=>%ld",[self class],(long)alertView.tag);
	
	//不起做用
    if( alertView.tag <= AlertNullType )
    {   
        NSLog(@"[%@] : Alert View Choosed , But null...",[self class]);
    }else
    {
        if( buttonIndex == 0 ){
            [self alertViewChoosed:alertView index:buttonIndex type:alertView.tag];
        }else
            [self alertViewCancel:alertView index:buttonIndex type:alertView.tag];
		
    }
}

//get No Data Error View's super view
-(UIView *) getNoDataErrorSuperView
{
	//sub class rewrite it
	
	return self.view;
}

//get in load view's super view
-(UIView *) getInReloadSuperView
{
    //sub class rewrite it
    
    return self.view;
}

//get in reload text
-(NSString *) getInReloadText
{
    //sub class can rewreite it
    
    return InReload_DefaultText;
}

//show/hide no data error view
-(void) showNoDataErrorView:(BOOL)flag;
{	
	if( flag ){
		UIView *superView = [self getNoDataErrorSuperView];
		
		if( superView ){
			if( !noDataErrorCtl_ ){
				noDataErrorCtl_ = [[NoDataErrorCtl alloc] init];
				noDataErrorCtl_.delegate_ = self;
			}
			
			[noDataErrorCtl_.view removeFromSuperview];
			[superView addSubview:noDataErrorCtl_.view];
			noDataErrorCtl_.textLb_.text = [ErrorInfo getErrorMsg:errorCode_];
            
			//set the rect
			CGRect rect = noDataErrorCtl_.view.frame;
			rect.origin.x = (int)((superView.frame.size.width - rect.size.width)/2.0);
			rect.origin.y = (int)((superView.frame.size.height - rect.size.height)/2.0);
			[noDataErrorCtl_.view setFrame:rect];
		}else{
			NSLog(@"[%@] : Didn't Rewrite Super Class's Function => [getNoDataErrorSuperView]",[self class]);
		}
        
	}else
	{
		[noDataErrorCtl_.view removeFromSuperview];
		noDataErrorCtl_ = nil;
	}
}

//show/hide in reload data view
-(void) showInReloadDataView:(BOOL)flag
{
    if( flag ){
		UIView *superView = [self getInReloadSuperView];
		
		if( superView ){
			if( !inReloadDataCtl_ ){
				inReloadDataCtl_ = [[InReloadDataCtl alloc] init];
			}
			
			[inReloadDataCtl_.view removeFromSuperview];
			[superView addSubview:inReloadDataCtl_.view];
			inReloadDataCtl_.textLb_.text = [self getInReloadText];
            
			//set the rect
			CGRect rect = inReloadDataCtl_.view.frame;
			rect.origin.x = (int)((superView.frame.size.width - rect.size.width)/2.0);
			rect.origin.y = (int)((superView.frame.size.height - rect.size.height)/2.0);
			[inReloadDataCtl_.view setFrame:rect];
		}else{
			NSLog(@"[%@] : Didn't Rewrite Super Class's Function => [getInReloadSuperView]",[self class]);
		}
        
	}else
	{
		[inReloadDataCtl_.view removeFromSuperview];
		inReloadDataCtl_ = nil;
	}
}

#pragma mark NoDataErrorDelegate
-(void) reloadData:(NoDataErrorCtl*)ctl sender:(id)sender
{
	//reload data
	if( noDataErrorCtl_ == ctl ){
		[self beginLoad:myParam_ exParam:exParam_];
	}
}

//refresh data(it will load the data)
-(void) refreshData:(id)dataModal exParam:(id)exParam
{
    bFresh_ = YES;
    [self beginLoad:dataModal exParam:exParam];
    bFresh_ = NO;
}

//清除有效期,让自己可以重新载入数据
-(void) clearLoadDataDate
{
    lasterLoadDate_ = nil;
}

//searchBar's search
-(void) beginSearch
{
    [self refreshData:myParam_ exParam:exParam_];
}

//begin load data
-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
	NSLog(@"[%@] : beginLoad \nDataModal=>%@ exParam=>%@",[self class],[dataModal class],[exParam class]);
	
	if( myParam_ != dataModal ){
		myParam_ = dataModal;
	}
	if( exParam_ != exParam ){
		exParam_ = exParam;
	}

	if( [self canGetData] ){
		loadStats_ = InReload;
        
        [self willLoadData];
        
		[self getDataFunction];
	}
	
	//update Com info
	[self updateComInfo:nil];
}

//can get data
-(BOOL) canGetData
{
    BOOL bCan = NO;
    
    //判断有效期
    if( (lasterLoadDate_ && [[NSDate date] timeIntervalSinceDate:lasterLoadDate_] > validateSeconds_ && loadStats_ == FinishLoad ) ){
        bCan = YES;
    }
    //加载状态
    else if( (!lasterLoadDate_ && loadStats_ == FinishLoad) || loadStats_ == ErrorLoad ){
		bCan = YES;
	}
    //一定要刷新
    else if( bFresh_ ){
        bCan = YES;
    }
	
	return bCan;
}

//get data fun
-(void) getDataFunction
{
	NSLog(@"[%@] : get data function be called",[self class]);
}

//weill Load data
-(void) willLoadData
{
    NSLog(@"[%@] : will load data",[self class]);
}

//need process error
-(BOOL) needProcessError:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type
{
    BOOL flag = NO;
    if( [PreRequestCon getRequestStr:type] ){
        flag = YES;
    }
    
    return flag;
}

//error get data
-(void) errorGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type
{
    NSLog(@"[%@] : error get data",[self class]);
    
    if( [self needProcessError:preRequestCon code:code type:type] ){
        NSString *typeStr = [PreRequestCon getRequestStr:type];
        NSString *errorTitle;
        if( typeStr ){
            errorTitle = [NSString stringWithFormat:@"%@失败",typeStr];
        }else
            errorTitle = @"处理失败";
        
        [PreBaseUIViewController showAlertView:errorTitle msg:[ErrorInfo getErrorMsg:code] btnTitle:@"关闭"];
    }
}

//finish get data
-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
	NSLog(@"[%@] : finish get data",[self class]);
}

#pragma mark LoadDataDelegate
-(void) loadDataBegin:(PreRequestCon *)con parserType:(XMLParserType)type
{
    NSLog(@"[%@] : loadData begin",[self class]);
    
    NSString *loadingText = nil;
    if( (loadingText = [self getLoadingText:con type:type]) ){
        currentShowLoadingCon = con;
        [PreBaseUIViewController showLoadingView:YES title:loadingText];
    }
}

-(void) loadDataComplete:(PreRequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr parserType:(XMLParserType)type
{
	NSLog(@"[%@] : loadDataComplate code=>%d dataArrCnt=>%lu",[self class],code,(unsigned long)[dataArr count]);
	
    if( con == currentShowLoadingCon ){
        [PreBaseUIViewController showLoadingView:NO title:nil];
    }
    
    if( type == InitOp_XMLParser ){
        if( [dataArr count] > 0 ){
            //继续上次的请求
            opDataModal = [dataArr objectAtIndex:0];
            
            //继续上次请求
            [prePreRequestCon_ connectBySoapMsg:preSoapMsg_ tableName:preTableName_];
            
            return;
        }
        //报错
        else{
            con = prePreRequestCon_;
            type = prePreRequestCon_.parserType_;
            
            if( type != InitOp_XMLParser ){
                [self loadDataComplete:con code:code dataArr:dataArr parserType:type];
                return;
            }
        }
    }
    
    errorCode_ = code;
    
    if( PreRequestCon_ == con ){
        //jude code
        if( code <= Success ){
            loadStats_ = FinishLoad;
            
            lasterLoadDate_ = [NSDate date];
        }else {
            loadStats_ = ErrorLoad;
        }
    }
    
    @try {
        //if no data
        if( code > Success ){
            //call errorGetData
            [self errorGetData:con code:code type:type];
        }else
            //call finishGetData
            [self finishGetData:con code:code type:type dataArr:dataArr];
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] : loadDataComplete error!",[self class]);
    }
    @finally {
        
    }
	
    if( !bDelete_ ){
    	//upate comInfo
        [self updateComInfo:con];
    }
}

-(void) initOp:(PreRequestCon *)con soapMsg:(NSString *)soapMsg tableName:(NSString *)tableName
{
    if( !initOpCon_ ){
        initOpCon_ = [[PreRequestCon alloc] init];
        initOpCon_.delegate_ = self;
    }
    
    //记住上次的请求参数
    prePreRequestCon_  = con;
    preSoapMsg_     = soapMsg;
    preTableName_   = tableName;
    
    [initOpCon_ initOp:Op_User pwd:Op_Pwd];
}

//start push(ctl is the will push ctl)
-(void) startPush:(UIViewController *)ctl
{
	NSLog(@"[%@] : will push %@",[self class],[ctl class]);
    
    self.navigationController.delegate = self;
    if( [ctl isKindOfClass:[PreBaseUIViewController class]] ){
        pushedCtl_ = (PreBaseUIViewController*)ctl;
    }else
        pushedCtl_ = nil;
}

//be pushed(ctl is the super ctl)
-(void) bePushed:(UIViewController *)ctl
{
	NSLog(@"[%@] : %@ push me",[self class],[ctl class]);
    
    //searchBar
    [searchBar_ resignFirstResponder];
    [self showCancelSearchBarView:NO animated:NO];
    
//    @try {
//        [[BaiduMobStat defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",[self class]]];
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
}

//start pop
-(void) startPop
{
    NSLog(@"[%@] : start pop",[self class]);
    
//    @try {
//        [[BaiduMobStat defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",[self class]]];
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
}

//pop done
-(void) donePop
{
	NSLog(@"[%@] : donePop",[self class]);
	
    if( [self canGetData] ){
        //stop conn
        [PreRequestCon_ stopConn];
    }
}

//be poped(ctl is the super ctl)
-(void) bePoped:(UIViewController *)ctl
{    
	NSLog(@"[%@] : %@ pop me",[self class],[ctl class]);
}

#pragma UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if( self == viewController && pushedCtl_ ){
//        [pushedCtl_ donePop];
//        pushedCtl_ = nil;
//        
//        //重设代理
//        @try {
//            navigationController.delegate = [[navigationController viewControllers] objectAtIndex:[[navigationController viewControllers] count] - 2 ];
//        }
//        @catch (NSException *exception) {
//            navigationController.delegate = nil;
//        }
//        @finally {
//            
//        }
//    }
}

//init res
-(void) initResources
{
	NSLog(@"[%@] : init resources",[self class]);
}

//release res
-(void) releaseResources
{
	NSLog(@"[%@] : resources release",[self class]);
}

//update com info
-(void) updateComInfo:(PreRequestCon *)con
{
	NSLog(@"[%@] : updateComInfo",[self class]);
    
    if( !con || con == PreRequestCon_ ){
    	if( loadStats_ == ErrorLoad ){
            [self showNoDataErrorView:YES];
        }else {
            [self showNoDataErrorView:NO];
        }
        
        if( loadStats_ == InReload ){
            [self showInReloadDataView:YES];
        }else
            [self showInReloadDataView:NO];
    }

    [self showCancelSearchBarView:bShowCancelView_ animated:YES];
    
    bNeedUpdateComInfo_ = NO;
}

#pragma mark IBAction
-(IBAction) buttonClick:(id)sender
{
	NSLog(@"[%@] : button clicked!",[self class]);  
    
//    //添加按扭点击事件到百度事件统计中
//    @try {
//        if( [sender isKindOfClass:[UIButton class]] ){
//            UIButton *btn = sender;
//            if( btn.titleLabel.text ){
//                [[BaiduMobStat defaultStat] logEvent:@"BtnClick" eventLabel:btn.titleLabel.text];
//            }else{
//                //通过tag来标识
//                NSString *str = [NSString stringWithFormat:@"%@_%d",[self class],btn.tag];
//                [[BaiduMobStat defaultStat] logEvent:@"BtnClick" eventLabel:str];
//            }
//        }else if( [sender isKindOfClass:[UIBarButtonItem class]] ){
//            UIBarButtonItem *barBtnItem = sender;
//            if( barBtnItem.title ){
//                [[BaiduMobStat defaultStat] logEvent:@"BtnClick" eventLabel:barBtnItem.title];
//            }else{
//                NSString *str = [NSString stringWithFormat:@"%@",[self class]];
//                [[BaiduMobStat defaultStat] logEvent:@"BtnClick" eventLabel:str];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
    
    switch ( [self checkInterrupt:sender] ) {
        case NullInterrupt:
            if( sender == backBarBtn_ ){
                [self backBarBtnResponse:sender];
            }else if( sender == leftBarBtn_ ){
                [self buttonResponse:sender];
                [self leftBarBtnResponse:sender];
            }else if( sender == rightBarBtn_ ){
                [self buttonResponse:sender];
                [self rightBarBtnResponse:sender];
            }else
                [self buttonResponse:sender];
            
            break;
        case LoginInterrupt:
            [self makeInterrupt:LoginInterrupt sender:sender backFun:@selector(buttonResponse:)];
            break;
        default:
            break;
    }
}

//button real response fun
-(void) buttonResponse:(id)sender
{
    
}

//back bar btn
-(void) backBarBtnResponse:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//left bar btn
-(void) leftBarBtnResponse:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//right bar btn
-(void) rightBarBtnResponse:(id)sender
{
    
}

//set left bar btn title
-(void) setLeftBarBtnTitle:(NSString *)str
{
    if( leftBarBtn_ ){
        [leftBarBtn_ setTitle:str forState:UIControlStateNormal];
    }
    [leftBarBtn_ setTitleColor:[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [leftBarBtn_ setFrame:CGRectMake(0, 0, 60, 44)];
    [leftBarBtn_.titleLabel setFont:TWEELVEFONT_COMMENT];
    [leftBarBtn_ setBackgroundColor:[UIColor clearColor]];
}

//set left bar btn title
-(void) setRightBarBtnTitle:(NSString *)str
{
    if( rightBarBtn_ ){
        [rightBarBtn_ setTitle:str forState:UIControlStateNormal];
    }
    [rightBarBtn_ setTitleColor:[UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 60, 44)];
    [rightBarBtn_.titleLabel setFont:TWEELVEFONT_COMMENT];
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
}

//check the interrupt
-(InterruptType) checkInterrupt:(id)sender;
{
    //sub class rewrite it
    return NullInterrupt;
}

//make a interrupt
-(void) makeInterrupt:(InterruptType)type sender:(id)sender backFun:(SEL)sel
{
    switch ( type ) {
        case LoginInterrupt:
            //判断此中断sender在view中index
            interruptIndex_ = -1;
            
            //如果不是导航中的点击
            if( [self checkSubView:self.view checkView:sender] )
            {

            }
            //左按扭按下
            else if( sender == leftBarBtn_ ){
                interruptIndex_ = -2;
            }
            //右按扭按下
            else if( sender == rightBarBtn_ ){
                interruptIndex_ = -3;
            }
            
            if( interruptIndex_ != -1 ){
//                manager.loginCtl_.interruptId_ = self;
//                interruptSel_ = sel;
//                
//                [self showChooseAlertView:ChooseLogin title:@"是否登录?" msg:@"该功能需要您登录,请问是否登录?" okBtnTitle:@"马上登录" cancelBtnTitle:@"取消"];
            }
            
            break;
            
        default:
            break;
    }
}

//return to interrupt
-(void) returnInterrupt
{
    NSLog(@"[%@] : return interrupt",[self class]);
    
    if( self.view && interruptIndex_ != -1 ){
        //如果是导航中的左按扭
        if( interruptIndex_ == -2 ){
            [self performSelector:interruptSel_ withObject:leftBarBtn_ afterDelay:0.5];
        }
        //如果是导航中的右按扭
        else if( interruptIndex_ == -3 ){
            [self performSelector:interruptSel_ withObject:rightBarBtn_ afterDelay:0.5];
        }
        //去self.view中去查找
        else if( interruptIndex_ >= 0 )
        {
            int tempIndex = interruptIndex_;
            interruptIndex_ = -1;
            UIView *subView = [self getSubView:self.view checkIndex:tempIndex];
            if( subView ){
                [self performSelector:interruptSel_ withObject:subView afterDelay:0.5];
            }
        }
    }
}

//back to interrupt
-(void) backInterrupt
{
    if( interruptId_ ){
        
        [interruptId_ performSelector:@selector(returnInterrupt) withObject:nil];
        interruptId_ = nil;
    }
}

//cancel interrupt
-(void) cancelInterrupt
{
    interruptId_ = nil;
}

//check myView whether contain checkView
-(BOOL) checkSubView:(UIView *)myView checkView:(UIView *)checkView
{
    ++interruptIndex_;
    
    if( myView == checkView ){
        return YES;
    }
    
    for ( UIView *subView in [myView subviews] ) {
        if( subView == checkView ){
            ++interruptIndex_;
            return YES;
        }else{
            BOOL flag = [self checkSubView:subView checkView:checkView];
            
            if( flag ){
                return YES;
            }
        }
    }
    
    return NO;
}

//get checkView
-(UIView *) getSubView:(UIView *)myView checkIndex:(int)index
{
    ++interruptIndex_;
    
    if( interruptIndex_ == index ){
        return myView;
    }
    
    for ( UIView *subView in [myView subviews] ) {
        if( interruptIndex_ == index ){
            ++interruptIndex_;
            return subView;
        }else{
            UIView *tempView = [self getSubView:subView checkIndex:index];
            
            if( tempView ){
                return tempView;
            }
        }
    }
    
    return nil;
}

//提示用户是否开始完善简历
-(void) showFinishResumeAlertView:(NSString *)title msg:(NSString *)msg
{
    [self showChooseAlertView:Choose_DoneResume title:title msg:msg okBtnTitle:@"马上完善" cancelBtnTitle:@"取消"];
}

//显示登录
-(void) showLoginCtl
{
//    manager.loginCtl_.interruptId_ = self;
//    
//    [manager.mainCtl_ presentModalViewController:manager.loginCtl_.navCtl_ animated:YES];
//    //[self presentModalViewController:manager.loginCtl_.navCtl_ animated:YES];
}

#pragma ShareProtol
//SMS,E-mail
-(NSString *) bodyMsgAtMFMessage
{
    //sub class rewrite it
    return @"请输入您要分享的内容";
}

//WB(TX,Sina)
-(NSString *) webContentMsg
{
    //sub class rewrite it
    return @"请输入您要分享的内容";
}

//获取一个请求类(validateSeconds数据有效期)
-(RequestCon *) getNewRequestCon:(BOOL)bDefault
{
    RequestCon *con = [[RequestCon alloc] init];
    con.delegate_ = self;
    
    return con;
}

#pragma LoadDataDelegate
//get the requetInditify
-(NSString *) getRequestInditify:(RequestCon *)con
{
    return nil;
}

//clear request dataArr's data
-(void) dataChanged:(RequestCon *)con
{

}

//start load data
-(void) loadDataBegin:(RequestCon *)con requestType:(int)type
{

}

//load data finish
-(void) loadDataComplete:(RequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr requestType:(int)type
{
    
}

//request should be interrupt
-(BOOL) dataConnShouldInterrupt:(RequestCon *)con aciton:(NSString *)action bodyMsg:(NSString *)bodyMsg method:(NSString *)method{
    return NO;
}

@end
