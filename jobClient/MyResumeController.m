//
//  MyResumeController.m
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "MyResumeController.h"
#import "ResumeHeaderViewController.h"
#import "HeaderNotifyTableViewCell.h"
#import "ResumeTypeTableViewCell.h"
#import "ModifyResumeViewController.h"
#import "New_PersonDataModel.h"
#import "CountMsgDataModel.h"
#import "InterviewMessageListCtl.h"
#import "ResumeVisitorListCtl.h"
#import "WorkApplyRecordListCtl.h"
#import "AttentionCompanyListCtl.h"
#import "ResumePreviewController.h"
#import "RequestCon.h"
#import "MBProgressHUD.h"
#import "MyOfferPartyIndexCtl.h"
#import "PositionCollectRecordCtl.h"
#import "WantJob_ResumeCtl.h"
#import "ResumeAccessAuthorityCtl.h"
#import "ResumeSendOutViewController.h"
#import "ConsultantRecommendationViewController.h"
#import "SuitJobViewController.h"
#import "UIImage+category.h"

#define OfferParty_Index 3
#define kBtn_TAG 1234560
#define pictureHeight 238

PersonDetailInfo_DataModal *personDetailInfoDataModal;

@interface MyResumeController ()<UIGestureRecognizerDelegate>
{
    
    NSString *personId;
//    个人信息model
    New_PersonDataModel *personDataVO;
//    面试通知，谁看过我等（CountMsgDataModel）数组
    NSMutableArray *notifyCountArr;
//    导航栏
    UIView *navView;
//    返回按钮
    UIButton *backBtn;
//    导航标题
    UILabel *titleLb;
    
    UIView *tableHeaderView;
    
    BOOL noFirstLoadData;

}
@property (strong, nonatomic) IBOutlet UIView *myHeaderView;
@property (nonatomic,retain) UIImageView *bgImgView;
@end

@implementation MyResumeController
#pragma mark - LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    self.footerRefreshFlag = NO;
    self.headerRefreshFlag = NO;
    self.showNoDataViewFlag = NO;
    self.showNoMoreDataViewFlag = NO;
    self.noRefershLoadData = YES;
    [super viewDidLoad];
    if (_isMyResumePop) {
        self.fd_interactivePopDisabled = YES;
    }
    
    [self configUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
//    [self setFd_prefersNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    ResumeHeaderViewController* resumeVC = [[ResumeHeaderViewController alloc]init];
    resumeVC.imgState = NO;
    resumeVC.hBackBtn.hidden = YES;
    resumeVC.headerimgView.hidden = YES;
    resumeVC.view.frame = _myHeaderView.frame;
    [self addChildViewController:resumeVC];
    [_myHeaderView addSubview:resumeVC.view];
    [_myHeaderView insertSubview:_bgImgView belowSubview:resumeVC.view];
    self.tableView.tableHeaderView = _myHeaderView;
    
    [notifyCountArr removeAllObjects];
    [self requestPersonInfo];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

#pragma mark--配置界面
-(void)configUI{
    self.tableView.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderNotifyTableViewCell" bundle:nil] forCellReuseIdentifier:@"myHeaderNotifyTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ResumeTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"myResumeTypeTableViewCell"];
    [self configNavBar];
    
    _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, pictureHeight)];
    _bgImgView.image = [UIImage imageNamed:@"background_header.png"];
    _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgView.clipsToBounds = YES;
    [_myHeaderView addSubview:_bgImgView];
}

#pragma mark--navbar
-(void)configNavBar{
    UIColor *color = UIColorFromRGB(0xe13e3e);
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.alpha = 0;
    navView.backgroundColor = color;
    [self.view addSubview:navView];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    titleLb = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 100)/2, 20, 100, 44)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.text = @"我的简历";
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.alpha = 0;
    [self.view addSubview:titleLb];
}

#pragma mark--加载数据
-(void)beginLoad:(id)param exParam:(id)exParam{
    [super beginLoad:param exParam:exParam];
    notifyCountArr = [NSMutableArray array];
    personId = [Manager getUserInfo].userId_;
    [self loadData];
}

