//
//  ELRecommendReportDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/11/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELRecommendReportDetailCtl.h"

@interface ELRecommendReportDetailCtl () <UIScrollViewDelegate,UITextViewDelegate>
{
    UIButton *rightButton;
    NSMutableArray *starImageArr;
    UITextView *contentTV;
    NSInteger star;
    UILabel *starLb;
    UILabel *tipsLb;
    UIButton *submitButton;
    UIScrollView *scrollView_;
    UIView *toolbarHolder;
    CGFloat _keyBoardHeight;
    BOOL haveSelectedJob;
}
@end

@implementation ELRecommendReportDetailCtl

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    star = -1;
    haveSelectedJob = YES;
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    toolbarHolder = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-44,ScreenHeight, 44, 30)];
    toolbarHolder.backgroundColor = [UIColor whiteColor];
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    hideButton.frame = CGRectMake(0,0,44,30);
    [hideButton setImage:[UIImage imageNamed:@"ZSSkeyboard"] forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [toolbarHolder addSubview:hideButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6f, 30)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.7f;
    [toolbarHolder addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 0.6f)];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.7f;
    [toolbarHolder addSubview:line2];

    [self.view addSubview:toolbarHolder];
    [self creatUI];
    [self changeDataFillFinish];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [contentTV resignFirstResponder];
}

