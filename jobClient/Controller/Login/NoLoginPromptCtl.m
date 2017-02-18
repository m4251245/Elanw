//
//  NoLoginPromptCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-4-28.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NoLoginPromptCtl.h"

@interface NoLoginPromptCtl ()

@property (weak, nonatomic) IBOutlet UIView *loginView;
@end

@implementation NoLoginPromptCtl

+(NoLoginPromptCtl *)noLoginManagerWithDelegate:(id)delegate
{
    NoLoginPromptCtl *manager = [NoLoginPromptCtl getNoLoginManager];
    manager.noLoginDelegare = delegate;
    return manager;
}

+(NoLoginPromptCtl *)getNoLoginManager{
    static NoLoginPromptCtl *manager = nil;
    static  dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager) {
            manager = [[NoLoginPromptCtl alloc] init];
        }
    });
    return manager;
}

+(void)loginOutWithDelegate:(id)delegate type:(NoLoginType)loginType loginRefresh:(BOOL)refresh{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
    [Manager shareMgr].showLoginBackBtn = YES;
    [Manager shareMgr].isNeedRefresh = refresh;
    [NoLoginPromptCtl getNoLoginManager].loginType = loginType;
    [NoLoginPromptCtl getNoLoginManager].noLoginDelegare = delegate;
}

-(void)loginSuccessDelegate{
    if ([self.noLoginDelegare respondsToSelector:@selector(loginSuccessResponse)]){
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self.noLoginDelegare loginSuccessResponse];
            self.noLoginDic = nil;
            self.loginType = 0;
            self.button = nil;
            self.indexPath = nil;
        });
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _loginView.userInteractionEnabled = YES;
    _loginView.clipsToBounds = YES;
    _loginView.layer.cornerRadius = 5.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_loginView addGestureRecognizer:tap];
    
    self.view.frame = [UIScreen mainScreen].bounds;
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    [Manager shareMgr].showLoginBackBtn = YES;
    [self hideNoLoginCtlView];
    [Manager shareMgr].isNeedRefresh = NO;
    if ([_noLoginDelegare respondsToSelector:@selector(loginDelegateCtl)]) {
        [_noLoginDelegare loginDelegateCtl];
    }else{
        [[Manager shareMgr] loginOut];
        [Manager shareMgr].haveLogin = NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_None;
    [self hideNoLoginCtlView];
}

-(void)showNoLoginCtlView
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.view];
}

-(void)hideNoLoginCtlView
{
    [self.view removeFromSuperview];
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
