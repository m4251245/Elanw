//
//  CondictionPlaceCtl_School.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PreCondictionListCtl.h"
#import "CondictionList_DataModal.h"
#import "CondictionList_Cell.h"
#import "CondictionPlaceCtl.h"
#import "Constant.h"
#import "FMDatabase.h"


//相关数据
NSMutableArray         *yearsData;
NSMutableArray         *monthsData;



@implementation PreCondictionListCtl

@synthesize delegate_;

-(id) init
{
    self = [self initWithNibName:PreCondictionListCtl_Xib_Name bundle:nil];
    
    //don't need ego
    bHeaderEgo_ = NO;
    bFooterEgo_ = NO;
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _datePickView_ = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, ScreenHeight-216,ScreenWidth, 216)];
    _datePickView_.datePickerMode = UIDatePickerModeDate;
    [_datePickView_ setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [contentView_ addSubview:_datePickView_];
    self.datePickView_ = _datePickView_;
    
    contentView_.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGestuer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMissGesture:)];
    [contentView_ addGestureRecognizer:tapGestuer];

    okBtn_.clipsToBounds = YES;
    okBtn_.layer.cornerRadius = 3.0;
    
    nullBtn_.clipsToBounds = YES;
    nullBtn_.layer.cornerRadius = 3.0;
    
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
}

