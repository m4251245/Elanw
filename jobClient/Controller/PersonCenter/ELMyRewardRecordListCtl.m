//
//  ELMyRewardRecordListCtl.m
//  jobClient
//
//  Created by YL1001 on 15/11/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELMyRewardRecordListCtl.h"
#import "MyConfig.h"
#import "SBJson.h"
#import "Reward_DataModal.h"
#import "ELMyRewardRecordListCell.h"
#import "RewardAmountCtl.h"
#import "ELPersonCenterCtl.h"


@interface ELMyRewardRecordListCtl ()
{
    NSMutableArray *imgArray;
    
    IBOutlet UIView *rewardBtnView;
    
    NSTimer *timer;
    NSMutableArray *goldArray;
    NSMutableArray *goldWidthArray;
    NSMutableArray *goldHeightArray;
    
    UIView *maskView;   /**<遮罩View */
    
    IBOutlet NSLayoutConstraint *_tableViewAutobottom;
}

@end

@implementation ELMyRewardRecordListCtl

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bFooterEgo_ = YES;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
    [super viewWillDisappear:animated];
    userImg.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    userImg.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self beginLoad:nil exParam:nil];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
       
    }
    
    if ([_personId isEqualToString:[Manager getUserInfo].userId_]) {
        [self isShowAnimation];
    }
}

- (void)isShowAnimation
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        return;
    }
    
    NSString *op = @"dashang_busi";
    NSString *function = @"getDashangCntToMe";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result integerValue] >= 1) {
            //出现动画
            goldArray = [[NSMutableArray alloc] initWithObjects:@"gold1.png",@"gold2.png",@"gold3.png",@"gold5.png",@"gold6.png",@"gold7.png",@"gold8.png",@"gold9.png",@"gold10.png", nil];
            
            goldWidthArray = [[NSMutableArray alloc] initWithObjects:@"17",@"28",@"17",@"12",@"25",@"14",@"17",@"18",@"38", nil];
            goldHeightArray = [[NSMutableArray alloc] initWithObjects:@"14",@"23",@"14",@"11",@"29",@"12",@"19",@"13",@"32", nil];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(goldDown) userInfo:nil repeats:YES];
            [timer fire];
            [self showMaskView];
            [self startDownTime];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 金币掉落动画
- (void)startDownTime
{
    __block int timeout = 4; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([timer isValid]) {
                    [timer invalidate];
                    timer = nil;
                    [self performSelector:@selector(hiddenMaskView) withObject:self afterDelay:2.5];
                }
            });
        }else{
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void)goldDown{//动画效果
    
    NSInteger randomNum1 = arc4random()%9;
    NSInteger imgWidth1 = [[goldWidthArray objectAtIndex:randomNum1] integerValue];
    NSInteger imgHeight1 = [[goldHeightArray objectAtIndex:randomNum1] integerValue];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(arc4random()%370 - 50, -50, imgWidth1, imgHeight1);
    imgView.image = [UIImage imageNamed:[goldArray objectAtIndex:randomNum1]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:imgView];
    
    [UIView beginAnimations:nil context:(__bridge void *)(imgView)];
    [UIView setAnimationDuration:2.5];
    [UIView setAnimationDelegate:self];
    //设置动画淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    imgView.frame = CGRectMake(arc4random()%321, ScreenHeight, imgWidth1, imgHeight1);
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{//到底部消除
    UIImageView *image = (__bridge UIImageView *)context;
    [image removeFromSuperview];
}

#pragma mark - 显示遮罩View
- (void)showMaskView
{
    maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.0;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:maskView];
    
    [UIView animateWithDuration:0.3 animations:^{
        maskView.alpha = 0.6;
    }];
}

