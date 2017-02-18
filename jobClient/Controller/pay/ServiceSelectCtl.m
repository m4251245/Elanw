//
//  ServiceSelectCtl.m
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ServiceSelectCtl.h"
#import "OrderService_DataModal.h"

@interface ServiceSelectCtl ()

@end

@implementation ServiceSelectCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bHeaderEgo_ = NO;
    tableView_.bounces = NO;
//    self.navigationItem.title = @"选择套餐";
    [self setNavTitle:@"选择套餐"];
    
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _serviceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    OrderService_DataModal *service = _serviceArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@   %@",service.levelName, service.versionTypeName];
    cell.textLabel.font = FIFTEENFONT_TITLE;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,39,310,1)];
    image.image = [UIImage imageNamed:@"gg_home_line2.png"];
    [cell.contentView addSubview:image];
    
    return cell;
}

#pragma mark 选择左侧热门标签
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderService_DataModal *service = _serviceArr[indexPath.row];
    if ([_delegate respondsToSelector:@selector(refreshService:)]) {
        [_delegate refreshService:service];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
