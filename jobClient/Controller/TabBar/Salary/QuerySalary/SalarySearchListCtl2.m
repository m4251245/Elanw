//
//  SalaryListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//
#define kJobTagOffSet 200
#define kFootViewTag 101

#import "SalarySearchListCtl2.h"
#import "SalaryCtl_Cell.h"
#import "ChangeRegionViewController.h"
#import "BuySalaryServiceCtl.h"
#import "HotJob_DataModel.h"
#import "ProfessionView.h"
#import "ProfesssionListCtl.h"
#import "EFloatBox.h"
#import "UIButton+WebCache.h"

@interface SalarySearchListCtl2 ()
{
    NSString * locationCity_;
    NSArray  * colorArr_;
    NSString * sum_;
    BOOL shouldRefresh_ ;
    RequestCon *_querySalaryCountCon;
    RequestCon *_salaryHotJobCon;//热门职业
    RequestCon *_salaryMapCon; //薪指地图
    CGPoint scrollSet;
    NSMutableArray *_hotJobArr;
    BOOL _isOpen;
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation SalarySearchListCtl2

-(id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    validateSeconds_ = 600;
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    regionModel_ = [[SqlitData alloc]init];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"查工资";
    [self setNavTitle:@"查工资"];
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [locationBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [locationBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [jobTF_ setFont:FOURTEENFONT_CONTENT];
    [jobTF_ setTextColor:BLACKCOLOR];
    regionModel_.provinceName = @"全国";
    [locationBtn_ setTitle:@"全国" forState:UIControlStateNormal];
    
    competeBtn_.layer.cornerRadius = 4.0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
        
    }
    if (_salaryMapCon) {
        [_salaryMapCon stopConnWhenBack];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( shouldRefresh_ ) {
        [self refreshLoad:requestCon_];
        shouldRefresh_ = NO;
    }
//    self.navigationItem.title = @"查工资";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setBtnTitle:(NSString*)str
{
    [locationBtn_ setTitle:str forState:UIControlStateNormal];
}

-(void)updateCom:(RequestCon *)con
{
  
    if (con && con == requestCon_) {
        if (_provinceName) {
            [locationBtn_ setTitle:_provinceName forState:UIControlStateNormal];
            jobTF_.text = _keyWords;
            _provinceName = nil;
            _keyWords = nil;
        }
    }
    NSString *jobStr;
    if (_keyWords) {
        jobStr = _keyWords;
    }else{
        jobStr = jobTF_.text;
    }
    CGSize size = [jobStr sizeNewWithFont:FOURTEENFONT_CONTENT ];
    if (size.width>200) {
        size.width = 200;
    }
    UILabel *jobLb = (UILabel *)[_headerView viewWithTag:111];
    CGRect frame = jobLb.frame;
    frame.size.width = size.width+5;
    jobLb.frame = frame;
    jobLb.text = jobStr;
    CGFloat tipX = CGRectGetMaxX(jobLb.frame);
    UILabel *tipLb = (UILabel *)[_headerView viewWithTag:112];
    frame = tipLb.frame;
    frame.origin.x = tipX;
    tipLb.frame = frame;
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (_provinceId) {
        regionModel_.provinceld = _provinceId;
        _provinceId = nil;
    }else{
        regionModel_.provinceName = locationBtn_.titleLabel.text;
        regionModel_.provinceld = [CondictionListCtl getRegionId:regionModel_.provinceName];
    }
    
    if (!regionModel_.provinceld || [regionModel_.provinceld isEqualToString:@""]) {
        regionModel_.provinceld = @"";
    }
    if (!jobTF_.text) {
        jobTF_.text = @"";
    }
    
    keyword_ = [jobTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([keyword_ isEqualToString:@""])
    {
        jobTF_.text = @"";
    }
    if (_keyWords) {
        keyword_ = _keyWords;
    }
   
    if (requestCon_.pageInfo_.currentPage_ == 0) {
        _salaryMapCon = [self getNewRequestCon:NO];
        [_salaryMapCon getSalaryMap:regionModel_.provinceld position:keyword_];
    }
    if (!_kwFlag || [_kwFlag isEqualToString:@""]) {
        _kwFlag = @"2";
    }
    [con getSalaryList:keyword_  keywordFlag:_kwFlag region:regionModel_.provinceld page:requestCon_.pageInfo_.currentPage_ pageSize:20 userId:[Manager getUserInfo].userId_];
    _kwFlag = @"2";
}

- (void)errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type
{
    [super errorGetData:requestCon code:code type:type];
    [tableView_.tableHeaderView setHidden:YES];
    [tableView_.tableHeaderView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width, 0)];
    [_headerView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width,0)];
    tableView_.tableHeaderView = _headerView;
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetSalaryCompeteSum:
        {
            sum_ = [dataArr objectAtIndex:0];
        }
            break;
        case Request_SalaryList:
        {
            shouldRefresh_ = NO;
            if (!requestCon_.dataArr_.count) {
                self.imgTopSpace = 60;
                self.noDataImgStr = @"img_search_noData.png";
                self.noDataTips = @"暂无相关结果，替换关键词再试试吧";
                UIView *noDataOkView = [self getNoDataView];
                tableView_.tableFooterView = noDataOkView;
            }else{
                tableView_.tableFooterView = nil;
            }
        }
            break;
        case Request_GetQuerySalaryCount://查询薪指的次数
        {
            NSDictionary *dic = dataArr[0];
            NSString *salaryQueryCount = dic[@"last_select_nums"];
            if (!salaryQueryCount || [salaryQueryCount isEqualToString:@""] || [salaryQueryCount isEqualToString:@"0"])
            {//没有查询的次数 跳转到购买的页面
                BuySalaryServiceCtl *buyCtl = [[BuySalaryServiceCtl alloc]init];
                NSString *orderNum = dic[@"no_pay_cnt"];
                buyCtl.orderNum = orderNum;
                [self.navigationController pushViewController:buyCtl animated:YES];
                [buyCtl beginLoad:nil exParam:nil];
            }
            else if ([salaryQueryCount intValue]){
                //友盟统计点击数
                NSDictionary * dict = @{@"Function":@"看看我能打败多少人"};
                [MobClick event:@"vsPay" attributes:dict];
                NSString *orderNum = dic[@"no_pay_cnt"];
                SalaryCompeteCtl *salaryCompeteCtl_ = [[SalaryCompeteCtl alloc] init];
                salaryCompeteCtl_.type_ = 2;
                salaryCompeteCtl_.kwFlag_ = @"1";
                salaryCompeteCtl_.orderNum = orderNum;
                [self.navigationController pushViewController:salaryCompeteCtl_ animated:YES];
                [salaryCompeteCtl_ beginLoad:[Manager getUserInfo].trade_ exParam:nil];
            }
        }
            break;
        case request_SalaryMap://薪指图表
        {
            NSDictionary *dict = dataArr[0];
            [self layoutSalaryMap: dict];
        }
            break;
        default:
            break;
    }
}

#pragma mark 显示薪指图表
- (void)layoutSalaryMap:(NSDictionary *)mapDic
{
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
    }
    if (_imageV) {
        [_imageV removeFromSuperview];
    }
    
    NSArray *infoArr = mapDic[@"data"][@"info"];

    NSMutableArray *temp = [NSMutableArray array];

    for (int i=0; i<infoArr.count; i++) {
        @try {
            NSDictionary *dic = infoArr[i];
            NSString *key = dic.allKeys[0];
            float value = [dic.allValues[0] floatValue];
            NSArray *keysArr = [key componentsSeparatedByString:@"-"];
            int start = 0;
            int end = 0;
            if ([keysArr[0] isEqualToString:@"0"]) {
                start = 0;
            }else{
                start = ([keysArr[0] intValue])/1000;
            }
            end = ([keysArr[1] intValue])/1000;
            NSString *labelStr;
            if (i == infoArr.count-1) {
                labelStr = [NSString stringWithFormat:@">%dk", start];
            }else{
                labelStr = [NSString stringWithFormat:@"%d-%dk", start, end];
            }
            EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:labelStr value:value index:i unit:@""];
            [temp addObject:eColumnDataModel];
        }
        @catch (NSException *exception) {
            
        }
    }
    
