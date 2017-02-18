//
//  SalaryCompareResultCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-26.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SalaryCompareResultCtl.h"
#import "SalaryGuide_HeaderView.h"
#import "JobSearch_DataModal.h"
#import "Article_DataModal.h"
#import "RegCtl.h"
#import "ResumePKView.h"
#import "SalaryCompareResultCtl_Cell.h"

#import "FMDatabase.h"

@interface SalaryCompareResultCtl ()<UITextViewDelegate>
{
    NSString * percentcontent_;
    UITapGestureRecognizer *singleTapRecognizer_;
    ResumePKView *_ResumePKView;
    UIView *_maskView;
    RequestCon *_resumeCompareCon;
    RequestCon *_sendPesonalMsgCon;
    FMDatabase           *database;
    User_DataModal *_compareUser;
}

@end

@implementation SalaryCompareResultCtl
@synthesize kwFlag_,regionId_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bHeaderEgo_ = NO;
        rightNavBarStr_ = @"分享";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
//    self.navigationItem.title = @"薪资比拼结果";
    [self setNavTitle:@"薪资比拼结果"];
    
    CGRect rect = tableView_.frame;
    rect.origin.y = -40;
    rect.size.height += 20;
    tableView_.frame = rect;
    [tableView_ setContentOffset:CGPointMake(0, 0)];
        
    sexImgView_.layer.cornerRadius = 20.0;
    sexImgView_.layer.masksToBounds = YES;
    
    [activityView_ startAnimating];
    tableView_.alpha = 0.0;
    tableView_.tableFooterView = footerView_;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CALayer *layer = _msgTV.layer;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = 0.5f;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2;
    
    layer = _sendMsgBtn.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:238.f/255 green:96.f/255 blue:86.f/255 alpha:1.f].CGColor;
    layer.masksToBounds = YES;
    layer.cornerRadius = 15.f;
    
    [_xiaoXinImgv sd_setImageWithURL:[NSURL URLWithString:@"http://img105.job1001.com/myUpload2/201504/11/1428737491_829.jpg"] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    
    layer = _xiaoXinImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 25.f;
    
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setFd_prefersNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
//    self.navigationItem.title = @"薪资比拼结果";
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    tableView_.contentOffset = CGPointMake(0, tableView_.contentSize.height - self.view.frame.size.height + keyboardRect.size.height - 60);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    tableView_.contentOffset = CGPointMake(0, tableView_.contentSize.height - self.view.frame.size.height );
}