-(void)creatUI{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,20,ScreenWidth,ScreenHeight-20)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    scrollView_ = scrollView;
    
    CGFloat height = 50;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    lable.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    lable.textColor = UIColorFromRGB(0x212121);
    lable.text = @"推荐报告";
    [lable sizeToFit];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.frame = CGRectMake(0,height,ScreenWidth,lable.height);
    [scrollView addSubview:lable];
    
    height = CGRectGetMaxY(lable.frame)+30;
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = UIColorFromRGB(0x9e9e9e);
    lable.text = @"人才匹配度";
    [lable sizeToFit];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.frame = CGRectMake((ScreenWidth-lable.width-12)/2.0,height,lable.width+12,lable.height);
    [scrollView addSubview:lable];
    
    CGFloat lineW = (ScreenWidth-120-lable.width)/2.0;
    [scrollView_ addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(60,lable.top+7,lineW,1) WithColor:UIColorFromRGB(0xe0e0e0)]]; 
    [scrollView_ addSubview:[[ELLineView alloc] initWithFrame:CGRectMake(lable.right,lable.top+7,lineW,1) WithColor:UIColorFromRGB(0xe0e0e0)]];
    
    height = CGRectGetMaxY(lable.frame)+16;
    
    starImageArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0;i<3;i++){
        CGFloat starX = (ScreenWidth-99-32)/2;
        starX += 49*i;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(starX,height,33,33)];
        image.image = [UIImage imageNamed:@"recommend_star_grey"];
        image.tag = 1000+i;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starTap:)]];
        [scrollView addSubview:image];
        [starImageArr addObject:image];
    }
    height += 41;
    
    starLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    starLb.font = [UIFont systemFontOfSize:12];
    starLb.textColor = UIColorFromRGB(0xbdbdbd);
    starLb.text = @"请选择人才与职位的匹配度";
    [starLb sizeToFit];
    starLb.textAlignment = NSTextAlignmentCenter;
    starLb.frame = CGRectMake(0,height,ScreenWidth,starLb.height);
    [scrollView addSubview:starLb];
    
    height = CGRectGetMaxY(starLb.frame)+18;
    
    CGFloat starX = 40;
    
    contentTV = [[UITextView alloc] initWithFrame:CGRectMake(starX,height,ScreenWidth-80,110)];
    contentTV.font = [UIFont systemFontOfSize:12];
    contentTV.textColor = UIColorFromRGB(0x212121);
    contentTV.delegate = self;
    contentTV.layer.cornerRadius = 2.0;
    contentTV.layer.borderWidth = 1.0;
    contentTV.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    contentTV.layer.masksToBounds = YES;
    [scrollView addSubview:contentTV];
    
    tipsLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0,contentTV.width-26,0)];
    tipsLb.font = [UIFont systemFontOfSize:12];
    tipsLb.numberOfLines = 0;
    tipsLb.textColor = UIColorFromRGB(0xe0e0e0);
    tipsLb.text = @"用一段话描述一下这位候选人的情况(150字以内)";
    [tipsLb sizeToFit];
    tipsLb.frame = CGRectMake(contentTV.left+13,contentTV.top+6,contentTV.width-26,tipsLb.height);
    [scrollView addSubview:tipsLb];
    
    height = CGRectGetMaxY(contentTV.frame)+17;
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,30)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = UIColorFromRGB(0x9e9e9e);
    lable.text = @"为TA推荐";
    [lable sizeToFit];
    lable.frame = CGRectMake(starX,height,ScreenWidth,lable.height);
    [scrollView addSubview:lable];
    
    height = CGRectGetMaxY(lable.frame)+14;
    
    CGFloat lableW = (ScreenWidth-(2*starX)-10)/2;
    CGFloat maxY = 0;
    for (NSInteger i = 0;i<_selectArr.count;i++) {
        NSInteger line = i/2;
        NSInteger list = i%2;
        CGFloat viewX = starX+(lableW+10)*list;
        CGFloat viewY = height+37*line;
        ELCompanyInfoModel *model = _selectArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 200+i;
        button.frame = CGRectMake(viewX,viewY,lableW,27);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.contentEdgeInsets = UIEdgeInsetsMake(0,8,0,8);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:[NSString stringWithFormat:@" %@",model.job_name] forState:UIControlStateNormal];
        [self changeButton:button styleWithRed:YES];
        [button addTarget:self action:@selector(changeJobRespone:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        maxY = CGRectGetMaxY(button.frame);
    }

    height = maxY+27;
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(25,height,ScreenWidth-50,45);
    submitButton.layer.cornerRadius = 4.0;
    submitButton.layer.masksToBounds = YES;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:UIColorFromRGB(0xff3333)];
    [self setDataFinish:NO];
    [scrollView addSubview:submitButton];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth,CGRectGetMaxY(submitButton.frame)+30);
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(7,20,44,44);
    [rightButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

-(void)backBarBtnResponse:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitBtnRespone:(UIButton *)button{
    NSMutableArray *tj_listDic = [[NSMutableArray alloc] init];
    
    for (ELCompanyInfoModel *model in _selectArr) {
        if (!model.isCancel) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:model.jobfair_id forKey:@"jobfair_id"];
            [dic setObject:model.job_id forKey:@"job_id"];
            [dic setObject:model.uId forKey:@"uid"];
            [tj_listDic addObject:dic];
        }
    }
    SBJsonWriter * jsontj_list = [[SBJsonWriter alloc] init];
    NSString *tj_listStr = [jsontj_list stringWithObject:tj_listDic];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [resultDic setObject:[NSString stringWithFormat:@"%ld",(long)(star+1)] forKey:@"star"];
    [resultDic setObject:contentTV.text forKey:@"reason"];
    SBJsonWriter * jsonresult = [[SBJsonWriter alloc] init];
    NSString *resultStr = [jsonresult stringWithObject:resultDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"sa_user_id=%@&u_user=%@&person_id=%@&tj_list=%@&resultConditionArr=%@",_salerId,[Manager getHrInfo].userName,_userId,tj_listStr,resultStr];
    
    [ELRequest newPostbodyMsg:bodyMsg op:@"app_jjr_api_busi" func:@"recommendPersonToJob" requestVersion:YES progressFlag:YES progressMsg:@"正在提交..." success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *status = dic[@"status"];
            NSString *desc = dic[@"status_desc"];
            if ([status isEqualToString:@"OK"]) {
                [BaseUIViewController showAlertViewContent:@"推荐成功" toView:nil second:1.0 animated:NO];
                if ([_refreshDelegate respondsToSelector:@selector(recommentSuccessRefresh)]) {
                    [_refreshDelegate recommentSuccessRefresh];
                }
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [BaseUIViewController showAlertViewContent:desc toView:nil second:1.0 animated:NO];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)starTap:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag-1000;
    if(index < starImageArr.count){
        star = index;   
        for (NSInteger i = 0;i<starImageArr.count;i++){
            UIImageView *image = starImageArr[i];
            if (i <= index){
                image.image = [UIImage imageNamed:@"recommend_star_yellow"];
            }else{
                image.image = [UIImage imageNamed:@"recommend_star_grey"];
            }
        }
        NSArray *arr = @[@"基本匹配",@"比较匹配",@"非常匹配"];
        starLb.text = arr[star];
        starLb.textColor = UIColorFromRGB(0xff3333);
    }
    [self changeDataFillFinish];
}

