//
//  DataSelectedCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-2.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "DataSelectedCtl.h"
#import "DataSelectedCell.h"

@interface DataSelectedCtl ()

@end

@implementation DataSelectedCtl
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = NO;
        bHeaderEgo_ = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择发布日期";
    [self setNavTitle:@"选择发布日期"];
    dataArray_ = [[NSArray alloc]initWithObjects:@"所有日期",@"近一天",@"近两天",@"近一周",@"近两周",@"近一月",@"近六周",@"近两月", nil];
    dataValueArray_ = [[NSArray alloc] initWithObjects:@"",@"1",@"2",@"7",@"14",@"30",@"42",@"60", nil];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataArray_ count] !=0) {
        return  [dataArray_ count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DataSelectedCell";
    
    DataSelectedCell *cell = (DataSelectedCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DataSelectedCell" owner:self options:nil] lastObject];
    }
    NSString *timeStr = [dataArray_ objectAtIndex:indexPath.row];
    [cell.titleLb_ setFont:FIFTEENFONT_TITLE];
    [cell.titleLb_ setTextColor:BLACKCOLOR];
    [cell.titleLb_ setText:timeStr];
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithObjects:[dataArray_ objectAtIndex:indexPath.row],[dataValueArray_ objectAtIndex:indexPath.row], nil];
    [delegate_ sendDataSelected:dataArr];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
