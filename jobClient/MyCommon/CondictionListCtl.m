//
//  CondictionListCtl.m
//  MBA
//
//  Created by sysweal on 13-12-15.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "CondictionListCtl.h"
#import "RegionCtl.h"
#import "Constant.h"
#import "FMDatabase.h"

@interface CondictionListCtl ()

@end

//条件选择
CondictionListCtl *condictionListCtl;

//地区以及行业数据

NSArray     *tradeArr;

@implementation CondictionListCtl

@synthesize bHaveSub_,type_,parentModal_,delegate_;

//共用的condictionListCtl
+(CondictionListCtl *) shareCtl
{
    if( !condictionListCtl ){
        condictionListCtl = [[CondictionListCtl alloc] init];
    }
    
    return condictionListCtl;
}

//获取学历arr
+(NSArray *) getEduArr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *strValue = [[NSArray alloc] initWithObjects:@"初中",@"高中",@"中技",@"中专",@"大专",@"本科",@"硕士",@"MBA",@"博士",@"博士后", nil];
    NSArray *idValue = [[NSArray alloc] initWithObjects:@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"75",@"80",@"90",nil];
    
    for( int i = 0 ; i < [strValue count] ; ++i )
    {
        NSString *obj = [strValue objectAtIndex:i];
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.bParent_ = NO;
        dataModal.str_ = obj;
        dataModal.id_ = [idValue objectAtIndex:i];
        
        [arr addObject:dataModal];
    }
    
    return arr;
}


//获取总行业类别
+(NSArray*)getTotalTradeArr
{
    NSMutableArray  * arr = [[NSMutableArray alloc] init];
    
    NSArray * strValue = [[NSArray alloc] initWithObjects:@"电气电力",@"环保水务",@"机电机械",@"水利河务",@"土木建筑",@"玩具礼品",@"卫生医疗",@"农林牧渔",@"建材家具",@"生活服务",@"咨询司法",@"广告传媒",@"商务百货",@"纺织服装",@"文化体育",@"气象地震",@"食品饮料",@"包装印刷",@"石油化工",@"采矿冶炼",@"物流运输",@"金融银行",@"酒店旅游",@"IT/通讯",@"教育培训", nil];
    
    NSArray  * idValue = [[NSArray alloc] initWithObjects:@"4",@"5",@"6",@"7",@"41",@"123",@"172",@"188",@"216",@"295",@"322",@"340",@"343",@"418",@"532",@"533",@"812",@"822",@"825",@"837",@"857",@"865",@"874",@"877",@"881", nil];
    for( int i = 0 ; i < [strValue count] ; ++i )
    {
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.bParent_ = YES;
        dataModal.str_ = [strValue objectAtIndex:i];
        dataModal.id_ = [idValue objectAtIndex:i];
        
        [arr addObject:dataModal];
    }
    
    return arr;

    
}

//获取专业类别
+(NSArray *) getZyeCatArr
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSArray *strValue = [[NSArray alloc] initWithObjects:
                          @"经济类",@"财政、金融、保险类",@"市场营销、经营管理类",@"公共管理类",@"财务会计类",@"计算机科学与技术类",@"电子科学与技术类",@"电子信息与通信工程类",@"建筑设计类",@"土木工程类",
                          @"水利工程类",@"测绘科学与技术类",@"矿业及冶金工程类",@"仪器科学与技术类",@"材料与能源类",@"地质资源、地质工程、勘探类",@"轻工纺织食品类",@"陆地运输、运输管理类",@"船舶水运类",@"航空航天类",@"石油与天然气工程类",
                          @"电力与电气工程类",@"机械工程类",@"动力工程及工程热物理类",@"控制科学与工程类",@"光学工程类",@"化学、日化、化工类",@"环保气象与安全类",@"农林牧渔类",@"医学类",@"师范、基础教育类",
                          @"职业技术教育类",@"新闻传播学类",@"外国语言文学类",@"中国语言文学类",@"数学类",@"历史学类",@"政治学类",@"心理学类",@"社会学类",@"哲学类",
                          @"军事与公安类",@"文学艺术类",@"自然科学类",@"力学类",@"物理学类",@"法学法律类",@"不限",
                          nil];
    NSArray *idValue = [[NSArray alloc] initWithObjects:
                         @"234",@"103",@"190",@"277",@"7081311410146700",@"3561316171568624",@"2411316171436663",@"1241319689752202",@"3331316171603977",@"8391316171650715",
                         @"4041316171683722",@"8571316171746655",@"1721311324162712",@"2581316171212190",@"102",@"4831316171818457",@"184",@"7401319700160659",@"4331319701013646",@"254",@"5231305599725656",
                         @"5041316171400371",@"154",@"7091305601881443",@"8561316171536808",@"9801320985413184",@"3241305599555369",@"146",@"9281316171955606",@"5911316172014230",@"236",
                         @"282",@"280",@"279",@"229",@"193",@"176",@"288",@"247",@"287",@"224",
                         @"8651316171995406",@"7931316170616545",@"9911316170873636",@"175",@"207",@"235",@"不限",
                         nil];
    
    for( int i = 0 ; i < [strValue count] ; ++i )
    {
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.bParent_ = YES;
        dataModal.str_ = [strValue objectAtIndex:i];
        dataModal.id_ = [idValue objectAtIndex:i];
        
        [arr addObject:dataModal];
    }
    
    return arr;
}