-(void)dissMissGesture:(UITapGestureRecognizer *)gesture
{
    [self showContentView:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.view.backgroundColor = [UIColor redColor];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//获取教育str
+(NSString *) getEduStr:(NSString *)eduId
{
    NSString *str = nil;
    if( !eduId ){
        return str;
    }
    PreRequestCon *tempCon = [[PreRequestCon alloc] init];
    
    NSArray *tempArr = [tempCon getLocalData:EduType_XMLParser];
    
    for ( CondictionList_DataModal *dataModal in tempArr ) {
        if( [dataModal.id_ isEqualToString:eduId] ){
            str = dataModal.str_;
            break;
        }
    }
    
    return str;
}

//获取教育Id
+(NSString *) getEduId:(NSString *)eduStr
{
    NSString *str = nil;
    if( !eduStr ){
        return str;
    }
    PreRequestCon *tempCon = [[PreRequestCon alloc] init];
    
    NSArray *tempArr = [tempCon getLocalData:EduType_XMLParser];
    
    for ( CondictionList_DataModal *dataModal in tempArr ) {
        if( [dataModal.str_ isEqualToString:eduStr] ){
            str = dataModal.id_;
            break;
        }
    }
    
    return str;
}

-(void) bePushed:(UIViewController *)ctl
{
    [super bePushed:ctl];
    
    self.delegate_ = (id<CondictionChooseDelegate>)ctl;
}

//开始获取数据
-(void) beginGetData:(id)myParam exParam:(id)exParam type:(CondictionChooseType)type
{
    condictionType_ = type;
    
    self.view.alpha = 1.0;
    
    [self refreshData:myParam exParam:exParam];
    if(condictionType_ == GetPlaceOriginType){
        //籍贯选择
        {
//            self.navigationItem.title = @"籍贯选择";
            [self setNavTitle:@"籍贯选择"];
            if( !regionArr.count ){
                FMDatabase *dataBase;
                @try {
                    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *pathname = [path lastObject];
                    NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
                    dataBase = [FMDatabase databaseWithPath:dbPath];
                    if (![dataBase open]) {
                        NSLog(@"Could not open db.");
                    }
                    
                    NSString *sql1 = [NSString stringWithFormat:@"select * from region_choosen"];
                    FMResultSet *rs = [dataBase executeQuery:sql1];
                    NSMutableArray *resulArr = [NSMutableArray arrayWithCapacity:533];
                    while ([rs next]) {
                        CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
                        model.id_ = [rs stringForColumn:@"selfId"];
                        model.pId_ = [rs stringForColumn:@"parentId"];
                        model.str_ = [rs stringForColumn:@"selfName"];
                        model.bParent_ = [rs boolForColumn:@"level"];
                        [resulArr addObject:model];
                    }
                    regionArr = resulArr;
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    [dataBase close];
                }

            }
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for ( CondictionList_DataModal *dataModal in regionArr ) {
                CondictionList_DataModal *tempDataModal = [[CondictionList_DataModal alloc] init];
                tempDataModal.str_ = dataModal.str_;
                tempDataModal.id_ = dataModal.id_;
                if( !dataModal.bParent_ ){
                    [tempArr addObject:tempDataModal];
                }
            }
            
            [self loadDataComplete:PreRequestCon_ code:Success dataArr:tempArr parserType:PlaceOrigin_XMLParser];
        }
        
    }
}

//显示/隐藏自己
-(void) showContentView:(BOOL)flag
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIViewController *ctl = window.rootViewController;
    
    if( flag ){
        [ctl.view addSubview:contentView_];
        
        CGRect rect = contentView_.frame;
        rect.origin.y = ctl.view.frame.size.height;
        rect.size.height = ctl.view.frame.size.height;
        rect.size.width = ScreenWidth;
        [contentView_ setFrame:rect];
        
        rect.origin.y = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [contentView_ setFrame:rect];
        [UIView commitAnimations];
    }else{
        CGRect rect = contentView_.frame;
        rect.origin.y = ctl.view.frame.size.height;
        rect.size.height = ctl.view.frame.size.height;
        rect.size.width = ScreenWidth;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [contentView_ setFrame:rect];
        [UIView commitAnimations];
    }
}

-(void) getDataFunction
{
//    if( !presentCtl_ ){
//        presentCtl_ = [[UIViewController alloc] init];
//    }
//    
//    presentCtl_.view = contentView_;
    
    //初始化年份数据
    if( !yearsData ){
        yearsData = [[NSMutableArray alloc] init];
        //初始化年份数据
        for ( int i = 1970 ; i < 2020 ; ++i ) {
            [yearsData addObject:[[NSString alloc] initWithFormat:@"%d",i]];
        }
    }
    
    //初始化月份数据
    if( !monthsData ){
        monthsData = [[NSMutableArray alloc] init];
        for ( int i = 1 ; i <= 12 ; ++i ) {
            [monthsData addObject:[[NSString alloc] initWithFormat:@"%d",i]];
        }
    }
    
    nullBtn_.alpha = 0.0;
    timeToNowBtn_.alpha = 0.0;
    _datePickView_.alpha = 0.0;
    pickView_.alpha = 1.0;
    
    switch ( condictionType_ ) {
            //职位发布时间
        case GetDateType:
//            self.navigationItem.title = @"时间选择";
            [self setNavTitle:@"时间选择"];
            [PreRequestCon_ getZWDateType];
            break;
            //学历
        case GetEduType:
//            self.navigationItem.title = @"学历选择";
            [self setNavTitle:@"学历选择"];
            [PreRequestCon_ getEduType];
            break;
            //工作年限
        case GetYearType:
//            self.navigationItem.title = @"工作年限选择";
            [self setNavTitle:@"工作年限选择"];
            [PreRequestCon_ getYearType];
            break;
            //现有职称
        case GetPostionLevelType:
//            self.navigationItem.title = @"职称选择";
            [self setNavTitle:@"职称选择"];
            [PreRequestCon_ getPostionLevelType];
            break;
            //婚姻状况
        case GetMarrayType:
//            self.navigationItem.title = @"婚姻选择";
            [self setNavTitle:@"婚姻选择"];
            [PreRequestCon_ getMarryType];
            break;
            //政治面貌
        case GetPoliticsType:
//            self.navigationItem.title = @"政治面貌选择";
            [self setNavTitle:@"政治面貌选择"];
            [PreRequestCon_ getPoliticsType];
            break;
            //民族选择
        case GetNationType:
//            self.navigationItem.title = @"民族选择";
            [self setNavTitle:@"民族选择"];
            [PreRequestCon_ getNationType];
            break;
            //求职类型
        case GetJobType:
//            self.navigationItem.title = @"求职类型选择";
            [self setNavTitle:@"求职类型选择"];
            [PreRequestCon_ getJobType];
            break;
            //可到职日期
        case GetWorkDateType:
//            self.navigationItem.title = @"可到职日期选择";
            [self setNavTitle:@"可到职日期选择"];
            [PreRequestCon_ getWorkDateType];
            break;
            //专业类别
        case GetZyeType:
//            self.navigationItem.title = @"专业类别选择";
            [self setNavTitle:@"专业类别选择"];
            [PreRequestCon_ getZyeType];
            break;
            //所有专业类别
        case GetZyeHaveAllType:
//            self.navigationItem.title = @"专业类别选择";
            [self setNavTitle:@"专业类别选择"];
            [PreRequestCon_ getZyeAllType];
            break;
            //专业名称
        case GetMajorNameType:
//            self.navigationItem.title = @"专业名称选择";
            [self setNavTitle:@"专业名称选择"];
            [PreRequestCon_ getMajorNameType:exParam_];
            break;
            //公司规模
        case GetCompanyEmployeType:
//            self.navigationItem.title = @"公司规模选择";
            [self setNavTitle:@"公司规模选择"];
            [PreRequestCon_ getCompanyEmployType];
            break;
            //公司性质
        case GetCompanyAttType:
//            self.navigationItem.title = @"公司性质选择";
            [self setNavTitle:@"公司性质选择"];
            [PreRequestCon_ getCompanyAttType];
            break;
            //年薪
        case GetYearSalayType:
//            self.navigationItem.title = @"年薪选择";
            [self setNavTitle:@"年薪选择"];
            [PreRequestCon_ getYearSalaryType];
            break;
            //年终奖
        case GetYearBounsType:
//            self.navigationItem.title = @"年终奖选择";
            [self setNavTitle:@"年终奖选择"];
            [PreRequestCon_ getYearBounsType];
            break;
            //职位类型选择
        case GetPartJobType:
//            self.navigationItem.title = @"职位类型选择";
            [self setNavTitle:@"职位类型选择"];
            [PreRequestCon_ GetPartJobType];
            break;
            
            //选择有不限的时间
        case GetDateHaveNullType:
        {
            nullBtn_.alpha = 1.0;

            [self showContentView:YES];
            
            [_datePickView_ setDate:[NSDate date] animated:YES];
            _datePickView_.alpha = 1.0;
            pickView_.alpha = 0.0;
        }
            break;
            //定位范围
        case GetMapRangType:
        {
            [PreRequestCon_ getMapRangType];
            
            [self showContentView:YES];
            
            _datePickView_.alpha = 0.0;
        }
            break;
            //出生日期
        case GetBirthDayDateType:
        {
            [self showContentView:YES];
            
            [_datePickView_ setDate:myParam_?myParam_:[NSDate date] animated:YES];
            _datePickView_.alpha = 1.0;
            pickView_.alpha = 0.0;
        }
            break;
            //年-月
        case GetYearMonthDateType:
        {
            [self showContentView:YES];
            
            _datePickView_.alpha = 1.0;
            pickView_.alpha = 0.0;
        }
            break;
            //年-月(有至今)
        case GetYearMonthDateHaveToNowType:
        {
            timeToNowBtn_.alpha = 1.0;
            
            [self showContentView:YES];
            
            _datePickView_.alpha = 1.0;
            pickView_.alpha = 0.0;
        }
            break;
            //结束时间
        case GetEndDateType:
        {
            timeToNowBtn_.alpha = 1.0;
            
            [self showContentView:YES];
            
            _datePickView_.alpha = 1.0;
            pickView_.alpha = 0.0;
        }
            break;
        default:
            break;
    }
}

-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    if( _datePickView_.alpha == 0.0 ){
        //set delegate
        pickView_.delegate = self;
        pickView_.dataSource = self;
        [pickView_ reloadAllComponents];
    }
}

