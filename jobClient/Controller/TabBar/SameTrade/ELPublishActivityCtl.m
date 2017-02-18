//
//  ELPublishActivityCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/15.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELPublishActivityCtl.h"
#import "ELActivitySuccessAlertView.h"
#import "ELChangeDateCtl.h"

@interface ELPublishActivityCtl () <UITextFieldDelegate,UITextViewDelegate>
{
    //背景scrollview
    UIScrollView *scrollView_;
    
    /*
        从上到下六个卡片的view 及底部的label
     */
    UIView *backViewOne;
    UIView *backViewTwo;
    UIView *backViewThree;
    UIView *backViewFour;
    UIView *backVIewFive;
    UIView *backViewSix;
    UILabel *bottomLable;
    
    //活动主题未输入时的提示文案
    UILabel *titleTipsLb;
    
    //活动介绍
    UITextView *activityContentTV;
    //活动主题
    UITextView *activityTitleTF;
    //活动地址及具体地址
    UITextField *activityPlaceTF;
    UITextField *activityDetailPlaceTF;
    
    //开始、结束、截止时间
    UITextField *startTimeTF;
    UITextField *finishTimeTF;
    UITextField *overTimeTF;
    
    //当前选择的活动地点的id
    NSString *placeId;
    
    //是否创建社群的两个按钮
    ELBaseButton *noCreatGroupBtn;
    ELBaseButton *isCreatGroupBtn;
    //是否需要报名的两个按钮
    ELBaseButton *isRegister;
    ELBaseButton *noRegister;

    //日期选择控件
    ELChangeDateCtl *changeDateCtl;
    
    ELRequest *elRequest;
    
    /*
     标识提交请求是否完成
     作用：请求未完成时提交按钮不可点
     */
    BOOL finishLoadStatus;
    
    //键盘高度
    CGFloat keyBoardHeight;
    //键盘是否弹出
    BOOL showKeyBoard;
    
    //键盘弹出时相关
    UIView *viewTF;
    id textTF;
}
@end

@implementation ELPublishActivityCtl

