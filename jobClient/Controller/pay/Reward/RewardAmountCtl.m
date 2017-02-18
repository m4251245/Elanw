//
//  RewardAmountCtl.m
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RewardAmountCtl.h"
#import "RewardOtherAmountCtl.h"
#import "Manager.h"
#import "UIImageView+WebCache.h"
#import "PayCtl.h"
#import "Order.h"
#import "RewardCollectionCell.h"
#import "ELRequest.h"
#import "MBProgressHUD+Add.h"

@interface RewardAmountCtl ()
{
    Order *payOrder;
    NSString    *payValue;
    RequestCon  *dasangCon;
    Order       *_payOrder;
    
    NSMutableArray *imgArray;       /**<礼物Img */
    NSMutableArray *priceArray;     /**<礼物价格 */
    NSMutableArray *giftNameArray;  /**<礼物名字 */
    NSMutableArray *cellArray;      
    NSArray *rewardTypeArr;         /**<打赏类型 */
    
    NSInteger giftNum;  /**<礼物数量 */
    NSString *giftType; /**<礼物类型 */
    NSInteger giftPrice;/**<礼物单价 */
    
    BOOL isRedPacket; //是否是红包
    IBOutlet NSLayoutConstraint *_rewardBtnAutoTop;
    
    BOOL isShowRewardOtherAmountCtl;
    
    UIImageView *_rewardImg;
}
@end

@implementation RewardAmountCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"打赏";
//    [self setFd_interactivePopDisabled:NO];
    
    CALayer *layer = _userImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 20.f;
    [_userImgv sd_setImageWithURL:[NSURL URLWithString:_personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    _nameLb.text = _personName;
    
    NSArray *tipsArray = [[NSArray alloc] initWithObjects:@"喜欢打赏的人，运气都不会太差~",@"能够得到你的认可，真的很开心~",@"打赏随心，鼓励和赞赏别人本来就是一种美德", nil];
    _tipsLb1.text = [tipsArray objectAtIndex:arc4random()%3];
    
    [_myConllection registerNib:[UINib nibWithNibName:@"RewardCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"RewardCollectionCell"];
    _myConllection.delegate = self;
    _myConllection.dataSource = self;
    
    imgArray = [[NSMutableArray alloc] initWithObjects:@"flower.png",@"reward_ pen.png",@"compute.png",@"emblem.png",@"crown.png",@"redPacket.png", nil];
    priceArray = [[NSMutableArray alloc] initWithObjects:@"1",@"3",@"5",@"10",@"20",@"0", nil];
    giftNameArray = [[NSMutableArray alloc] initWithObjects:@"鲜花",@"神奇钢笔",@"电脑",@"闪耀徽章",@"魔法皇冠",@"任性红包", nil];
    
    cellArray = [[NSMutableArray alloc] init];
    //@"2":鲜花,@"3":钢笔,@"4":电脑,@"5":徽章,@"6":皇冠,@"1":任性红包
    rewardTypeArr = [[NSArray alloc] initWithObjects:@"2",@"3",@"4",@"5",@"6",@"1", nil];
    
    _cutBtn.layer.borderWidth = 0.5f;
    _cutBtn.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _addBtn.layer.borderWidth = 0.5f;
    _addBtn.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _giftCountLb.layer.borderWidth = 0.5f;
    _giftCountLb.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _rewardBtn.layer.cornerRadius = 4.0f;
    
    giftNum = 1;
    payValue = @"1";
    giftType = @"3";
    giftPrice = 3;
    
    isShowRewardOtherAmountCtl = YES;
    
    _rewardImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 29, 29)];
    _rewardImg.image = [UIImage imageNamed:@"icon_zhuye_dashang.png"];
    _rewardImg.center = CGPointMake(ScreenWidth/2, 60);
    [[UIApplication sharedApplication].keyWindow addSubview:_rewardImg];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_rewardImg];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    if (IOS7) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    }
    [super viewWillDisappear:animated];
    _rewardImg.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginLoad:nil exParam:nil];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    if (IOS7) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _rewardImg.hidden = NO;
}


