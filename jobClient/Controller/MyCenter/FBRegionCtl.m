//
//  PositonType.m
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "FBRegionCtl.h"
#import <sqlite3.h>
#import "TradeZWModel.h"
#import "PositionCell.h"

@interface FBRegionCtl ()<UITableViewDataSource, UITableViewDelegate>
{
    sqlite3   *database;
    NSMutableArray *resulArr;
    NSMutableArray  *subResulArr;
    FMDatabase *db;
    NSDictionary *tempDic1;
    
    NSIndexPath *seletedIndexPath;
    
    NSString *selectLeftId;
    NSString *selectRightId;
    
//    UILabel *locationName;
//    UILabel *promptLabel;
    UIView *topBgView;
    NSString *localCityStr;
}
@property(nonatomic, strong) UILabel *locationName;

@end

@implementation FBRegionCtl

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationItem.title = @"选择工作地点";
    [self setNavTitle:@"选择工作地点"];
    
    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(_tableView1.right, 0, ScreenWidth/2, ScreenHeight - 64) style:UITableViewStylePlain];
    
    if (_showLocation) {
        
        if (!topBgView) {
            topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
            [self.view addSubview:topBgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(localTapClick:)];
            [topBgView addGestureRecognizer:tap];
            topBgView.userInteractionEnabled = YES;
        }
        
        if (!_locationName) {
           _locationName = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 100, 15)];
           
        }
//        locationName.text = @"正在定位城市...";
        _locationName.font = [UIFont systemFontOfSize:15];
        _locationName.textColor = UIColorFromRGB(0x333333);
        [_locationName sizeToFit];
        [topBgView addSubview:_locationName];
        
        [self startLocation];
        
        CGRect frame = _tableView1.frame;
        frame.origin.y = 48;
        frame.size.height -= frame.origin.y;
        _tableView1.frame = frame;
        
        frame = _tableView2.frame;
        frame.origin.y = 48;
        frame.size.height -= frame.origin.y;
        _tableView2.frame = frame;
    }
    
    _tableView1.delegate = self;
    _tableView2.delegate = self;
    _tableView1.dataSource = self;
    _tableView2.dataSource = self;
    
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView2.tableFooterView = [[UIView alloc]init];
    _tableView2.separatorColor = UIColorFromRGB(0xe0e0e0);
    
    [self.view addSubview:_tableView1];
    [self.view addSubview:_tableView2];
    
    
    resulArr = [[NSMutableArray alloc] init];
    subResulArr = [[NSMutableArray alloc] init];
    
    if (_showQuanGuo) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"不限" forKey:@"name"];
        [dic setObject:@"" forKey:@"id"];
        [resulArr addObject:dic];
    }
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:@"热门城市" forKey:@"name"];
    [mDic setObject:@"0000" forKey:@"id"];
    [resulArr addObject:mDic];
    
    NSString *dbPath = [self databasePath];
    db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    NSString *sql1 = [NSString stringWithFormat:@"select * from region_choosen where level == 0"];
    FMResultSet *rs = [db executeQuery:sql1];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"selfName"];
        NSString *idString = [rs stringForColumn:@"selfId"];
        NSString *parentid = [rs stringForColumn:@"parentId"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:name forKey:@"name"];
        [dic setObject:idString forKey:@"id"];
        [dic  setObject:parentid forKey:@"pid"];
        [resulArr addObject:dic];
    }
    
    NSInteger seletedIndex = 0;
    
    if (_inzwmodel.region.length > 0)
    {
        for (NSDictionary *dic1 in resulArr)
        {
            NSString *sql2 = [NSString stringWithFormat:@"select * from region_choosen where parentid == '%@'",dic1[@"id"]];
            FMResultSet *rs = [db executeQuery:sql2];
            BOOL flag = NO;
            while ([rs next]) {
                NSString *name = [rs stringForColumn:@"selfName"];
                if ([name isEqualToString:_inzwmodel.region])
                {
                    selectLeftId = [rs stringForColumn:@"parentId"];
                    selectRightId = [rs stringForColumn:@"selfId"];
                    flag = YES;
                    break;
                }
            }
            [rs close];
            if (flag)
            {
                break;
            }
            seletedIndex ++;
        }
    }
    else if ([Manager shareMgr].regionName_ != nil || _selectId.length > 0)
    {
        NSString *selectId;
        if (_isShowLocation) {
            selectId = @"";
        }
        else{
            selectId = [CondictionListCtl getRegionId:[Manager shareMgr].regionName_];
        }
       

        if (_selectId.length > 0) {
            selectId = _selectId;
        }
        
        if (![_selectId isEqualToString:@""]) {
            for (NSDictionary *dic1 in resulArr)
            {
                NSString *sql2 = [NSString stringWithFormat:@"select * from region_choosen where parentid == '%@'",dic1[@"id"]];
                FMResultSet *rs = [db executeQuery:sql2];
                BOOL flag = NO;
                while ([rs next]) {
                    NSString *name = [rs stringForColumn:@"selfId"];
                    if ([name isEqualToString:selectId])
                    {
                        selectLeftId = [rs stringForColumn:@"parentId"];
                        selectRightId = [rs stringForColumn:@"selfId"];
                        flag = YES;
                        break;
                    }
                }
                [rs close];
                if (flag)
                {
                    break;
                }
                seletedIndex ++;
            }

        }
    }
    if (seletedIndex >= resulArr.count)
    {
        seletedIndex = 0;
    }
    
    NSDictionary *subdic = [resulArr objectAtIndex:seletedIndex];
    NSString *sql2 = [NSString stringWithFormat:@"select * from region_choosen where parentId == '%@'" ,subdic[@"id"]];
    rs = [db executeQuery:sql2];
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"selfName"];
        NSString *idString = [rs stringForColumn:@"selfId"];
        NSString *parentid = [rs stringForColumn:@"parentId"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:name forKey:@"name"];
        [dic setObject:idString forKey:@"id"];
        [dic  setObject:parentid forKey:@"pid"];
        [subResulArr addObject:dic];
    }
    [rs close];
    
    NSIndexPath *selectedIndexPath;
    if (_selectHotCity) {
        selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [subResulArr removeAllObjects];
        
        NSMutableArray *arrHot = [[NSMutableArray alloc] initWithObjects:@"北京市",@"上海市",@"天津市",@"重庆市",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
        NSArray *arrHotId = @[@"110000",@"310000",@"120000",@"500000",@"440100",@"440300",@"420100",@"320100",@"330100",@"510100",@"610100"];
        for (int i= 0; i<arrHot.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:arrHot[i] forKey:@"name"];
            [dic setObject:arrHotId[i] forKey:@"id"];
            [subResulArr addObject:dic];
        }

    }else{
        selectedIndexPath = [NSIndexPath indexPathForRow:seletedIndex inSection:0];
    }
    
    [_tableView1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)startLocation
{
//    _locationName.text = @"正在定位城市...";
    [self configUI:@"正在定位城市..." showPrompt:NO];
    WS(weakSelf)
    [[MMLocationManager shareLocation] getCity:^(NSString *cityString) {
        localCityStr = cityString;
        [weakSelf configUI:cityString showPrompt:YES];
        
    } error:^(NSError *error){
        [weakSelf configUI:@"定位失败，请点击重试" showPrompt:NO];

    }];
}

