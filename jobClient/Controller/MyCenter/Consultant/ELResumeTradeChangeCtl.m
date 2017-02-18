//
//  ELResumeTradeChangeCtl.m
//  
//
//  Created by 一览iOS on 15/11/9.
//
//

#import "ELResumeTradeChangeCtl.h"

@interface ELResumeTradeChangeCtl ()
{
    __weak IBOutlet UITableView *tableViewOne;
    NSMutableArray *arrDataOne;
    NSMutableArray *arrAllList;
    
    CondictionList_DataModal *modalOne;
    CondictionList_DataModal *modalTwo;
}
@end

@implementation ELResumeTradeChangeCtl


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        bFooterEgo_ = NO;
        bHeaderEgo_ = NO;
        rightNavBarStr_ = @"确定";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"行业选择"];
    arrDataOne = [[NSMutableArray alloc] init];
    arrAllList = [[NSMutableArray alloc] initWithArray:[CondictionTradeCtl loadDataFromFile]];
    
    if (_selectedVO.pId_.length > 0 || _selectedVO.bParent_) {
        modalTwo = _selectedVO;
    }
    else{
        modalOne = _selectedVO;
    }

//    tableViewOne.delegate = self;
//    tableViewOne.dataSource = self;
    tableViewOne.hidden = YES;
    [tableView_ reloadData];
}

-(void)rightBarBtnResponse:(id)sender
{
    if (modalTwo || modalOne) {
        [_changeDelegate tradeChangeDelegateModa:modalTwo?modalTwo:modalOne];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10,10,(ScreenWidth/2.0)-20,20)];
        lable.tag = 100;
        lable.font = FIFTEENFONT_TITLE;
        [cell.contentView addSubview:lable];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(-10,39,(ScreenWidth/2.0)+10,1)];
        image.image = [UIImage imageNamed:@"gg_home_line2"];
        [cell.contentView addSubview:image];
        
        UIImageView *imageOne = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/2.0)-10,15,6,9)];
        imageOne.tag = 200;
        imageOne.image = [UIImage imageNamed:@"rightarrow"];
        [cell.contentView addSubview:imageOne];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CondictionList_DataModal *modal;
    if (tableView == tableView_)
    {
        modal = _arrDataList[indexPath.row];
    }
    else
    {
        modal = arrDataOne[indexPath.row];
    }
    UILabel *lable = (UILabel *)[cell.contentView viewWithTag:100];
    lable.text = modal.str_;
    
    if (tableView == tableView_ && [modal.id_ isEqualToString:modalOne.id_] && modal.isTotalTrade == modalOne.isTotalTrade)
    {
        lable.textColor = FONEREDCOLOR;
    }
    else if (tableView == tableViewOne && [modal.id_ isEqualToString:modalTwo.id_] && modal.isTotalTrade == modalTwo.isTotalTrade)
    {
        lable.textColor = FONEREDCOLOR;
    }
    else
    {
        lable.textColor = [UIColor blackColor];
    }
    
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:200];
    
    if (modal.isTotalTrade && tableView == tableView_) {
        image.hidden = NO;
    }
    else
    {
        image.hidden = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableViewOne) {
        return arrDataOne.count;
    }
    return _arrDataList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView_)
    {
        tableViewOne.hidden = YES;
        CondictionList_DataModal *modal = _arrDataList[indexPath.row];
        modalOne = modal;
        modalTwo = nil;
        [tableView_ reloadData];
        if (modal.isTotalTrade)
        {
            [arrDataOne removeAllObjects];
            for ( CondictionList_DataModal *dataModal in arrAllList )
            {
                if(([dataModal.pId_ isEqualToString:modal.id_] && !dataModal.bParent_) || [dataModal.id_ isEqualToString:modal.id_])
                {
                    [arrDataOne addObject:dataModal];
                }
            }
            tableViewOne.hidden = NO;
            [tableViewOne reloadData];
            return;
        }
    }
    else
    {
        modalTwo = arrDataOne[indexPath.row];
        [tableViewOne reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
