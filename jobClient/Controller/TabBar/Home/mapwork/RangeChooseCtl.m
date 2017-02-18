//
//  RangeChooseCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-14.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RangeChooseCtl.h"
#import "RangeChooseCtlCell.h"
#import "RangeDataMocel.h"

@interface RangeChooseCtl ()

@end

@implementation RangeChooseCtl
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        bFooterEgo_ = NO;
        bHeaderEgo_ = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"定位范围";
    [self setNavTitle:@"定位范围"];
    rangeArray_ =[[NSMutableArray alloc]init];
    tableView_.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0];
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    for (int i=0; i<5; i++) {
        RangeDataMocel *model = [[RangeDataMocel alloc]init];
        switch (i) {
            case 0:
            {
                model.rangeKey_ = @"3公里内";
                model.rangeValue_ = @"3";
            }
                break;
            case 1:
            {
                model.rangeKey_ = @"5公里内";
                model.rangeValue_ = @"5";
            }
                break;
            case 2:
            {
                model.rangeKey_ = @"10公里内";
                model.rangeValue_ = @"10";
            }
                break;
            case 3:
            {
                model.rangeKey_ = @"20公里内";
                model.rangeValue_ = @"20";
            }
                break;
            case 4:
            {
                model.rangeKey_ = @"30公里内";
                model.rangeValue_ = @"30";
            }
                break;
            default:
                break;
        }
        [rangeArray_ addObject:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([rangeArray_ count] !=0) {
        return [rangeArray_ count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RangeChooseCtlCell";
    RangeChooseCtlCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RangeChooseCtlCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    RangeDataMocel *model = [rangeArray_ objectAtIndex:indexPath.row];
    [cell.titleLb_ setTextColor:BLACKCOLOR];
    [cell.titleLb_ setFont:FIFTEENFONT_TITLE];
    [cell.titleLb_ setText:model.rangeKey_];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RangeDataMocel *model = [rangeArray_ objectAtIndex:indexPath.row];
    [delegate_ rangeChoose:model];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
