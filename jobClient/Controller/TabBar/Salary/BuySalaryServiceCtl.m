//
//  BuySalaryServiceCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BuySalaryServiceCtl.h"
#import "OrderService_DataModal.h"
#import "SalaryCompareOrderListCtl.h"
#import "Order.h"
#import "PayCtl.h"
#import "SalaryCompareQueryListCtl.h"

@interface BuySalaryServiceCtl ()
{
    RequestCon *_addGWCCon;
    Order *_payOrder;
    NSString *_oldCount;
    int kMaxCount;
    
    UIButton *_leftButton; //返回按钮
    UIButton *_rightBtn;  // 比拼记录按钮
    UIButton *_singleBtn;  //单次按钮
    UIButton *_manyBtn;    //套餐按钮
    UIButton *_deleteBtn;   //数量“-”按钮
    UIButton *_addBtn;      //数量“+”按钮
    UILabel *_amountLb;     //总价显示文本
    UIImageView *_salaryImgv;  //小薪观点卡片中的头像
    UIButton *_buyBtn;      // 立即支付按钮
    
    UIButton *_orderBtn;   //我的订单按钮
    UIButton *_orderCountBtn;  // 我的订单红点
    UITextField *_countTF;   //数量中间显示文本
    UIImageView *_singleSelectImgv;  //单次选中的对号图片
    UIImageView *_mangSelectImgv;   //多次选中的对号图片
    UILabel*_xiaoxinLb;        //小薪观点卡片文本框
    
}
@end

@implementation BuySalaryServiceCtl

- (void)viewDidLoad {
     self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-40)];
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:scrollView];
    self.scrollView_ = scrollView;
    
    [self creatUI];
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

-(void)creatUI{
    
#pragma mark - 顶部返回按钮与比拼记录按钮
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0,20,ScreenWidth,40)];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(8,6,44,26);
    _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,19);
    [_leftButton setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_leftButton];

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(ScreenWidth-80,9,72,22);
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightBtn setTitle:@"比拼记录" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"icon_record"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_rightBtn];
    
#pragma mark - 底部支付按钮与我的订单按钮    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-40,ScreenWidth,40)];
    toolBar.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.view addSubview:toolBar];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(-10,0,ScreenWidth+20,1)];
    line.image = [UIImage imageNamed:@"gg_home_line2"];
    [toolBar addSubview:line];
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.frame = CGRectMake(103,6,ScreenWidth-206,30);
    _buyBtn.backgroundColor = UIColorFromRGB(0xE74845);
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_buyBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:_buyBtn];

    _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderBtn.frame = CGRectMake(ScreenWidth-85,0,60,40);
    _orderBtn.backgroundColor = [UIColor clearColor];
    _orderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_orderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [_orderBtn setImage:[UIImage imageNamed:@"icon_order"] forState:UIControlStateNormal];
    _orderBtn.titleEdgeInsets = UIEdgeInsetsMake(18,-4,0,0);
    _orderBtn.imageEdgeInsets = UIEdgeInsetsMake(-12,17,0,0);
    [_orderBtn setTitleColor:UIColorFromRGB(0xAAAAAA) forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:_orderBtn];
    
    _orderCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderCountBtn.frame = CGRectMake(ScreenWidth-50,3,13,13);
    _orderCountBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    _orderCountBtn.backgroundColor = UIColorFromRGB(0xE74845);
    [_orderCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toolBar addSubview:_orderCountBtn];

#pragma mark - 顶部红色背景及图片文案
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,165)];
    headView.backgroundColor = UIColorFromRGB(0xE74845);
    [self.scrollView_ addSubview:headView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,45,320,120)];
    view.backgroundColor = [UIColor clearColor];
    [headView addSubview:view];
    view.center = CGPointMake(headView.center.x,view.center.y);
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(55,7,80,80)];
    image.image = [UIImage imageNamed:@"ios_icon_cxc2"];
    [view addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(186,7,80,80)];
    image.image = [UIImage imageNamed:@"icon_more"];
    [view addSubview:image];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(87,111,17,9)];
    image.image = [UIImage imageNamed:@"ic_downfile"];
    [view addSubview:image];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,93,320,13)];
    lable.text = @"通过比拼，你可以知道自己目前的工资在同行里处在什么水平";
    lable.font = [UIFont systemFontOfSize:10];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = UIColorFromRGB(0xFD999B);
    [view addSubview:lable];

