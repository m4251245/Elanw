//
//  ELJobSearchCondictionChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/11/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELJobSearchCondictionChangeCtl.h"
#import "Experience_SelectionTableViewCell.h"

@interface ELJobSearchCondictionChangeCtl () <UITableViewDataSource,UITableViewDelegate,ExDelegate>
{
    
    __weak IBOutlet UITableView *leftTableView;
    __weak IBOutlet UITableView *rightTableView;
    
    NSMutableArray *leftDataArr;
    NSMutableArray *rightDataArr;

    CondictionChangeType changeType;
    id selectModalOne;
    id selectModalTwo;
    DataBase *dataBase;
    id selectChangeModal;
    
    __weak IBOutlet UIView *allBackView;
    
    __weak IBOutlet UIView *tableBackView;
    
    NSMutableArray *tradeAllData;
    NSMutableArray *salaryDataArr;
    
    NSMutableDictionary *moreChangeDic;
    NSMutableArray *moreChangeArr;
    
    IBOutlet UIView *moreLeftView;
    
    IBOutlet UIView *moreRightView;
    
    NSMutableArray *hotRegionArr;
    
    NSMutableArray *xjhSchoolArr;
    
    FMDatabase *schoolDataBase;
    
    NSMutableArray *xjhTimeArr;
    
    NSMutableArray *resumeMoreDataArr;
    NSMutableDictionary *resumeMoreDataDic;
    
    NSMutableArray *experienceArr;
    
    __weak IBOutlet UIView *blackBackView;
    
    Experience_SelectionTableViewCell *selectAgeTwoCell;
    
    NSMutableArray *offerRegionArr;
    NSMutableArray *offerPaiReginArr;
    NSMutableArray *offerJobArr;
    NSMutableArray *offerPaiJobArr;
    
    NSMutableArray *_ageArrary;  /**<存放年龄 */
    NSMutableArray *_educationArr;  /**<学历 */
    
    NSMutableArray *rangeChooseArr;
    NSMutableArray *hotcitySelArr;
    NSMutableArray *gwExperenceArr;
    
    NSMutableArray *gwTradeArr;
    
    NSString *workAgeMore;//工作年限
    NSString *intruduceTimeMore;//发布日期
    NSString *eduMore;//学历要求
    NSString *workConMore;//共作性质
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation ELJobSearchCondictionChangeCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotify];
    self.view.backgroundColor = [UIColor clearColor];
    
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    
    leftTableView.separatorColor = UIColorFromRGB(0xe0e0e0);
    rightTableView.separatorColor = UIColorFromRGB(0xe0e0e0);
    
    leftTableView.tableFooterView = [[UIView alloc]init];
    rightTableView.tableFooterView = [[UIView alloc]init];
    
    leftDataArr = [[NSMutableArray alloc] init];
    rightDataArr = [[NSMutableArray alloc] init];
    
    
    [allBackView addSubview:moreLeftView];
    [allBackView addSubview:moreRightView];
    
    moreLeftView.hidden = YES;
    moreRightView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideView)];
    [blackBackView addGestureRecognizer:tap];
    
    _currentType = HideViewType;
    
    _backBtn.layer.cornerRadius = 3;
    _backBtn.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _backBtn.layer.borderWidth = 1;
    _backBtn.layer.masksToBounds = YES;
    
    [allBackView bringSubviewToFront:moreLeftView];
    [allBackView bringSubviewToFront:moreRightView];
}

-(void)tapHideView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moreCacel" object:nil];
    if ([_delegate_ respondsToSelector:@selector(cancelChangeDelegate)]) {
        [_delegate_ cancelChangeDelegate];
    }
    [self hideView];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

-(void)creatViewWithType:(CondictionChangeType)condictionType selectModal:(id)selectKeyWord
{
    CGRect frame = tableBackView.frame;
    frame.size.height = self.view.frame.size.height - 50;
    tableBackView.frame = frame;
    
    moreLeftView.hidden = YES;
    moreRightView.hidden = YES;
    
    leftTableView.contentOffset = CGPointZero;
    rightTableView.contentOffset = CGPointZero;
    
    changeType = condictionType;
    selectChangeModal = selectKeyWord;
    
    if (condictionType == RegionChange || condictionType == TradeChange || condictionType == XJHRegionChange) {
        leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else{
        leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [leftDataArr removeAllObjects];
    [rightDataArr removeAllObjects];
    [leftTableView reloadData];
    [rightTableView reloadData];
    
    selectModalOne = nil;
    selectModalTwo = nil;
    
    switch (condictionType)
    {
        case RegionChange:
        {
            [self creatRegionModal];
        }
            break;
        case TradeChange:
        {
            [self creatTradeData];
        }
            break;
        case SalaryMonthChange:
        {
            [self creatSalaryData];
        }
            break;
        case MoreChange:
        {
            [self creatMoreChangeData];
        }
            break;
        case XJHRegionChange:
        {
            [self creatXJHRegionData];
        }
            break;
        case XJHSchoolChange:
        {
            [self creatXJHSchooleData];
        }
            break;
        case XJHTimeChange:
        {
            [self creatXJHTimeData];
        }
            break;
        case ExperienceChange:
        {
            [self experienceChangeData];
        }
            break;
        case OfferPaiRegionChange:
        {
            [self offerPaiRegionChangeData];
        }
            break;
        case OfferPaiJobChange:
        {
            [self offerPaiJobChangeData];
        }
            break;
        case AgeChange:
        {
            [self CreateAgeChangeData];
        }
            break;
        case EducationChange:
        {
            [self CreateEducationChangeData];
        }
            break;
        case Range_ChooseChange:
        {
            [self rangeChooseData];
        }
            break;
        case GWexperienceChooseChange:
        {
            [self GWExperienceData];
        }
            break;
        case GWTradeChooseChange:
        {
            [self GWTradeData];
        }
            break;
        case GWMyresumeListPositionChange:
        {
            [self gwMyResumePostionChange];
        }
            break;
        default:
            break;
    }
}
#pragma mark--通知
-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offerPaiRegion:) name:@"offerPaiZoneSel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gwTradeSuccess:) name:@"gwTradeData" object:nil];
}

-(void)gwTradeSuccess:(NSNotification *)notify{
    gwTradeArr = [[NSMutableArray alloc]initWithArray:notify.userInfo[@"gwTrade"]];
}

-(void)offerPaiRegion:(NSNotification *)notify{
    NSNumber *num = notify.object;
    NSInteger numIdx = [num integerValue];
    if ([notify.userInfo[@"offerPaiZone"] count] > 0) {
        if (numIdx == 1) {
            offerPaiReginArr = [[NSMutableArray alloc] initWithArray:notify.userInfo[@"offerPaiZone"]];
        }
        else if(numIdx == 2){
            offerPaiJobArr = [[NSMutableArray alloc] initWithArray:notify.userInfo[@"offerPaiZone"]];
        }
    }
}