- (void)viewSingleTap:(UITapGestureRecognizer *)sender
{
    [_msgTV resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//设置右按扭的属性
-(void) setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if( [rightNavBarStr_ length] >= 4 ){
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    }else
        [rightBarBtn_ setFrame:CGRectMake(0, 0, 40, 40)];
    
    rightBarBtn_.titleLabel.font = [UIFont boldSystemFontOfSize:13];//[UIFont boldSystemFontOfSize:14];
    [rightBarBtn_ setImage:[UIImage imageNamed:@"share_white-2"] forState:UIControlStateNormal];
}


-(void)updateCom:(RequestCon *)con
{
    if (myModal_ && con == requestCon_) {
        
        NSString * regionStr = [CondictionListCtl getRegionStr:regionId_];
        if (!regionStr || [regionStr  isEqualToString:@""]||[regionStr  isEqualToString:@"暂无"]) {
            regionStr = @"全国";
        }
        attributedLb_.layer.borderColor = [UIColor whiteColor].CGColor;
        attributedLb_.alpha = 0.5;
        attributedLb_.layer.borderWidth = 0.5;
        attributedLb_.layer.cornerRadius = 4.0;
        NSString * str = [NSString stringWithFormat:@"击败了%@",regionStr];
        attributedLb_.text = str;
        [attributedLb_ setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:2];
        [attributedLb_ setColor:[UIColor whiteColor] fromIndex:0 length:[str length]];
        [attributedLb_ setFont:[UIFont systemFontOfSize:14] fromIndex:2 length:[str length]-3];
        
        NSString * astr = [NSString stringWithFormat:@"了%@",regionStr];
        NSString * bstr = @"击败";
        CGSize aSize = [astr sizeNewWithFont:[UIFont systemFontOfSize:14.0]];
        CGSize bSize = [bstr sizeNewWithFont:[UIFont systemFontOfSize:22.0]];
        
        CGRect rect = attributedLb_.frame;
        rect.size.width = aSize.width + bSize.width;
        rect.origin.x = (self.view.frame.size.width - rect.size.width)/2.0;
        attributedLb_.frame = rect;
        
        [sexImgView_ sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_ ] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
        nameLb_.text = [Manager getUserInfo].name_;
        salaryLb_.text = inModal_.salary_;
        
        NSString * percent = [myModal_.percentDic_ objectForKey:@"now"];
        NSString * bj = [myModal_.percentDic_ objectForKey:@"beijing"];
        NSString * sh = [myModal_.percentDic_ objectForKey:@"shagnhai"];
        NSString * gz = [myModal_.percentDic_ objectForKey:@"guangzhou"];
        NSString * sz = [myModal_.percentDic_ objectForKey:@"shenzhen"];
        
        if ([percent isNull]) {
            percent = @"0.01";
        }
        if ([bj isNull]) {
            bj = @"0.01";
        }
        if ([sh isNull]) {
            sh = @"0.01";
        }
        if ([gz isNull]) {
            gz = @"0.01";
        }
        if ([sz isNull]) {
            sz = @"0.01";
        }
        
        [percentLb_ setText:[NSString stringWithFormat:@"%@%%",percent]];
        [bjLb_ setText:[NSString stringWithFormat:@"%@%%",bj]];
        [shLb_ setText:[NSString stringWithFormat:@"%@%%",sh]];
        [gzLb_ setText:[NSString stringWithFormat:@"%@%%",gz]];
        [szLb_ setText:[NSString stringWithFormat:@"%@%%",sz]];
        
        tableView_.tableHeaderView = headView_;
        [self.view bringSubviewToFront:shareBtn_];
        [self.view bringSubviewToFront:mybackBtn_];
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    [con getSalarySearchResult2:inModal_.zym_ kwflag:kwFlag_ salary:inModal_.salary_ regionId:regionId_ userId:userId tradeId:@"" tradeName:@"" orderId:_orderId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_SalarySearchResult2://比拼结果
        {
            [activityView_ stopAnimating];
            activityView_.alpha = 0.0;
            tableView_.alpha = 1.0;
            myModal_ = [dataArr objectAtIndex:0];
        }
            break;
        case Request_ResumeCompare://简历对比
        {
            [self showPKView:dataArr];
        }
            break;
        case Request_LeaveMessage://留言
        {
            Status_DataModal *dataModal = [dataArr objectAtIndex:0];
            if( [dataModal.status_ isEqualToString:Success_Status] ){
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"留言成功"];
            }else{
                [BaseUIViewController showAutoDismissSucessView:nil msg:dataModal.des_];
            }
        }
            break;
        default:
            break;
    }
}


#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myModal_.recommendUserArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SalaryCompareResultCtl_Cell";
    
    SalaryCompareResultCtl_Cell *cell = (SalaryCompareResultCtl_Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryCompareResultCtl_Cell" owner:self options:nil] lastObject];
        cell.resumeCmpBtn.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.resumeCmpBtn addTarget:self action:@selector(requestResumeCompare:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.resumeCmpBtn.tag = indexPath.row + 1001;
    
    cell.SexImg.layer.cornerRadius = 25.0;
    cell.SexImg.layer.masksToBounds = YES;
    
    SalaryResult_DataModal *salaryModel = [requestCon_.dataArr_ objectAtIndex:0];
    User_DataModal * dataModal = [salaryModel.recommendUserArr objectAtIndex:indexPath.row];
    
    [cell.firstNameLb setText:[dataModal.name_ substringToIndex:1]];
    if (![dataModal.sex_ isEqualToString:@"2"]) {
        [cell.sexLb setText:@"先生"];
    }
    else
    {
        [cell.sexLb setText:@"小姐"];
    }
    
    NSString *imageName = [self getLianMengImage:[self sqlStr:[self setKey:dataModal.sex_ age:dataModal.age_]]];
    
    [cell.SexImg setImage:[UIImage imageNamed:imageName]];
    dataModal.img_ = imageName;
    cell.jobLb.text = dataModal.zye_;
    
    //地点
    NSString *address = dataModal.regiondetail_;
    CGSize addressSize = [address sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(60, 20)];
    CGRect frame = cell.addressLb.frame;
    frame.size.width = addressSize.width;
    cell.addressLb.frame = frame;
    cell.addressLb.text = address;
    
    //学历
    NSString *education = dataModal.eduName_;
    CGSize educationSize = [education sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]constrainedToSize:CGSizeMake(33, 16)];
    frame = cell.educationLb.frame;
    frame.size.width = educationSize.width;
    cell.educationLb.frame = frame;
    cell.educationLb.text = education;
    
    CGFloat padding = 3.0f;
    frame = cell.workAgeLine.frame;
    frame.origin.x = CGRectGetMaxX(cell.educationLb.frame) + padding;
    cell.workAgeLine.frame = frame;
    
    //工作年限
    NSString *workAge = dataModal.gzNum_;
    if (![workAge isEqualToString:@"暂无"]) {//工作年限
        workAge = [NSString stringWithFormat:@"%@年经验", dataModal.gzNum_];
    }
    
    CGSize workAgeSize = [workAge sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    CGFloat workAgeX = CGRectGetMaxX(cell.workAgeLine.frame);
    frame = cell.workAgeLb.frame;
    frame.origin.x = workAgeX;
    frame.size.width = workAgeSize.width;
    cell.workAgeLb.frame = frame;
    cell.workAgeLb.text = workAge;
    
    
    //学校
    frame = cell.schoolLine.frame;
    frame.origin.x = CGRectGetMaxX(cell.workAgeLb.frame) + padding;
    cell.schoolLine.frame = frame;
    
    NSString *school = dataModal.school_;
    cell.schoolLb.text = school;
    frame = cell.schoolLb.frame;
    frame.origin.x = CGRectGetMaxX(cell.schoolLine.frame);
    cell.schoolLb.frame = frame;
    
    
    if ([dataModal.salary_ integerValue] > 10000 || [dataModal.salary_ integerValue] == 10000)
    {
        //整数
        NSInteger a = [dataModal.salary_ integerValue]/10000;
        //小数位
        NSInteger b = ([dataModal.salary_ integerValue]%10000)/1000;
        
        cell.salaryLb.text = [NSString stringWithFormat:@"%ld.%ld万",(long)a,(long)b];
    }
    else
    {
        cell.salaryLb.text = [NSString stringWithFormat:@"%@",dataModal.salary_];
    }
 
    return cell;
}

#pragma mark - 根据年龄和性别获取查询的key
-(NSString*)setKey:(NSString*)sex age:(NSString*)age
{
    NSString * sexStr = @"";
    NSString * ageStr = @"";
    int randomIndex = 1 + arc4random() % 3;
    if ([sex isEqualToString:@"2"]) {
        sexStr = @"girl";
    }
    else
        sexStr = @"boy";
    
    if ([age integerValue] < 30) {
        ageStr = @"30";
    }
    else if ([age integerValue] >= 30 && [age integerValue] < 40){
        ageStr = @"40";
    }
    else if ([age integerValue] >= 40 && [age integerValue] < 50){
        ageStr = @"50";
    }
    else if ([age integerValue] >= 50 ){
        ageStr = @"60";
    }
    
    return [NSString stringWithFormat:@"%@_%@%d",sexStr,ageStr,randomIndex];
}

#pragma mark - 获取查询语句
-(NSString*)sqlStr:(NSString*)key
{
    return  [NSString stringWithFormat:@"select * from user_image where key='%@'",key];
}

#pragma mark-读取数据库里的头像
-(NSString*)getLianMengImage:(NSString*)str
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [Common getSandBoxPath:@"lianmeng_image.sqlite"];
    if( ![fileManager fileExistsAtPath:filePath] ){
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"lianmeng_image.sqlite"]];
        [data writeToFile:[Common getSandBoxPath:@"lianmeng_image.sqlite"] atomically:YES];
    }
    if (!database) {
        database = [FMDatabase databaseWithPath:filePath];
    }
    
    if ([database open])
    {
        FMResultSet *set = [database executeQuery:str];
        while ([set next]) {
            
            NSString * imageName = [set stringForColumn:@"value"];
            return imageName;
        }
    }
    return @"Gender100-nan.png";
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    //记录友盟统计模块使用量
    NSDictionary * dict = @{@"Function":@"薪指"};
    [MobClick event:@"personused" attributes:dict];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    SalaryResult_DataModal *salaryModel = [requestCon_.dataArr_ objectAtIndex:0];
    User_DataModal * dataModal = [salaryModel.recommendUserArr objectAtIndex:indexPath.row];
    _compareUser = dataModal;
    if (!_resumeCompareCon) {
        _resumeCompareCon = [self getNewRequestCon:NO];
    }
    NSString *myId = [Manager getUserInfo].userId_;
    if (!myId) {
        [BaseUIViewController showAlertView:nil msg:@"请登录" btnTitle:@"确定"];
        return;
    }
    NSString *compareId = dataModal.userId_;
    [_resumeCompareCon resumeCompareWithUserId:myId anotherId:compareId];

    
}