    _data = [NSArray arrayWithArray:temp];
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 80, ScreenWidth-80, 120)];
    [_eColumnChart setBackgroundColor:[UIColor clearColor]];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, ScreenWidth-20, 200)];
    _imageV = imageV;
    [imageV setImage:[UIImage imageNamed:@"xinchoubg.png"]];
    UILabel *yLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
    [imageV addSubview:yLb];
    [yLb setTextColor:[UIColor whiteColor]];
    [yLb setFont: [UIFont fontWithName:@"STHeitiSC-Medium" size:8]];
    [yLb setText:@"占比(%)"];
    
    UILabel *titileLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-130, 10, 90, 20)];
    [imageV addSubview:titileLb];
    [titileLb setTextColor:[UIColor whiteColor]];
    [titileLb setFont: [UIFont fontWithName:@"STHeitiSC-Medium" size:8]];
    [titileLb setText:@"各收入档次人员所占比例"];
    
    UIImageView *markImagev = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-142, 15, 10, 10)];
    [markImagev setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:97.0/255.0 blue:88.0/255.0 alpha:1.0]];
    markImagev.layer.cornerRadius = 1.0;
    markImagev.layer.borderColor = [UIColor whiteColor].CGColor;
    markImagev.layer.borderWidth = 0.5;
    [imageV addSubview:markImagev];
    
    UILabel *unitLb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-70, 180, 50, 20)];
    [imageV addSubview:unitLb];
    [unitLb setTextColor:[UIColor whiteColor]];
    [unitLb setFont: [UIFont fontWithName:@"STHeitiSC-Medium" size:8]];
    [unitLb setText:@"薪酬(K:千元)"];
    
    
    [tableView_.tableHeaderView setHidden:NO];
    [tableView_.tableHeaderView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width,260)];
    [_headerView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width,260)];
    tableView_.tableHeaderView = _headerView;
    
    
    [tableView_.tableHeaderView addSubview:imageV];
    
    [tableView_.tableHeaderView addSubview:_eColumnChart];
}