- (instancetype)init
{
    self = [super init];
    if (self){
        keyBoardHeight = 0;
        [self creatUI];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"发布活动"];
    [[self getNoNetworkView] removeFromSuperview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)creatUI{
    scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-64)];
    scrollView_.backgroundColor = UIColorFromRGB(0xEFEFF4);
    scrollView_.userInteractionEnabled = YES;
    [scrollView_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
    scrollView_.contentSize = CGSizeMake(ScreenWidth,625);
    [self.view addSubview:scrollView_];
    
    backViewOne = [self getBackViewWithFrame:CGRectMake(8,8,ScreenWidth-16,170)];
    UIView *view = [self getContentViewWithFrame:CGRectMake(0,0,ScreenWidth-16,50) showImg:NO showline:NO content:@"活动主题" lineX:75 lineH:20];
    activityTitleTF = [self getTextViewWithFrame:CGRectMake(87,15,ScreenWidth-116,20) font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
    activityTitleTF.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    [view addSubview:activityTitleTF];
    
    titleTipsLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"请输入活动主题（17字以内）" textColor:UIColorFromRGB(0xC5C2C4) Target:nil action:nil frame:CGRectMake(90,17,ScreenWidth-116, 17)];
    [view addSubview:titleTipsLb];
    [backViewOne addSubview:view];
    
    view = [self getContentViewWithFrame:CGRectMake(0,50,ScreenWidth-16,40) showImg:YES showline:YES content:@"开始时间" lineX:75 lineH:20];
    startTimeTF = [self getTextFieldWithFrame:CGRectMake(90,5,ScreenWidth-116,30) font:[UIFont systemFontOfSize:14] placeholder:@"请选择开始时间" color:[UIColor blackColor]];
    [view addSubview:startTimeTF];
    [backViewOne addSubview:view];
    
    view = [self getContentViewWithFrame:CGRectMake(0,90,ScreenWidth-16,40) showImg:YES showline:YES content:@"结束时间" lineX:75 lineH:20];
    finishTimeTF = [self getTextFieldWithFrame:CGRectMake(90,5,ScreenWidth-116,30) font:[UIFont systemFontOfSize:14] placeholder:@"请选择结束时间" color:[UIColor blackColor]];
    [view addSubview:finishTimeTF];
    [backViewOne addSubview:view];
    
    view = [self getContentViewWithFrame:CGRectMake(0,130,ScreenWidth-16,40) showImg:YES showline:YES content:@"报名截止" lineX:75 lineH:20];
    overTimeTF = [self getTextFieldWithFrame:CGRectMake(90,5,ScreenWidth-116,30) font:[UIFont systemFontOfSize:14] placeholder:@"请选择报名截止时间" color:[UIColor blackColor]];
    [view addSubview:overTimeTF];
    [backViewOne addSubview:view];
    
    [scrollView_ addSubview:backViewOne];
    
    backViewTwo = [self getBackViewWithFrame:CGRectMake(8,CGRectGetMaxY(backViewOne.frame)+8,ScreenWidth-16,80)];
    view = [self getContentViewWithFrame:CGRectMake(0,0,ScreenWidth-16,40) showImg:NO showline:NO content:@"活动地点" lineX:75 lineH:20];
    activityPlaceTF = [self getTextFieldWithFrame:CGRectMake(90,5,ScreenWidth-116,30) font:[UIFont systemFontOfSize:14] placeholder:@"请选择活动地点" color:[UIColor blackColor]];
    [view addSubview:activityPlaceTF];
    [backViewTwo addSubview:view];
    
    view = [self getContentViewWithFrame:CGRectMake(0,40,ScreenWidth-16,40) showImg:NO showline:YES content:@"具体地址" lineX:75 lineH:20];
    activityDetailPlaceTF = [self getTextFieldWithFrame:CGRectMake(90,5,ScreenWidth-116,30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入活动具体地址" color:[UIColor blackColor]];
    [activityDetailPlaceTF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:activityDetailPlaceTF];
    [backViewTwo addSubview:view];
    
    [scrollView_ addSubview:backViewTwo];
    
    backViewThree = [self getBackViewWithFrame:CGRectMake(8,CGRectGetMaxY(backViewTwo.frame)+8,ScreenWidth-16,80)];
    view = [self getContentViewWithFrame:CGRectMake(0,0,ScreenWidth-16,80) showImg:NO showline:NO content:@"活动介绍" lineX:75 lineH:20];
    activityContentTV = [self getTextViewWithFrame:CGRectMake(90,10,ScreenWidth-116,60) font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
    [view addSubview:activityContentTV];
    [backViewThree addSubview:view];
    [scrollView_ addSubview:backViewThree];
    
    backViewFour = [self getBackViewWithFrame:CGRectMake(8,CGRectGetMaxY(backViewThree.frame)+8,ScreenWidth-16,40)];
    view = [self getContentViewWithFrame:CGRectMake(0,0,ScreenWidth-16,40) showImg:NO showline:NO content:@"是否需要报名" lineX:106 lineH:20];
    
    isRegister = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:15] title:@"是" textColor:[UIColor whiteColor] Target:self action:@selector(registerChangeBtnRespone:) frame:CGRectMake(120,8,38,25)];
    [isRegister setLayerCornerRadius:3.0];
    [isRegister setBorderWidth:1.0 borderColor:[UIColor clearColor]];
    isRegister.selected = YES;
    [view addSubview:isRegister];
    
    noRegister = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:15] title:@"否" textColor:[UIColor whiteColor] Target:self action:@selector(registerChangeBtnRespone:) frame:CGRectMake(173,8,38,25)];
    [noRegister setLayerCornerRadius:3.0];
    [noRegister setBorderWidth:1.0 borderColor:[UIColor clearColor]];
    [view addSubview:noRegister];
    
    
    [backViewFour addSubview:view];
    [scrollView_ addSubview:backViewFour];
    
    backVIewFive = [self getBackViewWithFrame:CGRectMake(8,CGRectGetMaxY(backViewFour.frame)+8,ScreenWidth-16,80)];
    view = [self getContentViewWithFrame:CGRectMake(0,0,ScreenWidth-16,80) showImg:NO showline:NO content:@"希望报名者填写那些信息" lineX:106 lineH:60];
    NSArray *nameArr = @[@"姓名",@"手机",@"公司",@"部门",@"职务",@"邮箱",@"留言"];
    for (NSInteger i = 0;i<nameArr.count;i++){
        CGFloat frameX = 120+((i%4)*(38+8));
        CGFloat frameY = 11+((i/4)*(25+8));
        ELBaseButton *changeButton = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:13] title:nameArr[i] textColor:[UIColor blackColor] Target:self action:@selector(setChangeBtnRespone:) frame:CGRectMake(frameX,frameY,38,25)];
        changeButton.tag = 101+i;
        [changeButton setLayerCornerRadius:3.0];
        [changeButton setBorderWidth:1.0 borderColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
        changeButton.selected = NO;  
        changeButton.backgroundColor = [UIColor whiteColor];
        [view addSubview:changeButton];
    }
    
    [backVIewFive addSubview:view];
    [scrollView_ addSubview:backVIewFive];
    
    
    backViewSix = [self getBackViewWithFrame:CGRectMake(8,CGRectGetMaxY(backVIewFive.frame)+8,ScreenWidth-16,66)];
    view = [self getContentViewWithFrame:CGRectMake(0,0,ScreenWidth-16,66) showImg:NO showline:NO content:@"是否创建活动社群" lineX:106 lineH:38];
    
    isCreatGroupBtn = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:15] title:@"是" textColor:[UIColor whiteColor] Target:self action:@selector(registerChangeBtnRespone:) frame:CGRectMake(120,20,38,25)];
    [isCreatGroupBtn setLayerCornerRadius:3.0];
    [isCreatGroupBtn setBorderWidth:1.0 borderColor:[UIColor clearColor]];
    isCreatGroupBtn.selected = YES;
    [view addSubview:isCreatGroupBtn];
    
    noCreatGroupBtn = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:15] title:@"否" textColor:[UIColor whiteColor] Target:self action:@selector(registerChangeBtnRespone:) frame:CGRectMake(173,20,38,25)];
    [noCreatGroupBtn setLayerCornerRadius:3.0];
    [noCreatGroupBtn setBorderWidth:1.0 borderColor:[UIColor clearColor]];
    [view addSubview:noCreatGroupBtn];
    
    [backViewSix addSubview:view];
    [scrollView_ addSubview:backViewSix];
    
    bottomLable = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:13] title:@"用户报名成功后默认自动加入“交流群”" textColor:UIColorFromRGB(0x888888) Target:nil action:nil frame:CGRectMake(8,CGRectGetMaxY(backViewSix.frame)+12,ScreenWidth-16,0)];
    bottomLable.numberOfLines = 0;
    [bottomLable sizeToFit];
    bottomLable.frame = CGRectMake(8,CGRectGetMaxY(backViewSix.frame)+12,ScreenWidth-16,bottomLable.frame.size.height);

    [scrollView_ addSubview:bottomLable];
    
    [self registerChangeBtnRespone:isRegister];
    [self registerChangeBtnRespone:isCreatGroupBtn];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn setFrame:CGRectMake(0, 0, 45, 31)];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBarBtn addTarget:self action:@selector(rightBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];

}

