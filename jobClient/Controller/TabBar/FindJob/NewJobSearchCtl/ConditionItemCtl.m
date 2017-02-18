//
//  ConditionItemCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ConditionItemCtl.h"
#import "DataSelectedCell.h"

@interface ConditionItemCtl ()
@end

@implementation ConditionItemCtl
@synthesize conditionType_,delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        bHeaderEgo_ = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    switch (conditionType_) {
        case condition_WorkAge:

            [self setNavTitle:@"选择工作年限"];
            break;
        case condition_Time:

            [self setNavTitle:@"选择发布日期"];
            break;
        case condition_Edu:

            [self setNavTitle:@"选择学历"];
            break;
        case condition_PayMent:

            [self setNavTitle:@"选择月薪范围"];
            break;
        case condition_WorkType:

            [self setNavTitle:@"选择工作类型"];
            break;
        default:

            [self setNavTitle:@"选择"];
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inDataArray_ = [[dataModal objectAtIndex:0] mutableCopy];
    inValueArray_ = [[dataModal objectAtIndex:1]mutableCopy];
    if([dataModal count] > 2)
    {
        inValueArray_1 = [[dataModal objectAtIndex:2]mutableCopy];
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([inDataArray_ count] !=0) {
        return  [inDataArray_ count];
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
    NSString *timeStr = [inDataArray_ objectAtIndex:indexPath.row];
    [cell.titleLb_ setFont:FIFTEENFONT_TITLE];
    if ([_idStr isEqualToString:timeStr]) {
        [cell.titleLb_ setTextColor:UIColorFromRGB(0xe13e3e)];
    }
    else{
        [cell.titleLb_ setTextColor:BLACKCOLOR];
    }
    [cell.titleLb_ setText:timeStr];
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NSString *conditionName = [inDataArray_ objectAtIndex:indexPath.row];
    
    NSString *coditionValue = [inValueArray_ objectAtIndex:indexPath.row];
    NSString *coditionValue1 = [inValueArray_1 objectAtIndex:indexPath.row];
    
    [delegate_ conditionSeletedOK:conditionType_ conditionName:conditionName conditionValue:coditionValue conditionValue1:coditionValue1];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
