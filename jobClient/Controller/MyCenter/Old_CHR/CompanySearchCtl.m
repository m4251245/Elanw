//
//  companySearchCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-1-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CompanySearchCtl.h"
#import "ChangeRegionViewController.h"

#import "peopleResumeDataModal.h"
#import "CHRResumeCell.h"
#import "SearchParam_DataModal.h"


#define SEARCHVIEW_HEIGHT searchCon.frame.size.height
#define SEARCHVIEW_WIDTH searchCon.frame.size.width
#define BTN_TAG 111111
@interface CompanySearchCtl ()<UISearchBarDelegate, UITextFieldDelegate, ConditionItemCtlDelegate,UIScrollViewDelegate>
{
    BOOL shouldRefresh_;
    UIButton *rightBtn;
    UIView *searchView ;
    User_DataModal *userModelInfo;
    UITextField *_keyWorkTF;
    UIButton *leftBtn;
    UIView *searchCon;
    NSArray *btnSelArr;
    UIView *selConView;
    NSArray *placehoderArr;
    BOOL state;
    NSString *searchType;
}

@end

@implementation CompanySearchCtl

-(id)init
{
    self = [super init];
    
    //self.title = @"搜简历";
    bFooterEgo_ = YES;
    _regionId = @"";
    searchType = @"key";
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    btnSelArr = @[@"关键字",@"职位",@"企业"];
    placehoderArr = @[@"搜索关键字或简历编号",@"搜索职位名称关键字",@"搜索企业名称关键字"];
    [self configUI];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 3, 10, 1, 20)];
    line1.backgroundColor = UIColorFromRGB(0xececec);
    [_conditionView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 3*2, 10, 1, 20)];
    line2.backgroundColor = UIColorFromRGB(0xececec);
    [_conditionView addSubview:line2];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ((requestCon_ && [Manager shareMgr].isFromMessage_)||[requestCon_.dataArr_ count] == 0) {
        [self refreshLoad:nil];
        [Manager shareMgr].isFromMessage_ = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
    [self hideSearchConView];
}
#pragma mark--配置界面--
-(void)configUI{
    
    if ([_regionId isEqualToString:@""]) {
        _regionId = @"100000";
    }
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 115, 44)];
    
    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth - 115, 24)];
    bgImgv.layer.cornerRadius = 2;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    //    添加左侧按钮
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"关键字" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(5, 10, 45, 24);
    leftBtn.titleLabel.font = THIRTEENFONT_CONTENT;
    [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [searchView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    添加图标
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, 6, 4)];
    img.image = [UIImage imageNamed:@"popoverArrowDown@2x"];
    [searchView addSubview:img];
    
    //    添加线条
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(59, 12, 1, 20)];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [searchView addSubview:lineView];
    
    //    搜索框
    _keyWorkTF = [[UITextField alloc] initWithFrame:CGRectMake(62, 10, searchView.frame.size.width - 65, 24)];
    _keyWorkTF.returnKeyType = UIReturnKeySearch;
    _keyWorkTF.placeholder = @"搜索关键字或简历编号";
    [_keyWorkTF setFont:THIRTEENFONT_CONTENT];
    [_keyWorkTF setTextColor:BLACKCOLOR];
    _keyWorkTF.delegate = self;
    [_keyWorkTF setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:_keyWorkTF];
    
    //    右侧搜索按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn.titleLabel setFont:FIFTEENFONT_TITLE];
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
    
    _paramDataModel = [[SearchParam_DataModal alloc]init];
    
    _informalMemberTiPView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_informalMemberTiPView];
    [_informalMemberTiPView setHidden:YES];
    
    //   关键字选择背景view
    searchCon = [[UIView alloc]initWithFrame:CGRectMake(52, 51, 60, 75)];
    searchCon.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [[UIApplication sharedApplication].keyWindow addSubview:searchCon];
    [self configBtnSel];
    searchCon.hidden = YES;
    
    [self confiBtnTitleFrame];
}