//隐藏遮罩View
- (void)hiddenMaskView
{
    [UIView animateWithDuration:0.1 animations:^{
        maskView.alpha = 0.0;
    }completion:^(BOOL finished){
        [maskView removeFromSuperview];
    }];
    
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setNavTitle:@"打赏列表"];
    if(_isPop){
        self.fd_interactivePopDisabled = YES;
    }
    
    imgArray = [[NSMutableArray alloc] initWithObjects:@"redPacket.png",@"flower.png",@"reward_ pen.png",@"compute.png",@"emblem.png",@"crown.png", nil];
    
    userImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    userImg.layer.cornerRadius = 25;
    userImg.layer.masksToBounds = YES;
    
    [userImg sd_setImageWithURL:[NSURL URLWithString:_personImg] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    userImg.center = CGPointMake(ScreenWidth/2, 65);
    [[UIApplication sharedApplication].keyWindow addSubview:userImg];
    
    NSString *userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    
    CGRect frame = tableView_.frame;
    if ([userId isEqualToString:_personId]) {
        rewardBtnView.hidden = YES;
        _tableViewAutobottom.constant = 0;
    }
    else
    {
         _tableViewAutobottom.constant = 35;
    }
    tableView_.frame = frame;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self getRewardCount];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    [con getMyRewardList:_personId userId:userId pageSize:con.pageInfo_.currentPage_ pageIndex:20];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getMyRewardList:
        {
            if (dataArr.count == 0) {
                self.noDataTips = @"很抱歉，还没有人打赏哦！";
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)getRewardCount
{
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",_personId];
    
    NSString *function = @"getPersonDsTotalCnt";
    NSString *op = @"dashang_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
//        if (![result isKindOfClass:[NSString class]]) {
//            result = 0;
//        }
        NSString *str = [NSString stringWithFormat:@"累计被打赏了%ld次",(long)[result integerValue]];
        rewardCountLb.text = str;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    ELMyRewardRecordListCell *cell = (ELMyRewardRecordListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELMyRewardRecordListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Reward_DataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    [cell.personImg sd_setImageWithURL:[NSURL URLWithString:dataModal.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    cell.dataLb.text = dataModal.idatetime;
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@打赏%@%@%@",dataModal.name_,dataModal.serviceTitle,dataModal.buyNums,dataModal.serviceUnit]];
    NSRange range1=[[hintString string] rangeOfString:dataModal.name_];
    [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF22530) range:range1];
    
    cell.giftNameLb.attributedText = hintString;
    cell.giftNameLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    cell.giftImg.image = [UIImage imageNamed:[imgArray objectAtIndex:[dataModal.serviceId integerValue] -1]];
    cell.priceLb.text = [NSString stringWithFormat:@"%@元",dataModal.money];
    cell.priceLb.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reward_DataModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if (![[Manager getUserInfo].userId_ isEqualToString:dataModal.personId]) {
        ELPersonCenterCtl *personCenter = [[ELPersonCenterCtl alloc] init];
        [personCenter beginLoad:dataModal.personId exParam:nil];
        [self.navigationController pushViewController:personCenter animated:YES];
    }
}

- (void)btnResponse:(id)sender {
    
    if (sender == rewardBtn) {
        
        //友盟统计模块使用量
        NSDictionary *dict = @{@"Function":@"打赏"};
        [MobClick event:@"buttonClick" attributes:dict];
        
        if ([Manager shareMgr].haveLogin) {
            RewardAmountCtl *rewardAmountCtl = [[RewardAmountCtl alloc] init];
            rewardAmountCtl.personPic = _personImg; //被打赏用户头像;
            rewardAmountCtl.personId = _personId;   //被打赏用户Id
            rewardAmountCtl.personName = _personName;   //被打赏用户姓
            rewardAmountCtl.productId = _personId;   //产品Id
            rewardAmountCtl.productType = @"30";
            [self.navigationController pushViewController:rewardAmountCtl animated:YES];
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            [NoLoginPromptCtl getNoLoginManager].loginType = LoginType_RewardBottom;
        }
       
    }
    else if (sender == backBtn)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 退出登录
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_RewardBottom:
        {
            [self btnResponse:rewardBtn];
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
