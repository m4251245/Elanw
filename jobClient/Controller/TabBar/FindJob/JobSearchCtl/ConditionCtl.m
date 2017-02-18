//
//  ConditionCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ConditionCtl.h"
#import "ConditionCtlCell.h"
#import "ConditionDataModel.h"
#import "ConditionItemCtl.h"

@interface ConditionCtl ()

@end

@implementation ConditionCtl
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
        rightNavBarStr_ = @"完成";
    }
    return self;
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"筛选条件";
    [self setNavTitle:@"筛选条件"];
    dataArray_ = [[NSMutableArray alloc]init];
    
    workAgeArray_ = [[NSArray alloc]initWithObjects:@"不限",@"应届毕业生",@"1年内",@"2年及以上",@"3年及以上",@"5年及以上",@"8年及以上",@"10年及以上", nil];
    workAgeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"less1",@"2",@"3",@"5",@"8",@"10", nil];
    
    timeArray_ = [[NSArray alloc]initWithObjects:@"所有日期",@"近一天",@"近两天",@"近一周",@"近两周",@"近一月",@"近六周",@"近两月", nil];
    timeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"1",@"2",@"7",@"14",@"30",@"42",@"60", nil];
    
    eduArray_ = [[NSArray alloc]initWithObjects:@"不限",@"大专以下",@"大专",@"本科",@"硕士",@"MBA",@"博士",@"博士后" ,nil];
    eduValueArray_ = [[NSArray alloc]initWithObjects:@"0",@"lt||30",@"50",@"60",@"70",@"75",@"80",@"90",nil];
    
    paymentArray_ = [[NSArray alloc]initWithObjects:@"不限",@"面议",@"3000以下",@"3000及以上",@"5000及以上",@"7000及以上",@"10000及以上",nil];
    paymentValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"lt||3000",@"gte||3000",@"gte||5000",@"gte||7000",@"gte||10000",nil];
    
    workTypeArray_ = [[NSArray alloc]initWithObjects:@"不限",@"全职",@"兼职",@"临时",@"实习", nil];
    workTypeVauleArray_ = [[NSArray alloc]initWithObjects:@"",@"全职",@"兼职",@"临时",@"实习", nil];
    
    for (int i=0; i<5; i++) {
        ConditionDataModel *model = [[ConditionDataModel alloc]init];
        switch (i) {
            case 0:
                model.typeName_ = @"工作年限";
                if ([inSearchParam_.workAgeValue_ isEqualToString:@""] || !inSearchParam_.workAgeValue_) {
                   model.itemName_ = @"不限";
                }else{
                    NSInteger index = [workAgeValueArray_ indexOfObject:inSearchParam_.workAgeValue_];
                    model.itemName_ = [workAgeArray_ objectAtIndex:index];
                }
                
                break;
            case 1:
                model.typeName_ = @"发布日期";
                if ([inSearchParam_.timeStr_ isEqualToString:@""] || !inSearchParam_.timeStr_) {
                    model.itemName_ = @"所有日期";
                }else{
                    NSInteger index = [timeValueArray_ indexOfObject:inSearchParam_.timeStr_];
                    model.itemName_ = [timeArray_ objectAtIndex:index];
                }
                break;
            case 2:
                model.typeName_ = @"学历要求";
                if ([inSearchParam_.eduId_ isEqualToString:@""] || !inSearchParam_.eduId_) {
                    model.itemName_ = @"不限";
                }else{
                    NSInteger index = [eduValueArray_ indexOfObject:inSearchParam_.eduId_];
                    model.itemName_ = [eduArray_ objectAtIndex:index];
                }
                break;
            case 3:
                model.typeName_ = @"月薪范围";
                if ([inSearchParam_.payMentValue_ isEqualToString:@""] || inSearchParam_.payMentValue_) {
                    model.itemName_ = @"不限";
                }else{
                    NSInteger index = [paymentValueArray_ indexOfObject:inSearchParam_.payMentValue_];
                    model.itemName_ = [paymentArray_ objectAtIndex:index];
                }
                break;
            case 4:
                model.typeName_ = @"工作性质";
                if ([inSearchParam_.workTypeValue_ isEqualToString:@""] || inSearchParam_.workTypeValue_) {
                    model.itemName_ = @"不限";
                }else{
                    NSInteger index = [workTypeVauleArray_ indexOfObject:inSearchParam_.workTypeValue_];
                    model.itemName_ = [workTypeArray_ objectAtIndex:index];
                }
                break;
            default:
                break;
        }
        if (i != 3) {
            [dataArray_ addObject:model];
        }
        
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inSearchParam_ = dataModal;
}


- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
}


- (void)rightBarBtnResponse:(id)sender
{
    [delegate_ conditionSelectedOK:inSearchParam_];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 筛选条件代理

- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1
{
    ConditionDataModel *model = [dataArray_ objectAtIndex:type];
    model.itemName_ = conditionName;
    switch (type) {
        case condition_WorkAge:
            inSearchParam_.workAgeValue_ = conditionValue;
            inSearchParam_.workAgeName_ = conditionName;
            break;
        case condition_Edu:
            inSearchParam_.eduId_ = conditionValue;
            inSearchParam_.eduName_ = conditionName;
            break;
        case condition_Time:
            inSearchParam_.timeStr_ = conditionValue;
            inSearchParam_.timeName_ = conditionName;
            break;
        case condition_PayMent:
            inSearchParam_.payMentValue_ = conditionValue;
            inSearchParam_.payMentName_ = conditionName;
            break;
        case condition_WorkType:
            inSearchParam_.workTypeValue_ = conditionValue;
            inSearchParam_.workTypeName_ = conditionName;
            break;
        default:
            break;
    }
    [tableView_ reloadData];
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
    static NSString *CellIdentifier = @"ConditionCtlCell";
    
    ConditionCtlCell *cell = (ConditionCtlCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConditionCtlCell" owner:self options:nil] lastObject];
    }
    ConditionDataModel *model = [dataArray_ objectAtIndex:indexPath.row];
    [cell.typeLb_ setFont:FIFTEENFONT_TITLE];
    [cell.typeLb_ setTextColor:BLACKCOLOR];
    [cell.typeLb_ setText:model.typeName_];
    
    [cell.itemsLb_ setFont:FOURTEENFONT_CONTENT];
    [cell.itemsLb_ setTextColor:LIGHTGRAYCOLOR];
    [cell.itemsLb_ setText:model.itemName_];
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{

    ConditionItemCtl *conditionItemCtl_ = [[ConditionItemCtl alloc]init];
    conditionItemCtl_.delegate_ = self;
    switch (indexPath.row) {
        case 0:
        {
            NSArray *tempArray = [[NSArray alloc]initWithObjects:workAgeArray_,workAgeValueArray_, nil];
            [conditionItemCtl_ beginLoad:tempArray exParam:nil];
            [conditionItemCtl_ setConditionType_:condition_WorkAge];
        }
            break;
        case 1:
        {
            NSArray *tempArray = [[NSArray alloc]initWithObjects:timeArray_,timeValueArray_, nil];
            [conditionItemCtl_ beginLoad:tempArray exParam:nil];
            [conditionItemCtl_ setConditionType_:condition_Time];
        }
            break;
        case 2:
        {
            NSArray *tempArray = [[NSArray alloc]initWithObjects:eduArray_,eduValueArray_, nil];
            [conditionItemCtl_ beginLoad:tempArray exParam:nil];
            [conditionItemCtl_ setConditionType_:condition_Edu];
        }
            break;
        case 3:
        {
            NSArray *tempArray = [[NSArray alloc]initWithObjects:workTypeArray_,workTypeVauleArray_, nil];
            [conditionItemCtl_ beginLoad:tempArray exParam:nil];
            [conditionItemCtl_ setConditionType_:condition_WorkType];
        }
            break;
        case 4:
        {
//            NSArray *tempArray = [[NSArray alloc]initWithObjects:paymentArray_,paymentValueArray_, nil];
//            [conditionItemCtl_ beginLoad:tempArray exParam:nil];
//            [conditionItemCtl_ setConditionType_:condition_PayMent];
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:conditionItemCtl_ animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
