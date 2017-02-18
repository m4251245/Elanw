//
//  RegionListCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "RegionCtl.h"
#import "MMLocationManager.h"

@interface RegionCtl ()

@end

@implementation RegionCtl
@synthesize delegate_;
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
-(id)init
{
    self = [super init];
    bHeaderEgo_ = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择地区";
    [self setNavTitle:@"选择地区"];
    // Do any additional setup after loading the view from its nib.
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCity
{
//    __block __weak RegionListCtl *wself = self;

    bLocation_ = YES;
    if (!currentPlaceStr_ || [currentPlaceStr_ isEqualToString:@""]) {
        
        [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
            currentPlaceStr_ = cityString;
            [cityLb_ setText:currentPlaceStr_];
            
        } error:^(NSError *error){
            bLocation_ = NO;
            [cityLb_ setText:@"定位失败或者未开启定位服务"];
            NSLog(@"%@",error);
        }];
    }
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self getCity];
    if (!hotRegionArr_) {
        hotRegionArr_  = [[NSMutableArray alloc] initWithObjects:@"北京",@"上海",@"天津",@"重庆",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
    }
    [tableView_ reloadData];
}


#pragma UITableView Delegate
#pragma mark TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 50.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    headView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    UILabel * textLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    textLb.text = @"热门城市";
    textLb.textColor = UIColorFromRGB(0x333333);
    textLb.font = [UIFont systemFontOfSize:15];
    [headView addSubview:textLb];
    
    UIButton * myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.frame = CGRectMake(240, 5, 70, 30);
    [myBtn setTitle:@"按省选择" forState:UIControlStateNormal];
    [myBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [myBtn setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:66.0/255.0 blue:22.0/255.0 alpha:1.0]];
    [myBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    myBtn.layer.cornerRadius = 4.0;
    myBtn.tag = 101;
    [myBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //[headView addSubview:myBtn];
    
    return headView;
    
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
    }
    return cnt;
    return [hotRegionArr_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RegionCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        
    }
    NSInteger section = [indexPath section];
    NSInteger row     = [indexPath row];
    
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 49, ScreenWidth - 15, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xecedec);
    [cell.contentView addSubview:lineView];
    //定位
    if( section == 2 )
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
                
                cell.textLabel.text = GPS_Place_Loading;
            }else{
                getCurrentPlaceIndicatorView_.alpha = 0.0;
                
                cell.textLabel.text = @"定位失败";
            }
        }else
        {
            getCurrentPlaceIndicatorView_.alpha = 0.0;
            cell.textLabel.text = currentPlaceStr_;
        }
    }
    //热门地区
    else if( section == 1 )
    {
        if( hotRegionArr_ == 0 )
        {
            cell.textLabel.text = @"无数据";
            
            return cell;
        }
        
        NSString *str = [hotRegionArr_ objectAtIndex:row];
        cell.textLabel.text = str;
        
        
    }
    else if (section == 0 )
    {
//        if (row == 0) {
//            cell.textLabel.text = @"全国(不限地区)";
//        }
//        if (row == 1) {
            cell.textLabel.text = @"按省选择";
        [cell  setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        }
    }
    
    return cell;
}


-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NSString * choosedCity;
    if (indexPath.section == 0 ) {
//        if (indexPath.row == 0) {
//            choosedCity = @"全国";
//            [delegate_ chooseHotCity:self city:choosedCity];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        if (indexPath.row == 1) {
            if (!regionListCtl_) {
                regionListCtl_ = [[RegionConditionListCtl alloc] init];
            }
        
            [self.navigationController pushViewController:regionListCtl_ animated:YES];
            [regionListCtl_ getIn:self type:CondictionType_Region bHaveSub:YES];
//        }
    }
    else{
        if ([hotRegionArr_ count] == 0) {
            return;
        }
        choosedCity = [hotRegionArr_ objectAtIndex:indexPath.row];
        [delegate_ chooseHotCity:self city:choosedCity];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}


-(void)btnResponse:(id)sender
{
    if (sender == jumpBtn_) {
        [self.navigationController pushViewController:[CondictionListCtl shareCtl] animated:YES];
        [[CondictionListCtl shareCtl] getIn:self type:CondictionType_Region bHaveSub:YES];
    }
    else if (sender == chooseLocationBtn_) {
        NSString * choosedCity = @"";
        if (!currentPlaceStr_ || [currentPlaceStr_ isEqualToString:@""]) {
            currentPlaceStr_ = @"全国";
        }
        choosedCity = currentPlaceStr_;
        [delegate_ chooseHotCity:self city:choosedCity];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIButton * btn = sender;
        if (btn.tag == 101) {
            
            if (!regionListCtl_) {
                regionListCtl_ = [[RegionConditionListCtl alloc] init];
            }
            
            [self.navigationController pushViewController:regionListCtl_ animated:YES];
            [regionListCtl_ getIn:self type:CondictionType_Region bHaveSub:YES];
        }
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
                    
            [delegate_ chooseHotCity:self city:dataModal.str_];
        }
            break;
        default:
            break;
    }
}


@end