#pragma mark - 中间文本及选择按钮
    lable = [[UILabel alloc] initWithFrame:CGRectMake(18,170,150,40)];
    lable.text = @"请选择购买类型";
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = UIColorFromRGB(0x555555);
    [self.scrollView_ addSubview:lable];
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(18,222,38,22)];
    lable.text = @"可选";
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = UIColorFromRGB(0x555555);
    [self.scrollView_ addSubview:lable];
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(18,272,38,22)];
    lable.text = @"数量";
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = UIColorFromRGB(0x555555);
    [self.scrollView_ addSubview:lable];
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(18,319,38,22)];
    lable.text = @"共计";
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = UIColorFromRGB(0x555555);
    [self.scrollView_ addSubview:lable];
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(53,320,14,22)];
    lable.text = @"¥";
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor = UIColorFromRGB(0xE30F19);
    [self.scrollView_ addSubview:lable];
    
    _amountLb = [[UILabel alloc] initWithFrame:CGRectMake(62,320,200,22)];
    _amountLb.font = [UIFont systemFontOfSize:17];
    _amountLb.textColor = UIColorFromRGB(0xE30F19);
    [self.scrollView_ addSubview:_amountLb];
    
    _singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _singleBtn.frame = CGRectMake(53,218,113,35);
    _singleBtn.backgroundColor = [UIColor whiteColor];
    _singleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_singleBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [_singleBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView_ addSubview:_singleBtn];
    
    _manyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _manyBtn.frame = CGRectMake(179,218,113,35);
    _manyBtn.backgroundColor = [UIColor whiteColor];
    _manyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_manyBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [_manyBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView_ addSubview:_manyBtn];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(268,209,40,16)];
    image.image = [UIImage imageNamed:@"icon_save5yuan"];
    [self.scrollView_ addSubview:image];
    
    _singleSelectImgv = [[UIImageView alloc] initWithFrame:CGRectMake(152,239,14,14)];
    _singleSelectImgv.image = [UIImage imageNamed:@"icon_selected"];
    [self.scrollView_ addSubview:_singleSelectImgv];
    
    _mangSelectImgv = [[UIImageView alloc] initWithFrame:CGRectMake(278,239,14,14)];
    _mangSelectImgv.image = [UIImage imageNamed:@"icon_selected"];
    [self.scrollView_ addSubview:_mangSelectImgv];
    
    _countTF = [[UITextField alloc] initWithFrame:CGRectMake(83,268,40,30)];
    _countTF.delegate = self;
    _countTF.keyboardType = UIKeyboardTypeNumberPad;
    _countTF.textAlignment = NSTextAlignmentCenter;
    _countTF.text = @"1";
    _countTF.font = [UIFont systemFontOfSize:14];
    _countTF.textColor = UIColorFromRGB(0x555555);
    [self.scrollView_ addSubview:_countTF];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(54,268,30,30);
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView_ addSubview:_deleteBtn];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(121,268,30,30);
    _addBtn.backgroundColor = [UIColor whiteColor];
    [_addBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView_ addSubview:_addBtn];
    
