//
//  ELCreateCourseCtl.m
//  jobClient
//
//  Created by YL1001 on 15/10/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELCreateCourseCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELExpertCourseListCtl.h"
#import "RewardOtherAmountCtl.h"
#import "CreateCourseOtherBtnCtl.h"

@interface ELCreateCourseCtl ()
{
    NSString *courseTime;
    NSString *coursePrice;
    NSString *CourseStatu;
    
    IBOutlet UIButton *delectBtn;
    IBOutlet UIButton *saveCourseBtn;
    ELAspectantDiscuss_Modal *courseData;
    NSInteger btnTag;
    
    ELRequest *addCourseRequest;
    ELRequest *delectCourseRequest;
    
    IBOutlet NSLayoutConstraint *_delectBtnAutoWidth;
    IBOutlet NSLayoutConstraint *_delectBtnAutoLeading;
    
    IBOutlet NSLayoutConstraint *_saveBtnAutoWidth;
    IBOutlet NSLayoutConstraint *_saveBtnAutoTrailling;
}
@end

@implementation ELCreateCourseCtl

- (id)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"保存草稿";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"创建话题"];
    
    titleBgView.layer.cornerRadius = 8.0;
    titleBgView.layer.masksToBounds = YES;
    
    timeBgView.layer.cornerRadius = 8.0;
    timeBgView.layer.masksToBounds = YES;
    
    priceBgView.layer.cornerRadius = 8.0;
    priceBgView.layer.masksToBounds = YES;
    
    contentBgView.layer.cornerRadius = 8.0;
    contentBgView.layer.masksToBounds = YES;
    
    titleTV.layer.borderWidth = 0.5;
    titleTV.layer.borderColor = GRAYCOLOR.CGColor;
    
    contentTV.layer.borderWidth = 0.5;
    contentTV.layer.borderColor = GRAYCOLOR.CGColor;
    
    hoursBtnOne.layer.borderWidth = 1;
    hoursBtnOne.layer.cornerRadius = 8.0;
    hoursBtnOne.layer.borderColor = [UIColor redColor].CGColor;
    
    hoursBtnTwo.layer.borderWidth = 1;
    hoursBtnTwo.layer.cornerRadius = 8.0;
    hoursBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
    
    hoursBtnthree.layer.borderWidth = 1;
    hoursBtnthree.layer.cornerRadius = 8.0;
    hoursBtnthree.layer.borderColor = [UIColor grayColor].CGColor;
    
    otherTimeBtn.layer.borderWidth = 1;
    otherTimeBtn.layer.cornerRadius = 8.0;
    otherTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    priceBtnOne.layer.borderWidth = 1;
    priceBtnOne.layer.cornerRadius = 8.0;
    priceBtnOne.layer.borderColor = [UIColor redColor].CGColor;
    
    priceBtnTwo.layer.borderWidth = 1;
    priceBtnTwo.layer.cornerRadius = 8.0;
    priceBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
    
    priceBtnThree.layer.borderWidth = 1;
    priceBtnThree.layer.cornerRadius = 8.0;
    priceBtnThree.layer.borderColor = [UIColor grayColor].CGColor;
    
    otherPriceBtn.layer.borderWidth = 1;
    otherPriceBtn.layer.cornerRadius = 8.0;
    otherPriceBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    delectBtn.layer.cornerRadius = 4.0;
    delectBtn.layer.masksToBounds = YES;
    
    saveCourseBtn.layer.cornerRadius = 4.0;
    saveCourseBtn.layer.masksToBounds = YES;
    
    courseTime = @"1小时内";
    coursePrice = @"299元/次";
    CourseStatu = nil;
    delectBtn.hidden = YES;

    
    CGRect contentFrame = contentBgView.frame;
    contentFrame.origin.y = CGRectGetMaxY(tips3.frame) + 8;
    contentBgView.frame = contentFrame;
    
    CGRect btnFrame = delectBtn.frame;
    btnFrame.origin.y = CGRectGetMaxY(contentBgView.frame) + 8;
    delectBtn.frame = btnFrame;
    
    btnFrame = saveCourseBtn.frame;
    btnFrame.origin.y = CGRectGetMaxY(contentBgView.frame) + 8;
    saveCourseBtn.frame = btnFrame;
    
    self.scrollView_.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 650);
    
    if (courseData) {
        [self changeCourseInfo];
        delectBtn.hidden = NO;
        saveCourseBtn.hidden = YES;
        
        if ([courseData.course_status isEqualToString:@"7"]) {
            saveCourseBtn.hidden = NO;
            return;
        }
        
        _delectBtnAutoWidth.constant = ScreenWidth - 2*_delectBtnAutoLeading.constant;
//        CGRect frame = delectBtn.frame;
//        frame.size.width = 304;
//        delectBtn.frame = frame;
    }
    else
    {
        _saveBtnAutoWidth.constant = ScreenWidth - 2*_saveBtnAutoTrailling.constant;
        
//        CGRect btnFrame = saveCourseBtn.frame;
//        btnFrame.origin.x = 8;
//        btnFrame.size.width = 304;
//        saveCourseBtn.frame = btnFrame;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    courseData = dataModal;
    if (courseData) {
//         self.navigationItem.title = @"修改话题";
        [self setNavTitle:@"修改话题"];
    }
    else
    {
//         self.navigationItem.title = @"创建话题";
        [self setNavTitle:@"创建话题"];
    }
}

