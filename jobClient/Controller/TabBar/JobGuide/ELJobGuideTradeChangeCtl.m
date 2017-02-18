//
//  ELJobGuideTradeChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELJobGuideTradeChangeCtl.h"
#import "PositionCell.h"
#import "personTagModel.h"

@interface ELJobGuideTradeChangeCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView1;
    UITableView *_tableView2;
    NSMutableArray *rightDataArr;
    NSMutableArray *leftDataArr;
    NSMutableArray *tradeAllData;
    
    CondictionList_DataModal *selectModalOne;
    CondictionList_DataModal *selectModalTwo;
}
@end

@implementation ELJobGuideTradeChangeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    leftDataArr = [[NSMutableArray alloc]init];
    rightDataArr = [[NSMutableArray alloc] init];
    
    if (_showAllChange) {
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.str_ = @"全部";
        modal.id_ = @"";
        [leftDataArr addObject:modal];
    }
    
    [self setNavTitle:@"行业分类"];
    
    if(!tradeAllData)
    {
        tradeAllData = [[NSMutableArray alloc] initWithArray:[CondictionTradeCtl loadDataFromFile]];
    }
    
    CondictionList_DataModal *model1 = _selectChangeModal;
    
    for (CondictionList_DataModal *modal in tradeAllData)
    {
        if(modal.bParent_ )
        {
            [leftDataArr addObject:modal];
        }
    }
    CGFloat seletIndex = 0;
    if (model1)
    {
        if (model1.bParent_)
        {
            selectModalOne = model1;
            for (NSInteger i = 0;i<leftDataArr.count;i++)
            {
                CondictionList_DataModal *modal2 = leftDataArr[i];
                if ([model1.id_ isEqualToString:modal2.id_])
                {
                    seletIndex = i;
                    break;
                }
            }
        }
        else
        {
            selectModalTwo = model1;
            for (NSInteger i = 0;i<leftDataArr.count;i++)
            {
                CondictionList_DataModal *modal2 = leftDataArr[i];
                if ([model1.pId_ isEqualToString:modal2.id_])
                {
                    selectModalOne = modal2;
                    seletIndex = i;
                    break;
                }
            }
        }
    }else{
        selectModalOne = leftDataArr[0];
    }
    CondictionList_DataModal *modal4 = selectModalOne;
    for (CondictionList_DataModal *modal3 in tradeAllData)
    {
        if ([modal3.pId_ isEqualToString:modal4.id_] && !modal3.bParent_)
        {
            [rightDataArr addObject:modal3];
        }
    }
    
    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, ScreenHeight-64) style:UITableViewStylePlain];
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(_tableView1.right, 0, ScreenWidth/2, ScreenHeight-64) style:UITableViewStylePlain];
    
    _tableView1.delegate = self;
    _tableView2.delegate = self;
    _tableView1.dataSource = self;
    _tableView2.dataSource = self;
    
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView2.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView1];
    [self.view addSubview:_tableView2];
    
    [_tableView1 reloadData];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:seletIndex inSection:0];
    [_tableView1 selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    CGRect frame = [_tableView1 rectForRowAtIndexPath:selectedIndexPath];
    CGFloat maxY = _tableView1.contentSize.height - _tableView1.frame.size.height;
    if (frame.origin.y < maxY) {
        maxY = frame.origin.y;
    }
    [_tableView1 setContentOffset:CGPointMake(0,maxY)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView1) {
        return leftDataArr.count;
    }else if(tableView == _tableView2){
        return rightDataArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1) {
        static NSString *reuseIdentifier = @"PositionCell";
        PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PositionCell" owner:self options:nil][0];
            cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            
            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xffffff);
        }
        CondictionList_DataModal *model = leftDataArr[indexPath.row];
        [cell.titleLb setText:model.str_];
        return cell;
    }else{
        static NSString *reuseIdentifier = @"PositionCell";
        PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PositionCell" owner:self options:nil][0];
            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            cell.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        }
        CondictionList_DataModal *model = rightDataArr[indexPath.row];
        [cell.titleLb setText:model.str_];
        if ([model.str_ isEqualToString:selectModalTwo.str_]) {
            [cell.titleLb setTextColor:UIColorFromRGB(0xe13e3e)];
            cell.selectedImg.hidden = NO;
        }else{
            [cell.titleLb setTextColor:UIColorFromRGB(0x333333)];
            cell.selectedImg.hidden = YES;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1){
        [rightDataArr removeAllObjects];
        CondictionList_DataModal *modal4 = leftDataArr[indexPath.row];
        if ([modal4.str_ isEqualToString:@"全部"]) {
            if ([_tradeDelegate respondsToSelector:@selector(tradeChangeWithArr:)]) {
                [_tradeDelegate tradeChangeWithArr:modal4];
                [self.navigationController popViewControllerAnimated:YES];
            }
            return;
        }
        for (CondictionList_DataModal *modal3 in tradeAllData)
        {
            if ([modal3.pId_ isEqualToString:modal4.id_] && !modal3.bParent_)
            {
                [rightDataArr addObject:modal3];
            }
        }
        selectModalOne = modal4;
        [_tableView2 reloadData];
    }else if(tableView == _tableView2){
        CondictionList_DataModal *modal4 = rightDataArr[indexPath.row];
        modal4.pName = selectModalOne.str_;
        if ([_tradeDelegate respondsToSelector:@selector(tradeChangeWithArr:)]) {
            [_tradeDelegate tradeChangeWithArr:modal4];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
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