-(void)loadData{
    
    [self requestOfferParty];
    _dataArray = [@[@{@"section":@[@{@"title":@"面试通知"},@{@"title":@"谁看过我"},@{@"title":@"申请记录"}]},@{@"section":[@[@{@"icon":@"icon_01",@"title":@"修改简历"},@{@"icon":@"icon_02",@"title":@"简历预览"},@{@"icon":@"icon_03",@"title":@"刷新简历"},@{@"icon":@"icon_04",@"title":@"适合您的职位"},@{@"icon":@"icon_05",@"title":@"顾问推荐职位"},@{@"icon":@"icon_06",@"title":@"关注的企业"},@{@"icon":@"icon_07",@"title":@"职位收藏"}]mutableCopy]},@{@"section":@[@{@"icon":@"icon_08",@"title":@"求职意向"},@{@"icon":@"icon_09",@"title":@"简历外发"},@{@"icon":@"icon_10",@"title":@"保密设置"}]}]mutableCopy];
}
//请求个人主要的信息
-(void)requestPersonInfo{
    //设置请求参数
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@&where=%@&slaveInfo=%@",condictionStr,@"1=1",@"1"];
    NSString * function = @"getPersonDetail";
    NSString * op = @"person_sub_busi";
    if (!noFirstLoadData) {
        [BaseUIViewController showLoadView:YES content:nil view:nil];
        noFirstLoadData = YES;
    }
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        [self requestCenterMsg];
        personDataVO = [[New_PersonDataModel alloc]init];
        [personDataVO setValuesForKeysWithDictionary:result];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:personDataVO];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if (personDataVO.recommend_num.length > 0) {
            [userdefault setObject:personDataVO.recommend_num forKey:@"recommend_num"];
        }
        else{
            [userdefault setObject:@"0" forKey:@"recommend_num"];
        }
        [userdefault synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendData" object:nil userInfo:@{@"array":arr}];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}
//请求面试通知等
-(void)requestCenterMsg{
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = @"get_by_person";
    NSString * op = @"person_info_api";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        if([result isKindOfClass:[NSDictionary class]]){
            CountMsgDataModel * countVO = [[CountMsgDataModel alloc]init];
            [countVO setValuesForKeysWithDictionary:result];
            [notifyCountArr addObject:countVO];
            [self.tableView reloadData];
        }
        else{
            return;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}
//请求offer派
-(void)requestOfferParty{
    NSString * bodyMsg = [NSString stringWithFormat:@"personid=%@&",personId];
    NSString * function = @"getPersonJobfairCount";
    NSString * op = @"offerpai_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        if (![result isKindOfClass:[NSNull class]] && [result isKindOfClass:[NSNumber class]]) {
            NSInteger num = [result integerValue];
            NSDictionary *dic = _dataArray[1];
            NSMutableArray *arr = dic[@"section"];
            NSDictionary *offerDic = @{@"icon":@"icon_11",@"title":@"offer派"};
            NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
            if (num > 0 ) {
                [defaults setObject:@YES forKey:@"isJoinOfferParty"];
                [arr insertObject:offerDic atIndex:3];
            }
            else{
                [defaults setObject:@NO forKey:@"isJoinOfferParty"];
            }
            [defaults synchronize];
            [self.tableView reloadData];
        }
       
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//刷新简历
-(void)refreshResume{
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    NSString *function = @"refreshResume";
    NSString *op = @"person_sub_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        Status_DataModal *model = [[Status_DataModal alloc]init];
        model.status_ = [result objectForKey:@"status"];
        model.des_ = [result objectForKey:@"status_desc"];
        if ([model.status_ isEqualToString:@"OK"]) {
            loginDataModal.updateTime_ = model.des_;
            [BaseUIViewController showAutoDismissSucessView:@"刷新成功" msg:nil];
        }else{
            [BaseUIViewController showAutoDismissFailView:@"刷新失败" msg:nil];
        }
        NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.des_ forKey:@"time"];
        [defaults synchronize];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark--代理
#pragma mark-scorll代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollY = scrollView.contentOffset.y;
    if (scrollY > 108) {
        CGFloat alpha = MIN(1, 1 - (108 + 64 - scrollY)/64);
        navView.alpha = alpha;
        titleLb.alpha = alpha;
    }else{
        navView.alpha = 0 ;
        titleLb.alpha = 0;
    }
    
    // 下拉 纵向偏移量变小 变成负的
    if ( scrollY < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = pictureHeight - scrollY;
        // 图片放大比例
        CGFloat scale = totalOffset / pictureHeight;
        CGFloat width = ScreenWidth;
        // 拉伸后图片位置
        _bgImgView.frame = CGRectMake(-(width * scale - width) / 2, scrollY, width * scale, totalOffset);
    }

}
#pragma mark-table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _dataArray[section];
    NSArray *arr = dic[@"section"];
    if (section == 0) {
        return 1;
    }
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArray[indexPath.section];
    NSArray *arr = dic[@"section"];
    NSDictionary *dataDic = arr[indexPath.row];
    if (indexPath.section == 0) {
        HeaderNotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHeaderNotifyTableViewCell" forIndexPath:indexPath];
        
        if (notifyCountArr.count > 0) {
            CountMsgDataModel *countVO = notifyCountArr[0];
            if([countVO.resume_read_logs_count isEqualToString:@"0"] || countVO.resume_read_logs_count.length <= 0){
                cell.redCircleImg.hidden = YES;
            }
            else{
                cell.redCircleImg.hidden = NO;
            }
            if ([countVO.pmailbox_count isEqualToString:@"0"] || countVO.pmailbox_count.length <= 0) {
                cell.lookMeRedImg.hidden = YES;
            }
            else{
                cell.lookMeRedImg.hidden = NO;
            }
            cell.interNotyfyNumLab.text = countVO.resume_read_logs_count;
            cell.lookMeNumLab.text = countVO.pmailbox_count;
            cell.recordNumlab.text = countVO.cmail_box_count;
        }else{
            cell.redCircleImg.hidden = YES;
        }
        
        [cell.interNotifyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookMeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.recordBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.interNotifyBtn.tag = kBtn_TAG + 1;
        cell.lookMeBtn.tag = kBtn_TAG + 2;
        cell.recordBtn.tag = kBtn_TAG + 3;
        return cell;
    }
    
    ResumeTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myResumeTypeTableViewCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = bgView;
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe0e0e0);
    cell.iconImg.image = [UIImage imageNamed:dataDic[@"icon"]];
    cell.titleLb.text = dataDic[@"title"];
    
    if (indexPath.row == arr.count - 1) {
        cell.underLineView.hidden = YES;
    }
    else{
        cell.underLineView.hidden = NO;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            cell.timeLab.hidden = NO;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            cell.timeLab.text = [defaults valueForKey:@"time"];
        }
        BOOL isJoinOfferParty = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isJoinOfferParty"] boolValue];
        
        if([indexPath row] == (isJoinOfferParty?OfferParty_Index+2:OfferParty_Index+1)){
            NSString *recommendNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"recommend_num"];
            if (recommendNum) {
                if ([recommendNum integerValue] > 0) {
                    cell.numBtn.hidden = NO;
                    [cell.numBtn setTitle:recommendNum forState:UIControlStateNormal];
                }
                else{
                    cell.numBtn.hidden = YES;
                }
            }
        }
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 63;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isJoinOfferParty = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isJoinOfferParty"] boolValue];
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 1) {
//        修改简历
        if (indexPath.row == 0) {
            [self pushVC:@"ModifyResumeViewController"];
        }
//        简历预览
        if (indexPath.row == 1) {
            [self pushVC:@"ResumePreviewController"];
        }
//        刷新简历
        if (indexPath.row == 2) {
            [self refreshResume];
        }
//        我的offer派
        if ([indexPath row] == (isJoinOfferParty?OfferParty_Index:1000)) {
            [self pushVC:@"MyOfferPartyIndexCtl"];
        }
//        适合您的职位
        if([indexPath row] == (isJoinOfferParty?OfferParty_Index+1:OfferParty_Index+0)){
            [self pushVC:@"SuitJobViewController"];
        }
//        顾问推荐职位
        if([indexPath row] == (isJoinOfferParty?OfferParty_Index+2:OfferParty_Index+1)){
            [self pushVC:@"ConsultantRecommendationViewController"];
        }
//        关注的企业
        if([indexPath row] == (isJoinOfferParty?OfferParty_Index+3:OfferParty_Index+2)){
            [self pushVC:@"AttentionCompanyListCtl"];
        }
//        职位收藏
        if([indexPath row] == (isJoinOfferParty?OfferParty_Index+4:OfferParty_Index+3)){
            [self pushVC:@"PositionCollectRecordCtl"];
        }
            
    }
    else{
        if (indexPath.row == 0) {
            //意向职位
            [self pushVC:@"WantJob_ResumeCtl"];
        }
        else if(indexPath.row == 1){
//            简历外发
            [self pushVC:@"ResumeSendOutViewController"];
        }
        else{
//            保密设置
            [self pushVC:@"ResumeAccessAuthorityCtl"];
        }
    }
    
}