-(UITextView *)getTextViewWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.delegate = self;
    textView.font = font;
    textView.textColor = color;
    return textView;
}

-(UITextField *)getTextFieldWithFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder color:(UIColor *)color{
    UITextField *textF = [[UITextField alloc] initWithFrame:frame];
    textF.delegate = self;
    textF.font = font;
    textF.textColor = color;
    textF.placeholder = placeholder;
    return textF;
}

-(UIView *)getBackViewWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4.0;
    view.clipsToBounds = YES;
    view.layer.masksToBounds = YES;
    return view;
}

-(UIView *)getContentViewWithFrame:(CGRect)frame showImg:(BOOL)showImg showline:(BOOL)showLine content:(NSString *)content lineX:(CGFloat)lineX lineH:(CGFloat)lineH{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    ELBaseLabel *lable = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:15] title:content textColor:[UIColor blackColor] Target:nil action:nil frame:CGRectMake(8,0,lineX-10,0)];
    lable.numberOfLines = 0;
    [lable sizeToFit];
    lable.frame = CGRectMake(8,0,lineX-10,lable.frame.size.height);
    lable.center = CGPointMake(lable.center.x,view.height/2.0);
    [view addSubview:lable];
    
    UIImageView *vertacalLine = [[UIImageView alloc] initWithFrame:CGRectMake(lineX,0,1,lineH)];
    vertacalLine.image = [UIImage imageNamed:@"applayGrayLine"];
    vertacalLine.center = CGPointMake(vertacalLine.center.x,view.height/2.0);
    [view addSubview:vertacalLine];
    
    if (showLine){
        UIImageView *levelLine = [[UIImageView alloc] initWithFrame:CGRectMake(-10,0,ScreenWidth-6,1)];
        levelLine.image = [UIImage imageNamed:@"gg_home_line2"];
        [view addSubview:levelLine];
    }
    
    if (showImg){
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40,0,7,13)];
        rightImg.image = [UIImage imageNamed:@"icon_jiantou"];
        rightImg.center = CGPointMake(rightImg.center.x,view.height/2.0);
        [view addSubview:rightImg];
    }
    return view;
}