- (void)changeCourseInfo
{
    if ([courseData.course_price isEqualToString:@"299"]) {
        btnTag = 1001;
    }
    else if ([courseData.course_price isEqualToString:@"399"]){
        btnTag = 1002;
    }
    else if ([courseData.course_price isEqualToString:@"499"]){
        btnTag = 1003;
    }
    else{
        btnTag = 1004;
    }
    [self chooseCoursePrice:btnTag];
    
    if ([courseData.course_long isEqualToString:@"1.00"]) {
        btnTag = 101;
    }
    else if ([courseData.course_long isEqualToString:@"1.50"]){
        btnTag = 102;
    }
    else if ([courseData.course_long isEqualToString:@"2.00"]){
        btnTag = 103;
    }
    else{
        btnTag = 104;
    }
    [self chooseCourseHours:btnTag];
    
    titleTV.text = courseData.course_title;
    contentTV.text = courseData.course_info;
    [self textViewDidChange:titleTV];
    [self textViewDidChange:contentTV];
    
    tipsOne.hidden = YES;
    tipsTwo.hidden = YES;
}

#pragma mark - hoursBtnClick
- (IBAction)hoursBtnClick:(id)sender {//时长选择
    
    UIButton *btn = (UIButton *)sender;
    if (sender == otherTimeBtn) {
        CreateCourseOtherBtnCtl *otherTimeCtl = [[CreateCourseOtherBtnCtl alloc] init];
        otherTimeCtl.hourOrPrice = @"hours";
        _courseOtherTimeCtl = otherTimeCtl;
        __weak typeof(ELCreateCourseCtl) *weakSelf = self;
        otherTimeCtl.timeBlock = ^(double time){
            [weakSelf.courseOtherTimeCtl.view removeFromSuperview];
            weakSelf.courseOtherTimeCtl = nil;
            if (time > 0) {
                [self chooseCourseHours:btn.tag];
                courseTime = [NSString stringWithFormat:@"%.1f",time];
                [otherTimeBtn setTitle:[NSString stringWithFormat:@"%.1f小时",time] forState:UIControlStateNormal];
            }
        };
        
        otherTimeCtl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:otherTimeCtl.view];
    }else{
        [self chooseCourseHours:btn.tag];
    }
}