//顾问后台我的人才库职位类型筛选
-(void)gwMyResumePostionChange{
    if(_gwPositionArr){
        if ([_gwPositionArr isKindOfClass:[NSMutableArray class]]){
            [leftDataArr addObjectsFromArray:_gwPositionArr];
        }
        if (leftDataArr.count > 0){
            if (selectChangeModal) {
                selectModalOne = selectChangeModal;
            }else{
                selectModalOne = [leftDataArr firstObject];
            }
            [self reConfigUI:changeType];
            [leftTableView reloadData];
            [rightTableView reloadData];
        }
    }
}

//offer派地区筛选
-(void)offerPaiRegionChangeData
{
    if (!offerRegionArr) 
    {
        if (offerPaiReginArr.count > 0) {
            offerRegionArr = [[NSMutableArray alloc] initWithArray:offerPaiReginArr];
            [leftDataArr addObjectsFromArray:offerRegionArr];
            if (!selectModalOne) {
                selectModalOne = offerRegionArr[0];
            }
            [self reConfigUI:changeType];
            [leftTableView reloadData];
        }
        
    }
    else
    {
        [leftDataArr addObjectsFromArray:offerRegionArr];
        
        if (selectChangeModal) {
            CondictionList_DataModal *dataModal = selectChangeModal;
            if (dataModal.id_.length > 0) 
            {
                for (NSInteger i=0;i<offerRegionArr.count;i++)
                {
                    CondictionList_DataModal *modal = offerRegionArr[i];
                    if ([dataModal.id_ isEqualToString:modal.id_]) {
                        selectModalOne = modal;
                        [rightDataArr addObjectsFromArray:modal.dataArr];
                        break;
                    }
                    for (NSInteger i=0;i<modal.dataArr.count;i++)
                    {
                        CondictionList_DataModal *modalOne = modal.dataArr[i];
                        if ([dataModal.id_ isEqualToString:modalOne.id_]) {
                            selectModalOne = modal;
                            selectModalTwo = modalOne;
                            [rightDataArr addObjectsFromArray:modal.dataArr];
                            break;
                        }
                    }
                }
            }
        }
        
        if (!selectModalOne) {
            selectModalOne = offerRegionArr[0];
        }
        [self reConfigUI:changeType];
        [leftTableView reloadData];
        [rightTableView reloadData];
    }
}

//offer派职位筛选
-(void)offerPaiJobChangeData
{   
    selectModalOne = selectChangeModal;
    if (!offerJobArr) 
    {
        if (offerPaiJobArr.count > 0) {
            offerJobArr = [[NSMutableArray alloc] initWithArray:offerPaiJobArr];
            [leftDataArr addObjectsFromArray:offerJobArr];
            [self reConfigUI:changeType];
            [leftTableView reloadData];
        }
        
    }
    else
    {
        [leftDataArr addObjectsFromArray:offerJobArr];
        [self reConfigUI:changeType];
        [leftTableView reloadData];
    }
   
}

//经验筛选
-(void)experienceChangeData
{
    if (!experienceArr)
    {
        experienceArr = [[NSMutableArray alloc] init];
        NSArray *ageArray_ = [[NSArray alloc]initWithObjects:@"不限",@"应届毕业生",@"", nil];
        NSArray *ageValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"", nil];
        NSArray *ageValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"0",@"", nil];
        for (NSInteger i = 0;i<ageArray_.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.id_ = ageValueArray_[i];
            modal.str_ = ageArray_[i];
            modal.id_1 = ageValueArray_1[i];
            [experienceArr addObject:modal];
        }
    }
    selectModalOne = selectChangeModal;
    [leftDataArr addObjectsFromArray:experienceArr];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//创建年龄筛选数据
- (void)CreateAgeChangeData
{
    if (!_ageArrary)
    {
        _ageArrary = [[NSMutableArray alloc] init];
        NSArray *ageArray_ = [[NSArray alloc]initWithObjects:@"不限",@"", nil];
        NSArray *ageValueArray_ = [[NSArray alloc]initWithObjects:@"",@"", nil];
        NSArray *ageValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"", nil];
        
        for (NSInteger i = 0;i < ageArray_.count; i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = ageArray_[i];
            modal.id_ = ageValueArray_[i];
            modal.id_1 = ageValueArray_1[i];
            modal.pId_ = resumeMoreDataArr[1];
            [_ageArrary addObject:modal];
        }
    }
    
    selectModalOne = selectChangeModal;
    [leftDataArr addObjectsFromArray:_ageArrary];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//创建学历筛选数据
