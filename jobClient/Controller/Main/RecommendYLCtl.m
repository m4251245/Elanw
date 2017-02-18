//
//  RecommendYLCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RecommendYLCtl.h"
#import "RecommendYLCtl_Cell.h"
//#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "QRCodeGenerator.h"
#import "YLAddressBookListCtl.h"

@interface RecommendYLCtl ()
{
//    NSMutableArray * imgaArr_;
//    NSMutableArray * titleArr_;
    BOOL        qqLoginFlag;
    BOOL        weChatLoginFlag;
     YLAddressBookListCtl *addressBookCtl;
    
    __weak IBOutlet NSLayoutConstraint *viewOneW;
    
    __weak IBOutlet NSLayoutConstraint *viewTwoW;
    
    __weak IBOutlet NSLayoutConstraint *viewThreeW;
    
    __weak IBOutlet NSLayoutConstraint *viewFourW;
    
    
    __weak IBOutlet NSLayoutConstraint *weixinWidth;
    
    __weak IBOutlet NSLayoutConstraint *friendWidth;
    
    __weak IBOutlet NSLayoutConstraint *qqWidth;
    
    __weak IBOutlet NSLayoutConstraint *addressWidth;
    
}

@end

@implementation RecommendYLCtl

-(id)init
{
    self = [super init];
    bHeaderEgo_ = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"推荐给好友";
    [self setNavTitle:@"推荐给好友"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
//    imgaArr_ = [[NSMutableArray alloc] init];
//    titleArr_ = [[NSMutableArray alloc] init];
    qqLoginFlag =  [QQApiInterface isQQInstalled];
    weChatLoginFlag = [WXApi isWXAppInstalled];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:weixinWidth,friendWidth,qqWidth,addressWidth,nil];
    if (!weChatLoginFlag) 
    {
//        [imgaArr_ addObject:[UIImage imageNamed:@"shareicon_22.png"]];
//        [imgaArr_ addObject:[UIImage imageNamed:@"shareicon_23.png"]];
//        [titleArr_ addObject:@"推荐一览给微信好友"];
//        [titleArr_ addObject:@"推荐一览到微信朋友圈"];
        wxBgView.hidden = YES;
        pyqBgView.hidden = YES;
        [arr removeObject:weixinWidth];
        [arr removeObject:friendWidth];
    }
    if (!qqLoginFlag) 
    {
//        [imgaArr_ addObject:[UIImage imageNamed:@"shareicon_24.png"]];
//        [titleArr_ addObject:@"推荐一览给QQ好友"];
        qqBgView.hidden = YES;
        [arr removeObject:qqWidth];
    }
    // Do any additional setup after loading the view from its nib.
    
    viewOneW.constant = (ScreenWidth/2.0)-60;
    viewTwoW.constant = (ScreenWidth/2.0)-60;
    viewThreeW.constant = (ScreenWidth/2.0)-60;
    viewFourW.constant = (ScreenWidth/2.0)-60;

    CGFloat width = (ScreenWidth-arr.count*70)/(arr.count+1);
    
    for (NSInteger i = 0;i<arr.count;i++) 
    {
        NSLayoutConstraint *layout = arr[i];
        layout.constant = width + ((70+width)*i);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    
}


- (void)btnResponse:(id)sender
{
    if (sender == wxShareBtn) {
        //微信好友
        [self share:UMSocialPlatformType_WechatSession];
    }
    else if (sender == pyqShareBtn)
    {
        //微信朋友圈
        [self share:UMSocialPlatformType_WechatTimeLine];
    }
    else if (sender == qqShareBtn)
    {
        //QQ好友
        [self share:UMSocialPlatformType_QQ];
    }
    else if (sender == contactBtn)
    {
        if ([MFMessageComposeViewController canSendText])
        {
            ABAddressBookRef addressBooks = nil;
            
            addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
            
            //获取通讯录权限
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            BOOL accessStatus = [[Manager shareMgr] getAddressBookAccessStatusWithCancel:^{}];
            if (!accessStatus) {
                return;
            }
            if (!addressBooks)
            {
                return ;
            }
            BOOL isFirst = NO;
            if (!addressBookCtl)
            {
                addressBookCtl = [[YLAddressBookListCtl alloc] init];
                isFirst = YES;
            }
            addressBookCtl.whereForm = @"YLFRIEND";
            [tableView_ reloadData];
            [[Manager shareMgr].messageCenterListCtl refreshAddressBookRedDot];
            [self.navigationController pushViewController:addressBookCtl animated:YES];
            
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookTelephoneList"];
            NSArray *arrOne = [[NSUserDefaults standardUserDefaults] objectForKey:@"userListId"];
            NSString *currentPersonId = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressBookCurrentPersonId"];
            if (arr == nil || arrOne == nil || ![arrOne containsObject:[Manager getUserInfo].userId_])
            {
                
            }
            else if(isFirst || ![currentPersonId isEqualToString:[Manager getUserInfo].userId_])
            {
                [BaseUIViewController showLoadView:YES content:nil view:nil];
            }
        }
        else
        {
            [BaseUIViewController showAlertView:@"设备没有短信功能" msg:nil btnTitle:@"关闭"];
        }
    }
}

//按类型进行分享
-(void)share:(NSInteger)shareType
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024"  ofType:@"png"];
    
    NSString * sharecontent = @"查薪酬,找工作,同行交流,你想知道的,你所需要的,你想不到的这里全都有~一览职业成长社区~大家一起来！";
    
    NSString * titlecontent = [NSString stringWithFormat:@"%@",@"一览App-职场好助手~快来下载吧！"];
    
    NSString * url = [NSString stringWithFormat:@"http://m.yl1001.com/apps?item=39"];
    
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    //调用分享
    [[ShareManger sharedManager] shareSingleWithType:[NSString stringWithFormat:@"%ld",(long)shareType] ctl:self title:titlecontent content:sharecontent image:image url:url];
}

@end
