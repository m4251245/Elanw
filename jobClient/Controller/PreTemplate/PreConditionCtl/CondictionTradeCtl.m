 //
//  CondictionTradeCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionTradeCtl.h"
#import "CondictionList_Cell.h"
#import "DataManger.h"
#import "CondictionList_DataModal.h"

//列表数据
NSArray             *tradeData;

@implementation CondictionTradeCtl

@synthesize delegate_;

-(id) init
{
    self = [self initWithNibName:@"CondictionTradeCtl" bundle:nil];
    
    
    if( !subCtl_ ){
        subCtl_ = [[CondictionTradeCtl_Sub alloc] init];
    }
    
    dataArr_ = [[NSMutableArray alloc] init];
    
    bHaveSub_ = YES;
    
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
Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择行业";
    [self setNavTitle:@"选择行业"];
    //设置代理
    tableView_.delegate     = self;
    tableView_.dataSource   = self;

    //设置一下数据
    [self setData];    
    
    if (_guwenFlag || _tradeArray != nil)
    {
        [dataArr_ removeAllObjects];
        for (NSString *tradeId in _tradeArray)
        {
            if ([tradeId isEqualToString:@"1000"])
            {
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                dataModal.str_ = @"所有行业";
                dataModal.id_ = nil;
                dataModal.bParent_ = NO;
                [dataArr_ addObject:dataModal];
            }
        }
        
        if( !tradeData ){
            [CondictionTradeCtl initData];
        }
        for (CondictionList_DataModal *dataModal in tradeData)
        {
//            if( dataModal.bParent_  )
//            {
                for (NSString *tradeId in _tradeArray)
                {
                    if ([tradeId isEqualToString:dataModal.id_]) {
                        [dataArr_ addObject:dataModal];
                    }
                }
//            }
        }
        [tableView_ reloadData];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//初始化数据
+(void) initData
{
    [CondictionTradeCtl loadDataFromFile];
}

//从文件中反序列化数据
+(id) loadDataFromFile
{
   
    //从序列化文件中取得数据
    @try {
        id archieveData = [MyCommon unArchiverFromFile:TradeDataFile_Name];
        
        tradeData = archieveData;
        return archieveData;
    }
    @catch (NSException *exception) {
        [PreBaseUIViewController showAlertView:@"异常" msg:@"行业列表获取失败,请尝试重启程序." btnTitle:@"关闭"];
        
        return nil;
    }
    @finally {
        
    }
    
    return nil;
}

 /*
  *序列化行业 需要添加行业时调用  后续改为数据库  2017.2.8
  *tradeName 行业名称  如电力
  *tradeId   子行业编号（某一个小类的编号）
  *tradePId  父行业编号（某一个大类的编号）
  由于模型中部分数据类型导致无法归档
 */
//+ (void)archiverTradeName:(NSString *)tradeName tradeId:(NSString *)tradeId tradePId:(NSString *)tradePid bParent:(BOOL)bParent
//{
//    CondictionList_DataModal *model = [[CondictionList_DataModal alloc] init];
//    model.str_ = tradeName;
//    model.id_ = tradeId;
//    model.pId_ = tradePid;
//    model.bParent_ = bParent;
//    
//    NSMutableArray *mArray =  (NSMutableArray *)[self loadDataFromFile];
//    [mArray addObject:model];
//    
//    NSArray *array = mArray;
//    
////    NSString *homeDictionary = NSHomeDirectory();//获取根目录
//    NSString *homePath  = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],TradeDataFile_Name];
//    BOOL flag = [NSKeyedArchiver archiveRootObject:array toFile:homePath];//归档一个字
//    
//}

//由tradeId获取其pid
+(NSString *) getTradePId:(NSString *)tradeId
{
    if( !tradeId || tradeId == nil )
    {
        return nil;
    }
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in tradeData ) {
        if( [dataModal.id_ isEqualToString:tradeId] && !dataModal.bParent_ )
        {
            return dataModal.pId_;
        }
    }
    
    return nil;
}

+(NSString *) getTradeName:(NSString *)tradeId
{
    if( !tradeId || tradeId == nil )
    {
        return nil;
    }
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in tradeData ) {
        if( [dataModal.id_ isEqualToString:tradeId] && dataModal.bParent_ )
        {
            return dataModal.str_;
        }
    }
    return nil;
}