- (void)CreateEducationChangeData
{
    if (!_educationArr)
    {
        _educationArr = [[NSMutableArray alloc] init];
        NSArray *eduArray_ = [[NSArray alloc]initWithObjects:@"不限", @"博士后", @"博士", @"MBA", @"硕士", @"本科", @"大专", @"中专", @"中技", @"高中", @"初中", nil];
        NSArray *eduValueArray_ = [[NSArray alloc]initWithObjects:@"", @"90", @"80", @"75", @"70", @"60", @"50", @"40", @"30", @"20", @"10",nil];
        
        for (NSInteger i = 0;i < eduArray_.count; i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = eduArray_[i];
            modal.id_ = eduValueArray_[i];
            modal.pId_ = resumeMoreDataArr[0];
            [_educationArr addObject:modal];
        }
    }
    
    selectModalOne = selectChangeModal;
    [leftDataArr addObjectsFromArray:_educationArr];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//附近职位
-(void)rangeChooseData{
    if (!rangeChooseArr) {
        rangeChooseArr = [NSMutableArray array];
        NSArray *rangeArray_ = [[NSArray alloc]initWithObjects:@"3公里内", @"5公里内", @"10公里内", @"20公里内", @"30公里内", nil];
        NSArray *rangeValueArray_ = [[NSArray alloc]initWithObjects:@"3", @"5", @"10", @"20", @"30",nil];
        for (NSInteger i = 0;i < rangeArray_.count; i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = rangeArray_[i];
            modal.id_ = rangeValueArray_[i];
            [rangeChooseArr addObject:modal];
        }
    }
    selectModalOne = selectChangeModal;
    [leftDataArr addObjectsFromArray:rangeChooseArr];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//顾问简历搜索工作年限
-(void)GWExperienceData{
    if (!gwExperenceArr) {
        gwExperenceArr = [NSMutableArray array];
        NSArray *workAgeArray_ = [[NSArray alloc]initWithObjects:@"不限",@"应届毕业生",@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上", nil];
        NSArray *workAgeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"0",@"1",@"3",@"5",@"10", nil];
        NSArray *workAgeValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"",@"1",@"3",@"5",@"10",@"0", nil];
        for (int i = 0; i < workAgeArray_.count; i++) {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = workAgeArray_[i];
            modal.id_ = workAgeValueArray_[i];
            modal.id_1 = workAgeValueArray_1[i];
            [gwExperenceArr addObject:modal];
        }
    }
    selectModalOne = selectChangeModal;
    [leftDataArr addObjectsFromArray:gwExperenceArr];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//宣讲会日期筛选
-(void)creatXJHTimeData
{
    if (!xjhTimeArr)
    {
        xjhTimeArr = [[NSMutableArray alloc] init];
        NSMutableArray *arrDataId = [[NSMutableArray alloc] initWithArray:@[@"",@"1",@"3",@"7",@"14",@"30",@"60"]];
        NSMutableArray *arrDataName = [[NSMutableArray alloc] initWithArray:@[@"所有日期",@"今天",@"近三天",@"近一周",@"近两周",@"近一月",@"近两月"]];
        for (NSInteger i = 0;i<arrDataName.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.id_ = arrDataId[i];
            modal.str_ = arrDataName[i];
            [xjhTimeArr addObject:modal];
        }
    }
    [leftDataArr addObjectsFromArray:xjhTimeArr];
    CondictionList_DataModal *modalSelect = selectChangeModal;
    
    for (CondictionList_DataModal *modal1 in leftDataArr)
    {
        if ([modal1.str_ isEqualToString:modalSelect.str_]) {
            modalSelect = modal1;
        }
    }
    if (modalSelect)
    {
        selectModalOne = modalSelect;
    }
    else
    {
        selectModalOne = leftDataArr[0];
    }
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//宣讲会学校筛选
-(void)creatXJHSchooleData
{
    if (!schoolDataBase)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *filePath = [Common getSandBoxPath:@"data.db"];
        
        if( ![fileManager fileExistsAtPath:filePath] ){
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"data.db"]];
            [data writeToFile:[Common getSandBoxPath:@"data.db"] atomically:YES];
        }
        schoolDataBase = [FMDatabase databaseWithPath:filePath];
    }

    SqlitData *allData = [[SqlitData alloc] init];
    allData.school = @"所有学校";
    [leftDataArr addObject:allData];
    
    CondictionList_DataModal *modal = selectChangeModal;
    NSString *_regionId = modal.id_;
    if ([modal.pId_ isEqualToString:@"所有学校"])
    {
        selectModalOne = allData;
    }
    
    NSString *typeId = [_regionId substringWithRange:NSMakeRange(_regionId.length-4,4)];
    NSString *typeIdTwo = [_regionId substringWithRange:NSMakeRange(_regionId.length-2,2)];
    NSString *selectString = @"";
    if ([typeId isEqualToString:@"0000"])
    {
        selectString = [NSString stringWithFormat:@"select * from new_school where parentId >= '%@' and parentId <= '%@' and school !=''",_regionId,[_regionId stringByReplacingCharactersInRange:NSMakeRange(_regionId.length - 4,4) withString:@"9999"]];
    }
    else if ([typeIdTwo isEqualToString:@"00"])
    {
        selectString = [NSString stringWithFormat:@"select * from new_school where (provinceId = '%@' or parentId >= '%@' and parentId <= '%@' )and school != ''",_regionId,[_regionId stringByReplacingCharactersInRange:NSMakeRange(_regionId.length - 2,2) withString:@"00"],[_regionId stringByReplacingCharactersInRange:NSMakeRange(_regionId.length - 2,2) withString:@"99"]];
    }
    else
    {
        selectString = [NSString stringWithFormat:@"select * from new_school where parentId = '%@' and school !=''",_regionId];
    }
    
    if ([schoolDataBase open])
    {
        //[NSString stringWithFormat:@"select * from new_school where parentId='%@'",_regionId]
        FMResultSet *set = [schoolDataBase executeQuery:selectString];
        while ([set next]) {
            SqlitData *data = [[SqlitData alloc] init];
            data.provinceName = [set stringForColumn:@"provinceName"];
            data.stringId = [set stringForColumn:@"rowid"];
            data.provinceld = [set stringForColumn:@"provinceId"];
            data.parentld = [set stringForColumn:@"parentId"];
            data.level = [set stringForColumn:@"level"];
            data.school = [set stringForColumn:@"school"];
            if ([data.school length] > 0) {
                [leftDataArr addObject:data];
            }
            if ([data.school isEqualToString:modal.pId_] && modal.pId_.length > 0)
            {
                selectModalOne = data;
            }
        }
    }
    [schoolDataBase close];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

//宣讲会地区筛选
-(void)creatXJHRegionData
{
    if (!regionArr)
    {
//        regionArr = [MyCommon unArchiverFromFile:RegionDataName];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathname = [path lastObject];
        NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        @try {
            if (![db open]) {
                NSLog(@"Could not open db.");
            }
            NSString *sql = [NSString stringWithFormat:@"select * from region_choosen"];
            FMResultSet *rs = [db executeQuery:sql];
            NSMutableArray *resulArr = [NSMutableArray arrayWithCapacity:533];
            while ([rs next]) {
                CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
                model.id_ = [rs stringForColumn:@"selfId"];
                model.pId_ = [rs stringForColumn:@"parentId"];
                model.str_ = [rs stringForColumn:@"selfName"];
                model.bParent_ = ![rs boolForColumn:@"level"];
                [resulArr addObject:model];
            }
            regionArr = resulArr;
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [db close];
        }
    }
    CondictionList_DataModal *modal3 = [[CondictionList_DataModal alloc] init];
    modal3.str_ = @"热门城市";
    modal3.bParent_ = YES;
    modal3.bSelected_ = YES;
    
    
    if (!hotRegionArr)
    {
        NSMutableArray *arrHot = [[NSMutableArray alloc] initWithObjects:@"北京市",@"上海市",@"天津市",@"重庆市",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
        NSArray *arrHotId = @[@"110000",@"310000",@"120000",@"500000",@"440100",@"440300",@"420100",@"320100",@"330100",@"510100",@"610100"];
        hotRegionArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrHot.count; i++) {
            CondictionList_DataModal *modal = [CondictionList_DataModal new];
            modal.str_ = arrHot[i];
            modal.id_ = arrHotId[i];
            modal.bSelected_ = YES;
            [hotRegionArr addObject:modal];
        }
    }
    
    [leftDataArr removeAllObjects];
    [rightDataArr removeAllObjects];
    CondictionList_DataModal *modal1 = selectChangeModal;
    
    for (CondictionList_DataModal *modal in regionArr)
    {
        if(modal.bParent_ && [modal.pId_ isEqualToString:@"0"])
        {
            [leftDataArr addObject:modal];
        }
        if ([modal1.id_ isEqualToString:modal.id_] && !modal1.bSelected_)
        {
            modal1 = modal;
        }
    }
    
    CondictionList_DataModal *modal5 = [[CondictionList_DataModal alloc] init];
    modal5.str_ = @"不限";
    modal5.id_ = @"";
    modal5.bParent_ = YES;
    [leftDataArr insertObject:modal5 atIndex:0];

    if (modal1.bSelected_ == YES) {
        selectModalOne = modal3;
        for (CondictionList_DataModal *modal in hotRegionArr) {
            if ([modal.str_ isEqualToString:modal1.str_]) {
                selectModalTwo = modal;
            }
        }
        [rightDataArr addObjectsFromArray:hotRegionArr];
    }
    else{
        
        if (modal1)
        {
            if ([modal1.str_ isEqualToString:@"不限"]) {
                selectModalOne = modal5;
            }
            else
            {
                if (modal1.bParent_)
                {
                    selectModalOne = modal1;
                }
                else
                {
                    selectModalTwo = modal1;
                    for (CondictionList_DataModal *modal in leftDataArr)
                    {
                        if ([modal.id_ isEqualToString:modal1.pId_])
                        {
                            selectModalOne = modal;
                            break;
                        }
                    }
                }
            }
        }
        else
        {
            selectModalOne = modal5;
        }
        
        CondictionList_DataModal *modal4 = selectModalOne;
        if (![modal4.str_ isEqualToString:@"不限"])
        {
            if ([modal4.str_ isEqualToString:@"热门城市"])
            {
                [rightDataArr addObjectsFromArray:hotRegionArr];
            }
            else
            {
                for (CondictionList_DataModal *modal in regionArr)
                {
                    if ([modal.id_ isEqualToString:modal4.id_]) {
                        modal.bParent_ = YES;
                    }
                    if ([modal.pId_ isEqualToString:modal4.id_])
                    {
                        [rightDataArr addObject:modal];
                    }
                }
            }
        }
    }

    [leftDataArr insertObject:modal3 atIndex:1];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
    [rightTableView reloadData];
}

//创建地区模型
-(void)creatRegionModal
{
    dataBase = [DataBase shareDatabase];
    leftDataArr = [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:@"select * from region_web where level='1'"]];
    
    SqlitData *markModal;
    for (SqlitData *modal in leftDataArr) {
        if ([modal.provinceName isEqualToString:@"全国"]) {
            markModal = modal;
        }
    }
    if (markModal) {
        [leftDataArr removeObject:markModal];
        markModal.provinceName = @"不限"; 
        [leftDataArr insertObject:markModal atIndex:0];
    }
    
    NSMutableArray *arrData;
    
    SqlitData *data = selectChangeModal;
    SqlitData * hotVO = [SqlitData new];
    hotVO.provinceName = @"热门城市";
    hotVO.level = @"1";
    hotVO.selected = YES;
    if (!hotcitySelArr) {
        NSMutableArray *arrHot = [[NSMutableArray alloc] initWithObjects:@"北京市",@"上海市",@"天津市",@"重庆市",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
        NSArray *arrHotId = @[@"110000",@"310000",@"120000",@"500000",@"440100",@"440300",@"420100",@"320100",@"330100",@"510100",@"610100"];
        hotcitySelArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrHot.count; i++) {
            SqlitData *modal = [SqlitData new];
            modal.provinceName = arrHot[i];
            modal.provinceld = arrHotId[i];
            modal.selected = YES;
            [hotcitySelArr addObject:modal];
        }
    }
    
    if (data.selected == YES) {
        selectModalOne = hotVO;
        for (SqlitData *VO in hotcitySelArr) {
            if ([VO.provinceld isEqualToString:data.provinceld]) {
                selectModalTwo = VO;
            }
        }
        rightDataArr = [NSMutableArray arrayWithArray:hotcitySelArr];
    }
    else{
        if (data.provinceld.length > 0)
        {
            arrData = [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:[NSString stringWithFormat:@"select * from region_web where provinceId='%@'",data.provinceld]]];
        }
        SqlitData *modal;
        if (arrData.count > 0)
        {
            modal = arrData[0];
            if ([modal.level isEqualToString:@"1"])
            {
                selectModalOne = modal;
                selectModalTwo = modal;
            }
            else
            {
                selectModalTwo = modal;
                arrData =  [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:[NSString stringWithFormat:@"select * from region_web where provinceId='%@'",modal.parentld]]];
                if (arrData.count > 0)
                {
                    selectModalOne = arrData[0];
                }
            }
            
            SqlitData *modal2 = selectModalOne;
            rightDataArr = [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:[NSString stringWithFormat:@"select * from region_web where parentId='%@'",modal2.provinceld]]];
            if (![modal2.provinceName isEqualToString:@"全国"])
            {
                [rightDataArr insertObject:modal2 atIndex:0];
            }
        }
        
        for (NSInteger i = 0;i<leftDataArr.count;i++) {
            if ([[leftDataArr[i] provinceName] isEqualToString:@"不限"])
            {
                SqlitData *data = leftDataArr[i];
                [leftDataArr removeObjectAtIndex:i];
                [leftDataArr insertObject:data atIndex:0];
                if (!modal)
                {
                    selectModalOne = data;
                }
                break;
            }
        }
    }
    
    [leftDataArr insertObject:hotVO atIndex:1];

    
    [self reConfigUI:changeType];
    [leftTableView reloadData];
    [rightTableView reloadData];
}

