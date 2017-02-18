//
//  ELCountryICtl.m
//  jobClient
//
//  Created by 一览ios on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCountryICtl.h"

@interface ELCountryICtl ()
{
    NSArray *dataArr;
}
@end

@implementation ELCountryICtl

- (void)viewDidLoad {
    
//    self.navigationItem.title = @"国籍选择";
    [self setNavTitle:@"国籍选择"];
    
    self.headerRefreshFlag = NO;    //是否有需要下拉刷新
    self.footerRefreshFlag = NO;    //是否有需要上拉加载更多
    self.showNoDataViewFlag = NO;    //显示没有数据的view
    self.showNoMoreDataViewFlag = NO;    //显示没有数据的view

    self.noRefershLoadData = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //国籍
    dataArr = @[@"中国",@"美国",@"日本",@"德国",@"法国",@"英国",@"意大利",@"俄罗斯",@"加拿大",@"印度",@"新加坡",@"澳大利亚",@"韩国",@"朝鲜",@"泰国",@"其它"];
    
    [self.tabView reloadData];
}


-(CGFloat )tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = dataArr[indexPath.row];
    [cell.textLabel setTextColor:UIColorFromRGB(0X333333)];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.f];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate countryICtl:dataArr[indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
