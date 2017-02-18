//
//  JobGuideTypeAQListCtl.m
//  jobClient
//
//  Created by YL1001 on 15/8/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "JobGuideTypeAQListCtl.h"
#import "MyJobGuideCtl_Cell.h"
#import "MyJobGuide_RewardCell.h"
#import "JobGuideQuizModal.h"
#import "ELAnswerListCell.h"
#import "ELJobGuideTradeChangeCtl.h"

@interface JobGuideTypeAQListCtl () <ELTradeChangeDelegate>
{
    BOOL isHaveTitle;
    NSString *titleName;
    NSString *typeId;
    BOOL shouldRefresh_;
    NSString *queTitle;
    UILabel *tradeNameLb;
    UIButton *tradeChangeButton;
}
@end

@implementation JobGuideTypeAQListCtl

- (id)init
{
    self = [super init];
    bFooterEgo_ = YES;
    validateSeconds_ = 600;
    imageConArr_ = [[NSMutableArray alloc] init];
    rightNavBarStr_ = @"提问";
    return self;
}

- (void)changeGuideType:(NSInteger)count
{
//    index = count;
    isHaveTitle = NO;
//    [titleBtn_ setTitle:[quesArr[count] str_] forState:UIControlStateNormal];
    [self refreshLoad:requestCon_];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    isHaveTitle = NO;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,60,40)];
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = titleName;
    
    self.navigationItem.titleView = lable;

//    quesArr = [CondictionListCtl getQuesArr];
//    [titleBtn_ setTitle:titleName forState:UIControlStateNormal];
    
    self.navigationController.toolbarHidden = YES;
    
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    tableView_.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    [tableView_ registerNib:[UINib nibWithNibName:@"ELAnswerListCell" bundle:nil] forCellReuseIdentifier:@"ELAnswerListCell"];
    
}

-(void)rightBarBtnResponse:(id)sender{
    AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
    askDefaultCtl_.backCtlIndex = self.navigationController.viewControllers.count-1;
    [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
    [askDefaultCtl_ beginLoad:nil exParam:nil];
}

-(void)creatHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,70)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,10,ScreenWidth,50)];
    backView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:backView];
    
    UILabel *tradeLable = [[UILabel alloc] initWithFrame:CGRectMake(16,15,70,20)];
    tradeLable.textColor = UIColorFromRGB(0x212121);
    tradeLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    tradeLable.text = @"行业分类";
    [backView addSubview:tradeLable];
    
    tradeNameLb = [[UILabel alloc] initWithFrame:CGRectMake(95,15,ScreenWidth-130,20)];
    tradeNameLb.textColor = UIColorFromRGB(0x757575);
    tradeNameLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    tradeNameLb.textAlignment = NSTextAlignmentRight;
    if (_tradeModel && ![_tradeModel.str_ isEqualToString:@"全部"]) {
        tradeNameLb.text = [NSString stringWithFormat:@"%@-%@",_tradeModel.pName,_tradeModel.str_];
    }else{
        tradeNameLb.text = @"全部";  
    }
    [backView addSubview:tradeNameLb];
    
    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-25,18,8,13)];
    rightImage.image = [UIImage imageNamed:@"right_jiantou_image"];
    [backView addSubview:rightImage];
    
    tradeChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self refreshTradeButtonFrame];
    [tradeChangeButton addTarget:self action:@selector(tradeChangeBtnRespone:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:tradeChangeButton];
    tableView_.tableHeaderView = headView;
}