-(void)btnResponse:(id)sender
{
    if (sender == backBtn_) {
        //友盟统计点击数
        NSDictionary * dict = @{@"Function":@"再比一次看看"};
        [MobClick event:@"againVsPay" attributes:dict];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (sender == mybackBtn_){
        [super backBarBtnResponse:nil];
    }
    else if(sender == shareBtn_){
        [self rightBarBtnResponse:nil];
    }else if (sender == _sendMsgBtn){//发送留言
        [_msgTV resignFirstResponder];
        if ([[_msgTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissFailView:@"留言内容不能为空" msg:nil seconds:2.0];
            return;
        }
        if (!_sendPesonalMsgCon) {
            _sendPesonalMsgCon = [self getNewRequestCon:NO];
        }
        User_DataModal *user = [Manager getUserInfo];
        NSString *fromUserId = user.userId_;
        if (!fromUserId) {
            [BaseUIViewController showAutoDismissFailView:@"登录后才能留言" msg:nil seconds:2.0];
            return;
        }
        NSString *toUserId = @"16117473";
        [_sendPesonalMsgCon leaveMsgContent:_msgTV.text from:fromUserId to:toUserId hrFlag:NO shareType:@"" productType:@"" recordId:@""];
    }
}

#pragma mark 请求简历对比的数据
- (void)requestResumeCompare:(UIButton *)sender
{
    NSInteger index = sender.tag - 1001;
    SalaryResult_DataModal *salaryModel = [requestCon_.dataArr_ objectAtIndex:0];
    User_DataModal * dataModal = [salaryModel.recommendUserArr objectAtIndex:index];
    _compareUser = dataModal;
    if (!_resumeCompareCon) {
        _resumeCompareCon = [self getNewRequestCon:NO];
    }
    NSString *myId = [Manager getUserInfo].userId_;
    if (!myId) {
        [BaseUIViewController showAlertView:nil msg:@"请登录" btnTitle:@"确定"];
        return;
    }
    NSString *compareId = dataModal.userId_;
    [_resumeCompareCon resumeCompareWithUserId:myId anotherId:compareId];
}

#pragma mark 显示PK的view
- (void)showPKView:(NSArray *)resumeArr
{
    if (!_ResumePKView) {
        _ResumePKView = [[NSBundle mainBundle] loadNibNamed:@"ResumePKView" owner:self options:nil][0];
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
        [MyCommon addTapGesture:_maskView target:self numberOfTap:1 sel:@selector(maskClicked)];
    }
    if (resumeArr.count == 2) {
        //薪指采用传递的薪指
        User_DataModal *compareUser = resumeArr[1];
        NSString *sexStr;
        if (![compareUser.sex_ isEqualToString:@"2"]) {
            sexStr = @"先生";
        } else {
            sexStr = @"小姐";
        }
        compareUser.name_ = [NSString stringWithFormat:@"%@%@", [compareUser.name_ substringToIndex:1], sexStr];
        compareUser.eduName_ = _compareUser.eduName_;
        compareUser.salary_ = _compareUser.salary_;
        compareUser.img_ = _compareUser.img_;
        
        User_DataModal *myModel = resumeArr[0];
        myModel.salary_ = inModal_.salary_;
        myModel.percent = [myModal_.percentDic_ objectForKey:@"now"];
    }
    
    _ResumePKView.resumeArr = resumeArr;
    
    CGRect frame = CGRectMake(ScreenWidth,(ScreenHeight-343)/2.0, 305, 343);
    _ResumePKView.frame = frame;
    _maskView.frame = self.view.bounds;
    [self.view addSubview:_maskView];
    [self.view addSubview:_ResumePKView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0.7;
        _ResumePKView.frame = CGRectMake((ScreenWidth-304)/2.0,(ScreenHeight-343)/2.0, 305, 343);
    }];
}

#pragma mark 隐藏PKview
- (void)maskClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0.0;
        _ResumePKView.frame = CGRectMake(ScreenWidth, (ScreenHeight-343)/2.0, 305, 343);
        
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [_ResumePKView removeFromSuperview];
    }];
}

