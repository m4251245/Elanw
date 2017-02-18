//
//  SalaryListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//看前景
#define kJobTagOffSet 200
#define kFootViewTag 101

#import "SalaryFutureSearchListCtl.h"
#import "SalaryCtl_Cell.h"
#import "HotJob_DataModel.h"
#import "MoreMajorListCtl.h"
#import "EFloatBox.h"
#import "SalaryForecastModel.h"
#import "UIButton+WebCache.h"
#import "SalaryGuideCtl.h"

@interface SalaryFutureSearchListCtl () <UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, NoLoginDelegate>
{
    NSString             *keyword_;
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    SqlitData            *regionModel_;
    FMDatabase           *database;
    BOOL _shouldRefresh ;
    
    NSArray *_yearArray;
    NSMutableArray *_data;
    RequestCon *_salaryCon;
    NSString *_inWorkAge;
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation SalaryFutureSearchListCtl

-(id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    validateSeconds_ = 600;
    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _data = [[NSMutableArray alloc] init];
    regionModel_ = [[SqlitData alloc]init];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"看钱景";
    [self setNavTitle:@"看钱景"];
    _yearArray = @[@"毕业年限", @"1年内", @"1-2年", @"3-5年", @"6-10年", @"10年以上"];
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_yearBtn.titleLabel setFont:FOURTEENFONT_CONTENT];
    [_yearBtn setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
    
    [_majorTF setFont:FOURTEENFONT_CONTENT];
    [_majorTF setTextColor:BLACKCOLOR];
    regionModel_.provinceName = @"全国";
    [_yearBtn setTitle:@"毕业年限" forState:UIControlStateNormal];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        _shouldRefresh = YES;
    }
    if (_salaryCon) {
        [_salaryCon stopConnWhenBack];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( _shouldRefresh ) {
        [self refreshLoad:requestCon_];
        _shouldRefresh = NO;
    }
//    self.navigationItem.title = @"看钱景";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)updateCom:(RequestCon *)con
{
    if (con && con==requestCon_) {
        if (_majorName) {
            [_yearBtn setTitle:_workAge forState:UIControlStateNormal];
            _majorTF.text = _majorName;
            _majorName = nil;
            _inWorkAge = _workAge;
            _workAge = nil;
        }
    }
    
    if (con && con == _salaryCon) {
        UILabel *yearLb = (UILabel *)[_headerView viewWithTag:111];
        NSString *yearStr;
        if (_workAge) {
            yearStr = _workAge;
        }else if (_yearBtn.titleLabel.text){
            yearStr = _yearBtn.titleLabel.text;
        }
        
        yearLb.text = yearStr;
    }
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    regionModel_.provinceld = [CondictionListCtl getRegionId:regionModel_.provinceName];
    if (!regionModel_.provinceld) {
        regionModel_.provinceld = @"";
    }
    if (!_majorTF.text) {
        _majorTF.text = @"";
    }
    
    keyword_ = [_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([keyword_ isEqualToString:@""])
    {
        _majorTF.text = @"";
    }
    NSString *yearStr = _yearBtn.titleLabel.text;
    if (_workAge) {//参数传递
        yearStr = _workAge;
    }
    if (_majorName) {
        _majorTF.text = _majorName;
    }
    NSString *minWorkAge = nil;
    NSString *maxWorkAge = nil;
    if ([yearStr isEqualToString:@"毕业年限"]) {
        minWorkAge = @"0";
        maxWorkAge = @"100";
    }else if ([yearStr isEqualToString:@"1年内"]) {
        minWorkAge = @"0";
        maxWorkAge = @"1";
    }else if ([yearStr isEqualToString:@"1-2年"]) {
        minWorkAge = @"1";
        maxWorkAge = @"2";
    }else if ([yearStr isEqualToString:@"3-5年"]) {
        minWorkAge = @"3";
        maxWorkAge = @"5";
    }else if ([yearStr isEqualToString:@"6-10年"]) {
        minWorkAge = @"6";
        maxWorkAge = @"10";
    }else if ([yearStr isEqualToString:@"10年以上"]) {
        minWorkAge = @"10";
        maxWorkAge = @"100";
    }
    
    NSString *matchModel = nil;
    if (_queryInfo[@"matchModel"] && [_queryInfo[@"matchModel"] isEqualToString:@"equal"]) {
        matchModel = @"equal";
    }else{
        matchModel = @"like";
    }

    if (requestCon_.pageInfo_.currentPage_ == 0) {
        _salaryCon = [self getNewRequestCon:NO];//否则刷新不行
        [_salaryCon getSalaryForecastWithZyName:_majorTF.text minWorkAge:@"0" maxWorkAge:@"100" matchModel:matchModel];
    }
    con.storeType_ = TempStoreType;
    [con getFreshSalaryList:_majorTF.text minWorkAge:minWorkAge  maxWorkAge:maxWorkAge regionId:regionModel_.provinceld page:requestCon_.pageInfo_.currentPage_ pageSize:20];
}



-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case request_getSalaryForecast:
        {
            Status_DataModal *model = [dataArr objectAtIndex:0];
            if ([model.status_ isEqualToString:@"OK"]) {
                [tableView_.tableHeaderView setHidden:NO];
                [tableView_.tableHeaderView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width,320)];
                [self layoutSalaryMap:model.exObjArr_];
                [_headerView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width,320)];
                tableView_.tableHeaderView = _headerView;
            }
            else{
                [tableView_.tableHeaderView setHidden:YES];
                [tableView_.tableHeaderView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width, 0)];
                [_headerView setFrame:CGRectMake(0, 0, tableView_.tableHeaderView.frame.size.width,0)];
                tableView_.tableHeaderView = _headerView;
            }
        }
            break;
        case Request_FreshSalaryList://薪指预测列表
        {
            _shouldRefresh = NO;
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
        
        default:
            break;
    }
}


