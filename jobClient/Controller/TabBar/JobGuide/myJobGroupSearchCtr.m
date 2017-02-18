//
//  myJobGroupSearchCtr.m
//  jobClient
//
//  Created by 一览iOS on 15-1-21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "myJobGroupSearchCtr.h"
#import "AnswerDetailCtl.h"
#import "NoLoginPromptCtl.h"
#import "MyJobGuideCtl_Cell.h"
#import "MyJobGuide_RewardCell.h"
#import "JobGuideQuizModal.h"
#import "ELAnswerListCell.h"

@interface myJobGroupSearchCtr () <UISearchBarDelegate,NoLoginDelegate>

@end

@implementation myJobGroupSearchCtr

-(id) init
{
    self = [super init];
    bFooterEgo_ = YES;
   // validateSeconds_ = 600;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_addQuesbtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xe0e0e0)] forState:UIControlStateHighlighted];
    
    [_searchBar setBackgroundImage:[[UIImage alloc] init]];
    _searchBar.delegate = self;
    _searchBar.tintColor = UIColorFromRGB(0xe13e3e);
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];

    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    
    CGRect frame;
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    maxWidth += 15;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
    
    frame = _searchVIew.frame;
    frame.size.width = ScreenWidth - maxWidth * 2;
    _searchVIew.frame = frame;
    self.navigationItem.titleView = _searchVIew;
    
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"ELAnswerListCell" bundle:nil] forCellReuseIdentifier:@"ELAnswerListCell"];
    
    if (_keyWord && ![_keyWord isEqualToString:@""]) {
        _searchBar.text = [MyCommon removeAllSpace:_keyWord];
        _addQuesView.hidden = NO;
        _paeaseLable.hidden = YES;
        tableView_.hidden = NO;
        [self beginLoad:nil exParam:nil];
    }else{
       [_searchBar becomeFirstResponder]; 
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con myJobGroudeCtlList:_searchBar.text typeId:@"" pageSize:10 pageIndex:requestCon_.pageInfo_.currentPage_ tradeId:@"" totalId:@""];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

-(void)btnResponse:(id)sender
{
    if (sender == _addQuesbtn) {
        if ([Manager shareMgr].haveLogin) {
            AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
            askDefaultCtl_.backCtlIndex = self.navigationController.viewControllers.count-1;
            [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
            [askDefaultCtl_ beginLoad:nil exParam:nil];
        }else{
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        }
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 1:
        {
            [Manager shareMgr].registeType_ = FromZD;
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobGuideQuizModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if ([dataModal.is_recommend isEqualToString:@"1"]) {
        return [MyJobGuide_RewardCell getCellHeight];
    }
    else
    {
        return dataModal.cellHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobGuideQuizModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if ([dataModal.is_recommend isEqualToString:@"1"]) {
        static NSString *rewardCellIden = @"MyJobGuide_RewardCell";
        MyJobGuide_RewardCell *rewardCell = (MyJobGuide_RewardCell *)[tableView dequeueReusableCellWithIdentifier:rewardCellIden];
        if (rewardCell == nil)
        {
            rewardCell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobGuide_RewardCell" owner:self options:nil] lastObject];
            [rewardCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [rewardCell setCount:dataModal.hot_count withContent:[MyCommon translateHTML:dataModal.question_title]];
        return rewardCell;
    }
    else
    {
        ELAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ELAnswerListCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        JobGuideQuizModal *modal = requestCon_.dataArr_[indexPath.row];
        [cell giveDataWithModal:modal];
        if (!cell.lineView) {
            cell.lineView = [[ELLineView alloc] initWithFrame:CGRectMake(0,modal.cellHeight-1,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            [cell.contentView addSubview:cell.lineView];
        }
        cell.lineView.frame = CGRectMake(0,modal.cellHeight-1,ScreenWidth,1);
        return cell;
    }
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    //记录友盟统计模块使用量
    NSDictionary * dict = @{@"Function":@"职导"};
    [MobClick event:@"personused" attributes:dict];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    JobGuideQuizModal *selectModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:selectModal.question_id exParam:nil];
}

#pragma mark 我来回答
- (void)answerBtnclick:(UIButton *)sender
{
    JobGuideQuizModal *selectModal = [requestCon_.dataArr_ objectAtIndex:sender.tag];
    
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:selectModal.question_id exParam:nil];
}

#pragma mark - 悬赏问答卡片按钮点击
- (void)cellAnswerBtnclick:(UIButton *)sender
{
    JobGuideQuizModal *selectModal = [requestCon_.dataArr_ objectAtIndex:sender.tag];
    
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:selectModal.question_id exParam:nil];
}


#pragma mark - SearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    _addQuesView.hidden = NO;
    _paeaseLable.hidden = YES;
    tableView_.hidden = NO;
    [self beginLoad:nil exParam:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    if ([searchBar.text isEqualToString:@""]) {
        _addQuesView.hidden = YES;
        _paeaseLable.hidden = NO;
        tableView_.hidden = YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

-(void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