-(void)hideKeyBoardOne
{
    [activityTitleTF resignFirstResponder];
    [activityDetailPlaceTF resignFirstResponder];
    [activityContentTV resignFirstResponder];
}

-(void)keyBoardShow:(NSNotification *)notification
{
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight = keyboardRect.size.height;
    
    CGRect frame;
    if ([textTF isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)textTF;
        frame = tf.frame;
    }
    else
    {
        UITextView *tf = (UITextView *)textTF;
        frame = tf.frame;
    }
    
    CGRect rect1 = [viewTF convertRect:frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyBoardHeight - 66))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyBoardHeight - 66));
        scrollView_.contentOffset = CGPointMake(0,height + scrollView_.contentOffset.y);
    }
    scrollView_.contentInset = UIEdgeInsetsMake(0,0,keyBoardHeight,0);
}

-(void)keyBoardHide:(NSNotification *)notification
{
    showKeyBoard = NO;
    scrollView_.contentInset = UIEdgeInsetsZero;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textTF = textField;
    if (textField == activityPlaceTF) {
        
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        vc.blockString = ^(SqlitData *regionModel)
        {
            activityPlaceTF.text = regionModel.provinceName;
            placeId = regionModel.provinceld;
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    if (textField == startTimeTF || textField == finishTimeTF || textField == overTimeTF)
    {
        [self hideKeyBoardOne];
        if (!changeDateCtl)
        {
            changeDateCtl = [[ELChangeDateCtl alloc] init];
            changeDateCtl.showTodayBtn = NO;
            changeDateCtl.showMinDate = YES;
            changeDateCtl.pickerMode = UIDatePickerModeDateAndTime;
        } 
        [changeDateCtl showViewCtlCurrentDate:nil WithBolck:^(CondictionList_DataModal *dataModal)
         {
             UITextField *tf = (UITextField *)textTF;
             NSString *str = [dataModal.changeDate stringWithFormatDefault];
             tf.text = [str substringToIndex:16];
         }];
        return NO;
    }
    
    UIView *view = textField.superview;
    CGRect rect1 = [view convertRect:textField.frame toView:self.view];
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyBoardHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyBoardHeight - 64));
        scrollView_.contentOffset = CGPointMake(0,height + scrollView_.contentOffset.y);
    }
    return YES;
}

