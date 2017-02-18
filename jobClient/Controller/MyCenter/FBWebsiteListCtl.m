//
//  FBWebsiteListCtl.m
//  jobClient
//
//  Created by 一览ios on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "FBWebsiteListCtl.h"
#import "ZWConditionCell.h"
#import "ExRequetCon.h"

@interface FBWebsiteListCtl ()
{
    NSString    *incompanyId;
    NSMutableArray *dataSourceArr;
}
@end

@implementation FBWebsiteListCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"1"]) {
//        self.navigationItem.title = @"选择发布部门";
        [self setNavTitle:@"选择发布部门"];
    }else{
//        self.navigationItem.title = @"选择发布网站";
        [self setNavTitle:@"选择发布网站"];
    }
    dataSourceArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
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

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getZWFBInfoWithCompanyId:incompanyId];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getZWFBInfoWithCompanyId:
        {
            if ([_type isEqualToString:@"1"]) {//部门
                if ([dataArr count]!= 0) {
                    NSDictionary *dic = [dataArr firstObject];
                    NSArray *dataArr = dic[@"deptArr"];
                    for (NSDictionary *dataDic in dataArr) {
                        [dataSourceArr addObject:dataDic];
                    }
                }
            }else{
                if ([dataArr count]!= 0) {
                    NSDictionary *dic = [dataArr firstObject];
                    NSArray *dataArr = dic[@"tradeArr"];
                    for (NSDictionary *dataDic in dataArr) {
                        [dataSourceArr addObject:dataDic];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)refreshLoad:(RequestCon *)con
{
    [dataSourceArr removeAllObjects];
    [super refreshLoad:con];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataSourceArr count]!=0) {
        return [dataSourceArr count];
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
    NSDictionary *dic = dataSourceArr[indexPath.row];
    if ([_type isEqualToString:@"1"]) {
        [cell.titleLb setText:dic[@"deptName"]];
    }else{
        [cell.titleLb setText:dic[@"homename"]];
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
    NSDictionary *dic = dataSourceArr[indexPath.row];
    
    if ([_type isEqualToString:@"1"]) {
        _inzwmodel.deptId = dic[@"deptId"];
        _inzwmodel.deptName = dic[@"deptName"];
    }else if([_type isEqualToString:@"2"]){
        
    }else{
        _inzwmodel.zp_urlId = dic[@"zp_urlId"];
        _inzwmodel.zp_urlName = dic[@"homename"];
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