#pragma mark 显示薪指图表
- (void)layoutSalaryMap:(NSArray *)mapDic
{
    
    if (_eColumnChart) {
        [_eColumnChart removeFromSuperview];
    }
    
    _data = [NSMutableArray array];
    
    for (int i=0; i<mapDic.count; i++) {
        SalaryForecastModel *model = mapDic[i];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:model.year  value:[model.salaryAvg floatValue ] index:i unit:@""];
        [_data addObject:eColumnDataModel];
    }
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 90, ScreenWidth-80, 160)];
    [_eColumnChart setBackgroundColor:[UIColor clearColor]];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, 240)];
    [imageV setImage:[UIImage imageNamed:@"xinchoubg.png"]];
    UILabel *yLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 40, 20)];
    [imageV addSubview:yLb];
    [yLb setTextColor:[UIColor whiteColor]];
    [yLb setFont: [UIFont fontWithName:@"STHeitiSC-Medium" size:8]];
    [yLb setText:@"薪酬(元)"];
    
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    [tableView_.tableHeaderView addSubview:imageV];
    [tableView_.tableHeaderView addSubview:_eColumnChart];
}




#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    //singleTapRecognizer_.delegate = self;
    
    
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
    [_majorTF resignFirstResponder];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
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
    ELSalaryResultModel *model = requestCon_.dataArr_[indexPath.row];
    [cell setDataModalOne:model];
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
    [self.navigationController pushViewController:salaryGuideCtl animated:YES];
    ELSalaryResultModel * dataModal = selectData;
    if ([keyword_ length] > 0) {
        salaryGuideCtl.kwFlag_ = @"0";
    }
    else{
        salaryGuideCtl.kwFlag_ = @"1";
    }
    NSString * regionid = [CondictionListCtl getRegionId:_yearBtn.titleLabel.text];
    if (!regionid) {
        regionid = @"";
    }
    salaryGuideCtl.regionId_ = regionid;
    salaryGuideCtl.noFromMessage_ = YES;
    [salaryGuideCtl beginLoad:dataModal exParam:exParam];
    
}






-(void)hideKeyboard
{
    [_majorTF resignFirstResponder];
}

-(void)btnResponse:(id)sender
{
    [_majorTF resignFirstResponder];
    if(sender == _yearBtn){//选择时间
        [self showYearView];
    }
    else if (sender == _searchBtn) {//搜索

        if (!_majorTF.text) {
            _majorTF.text = @"";
        }
        
        keyword_ = [_majorTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([keyword_ isEqualToString:@""])
        {
            _majorTF.text = @"";
        }
    
        [self refreshLoad:nil];
        return;
    }
    
}

#pragma makr 显示选择时间
- (void)showYearView
{
    UIView *containerView = [[UIView alloc]initWithFrame:self.view.bounds];
    UIView *mask = [[UIView alloc]initWithFrame:containerView.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.5;
    [MyCommon addTapGesture:mask target:self numberOfTap:1 sel:@selector(maskViewClick)];
    [containerView addSubview:mask];
    CGFloat pickY = CGRectGetHeight(containerView.frame) - 160;
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, pickY, ScreenWidth, 160)];
    pickView.delegate =self;
    pickView.dataSource = self;
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.showsSelectionIndicator = YES;
    [containerView addSubview:pickView];
    _pickView = pickView;
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(ScreenWidth-40, pickY, 40, 40);
    [containerView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(selectYearClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:containerView];
    _containerView = containerView;
}

- (void)maskViewClick
{
    [_containerView removeFromSuperview];
}

- (void) selectYearClick
{
    NSInteger row = [_pickView selectedRowInComponent:0];
    [_yearBtn setTitle:[_yearArray objectAtIndex:row] forState:UIControlStateNormal];
    [self maskViewClick];
}

- (void)reciveNewMesageAction:(NSNotificationCenter *)notifcation
{
    
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

-(void)chooseJob:(NSString *)jobName
{
    [_majorTF setText:jobName];
    [self refreshLoad:nil];
}


#pragma mark ---------pickview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _yearArray[row];
}

 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _yearArray.count;
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
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
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

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
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

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
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
    [_searchBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *keywords = _queryInfo[@"keywords"];
    if (![keywords isEqualToString:textField.text ]) {
        _queryInfo[@"matchModel"] = @"like";
    }
    
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
            rect.size.height = ScreenHeight - 30;
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

- (void)dealloc
{
    [database close];
}

@end