#pragma mark - 小薪观点卡片
    UIView *personView = [[UIView alloc] initWithFrame:CGRectMake(0,357,ScreenWidth,70)];
    personView.backgroundColor = [UIColor whiteColor];
    [self.scrollView_ addSubview:personView];
    
    _salaryImgv = [[UIImageView alloc] initWithFrame:CGRectMake(19,15,40,40)];
    [personView addSubview:_salaryImgv];
    
    _xiaoxinLb = [[UILabel alloc] initWithFrame:CGRectMake(68,0,ScreenWidth-76,70)];
    _xiaoxinLb.text = @"小薪观点：想加薪？想升职？你这点的小薪事，肿么可能瞒得过我的火眼金睛！想打探更多同行薪水情况可以找我帮你解决!";
    _xiaoxinLb.font = THIRTEENFONT_CONTENT;
    _xiaoxinLb.textColor = UIColorFromRGB(0x555555);
    _xiaoxinLb.numberOfLines = 3;
    [personView addSubview:_xiaoxinLb];
    
    self.fd_interactivePopDisabled = YES;
    _singleBtn.selected = YES;
    _mangSelectImgv.hidden = YES;
    kMaxCount = 10;
    CALayer *layer = _singleBtn.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.f].CGColor;

    layer = _manyBtn.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer = _deleteBtn.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer = _countTF.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer = _addBtn.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer = _orderCountBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 6.5f;
    
    [_salaryImgv sd_setImageWithURL:[NSURL URLWithString:@"http://img105.job1001.com/myUpload2/201504/11/1428737491_829.jpg"] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"] options:SDWebImageAllowInvalidSSLCertificates];
    layer = _salaryImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 20.f;
    
    [_orderCountBtn setTitle:_orderNum forState:UIControlStateNormal];
    self.scrollView_.alwaysBounceVertical = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 2;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:13], NSParagraphStyleAttributeName:paragraphStyle};
    _xiaoxinLb.attributedText = [[NSAttributedString alloc]initWithString:_xiaoxinLb.text attributes:attributes];
}


-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
//    if (IOS7) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    }else{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _buyBtn.enabled = NO;
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        [BaseUIViewController showAlertView:nil msg:@"需要登录" btnTitle:@"确定"];
        return;
    }
    if (!requestCon_) {
        requestCon_ = [self getNewRequestCon:YES];
        requestCon_.storeType_ = TempStoreType;
    }
    [requestCon_ getSalaryServiceType];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetSalaryServiceInfo:
        {
            _buyBtn.enabled = YES;
            OrderService_DataModal *service1 = dataArr[0];
            OrderService_DataModal *service2 = dataArr[1];
            [_singleBtn setTitle:service1.serviceName forState:UIControlStateNormal];
            [_singleBtn setTitle:service1.serviceName forState:UIControlStateSelected];
            _amountLb.text = [NSString stringWithFormat:@"%@.00", service1.price];
            [_manyBtn  setTitle:service2.serviceName forState:UIControlStateNormal];
            [_manyBtn  setTitle:service2.serviceName forState:UIControlStateSelected];
        }
            break;
        case Request_GenShoppingCart://生成订单
        {
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
                NSInteger count = [_orderCountBtn.titleLabel.text integerValue] + 1;
                [_orderCountBtn setTitle:[NSString stringWithFormat:@"%ld", (long)count] forState:UIControlStateNormal];
                
                [self goPay];
            }
        }
            break;
        default:
            break;
    }
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 10:
        {
            [self goPay];
        }
            break;
        default:
            break;
    }
}

-(void) alertViewCancel:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
        case 10:
        {
        
        }
            break;
        default:
            break;
    }
}

#pragma mark 跳转到支付页面
- (void)goPay
{
    PayCtl *payCtl = [[PayCtl alloc]init];
    payCtl.order = _payOrder;
    [self.navigationController pushViewController:payCtl animated:YES ];
}

- (void)updateCom:(RequestCon *)con
{
  
}