- (void)TextFieldDidChange:(UITextField *)textfield
{
    if (textfield == activityDetailPlaceTF) {
        [MyCommon limitTextFieldTextNumberWithTextField:activityDetailPlaceTF wordsNum:200 numLb:nil];
    }
    
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIView *view = textView.superview;
    CGRect rect1 = [view convertRect:textView.frame toView:self.view];
    textTF = textView;
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyBoardHeight - 64) && showKeyBoard)
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyBoardHeight - 64)) + 40;
        scrollView_.contentOffset = CGPointMake(0,height + scrollView_.contentOffset.y);
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == activityTitleTF) {
        if (textView.text.length <= 0) {
            titleTipsLb.hidden = NO;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == activityTitleTF) {
        titleTipsLb.hidden = YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView == activityTitleTF)
    {
        [MyCommon dealLabNumWithTipLb:titleTipsLb numLb:nil textView:activityTitleTF wordsNum:17];
        
        NSString *str = [NSString stringWithFormat:@"用户报名成功后默认自动加入“%@交流群”",activityTitleTF.text];
        bottomLable.text = str;
        [bottomLable sizeToFit];
        bottomLable.frame = CGRectMake(8,CGRectGetMaxY(backViewSix.frame)+12,ScreenWidth-16,bottomLable.frame.size.height);
        
        CGRect frame = activityTitleTF.frame;
        if (activityTitleTF.contentSize.height > 25) {
            frame.origin.y = 8;
            frame.size.height = 35;
        }else{
            frame.origin.y = 15;
            frame.size.height = 20;
        }
        activityTitleTF.frame = frame;
    }else if(textView == activityContentTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:activityContentTV wordsNum:2000];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if(textView == activityTitleTF)
    {
        [activityTitleTF scrollRangeToVisible:NSMakeRange(activityTitleTF.text.length, 1)];
    }
}

- (void)setChangeBtnRespone:(UIButton *)sender
{
    if (!sender.selected)
    {
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = PINGLUNHONG;
        sender.selected = YES;
    }
    else
    {
        sender.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor whiteColor];
        sender.selected = NO;
    }
}

- (void)registerChangeBtnRespone:(UIButton *)sender
{
    if (sender == isRegister){
        [self changeBtnColor:isRegister withBool:YES];
        [self changeBtnColor:noRegister withBool:NO];
        backVIewFive.hidden = NO;
        isRegister.selected = YES;
        CGRect frame = backViewSix.frame;
        frame.origin.y = CGRectGetMaxY(backVIewFive.frame)+8;
        backViewSix.frame = frame;
        frame = bottomLable.frame;
        frame.origin.y = CGRectGetMaxY(backViewSix.frame)+12;
        bottomLable.frame = frame;
        
    }else if(sender == noRegister){
        [self changeBtnColor:isRegister withBool:NO];
        [self changeBtnColor:noRegister withBool:YES];
        backVIewFive.hidden = YES;
        isRegister.selected = NO;
        CGRect frame = backViewSix.frame;
        frame.origin.y = CGRectGetMaxY(backViewFour.frame)+8;
        backViewSix.frame = frame;
        frame = bottomLable.frame;
        frame.origin.y = CGRectGetMaxY(backViewSix.frame)+12;
        bottomLable.frame = frame;
    }else if (sender == isCreatGroupBtn){
        [self changeBtnColor:isCreatGroupBtn withBool:YES];
        [self changeBtnColor:noCreatGroupBtn withBool:NO];
        isCreatGroupBtn.selected = YES;
        bottomLable.hidden = NO;
    }else if (sender == noCreatGroupBtn){
        [self changeBtnColor:isCreatGroupBtn withBool:NO];
        [self changeBtnColor:noCreatGroupBtn withBool:YES];
        isCreatGroupBtn.selected = NO;
        bottomLable.hidden = YES;
    }
}