//获取问题类型列表
+(NSArray *) getQuesArr
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSArray *strValue = [[NSArray alloc]initWithObjects:@"志愿填报",@"职业定位",@"简历指导",@"面试技巧",@"薪酬行情",@"职业困惑",@"专业技能",@"晋升通道",@"劳动法规",@"全部类型",@"其他类型",nil];
    NSArray *idValue = [[NSArray alloc]initWithObjects:@"8161394610695137",@"1",@"2",@"3",@"4",@"5",@"8581399449565705",@"6",@"2251394610721631",@"",@"0",nil];
    for( int i = 0 ; i < [strValue count] ; ++i )
    {
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.bParent_ = NO;
        dataModal.str_ = [strValue objectAtIndex:i];
        dataModal.id_ = [idValue objectAtIndex:i];
        
        [arr addObject:dataModal];
    }
    
    return arr;
}

//获取某专业下的子arr
+(NSArray *) getMajorArr:(NSString *)zyeId
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //动态从本地数据库中读取专业分类
    //从数据库中去读取数据
    sqlite3_stmt *result = [[MyDataBase defaultDB] selectSQL:nil fileds:@"id,str" whereStr:[NSString stringWithFormat:@"parentStr='%@'",zyeId] limit:0 tableName:DB_Table_Major];
    
    while ( sqlite3_step(result) == SQLITE_ROW )
    {
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        
        //id
        char *rowData_0 = (char *)sqlite3_column_text(result, 0);
        //str
        char *rowData_1 = (char *)sqlite3_column_text(result, 1);
        
        dataModal.id_   = [[NSString alloc] initWithCString:rowData_0 encoding:(NSUTF8StringEncoding)];
        dataModal.str_  = [[NSString alloc] initWithCString:rowData_1 encoding:(NSUTF8StringEncoding)];
        
        [arr addObject:dataModal];
    }
    
    sqlite3_finalize(result);

    return arr;
}

//获取学历
+(NSString *) getEduStr:(NSString *)edu
{
    NSString *str = @"暂无";
    
    if( edu ){
        NSArray *arr = [self getEduArr];
        for ( CondictionList_DataModal *dataModal in arr ) {
            if( [edu isEqualToString:dataModal.id_] ){
                return dataModal.str_;
            }
        }
    }
    
    return str;
}

//获取学历id
+(NSString *) getEduId:(NSString *)eduStr
{
    NSString *str = @"";
    
    if( eduStr ){
        NSArray *arr = [self getEduArr];
        for ( CondictionList_DataModal *dataModal in arr ) {
            if( [eduStr isEqualToString:dataModal.str_] ){
                return dataModal.id_;
            }
        }
    }
    
    return str;
}

//获取行业
+(NSString *) getTradeStr:(NSString *)trade
{
    NSString *str = @"暂无";
    
    if( !tradeArr ){
        tradeArr = [MyCommon unArchiverFromFile:TradeDataName];
    }
    
    if( trade ){
        NSArray *arr = tradeArr;
        for ( CondictionList_DataModal *dataModal in arr ) {
            if( [trade isEqualToString:dataModal.id_] ){
                return dataModal.str_;
            }
        }
    }
    
    return str;
}