- (void)btnResponse:(id)sender
{
    if (sender == _leftButton){//返回
        [self backBarBtnResponse:sender];
    }
    else if (sender == _rightBtn)
    {
        SalaryCompareQueryListCtl *queryCtl = [[SalaryCompareQueryListCtl alloc]init];
        [self.navigationController pushViewController:queryCtl animated:YES];
        [queryCtl beginLoad:nil exParam:nil];
    }
    else if (sender == _orderBtn){//我的订单
        SalaryCompareOrderListCtl *orderListCtl = [[SalaryCompareOrderListCtl alloc]init];
        [self.navigationController pushViewController:orderListCtl animated:YES];
        [orderListCtl beginLoad:nil exParam:nil];
    }
    else if (sender == _singleBtn){//选择单次
        if (_manyBtn.selected) {
            CALayer *layer = _manyBtn.layer;
            layer.borderColor = [UIColor lightGrayColor].CGColor;
            _mangSelectImgv.hidden = YES;
            _manyBtn.selected = NO;
        }
        if (_singleBtn.selected) {
            return;
        }else{
            CALayer *layer = _singleBtn.layer;
            layer.borderWidth = 0.5;
            layer.borderColor = [UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.f].CGColor;
            _singleSelectImgv.hidden = NO;
            _singleBtn.selected = YES;
            [self calculateMoney];
        }
    }
    else if (sender == _manyBtn){//选择套餐
        if (_singleBtn.selected) {
            CALayer *layer = _singleBtn.layer;
            layer.borderColor = [UIColor lightGrayColor].CGColor;
            _singleSelectImgv.hidden = YES;
            _singleBtn.selected = NO;
        }
        if (_manyBtn.selected) {
            return;
        }else{
            CALayer *layer = _manyBtn.layer;
            layer.borderWidth = 0.5;
            layer.borderColor = [UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.f].CGColor;
            _mangSelectImgv.hidden = NO;
            _manyBtn.selected = YES;
            [self calculateMoney];
        }
        
    }
    else if (sender == _deleteBtn){
        [self addOrDecreaseCount:NO];
    }
    else if (sender == _addBtn){
        [self addOrDecreaseCount:YES];
    }
    else if (sender == _buyBtn)
    {//立即购买
        
        [Manager shareMgr].payType = PayTypeQuerySalary;
        
        if(!_addGWCCon){
            _addGWCCon = [self getNewRequestCon:NO];
        }
        
        OrderService_DataModal *orderService;
        if (_singleBtn.selected) {//选择单次
            orderService = requestCon_.dataArr_[0];
        }else if (_manyBtn.selected){
            orderService = requestCon_.dataArr_[1];
        }
        
        NSString *userId = [Manager getUserInfo].userId_;
        if (!userId) {
            [BaseUIViewController showAlertView:nil msg:@"需要登录" btnTitle:@"确定"];
            return;
        }
        [_addGWCCon genShoppingCartWithServiceCode:orderService.serviceCode serviceId:orderService.resumeId userId:userId number: [_countTF.text intValue] expertId:@""];
    }

}

- (void)addOrDecreaseCount:(BOOL)isAdd
{
    if (_countTF.text == nil || [_countTF.text isEqualToString:@""]) {
        return;
    }
    int count = [_countTF.text intValue];
    if (isAdd) {
        if(count +1>kMaxCount){
            [BaseUIViewController showAutoDismissAlertView:nil msg:@"数量超出范围" seconds:1.5f];
            return;
        }
        count +=1;
    }else{
        count-=1;
        if (count<=0) {
            count = 1;
        }
    }
    _countTF.text = [NSString stringWithFormat:@"%d", count];
    [self calculateMoney];
}

- (void)calculateMoney
{
    double multipleA = 0.0f;
    if (_singleBtn.selected) {
        OrderService_DataModal *service = requestCon_.dataArr_[0];
        multipleA = [service.price floatValue];
    }
    if (_manyBtn.selected) {
        OrderService_DataModal *service = requestCon_.dataArr_[1];
        multipleA = [service.price floatValue];
    }
    int count = [_countTF.text intValue];
    _amountLb.text = [NSString stringWithFormat:@"%.00f.00", multipleA *count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    //    [jobTF_ resignFirstResponder];
    //    [salaryTF_ resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [super keyboardWillHide:notification];
    if (_countTF.text == nil || [_countTF.text isEqualToString:@""]) {
        _countTF.text = @"1";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _oldCount = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text && ![textField.text isEqualToString:@""]) {
        if (![self isPureInt:textField.text]) {
            [BaseUIViewController showAutoDismissAlertView:nil msg:@"数量必须为数字" seconds:1.5f];
            textField.text = _oldCount;
            return;
        }
        if ([textField.text intValue] >kMaxCount) {
            [BaseUIViewController showAutoDismissAlertView:nil msg:@"数量超限" seconds:1.5f];
            textField.text = _oldCount;
            return;
        }
        if ([textField.text intValue] == 0) {
            textField.text = @"1";
        }
        _oldCount = textField.text;
        [self calculateMoney];
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