-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    CondictionList_DataModal *dataModal = selectData;
    if( dataModal.bParent_ ){
        //push sub
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        [delegate_ condictionChooseComplete:self dataModal:selectData type:condictionType_];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    CondictionList_Cell *cell = (CondictionList_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CondictionList_Cell" owner:self options:nil] lastObject];
        
        //自定义cell的背景
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
//        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
//        [imageView setFrame:cell.frame];
//        [cell setBackgroundView:imageView];
    }
    
    //学校名称
    UILabel *textLb = (UILabel *)[cell viewWithTag:100];
    
    CondictionList_DataModal *dataModal = [resultArr_ objectAtIndex:[indexPath row]];
    textLb.text = dataModal.str_;

    if( dataModal.bParent_ ){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(16, 49, ScreenWidth - 16, 1)];
    view.backgroundColor = UIColorFromRGB(0xecedec);
    [cell.contentView addSubview:view];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma UIPickView Delegate/DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger count = 0;
    switch ( condictionType_ )
    {
        case GetMapRangType:
            count = 1;
            break;
        case GetYearMonthDateType:
            count = 2;
            break;
        case GetYearMonthDateHaveToNowType:
            count = 2;
            break;
        default:
            break;
    }
    
    return count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    switch ( condictionType_ )
    {
        case GetMapRangType:
            count = [resultArr_ count];
            break;
        case GetYearMonthDateType:
        {
            //返回年
            if( component == 0 )
            {
                count = [yearsData count];
            }
            //返回月
            else
            {
                count = [monthsData count];
            }
        }
            break;
        case GetYearMonthDateHaveToNowType:
        {
            //返回年
            if( component == 0 )
            {
                count = [yearsData count];
            }
            //返回月
            else
            {
                count = [monthsData count];
            }
        }
            break;
        default:
            break;
    }
    
    return count;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int width = 0;
    switch ( condictionType_ )
    {
        case GetMapRangType:
            width = 300;
            break;
        case GetYearMonthDateType:
        {
            width = 150;
        }
            break;
        case GetYearMonthDateHaveToNowType:
        {
            width = 150;
        }
            break;
        default:
            break;
    }
    
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    switch ( condictionType_ )
    {
        case GetMapRangType:
        {
            CondictionList_DataModal *dataModal = [resultArr_ objectAtIndex:row];
            str = dataModal.str_;
        }
            break;
        case GetYearMonthDateType:
        {
            //返回年
            if( component == 0 )
            {
                str = [[NSString alloc] initWithFormat:@"%@年",[yearsData objectAtIndex:row]];
            }
            //返回月
            else
            {
                str = [[NSString alloc] initWithFormat:@"%@月",[monthsData objectAtIndex:row]];
            }
        }
            break;
        case GetYearMonthDateHaveToNowType:
        {
            //返回年
            if( component == 0 )
            {
                str = [[NSString alloc] initWithFormat:@"%@年",[yearsData objectAtIndex:row]];
            }
            //返回月
            else
            {
                str = [[NSString alloc] initWithFormat:@"%@月",[monthsData objectAtIndex:row]];
            }
        }
            break;
        default:
            break;
    }
    
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch ( condictionType_ )
    {
        case GetMapRangType:
        {
            selectIndex_ = row;
        }
            break;
        case GetYearMonthDateType:
        {
            //返回年
            if( component == 0 )
            {
                yearsIndex_ = row;
            }
            //返回月
            else
            {
                monthsIndex_ = row;
            }
        }
            break;
        case GetYearMonthDateHaveToNowType:
        {
            //返回年
            if( component == 0 )
            {
                yearsIndex_ = row;
            }
            //返回月
            else
            {
                monthsIndex_ = row;
            }
        }
            break;
        default:
            break;
    }
}

