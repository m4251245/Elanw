//
//  ProfessionChildCtl.m
//  jobClient
//
//  Created by 一览ios on 15/4/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//更多热门专业

#import "MoreMajorListCtl.h"
#import "Profession_Cell.h"
#import "SalaryFutureListCtl.h"
#import "HotJob_DataModel.h"
#import "ProfessionList_Cell.h"

@interface MoreMajorListCtl ()<UITableViewDataSource, UITableViewDelegate>
{
    id _inModel;
    NSMutableArray *_majorArray;
}
@end

@implementation MoreMajorListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"更多热门专业";
    [self setNavTitle:@"更多热门专业"];
    bFooterEgo_ = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getMoreHotIndustry];
}


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type){
        case Request_getMoreHotIndustry://专业列表
        {
            
            
        }
            break;
        default:
            break;
    }
}



- (void)getHotMajorByDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [Common getSandBoxPath:@"data.db"];
    if( ![fileManager fileExistsAtPath:filePath] ){
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"data.db"]];
        [data writeToFile:[Common getSandBoxPath:@"data.db"] atomically:YES];
    }
    
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    NSString *sqlStr = @"select selfName from zyname where _id != 48";
    _majorArray = [NSMutableArray arrayWithCapacity:47];
    if ([database open])
    {
        @try {
            FMResultSet *set = [database executeQuery:sqlStr];
            while ([set next]) {
                NSString * majorName = [set stringForColumn:@"selfName"];
                [_majorArray addObject:majorName];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            [database close];
        }
        
//        if (_majorArray.count) {
//            [_collectionView reloadData];
//        }
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return requestCon_.dataArr_.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ProfessionList_Cell";
    ProfessionList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ProfessionList_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect frame = cell.titleLb.frame;
        frame.origin.x = 12;
        cell.titleLb.frame = frame;
    }
    HotJob_DataModel *jobModel = requestCon_.dataArr_[indexPath.row];
    cell.titleLb.text = jobModel.jobName;
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    HotJob_DataModel *hotJob = (HotJob_DataModel *)selectData;
    NSInteger count = self.navigationController.childViewControllers.count;
    SalaryFutureListCtl *ctl  =self.navigationController.childViewControllers[count-2];
    if ([ctl isKindOfClass:[SalaryFutureListCtl class]]) {
        ctl.majorTF.text = hotJob.jobName;
        [self.navigationController popViewControllerAnimated:NO];
        [ctl pushSearchCtl];
    }
}



@end
