//
//  ELSameTradeSearchCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/12.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELSameTradeSearchCtl.h"
#import "SameTradeCell.h"
#import "ExJSONParser.h"
#import "ELPersonCenterCtl.h"
#import "ELSameTradePeopleFrameModel.h"

@interface ELSameTradeSearchCtl () <UISearchBarDelegate,PersonCenterCtlDelegate>
{
    __weak IBOutlet UISearchBar *searchBar_;
    
    IBOutlet UIButton *rightBtn;
    RequestCon *attentionCon_;
    NSInteger index_;
    ELRequest *elRequest;
    
    UIView *tapView;
    NSInteger indexPathRow;
}
@end

@implementation ELSameTradeSearchCtl

-(instancetype)init
{
    self = [super init];
    if (self) {
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    searchBar_.delegate = self;
    searchBar_.hidden = YES;
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    [searchBar_ setBackgroundColor:PINGLUNHONG];
    searchBar_.tintColor = UIColorFromRGB(0xe13e3e);
    self.navigationItem.titleView = searchBar_;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    tableView_.hidden = YES;
    tapView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapView addGestureRecognizer:tap];
    
    [searchBar_ becomeFirstResponder];
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    [searchBar_ resignFirstResponder];
    [tapView removeFromSuperview];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:nil];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager getUserInfo].userId_) {
        userId = @"";
    }
    [con getTraderPeson:userId pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ keyWord:[MyCommon removeAllSpace:searchBar_.text ] isExpert:_getExpertFlag.length>0?@"1":@"" withJobType:_jobType];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetTraderPeson:
        {
            for (ELSameTradePeopleFrameModel *model in dataArr){
                [model changeSearchKeyWord];
            }
            
            if (dataArr.count <= 0) {
                self.noDataImgStr = @"img_search_noData.png";
                self.noDataTips = @"暂无相关结果，替换关键词再试试吧";
            }
            
            [tableView_ reloadData];
        }
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fromMessageList)
    {
        ShareMessageModal *shareModal = [[ShareMessageModal alloc] init];
        ELSameTradePeopleFrameModel *modal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        shareModal.personId = modal.peopleModel.personId;
        shareModal.personName = modal.peopleModel.person_iname;
        shareModal.personName = [shareModal.personName stringByReplacingOccurrencesOfString:@"<font color=red>" withString:@""];
        shareModal.personName = [shareModal.personName stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
        shareModal.person_pic = modal.peopleModel.person_pic;
        shareModal.person_zw = modal.peopleModel.person_job_now;
        shareModal.person_zw = [shareModal.person_zw stringByReplacingOccurrencesOfString:@"<font color=red>" withString:@""];
        shareModal.person_zw = [shareModal.person_zw stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
        if (shareModal.person_zw.length == 0) {
            shareModal.person_zw = modal.peopleModel.person_zw;
        }
        shareModal.shareType = @"1";
        shareModal.shareContent = @"名片";
        
        if (!shareModal.personName) {
            shareModal.personName = @"";
        }
        if (!shareModal.person_pic) {
            shareModal.person_pic = @"";
        }
        if (!shareModal.person_zw) {
            shareModal.person_zw = @"";
        }
        
        [self.sameTradeCtl.delegate_ sameTradeMessageModal:shareModal];
        for (id ctl in self.navigationController.viewControllers)
        {
            if ([ctl isKindOfClass:[MessageDailogListCtl class]])
            {
                [self.navigationController popToViewController:ctl animated:YES];
                break;
            }
        }
        return;
    }
    ELSameTradePeopleFrameModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
    personCenterCtl.delegate = self;
    [self.navigationController pushViewController:personCenterCtl animated:YES];
    indexPathRow = indexPath.row;
    [personCenterCtl beginLoad:model.peopleModel.personId exParam:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSameTradePeopleFrameModel *model = requestCon_.dataArr_[indexPath.row];
    static NSString *identifier = @"cell";
    SameTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SameTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.showAttentionButton = YES;
    cell.peopleModel = model;
    return cell;
}

- (void)addLikeSuccess
{
    Expert_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexPathRow];
    model.followStatus_ = 1;
    [tableView_ reloadData];
}
- (void)leslikeSuccess
{
    Expert_DataModal *model = [requestCon_.dataArr_ objectAtIndex:indexPathRow];
    model.followStatus_ = 0;
    [tableView_ reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
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

#pragma mark - UISearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}

- (IBAction)cancelBtnRespone:(UIButton *)sender
{
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [tableView_ addSubview:tapView];
    return YES;
}

@end