- (void)configUI:(NSString *)locationStatus showPrompt:(BOOL)prompt
{
    _locationName.text = locationStatus;
    [_locationName sizeToFit];
    
    if (prompt) {
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationName.right+10, 1, 100, topBgView.height)];
        promptLabel.text = @"当前城市";
        promptLabel.font = [UIFont systemFontOfSize:14];
        promptLabel.textColor = UIColorFromRGB(0x9e9e9e);
        [topBgView addSubview:promptLabel];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView1) {
        if ([resulArr count]!=0) {
            return [resulArr count];
        }
    }else if(tableView == _tableView2){
        if ([subResulArr count]!=0) {
            return [subResulArr count];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1) {
        static NSString *reuseIdentifier = @"PositionCell";
        PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PositionCell" owner:self options:nil][0];
            cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);

            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xffffff);
        }
        NSDictionary *dic = resulArr[indexPath.row];
        [cell.titleLb setText:dic[@"name"]];
        return cell;
    }else{
        static NSString *reuseIdentifier = @"PositionCell";
        PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PositionCell" owner:self options:nil][0];
            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            cell.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        }
        NSDictionary *dic = subResulArr[indexPath.row];
        [cell.titleLb setText:dic[@"name"]];
        if ([dic[@"id"] isEqualToString:selectRightId]) {
            [cell.titleLb setTextColor:UIColorFromRGB(0xe13e3e)];
            cell.selectedImg.hidden = NO;
        }else{
            [cell.titleLb setTextColor:UIColorFromRGB(0x333333)];
            cell.selectedImg.hidden = YES;
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1) 
    {
        [subResulArr removeAllObjects];
        
        NSDictionary *dic = resulArr[indexPath.row];
        tempDic1 = dic;
        if([tempDic1[@"id"] isEqualToString:@""])
        {
            
            _selectHotCity = NO;
            NSString *name = nil;
            if ([_type isEqualToString:@"1"]) {
                name = [NSString stringWithFormat:@"%@%@",tempDic1[@"name"],dic[@"name"]];
            }else{
                name = dic[@"name"];
            }
            _inzwmodel.region = name;
            _inzwmodel.regionid = dic[@"id"];
            
            if(_isModify){
               [self modifyRegion:dic[@"id"] name:name];
            }
            else{
                if (_block) {
                    _block(name,dic[@"id"],_selectHotCity);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else if ([tempDic1[@"id"] isEqualToString:@"0000"]){
                _selectHotCity = YES;
                NSMutableArray *arrHot = [[NSMutableArray alloc] initWithObjects:@"北京市",@"上海市",@"天津市",@"重庆市",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
                NSArray *arrHotId = @[@"110000",@"310000",@"120000",@"500000",@"440100",@"440300",@"420100",@"320100",@"330100",@"510100",@"610100"];
                for (int i= 0; i<arrHot.count; i++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:arrHot[i] forKey:@"name"];
                    [dic setObject:arrHotId[i] forKey:@"id"];
                    [subResulArr addObject:dic];
                }
            [_tableView2 reloadData];

        }
        else
        {
            _selectHotCity = NO;
            NSString *sql2 = [NSString stringWithFormat:@"select * from region_choosen where parentid == '%@'",dic[@"id"]];
            FMResultSet *rs = [db executeQuery:sql2];
            while ([rs next]) {
                NSString *name = [rs stringForColumn:@"selfName"];
                NSString *idString = [rs stringForColumn:@"selfId"];
                NSString *parentid = [rs stringForColumn:@"parentId"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:name forKey:@"name"];
                [dic setObject:idString forKey:@"id"];
                [dic  setObject:parentid forKey:@"pid"];
                [subResulArr addObject:dic];
            }
            [_tableView2 reloadData];
            [rs close];
            
            
        }
        
    }else{
        
        
        NSDictionary *dic = subResulArr[indexPath.row];
        NSString *name = nil;
        if ([_type isEqualToString:@"1"]) {
            name = [NSString stringWithFormat:@"%@%@",tempDic1[@"name"],dic[@"name"]];
        }else{
            name = dic[@"name"];
        }
        _inzwmodel.region = name;
        _inzwmodel.regionid = dic[@"id"];
        
        if(_isModify){
            [self modifyRegion:dic[@"id"] name:name];
        }
        else{
            if (_block) {
                _block(name,dic[@"id"],_selectHotCity);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//点击当前定位城市
-(void)localTapClick:(UITapGestureRecognizer *)tap{
//    UILabel *label = (UILabel *)tap.view;
    NSString *localCity = localCityStr;
    NSString *localId = [CondictionPlaceCtl getRegionId:localCity];
    NSString *pLocalId = [CondictionPlaceCtl getRegionPId:localCity];
    for (NSDictionary *dic in resulArr) {
        if ([dic[@"id"] isEqualToString:pLocalId]) {
            [subResulArr removeAllObjects];
            tempDic1 = dic;
            _selectHotCity = NO;
            NSString *sql2 = [NSString stringWithFormat:@"select * from region_choosen where parentid == '%@'",dic[@"id"]];
            FMResultSet *rs = [db executeQuery:sql2];
            while ([rs next]) {
                NSString *name = [rs stringForColumn:@"selfName"];
                NSString *idString = [rs stringForColumn:@"selfId"];
                NSString *parentid = [rs stringForColumn:@"parentId"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:name forKey:@"name"];
                [dic setObject:idString forKey:@"id"];
                [dic  setObject:parentid forKey:@"pid"];
                [subResulArr addObject:dic];
            }
            [rs close];
        }
    }
    for (NSDictionary *dic in subResulArr) {
        if ([dic[@"id"] isEqualToString:localId]) {
            NSString *name = nil;
            if ([_type isEqualToString:@"1"]) {
                name = [NSString stringWithFormat:@"%@%@",tempDic1[@"name"],dic[@"name"]];
            }else{
                name = dic[@"name"];
            }
            _inzwmodel.region = name;
            _inzwmodel.regionid = dic[@"id"];
            
            if(_isModify){
                [self modifyRegion:dic[@"id"] name:name];
            }
            else{
                if (_block) {
                    _block(name,dic[@"id"],_selectHotCity);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
}

-(NSString *) databasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path lastObject];
    NSLog(@"reurl = %@",[pathname stringByAppendingPathComponent:@"data.db"]);
    return [pathname stringByAppendingPathComponent:@"data.db"];
}

-(void)modifyRegion:(NSString *)regionid name:(NSString *)name{
    NSString * function = @"edit_card";
    NSString * op = @"person_info_api";
    NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
    [updateDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    [updateDic setObject:regionid forKey:@"regionid"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *updateStr = [jsonWriter2 stringWithObject:updateDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",updateStr];
    [BaseUIViewController showLoadView:YES content:nil view:self.view];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        if (_block) {
            _block(name,regionid,_selectHotCity);
        }
        [self.navigationController popViewControllerAnimated:YES];
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ELRegionCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

@end