//配置关键字
-(void)configBtnSel{
    
    for (int i = 0; i < btnSelArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, SEARCHVIEW_HEIGHT/3 * i, SEARCHVIEW_WIDTH, SEARCHVIEW_HEIGHT/3);
        [btn setTitle:btnSelArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [btn.titleLabel setFont:THIRTEENFONT_CONTENT];
        [searchCon addSubview:btn];
        btn.tag = BTN_TAG + i;
        [btn addTarget:self action:@selector(btnSelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SEARCHVIEW_HEIGHT/3 * i, SEARCHVIEW_WIDTH, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xececec);
        [searchCon addSubview:lineView];
    }
}


#pragma mark--数据处理--
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _companyId = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *keywords = @"";
    if (_keyWorkTF.text.length) {
        keywords = [_keyWorkTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSString *eduId = @"";
    if (_paramDataModel.eduId_) {
        eduId = _paramDataModel.eduId_;
    }
   
    NSString *wokeAge = _paramDataModel.workAgeValue_;
    NSString *wokeAge1 = _paramDataModel.workAgeValue_1;
    if (!wokeAge) {
        wokeAge = @"";
    }
    if (!wokeAge1) {
        wokeAge1 = @"";
    }
    
    if(!con)
    {
        con = [self getNewRequestCon:NO];
    }
    if ([_regionId isEqualToString:@"100000"]) {
        _regionId = @"";
    }

    [con companySearchResumeCompanyId:_companyId regionId:_regionId eduId:eduId workeAge:wokeAge workeAge1:wokeAge1 keyWord:keywords pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:15 searchType:searchType];
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_CompanySearchResume:
        {
            shouldRefresh_ = NO;
            
            userModelInfo = dataArr[0];
            if ([userModelInfo.code_ isEqualToString:@"1"]) {
                [requestCon_.dataArr_ removeAllObjects];
                [_informalMemberTiPView setHidden:NO];
                [_conditionView setHidden:YES];
                [tableView_ setHidden:YES];
                self.title = @"简历搜索";
                [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
            
            }else{
                [_informalMemberTiPView setHidden:YES];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
                [self.navigationItem.rightBarButtonItem.customView setAlpha:1.0];
                self.navigationItem.titleView = searchView;
            }
        }
            break;
        default:
            break;
    }
    
}
#pragma mark--代理--
#pragma mark--tableView delegate
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHRResumeCell";
    CHRResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLb.hidden = YES;
        cell.joinStateLb.hidden = YES;
    }
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
   
    cell.userNameLb.text = userModel.name_;
    
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;
    
    NSString *sex = userModel.sex_;
    [cell.sexBtn setTitle:userModel.age_ forState:UIControlStateNormal];
    if ([sex isEqualToString:@"男"]) {
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else if ([sex isEqualToString:@"女"]){
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }else{
        [cell.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    
    if ([userModel.kj isEqualToString:@"0"]) {
        [cell.isDownImgv setHidden:YES];
        [cell.statusLb setHidden:NO];
        [cell.statusLb setText:@"保密"];
    }else{
        if ([userModel.isDown isEqualToString:@"1"]) {
            cell.isDownImgv.hidden = NO;
        }else{
            cell.isDownImgv.hidden = YES;
        }
        [cell.statusLb setHidden:YES];
    }
    
    NSDictionary *nameAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
    if (city.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:city attributes:nameAttr]];
        if (workAge.length > 0 || eduName.length > 0) {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
    }
    if (workAge.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@年工作经验", workAge] attributes:nameAttr]];
        if (eduName.length > 0) {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
    }
    if (eduName.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", eduName] attributes:nameAttr]];
    }
    cell.summaryLb.attributedText = attrString;
    if (userModel.job_) {
        cell.jobLb.text =[NSString stringWithFormat:@"意向职位: %@", userModel.job_];
    }else{
        cell.jobLb.text = @"";
    }
    NSString *time = [self dealTime:userModel.sendtime_];
    cell.timeLb.text = time;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132.0f;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal *dataModal = (User_DataModal *)selectData;
    RecommendResumePreviewCtl * resumePreviewCtl = [[RecommendResumePreviewCtl alloc] init];
    resumePreviewCtl.resumeType = _resumeType;
    resumePreviewCtl.delegate_ = self;
    resumePreviewCtl.isResumeSearch = YES;
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:_companyId];
    
}
 
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [resumeSearchBar resignFirstResponder];
    [_keyWorkTF resignFirstResponder];
}

#pragma mark--DownloadResumeDelegate
-(void)hideKeyboard
{
    [_keyWorkTF resignFirstResponder];
}
 

#pragma DownloadResumeDelegate
-(void)downloadResume:(User_DataModal *)dataModal
{
    dataModal.isDown = @"1";
    [tableView_ reloadData];
}

#pragma mark--textFiled Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _keyWorkTF) {
        [_keyWorkTF resignFirstResponder];
        [self refreshLoad:nil];
    }
    [self hideSearchConView];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    [self hideSearchConView];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [self hideSearchConView];
    return YES;
}
#pragma mark--scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self hideSearchConView];
    [_keyWorkTF resignFirstResponder];
}

