//
//  SysTemSetCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SysTemSetCtl.h"
#import "MyCenterCell.h"
#import "Manager.h"
#import "QuestionnaireCtl.h"
//#import "MMProgressHUD.h"
#import "AgreementCtl.h"
#import "WebLinkCtl.h"
#import "Manager.h"
#import "VersionInfo_DataModal.h"
#import "PushSetCtl.h"
#import "AboutUsCtl.h"
#import "ResetPwdCtl.h"
#import "ELRequest.h"
#import "AccountPasswordCtl.h"
#import "ELVersionIterationRecordCtl.h"
#import "MBProgressHUD+Add.h"

@interface SysTemSetCtl ()<NoLoginDelegate>
{
    NSMutableArray *dataSourceArr;
    NSMutableArray *imgDataSource;
    float cacheSize;
//    MMProgressHUD *hud;
    RequestCon              *versionCon_;   //用于查看版本
    NSString *trackViewURL;//下载的地址
    BOOL _isBindPhone;//是否绑定手机号
    NSString *_phone;
}
@end

@implementation SysTemSetCtl


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"设置";
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *sectionArr1 = [[NSMutableArray alloc] initWithObjects:@"消息推送提醒", nil];
    NSMutableArray *sectionArr2 = [[NSMutableArray alloc] initWithObjects:@"关于我们",@"版本迭代记录",@"体验问卷",@"社区协议",@"官方网站(触屏版)", nil];
    NSMutableArray *sectionArr3 = [[NSMutableArray alloc] initWithObjects:@"清缓存", nil];
    NSMutableArray *sectionArr4 = [[NSMutableArray alloc] initWithObjects:@"给个好评", nil];
    NSMutableArray *sectionArr5 = [[NSMutableArray alloc] initWithObjects:@"账号和密码", nil];
#warning todo
//    NSMutableArray *sectionArr5 = [[NSMutableArray alloc] initWithObjects:@"手机绑定", @"修改密码", nil];
    dataSourceArr = [[NSMutableArray alloc] initWithObjects:sectionArr1,sectionArr2,sectionArr3,sectionArr4,sectionArr5,nil];
    
    NSMutableArray *imgSectionArr1 = [[NSMutableArray alloc] initWithObjects:@"ios_icon_12xx.png", nil];
    NSMutableArray *imgSectionArr2 = [[NSMutableArray alloc] initWithObjects:@"ios_icon_13wm.png",@"ios_icon_ddjl.png",@"ios_icon_14wj.png",@"ios_icon_15xy.png",@"ios_icon_16gw.png", nil];
    NSMutableArray *imgSectionArr3 = [[NSMutableArray alloc] initWithObjects:@"ios_icon_17qc.png", nil];
    NSMutableArray *imgSectionArr4 = [[NSMutableArray alloc] initWithObjects:@"ios_icon_18hp.png", nil];
    NSMutableArray *imgSectionArr5 = [[NSMutableArray alloc] initWithObjects: @"ios_icon_19mm.png", nil];
#warning todo
//    NSMutableArray *imgSectionArr5 = [[NSMutableArray alloc] initWithObjects:@"bind_phone.png", @"ios_icon_19mm.png", nil];
    
    imgDataSource = [[NSMutableArray alloc] initWithObjects:imgSectionArr1,imgSectionArr2,imgSectionArr3,imgSectionArr4,imgSectionArr5,nil];
    
    tableView_.sectionFooterHeight = 1.0;
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    btnOutLogin.layer.cornerRadius = 4.5;
    btnOutLogin.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([Manager shareMgr].haveLogin)
    {
        [btnOutLogin setTitle:@"退出登录" forState:UIControlStateNormal];
    }else{
        [btnOutLogin setTitle:@"登录" forState:UIControlStateNormal];
    }
    [self beginLoad:nil exParam:nil];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];

    
    if (![Manager shareMgr].haveLogin) {//未登录，不请求
        return;
    }
    //查询绑定状态
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&", [Manager getUserInfo].userId_ ? [Manager getUserInfo].userId_:@""];
    [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"getBindMobile" requestVersion:YES success:^(AFHTTPRequestOperation *operation, id result) {
        NSString *code = result[@"code"];
        NSMutableArray *section4Arr = dataSourceArr[4];
        if ([code isEqualToString:@"10"]) {//参数错误
            
        }else if ([code isEqualToString:@"20"]) {//没有手机号
            section4Arr[0] = [NSString stringWithFormat:@"手机绑定\t未绑定"];
        }else if ([code isEqualToString:@"50"]) {//未绑定，但是有联系手机号
            section4Arr[0] = [NSString stringWithFormat:@"手机绑定\t未绑定"];
            NSString *phone = result[@"status_info"][@"shouji"];
            _phone = phone;
        }else if ([code isEqualToString:@"200"] || [code isEqualToString:@"201"]) {//已绑定, 201手机注册
            _isBindPhone = YES;
            NSString *phone = result[@"status_info"][@"shouji"];
            section4Arr[0] = [NSString stringWithFormat:@"手机绑定\t%@", phone];
        }
        [tableView_ reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(id)sender
{
    if (sender == btnOutLogin) {
        if ([Manager shareMgr].haveLogin) {
            [self showChooseAlertView:1 title:@"确定退出?" msg:nil okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
        }
        else{
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
            [Manager shareMgr].isFromNoLogin = YES;
            [Manager shareMgr].showLoginBackBtn = YES;
        }
        return;
    }
}
-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr].sameTradeCtl_ reloadRecentNewsCtlData];
            [Manager shareMgr].registeType_ = FromMore;
            
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
                  
            [[Manager shareMgr].myCenterCtl refreshTableView];
        }
            break;
        case 17:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl_]];
        }
            break;
        case 20://升级提示框
        {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:trackViewURL]];
        }
            break;
        default:
            break;
    }
}



