//
//  NearJobSearchCtl.m
//  jobClient
//
//  Created by YL1001 on 15/6/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "NearJobSearchCtl.h"
#import "JobSearchTableViewCell.h"
#import "CustomButton.h"

@interface NearJobSearchCtl ()
{
    NSMutableArray *cellArray;
}
@end

@implementation NearJobSearchCtl

- (id)init
{
    self = [super init];
    if (self)
    {
        bHeaderEgo_ = NO;
        bFooterEgo_ = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"职位";
    [self setNavTitle:@"职位"];
    
    searchBar_.delegate = self;
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);

    if ([searchBar_ respondsToSelector:@selector(barTintColor)])
    {
            [[[[searchBar_.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [searchBar_ setBackgroundColor:[UIColor clearColor]];
       
    }
   
    tableView_.delegate = self;
    tableView_.dataSource = self;
    
    cellArray = [[NSMutableArray alloc] init];
    
    searchHistoryArray_ = [[NSMutableArray alloc]init];
    searchHistoryArray_ = [self loadDataInDataBase:[Manager getUserInfo].userId_];
    [clearBtn_.titleLabel setTextColor:BLACKCOLOR];
    
    [tableView_ reloadData];
}

- (void)getDataFunction:(RequestCon *)con
{
    
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inSearchParam_ = dataModal;
    [searchBar_ setText:inSearchParam_.searchKeywords_];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    
    if ([searchHistoryArray_ count] !=0) {
        [clearBtn_ setTitle:@"[清空历史记录]" forState:UIControlStateNormal];
        [clearBtn_ setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [clearBtn_ setTitle:@"暂无历史搜索记录" forState:UIControlStateNormal];
        [clearBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)btnResponse:(id)sender
{
   if (sender == clearBtn_){
        if (!db_) {
            db_ = [[DBTools alloc]init];
        }
        [db_ deleteNearJobSearchData:[Manager getUserInfo].userId_];
        [clearBtn_ setTitle:@"暂无历史搜索记录" forState:UIControlStateNormal];
        [clearBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [searchHistoryArray_ removeAllObjects];
        [tableView_ reloadData];
    }
}

#pragma mark-  UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([searchHistoryArray_  count] != 0 && [searchHistoryArray_  count] <= 5) {
        return [searchHistoryArray_  count];
    }else if([searchHistoryArray_  count] >5){
        return 5;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobSearchTableViewCell";
    JobSearchTableViewCell *cell = (JobSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JobSearchTableViewCell" owner:self options:nil] lastObject];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.deleteBtn.hidden = NO;
    [cell.deleteBtn addTarget:self action:@selector(deleteRecord:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.clickState = 1;
    cell.deleteBtn.tag = 100 + indexPath.row;
    
    SearchParam_DataModal *dataModal = [searchHistoryArray_ objectAtIndex:indexPath.row];
    cell.conditionLb.text = dataModal.searchKeywords_;
    
    [cellArray addObject:cell];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if ([searchBar_ isFirstResponder]) {
        [searchBar_ resignFirstResponder];
    }
    SearchParam_DataModal *dataModal = [searchHistoryArray_ objectAtIndex:indexPath.row];
    inSearchParam_.searchKeywords_ = dataModal.searchKeywords_;
    if (self.nearsearchBlock) {
        self.nearsearchBlock(inSearchParam_, YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if ([searchBar_ isFirstResponder]) {
        [searchBar_ resignFirstResponder];
    }
}

- (void)deleteRecord:(CustomButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    SearchParam_DataModal *zwName = [searchHistoryArray_ objectAtIndex:index];
    
    for (NSInteger i = 0; i < cellArray.count; i++)
    {
        JobSearchTableViewCell *cell = [cellArray objectAtIndex:i];
        if (cell.deleteBtn.tag != sender.tag)
        {
            [cell.deleteBtn setImage:[UIImage imageNamed:@"icon_delete_gray.png"] forState:UIControlStateNormal];
        }
    }
    
    switch (sender.clickState)
    {
        case 1:
        {
            [sender setImage:[UIImage imageNamed:@"icon_delete_red.png"] forState:UIControlStateNormal];
            sender.clickState = 2;
        }
            break;
        case 2:
        {
            if (!db_) {
                db_ = [[DBTools alloc]init];
            }
            [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:zwName.searchKeywords_ tradeStr:nil];
            sender.clickState = 1;
            [searchHistoryArray_ removeObjectAtIndex:index];
            [cellArray removeObjectAtIndex:index];
            if (cellArray.count == 0) {
                [clearBtn_ setTitle:@"暂无历史搜索记录" forState:UIControlStateNormal];
                [clearBtn_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [tableView_ reloadData];
        }
        default:
            break;
    }
    
}


-(NSMutableArray *)loadDataInDataBase:(NSString *)personId
{
    if (!db_) {
        db_ = [[DBTools alloc]init];
    }
    return [db_ inquireFornearJobSearch:[Manager getUserInfo].userId_];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [searchBar_ becomeFirstResponder];
//    self.navigationItem.title = @"职位";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UISearchBar 代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    inSearchParam_.searchKeywords_ = searchBar_.text;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    inSearchParam_.searchKeywords_ = searchBar_.text;
    [searchBar_ resignFirstResponder];
    self.nearsearchBlock(inSearchParam_,YES);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