//获取行业id
+(NSString *) getTradeId:(NSString *)tradeStr
{
    NSString *str = @"";
    
    if( !tradeArr ){
        tradeArr = [MyCommon unArchiverFromFile:TradeDataName];
    }
    
    if( tradeStr ){
        NSArray *arr = tradeArr;
        for ( CondictionList_DataModal *dataModal in arr ) {
            if( [tradeStr isEqualToString:dataModal.str_] ){
                return dataModal.id_;
            }
        }
    }
    
    return str;
}

//获取专业类别id
+(NSString *) getZyeId:(NSString *)zyeStr
{
    NSString *str = @"";
    
    if( zyeStr ){
        for ( CondictionList_DataModal *dataModal in [self getZyeCatArr] ) {
            if( [zyeStr isEqualToString:dataModal.str_] ){
                return dataModal.id_;
            }
        }
    }
    
    return str;
}

//获取专业名称
+(NSString *) getZyeName:(NSString *)zyeId
{
    NSString *str = @"";
    
    if( zyeId ){
        for ( CondictionList_DataModal *dataModal in [self getZyeCatArr] ) {
            if( [zyeId isEqualToString:dataModal.id_] ){
                return dataModal.str_;
            }
        }
    }
    
    return str;
}

//根据regionId获取regionStr
+(NSString *) getRegionStr:(NSString *)regionId
{
    NSString *str = @"暂无";
    if( !regionArr ){
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
                model.bParent_ = [rs boolForColumn:@"level"];
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
    
    if( regionId ){
        for ( CondictionList_DataModal *dataModal in regionArr ) {
            if( [regionId isEqualToString:dataModal.id_] ){
                return dataModal.str_;
            }
        }
    }
    
    return str;
}

//根据regionStr获取regionId
+(NSString *) getRegionId:(NSString *)regionStr
{
    NSString *str = @"";
    
    if( !regionArr ){
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
                model.bParent_ = [rs boolForColumn:@"level"];
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
    
    if( regionStr ){
        for ( CondictionList_DataModal *dataModal in regionArr ) {
            if( [regionStr isEqualToString:dataModal.str_] ){
                return dataModal.id_;
            }
        }
    }
    
    return str;
}

//根据quesId获取quesStr
+(NSString *)getQuesStr:(NSString*)quesId
{
    NSString *str = @"";
    
    if( quesId ){
        NSArray *arr = [self getQuesArr];
        for ( CondictionList_DataModal *dataModal in arr ) {
            if( [quesId isEqualToString:dataModal.id_] ){
                return dataModal.str_;
            }
        }
    }
    
    return str;
}

//根据quesStr获取quesId
+(NSString *)getQuesId:(NSString*)quesStr
{
    NSString *str = @"";
    
    if( quesStr ){
        NSArray *arr = [self getQuesArr];
        for ( CondictionList_DataModal *dataModal in arr ) {
            if( [quesStr isEqualToString:dataModal.str_] ){
                return dataModal.id_;
            }
        }
    }
    
    return str;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bHeaderEgo_ = NO;
        
        dataArr_ = [[NSMutableArray alloc] init];
        
        //rightNavBarStr_ = @"全选";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进入某个类型
-(void) getIn:(id<CondictionListDelegate>)delegate type:(CondictionType)type bHaveSub:(BOOL)bHaveSub
{
    delegate_ = delegate;
    type_ = type;
    bHaveSub_ = bHaveSub;
        
    [dataArr_ removeAllObjects];
    
    switch ( type ) {
        case CondictionType_Hka:
        case CondictionType_Region:
        {
//            self.navigationItem.title = @"选择地区";
            [self setNavTitle:@"选择地区"];
            
            if( !regionArr ){
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
                        model.bParent_ = [rs boolForColumn:@"level"];
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
            
            if( parentModal_ ){
                [dataArr_ addObject:parentModal_];
            }
            
            for ( CondictionList_DataModal *dataModal in regionArr ) {
                //如果父modal存在,则代表自己是子层
                if( parentModal_ ){
                    if( !dataModal.bParent_ && [dataModal.pId_ isEqualToString:parentModal_.id_] ){
                        [dataArr_ addObject:dataModal];
                    }
                }else if( dataModal.bParent_ ){
                    [dataArr_ addObject:dataModal];
                }
            }
        }
            break;
        case CondictionType_Trade:
        {
//            self.navigationItem.title = @"选择行业";
            [self setNavTitle:@"选择行业"];
            
            if( !tradeArr ){
                tradeArr = [MyCommon unArchiverFromFile:TradeDataName];
            }
            
            if( parentModal_ ){
                [dataArr_ addObject:parentModal_];
            }
            
            for ( CondictionList_DataModal *dataModal in tradeArr ) {
                //如果父modal存在,则代表自己是子层
                if( parentModal_ ){
                    if( !dataModal.bParent_ && [dataModal.pId_ isEqualToString:parentModal_.id_] ){
                        [dataArr_ addObject:dataModal];
                    }
                }else if( dataModal.bParent_ ){
                    [dataArr_ addObject:dataModal];
                }
            }
        }
            break;
        case CondictionType_Edu:
        {
//            self.navigationItem.title = @"选择学历";
            [self setNavTitle:@"选择学历"];
            
            [dataArr_ addObjectsFromArray:[CondictionListCtl getEduArr]];
        }
            break;
        case CondictionType_Zye:
        {
//            self.navigationItem.title = @"选择专业";
            [self setNavTitle:@"选择专业"];
            
            [dataArr_ addObjectsFromArray:[CondictionListCtl getZyeCatArr]];
        }
            break;
        case CondicitonType_Major:
        {
//            self.navigationItem.title = @"选择名称";
            [self setNavTitle:@"选择名称"];
            
            [dataArr_ addObjectsFromArray:[CondictionListCtl getMajorArr:parentModal_.str_]];
        }
            break;
        case ConditionType_JobGuideQues:
        {
//            self.navigationItem.title = @"选择类型";
            [self setNavTitle:@"选择类型"];
            [dataArr_ addObjectsFromArray:[CondictionListCtl getQuesArr]];
        }
            break;
        case CondictionType_TotalTrade:
        {
//            self.navigationItem.title = @"选择行业";
            [self setNavTitle:@"选择行业"];
            [dataArr_ addObjectsFromArray:[CondictionListCtl getTotalTradeArr]];
        }
            break;
        default:
            break;
    }
    
    [tableView_ reloadData];
    [tableView_ setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    CondictionList_DataModal *dataModal = [dataArr_ objectAtIndex:[indexPath row]];
    if( !bHaveSub_ ){
        [self popCondictionListCtl];
        [delegate_ condictionListCtlChoosed:self dataModal:dataModal];
    }else{
        CondictionListCtl *subConCtl = [[CondictionListCtl alloc] init];
        
        [self.navigationController pushViewController:subConCtl animated:YES];
        subConCtl.parentModal_ = dataModal;
        [subConCtl getIn:self type:type_ bHaveSub:NO];
    }
}

#pragma CondictionListDelegate
-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal
{
    [delegate_ condictionListCtlChoosed:self dataModal:dataModal];
}

#pragma mark - Table view data source
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        

        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
   
    CondictionList_DataModal *dataModal = [dataArr_ objectAtIndex:[indexPath row]];
    cell.textLabel.text = dataModal.str_;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void) rightBarBtnResponse:(id)sender
{
    [super rightBarBtnResponse:sender];
    
    [self popCondictionListCtl];
    [delegate_ condictionListCtlChoosed:self dataModal:nil];
}

//将nav中的堆栈pop出来
-(void) popCondictionListCtl
{
    self.parentModal_ = nil;
    
    UIViewController *tmpCtl = nil;
    for ( UIViewController *ctl in self.navigationController.viewControllers ) {
        if( [ctl isKindOfClass:[CondictionListCtl class]] || [ctl isKindOfClass:[RegionCtl class]] ||[ctl isKindOfClass:[RegionConditionListCtl class]]){
            break;
        }else{
            tmpCtl = ctl;
        }
    }
    
    [self.navigationController popToViewController:tmpCtl animated:YES];
}

@end
