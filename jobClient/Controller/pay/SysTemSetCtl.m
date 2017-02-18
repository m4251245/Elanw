//
//  SysTemSetCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/30.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SysTemSetCtl.h"
#import "MyCenterCell.h"
#import "QuestionnaireCtl.h"
#import "AgreementCtl.h"
#import "WebLinkCtl.h"
#import "VersionInfo_DataModal.h"
#import "PushSetCtl.h"
#import "AboutUsCtl.h"
#import "AccountPasswordCtl.h"

@interface SysTemSetCtl ()<NoLoginDelegate,CellClickDelegate>
{
    NSMutableArray *dataSourceArr;
    float cacheSize;
    
    RequestCon              *versionCon_;   //用于查看版本
    NSString *trackViewURL;//下载的地址
    BOOL _isBindPhone;//是否绑定手机号
    NSString *_phone;
}
@end

@implementation SysTemSetCtl

- (void)dealloc
{
    [tableView_ removeFromSuperview];
    tableView_ = nil;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
       
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设置"];
    NSMutableArray *sectionArr2 = [[NSMutableArray alloc] initWithObjects:@"账号和密码", nil];
    NSMutableArray *sectionArr3 = [[NSMutableArray alloc] initWithObjects:@"消息通知", @"清理缓存", nil];
    NSMutableArray *sectionArr4 = [[NSMutableArray alloc] initWithObjects:@"关于我们", @"给个好评", @"体验问卷", nil];
    
    dataSourceArr = [[NSMutableArray alloc] initWithObjects:sectionArr2, sectionArr3, sectionArr4, nil];
    
    tableView_.sectionFooterHeight = 1.0;
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    btnOutLogin.layer.cornerRadius = 4.5;
    btnOutLogin.layer.masksToBounds = YES;
    [btnOutLogin setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xe0e0e0)] forState:UIControlStateHighlighted];
    
    //在分线程中计算缓存大小，主线程会卡
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(changeCacheSize) object:nil];
    [thread start];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];

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
    [ELRequest postbodyMsg:bodyMsg op:@"job1001user_person_bind_busi" func:@"getBindMobile" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSString *code = result[@"code"];
        NSMutableArray *sectionArr2 = dataSourceArr[0];
        
        if ([code isEqualToString:@"10"]) {//参数错误
            
        }
        else if ([code isEqualToString:@"20"]) {//没有手机号
            sectionArr2[0] = [NSString stringWithFormat:@"手机绑定\t未绑定"];
        }
        else if ([code isEqualToString:@"50"]) {//未绑定，但是有联系手机号
            sectionArr2[0] = [NSString stringWithFormat:@"手机绑定\t未绑定"];
            NSString *phone = result[@"status_info"][@"shouji"];
            _phone = phone;
        }
        else if ([code isEqualToString:@"200"] || [code isEqualToString:@"201"]) {//已绑定, 201手机注册
            _isBindPhone = YES;
            NSString *phone = result[@"status_info"][@"shouji"];
            sectionArr2[0] = [NSString stringWithFormat:@"手机绑定\t%@", phone];
        }
        [tableView_ reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
}

#pragma mark - 计算缓存大小
-(void)changeCacheSize{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat size = [[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0) + [self folderSizeAtPath:cachPath];
    [self performSelectorOnMainThread:@selector(loadFinishCache:) withObject:[NSString stringWithFormat:@"%f",size] waitUntilDone:YES];
}

-(void)loadFinishCache:(NSString *)str{
    cacheSize = [str floatValue];
    [tableView_ reloadData];
}

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

-(void)clearCacheSuccess
{
    [BaseUIViewController showLoadView:NO content:nil view:nil];
    [BaseUIViewController showAutoDismissSucessView:[NSString stringWithFormat:@"已清理临时文件%.1fM",cacheSize] msg:nil seconds:1.0];
    cacheSize = 0;
    [tableView_ reloadData];
}

#pragma mark - button点击事件
- (void)btnResponse:(id)sender
{
    if (sender == btnOutLogin) {
        [Manager shareMgr].isNeedRefresh = YES;
        if ([Manager shareMgr].haveLogin) {
            [self showChooseAlertView:1 title:@"确定退出?" msg:nil okBtnTitle:@"确定" cancelBtnTitle:@"取消"];
        }
        else
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
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
            [Manager shareMgr].registeType_ = FromMore;
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
            [[Manager shareMgr].myCenterCtl refreshTableView];
            
            [self deleteOfferPartyCityCache];
        }
            break;
        case 17:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl_]];
        }
            break;
        default:
            break;
    }
}

//退出登录时清空offer派个人端的城市缓存
- (void)deleteOfferPartyCityCache
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"newOfferRegion"];
    [defaults removeObjectForKey:@"oldOfferRegion"];
    [defaults synchronize];
}

#pragma mark - UITableViewDelegate
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    MyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        cell.delagate = self;
    }
    cell.indexPath = indexPath;
    
    NSString *title = dataSourceArr[indexPath.section][indexPath.row];
    [cell.lbTitle setText:title];
    
    NSMutableArray *array = dataSourceArr[indexPath.section];
    
    if (indexPath.row == [array count] - 1) {
        [cell.imgButtomLine setHidden:YES];
    }
    else
    {
        [cell.imgButtomLine setFrame:CGRectMake(0, 49, ScreenWidth, 1)];
    }
    
    cell.rightStatusLb.hidden = YES;
    if (indexPath.section == 0) {
        cell.rightStatusLb.hidden = YES;
        cell.rightStatusLb.text = @"职人版";
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 1) {
//            [cell removeTapGestureRecognizer];
            cell.rightStatusLb.hidden = NO;
            if (cacheSize > 0) {
                cell.rightStatusLb.text = [NSString stringWithFormat:@"%.1fM", cacheSize];
            }
            else
            {
                cell.rightStatusLb.text = [NSString stringWithFormat:@"%.0fM", cacheSize];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [sectionView setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: //修密码
        {
            if (![Manager shareMgr].haveLogin){
                [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                return;
            }

            AccountPasswordCtl *accPasswordCtl = [[AccountPasswordCtl alloc]init];
            [self.navigationController pushViewController:accPasswordCtl animated:YES];
            [accPasswordCtl beginLoad:nil exParam:nil];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:  //消息通知提醒
                {
                    if (![Manager shareMgr].haveLogin) {
                        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
                    }
                    else{
                        PushSetCtl *setCtl = [[PushSetCtl alloc]init];
                        [self.navigationController pushViewController:setCtl animated:YES];
                        [setCtl beginLoad:nil exParam:nil];
                    }
                }
                    break;
                case 1:  //清理缓存
                {
                    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    [BaseUIViewController showLoadView:YES content:@"清理中..." view:self.view];
                    
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
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:  //关于我们
                {
                    AboutUsCtl *aboutUsCtl_ = [[AboutUsCtl alloc] init];
                    [self.navigationController pushViewController:aboutUsCtl_ animated:YES];
                }
                    break;
                case 1:  //给好评
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPDownloadURL]];
                }
                    break;
                case 2:  //体验问卷
                {
                    QuestionnaireCtl *questionnaireCtl_ = [[QuestionnaireCtl alloc]init];
                    [self.navigationController pushViewController:questionnaireCtl_ animated:YES];
                    [questionnaireCtl_ beginLoad:nil exParam:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)tapClicked:(NSIndexPath *)indexPath
{
    [self tableView:tableView_ didSelectRowAtIndexPath:indexPath];
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


@end