//顾问行业
-(void)GWTradeData{
    [leftDataArr addObjectsFromArray:gwTradeArr];
    selectModalOne = selectChangeModal;
    [self reConfigUI:changeType];
    [leftTableView reloadData];
    [rightTableView reloadData];
}

//创建行业模型
-(void)creatTradeData
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = @"不限";
    dataModal.id_ = nil;
    dataModal.bParent_ = NO;
    [leftDataArr addObject:dataModal];
    
    if(!tradeAllData || tradeAllData.count <= 0)
    {
        tradeAllData = [[NSMutableArray alloc] initWithArray:[CondictionTradeCtl loadDataFromFile]];
    }
    
    CondictionList_DataModal *model1 = selectChangeModal;
    
    for (CondictionList_DataModal *modal in tradeAllData)
    {
        if(modal.bParent_ )
        {
            [leftDataArr addObject:modal];
        }
    }
    if (model1)
    {
        if ([model1.str_ isEqualToString:@"不限"]) {
            selectModalOne = model1;
        }
        else{
            if (model1.bParent_)
            {
                selectModalOne = model1;
            }
            else
            {
                selectModalTwo = model1;
                for (CondictionList_DataModal *modal2 in leftDataArr)
                {
                    if ([model1.pId_ isEqualToString:modal2.id_])
                    {
                        selectModalOne = modal2;
                        break;
                    }
                }
            }

        }
    }
    else
    {
        selectModalOne = dataModal;
    }
    CondictionList_DataModal *modal4 = selectModalOne;
    for (CondictionList_DataModal *modal3 in tradeAllData)
    {
        if ([modal3.pId_ isEqualToString:modal4.id_])
        {
            [rightDataArr addObject:modal3];
        }
    }
    [self reConfigUI:changeType];
    [leftTableView reloadData];
    [rightTableView reloadData];
}

//薪水数据
-(void)creatSalaryData
{
    if (!salaryDataArr)
    {
        salaryDataArr = [[NSMutableArray alloc] init];
        NSArray *paymentArray_ = [[NSArray alloc]initWithObjects:@"不限",@"面议",@"3000以下",@"3000及以上",@"5000及以上",@"7000及以上",@"10000及以上",nil];
        NSArray *paymentValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"lt||3000",@"gte||3000",@"gte||5000",@"gte||7000",@"gte||10000",nil];
        for (NSInteger i= 0;i<paymentArray_.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = paymentArray_[i];
            modal.id_ = paymentValueArray_[i];
            [salaryDataArr addObject:modal];
        }
    }
    selectModalOne = selectChangeModal;
    [leftDataArr addObjectsFromArray:salaryDataArr];
    [self reConfigUI:changeType];
    [leftTableView reloadData];
}