#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
    {
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    if (singleTapRecognizer_) {
        [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
        singleTapRecognizer_ = nil;
    }
    [jobTF_ resignFirstResponder];
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            break;
        default:
            break;
    }
}

#pragma CondictionListDelegate
-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal
{
    if( !dataModal ){
        dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.str_ = @"全国";
    }
    
    switch ( ctl.type_ ) {
        case CondictionType_Region:
        {
            [locationBtn_ setTitle:dataModal.str_ forState:UIControlStateNormal];
            locationCity_ = dataModal.str_;
            
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
    
    [locationBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [locationBtn_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
}

//返回地区进行查询
- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    regionModel_ = regionModel;
    if (regionModel.provinceName.length >= 4) {
        [locationBtn_ setTitle:[regionModel.provinceName substringWithRange:NSMakeRange(0, 4)] forState:UIControlStateNormal];
    }else{
        [locationBtn_ setTitle:regionModel.provinceName forState:UIControlStateNormal];
    }
    [self refreshLoad:nil];
}

#pragma ChooseHotCityDelegate
-(void)chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    [locationBtn_ setTitle:city forState:UIControlStateNormal];
    locationCity_ = city;
    [self refreshLoad:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = tableView_.contentSize.height > tableView_.bounds.size.height ? tableView_.contentSize.height : tableView_.bounds.size.height;
    [refreshFooterView_ setFrame:CGRectMake(0.0f, height, tableView_.frame.size.width, tableView_.bounds.size.height)];
    static NSString *CellIdentifier = @"SalaryCtlCell";
    
    SalaryCtl_Cell *cell = (SalaryCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SalaryCtl_Cell" owner:self options:nil] lastObject];
        //cell其他地方有使用
        cell.resumeLookBtn.hidden = NO;
    }
    ELSalaryResultModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    [cell setDataModal:dataModal];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        return;
    }
    //记录友盟统计模块使用量
    NSDictionary * dict = @{@"Function":@"薪指"};
    [MobClick event:@"personused" attributes:dict];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    SalaryGuideCtl *salaryGuideCtl = [[SalaryGuideCtl alloc] init];
    salaryGuideCtl.bgColor_ = [colorArr_ objectAtIndex:indexPath.row%4];
    [self.navigationController pushViewController:salaryGuideCtl animated:YES];
    ELSalaryResultModel * dataModal = selectData;
    if ([keyword_ length] > 0) {
        dataModal.zw_typename = keyword_;
        salaryGuideCtl.kwFlag_ = @"0";
    }
    else
        salaryGuideCtl.kwFlag_ = @"1";
    
    NSString * regionid = [CondictionListCtl getRegionId:locationBtn_.titleLabel.text];
    if (!regionid) {
        regionid = @"";
    }
    salaryGuideCtl.regionId_ = regionid;
    salaryGuideCtl.noFromMessage_ = YES;
    [salaryGuideCtl beginLoad:dataModal exParam:exParam];
}

- (void)getRegionSucess
{
    locationCity_ = [Manager shareMgr].regionName_;
    regionModel_.provinceName = [Manager shareMgr].regionName_;
    [locationBtn_ setTitle:locationCity_ forState:UIControlStateNormal];
    if (!locationCity_ || [locationCity_ isEqual:[NSNull null]]) {
        [locationBtn_ setTitle:@"全国" forState:UIControlStateNormal];
    }
    
    [self refreshLoad:nil];
}

-(void)hideKeyboard
{
    [jobTF_ resignFirstResponder];
}

-(void)btnResponse:(id)sender
{
    [jobTF_ resignFirstResponder];
    if(sender == locationBtn_)
    {
        ChangeRegionViewController *vc = [[ChangeRegionViewController alloc] init];
        vc.blockString = ^(SqlitData *regionModel)
        {
            NSLog(@"%@ %@",regionModel.provinceld, regionModel.provinceName);
            [self chooseCityToSearch:regionModel];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender == searchBtn_)
    {
        if (!jobTF_.text) {
            jobTF_.text = @"";
        }
        
        keyword_ = [jobTF_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([keyword_ isEqualToString:@""])
        {
            jobTF_.text = @"";
        }
        
        [self refreshLoad:nil];
    }
    else if (sender == competeBtn_)
    {//马上查一查
        NSString *userId = [Manager getUserInfo].userId_;
        if (!userId) {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return;
        }
        if (!_querySalaryCountCon) {
            _querySalaryCountCon = [self getNewRequestCon:NO];
        }
        [_querySalaryCountCon getSalaryQueryCountWithUserId:userId];
    }
}

- (void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
}

#pragma mark scrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [jobTF_ resignFirstResponder];
}

-(void)chooseJob:(NSString *)jobName
{
    [jobTF_ setText:jobName];
    [self refreshLoad:nil];
}

#pragma -mark- EColumnChartDataSource
//总共的列数
- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

#pragma mark 多少显示的列
- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart didSelectColumn:(EColumn *)eColumn
{
    NSLog(@"Index: %ld  Value: %f", (long)eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    _valueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidEnterColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did enter %ld", (long)eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"kWh" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];
        
    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _eFloatBox.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart fingerDidLeaveColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did leave %ld", (long)eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [searchBtn_ sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (void)showNoDataOkView:(BOOL)flag
{
    if(flag)
    {
        self.imgTopSpace = 60;
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if(noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            //set the rect
            CGRect rect = noDataOkView.frame;
            rect.size.height = 290;
            [noDataOkView setFrame:rect];
            
            CGSize size = tableView_.contentSize;
            size.height = tableView_.tableFooterView.frame.size.height + noDataOkView.frame.size.height;
            tableView_.contentSize = size;
        }
        else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }else{
        [[self getNoDataView] removeFromSuperview];
    }

}

#pragma mark 退出登录
-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

@end
