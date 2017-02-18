//
//  ELJobTypeChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/5/30.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELJobTypeChangeCtl.h"
#import "DataBase.h"

@interface ELJobTypeChangeCtl () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *resulArr;
    FMDatabase *db;
    __weak IBOutlet UITableView *_tableView;
}
@end

@implementation ELJobTypeChangeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    self.navigationItem.title = @"选择职位类型";
    [self setNavTitle:@"选择职位类型"];
    //NSString *dbPath = [self databasePath];
    db = [DataBase shareDatabase].database;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    resulArr = [[NSMutableArray alloc] init];
    NSString *sql1 = @"";
    if (_type == 1) {
        sql1 = [NSString stringWithFormat:@"select * from trade_zw where parentId= '0' and tradeid= '1000' order by orders asc"];
    }else if (_type == 2){
        sql1 = [NSString stringWithFormat:@"select * from trade_zw where parentId= '%@' and tradeid= '1000' order by orders asc",_jobId];
    }
    
    FMResultSet *rs = [db executeQuery:sql1];
    while ([rs next]) {
        NSInteger tradeidint = [rs intForColumn:@"tradeid"];
        NSInteger zwidint = [rs intForColumn:@"zwid"];
        NSString  *zwName = [rs stringForColumn:@"zwname"];
        NSInteger  parentidint = [rs intForColumn:@"parentId"];
        TradeZWModel *model = [TradeZWModel alloc];
        model.zwName = zwName;
        model.zwid = [NSString stringWithFormat:@"%ld",(long)zwidint];
        model.tradeid = [NSString stringWithFormat:@"%ld",(long)tradeidint];
        model.parentid = [NSString stringWithFormat:@"%ld",(long)parentidint];
        [resulArr addObject:model];
    }
    [rs close];
    [_tableView reloadData];
}

-(BOOL)changeWithZwid:(NSString *)zwid{
    NSString *sql1 = [NSString stringWithFormat:@"select * from trade_zw where parentId= '%@' and tradeid= '1000' order by orders asc",zwid];
    FMResultSet *rs = [db executeQuery:sql1];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resulArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"PositionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectedBackgroundView.backgroundColor = [[UIColor alloc]initWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10,12,ScreenWidth-50,20)];
        titleLable.font = FIFTEENFONT_TITLE;
        titleLable.tag = 200;
        [cell.contentView addSubview:titleLable];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(-10,43,ScreenWidth+10,1)];
        image.image = [UIImage imageNamed:@"gg_home_line2@2x.png"];
        [cell.contentView addSubview:image];
        
        UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30,15,7,13)];
        imageRight.image = [UIImage imageNamed:@"icon_jiantou.png"];
        imageRight.tag = 1002;
        [cell.contentView addSubview:imageRight];
    }
    UILabel *titleLb = (UILabel *)[cell viewWithTag:200];
    TradeZWModel *model = resulArr[indexPath.row];
    [titleLb setText:model.zwName];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeZWModel *dataModel = resulArr[indexPath.row];
    if (_type == 1) {
        if ([self changeWithZwid:dataModel.zwid]) {
            ELJobTypeChangeCtl *ctl = [[ELJobTypeChangeCtl alloc] init];
            ctl.type = 2;
            ctl.jobId = dataModel.zwid;
            ctl.block = ^(TradeZWModel *model){
                _block(model);
            };
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            _block(dataModel);
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-2] animated:YES];
        }
    }else if(_type == 2){
        _block(dataModel);
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
    }
}

-(NSString *) databasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path lastObject];
    NSLog(@"reurl = %@",[pathname stringByAppendingPathComponent:@"data.db"]);
    return [pathname stringByAppendingPathComponent:@"data.db"];
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