-(void)creatMoreChangeData
{
    if (!moreChangeArr)
    {
        moreChangeArr = [[NSMutableArray alloc] initWithArray:@[@"工作年限",@"发布日期",@"学历要求",@"工作性质"]];
        
        NSArray *workAgeArray_ = [[NSArray alloc]initWithObjects:@"年限不限",@"应届毕业生",@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上", nil];
        NSArray *workAgeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"0",@"1",@"3",@"5",@"10", nil];
        NSArray *workAgeValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"",@"1",@"3",@"5",@"10",@"0", nil];
        
       NSArray *timeArray_ = [[NSArray alloc]initWithObjects:@"所有日期",@"近一天",@"近两天",@"近一周",@"近两周",@"近一月",@"近六周",@"近两月", nil];
        NSArray *timeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"1",@"2",@"7",@"14",@"30",@"42",@"60", nil];
        
        NSArray *eduArray_ = [[NSArray alloc]initWithObjects:@"学历不限",@"大专以下",@"大专",@"本科",@"硕士",@"MBA",@"博士",@"博士后" ,nil];
        NSArray *eduValueArray_ = [[NSArray alloc]initWithObjects:@"",@"lt||30",@"50",@"60",@"70",@"75",@"80",@"90",nil];
        
//        NSArray *eduArray_ = [[NSArray alloc]initWithObjects:@"不限", @"博士后", @"博士", @"MBA", @"硕士", @"本科", @"大专", @"大专以下", nil];
//        NSArray *eduValueArray_ = [[NSArray alloc]initWithObjects:@"", @"90", @"80", @"75", @"70", @"60", @"50", @"lt||30",nil];
        
        NSArray *workTypeArray_ = [[NSArray alloc]initWithObjects:@"性质不限",@"全职",@"兼职",@"临时",@"实习", nil];
        NSArray *workTypeVauleArray_ = [[NSArray alloc]initWithObjects:@"",@"全职",@"兼职",@"临时",@"实习", nil];
        
        moreChangeDic = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSInteger i= 0;i<workAgeArray_.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = workAgeArray_[i];
            modal.id_ = workAgeValueArray_[i];
            modal.id_1 = workAgeValueArray_1[i];
            modal.pId_ = moreChangeArr[0];
            [arr addObject:modal];
        }
        [moreChangeDic setObject:arr forKey:moreChangeArr[0]];
        
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        for (NSInteger i= 0;i<timeArray_.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = timeArray_[i];
            modal.id_ = timeValueArray_[i];
            modal.pId_ = moreChangeArr[1];
            [arr1 addObject:modal];
        }
        [moreChangeDic setObject:arr1 forKey:moreChangeArr[1]];
        
        NSMutableArray *arr2 = [[NSMutableArray alloc] init];
        for (NSInteger i= 0;i<eduArray_.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = eduArray_[i];
            modal.id_ = eduValueArray_[i];
            modal.pId_ = moreChangeArr[2];
            [arr2 addObject:modal];
        }
        [moreChangeDic setObject:arr2 forKey:moreChangeArr[2]];
        
        NSMutableArray *arr3 = [[NSMutableArray alloc] init];
        for (NSInteger i= 0;i<workTypeArray_.count;i++)
        {
            CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = workTypeArray_[i];
            modal.id_ = workTypeVauleArray_[i];
            modal.pId_ = moreChangeArr[3];
            [arr3 addObject:modal];
        }
        [moreChangeDic setObject:arr3 forKey:moreChangeArr[3]];
    }
    
    for (NSInteger i = 0; i<moreChangeArr.count;i++)
    {
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.str_ = moreChangeArr[i];
        [leftDataArr addObject:modal];
    }
    
    selectModalOne = selectChangeModal;
    [self reConfigUI:changeType];
    [leftTableView reloadData];
    [rightTableView reloadData];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == leftTableView)
    {
        return leftDataArr.count;
    }
    return rightDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((changeType == ExperienceChange && indexPath.row == 2) || (changeType == AgeChange && indexPath.row == 1))
    {
        Experience_SelectionTableViewCell *experienceCell = [[NSBundle mainBundle]loadNibNamed:@"Experience_SelectionTableViewCell" owner:self options:nil].firstObject;
        experienceCell.delegate = self;
        CondictionList_DataModal *selectM = selectModalOne;
        if ([selectM.id_1 integerValue] > 0 && [selectM.id_ integerValue] <= [selectM.id_1 integerValue]){
            experienceCell.lowTxt.text = selectM.id_;
            experienceCell.highTxt.text = selectM.id_1;
        }
        selectAgeTwoCell = experienceCell;
        return experienceCell;
    }
    
    static NSString *strCell = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15,11,(ScreenWidth/2)-50,20)];
    lable.tag = 100;
    lable.font = FIFTEENFONT_TITLE;
    [cell.contentView addSubview:lable];
    
    UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/2) - 31,15,18,18)];
    imageRight.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    imageRight.tag = 500;
    imageRight.hidden = YES;
    [cell.contentView addSubview:imageRight];
    
    UILabel *lableOne = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2,11,(ScreenWidth/2)-35,20)];
    lableOne.font = FOURTEENFONT_CONTENT;
    lableOne.tag = 300;
    lableOne.textAlignment = NSTextAlignmentRight;
    lableOne.textColor = UIColorFromRGB(0x757575);
    [cell.contentView addSubview:lableOne];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    lableOne.hidden = YES;
    
    if (changeType == SalaryMonthChange || changeType == XJHSchoolChange || changeType == XJHTimeChange || changeType == ExperienceChange || changeType == OfferPaiJobChange || changeType == OfferPaiRegionChange || changeType == AgeChange || changeType == EducationChange || changeType == Range_ChooseChange || changeType == GWMyresumeListPositionChange)
    {
        lable.frame = CGRectMake(15,11,ScreenWidth-50,20);
        imageRight.frame = CGRectMake(ScreenWidth - 31,15,18,18);
    }
    else if(changeType == MoreChange)
    {
        if (tableView == leftTableView)
        {
            lable.frame = CGRectMake(15,11,(ScreenWidth/2)-50,20);
            lableOne.hidden = NO;
            imageRight.frame = CGRectMake(ScreenWidth - 28,15,8,13);
            imageRight.image = [UIImage imageNamed:@"right_grey"];
            imageRight.hidden = NO;
        }
        else
        {
            lable.frame = CGRectMake(15,11,ScreenWidth-50,20);
            imageRight.frame = CGRectMake(ScreenWidth - 31,15,18,18);
            imageRight.image = [UIImage imageNamed:@"ic_done_black_36dp"];
        }
        
    }
    else
    {
        lable.frame = CGRectMake(15,11,(ScreenWidth/2)-50,20);
        imageRight.frame = CGRectMake((ScreenWidth/2) - 31,15,18,18);
        imageRight.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    }
    
    switch (changeType)
    {
        case RegionChange:
        {
            SqlitData *modal;
            SqlitData *modal1;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
                modal1 = selectModalOne;
                if ([modal.provinceName isEqualToString:modal1.provinceName] || [modal.provinceld isEqualToString:modal1.provinceld])
                {
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
                }
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
                modal1 = selectModalTwo;
                if ([modal.provinceName isEqualToString:modal1.provinceName] || [modal.provinceld isEqualToString:modal1.provinceld])
                {
                    lable.textColor = UIColorFromRGB(0xe13e3e);
                    imageRight.hidden = NO;
                }
                else
                {
                    lable.textColor = UIColorFromRGB(0x212121);
                    imageRight.hidden = YES;
                }
            }
            lable.text = modal.provinceName;
            
        }
            break;
        case TradeChange:
        {
            CondictionList_DataModal *modal;
            CondictionList_DataModal *modal1;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
                modal1 = selectModalOne;
                if ([modal.str_ isEqualToString:modal1.str_] && modal.bParent_== modal1.bParent_)
                {
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
                }
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
                modal1 = selectModalTwo;
                if ([modal.str_ isEqualToString:modal1.str_] && modal.bParent_== modal1.bParent_)
                {
                    lable.textColor = UIColorFromRGB(0xe13e3e);
                    imageRight.hidden = NO;
                }
                else
                {
                    lable.textColor = UIColorFromRGB(0x212121);
                    imageRight.hidden = YES;
                }
            }
            lable.text = modal.str_;
        }
            break;
        case SalaryMonthChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            lable.text = modal.str_;
            CondictionList_DataModal *modal1 = selectModalOne;
            if ([modal1.id_ isEqualToString: modal.id_])
            {
                lable.textColor = UIColorFromRGB(0xe13e3e);
                imageRight.hidden = NO;
            }
            else
            {
                lable.textColor = UIColorFromRGB(0x212121);
                imageRight.hidden = YES;
            }
        }
            break;
        case MoreChange:
        {
            CondictionList_DataModal *modal;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
                SearchParam_DataModal *modal1 = selectModalOne;
                if ([modal.str_ isEqualToString:@"工作年限"])
                {
                    lableOne.text = modal1.workAgeName_;
                    workAgeMore = lableOne.text;
                }
                else if ([modal.str_ isEqualToString:@"发布日期"])
                {
                    lableOne.text = modal1.timeName_;
                    intruduceTimeMore = lableOne.text;
                }
                else if ([modal.str_ isEqualToString:@"学历要求"])
                {
                    lableOne.text = modal1.eduName_;
                    eduMore = lableOne.text;
                }
                else if ([modal.str_ isEqualToString:@"工作性质"])
                {
                    lableOne.text = modal1.workTypeName_;
                    workConMore = lableOne.text;
                }
                
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
                if ([modal.str_ isEqualToString:workAgeMore] || [modal.str_ isEqualToString:intruduceTimeMore] || [modal.str_ isEqualToString:eduMore] || [modal.str_ isEqualToString:workConMore]) {
                    lable.textColor = UIColorFromRGB(0xe13e3e);
                    imageRight.hidden = NO;
                }
                else{
                    lable.textColor = UIColorFromRGB(0x212121);
                    imageRight.hidden = YES;
                }
            }
            if([modal.str_ isEqualToString:@"年限不限"] || [modal.str_ isEqualToString:@"学历不限"] || [modal.str_ isEqualToString:@"性质不限"]){
                lable.text = @"不限";
            }
            else{
                lable.text = modal.str_;
            }
            
        }
            break;
        case XJHRegionChange:
        {
            CondictionList_DataModal *modal;
            CondictionList_DataModal *modal1;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
                modal1 = selectModalOne;
                if ([modal.str_ isEqualToString:modal1.str_] && modal.bParent_== modal1.bParent_)
                {
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
                }
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
                modal1 = selectModalTwo;
                if ([modal.str_ isEqualToString:modal1.str_] && modal.bParent_== modal1.bParent_)
                {
                    lable.textColor = UIColorFromRGB(0xe13e3e);
                    imageRight.hidden = NO;
                }
                else
                {
                    lable.textColor = UIColorFromRGB(0x212121);
                    imageRight.hidden = YES;
                }
            }
            lable.text = modal.str_;
            
        }
            break;
        case OfferPaiRegionChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            CondictionList_DataModal *modal1 = selectModalOne;
            lable.text = modal.str_;
            if ([modal.id_ isEqualToString:modal1.id_])
            {
                lable.textColor = UIColorFromRGB(0xe13e3e);
                imageRight.hidden = NO;
            }
            else
            {
                lable.textColor = UIColorFromRGB(0x212121);
                imageRight.hidden = YES;
            }
        }
            break;
        case OfferPaiJobChange:
        {
            personTagModel *modal = leftDataArr[indexPath.row];;
            personTagModel *modal1 = selectModalOne;
            
            lable.text = modal.tagName_;
            if ([modal.tagName_ isEqualToString:modal1.tagName_])
            {
                lable.textColor = UIColorFromRGB(0xe13e3e);
                imageRight.hidden = NO;
            }
            else
            {
                lable.textColor = UIColorFromRGB(0x212121);
                imageRight.hidden = YES;
            }
        }
            break;
        case XJHSchoolChange:
        {
            SqlitData *modal = leftDataArr[indexPath.row];
            lable.text = modal.school;
            SqlitData *modal1 = selectModalOne;
            
            if ([modal1.school isEqualToString: modal.school])
            {
                lable.textColor = UIColorFromRGB(0xe13e3e);
                imageRight.hidden = NO;
            }
            else
            {
                lable.textColor = UIColorFromRGB(0x212121);
                imageRight.hidden = YES;
            }
        }
            break;
        case XJHTimeChange:
        case ExperienceChange:
        case AgeChange:
        case EducationChange:
        case Range_ChooseChange:
        case GWexperienceChooseChange:
        case GWMyresumeListPositionChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            lable.text = modal.str_;
            CondictionList_DataModal *modal1 = selectModalOne;
            if ([modal1.str_ isEqualToString: modal.str_])
            {
                lable.textColor = UIColorFromRGB(0xe13e3e);
                imageRight.hidden = NO;
            }
            else
            {
                lable.textColor = UIColorFromRGB(0x212121);
                imageRight.hidden = YES;
            }
        }
            break;
        case GWTradeChooseChange:
        {
            CondictionList_DataModal *modal;
            CondictionList_DataModal *modal1;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
                modal1 = selectModalOne;
                if ([modal.str_ isEqualToString:modal1.str_] && modal.bParent_== modal1.bParent_)
                {
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
                }
            }
            lable.text = modal.str_;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (changeType)
    {
        case RegionChange:
        {
            SqlitData *modal;
            if (tableView == leftTableView)
            {
                if (indexPath.row < leftDataArr.count) {
                    modal = leftDataArr[indexPath.row];
                }
                
            }
            else if(tableView == rightTableView)
            {
                if (indexPath.row < rightDataArr.count) {
                    modal = rightDataArr[indexPath.row];
                }
                
            }
            rightDataArr = [NSMutableArray array];
            if ([modal.level isEqualToString:@"1"] && tableView == leftTableView && ![modal.provinceName isEqualToString:@"不限"])
            {
                selectModalOne = modal;
                if ([modal.provinceName isEqualToString:@"热门城市"])
                {
                    [rightDataArr addObjectsFromArray:hotcitySelArr];
                }
                else{
                    rightDataArr = [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:[NSString stringWithFormat:@"select * from region_web where parentId='%@'",modal.provinceld]]];
                    [rightDataArr insertObject:modal atIndex:0];
                }
                rightTableView.contentOffset = CGPointZero;
                [leftTableView reloadData];
                [rightTableView reloadData];
            }
            else
            {
                [_delegate_ changeCondiction:changeType dataModel:modal];
                [self hideView];
            }
        }
            break;
        case TradeChange:
        {
            CondictionList_DataModal *modal;
            if (tableView == leftTableView)
            {
                if (indexPath.row < leftDataArr.count) {
                    modal = leftDataArr[indexPath.row];
                }
                
            }
            else if(tableView == rightTableView)
            {
                if (indexPath.row < rightDataArr.count) {
                    modal = rightDataArr[indexPath.row];
                }
                
            }
            [rightDataArr removeAllObjects];
            if (modal.bParent_ && tableView == leftTableView && ![modal.str_ isEqualToString:@"不限"])
            {
                selectModalOne = modal;
                for (CondictionList_DataModal *modal3 in tradeAllData)
                {
                    if ([modal3.pId_ isEqualToString:modal.id_])
                    {
                        [rightDataArr addObject:modal3];
                    }
                }
                rightTableView.contentOffset = CGPointZero;
                [leftTableView reloadData];
                [rightTableView reloadData];
            }
            else
            {
                [_delegate_ changeCondiction:changeType dataModel:modal];
                [self hideView];
            }
        }
            break;
        case SalaryMonthChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            [_delegate_ changeCondiction:changeType dataModel:modal];
            [self hideView];
        }
            break;
        case MoreChange:
        {
            CondictionList_DataModal *modal;
            if (tableView == leftTableView)
            {
                if (indexPath.row < leftDataArr.count) {
                    modal = leftDataArr[indexPath.row];
                }
                
                [rightDataArr removeAllObjects];
                [rightDataArr addObjectsFromArray:moreChangeDic[modal.str_]];
                rightTableView.contentOffset = CGPointZero;
                [leftTableView reloadData];
                [rightTableView reloadData];
                
                CGRect leftFrame = leftTableView.frame;
                CGRect rightFrame = rightTableView.frame;
                CGRect rightBtnFrame = moreRightView.frame;
                CGRect leftBtnFrame = moreLeftView.frame;
                rightFrame.origin.x = 0;
                leftFrame.origin.x = -ScreenWidth;
                leftBtnFrame.origin.x = -ScreenWidth;
                rightBtnFrame.origin.x = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    rightTableView.frame = rightFrame;
                    leftTableView.frame = leftFrame;
                    moreRightView.frame = rightBtnFrame;
                    moreLeftView.frame = leftBtnFrame;
                }];
                
                moreLeftView.hidden = YES;
                moreRightView.hidden = NO;
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
                CGRect leftFrame = leftTableView.frame;
                CGRect rightFrame = rightTableView.frame;
                CGRect rightBtnFrame = moreRightView.frame;
                CGRect leftBtnFrame = moreLeftView.frame;
                leftBtnFrame.origin.x = 0;
                leftFrame.origin.x = 0;
                rightFrame.origin.x = ScreenWidth;
                rightBtnFrame.origin.x = ScreenWidth;
                [UIView animateWithDuration:0.3 animations:^{
                    rightTableView.frame = rightFrame;
                    leftTableView.frame = leftFrame;
                    moreRightView.frame = rightBtnFrame;
                    moreLeftView.frame = leftBtnFrame;
                }];
                SearchParam_DataModal *modal1 = selectModalOne;
                if ([modal.pId_ isEqualToString:@"工作年限"])
                {
                    modal1.workAgeName_ = modal.str_;
                    modal1.workAgeValue_ = modal.id_;
                    modal1.workAgeValue_1 = modal.id_1;
                }
                else if ([modal.pId_ isEqualToString:@"发布日期"])
                {
                    modal1.timeName_ = modal.str_;
                    modal1.timeStr_ = modal.id_;
                }
                else if ([modal.pId_ isEqualToString:@"学历要求"])
                {
                    modal1.eduName_ = modal.str_;
                    modal1.eduId_ = modal.id_;
                }
                else if ([modal.pId_ isEqualToString:@"工作性质"])
                {
                    modal1.workTypeName_ = modal.str_;
                    modal1.workTypeValue_ = modal.id_;
                }
                [leftTableView reloadData];
                [rightTableView reloadData];
                moreLeftView.hidden = NO;
                moreRightView.hidden = YES;
            }
        }
            break;
        case XJHRegionChange:
        {
            CondictionList_DataModal *modal;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
            }
            [rightDataArr removeAllObjects];
            if (modal.bParent_ && tableView == leftTableView && ![modal.str_ isEqualToString:@"不限"])
            {
                selectModalOne = modal;
                if ([modal.str_ isEqualToString:@"热门城市"])
                {
                    [rightDataArr addObjectsFromArray:hotRegionArr];
                }
                else
                {
                    for (CondictionList_DataModal *modal1 in regionArr)
                    {
                        if ([modal1.id_ isEqualToString:modal.id_]) {
                            modal.bParent_ = YES;
                        }
                        if ([modal1.pId_ isEqualToString:modal.id_]) {
                            [rightDataArr addObject:modal1];
                        }
                    }
                }
                rightTableView.contentOffset = CGPointZero;
                [leftTableView reloadData];
                [rightTableView reloadData];
            }
            else
            {
                [_delegate_ changeCondiction:XJHRegionChange dataModel:modal];
                [self hideView];
            }
        }
            break;
        case XJHSchoolChange:
        {
            SqlitData *modal = leftDataArr[indexPath.row];
            [_delegate_ changeCondiction:changeType dataModel:modal];
            [self hideView];
        }
            break;
        case XJHTimeChange:
        case ExperienceChange:
        case AgeChange:
        case Range_ChooseChange:
        case GWexperienceChooseChange:
        case GWMyresumeListPositionChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            [_delegate_ changeCondiction:changeType dataModel:modal];
            [self hideView];
        }
            break;
        case OfferPaiRegionChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            [_delegate_ changeCondiction:OfferPaiRegionChange dataModel:modal];
            [self hideView];
        }
            break;
        case OfferPaiJobChange:
        {
            personTagModel*modal = leftDataArr[indexPath.row];
            [_delegate_ changeCondiction:OfferPaiJobChange dataModel:modal];
            [self hideView];
        }
            break;
        case EducationChange:
        {
            CondictionList_DataModal *modal = leftDataArr[indexPath.row];
            [_delegate_ changeCondiction:changeType dataModel:modal];
            [self hideView];
        }
            break;
        case GWTradeChooseChange:
        {
            CondictionList_DataModal *modal;
            if (tableView == leftTableView)
            {
                modal = leftDataArr[indexPath.row];
            }
            else if(tableView == rightTableView)
            {
                modal = rightDataArr[indexPath.row];
            }
            [rightDataArr removeAllObjects];
            if (modal.bParent_ && tableView == leftTableView && ![modal.str_ isEqualToString:@"不限"])
            {
                selectModalOne = modal;
                for (CondictionList_DataModal *modal3 in tradeAllData)
                {
                    if ([modal3.pId_ isEqualToString:modal.id_])
                    {
                        [rightDataArr addObject:modal3];
                    }
                }
                rightTableView.contentOffset = CGPointZero;
                [leftTableView reloadData];
                [rightTableView reloadData];
            }
            else
            {
                [_delegate_ changeCondiction:changeType dataModel:modal];
                [self hideView];
            }
        }
            break;
        default:
            break;
    }
}

