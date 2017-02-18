//
//  XJHDateChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-4-24.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "XJHDateChangeCtl.h"
#import "XJHChangeCellTableViewCell.h"

@interface XJHDateChangeCtl () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrDataName;
    NSMutableArray *arrDataId;
}
@end

@implementation XJHDateChangeCtl

-(id)init
{
    self = [super init];
    bHeaderEgo_ = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrDataId = [[NSMutableArray alloc] initWithArray:@[@"",@"1",@"3",@"7",@"14",@"30",@"60"]];
    arrDataName = [[NSMutableArray alloc] initWithArray:@[@"所有日期",@"今天",@"近三天",@"近一周",@"近两周",@"近一月",@"近两月"]];
//    self.navigationItem.title = @"日期选择";
    [self setNavTitle:@"日期选择"];
    [tableView_ reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XJHChangeCellTableViewCell";
    XJHChangeCellTableViewCell *cell = (XJHChangeCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XJHChangeCellTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.titleLable.text = arrDataName[indexPath.row];
    
    if ([arrDataName[indexPath.row] isEqualToString:_currentTime])
    {
        cell.titleLable.textColor = REDCOLOR;
    }
    else
    {
        cell.titleLable.textColor = BLACKCOLOR;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDataName.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    [_timeDelegate changeCurrentTimeType:arrDataName[indexPath.row] timeId:arrDataId[indexPath.row]];
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
