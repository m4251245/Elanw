//
//  CondictionPlaceCtl.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CondictionPlaceCtl.h"
#import "FMDatabase.h"
#import "Constant.h"


//从文件中读取的数据

@implementation CondictionPlaceCtl

@synthesize delegate_;
@synthesize bSubscribePlace_;

-(id) init
{
    self = [self initWithNibName:@"CondictionPlaceCtl" bundle:nil];
    
    //初始化结果集
    currentPlaceStr_    = nil;
    provinceArr_        = [[NSMutableArray alloc] init];
    
//    mapCtl_ = [[MapCtl alloc] init];
//    mapCtl_.delegate_ = self;
    
    condictionPlaceCtlSub_ = [[CondictionPlaceCtl_Sub alloc] init];
    
    
    bSubscribePlace_ = NO;
    
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
//    self.navigationItem.title = @"选择地区";
    [self setNavTitle:@"选择地区"];
    //设置代理
    tableView_.delegate     = self;
    tableView_.dataSource   = self;
    
    //设置一下数据
    [self setData];
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

-(void) startPop
{
    [super startPop];
    
    [lm_ stopUpdatingLocation];
    [reverseGeocoder_ cancelGeocode];
    
    currentPlaceStr_ = nil;
}

-(void) bePushed:(UIViewController *)ctl
{
    [super bePushed:ctl];
    
    self.delegate_ = (id<CondictionChooseDelegate>)ctl;
    
    [tableView_ scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    //开启定位
    [self updateCurrentPlace];
    
    //set the hot region arr
    [hotRegionArr_ removeAllObjects];
    hotRegionArr_ = nil;
    if( bSubscribePlace_ )
    {
        hotRegionArr_       = [[NSMutableArray alloc] initWithObjects:@"北京",@"上海",@"天津",@"重庆",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
    }else
        hotRegionArr_       = [[NSMutableArray alloc] initWithObjects:@"全国",@"北京",@"上海",@"天津",@"重庆",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
    
    [tableView_ reloadData];
}

-(void) setDelegate_:(id<CondictionChooseDelegate>)delegate
{
    delegate_ = delegate;
    condictionPlaceCtlSub_.delegate_ = delegate;
}

//初始化数据
+(void) initData
{
    [CondictionPlaceCtl loadRegionDataFromFile];
}

//从文件中反序列化数据(地区)
+(id) loadRegionDataFromFile
{
    //从序列化文件中取得数据
    FMDatabase *db;
    @try {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathname = [path lastObject];
        NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
         db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            NSLog(@"Could not open db.");
        }
        
        NSString *sql1 = [NSString stringWithFormat:@"select * from region_choosen"];
        FMResultSet *rs = [db executeQuery:sql1];
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
        return resulArr;
    }
    @catch (NSException *exception) {
        [PreBaseUIViewController showAlertView:@"异常" msg:@"地区列表获取失败,请尝试重启程序." btnTitle:@"关闭"];
        
        return nil;
    }
    @finally {
        [db close];
    }
    
    return nil;
}

//由regionStr获取regionId
+(NSString *) getRegionId:(NSString *)regionStr
{
    if( !regionStr || regionStr == nil )
    {
        return nil;
    }
    
    if( !regionArr ){
        [CondictionPlaceCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in regionArr ) {
        if( [dataModal.str_ isEqualToString:regionStr] )
        {
            return dataModal.id_;
        }
    }
    
    return nil;
}

//获由regionPId
+(NSString *) getRegionPId:(NSString *)regionStr
{
    if( !regionStr || regionStr == nil )
    {
        return nil;
    }
    
    if( !regionArr ){
        [CondictionPlaceCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in regionArr ) {
        if( [dataModal.str_ isEqualToString:regionStr] )
        {
            return dataModal.pId_;
        }
    }
    
    return nil;
}

//由regionId获取regionStr
+(NSString *) getRegionStr:(NSString *)regionId
{
    if( !regionId || regionId == nil )
    {
        return nil;
    }
    
    if( !regionArr ){
        [CondictionPlaceCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in regionArr ) {
        if( [dataModal.id_ isEqualToString:regionId] )
        {
            return dataModal.str_;
        }
    }
    
    return nil;
}

//检查regionid是否是省份的id
+(BOOL) checkRegionIsProvice:(NSString *)regionId
{
    const char *pFirst = [regionId UTF8String];
    
    //id为6位
    //如果后四位都是0，那么是省份的id
    if( *(pFirst+2) == '0' && *(pFirst+3) == '0' && *(pFirst+4) == '0' && *(pFirst+5) == '0')
    {
        return YES;
    }
    
    return NO;
}

//检查regionid是否是省份中的id
+(BOOL) checkRegionIsSubProvice:(NSString *)regionId
{
    const char *pFirst = [regionId UTF8String];
    
    //id为6位
    //如果后四位都是0，那么是省份的id
    if( *(pFirst+4) == '0' && *(pFirst+5) == '0')
    {
        return YES;
    }
    
    return NO;
}

//根据regionId获取region的具体位置
+(NSString *) getRegionDetailAddress:(NSString *)regionId
{
    if( !regionId || [regionId isEqualToString:@""] )
    {
        return nil;
    }
    
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    
    @try {
        if( ![regionId isEqualToString:@"100000"] )
        {
            //如果是省,只解析一层既可
            if( [CondictionPlaceCtl checkRegionIsProvice:regionId] )
            {
                [addressStr appendFormat:@"%@",[CondictionPlaceCtl getRegionStr:regionId]];
            }
            //如果是shi
            else if( [CondictionPlaceCtl checkRegionIsSubProvice:regionId] )
            {
                //先获取省的str
                NSString *shengId = [[NSString alloc] initWithFormat:@"%@0000",[regionId substringToIndex:2]];
                NSString *shengStr = [CondictionPlaceCtl getRegionStr:shengId];
                NSString *shiStr   = [CondictionPlaceCtl getRegionStr:regionId];
                
                [addressStr appendFormat:@"%@-%@",shengStr,shiStr];
            }else
            {
                //此时不具备县的解析(递归调用一次即可)
                if (regionId.length>4) {
                    NSString *shiId = [[NSString alloc] initWithFormat:@"%@00",[regionId substringToIndex:4]];
                    return [CondictionPlaceCtl getRegionDetailAddress:shiId];
                }
                
            }
        }
    }
    @catch (NSException *exception) {
        addressStr = nil;
    }
    @finally {
        
    }
    
    return addressStr;
}

+(NSString *) getRegionDetailAddressExcept:(NSString *)regionId
{
    if( !regionId || [regionId isEqualToString:@""] )
    {
        return nil;
    }
    
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    
    @try {
        if( ![regionId isEqualToString:@"100000"] )
        {
            //如果是省,只解析一层既可
            if( [CondictionPlaceCtl checkRegionIsProvice:regionId] )
            {
                [addressStr appendFormat:@"%@",[CondictionPlaceCtl getRegionStr:regionId]];
            }
            //如果是shi
            else if( [CondictionPlaceCtl checkRegionIsSubProvice:regionId] )
            {
                //先获取省的str
//                NSString *shengId = [[NSString alloc] initWithFormat:@"%@0000",[regionId substringToIndex:2]];
//                NSString *shengStr = [CondictionPlaceCtl getRegionStr:shengId];
                NSString *shiStr   = [CondictionPlaceCtl getRegionStr:regionId];
                
                [addressStr appendFormat:@"%@",shiStr];
            }else
            {
                //此时不具备县的解析(递归调用一次即可)
                NSString *shiId = [[NSString alloc] initWithFormat:@"%@00",[regionId substringToIndex:4]];
                return [CondictionPlaceCtl getRegionDetailAddressExcept:shiId];
            }
        }
    }
    @catch (NSException *exception) {
        addressStr = nil;
    }
    @finally {
        
    }
    
    return addressStr;
}



//由regionStr获取dataModal
+(CondictionList_DataModal *) getDataModalByStr:(NSString *)regionStr
{
    if( !regionStr || regionStr == nil )
    {
        return nil;
    }
    
    if( !regionArr ){
        [CondictionPlaceCtl initData];
    }
    
    for ( CondictionList_DataModal *dataModal in regionArr ) {
        if( [dataModal.str_ isEqualToString:regionStr] )
        {
            return dataModal;
        }
    }
    
    return nil;
}

//检测是否是省份
+(BOOL) checkIsProvince:(NSString *)regionStr
{
    BOOL bProvince = NO;
    
    if( !regionArr ){
        [CondictionPlaceCtl initData];
    }
    
    if( regionStr && ![regionStr isEqualToString:@""] )
    {
        for ( CondictionList_DataModal *dataModal in regionArr ) {
            if( [dataModal.str_ isEqualToString:regionStr] )
            {
                bProvince = dataModal.bParent_;
                break;
            }
        }
    }
    
    return bProvince;
}

//更新当前位置
-(void) updateCurrentPlace
{
    currentPlaceStr_ = nil;
    
    bLocation_ = YES;
    
    if( !lm_ ){
        //初始化lm
        lm_ = [[CLLocationManager alloc] init];
        lm_.delegate = self;
        lm_.desiredAccuracy = kCLLocationAccuracyBest;
        lm_.distanceFilter = 1000.0f;
    }
    
    [lm_ startUpdatingLocation];
    
    if( ![CLLocationManager locationServicesEnabled] )
    {
        errorCode_ = GPS_InValidate_Error;
        bLocation_ = NO;
    }
    else if( [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways )
    {
        errorCode_ = Map_InValidate_Error;
        bLocation_ = NO;
    }
    else
    {
        errorCode_ = Success;
    }
    
    [tableView_ reloadData];
}

#pragma CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"[Get Location] : %f %f\n",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    //获取到了自己的位置后，停止进一步的获取
    [lm_ stopUpdatingLocation];
    
    //反向解析出自己的所在地址
    //[reverseGeocoder_ cancel];
    if( !reverseGeocoder_ ){
        reverseGeocoder_ = [[CLGeocoder alloc] init];
    }
    [tableView_ reloadData];
    
    [reverseGeocoder_ reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            currentPlaceStr_ = placemark.locality;
            [tableView_ reloadData];
    }];
    
    /*
    [reverseGeocoder_ initWithCoordinate:newLocation.coordinate];
    reverseGeocoder_.delegate = self;
    [reverseGeocoder_ start];
    */
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"[Get Location] : %@\n",error.domain);
}

/*
#pragma MKReverseGeocoderDelegate
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    
    NSLog(@"[MKReverseGeocoder] : %@",error.domain);
    
    //重新去解析
    [lm_ startUpdatingLocation];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    NSLog(@"[MKReverseGeocoder] : %@",placemark.locality);
    
    //currentPlacemark_ release];
    //currentPlacemark_ = [placemark retain];
    
    currentPlaceStr_ = placemark.locality;
    
    [tableView_ reloadData];
}
*/

//设置自己的数据
-(void) setData
{
    //先清除，再计算
    [provinceArr_     removeAllObjects];

    if( !regionArr ){
        [CondictionPlaceCtl initData];
    }
    
    for (CondictionList_DataModal *dataModal in regionArr) {
        if( dataModal.bParent_ )
        {
            [provinceArr_ addObject:dataModal];
        }
    }

}

//设置自己有学校列表
-(void) initSchoolCtl
{
    [condictionPlaceCtlSub_ initSchoolCtl];
}

//设置子集不需要popBack
-(void) setSubPopBack:(BOOL)flag
{
    condictionPlaceCtlSub_.bNeedPopBack_ = flag;
}

#pragma UITableView Delegate
#pragma mark TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{	
    NSString *str;
	if( section == 0 )
    {
        str = @"您当前所在城市";
    }else if( section == 1 )
    {
        str = @"热门城市";
    }else if( section == 2 )
    {
        str = @"按省选择";
    }
    
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    NSString *sectionTitle=[self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle==nil) 
	{
        return nil;
	}
	
	// Create label with section title
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(8, 0, 300, 30);
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor colorWithRed:57.0/255 green:82.0/255 blue:145.0/255 alpha:1];
    label.font = [UIFont systemFontOfSize:17];
    //label.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
    label.text=sectionTitle;
    
    // Create header view and add label as a subview
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    sectionView.backgroundColor = [UIColor orangeColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_section_title.png"]];
    imageView.alpha = 1.0;
    [sectionView addSubview:imageView];
    //    [sectionView setBackgroundColor:[UIColor orangeColor]];
    [imageView setFrame:sectionView.frame];
    [sectionView addSubview:label];
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{	    
    NSInteger cnt = 0;
    
    if( section == 0 )
    {
        cnt = 1;
    }else if( section == 1 )
    {
        cnt = [hotRegionArr_ count];
    }else if( section == 2 )
    {
        cnt = [provinceArr_ count];
    }
    
    return cnt;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *textLb;
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    CondictionList_Cell *cell = (CondictionList_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[[NSBundle mainBundle] loadNibNamed:@"CondictionList_Cell" owner:self options:nil] lastObject];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
        
        //找到里面自定义的textLb
        textLb     = (UILabel *)[cell viewWithTag:100];
        
        //自定义cell的背景
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imageView setImage:[UIImage imageNamed:BG_Cell_1]];
        [imageView setFrame:cell.frame];
        [cell setBackgroundView:imageView];
    }
    
    textLb.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSInteger section = [indexPath section];
    NSInteger row     = [indexPath row];
    
    //定位
    if( section == 0 )
    {
        if( !currentPlaceStr_ )
        {
            if( bLocation_ )
            {
                getCurrentPlaceIndicatorView_.alpha = 1.0;
                
                [cell addSubview:getCurrentPlaceIndicatorView_];
                
                CGRect rect = getCurrentPlaceIndicatorView_.frame;
                rect.origin.x = 20;
                rect.origin.y = (int)((cell.frame.size.height - rect.size.height)/2.0);
                [getCurrentPlaceIndicatorView_ setFrame:rect];
                
                textLb.text = GPS_Place_Loading;
            }else{
                getCurrentPlaceIndicatorView_.alpha = 0.0;
                
                textLb.text = [ErrorInfo getErrorMsg:errorCode_];
            }
        }else
        {
            getCurrentPlaceIndicatorView_.alpha = 0.0;
            textLb.text = currentPlaceStr_;
        }
    }
    //热门地区
    else if( section == 1 )
    {
        if( hotRegionArr_ == 0 )
        {
            textLb.text = @"无数据";
            
            return cell;
        }
        
        NSString *str = [hotRegionArr_ objectAtIndex:row];
        textLb.text = str;
        
        if( [CondictionPlaceCtl checkIsProvince:str] )
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    //按省选择
    else if( section == 2 )
    {
        if( [provinceArr_ count] == 0)
        {
            textLb.text = @"无数据";
            
            return cell;
        }
        
        CondictionList_DataModal *dataModal = [provinceArr_ objectAtIndex:row];
        
        if( dataModal.bParent_ )
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        textLb.text = dataModal.str_;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    NSInteger row     = [indexPath row];
    NSString    *regionStr;
    
    @try {
        //定位
        if( section == 0 )
        {
            if( currentPlaceStr_ )
            {
                CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
                dataModal.id_ = [CondictionPlaceCtl getRegionId:currentPlaceStr_];
                dataModal.str_ = currentPlaceStr_;
                dataModal.pId_ = [CondictionPlaceCtl getRegionPId:currentPlaceStr_];
                dataModal.bParent_ = NO;
                
                [delegate_ condictionChooseComplete:self dataModal:dataModal type:GetRegionType];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            //重新定位
            else
            {
                [self updateCurrentPlace];
            }
        }
        //热门地区
        else if( section == 1 )
        {
            regionStr = [hotRegionArr_ objectAtIndex:row];
            
            if( [regionStr isEqualToString:@"全国"] )
            {
                [delegate_ condictionChooseComplete:self dataModal:nil type:GetRegionType];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                if( [CondictionPlaceCtl checkIsProvince:regionStr] )
                {
                    [self.navigationController pushViewController:condictionPlaceCtlSub_ animated:YES];
                    condictionPlaceCtlSub_.title = regionStr;
                    
                    NSString *regionId = [CondictionPlaceCtl getRegionId:regionStr];
                    
                    //组装出数组
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    for ( CondictionList_DataModal *dataModal in regionArr ) {
                    if( [dataModal.pId_ isEqualToString:regionId] && ( !dataModal.bParent_ || ( dataModal.bParent_ && !condictionPlaceCtlSub_.schoolCtl_ ) ) )
                        {
                            [subArr addObject:dataModal];
                        }
                    }
                    
                    [condictionPlaceCtlSub_ setData:subArr];
                }else
                {
                    CondictionList_DataModal *dataModal = [CondictionPlaceCtl getDataModalByStr:regionStr];
                    
                    [delegate_ condictionChooseComplete:self dataModal:dataModal type:GetRegionType];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        //按省选择
        else if( section == 2 )
        {
            CondictionList_DataModal *dataModal = [provinceArr_ objectAtIndex:row];
            
            [self.navigationController pushViewController:condictionPlaceCtlSub_ animated:YES];
            condictionPlaceCtlSub_.title = dataModal.str_;
            
            NSString *regionId = dataModal.id_;
            
            //组装出数组
            NSMutableArray *subArr = [[NSMutableArray alloc] init];
            for ( CondictionList_DataModal *dataModal in regionArr ) {
                if( [dataModal.pId_ isEqualToString:regionId] && ( !dataModal.bParent_ || ( dataModal.bParent_ && !condictionPlaceCtlSub_.schoolCtl_ ) ) )
                {
                    [subArr addObject:dataModal];
                }
            }
            [condictionPlaceCtlSub_ setData:subArr];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[PreCondictionListCtl-->haveChoosed] : Happen Error\n");
    }
    @finally {
        
    }

}

@end
