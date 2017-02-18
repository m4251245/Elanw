//
//  FBCondictionCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "FBCondictionCtl.h"
#import "ZWConditionCell.h"
#import "FMDatabase.h"
#import "TradeZWModel.h"

@interface FBCondictionCtl ()
{
    NSString    *incompanyId;
    NSMutableArray *resulArr;
    FMDatabase *db;
}
@end

@implementation FBCondictionCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    bHeaderEgo_ = NO;
    bFooterEgo_ = NO;
    
    if ([_type isEqualToString:@"1"]) {
//        self.navigationItem.title = @"选择学历";
        [self setNavTitle:@"选择学历"];
    }else if([_type isEqualToString:@"2"]){
//        self.navigationItem.title = @"选择薪酬";
        [self setNavTitle:@"选择薪酬"];
    }else{
//        self.navigationItem.title = @"选择工作经验";
        [self setNavTitle:@"选择工作经验"];
    }
    
    if ([_type isEqualToString:@"2"]) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:@"1000-2000",@"2000-4000",@"4000-6000",@"6000-8000",@"8000-10000",@"10000-15000",@"15000-20000",@"20000-30000",@"30000-50000",@"50000以上", nil];
        resulArr = [tempArr copy];
    }else{
        NSString *sql1 = nil;
        resulArr = [[NSMutableArray alloc] init];
        NSString *dbPath = [self databasePath];
        db = [FMDatabase databaseWithPath:dbPath];
        if (![db open]) {
            NSLog(@"Could not open db.");
            return ;
        }
        if ([_type isEqualToString:@"1"]) {
            sql1= [NSString stringWithFormat:@"select * from edu"];
        }else{
            sql1= [NSString stringWithFormat:@"select * from workYear"];
        }
        
        FMResultSet *rs = [db executeQuery:sql1];
        while ([rs next]) {
            
            NSString *idString = [rs stringForColumn:@"selfId"];
            NSString *idString1;
            idString1 = [rs stringForColumn:@"selfId1"];
            if (!idString) {
                idString = @"";
            }
            if (!idString1) {
                idString1 = @"";
            }
            NSString *name = [rs stringForColumn:@"selfName"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic setObject:idString forKey:@"id"];
            [dic setObject:idString1 forKey:@"id1"];
            [dic setObject:name forKey:@"name"];
            [resulArr addObject:dic];
            
            
        }
        [db close];
    }
    // Do any additional setup after loading the view from its nib.
}

+(NSString *)getEduNameWith:(NSString *)eduId
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path lastObject];
    NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dataBase open]) {
        NSLog(@"Could not open db.");
        return @"";
    }
    NSString *sql1= [NSString stringWithFormat:@"select * from edu where selfId='%@'",eduId];
    FMResultSet *rs = [dataBase executeQuery:sql1];
    NSString *eduName;
    while ([rs next])
    {
        eduName = [rs stringForColumn:@"selfName"];
        break;
    }
    [dataBase close];
    return eduName.length > 0 ? eduName:@"";
}

+(NSString *)getWorkAgeNameWithStart:(NSString *)workStart end:(NSString *)workEnd
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path lastObject];
    NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dataBase open]) {
        NSLog(@"Could not open db.");
        return @"";
    }
    NSString *sql1= [NSString stringWithFormat:@"select * from workYear where selfId='%@' and selfId1='%@'",workStart,workEnd];
    FMResultSet *rs = [dataBase executeQuery:sql1];
    NSString *eduName;
    while ([rs next])
    {
        eduName = [rs stringForColumn:@"selfName"];
        break;
    }
    [dataBase close];
    return eduName.length > 0 ? eduName:@"";
}

-(NSString *)databasePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path lastObject];
    NSLog(@"reurl = %@",[pathname stringByAppendingPathComponent:@"data.db"]);
    return [pathname stringByAppendingPathComponent:@"data.db"];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    incompanyId = dataModal;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([resulArr count]!=0) {
        return [resulArr count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ZWConditionCell";
    ZWConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ZWConditionCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([_type isEqualToString:@"2"]) {
        [cell.titleLb setText:resulArr[indexPath.row]];
    }else{
        NSDictionary *dic = resulArr[indexPath.row];
        [cell.titleLb setText:dic[@"name"]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    if ([_type isEqualToString:@"1"]) {
        NSDictionary *dic = resulArr[indexPath.row];
        _inzwmodel.edu = dic[@"name"];
        _inzwmodel.eduId = dic[@"id"];
    }else if([_type isEqualToString:@"2"]){
        _inzwmodel.salary = resulArr[indexPath.row];
    }else{
        NSDictionary *dic = resulArr[indexPath.row];
        _inzwmodel.gznum = dic[@"name"];
        _inzwmodel.gznumId = dic[@"id"];
        _inzwmodel.gznumId1 = dic[@"id1"];
    }
    if (_block) {
        _block();
    }
    [self.navigationController popViewControllerAnimated:YES];
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