-(void)changeJobRespone:(UIButton *)button{
    NSInteger index = button.tag - 200;
    if (index < _selectArr.count) {
        ELCompanyInfoModel *model = _selectArr[index];
        [self changeButton:button styleWithRed:model.isCancel];
        model.isCancel = !model.isCancel;
    }
    haveSelectedJob = NO;
    for (ELCompanyInfoModel *model in _selectArr) {
        if (!model.isCancel) {
            haveSelectedJob = YES;
            break;
        }
    }
    [self changeDataFillFinish];
}

-(void)changeButton:(UIButton *)button styleWithRed:(BOOL)red{
    if (red){
        [button setTitleColor:UIColorFromRGB(0xff3333) forState:UIControlStateNormal];
        button.layer.cornerRadius = 4.0;
        button.layer.borderColor = UIColorFromRGB(0xff3333).CGColor;
        button.layer.borderWidth = 1.0;
        button.layer.masksToBounds = YES;
        [button setImage:[UIImage imageNamed:@"choose_these"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    }else{
        [button setTitleColor:UIColorFromRGB(0x212121) forState:UIControlStateNormal];
        button.layer.cornerRadius = 4.0;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.borderWidth = 0.0;
        button.layer.masksToBounds = YES;
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    }
}

#pragma mark - 监测文本框内容变化
-(void)textChanged:(UITextView *)textView{
    if (contentTV.isFirstResponder){
        [self changeDataFillFinish];
    }
}

#pragma mark - 修改提交按钮的状态
-(void)setDataFinish:(BOOL)isFinish{
    if (isFinish) {
        [submitButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        [submitButton setTitleColor:UIColorFromRGB(0xffbebe) forState:UIControlStateNormal];
    }
}

-(void)changeDataFillFinish{
    BOOL isFinish = NO;
    NSString *str = [contentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(str.length > 0 && haveSelectedJob && star != -1){
        isFinish = YES;
    }
    submitButton.enabled = isFinish;
    [self setDataFinish:isFinish];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == contentTV) {
        if (textView.text.length <= 0) {
            tipsLb.hidden = NO;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == contentTV){
        tipsLb.hidden = YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView == contentTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:contentTV wordsNum:150];
    }
    [textView scrollRangeToVisible:textView.selectedRange];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [self showKeyBoardButtonWithBool:NO];
    CGRect frame = scrollView_.frame;
    frame.size.height = ScreenHeight-20;
    scrollView_.frame = frame;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyBoardHeight = [aValue CGRectValue].size.height;
    [self showKeyBoardButtonWithBool:YES];
    CGRect frame = scrollView_.frame;
    frame.size.height = ScreenHeight-20-_keyBoardHeight;
    scrollView_.frame = frame;
    CGFloat height = CGRectGetMaxY(contentTV.frame)+20-(ScreenHeight-_keyBoardHeight);
    if (height > 0) {
        if (scrollView_.contentOffset.y < height) {
            scrollView_.contentOffset = CGPointMake(0,height);
        }
    }
}

-(void)showKeyBoardButtonWithBool:(BOOL)show{
    if (show) {
        [self.view bringSubviewToFront:toolbarHolder];
        CGRect frame = toolbarHolder.frame;
        frame.origin.y = self.view.frame.size.height - (_keyBoardHeight + toolbarHolder.frame.size.height);
        toolbarHolder.frame = frame;
    }else{
        CGRect frame = toolbarHolder.frame;
        frame.origin.y = self.view.frame.size.height;
        toolbarHolder.frame = frame;
    }
}

-(void)dismissKeyboard{
    [contentTV resignFirstResponder];
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
