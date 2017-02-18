//
//  WorkingAgeCtl.m
//  Association
//
//  Created by 一览iOS on 14-5-27.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "WorkingAgeCtl.h"

@interface WorkingAgeCtl ()

@end

@implementation WorkingAgeCtl
@synthesize delegate_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"选择工作年限";
    [self setNavTitle:@"选择工作年限"];
    // Do any additional setup after loading the view from its nib.
    workingAgeTableView_.delegate = self;
    workingAgeTableView_.dataSource = self;
    
    dataArray_ = [[NSMutableArray alloc]initWithObjects:@"不限",@"一年以上",@"二年以上",@"三年以上",@"四年以上",@"五年以上",@"六年以上",@"七年以上",@"八年以上",@"九年以上",@"十年以上", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString *yearStr = [dataArray_ objectAtIndex:indexPath.row];
    [cell.textLabel setText:yearStr];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0]];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *yearStr = [dataArray_ objectAtIndex:indexPath.row];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"FreshSalaryGetWorkingAge" object:yearStr];
    NSString * gznum = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [delegate_ chooseGZNum:yearStr gznum:gznum];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