- (void)chooseCourseHours:(NSInteger)tag
{
    switch (tag) {
        case 101:
        {
            hoursBtnOne.layer.borderColor = [UIColor redColor].CGColor;
            [hoursBtnOne setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            hoursBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            hoursBtnthree.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnthree setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            otherTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [otherTimeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherTimeBtn setTitle:@"其他" forState:UIControlStateNormal];
            
            courseTime = hoursBtnOne.titleLabel.text;
        }
            break;
        case 102:
        {
            hoursBtnOne.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            hoursBtnTwo.layer.borderColor = [UIColor redColor].CGColor;
            [hoursBtnTwo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            hoursBtnthree.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnthree setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            otherTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [otherTimeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherTimeBtn setTitle:@"其他" forState:UIControlStateNormal];
            
            courseTime = hoursBtnTwo.titleLabel.text;
        }
            break;
        case 103:
        {
            hoursBtnOne.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            hoursBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            hoursBtnthree.layer.borderColor = [UIColor redColor].CGColor;
            [hoursBtnthree setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            otherTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [otherTimeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherTimeBtn setTitle:@"其他" forState:UIControlStateNormal];
            
            courseTime = hoursBtnthree.titleLabel.text;
        }
            break;
        case 104:
        {
            hoursBtnOne.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            hoursBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            hoursBtnthree.layer.borderColor = [UIColor grayColor].CGColor;
            [hoursBtnthree setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            otherTimeBtn.layer.borderColor = [UIColor redColor].CGColor;
            [otherTimeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            if (courseData) {
                courseTime = courseData.course_long;
                [otherTimeBtn setTitle:[NSString stringWithFormat:@"%@小时",courseTime] forState:UIControlStateNormal];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PriceBtnClick
- (IBAction)priceBtnClick:(id)sender {//价格选择
    
    UIButton *btn = (UIButton *)sender;

    if (sender == otherPriceBtn)
    {
        CreateCourseOtherBtnCtl *otherTimeCtl = [[CreateCourseOtherBtnCtl alloc] init];
        otherTimeCtl.hourOrPrice = @"price";
        _courseOtherTimeCtl = otherTimeCtl;
        __weak typeof(ELCreateCourseCtl) *weakSelf = self;
        otherTimeCtl.timeBlock = ^(double amount){
            [weakSelf.courseOtherTimeCtl.view removeFromSuperview];
            weakSelf.courseOtherTimeCtl = nil;
            if (amount > 0) {
//                coursePrice = [NSString stringWithFormat:@"%f",amount];
//                [otherPriceBtn setTitle:[NSString stringWithFormat:@"%f元/次",amount] forState:UIControlStateNormal];
                [weakSelf chooseCoursePrice:btn.tag];
                coursePrice = [NSString stringWithFormat:@"%.2f",amount];
                [otherPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/次",amount] forState:UIControlStateNormal];
            }
        };
        otherTimeCtl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        otherTimeCtl.otherTimeTF.placeholder = @"金额(元)";
        otherTimeCtl.titleLb.text = @"其他金额";
        [[UIApplication sharedApplication].keyWindow addSubview:otherTimeCtl.view];
        
    }else{
        [self chooseCoursePrice:btn.tag];
    }
}

- (void)chooseCoursePrice:(NSInteger)tag
{
    switch (tag) {
        case 1001:
        {
            priceBtnOne.layer.borderColor = [UIColor redColor].CGColor;
            [priceBtnOne setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            priceBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            priceBtnThree.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnThree setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            otherPriceBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [otherPriceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherPriceBtn setTitle:@"其他金额" forState:UIControlStateNormal];
            
            coursePrice = priceBtnOne.titleLabel.text;
        }
            break;
        case 1002:
        {
            priceBtnOne.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            priceBtnTwo.layer.borderColor = [UIColor redColor].CGColor;
            [priceBtnTwo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            priceBtnThree.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnThree setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            otherPriceBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [otherPriceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherPriceBtn setTitle:@"其他金额" forState:UIControlStateNormal];
            
            coursePrice = priceBtnTwo.titleLabel.text;
        }
            break;
        case 1003:
        {
            priceBtnOne.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            priceBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            priceBtnThree.layer.borderColor = [UIColor redColor].CGColor;
            [priceBtnThree setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            otherPriceBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [otherPriceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [otherPriceBtn setTitle:@"其他金额" forState:UIControlStateNormal];
            
            coursePrice = priceBtnThree.titleLabel.text;
            
        }
            break;
        case 1004:
        {
            priceBtnOne.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            priceBtnTwo.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            priceBtnThree.layer.borderColor = [UIColor grayColor].CGColor;
            [priceBtnThree setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            otherPriceBtn.layer.borderColor = [UIColor redColor].CGColor;
            [otherPriceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            if (courseData) {
                coursePrice = courseData.course_price;
                [otherPriceBtn setTitle:[NSString stringWithFormat:@"%@元/次",coursePrice] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    if ([titleTV.text isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"" msg:@"主题名称不能为空" btnTitle:@"确定"];
        return;
    }
    
    if ([contentTV.text isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"" msg:@"话题描述不能为空" btnTitle:@"确定"];
        return;
    }
    CourseStatu = @"7";
    if (courseData) {
        [self updateCourse];
    }
    else
    {
        [self addCourse];
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == confirmBtn) {
        
    }
    else if (sender == delectBtn)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除该话题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 1002;
        [alertView show];
    }
    else if (sender == saveCourseBtn)
    {
        if ([titleTV.text isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"" msg:@"主题名称不能为空" btnTitle:@"确定"];
            return;
        }
        
        if ([contentTV.text isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"" msg:@"话题描述不能为空" btnTitle:@"确定"];
            return;
        }
        else if (![contentTV.text isEqualToString:@""])
        {
            if (contentTV.text.length < 100) {
                [BaseUIViewController showAlertView:@"" msg:@"话题描述不少于100字" btnTitle:@"确定"];
                return;
            }
            else if (contentTV.text.length > 2000)
            {
                [BaseUIViewController showAlertView:@"" msg:@"话题描述最多2000字" btnTitle:@"确定"];
                return;
            }
        }
        CourseStatu = @"0";
        if (courseData) {
            [self updateCourse];
        }
        else
        {
            [self addCourse];
        }
    }
}

//删除课程
- (void)deleteCourse
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString *op = @"yuetan_record_busi";
    NSString *func = @"deleteCourse";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&course_id=%@", userId, courseData.course_id];

    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        NSDictionary *dic = result;
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"200"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"COURSEEDITORSUCCESS" object:@{@"type":@"delete"}];
            if (_backIndex > 0 && _backIndex < self.navigationController.viewControllers.count) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[_backIndex] animated:YES];
            }else{
                ELExpertCourseListCtl *ctl = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                if ([ctl respondsToSelector:@selector(setIsRefresh:)]) {
                    [ctl setIsRefresh:YES]; 
                }
                [self.navigationController popToViewController:ctl animated:YES];
            }
        }

    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];

}

//添加课程
- (void)addCourse
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString *op = @"yuetan_record_busi";
    NSString *func = @"addCourse";
    
    NSMutableDictionary *courseInfoDic = [[NSMutableDictionary alloc] init];
    [courseInfoDic setNewValue:titleTV.text forKey:@"course_title"];
    [courseInfoDic setNewValue:contentTV.text forKey:@"course_intro"];
    [courseInfoDic setNewValue:coursePrice forKey:@"course_price"];
    [courseInfoDic setNewValue:courseTime forKey:@"course_long"];
    [courseInfoDic setNewValue:CourseStatu forKey:@"course_status"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *courseInfoStr = [jsonWrite stringWithObject:courseInfoDic];

    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&courseInfo=%@", userId, courseInfoStr];
    
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result){
        
        NSDictionary *dic = result;
        NSString *code = dic[@"code"];
        NSString *des = dic[@"status_desc"];
        if ([code isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:@"" msg:@"添加成功！"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"COURSEEDITORSUCCESS" object:@{@"type":@"add"}];
            ELExpertCourseListCtl *ctl = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            if ([ctl respondsToSelector:@selector(setIsRefresh:)]) {
               [ctl setIsRefresh:YES]; 
            }
            [self.navigationController popToViewController:ctl animated:YES];
        }else{
            [BaseUIViewController showAlertViewContent:des toView:nil second:1.0 animated:YES];
        }
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}

//修改课程
- (void)updateCourse
{
    NSString *userId = [Manager getUserInfo].userId_;
    
    NSString *op = @"yuetan_record_busi";
    NSString *func = @"updateCourse";
    
    NSMutableDictionary *courseInfoDic = [[NSMutableDictionary alloc] init];
    [courseInfoDic setValue:courseData.course_id forKey:@"course_id"];
    [courseInfoDic setValue:titleTV.text forKey:@"course_title"];
    [courseInfoDic setValue:contentTV.text forKey:@"course_intro"];
    [courseInfoDic setValue:coursePrice forKey:@"course_price"];
    [courseInfoDic setValue:courseTime forKey:@"course_long"];
    [courseInfoDic setValue:CourseStatu forKey:@"course_status"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *courseInfoStr = [jsonWrite stringWithObject:courseInfoDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&courseInfo=%@", userId, courseInfoStr];
    
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result){
        
        NSDictionary *dic = result;
        NSString *code = dic[@"code"];
        NSString *des = dic[@"status_desc"];
        if ([code isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:@"" msg:@"修改成功！"];
            ELExpertCourseListCtl *ctl = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            if ([ctl respondsToSelector:@selector(setIsRefresh:)]) {
                [ctl setIsRefresh:YES]; 
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"COURSEEDITORSUCCESS" object:@{@"type":@"editor"}];
            [self.navigationController popToViewController:ctl animated:YES];
        }else{
            [BaseUIViewController showAlertViewContent:des toView:nil second:1.0 animated:YES];
        }
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length = textView.text.length;
    NSString *lang = [textView.textInputMode primaryLanguage];
    
    if (textView == titleTV) {
        if (titleTV.text.length <= 0) {
            tipsOne.hidden = NO;
            numOfTitleTV.text = @"30字";
        }
        else
        {
            tipsOne.hidden = YES;
            length = 30 - length;
            numOfTitleTV.text = [NSString stringWithFormat:@"%ld字",(long)length];
            if (length <= 0) {
                numOfTitleTV.text = @"0字";
            }
            
            if ([lang isEqualToString:@"zh-Hans"]) {//如果输入的时中文
                UITextRange *selectedRange = [titleTV markedTextRange];
                UITextPosition *position = [titleTV positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    if (titleTV.text.length > 30) {
                        titleTV.text = [titleTV.text substringToIndex:30];
                    }
                }
            }else{
                if (titleTV.text.length > 30) {
                    titleTV.text = [titleTV.text substringToIndex:30];
                }
            }
        }

    }
    else if (textView == contentTV){
        if (contentTV.text.length <= 0)
        {
            tipsTwo.hidden = NO;
            numOfContentTv.text = @"2000字";
        }
        else
        {
            tipsTwo.hidden = YES;
            length = 2000 - length;
            numOfContentTv.text = [NSString stringWithFormat:@"%ld字",(long)length];
            if (length <= 0) {
                numOfContentTv.text = @"0字";
            }
            
            if ([lang isEqualToString:@"zh-Hans"]) {//如果输入的时中文
                UITextRange *selectedRange = [contentTV markedTextRange];
                UITextPosition *position = [contentTV positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    if (contentTV.text.length > 2000) {
                        contentTV.text = [contentTV.text substringToIndex:2000];
                    }
                }
            }else{
                if (contentTV.text.length > 2000) {
                    contentTV.text = [contentTV.text substringToIndex:2000];
                }
            }
        }
    }
}

- (void)backBarBtnResponse:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否要退出编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        switch (buttonIndex) {
            case 1:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }

    }
    else if (alertView.tag == 1002)
    {
        if (buttonIndex == 1) {
            titleTV.text = @"";
            contentTV.text = @"";
            tipsOne.hidden = NO;
            tipsTwo.hidden = NO;
            [self deleteCourse];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    singleTapRecognizer_ = nil;
    
    CGPoint point = self.scrollView_.contentOffset;
    if( point.y < 0 ){
        [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if( self.scrollView_.frame.size.height + point.y > self.scrollView_.contentSize.height ){
        if( self.scrollView_.frame.size.height > self.scrollView_.contentSize.height ){
            [self.scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
        }else
            [self.scrollView_ setContentOffset:CGPointMake(0, self.scrollView_.contentSize.height - self.scrollView_.frame.size.height) animated:YES];
    }
    
    CGRect frame = self.toolbarHolder.frame;
    frame.origin.y = self.view.frame.size.height;
    self.toolbarHolder.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