#pragma mark--事件--
- (void)rightBarBtnResponse:(id)sender
{
    [_keyWorkTF resignFirstResponder];
    [self hideSearchConView];
    [self refreshLoad:nil];
}

-(void)btnResponse:(id)sender
{
    if (sender == _cityBtn) {
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        __weak typeof(CompanySearchCtl) *weakSelf = self;
        vc.blockString = ^(SqlitData *regionModel){
            NSLog(@"%@ %@",regionModel.provinceld, regionModel.provinceName);
            weakSelf.regionId = regionModel.provinceld;
            [weakSelf.cityBtn setTitle:regionModel.provinceName forState:UIControlStateNormal];
            [self confiBtnTitleFrame];
            [weakSelf refreshLoad:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender == _workAgeBtn){//工作年限选择
        ConditionItemCtl *conditionItemCtl_ = [[ConditionItemCtl alloc]init];
        conditionItemCtl_.delegate_ = self;
        NSArray *workAgeArray_ = [[NSArray alloc]initWithObjects:@"不限",@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年及以上", nil];
        
        NSArray *workAgeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"1",@"3",@"5",@"10", nil];
        NSArray *workAgeValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"1",@"3",@"5",@"10",@"0", nil];
        
        NSArray *tempArray = [[NSArray alloc]initWithObjects:workAgeArray_,workAgeValueArray_,workAgeValueArray_1, nil];
        [conditionItemCtl_ beginLoad:tempArray exParam:nil];
        [conditionItemCtl_ setConditionType_:condition_WorkAge];
        [self.navigationController pushViewController:conditionItemCtl_ animated:YES];
    }
    else if (sender == _educationLevelBtn){//学历选择
        ConditionItemCtl *conditionItemCtl_ = [[ConditionItemCtl alloc]init];
        conditionItemCtl_.delegate_ = self;
        NSArray *eduArray_ = [[NSArray alloc]initWithObjects:@"不限", @"博士后", @"博士", @"MBA", @"硕士", @"本科", @"大专", @"大专以下", nil];
        NSArray *eduValueArray_ = [[NSArray alloc]initWithObjects:@"", @"90", @"80", @"75", @"70", @"60", @"50", @"lt||30",nil];
        NSArray *tempArray = [[NSArray alloc]initWithObjects:eduArray_,eduValueArray_, nil];
        [conditionItemCtl_ beginLoad:tempArray exParam:nil];
        [conditionItemCtl_ setConditionType_:condition_Edu];
        [self.navigationController pushViewController:conditionItemCtl_ animated:YES];
    }
}

//左侧关键字选择btnClick
-(void)leftBtnClick:(UIButton *)btn{
    
    if (!state) {
        searchCon.hidden = NO;
    }
    else{
        searchCon.hidden = YES;
    }
    NSLog(@"%d",state);
    state = !state;
}

//关键字选择
-(void)btnSelClick:(UIButton *)btn{
    [leftBtn setTitle:btnSelArr[btn.tag - BTN_TAG] forState:UIControlStateNormal];
    _keyWorkTF.placeholder = placehoderArr[btn.tag - BTN_TAG];
    //    keyWorkTF.text = @"";
    if (btn.tag == BTN_TAG) {
        searchType = @"key";
    }
    else if(btn.tag == BTN_TAG + 1){
        searchType = @"job";
    }
    else{
        searchType = @"company";
    }
    state = !state;
    searchCon.hidden = YES;
//    [self refreshLoad:nil];
}

#pragma mark--业务逻辑--
#pragma mark--时间处理 
-(NSString *)dealTime:(NSString *)timeLb{
    NSArray *currentDateArr = [self currentTime];
//    当前天
    NSInteger currentDayNum = [currentDateArr[2] integerValue];
//    当前分钟
    NSInteger currentMinute = [currentDateArr[4] integerValue];
//    当前小时
    NSInteger currentHour = [currentDateArr[3] integerValue];
    
    NSArray *arr = [timeLb componentsSeparatedByString:@" "];
    NSString *dateStr = arr[0];
    NSString *timeStr = arr[1];
    NSArray *dataArr = [dateStr componentsSeparatedByString:@"-"];
    NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
    NSString *lastDataStr = dataArr[2];
    NSInteger lastDayNum = [lastDataStr integerValue];
    if (currentDayNum - lastDayNum == 0) {
        NSInteger lastHour = [timeArr[0] integerValue];
        NSInteger lastMinute = [timeArr[1] integerValue];
        if (currentHour - lastHour == 0) {

            if (currentMinute - lastMinute == 0) {
                return [NSString stringWithFormat:@"刚刚"];
            }else{
                NSInteger min = currentMinute - lastMinute;
                return [NSString stringWithFormat:@"%ld分钟前",(long)min];
            }
        }
        else if(currentHour - lastHour == 1){
            if (currentMinute >= lastMinute){
                return [NSString stringWithFormat:@"1小时前"];
            }
            else{
                return [NSString stringWithFormat:@"%ld分钟前",(long)(60 + currentMinute - lastMinute)];
            }
        }
        else{
            NSInteger hourN = currentHour - lastHour;
            hourN = labs(hourN);
            NSString *hour = [NSString stringWithFormat:@"%ld小时前",(long)hourN];
            return hour;
        }
    }
    else{
        return dateStr;
    }
}

#pragma mark--获取当前时间 
-(NSArray *)currentTime{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY MM dd HH mm ss"];
    NSString *dateString = [formatter stringFromDate:currentDate];
    NSArray *arr = [dateString componentsSeparatedByString:@" "];
    return arr;
}

#pragma mark--条件选择
- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1
{
    switch (type) {
        case condition_WorkAge://工作年限选择
        {
            _paramDataModel.workAgeName_ = conditionName;
            _paramDataModel.workAgeValue_ = conditionValue;
            _paramDataModel.workAgeValue_1 = conditionValue1;
            
            [_workAgeBtn setTitle:conditionName forState:UIControlStateNormal];
        }
            break;
        case condition_Edu://学历选择
        {
            _paramDataModel.eduName_ = conditionName;
            _paramDataModel.eduId_ = conditionValue;
            [_educationLevelBtn setTitle:conditionName forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    [self refreshLoad:requestCon_];
    [self confiBtnTitleFrame];
}

//隐藏关键字选择
-(void)hideSearchConView{
    if (state) {
        searchCon.hidden = YES;
        state = !state;
    }
}

- (void)confiBtnTitleFrame
{
    CGFloat btnWidth = ScreenWidth / 3;
    _cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btnWidth - _cityBtn.imageView.frame.size.width
                                                      - _cityBtn.titleLabel.intrinsicContentSize.width) / 2, 0, 0);
    _cityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, (btnWidth - _cityBtn.imageView.frame.size.width
                                                    - _cityBtn.titleLabel.intrinsicContentSize.width) / 2 + _cityBtn.titleLabel.intrinsicContentSize.width, 0, 0);
    
    _workAgeBtn.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btnWidth - _workAgeBtn.imageView.frame.size.width
                                                      - _workAgeBtn.titleLabel.intrinsicContentSize.width) / 2, 0, 0);
    _workAgeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, (btnWidth - _workAgeBtn.imageView.frame.size.width
                                                    - _workAgeBtn.titleLabel.intrinsicContentSize.width) / 2 + _workAgeBtn.titleLabel.intrinsicContentSize.width, 0, 0);
    
    _educationLevelBtn.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btnWidth - _educationLevelBtn.imageView.frame.size.width
                                                      - _educationLevelBtn.titleLabel.intrinsicContentSize.width) / 2, 0, 0);
    _educationLevelBtn.imageEdgeInsets = UIEdgeInsetsMake(0, (btnWidth - _educationLevelBtn.imageView.frame.size.width
                                                    - _educationLevelBtn.titleLabel.intrinsicContentSize.width) / 2 + _educationLevelBtn.titleLabel.intrinsicContentSize.width, 0, 0);
}

@end