-(void)hideView
{
    [self.view removeFromSuperview];
    CGRect frame = allBackView.frame;
    frame.origin.y = -self.view.frame.size.height;
    allBackView.frame = frame;
    _currentType = HideViewType;
    [Manager shareMgr].searchChangeCtl = nil;
    if ([_delegate_ respondsToSelector:@selector(hideSuccessDelegate)]) {
        [_delegate_ hideSuccessDelegate];
    }
}

-(void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
    [Manager shareMgr].searchChangeCtl = self;
    CGRect frame = allBackView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.2 animations:^{
        allBackView.frame = frame;
    }];
    _currentType = changeType;
}

- (IBAction)moreLeftBtnRespone:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moreCacel" object:nil];
    [_delegate_ changeCondiction:changeType dataModel:selectModalOne];
    [self hideView];
}

- (IBAction)moreRightBtnrespone:(id)sender
{
    moreRightView.hidden = YES;
    moreLeftView.hidden = NO;
    CGRect leftFrame = leftTableView.frame;
    CGRect rightFrame = rightTableView.frame;
    CGRect rightBtnFrame = moreRightView.frame;
    CGRect leftBtnFrame = moreLeftView.frame;
    leftBtnFrame.origin.x = 0;
    leftFrame.origin.x = 0;
    rightFrame.origin.x = ScreenWidth;
    rightBtnFrame.origin.x = ScreenWidth;
    [UIView animateWithDuration:0.3 animations:^{
        rightTableView.frame = rightFrame;
        leftTableView.frame = leftFrame;
        moreRightView.frame = rightBtnFrame;
        moreLeftView.frame = leftBtnFrame;
    }];
}