#pragma mark - UICollectionViewDelegate
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (ScreenWidth - 80)/3;
    return CGSizeMake(width,30);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  priceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"RewardCollectionCell";
    
    RewardCollectionCell *cell = (RewardCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.priceLb.backgroundColor = [UIColor redColor];
        cell.priceLb.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.row < 5) {
        cell.priceLb.text = [NSString stringWithFormat:@"%@", [giftNameArray objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.priceLb.text = [giftNameArray objectAtIndex:indexPath.row];
    }
    
    [cellArray addObject:cell];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RewardCollectionCell *selectedCell = (RewardCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    for (NSInteger i = 0; i < cellArray.count; i++) {
            RewardCollectionCell *cell = [cellArray objectAtIndex:i];
            if ([selectedCell.priceLb.text isEqualToString:cell.priceLb.text]) {
                selectedCell.priceLb.backgroundColor = [UIColor redColor];
                selectedCell.priceLb.textColor = [UIColor whiteColor];
            }
            else
            {
                cell.priceLb.backgroundColor = [UIColor whiteColor];
                cell.priceLb.textColor = [UIColor redColor];
            }

        }
    
    giftType = [rewardTypeArr objectAtIndex:indexPath.row];
    NSString *priceStr = [priceArray objectAtIndex:indexPath.row];

    if ([priceStr isEqualToString:@"0"]) {//红包
        
        if (isShowRewardOtherAmountCtl) {
            _tipsLb.hidden = YES;
            _cutBtn.hidden = YES;
            _addBtn.hidden = YES;
            _giftCountLb.hidden = YES;
            
            _rewardBtnAutoTop.constant = 17;
            
            _giftImg.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
            _giftNameLb.text = [NSString stringWithFormat:@"%@%@元",[giftNameArray objectAtIndex:indexPath.row],[priceArray objectAtIndex:indexPath.row]];
            
            RewardOtherAmountCtl *otherAmountCtl = [[RewardOtherAmountCtl alloc]init];
            
            _rewardOtherAmountCtl = otherAmountCtl;
            __weak  typeof(RewardAmountCtl) *weakSelf = self;
            otherAmountCtl.amountBlock = ^(NSString *amount){
                if (amount != 0) {
                    payValue = amount;
                    _giftNameLb.text = [NSString stringWithFormat:@"任性红包%@元",payValue];
                    [self getTodayCanDs];
                }
                else
                {
                    payValue = 0;
                    [weakSelf.rewardOtherAmountCtl.view removeFromSuperview];
                    weakSelf.rewardOtherAmountCtl = nil;
                }
                
                isShowRewardOtherAmountCtl = YES;
            };
            otherAmountCtl.view.frame = CGRectMake(0,ScreenHeight, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [[UIApplication sharedApplication].keyWindow addSubview:otherAmountCtl.view];
            [UIView animateWithDuration:0.3 animations:^{
                otherAmountCtl.view.frame = [UIScreen mainScreen].bounds;
            }];
            [otherAmountCtl.personImg sd_setImageWithURL:[NSURL URLWithString:_personPic] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
            otherAmountCtl.personNameLb.text = _personName;
            isRedPacket = YES;
            isShowRewardOtherAmountCtl = NO;
        }
    }
    else
    {//其他
        _tipsLb.hidden = NO;
        _cutBtn.hidden = NO;
        _addBtn.hidden = NO;
        _giftCountLb.hidden = NO;
        
        _rewardBtnAutoTop.constant = 52;
        
        _giftImg.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
        _giftNameLb.text = _giftNameLb.text = [NSString stringWithFormat:@"%@%@元",[giftNameArray objectAtIndex:indexPath.row],[priceArray objectAtIndex:indexPath.row]];
        payValue = [priceArray objectAtIndex:indexPath.row];
        giftPrice = [payValue integerValue];
        
        isRedPacket = NO;
    }
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

- (void)btnResponse:(UIButton *)sender
{
    if (sender == _cutBtn) {
        if (giftNum <= 1) {
            _giftCountLb.text = @"1";
        }
        else
        {
            giftNum -= 1;
            _giftCountLb.text = [NSString stringWithFormat:@"%ld",(long)giftNum];
        }
    }
    else if (sender == _addBtn)
    {
        giftNum += 1;
        _giftCountLb.text = [NSString stringWithFormat:@"%ld",(long)giftNum];
        
    }
    else if (sender == _rewardBtn)
    {
        if (!isRedPacket) {
            payValue = [NSString stringWithFormat:@"%ld",(long)giftNum];
        }
        else
        {
            if (payValue == 0) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"请输入金额"];
                return;
            }
        }
        [self getTodayCanDs];
    }
    else if (sender == backBtn)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_DashangShoppingCart://生成订单
        {
            [BaseUIViewController showLoadView:NO content:nil view:[[UIApplication sharedApplication] keyWindow]];
            NSDictionary *orderDict = dataArr[0];
            if ([orderDict[@"status"] isEqualToString:@"SUCCESS"])
            {
                NSString *orderId = orderDict[@"gwc_id"];
                Order *order = [[Order alloc]init];
                order.tradeNO = orderId;
                order.productName = orderDict[@"subject"];
                order.productDescription = orderDict[@"body"];
                order.amount = orderDict[@"payfree"];
                _payOrder = order;
                
                PayCtl *payCtl = [[PayCtl alloc]init];
                [Manager shareMgr].payType = PayTypeReward;//打赏
                if (isRedPacket) {
                    payCtl.isRedPacket = YES;
                }
                else
                {
                    payCtl.isRedPacket = NO;
                }
                
                payCtl.order = _payOrder;
                [payCtl beginLoad:nil exParam:nil];
                [self.navigationController pushViewController:payCtl animated:YES ];
                
                [self.rewardOtherAmountCtl.view removeFromSuperview];
                self.rewardOtherAmountCtl = nil;
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"抱歉，订单生成失败!" seconds:1.0];
            }
        }
            break;
        default:
            break;
    }
}

//单个账户日限额2000元
- (void)getTodayCanDs
{
    NSString *op = @"dashang_busi";
    NSString *func = @"getTodayCanDs";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&money=%ld",[Manager getUserInfo].userId_,(long)(giftPrice*giftNum)];
    
    [BaseUIViewController showLoadView:YES content:@"正在加载" view:[[UIApplication sharedApplication] keyWindow]];
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        Status_DataModal *dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = result[@"status"];
        dataModal.code_ = result[@"code"];
        dataModal.status_desc = result[@"status_desc"];
        if ([dataModal.status_ isEqualToString:@"OK"]) {
            //请求生成订单，后跳转到支付页面
            [self goPay];
        }
        else if ([dataModal.status_ isEqualToString:@"FAIL"])
        {
            [BaseUIViewController showAlertView:@"" msg:dataModal.status_desc btnTitle:@"确定"];
        }
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

#pragma mark 跳转到支付页面
- (void)goPay
{
    if (!dasangCon) {
        dasangCon = [self getNewRequestCon:NO];
    }
    /**
     * productType:产品类型  1回答，10文章，20社群，30个人主页打赏
     * product_id:产品编号，如文章ID
     */
    
    [dasangCon genShoppingDaShangCartWithServiceCode:@"P_DASHANG" serviceId:giftType userId:[Manager getUserInfo].userId_ tagetUserId:_personId number:payValue productType:_productType productId:_productId];
//    [BaseUIViewController showLoadView:YES content:nil view:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