+(NSString *) getTotalNameWithTotalId:(NSString *)totalId
{
    if( !totalId || totalId == nil )
    {
        return nil;
    }
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in tradeData ) {
        if( [dataModal.id_ isEqualToString:totalId] && dataModal.bParent_ )
        {
            return dataModal.str_;
        }
    }
    return nil;
}

+(NSString *) getTradeNameWithTradeId:(NSString *)tradeId
{
    if( !tradeId || tradeId == nil )
    {
        return nil;
    }
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in tradeData ) {
        if( [dataModal.id_ isEqualToString:tradeId] && !dataModal.bParent_ )
        {
            return dataModal.str_;
        }
    }
    return nil;
}

+(CondictionList_DataModal *) returnPtradeId:(NSString *)tradeId
{
    if( !tradeId || tradeId == nil )
    {
        return nil;
    }
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in tradeData ) {
        if( [dataModal.id_ isEqualToString:tradeId])
        {
            return dataModal;
        }
    }
    return nil;
}

+(CondictionList_DataModal *) returnModelWithTradeId:(NSString *)tradeId
{
    if( !tradeId || tradeId == nil )
    {
        return nil;
    }
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in tradeData ) {
        if( [dataModal.id_ isEqualToString:tradeId] && !dataModal.bParent_)
        {
            return dataModal;
        }
    }
    return nil;
}

//设置代理
-(void) setDelegate_:(id<CondictionChooseDelegate>)delegate
{
    delegate_ = delegate;
    subCtl_.delegate_ = delegate;
}

- (void)setGuWenData:(NSMutableArray *)dic;
{
    [dataArr_ removeAllObjects];
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    for (CondictionList_DataModal *dataModal in tradeData) {
        if( dataModal.bParent_ )
        {
            for (NSString *tradeId in dic) {
                if ([tradeId isEqualToString:dataModal.id_]) {
                    [dataArr_ addObject:dataModal];
                }
            }
        }
    }
    [tableView_ reloadData];
}

//设置数据
-(void) setData
{
    [dataArr_ removeAllObjects];
    
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = @"所有行业";
    dataModal.id_ = nil;
    dataModal.bParent_ = NO;
    [dataArr_ addObject:dataModal];
    
    if( !tradeData ){
        [CondictionTradeCtl initData];
    }
    
    for (CondictionList_DataModal *dataModal in tradeData) {
        if( dataModal.bParent_ )
        {
            [dataArr_ addObject:dataModal];
        }
    }
    
    [tableView_ reloadData];
}

-(void) bePushed:(UIViewController *)ctl
{
    [super bePushed:ctl];
    
    self.delegate_ = (id<CondictionChooseDelegate>)ctl;
    
    [tableView_ scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma UITableView Delegate
#pragma mark TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	    
    return [dataArr_ count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *textLb;
    UIActivityIndicatorView *indicatorView;
    
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    CondictionList_Cell *cell = (CondictionList_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[[NSBundle mainBundle] loadNibNamed:@"CondictionList_Cell" owner:self options:nil] lastObject];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
        
        //找到里面自定义的textLb
        textLb     = (UILabel *)[cell viewWithTag:100];
        indicatorView = (UIActivityIndicatorView *)[cell viewWithTag:120];
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
    }
    textLb.text = @"";
    indicatorView.alpha = 0.0;
    //cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger row = [indexPath row];
    
    if( [dataArr_ count] == 0)
    {
        textLb.text = @"无数据";
        
        return cell;
    }
    
    CondictionList_DataModal *dataModal = [dataArr_ objectAtIndex:row];
    if( dataModal.bParent_ )
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    textLb.text = dataModal.str_;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    
    @try {
        CondictionList_DataModal *dataModal = [dataArr_ objectAtIndex:row];
        
        if( dataModal.bParent_ )
        {            
            [self.navigationController pushViewController:subCtl_ animated:YES];
            subCtl_.title = dataModal.str_;
            
            NSString *dataId = dataModal.id_;
            
            //组装出数组
            NSMutableArray *subArr = [[NSMutableArray alloc] init];
            [subArr addObject:dataModal];
            for ( CondictionList_DataModal *dataModal in tradeData ) {
                if( [dataModal.pId_ isEqualToString:dataId] && !dataModal.bParent_ )
                {
                    [subArr addObject:dataModal];
                }
            }
            [subCtl_ setData:subArr];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
            [delegate_ condictionChooseComplete:self dataModal:dataModal type:GetTradeType];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[PreCondictionListCtl-->haveChoosed] : Happen Error\n");
    }
    @finally {
        
    }
    
}

@end