#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = dataSourceArr[section];
    if ([array count] != 0) {
        return [array count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([dataSourceArr count] != 0) {
        return [dataSourceArr count];
    }
    return 0;
}


//在后台检测版本
-(void) checkVersionByHide
{
    NSString *url = @"http://itunes.apple.com/lookup?id=468319885";
    [ELRequest getMsgWithUrl:url parameters:nil success:^(AFHTTPRequestOperation *operation, id result) {
        NSArray *infoArray = [result objectForKey:@"results"];
        if (infoArray.count > 0) {
            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
            NSString *storeVersion = [releaseInfo objectForKey:@"version"];
//            NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
            NSString *currVersion = Version_Str;
            BOOL needUpdate = [self needUpdate:currVersion appStoreVersion:storeVersion];
            if (needUpdate) {
                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                [self showChooseAlertView:20 title:@"版本升级" msg:[NSString stringWithFormat:@"发现有新版本，是否升级？"] okBtnTitle:@"马上升级" cancelBtnTitle:@"暂不升级"];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
//    if( !versionCon_ ){
//        versionCon_ = [self getNewRequestCon:NO];
//    }
//    
//    [versionCon_ checkClientVersionByHide:MyClientName];
}

#pragma mark 判断是否需要更新
- (BOOL)needUpdate:(NSString *)currentVersion appStoreVersion:(NSString *)appStoreVersion
{
    NSArray *curVerArr = [currentVersion componentsSeparatedByString:@"."];
    NSArray *appstoreVerArr = [appStoreVersion componentsSeparatedByString:@"."];
    BOOL needUpdate = NO;
    //比较版本号大小
    int maxv = (int)MAX(curVerArr.count, appstoreVerArr.count);
    int cver = 0;
    int aver = 0;
    for (int i = 0; i < maxv; i++) {
        if (appstoreVerArr.count > i) {
            aver = [NSString stringWithFormat:@"%@",appstoreVerArr[i]].intValue;
        }
        else{
            aver = 0;
        }
        if (curVerArr.count > i) {
            cver = [NSString stringWithFormat:@"%@",curVerArr[i]].intValue;
        }
        else{
            cver = 0;
        }
        if (aver > cver) {
            needUpdate = YES;
            break;
        }
    }
    return needUpdate;
}


-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case Request_CheckVersionByHide:
        {
            VersionInfo_DataModal *dataModal = [dataArr objectAtIndex:0];
            //版本号判读
            int firstNum = 0;
            int secondNum = 0;
            int myFirstNUm = 0;
            int mySecondNum = 0;
            NSArray *versionArr = [dataModal.version_ componentsSeparatedByString:@"."];
            NSArray *localVersionArr = [ClientVersion componentsSeparatedByString:@"."];
            if ([versionArr count] == 2) {
                firstNum = [versionArr[0] intValue];
                secondNum = [versionArr[1] intValue];
            }
            if ([localVersionArr count] == 2) {
                myFirstNUm = [localVersionArr[0] intValue];
                mySecondNum = [localVersionArr[1] intValue];
            }
            
            if (myFirstNUm > firstNum) {
                break;
            }else{
                if (mySecondNum >= secondNum) {
                    break;
                }else{
                    [[Manager shareMgr] findNewVersion];
                    updateUrl_ = dataModal.url_;
                    [self showChooseAlertView:17 title:[NSString stringWithFormat:@"发现新版本 %@",dataModal.version_] msg:dataModal.msg_ okBtnTitle:@"升级" cancelBtnTitle:@"取消"];
                }
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    MyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString *title = dataSourceArr[indexPath.section][indexPath.row];
    NSString *imgName = imgDataSource[indexPath.section][indexPath.row];
    [cell.lbTitle setText:title];
    [cell.imgvLefe setImage:[UIImage imageNamed:imgName]];
    [cell.lbCount setHidden:YES];
    if (indexPath.row == 0) {
        [cell.imgTopLine setHidden:NO];
    }else{
        [cell.imgTopLine setHidden:YES];
    }
    
    NSMutableArray *array = dataSourceArr[indexPath.section];
    if (indexPath.row == [array count] - 1) {
        [cell.imgButtomLine setFrame:CGRectMake(-10, 35, ScreenWidth + 10, 1)];
    }else{
        [cell.imgButtomLine setFrame:CGRectMake(45, 35, ScreenWidth + 10, 1)];
    }
    
    if (indexPath.section == 4) {
        if ([Manager shareMgr].isThridLogin_) {
            [cell.lbTitle setTextColor:[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0]];
        }else{
            [cell.lbTitle setTextColor:[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0]];
        }

    }else{
        [cell.lbTitle setTextColor:[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [sectionView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:251.0/255.0 alpha:1.0]];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: //消息推送提醒
        {
            if (![Manager shareMgr].haveLogin) {
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            }else{
                PushSetCtl *setCtl = [[PushSetCtl alloc]init];
                [self.navigationController pushViewController:setCtl animated:YES];
                [setCtl beginLoad:nil exParam:nil];
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0: //关于我们
                {
                    AboutUsCtl *aboutUsCtl_ = [[AboutUsCtl alloc] init];
                    [[Manager shareMgr].centerNav_ pushViewController:aboutUsCtl_ animated:YES];
                }
                    break;
                case 1: //版本迭代记录
                {
                    ELVersionIterationRecordCtl *iterationCtl = [[ELVersionIterationRecordCtl alloc] init];
                    [[Manager shareMgr].centerNav_ pushViewController:iterationCtl animated:YES];
                }
                    break;
                case 2:  //体验问卷
                {
                    QuestionnaireCtl *questionnaireCtl_ = [[QuestionnaireCtl alloc]init];
                    [self.navigationController pushViewController:questionnaireCtl_ animated:YES];
                    [questionnaireCtl_ beginLoad:nil exParam:nil];
                }
                    break;
                case 3:  //社区协议
                {
                     AgreementCtl *agreementCtl_ = [[AgreementCtl alloc] init];
                    [[Manager shareMgr].centerNav_ pushViewController:agreementCtl_ animated:YES];
                    [agreementCtl_ beginLoad:nil exParam:nil];
                }
                    break;
                case 4: //官网
                {
                    WebLinkCtl *weblinkCtl_ = [[WebLinkCtl alloc] init];
                    [[Manager shareMgr].centerNav_ pushViewController:weblinkCtl_ animated:YES];
                    [weblinkCtl_ beginLoad:Nil exParam:Nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:  //清缓存
        {
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            cacheSize = [[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0) + [self folderSizeAtPath:cachPath];
            
            [BaseUIViewController showModalLoadingView:YES title:@" " status:@"清理中..."];
            
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                   for (NSString *p in files) {
                       NSError *error;
                       NSString *path = [cachPath stringByAppendingPathComponent:p];
                       if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                           [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                       }
                   }
                   [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
            });
        }
            break;
        case 3: //给好评
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPDownloadURL]];
        }
            break;
        case 4: //修密码
        {
            if (![Manager shareMgr].haveLogin){
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                return;
            }
//            else if (indexPath.row == 0) {//手机绑定
//                return;
//            }
            
            if (indexPath.row ==0 ) {
                
                AccountPasswordCtl *accPasswordCtl = [[AccountPasswordCtl alloc]init];
                [[Manager shareMgr].centerNav_ pushViewController:accPasswordCtl animated:YES];
                [accPasswordCtl beginLoad:nil exParam:nil];
                
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)clearCacheSuccess
{
    [BaseUIViewController showAutoDismissSucessView:[NSString stringWithFormat:@"清理了%.1fm空间",cacheSize] msg:nil seconds:1.0];
}

//#pragma mark 绑定手机号
//- (void)doBindAction:(id)sender
//{
//    User_DataModal *userInfo = [Manager getUserInfo];
//    TBindPhoneCtl *bindPhoneCtl = [[TBindPhoneCtl alloc]init];
//    bindPhoneCtl.fromType = FromTypeSetting;
//    bindPhoneCtl.phone = _phone;
//    bindPhoneCtl.inDataModal = userInfo;
//    [[Manager shareMgr].centerNav_ pushViewController:bindPhoneCtl animated:YES];
//}


- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]){
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


-(void)loginDelegateCtl
{
    [Manager shareMgr].registeType_ = FromMessageSet;
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
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