-(void)sureBtnClicked:(UIButton *)btn{
    
    NSString *low = selectAgeTwoCell.lowTxt.text;
    NSString *high = selectAgeTwoCell.highTxt.text;
    
    if (low.length > 0 && high.length > 0) {
        NSInteger lowNum = [low integerValue];
        NSInteger highNum = [high integerValue];
        if (lowNum > highNum){
            if (changeType == AgeChange) {
                [self alert:@"请输入正确的年龄"];
                return;
            }
            else if (changeType == ExperienceChange) {
                [self alert:@"请输入正确工作年限"];
                return;
            }
        }
    }
    else{
        if (changeType == AgeChange) {
            [self alert:@"请输入正确的年龄"];
        }
        if (changeType == ExperienceChange) {
            [self alert:@"请输入工作年限"];
        }
        return;
    }

    CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
    dataVO.id_ = low;
    dataVO.id_1 = high;
    dataVO.str_ = [NSString stringWithFormat:@"%@-%@",low,high];
    [_delegate_ changeCondiction:changeType dataModel:dataVO];
    [self hideView];
}

-(void)alert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
    [alert show];
}

-(void)reConfigUI:(CondictionChangeType)condictionType{
    leftTableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    CGRect frame = leftTableView.frame;
    frame.size.height = self.view.frame.size.height - 93;
    frame.size.width = ScreenWidth/2;
    frame.origin.x = 0;
    
    if (condictionType == SalaryMonthChange 
        || condictionType == MoreChange 
        || condictionType == XJHSchoolChange 
        || condictionType == XJHTimeChange  
        || condictionType == ExperienceChange 
        || condictionType == OfferPaiJobChange 
        || condictionType == OfferPaiRegionChange 
        || condictionType == AgeChange 
        || condictionType == EducationChange 
        || condictionType == Range_ChooseChange 
        || condictionType == GWexperienceChooseChange 
        || condictionType == GWTradeChooseChange
        || condictionType == GWMyresumeListPositionChange)
    {
        frame.size.width = ScreenWidth;
        if (condictionType == OfferPaiRegionChange) {
            frame.size.height = self.view.size.height;
        }
        else
        {
            if (leftDataArr.count * 44 > ScreenHeight - 108 - 93) {
                if (condictionType == XJHSchoolChange) {
                    frame.size.height = ScreenHeight - 64 - 88 - 93;
                }
                else{
                    frame.size.height = ScreenHeight - 108 - 93;
                }
            }
            else{
                frame.size.height = leftDataArr.count * 44;
            }
        }
        
        if (condictionType == MoreChange)
        {
            leftTableView.backgroundColor = [UIColor whiteColor];
            frame.size.height = leftDataArr.count * 44 + 65;
            moreLeftView.frame = CGRectMake(0,44 * 4 + 15,ScreenWidth,50);
            moreLeftView.hidden = NO;
        }
        if(condictionType == GWTradeChooseChange){
            frame.size.width = ScreenWidth/2;
        }
    }
    leftTableView.frame = frame;
    
    frame = rightTableView.frame;
    frame.size.height = self.view.frame.size.height - 93;
    frame.origin.x = ScreenWidth/2;
    frame.size.width = ScreenWidth/2;
    if (condictionType == SalaryMonthChange 
        || condictionType == XJHSchoolChange 
        || condictionType == XJHTimeChange 
        || condictionType == ExperienceChange 
        || condictionType == OfferPaiJobChange 
        || condictionType == OfferPaiRegionChange 
        || condictionType == AgeChange 
        || condictionType == EducationChange 
        || condictionType == Range_ChooseChange 
        || condictionType == GWexperienceChooseChange 
        || condictionType == GWMyresumeListPositionChange)
    {
        rightTableView.hidden = YES;
    }
    else if(condictionType == MoreChange)
    {
        frame.origin.x = ScreenWidth;
        frame.size.width = ScreenWidth;
        rightTableView.hidden = NO;
        if (ScreenHeight == 480 || ScreenHeight == 568) {
            frame.size.height = ScreenHeight - 108 - 93 - 65;
        }
        else{
            frame.size.height = 8 * 44 + 65;
        }
        moreRightView.frame = CGRectMake(0,frame.size.height,ScreenWidth,65);
    }
    else if(condictionType == GWTradeChooseChange){
        rightTableView.hidden = NO;
        frame.origin.x = ScreenWidth/2;
        frame.size.width = ScreenWidth/2;
        frame.size.height = leftTableView.frame.size.height;
    }
    else
    {
        rightTableView.hidden = NO;
    }
    rightTableView.frame = frame;
    
//    设置整个背景位置
    frame = self.view.bounds;
    frame.origin.y = -frame.size.height;
    allBackView.frame = frame;
 
}

-(void)setBackViewBlackColor{
    blackBackView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