#pragma mark--事件
-(IBAction)backBtnClick:(id)sender{
    [self.tableView setContentOffset:CGPointMake(0,0)];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnClick:(UIButton *)sender{
//    面试通知
    if (sender.tag == kBtn_TAG + 1) {
        [self pushVC:@"InterviewMessageListCtl"];
    }
//    谁看过我
    else if(sender.tag == kBtn_TAG + 2){
        [self pushVC:@"ResumeVisitorListCtl"];
    }
//    申请记录
    else if(sender.tag == kBtn_TAG + 3){
        [self pushVC:@"WorkApplyRecordListCtl"];
    }
}

#pragma mark--业务逻辑
-(void)pushVC:(NSString *)ctrlName{
    id ctrlVC = [[NSClassFromString(ctrlName) alloc]init];
    [self.navigationController pushViewController:ctrlVC animated:YES];
    [ctrlVC beginLoad:nil exParam:nil];
}

//网络异常提示
- (void)showNoNetworkView:(BOOL)flag
{
    //显示
    if( flag ){
        UIView *superView = [self getSuperView];
        UIView *myView = [self getNoNetworkView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            [myView setFrame:CGRectMake(0, _myHeaderView.frame.size.height + 10, ScreenWidth, 50 * 12)];
        }else{
            [MyLog Log:@"error view's super view or error view is null" obj:self];
        }
    }
    //不显示
    else{
        [[self getNoNetworkView] removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
