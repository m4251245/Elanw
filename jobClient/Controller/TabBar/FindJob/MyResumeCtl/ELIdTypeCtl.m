//
//  ELIdTypeCtl.m
//  jobClient
//
//  Created by 一览ios on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELIdTypeCtl.h"

@interface ELIdTypeCtl ()
{
    NSArray *dataArr;
    NSDictionary *dic;

}
@end

@implementation ELIdTypeCtl

- (void)viewDidLoad {
    
//    self.navigationItem.title = @"证件类型选择";
    [self setNavTitle:@"证件类型选择"];
    self.headerRefreshFlag = NO;    //是否有需要下拉刷新
    self.footerRefreshFlag = NO;    //是否有需要上拉加载更多
    self.showNoDataViewFlag = NO;    //显示没有数据的view
    self.showNoMoreDataViewFlag = NO;    //显示没有数据的view
    
    self.noRefershLoadData = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //证件类型
    dataArr = @[@"大陆身份证",@"香港身份证",@"澳门身份证",@"台湾身份证",@"台胞证",@"国外证件"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorColor = UIColorFromRGB(0xecedec);
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *idStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
    }
    
    cell.textLabel.text = dataArr[indexPath.row];
    [cell.textLabel setTextColor:UIColorFromRGB(0X333333)];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate idTypeCtl:dataArr[indexPath.row]];  
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