-(void)changeBtnColor:(UIButton *)button withBool:(BOOL)isChange{
    if (isChange) {
        button.layer.borderColor = [UIColor clearColor].CGColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = PINGLUNHONG;
    }else{
        button.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0].CGColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)rightBarBtn:(UIButton *)sender
{
    if (finishLoadStatus) {
        return;
    }
    if ([[activityTitleTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写活动主题" btnTitle:@"确定"];
        return;
    }
    else if([[startTimeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写活动开始时间" btnTitle:@"确定"];
        return;
    }
    else if([[finishTimeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写活动结束时间" btnTitle:@"确定"];
        return;
    }
    else if([[overTimeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写报名截止时间" btnTitle:@"确定"];
        return;
    }
    else if([[activityPlaceTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请选择活动地点" btnTitle:@"确定"];
        return;
    }
    else if([[activityDetailPlaceTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写具体活动地址" btnTitle:@"确定"];
        return;
    }
    else if([[activityContentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [BaseUIViewController showAlertView:nil msg:@"请填写活动介绍" btnTitle:@"确定"];
        return;
    }
    
    NSString *publishMessageStr = @"";
    if(isRegister.selected == YES)
    {
        NSMutableArray *arrList = [[NSMutableArray alloc] initWithArray:@[@"gaae_name",@"gaae_contacts",@"company",@"group",@"jobs",@"email",@"remark"]];
        
        for (NSInteger i = 0; i< 7; i++)
        {
            UIButton *btn = (UIButton *)[backVIewFive viewWithTag:101+i];
            if (btn.selected == YES) {
                if (publishMessageStr.length == 0)
                {
                    publishMessageStr = arrList[i];
                }
                else
                {
                    publishMessageStr = [NSString stringWithFormat:@"%@,%@",publishMessageStr,arrList[i]];
                }
            }
        }
        if([publishMessageStr isEqualToString:@""])
        {
            [BaseUIViewController showAlertView:nil msg:@"请选择希望报名者填写哪些信息" btnTitle:@"确定"];
            return;
        }
    }
    
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:activityTitleTF.text forKey:@"title"];
    [conditionDic setObject:placeId forKey:@"regionid"];
    [conditionDic setObject:activityDetailPlaceTF.text forKey:@"address"];
    [conditionDic setObject:activityContentTV.text forKey:@"intro"];
    [conditionDic setObject:startTimeTF.text forKey:@"start_time"];
    [conditionDic setObject:finishTimeTF.text forKey:@"end_time"];
    [conditionDic setObject:overTimeTF.text forKey:@"last_join_time"];
    if (isRegister.selected == YES) {
        [conditionDic setObject:@"1" forKey:@"need_join"];
        [conditionDic setObject:publishMessageStr forKey:@"need_info"];
    }
    else
    {
        [conditionDic setObject:@"0" forKey:@"need_join"];
        [conditionDic setObject:@"" forKey:@"need_info"];
    }
    if (isCreatGroupBtn.selected) {
        [conditionDic setObject:@"3" forKey:@"activity_groups"];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&info=%@",userId,conditionDicStr];
    NSString * function = @"add_activity_info";
    NSString * op = @"salarycheck_all_busi";
    finishLoadStatus = YES;
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        NSString *status = dic[@"status"];
        NSString *des = dic[@"status_desc"];
        if ([status isEqualToString:@"OK"])
        {
            //[BaseUIViewController showAutoDismissSucessView:@"" msg:des seconds:1.0];
            Article_DataModal *modal = [[Article_DataModal alloc] init];
            modal.title_ = activityTitleTF.text;
            modal.summary_ = activityContentTV.text;
            modal.id_ = dic[@"article_id"];
            [[ELActivitySuccessAlertView activitySuccessView] showWithPublishSuccessArticleModal:modal];
            [self hideKeyBoardOne];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:@"" msg:des seconds:1.0];
        }
        finishLoadStatus = NO;
  
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showAutoDismissAlertView:@"" msg:@"发布报名失败,请稍后再试" seconds:1.0];
        finishLoadStatus = NO;
    }];
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
