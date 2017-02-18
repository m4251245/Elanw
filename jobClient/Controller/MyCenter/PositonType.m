//
//  PositonType.m
//  jobClient
//
//  Created by 一览ios on 15/10/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "PositonType.h"
#import <sqlite3.h>
#import "TradeZWModel.h"
#import "PositionCell.h"

@interface PositonType ()<UITableViewDataSource, UITableViewDelegate>
{
    sqlite3   *database;
    NSMutableArray *resulArr;
    NSMutableArray  *subResulArr;
    FMDatabase *db;
    TradeZWModel *seletedModel;
    __weak IBOutlet UIView *_noDataView;
}
@end

@implementation PositonType

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"1"]) {
        [self setNavTitle:@"选择工作地点"];
    }else{
        [self setNavTitle:@"选择职位类型"];
    }
    
    resulArr = [[NSMutableArray alloc] init];
    subResulArr = [[NSMutableArray alloc] init];
    NSString *dbPath = [self databasePath];
    db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *sql1 = [NSString stringWithFormat:@"select * from trade_zw where parentId = '0' and tradeid == '%@' order by orders asc",_inzwmodel.zp_urlId];
    FMResultSet *rs = [db executeQuery:sql1];
    while ([rs next]) {
        NSInteger tradeidint = [rs intForColumn:@"tradeid"];
        NSInteger zwidint = [rs intForColumn:@"zwid"];
        NSString  *zwName = [rs stringForColumn:@"zwname"];
        NSInteger  parentidint = [rs intForColumn:@"parentid"];
        TradeZWModel *model = [TradeZWModel alloc];
        model.zwName = zwName;
        model.zwid = [NSString stringWithFormat:@"%ld",(long)zwidint];
        model.tradeid = [NSString stringWithFormat:@"%ld",(long)tradeidint];
        model.parentid = [NSString stringWithFormat:@"%ld",(long)parentidint];
        [resulArr addObject:model];
    }
    TradeZWModel *subModel = [resulArr firstObject];
    NSString *sql2 = [NSString stringWithFormat:@"select * from trade_zw where parentId = '%@' and tradeid == '%@' order by orders asc",subModel.zwid,_inzwmodel.zp_urlId];
    rs = [db executeQuery:sql2];
    while ([rs next]) {
        NSInteger tradeidint = [rs intForColumn:@"tradeid"];
        NSInteger zwidint = [rs intForColumn:@"zwid"];
        NSString  *zwName = [rs stringForColumn:@"zwname"];
        NSInteger  parentidint = [rs intForColumn:@"parentid"];
        TradeZWModel *model = [TradeZWModel alloc];
        model.zwName = zwName;
        model.zwid = [NSString stringWithFormat:@"%ld",(long)zwidint];
        model.tradeid = [NSString stringWithFormat:@"%ld",(long)tradeidint];
        model.parentid = [NSString stringWithFormat:@"%ld",(long)parentidint];
        [subResulArr addObject:model];
    }
    [rs close];
    _tableView1.delegate = self;
    _tableView2.delegate = self;
    _tableView1.dataSource = self;
    _tableView2.dataSource = self;
    
    CGRect frame = _tableView1.frame;
    frame.size.width = ScreenWidth/2.0;
    _tableView1.frame = frame;
    
    frame = _tableView2.frame;
    frame.size.width = ScreenWidth/2.0;
    frame.origin.x = ScreenWidth/2.0;
    _tableView2.frame = frame;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView1) {
        if ([resulArr count]!=0) {
            return [resulArr count];
        }
    }else{
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
            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [[UIColor alloc]initWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1]; ;
        }
        TradeZWModel *model = resulArr[indexPath.row];
        [cell.titleLb setText:model.zwName];
        return cell;
    }else{
        static NSString *reuseIdentifier = @"PositionCell";
        PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PositionCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
        }
        TradeZWModel *model = subResulArr[indexPath.row];
        [cell.titleLb setText:model.zwName];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _tableView1) {
        TradeZWModel *model = resulArr[indexPath.row];
        seletedModel = model;
        NSString *sql2 = [NSString stringWithFormat:@"select * from trade_zw where parentid == '%@' and tradeid == '%@'",model.zwid,_inzwmodel.zp_urlId];
        FMResultSet *rs = [db executeQuery:sql2];
        [subResulArr removeAllObjects];
        while ([rs next]) {
            NSInteger tradeidint = [rs intForColumn:@"tradeid"];
            NSInteger zwidint = [rs intForColumn:@"zwid"];
            NSString  *zwName = [rs stringForColumn:@"zwname"];
            NSInteger  parentidint = [rs intForColumn:@"parentid"];
            TradeZWModel *model = [TradeZWModel alloc];
            model.zwName = zwName;
            model.zwid = [NSString stringWithFormat:@"%ld",(long)zwidint];
            model.tradeid = [NSString stringWithFormat:@"%ld",(long)tradeidint];
            model.parentid = [NSString stringWithFormat:@"%ld",(long)parentidint];
            [subResulArr addObject:model];
        }
        [_tableView2 reloadData];
        [rs close];
        
        if (subResulArr.count <= 0)
        {
            _inzwmodel.job_childid = nil;
            _inzwmodel.job_child = nil;
            _inzwmodel.job = seletedModel.zwName;
            _inzwmodel.jobid = seletedModel.zwid;
            if (_block) {
                _block(_inzwmodel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        TradeZWModel *model = subResulArr[indexPath.row];
        _inzwmodel.job_childid = model.zwid;
        _inzwmodel.job_child = model.zwName;
        _inzwmodel.job = seletedModel.zwName;
        _inzwmodel.jobid = seletedModel.zwid;
        if (_block) {
            _block(_inzwmodel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _tableView1.hidden = YES;
    _tableView2.hidden = YES;
    
    NSInteger seletedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:seletedIndex inSection:0];
    [_tableView1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if (resulArr.count > 0) {
        _noDataView.hidden = YES;
        
        _tableView1.hidden = NO;
        _tableView2.hidden = NO;
        
        TradeZWModel *model = resulArr[selectedIndexPath.row];
        seletedModel = model;
    }
    else
    {
        _noDataView.hidden = NO;
    }

}


-(NSString *) databasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path lastObject];
    NSLog(@"reurl = %@",[pathname stringByAppendingPathComponent:@"data.db"]);
    return [pathname stringByAppendingPathComponent:@"data.db"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