-(void)rightBarBtnResponse:(id)sender
{
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.view.frame.size);
    }
    
    //获取图像
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024"  ofType:@"png"];
    
    NSString * sharecontent = percentcontent_;
    
    NSString * titlecontent = [NSString stringWithFormat:@"我打败了%@的人，赶紧来试试吧！",percentLb_.text];
    
    NSString * url = [self shareUrl:inModal_];
    
    //调用分享
    [[ShareManger sharedManager] shareWithCtl:self.navigationController title:titlecontent content:sharecontent image:image url:url];

}

-(NSString*)shareUrl:(User_DataModal*)model
{
    NSString * pre = @"http://m.yl1001.com/xinwen/xzbp/?type=1&";
    
    NSString * regionId = regionId_;
    if ([regionId isEqualToString:@"10000"]|| [regionId isEqualToString:@""]) {
        regionId = @"100";
    }
    
    NSString * kw = [MyCommon utf8ToUnicode:model.zym_];
    kw = [kw stringByReplacingOccurrencesOfString:@"@@" withString:@"\\"];
    
    NSString * condition = [NSString stringWithFormat:@"salary=%@&zw=%@&region_id=%@",model.salary_,kw,regionId];
    
    return [NSString stringWithFormat:@"%@%@",pre,condition];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _tipLb.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text == nil || [textView.text isEqualToString:@""]) {
        _tipLb.hidden = NO;
    }
}

- (void)backBarBtnResponse:(id)sender
{
//    tableView_.delegate = nil;
    [super backBarBtnResponse:sender];
}

- (void)dealloc
{
    tableView_.delegate = nil;
    [database close];
}
@end