-(void) buttonResponse:(id)sender
{
    //搜索范围或日期选定了
    if( sender == okBtn_ )
    {
        switch ( condictionType_ ) {
            case GetBirthDayDateType:
            {
//                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//                UIViewController *ctl = window.rootViewController;
                
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                dataModal.str_ = [PreCommon getDateStr:[_datePickView_ date]];
                dataModal.id_ = dataModal.str_;
                if ([delegate_ respondsToSelector:@selector(condictionChooseComplete:dataModal:type:)]) {
                    [delegate_ condictionChooseComplete:self dataModal:dataModal type:condictionType_];
                }
                [self showContentView:NO];
            }
                break;
            case GetDateHaveNullType:
            {
//                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//                UIViewController *ctl = window.rootViewController;
                
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                dataModal.str_     = [PreCommon getDateStr:[_datePickView_ date]];
                dataModal.id_      = dataModal.str_;
                
                [delegate_ condictionChooseComplete:self dataModal:dataModal type:condictionType_];
                
                //[ctl dismissModalViewControllerAnimated:YES];
                [self showContentView:NO];
            }
                break;
            case GetEndDateType:
            {
//                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//                UIViewController *ctl = window.rootViewController;
                
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                dataModal.str_     = [PreCommon getDateStr:[_datePickView_ date]];
                dataModal.id_      = dataModal.str_;
                
                [delegate_ condictionChooseComplete:self dataModal:dataModal type:condictionType_];

                //[ctl dismissModalViewControllerAnimated:YES];
                [self showContentView:NO];
            }
                break;
            case GetMapRangType:
            {
//                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//                UIViewController *ctl = window.rootViewController;
                
                [delegate_ condictionChooseComplete:self dataModal:[resultArr_ objectAtIndex:selectIndex_] type:condictionType_];
                
                //[ctl dismissModalViewControllerAnimated:YES];
                [self showContentView:NO];
            }
                break;
            case GetYearMonthDateType:
            {
//                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//                UIViewController *ctl = window.rootViewController;
                
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                //开始组装数据
//                dataModal.str_ = [[NSString alloc] initWithFormat:@"%@年%@%@月",[yearsData objectAtIndex:yearsIndex_],Cer_Date_Add_Inditifer,[monthsData objectAtIndex:monthsIndex_]];
                NSString *dateStr = [PreCommon getDateStr:[_datePickView_ date]];
                if (dateStr.length > 7)
                {
                    dataModal.str_ = [NSString stringWithFormat:@"%@年-%@月",[dateStr substringWithRange:NSMakeRange(0,4)],[dateStr substringWithRange:NSMakeRange(5,2)]];
                    dataModal.id_ = dataModal.str_;
                    dataModal.pId_ = [NSString stringWithFormat:@"%@.%@",[dateStr substringWithRange:NSMakeRange(0,4)],[dateStr substringWithRange:NSMakeRange(5,2)]];
                    if ([[_datePickView_ date] isEqualToDate:[[NSDate date] laterDate:[_datePickView_ date]]])
                    {
                        dataModal.isFutureTime = YES;
                    }
                    dataModal.oldString = dateStr;
                }
                
                [delegate_ condictionChooseComplete:self dataModal:dataModal type:condictionType_];
                
                //[ctl dismissModalViewControllerAnimated:YES];
                [self showContentView:NO];
            }
                break;
            case GetYearMonthDateHaveToNowType:
            {
//                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//                UIViewController *ctl = window.rootViewController;
                
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                
                //开始组装数据
//                dataModal.str_ = [[NSString alloc] initWithFormat:@"%@年%@%@月",[yearsData objectAtIndex:yearsIndex_],Cer_Date_Add_Inditifer,[monthsData objectAtIndex:monthsIndex_]];
                NSString *dateStr = [PreCommon getDateStr:[_datePickView_ date]];
                if (dateStr.length > 7)
                {
                    dataModal.str_ = [NSString stringWithFormat:@"%@年-%@月",[dateStr substringWithRange:NSMakeRange(0,4)],[dateStr substringWithRange:NSMakeRange(5,2)]];
                    dataModal.id_ = dataModal.str_;
                    dataModal.pId_ = [NSString stringWithFormat:@"%@.%@",[dateStr substringWithRange:NSMakeRange(0,4)],[dateStr substringWithRange:NSMakeRange(5,2)]];
                    if ([[_datePickView_ date] isEqualToDate:[[NSDate date] laterDate:[_datePickView_ date]]])
                    {
                        dataModal.isFutureTime = YES;
                    }
                    dataModal.oldString = dateStr;
                }
                dataModal.id_ = dataModal.str_;
                
                [delegate_ condictionChooseComplete:self dataModal:dataModal type:condictionType_];
                
                //[ctl dismissModalViewControllerAnimated:YES];
                [self showContentView:NO];
            }
                break;
                
            default:
                break;
        }
        
    }
    //选择了至今
    else if( sender == timeToNowBtn_ )
    {
//        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//        UIViewController *ctl = window.rootViewController;
        
        CondictionList_DataModal *timeToNowDataMomal = [[CondictionList_DataModal alloc] init];
        timeToNowDataMomal.str_ = TimeToNow_Str;
        timeToNowDataMomal.id_ = TimeToNow_Str;
        [delegate_ condictionChooseComplete:self dataModal:timeToNowDataMomal type:condictionType_];
        
        //[ctl dismissModalViewControllerAnimated:YES];
    
        [self showContentView:NO];
    }
    else if( sender == nullBtn_ )
    {
//        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//        UIViewController *ctl = window.rootViewController;
        
        [delegate_ condictionChooseComplete:self dataModal:nil type:condictionType_];
//        [ctl dismissModalViewControllerAnimated:YES];
  
        [self showContentView:NO];
    }
}

@end
