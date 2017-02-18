//
//  ExpertListCtl.m
//  jobClient
//
//  Created by YL1001 on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ExpertListCtl.h"
#import "ExpertListCell.h"
#import "ELBecomeExpertCtl.h"
#import "DataBase.h"
#import "UIImageView+WebCache.h"
#import "ELExpertCourseListCtl.h"

@interface ExpertListCtl ()
{
    NSInteger index;
    
    IBOutlet UIView *applyExpertView;
    
    __weak IBOutlet UIButton *applyBtn;
    
    NSMutableDictionary *cellDic;
    NSString *defaultImgStr;
}
@end

@implementation ExpertListCtl


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bFooterEgo_ = YES;
        validateSeconds_ = 60000;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellDic = [NSMutableDictionary dictionary];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1]];
    applyExpertView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (_showApplyExpertView)
    {
        CGRect frame = applyExpertView.frame;
        frame.size.width = ScreenWidth;
        applyExpertView.frame = frame;
        
        applyBtn.clipsToBounds = YES;
        applyBtn.layer.cornerRadius = 4.0;
        applyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        applyBtn.layer.borderWidth = 1.0;
        tableView_.tableHeaderView = applyExpertView;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)viewDidLayoutSubviews
{
    [self.view layoutSubviews];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString *cityStr = [Manager shareMgr].regionName_;
    NSString *regionId = [CondictionListCtl getRegionId:cityStr];
    
    NSString *userId = [Manager getUserInfo].userId_;
    if (!userId) {
        userId = @"";
    }
    [con getJobGuideExpertList:userId page:con.pageInfo_.currentPage_ pageSize:20 productType:_productType regionId:regionId regionName:cityStr];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}


- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_getJobGuideExpertList:
        {
            if( [requestCon_.dataArr_ count] > 0 )
            {
                _alreadyRefresh = YES;
                if( requestCon_.pageInfo_.currentPage_ > requestCon_.pageInfo_.pageCnt_ ){
                    self.isChangeNoMoreData = YES;
                    CGRect frame = footerView.frame;
                    frame.size.width = ScreenWidth;
                    footerView.frame = frame;
                    footerView.backgroundColor = [UIColor clearColor];
                    tableView_.tableFooterView = footerView;
                }
                else
                {
                    self.isChangeNoMoreData = NO;
                    [footerView removeFromSuperview];
                    tableView_.tableFooterView = nil;
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestCon_.dataArr_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ExpertListCell";
    
    JobGuideExpertModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    ExpertListCell *cell = (ExpertListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpertListCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    }
    
    dataModal.expertType = _productType;
    
    [cell setExpertHonorLbFrame:dataModal];
    cell.expertHonorLb_.numberOfLines = 0;
    
    NSInteger expertImgHeight = (ScreenWidth * 450) / 750;
    cell.expertImgAutoHeight.constant = expertImgHeight;
    cell.expertImg_.contentMode = UIViewContentModeScaleAspectFill;
    [cell.expertImg_ updateConstraintsIfNeeded];
    
    
    [cell.expertName_ setTitle:[MyCommon translateHTML:dataModal.person_iname] forState:UIControlStateNormal];
    cell.adeptLb_.text = [MyCommon translateHTML:dataModal.expert_detail[@"good_at"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertListCell *cell = [cellDic objectForKey:@"cell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ExpertListCell" owner:self options:nil].lastObject;
        [cellDic setObject:cell forKey:@"cell"];
    }
    JobGuideExpertModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    cell.expertHonorLb_.text = dataModal.person_zw;
    cell.expertHonorLb_.textAlignment = NSTextAlignmentCenter;
    
    NSInteger expertImgHeight = (ScreenWidth * 450) / 750;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.expertHonorLb_.preferredMaxLayoutWidth = 2 * [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat setExpertHonorLbHeight = [cell.expertHonorLb_ systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    cell.expertHonorLb_.numberOfLines = 0;
    return setExpertHonorLbHeight + 255 + (expertImgHeight - 190);
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    JobGuideExpertModal *dataModal = selectData;
    ELPersonCenterCtl *ctl = [[ELPersonCenterCtl alloc] init];
    ctl.isFromJobAnswer = YES;
    [ctl beginLoad:dataModal.person_id exParam:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)btnResponse:(id)sender
{
    //记录友盟统计模块使用量
    NSString *dictStr;
    
    if (sender == moreExpertBtn_)
    {
        dictStr = [NSString stringWithFormat:@"%@_%@", @"查看更多行家", [self class]];
        
        SameTradeListCtl *sameTradeList = [[SameTradeListCtl alloc] init];
        [self.navigationController pushViewController:sameTradeList animated:YES];
        NSString *str = @"1";
        [sameTradeList beginLoad:str exParam:nil];
    }
    else if (sender == applyBtn)
    {
        dictStr = [NSString stringWithFormat:@"%@_%@", @"申请行家", [self class]];
        if ([Manager shareMgr].haveLogin) {
            if ([Manager getUserInfo].isExpert_) {
                ELExpertCourseListCtl *CourseListCtl = [[ELExpertCourseListCtl alloc] init];
                [[Manager shareMgr].centerNav_ pushViewController:CourseListCtl animated:YES];
                [CourseListCtl beginLoad:nil exParam:nil];
            }else{
                ELBecomeExpertCtl *expertCtl = [[ELBecomeExpertCtl alloc] init];
                [[Manager shareMgr].centerNav_ pushViewController:expertCtl animated:YES];
            }
        }
        else
        {
            [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
            return;
        }
    }
    if (dictStr.length > 0) {
        NSDictionary *dict = @{@"Function" : dictStr};
        [MobClick event:@"buttonClick" attributes:dict];
    }
}

- (void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
