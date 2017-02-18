//
//  SearchGroupArticleList.m
//  jobClient
//
//  Created by 一览ios on 14-12-19.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "SearchGroupArticleList.h"
#import "SearchGroupArticleCell.h"


@interface SearchGroupArticleList ()
{
    UIView *tapView;
}
@end

@implementation SearchGroupArticleList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [changBtn_.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13]];
    groupArticleArray_ = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    searchBar_.delegate = self;
    searchBar_.hidden = YES;
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    [searchBar_ setBackgroundColor:PINGLUNHONG];
    self.navigationItem.titleView = searchBar_;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changBtn_];
    
    tableView_.hidden = YES;
    tapView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,568)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapView addGestureRecognizer:tap];
    
    [searchBar_ becomeFirstResponder];
    searchBar_.showsCancelButton = NO;
    
    CGRect frame = tableView_.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - 66;
    tableView_.frame = frame;
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    [searchBar_ resignFirstResponder];
    [tapView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)btnResponse:(id)sender
{
    if (sender == changBtn_) {
        [searchBar_ resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getDataFunction:(RequestCon *)con
{
    if (![[MyCommon removeAllSpace:searchBar_.text] isEqualToString:@""] ) {
        NSString * userId = [Manager getUserInfo].userId_;
        if (!userId || [userId isEqualToString:@""]) {
            userId = @"";
        }
        if (!con) {
            con = [self getNewRequestCon:YES];
        }
        [con searchGroupsArticleList:_groupsDataModal_.group_id user:userId keyWord:[MyCommon removeAllSpace:searchBar_.text] page:requestCon_.pageInfo_.currentPage_ pageSize:10 topArticle:@"0"];
    }
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    //[tableView_ setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    tableView_.hidden = NO;
    [self beginLoad:nil exParam:nil];
    [searchBar_ resignFirstResponder];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [tapView removeFromSuperview];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar_ resignFirstResponder];
}
- (IBAction)cancelBtnRespone:(UIButton *)sender
{
    //    if ([MyCommon removeAllSpace:searchBar_.text].length > 0)
    //    {
    //        tableView_.hidden = NO;
    //        [self beginLoad:nil exParam:nil];
    //    }
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [tableView_ addSubview:tapView];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchGroupArticleCell";
    SearchGroupArticleCell *cell = (SearchGroupArticleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchGroupArticleCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.titleLb setFont:FIFTEENFONT_TITLE];
        [cell.titleLb setTextColor:BLACKCOLOR];
        [cell.contentLb setFont:FOURTEENFONT_CONTENT];
        [cell.contentLb setTextColor:GRAYCOLOR];
    }
    Article_DataModal * dataModal = [groupArticleArray_ objectAtIndex:indexPath.row];
    
    if (dataModal.summary_.length == 0 || !dataModal.summary_)
    {
        cell.contentLb.hidden = YES;
        cell.timeLableTop.constant = 31;
    }
    else
    {
        cell.timeLableTop.constant = 70;
        cell.contentLb.hidden = NO;
        [cell.contentLb setAttributedText:dataModal.contentAttString];
    }
    
    [cell.titleLb setAttributedText:dataModal.titleAttString];
    
    cell.timeLb.text = [NSString stringWithFormat:@"%@ %@",dataModal.personName_,dataModal.lastCommenttime_];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:dataModal.thum_] placeholderImage:[UIImage imageNamed:@"bg__xinwen2-1"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([groupArticleArray_ count] != 0){
        return [groupArticleArray_ count];
    }
    return 0;
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_SearchGroupsArticle:
        {
            for (Article_DataModal *dataModal in dataArr)
            {
                dataModal.contentAttString = [[NSMutableAttributedString alloc] initWithString:dataModal.summary_];
                if ([dataModal.contentAttString.string rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                {
                    for (NSInteger i = 0; i<=(dataModal.contentAttString.string.length-searchBar_.text.length) ;i++)
                    {
                        NSString *str = [dataModal.contentAttString.string substringWithRange:NSMakeRange(i,searchBar_.text.length)];
                        if ([str rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                        {
                            [dataModal.contentAttString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,searchBar_.text.length)];
                        }
                    }
                }
                
                dataModal.titleAttString = [[NSMutableAttributedString alloc] initWithString:dataModal.title_];
                if ([dataModal.titleAttString.string rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                {
                    for (NSInteger i = 0; i<=(dataModal.titleAttString.string.length-searchBar_.text.length) ;i++)
                    {
                        NSString *str = [dataModal.titleAttString.string substringWithRange:NSMakeRange(i,searchBar_.text.length)];
                       // NSString *str1 = [dataModal.titleAttString.string substringWithRange:NSMakeRange(0,i+1)];
                        
//                        if ([str1 sizeWithFont:[UIFont systemFontOfSize:14]].width > 424)
//                        {
//                            [dataModal.titleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(i+1,dataModal.titleAttString.string.length-i-1)];
//                            break;
//                        }
                        if ([str rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                        {
                            [dataModal.titleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,searchBar_.text.length)];
                        }
                    }
                }
                
                [dataModal.contentAttString addAttribute:NSFontAttributeName value:FOURTEENFONT_CONTENT range:NSMakeRange(0,dataModal.contentAttString.string.length)];
                [dataModal.titleAttString addAttribute:NSFontAttributeName value:FOURTEENFONT_CONTENT range:NSMakeRange(0,dataModal.titleAttString.string.length)];
                
            }
            if (requestCon_.pageInfo_.currentPage_ == 1)
            {
                [groupArticleArray_ removeAllObjects];
            }
            [groupArticleArray_ addObjectsFromArray:dataArr];
        }
        default:
            break;
    }
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    [searchBar_ resignFirstResponder];
    if ([Manager shareMgr].haveLogin) {
        if ([_groupsDataModal_.code isEqualToString:@"199"]||[_groupsDataModal_.code isEqualToString:@"200"]||[_groupsDataModal_.code isEqualToString:@"201"]||[_groupsDataModal_.code isEqualToString:@"202"]) {
            //[BaseUIViewController showAlertView:@"无法查看" msg:@"您尚未加入本社群" btnTitle:@"确定"];
            [self showChooseAlertView:11 title:@"加入社群后才可查看" msg:@"是否马上加入？" okBtnTitle:@"加入" cancelBtnTitle:@"取消"];
            return;
        }
    }else{
        [BaseUIViewController showAlertView:@"无法查看" msg:@"您尚未登录" btnTitle:@"确定"];
        return;
    }
    ArticleDetailCtl *articleDetailCtl_ = [[ArticleDetailCtl alloc] init];
    articleDetailCtl_.isFromGroup_ = YES;
    Article_DataModal * dataModel = [groupArticleArray_ objectAtIndex:indexPath.row];
    if (!dataModel.id_) {
        return;
    }
    dataModel.articleType_ = Article_Group;
    if ([_expertModel_.id_ isEqualToString:dataModel.personID_]) {
        articleDetailCtl_.type_ = @"1";//判断文章是否能跳转个人中心
    }
    else {
        [self.navigationController pushViewController:articleDetailCtl_ animated:YES];
    }
    [articleDetailCtl_ beginLoad:dataModel.id_ exParam:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article_DataModal *modal = requestCon_.dataArr_[indexPath.row];
    if (modal.summary_.length == 0 || !modal.summary_)
    {
        return 70;
    }
    return 100.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    searchBar_.hidden = NO;
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    searchBar_.hidden = YES;
    [super viewWillDisappear:animated];
    [searchBar_ resignFirstResponder];
}

@end