-(void)tradeChangeBtnRespone:(UIButton *)sender{
    ELJobGuideTradeChangeCtl *ctl = [[ELJobGuideTradeChangeCtl alloc] init];
    ctl.tradeDelegate = self;
    ctl.showAllChange = YES;
    if (_tradeModel && ![_tradeModel.str_ isEqualToString:@"全部"]) {
        ctl.selectChangeModal = _tradeModel;
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)tradeChangeWithArr:(CondictionList_DataModal *)dataModal{
    if (dataModal){
        _tradeModel = dataModal;
        if ([_tradeModel.str_ isEqualToString:@"全部"]) {
            tradeNameLb.text = @"全部";
            _tradeModel = nil;
        }else{
            tradeNameLb.text = tradeNameLb.text = [NSString stringWithFormat:@"%@-%@",_tradeModel.pName,_tradeModel.str_];
        }
        [self refreshTradeButtonFrame];
        [self refreshLoad:nil];
    }
}
-(void)refreshTradeButtonFrame{
    CGSize size = [tradeNameLb.text sizeNewWithFont:tradeNameLb.font];
    tradeChangeButton.frame = CGRectMake(ScreenWidth-size.width-35,0,size.width+35,50);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_ egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        shouldRefresh_ = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (requestCon_ && ([requestCon_.dataArr_ count] == 0 || shouldRefresh_)) {
        [self refreshLoad:nil];
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (dataModal){
        typeId = dataModal;
    }else{
        typeId = @"";
    }
    if (exParam) {
        titleName = exParam;
    }else{
        titleName = @"全部类型";
    }
    //    index = [dataModal integerValue];
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!typeId) {
        typeId = @"";
    }
    NSString *tradeId = @"";
    if (_tradeModel && ![_tradeModel.str_ isEqualToString:@"全部"]) {
        tradeId = _tradeModel.id_;
    }
    [con myJobGroudeCtlList:@"" typeId:typeId pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ tradeId:tradeId totalId:@""];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_JobGuideQuesList:
            shouldRefresh_ = NO;
            if (_showTradeChange) {
                [self creatHeadView];
                self.noDataViewStartY = 70;
            }else{
                tableView_.tableHeaderView = nil;
            }
            break;
            
        default:
            break;
    }
}


- (void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch (type) {
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

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobGuideQuizModal *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if ([dataModal.is_recommend isEqualToString:@"1"]) {
        static NSString *rewardCellIden = @"MyJobGuide_RewardCell";
        MyJobGuide_RewardCell *rewardCell = (MyJobGuide_RewardCell *)[tableView dequeueReusableCellWithIdentifier:rewardCellIden];
        if (rewardCell == nil)
        {
            rewardCell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobGuide_RewardCell" owner:self options:nil] lastObject];
            [rewardCell setSelectionStyle:UITableViewCellSelectionStyleGray];
            rewardCell.selectedBackgroundView = [[UIView alloc] initWithFrame:rewardCell.frame];
            rewardCell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        }
        [rewardCell setCount:dataModal.hot_count withContent:[MyCommon translateHTML:dataModal.question_title]];
        return rewardCell;
    }
    else
    {
        ELAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ELAnswerListCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        JobGuideQuizModal *modal = requestCon_.dataArr_[indexPath.row];
        [cell giveDataWithModal:modal];
        if (!cell.lineView) {
            cell.lineView = [[ELLineView alloc] initWithFrame:CGRectMake(0,modal.cellHeight-1,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            [cell.contentView addSubview:cell.lineView];
        }
        cell.lineView.frame = CGRectMake(0,modal.cellHeight-1,ScreenWidth,1);
        return cell;
        
//        static NSString *CellIdentifier = @"MyJobGuideCtl_Cell";
        
//        MyJobGuideCtl_Cell *cell = (MyJobGuideCtl_Cell *)[tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobGuideCtl_Cell" owner:self options:nil] lastObject];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            cell.titleImage.clipsToBounds = YES;
//            cell.titleImage.layer.cornerRadius = cell.titleImage.bounds.size.height/2;
//        }
//        
//        [cell giveDataWithModal:dataModal];
//        
//        cell.answerBtn.tag = indexPath.row;
//        [cell.answerBtn addTarget:self action:@selector(answerBtnclick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES]
    ;    //记录友盟统计模块使用量
    NSDictionary * dict = @{@"Function":@"职导"};
    [MobClick event:@"personused" attributes:dict];
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    JobGuideQuizModal *selectModal = selectData;
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:selectModal.question_id exParam:exParam];

}

#pragma mark - 我来回答
- (void)answerBtnclick:(UIButton *)sender
{
    //记录友盟统计模块使用量
    NSString *dictStr = [NSString stringWithFormat:@"%@_%@", @"我来回答", [self class]];
    NSDictionary *dict = @{@"Function" : dictStr};
    [MobClick event:@"buttonClick" attributes:dict];
    
    JobGuideQuizModal *selectModal = [requestCon_.dataArr_ objectAtIndex:sender.tag];
    
    AnswerDetailCtl *answerDetailCtl = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:answerDetailCtl animated:YES];
    [answerDetailCtl beginLoad:selectModal.question_id exParam:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
