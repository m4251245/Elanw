//
//  ELTodayFocusSearchCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELTodayFocusSearchCtl.h"
#import "BaseUIViewController.h"
#import "ELSameTradeSearchCell.h"
#import "SearchGroupArticleCell.h"
#import "YLOfferListCtlCell.h"
#import "ELTodayJobSearchCell.h"
#import "ELTodaySearchMoreCtl.h"
#import "ELTodaySearchModal.h"
#import "ELPersonCenterCtl.h"
#import "YLOfferApplyUrlCtl.h"
#import "MyJobSearchCtlCell.h"
#import "PrivateGroupView.h"
#import "ResumeCompleteModel.h"
#import "ELGroupDetailCtl.h"

@interface ELTodayFocusSearchCtl () <UISearchBarDelegate,JionGroupReasonCtlDelegate,NoLoginDelegate>
{
    IBOutlet UIButton *cancelBtn;
    IBOutlet UISearchBar *searchBar_;
    UIView *tapView;
    
    RequestCon *resumeCon;
    
    __weak IBOutlet UIImageView *canSearchImage;
    __weak IBOutlet UILabel *searchFinishLb;
    
    BOOL resumeComplete;
    
    NSMutableArray *dataListArr;
    RequestCon       * joinCon_;
    PrivateGroupView *privateView;
    NSString *groudID;
    
}
@end

@implementation ELTodayFocusSearchCtl

#pragma LifeCycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

-(instancetype)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view from its nib.
     [super viewDidLoad];
    
    searchFinishLb.text = @"";
    canSearchImage.hidden = NO;
    
    searchBar_.delegate = self;
    searchBar_.hidden = YES;
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    [searchBar_ setBackgroundColor:PINGLUNHONG];
    
    [searchBar_ setTintColor:PINGLUNHONG];
    
    self.navigationItem.titleView = searchBar_;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    tableView_.hidden = YES;
    
    tapView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapView addGestureRecognizer:tap];
    
    [searchBar_ becomeFirstResponder];
    searchBar_.showsCancelButton = NO;
    
    dataListArr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"LOGINSUCCESS" object:nil];
    
    if ([Manager shareMgr].haveLogin)
    {
        if (!resumeCon) {
            resumeCon = [self getNewRequestCon:NO];
        }
        [resumeCon getResumeComplete:[Manager getUserInfo].userId_];
    }
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

- (void)refreshData
{
    [self refreshLoad:nil];
}

#pragma mark - NetWork
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getTodaySearchListKeyWord:searchBar_.text];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_JoinGroup:
        {
            if (code == Success) {
                [privateView.operationBtn setTitle:@"等待审核" forState:UIControlStateNormal];
                privateView.operationBtn.enabled = NO;
            }
        }
            break;
        case Request_TodaySearchList:
        {
            [dataListArr removeAllObjects];
            
            NSDictionary *dic = dataArr[0][@"data"];
            
            NSArray *expertList = dic[@"expert_list"];
            NSArray *personList = dic[@"person_list"];
            NSArray *articleList = dic[@"article_list"];
            NSArray *groupList = dic[@"group_list"];
            NSArray *offerList = dic[@"offer_list"];
            NSArray *positionList = dic[@"zhiwei_list"];
            
            //行家列表
            if ([expertList isKindOfClass:[NSArray class]])
            {
                 NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 0;i < MIN(expertList.count,2);i++)
                {
                    NSDictionary *dic1 = expertList[i];
                    ELTodaySearchModal *model = [[ELTodaySearchModal alloc] initExpertModelWithDictionary:dic1];
                    if (expertList.count >= 2)
                    {
                        model.showMore = YES;
                    }
                    else
                    {
                        model.showMore = NO;
                    }
                    [arr1 addObject:model];
                }
                if(arr1.count > 0)
                {
                    [dataListArr addObject:arr1];
                }
            }
            
            //个人列表
            if ([personList isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 0;i < MIN(personList.count,3);i++)
                {
                    NSDictionary *dic1 = personList[i];
                    ELTodaySearchModal *model = [[ELTodaySearchModal alloc] initSameTradeModelWithDictionary:dic1];
                    if (personList.count >= 3)
                    {
                        model.showMore = YES;
                    }
                    else
                    {
                        model.showMore = NO;
                    }
                    [arr1 addObject:model];
                }
                if(arr1.count > 0)
                {
                    [dataListArr addObject:arr1];
                }
            }
            
            //文章列表
            if ([articleList isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 0;i < MIN(articleList.count,3);i++)
                {
                    NSDictionary *dic1 = articleList[i];
                    ELTodaySearchModal *model = [[ELTodaySearchModal alloc] initArticleModalWithDictionary:dic1];
                    if (articleList.count >= 3)
                    {
                        model.showMore = YES;
                    }
                    else
                    {
                        model.showMore = NO;
                    }
                    model.attStringContent = [model.summary getHtmlAttStringWithFont:FOURTEENFONT_CONTENT color:GRAYCOLOR];
                    if ([model.attStringContent.string rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        for (NSInteger i = 0; i<=(model.attStringContent.string.length-searchBar_.text.length) ;i++)
                        {
                            NSString *str = [model.attStringContent.string substringWithRange:NSMakeRange(i,searchBar_.text.length)];
                            if ([str rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                            {
                                [model.attStringContent addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,searchBar_.text.length)];
                            }
                        }
                    }
                    [arr1 addObject:model];
                }
                if(arr1.count > 0)
                {
                    [dataListArr addObject:arr1];
                }
            }
            
            //社群列表
            if ([groupList isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 0;i < MIN(groupList.count,3);i++)
                {
                    NSDictionary *dic1 = groupList[i];
                    ELTodaySearchModal *model = [[ELTodaySearchModal alloc] initGroupModalWithDictionary:dic1];
                    if (!model.attStringTitle) {
                        model.attStringTitle = [[NSMutableAttributedString alloc] initWithString:model.group_name];
                        [model.attStringTitle setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
                    }
                    if (groupList.count >= 3)
                    {
                        model.showMore = YES;
                    }
                    else
                    {
                        model.showMore = NO;
                    }
                    [arr1 addObject:model];
                }
                if(arr1.count > 0)
                {
                    [dataListArr addObject:arr1];
                }
            }
            
            //offer派列表
            if ([offerList isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 0;i < MIN(offerList.count,1);i++)
                {
                    NSDictionary *dic1 = offerList[i];
                    ELTodaySearchModal *model = [[ELTodaySearchModal alloc] initOfferModalWithDictionary:dic1];
                    if (offerList.count >= 1)
                    {
                        model.showMore = YES;
                    }
                    else
                    {
                        model.showMore = NO;
                    }
                    
                    model.attStringTitle = [[NSMutableAttributedString alloc] initWithString:model.offerModal.jobfair_name];
                    if ([model.attStringTitle.string rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        for (NSInteger i = 0; i<=(model.attStringTitle.string.length-searchBar_.text.length) ;i++)
                        {
                            NSString *str = [model.attStringTitle.string substringWithRange:NSMakeRange(i,searchBar_.text.length)];
                            if ([str rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                            {
                                [model.attStringTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,searchBar_.text.length)];
                            }
                        }
                    }
                    
                    model.attStringContent = [[NSMutableAttributedString alloc] initWithString:model.offerModal.jobfair_zhiwei];
                    if ([model.attStringContent.string rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        for (NSInteger i = 0; i<=(model.attStringContent.string.length-searchBar_.text.length) ;i++)
                        {
                            NSString *str = [model.attStringContent.string substringWithRange:NSMakeRange(i,searchBar_.text.length)];
                            if ([str rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                            {
                                [model.attStringContent addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,searchBar_.text.length)];
                            }
                        }
                    }
                    
                    model.attStringDetial = [[NSMutableAttributedString alloc] initWithString:model.offerModal.place_name];
                    if ([model.attStringDetial.string rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        for (NSInteger i = 0; i<=(model.attStringDetial.string.length-searchBar_.text.length) ;i++)
                        {
                            NSString *str = [model.attStringDetial.string substringWithRange:NSMakeRange(i,searchBar_.text.length)];
                            if ([str rangeOfString:searchBar_.text options:NSCaseInsensitiveSearch].location != NSNotFound)
                            {
                                [model.attStringDetial addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,searchBar_.text.length)];
                            }
                        }
                    }
                    
                    [arr1 addObject:model];
                }
                if(arr1.count > 0)
                {
                    [dataListArr addObject:arr1];
                }
            }
            
            //职位列表
            if ([positionList isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                for (NSInteger i = 0;i < MIN(positionList.count,3);i++)
                {
                    NSDictionary *dic1 = positionList[i];
                    ELTodaySearchModal *model = [[ELTodaySearchModal alloc] initPositionModelWithDictionary:dic1];
                    model.attStringTitle = [[NSMutableAttributedString alloc] initWithString:model.jobModel.jtzw];
                    NSString *companyname;
                    if (model.jobModel.cname.length > 0)
                    {
                        companyname = model.jobModel.cname;
                    }else
                    {
                        companyname = model.jobModel.cname_all;
                    }
                    model.attStringContent = [[NSMutableAttributedString alloc] initWithString:companyname];
                    [model changeColor:model.attStringTitle withKeyWork:searchBar_.text];
                    [model changeColor:model.attStringContent withKeyWork:searchBar_.text];
                    if (positionList.count >= 3)
                    {
                        model.showMore = YES;
                    }
                    else
                    {
                        model.showMore = NO;
                    }
                    [arr1 addObject:model];
                }
                if(arr1.count > 0)
                {
                    [dataListArr addObject:arr1];
                }
            }
            
            if (dataListArr.count == 0)
            {
                tableView_.hidden = NO;
                self.noDataTips = @"暂无相关结果，替换关键词再试试吧";
                self.noDataImgStr = @"img_search_noData.png";
                [self showNoDataOkView:YES];
            }
            else
            {
                [[self getNoDataView] removeFromSuperview];
            }

            [tableView_ reloadData];
        }
            break;
        case Request_GetResumeComplete:
        {
            ResumeCompleteModel *model = dataArr[0];
            if ([model.basic_ isEqualToString:@"2"] && [model.edu_ isEqualToString:@"2"] && [model.work_ isEqualToString:@"2"])
            {
                resumeComplete = YES;
            }
            else
            {
                resumeComplete = NO;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataListArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ELTodaySearchModal *model = dataListArr[section][0];
    if (model.showMore)
    {
        return [dataListArr[section] count] + 2;
    }
    return [dataListArr[section] count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 30.0;
    }
    else if(indexPath.row == [dataListArr[indexPath.section] count] + 1)
    {
        return 40.0;
    }
    else
    {
        ELTodaySearchModal *model = dataListArr[indexPath.section][indexPath.row-1];
        switch (model.modelType)
        {
            case ExpertSearchType:
            case SameTradeSearchType:
            case GroupSearchType:
            {
                return 60.0;
            }
                break;
            case ArticleSearchType:
            {
                if (model.title.length > 0) {
                    return 95.0;
                }
                return 75.0;
            }
                break;
            case OfferSearchType:
            {
                return 70.0;
            }
                break;
            case JobSearchType:
            {
                NewJobPositionDataModel *dataModal = model.jobModel;
                if (!dataModal.fldy) {
                    return 95;
                }else{
                    return 118;
                }
            }
                break;
            default:
                break;
        }
    }
    
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)];
    view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ELTodaySearchModal *model = dataListArr[section][0];
    if (((NSArray *)dataListArr[section]).count == 1 && model.modelType == GroupSearchType && [model.openstatus isEqualToString:@"3"]) {
        return MAX(400, ScreenHeight-150);
    }
    if(section == dataListArr.count-1)
    {
        return 0.1;
    }
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
   
    ELTodaySearchModal *model = dataListArr[section][0];
    
    if (model.modelType == GroupSearchType && [model.openstatus isEqualToString:@"3"] && (![model.group_user_rel isEqualToString:@"30"]|| ![Manager shareMgr].haveLogin)) {
        if (!privateView) {
           privateView = [[[NSBundle mainBundle] loadNibNamed:@"PrivateGroupView" owner:self options:nil] lastObject];
        }
        groudID = model.group_id;
        [privateView showPrivateGroupEntrance:[Manager shareMgr].haveLogin?model.group_user_rel:@"10"];
        [privateView.operationBtn addTarget:self action:@selector(operationAction) forControlEvents:UIControlEventTouchUpInside];
        
        return privateView;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,1)];
    view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellString = @"headerCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20,5,ScreenWidth-120,20)];
            lable.tag = 101;
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font = FIFTEENFONT_TITLE;
            lable.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lable];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,29,ScreenWidth,1)];
            imageView.image = [UIImage imageNamed:@"gg_home_line2"];
            [cell.contentView addSubview:imageView];
            UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(-10,0,ScreenWidth+10,1)];
            imageViewOne.image = [UIImage imageNamed:@"gg_home_line2"];
            [cell.contentView addSubview:imageViewOne];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        UILabel *lable = (UILabel *)[cell.contentView viewWithTag:101];
        ELTodaySearchModal *model = dataListArr[indexPath.section][0];
        
        switch (model.modelType)
        {
            case ExpertSearchType:
            {
                lable.text = @"行家";
            }
                break;
            case SameTradeSearchType:
            {
                lable.text = @"同行";
            }
                break;
            case GroupSearchType:
            {
                lable.text = @"社群";
            }
                break;
            case ArticleSearchType:
            {
                lable.text = @"话题";
            }
                break;
            case OfferSearchType:
            {
                lable.text = @"Offer派";
            }
                break;
            case JobSearchType:
            {
                lable.text = @"职位";
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    else if (indexPath.row == [[dataListArr objectAtIndex:[indexPath section]] count] + 1)
    {
        static NSString *cellString = @"footCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(40,10,ScreenWidth-120,20)];
            lable.tag = 101;
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font = FIFTEENFONT_TITLE;
            lable.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lable];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10,39,ScreenWidth+10,1)];
            imageView.image = [UIImage imageNamed:@"gg_home_line2"];
            [cell.contentView addSubview:imageView];
            UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(20,12,16,16)];
            imageViewOne.image = [UIImage imageNamed:@"icon_search_16"];
            [cell.contentView addSubview:imageViewOne];
            UIImageView *imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-20,13,7,13)];
            imageViewTwo.image = [UIImage imageNamed:@"icon_jiantou.png"];
            [cell.contentView addSubview:imageViewTwo];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        UILabel *lable = (UILabel *)[cell.contentView viewWithTag:101];
        ELTodaySearchModal *model = dataListArr[indexPath.section][0];
        switch (model.modelType)
        {
            case ExpertSearchType:
            {
                lable.text = @"查看更多行家";
            }
                break;
            case SameTradeSearchType:
            {
                lable.text = @"查看更多同行";
            }
                break;
            case GroupSearchType:
            {
                lable.text = @"查看更多相关社群";
            }
                break;
            case ArticleSearchType:
            {
                lable.text = @"查看更多相关话题";
            }
                break;
            case OfferSearchType:
            {
                lable.text = @"查看更多相关Offer派";
            }
                break;
            case JobSearchType:
            {
                lable.text = @"查看更多相关职位";
            }
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        ELTodaySearchModal *model = dataListArr[indexPath.section][indexPath.row-1];
        switch (model.modelType) {
            case ExpertSearchType:
            {
                static NSString *identifier = @"ELSameTradeSearchCell";
                ELSameTradeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ELSameTradeSearchCell" owner:self options:nil] lastObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.title.frame = CGRectMake(80,10,ScreenWidth-105,20);
                cell.content.frame = CGRectMake(62,32,ScreenWidth-80,17);
                cell.lineImage.frame = CGRectMake(10,59,ScreenWidth,1);
                cell.expertImage.hidden = NO;
                cell.title.attributedText = model.attStringTitle;
                cell.content.attributedText = model.attStringContent;
                cell.title.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.content.lineBreakMode = NSLineBreakByTruncatingTail;
                [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
                return cell;
            }
                break;
            case SameTradeSearchType:
            {
                static NSString *identifier = @"ELSameTradeSearchCell";
                ELSameTradeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ELSameTradeSearchCell" owner:self options:nil] lastObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.title.frame = CGRectMake(62,10,ScreenWidth-80,20);
                cell.content.frame = CGRectMake(62,32,ScreenWidth-80,17);
                cell.lineImage.frame = CGRectMake(10,59,ScreenWidth,1);
                cell.expertImage.hidden = YES;
                cell.title.attributedText = model.attStringTitle;
                cell.content.attributedText = model.attStringContent;
                cell.title.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.content.lineBreakMode = NSLineBreakByTruncatingTail;
                [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.person_pic] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
                return cell;
            }
                break;
            case ArticleSearchType:
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
                    cell.titleImageLeftW.constant = 20;
                    cell.timeLableLeftW.constant = 102;
                }
                
                if (model.title.length > 0)
                {
                    cell.titleLb.hidden = NO;
                    cell.contentViewTopW.constant = 30;
                    cell.timeLableTop.constant = 65;
                }
                else
                {
                    cell.titleLb.hidden = YES;
                    cell.contentViewTopW.constant = 10;
                    cell.timeLableTop.constant = 45;
                }
                cell.timeLb.text = [MyCommon getTimeWithString:model.ctime];
                [cell.contentLb setAttributedText:model.attStringContent];
                [cell.titleLb setAttributedText:model.attStringTitle];
                cell.titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
                [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"bg__xinwen2-1"]];
                return cell;
            }
                break;
            case GroupSearchType:
            {
                static NSString *identifier = @"ELSameTradeSearchCell";
                ELSameTradeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ELSameTradeSearchCell" owner:self options:nil] lastObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.title.frame = CGRectMake(62,10,ScreenWidth-80,20);
                cell.content.frame = CGRectMake(62,32,ScreenWidth-80,17);
                cell.lineImage.frame = CGRectMake(10,59,ScreenWidth,1);
                cell.expertImage.hidden = YES;
                
                [cell.title setAttributedText:model.attStringTitle];
                cell.content.text = [NSString stringWithFormat:@"社长:%@  |  成员%ld  |  话题%ld",model.person_iname,(long)[model.group_person_cnt integerValue],(long)[model.group_article_cnt integerValue]];
                [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq"]];
                
                
                return cell;
            }
                break;
            case OfferSearchType:
            {
                static NSString *cellStr = @"YLOfferListCtlCell";
                
                YLOfferListCtlCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
                if (cell == nil)
                {
                    cell = [[NSBundle mainBundle]loadNibNamed:cellStr owner:self options:nil][0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.timeBackView.clipsToBounds = YES;
                    cell.timeBackView.layer.borderWidth = 1.0f;
                    cell.timeBackView.layer.cornerRadius = 4.0f;
                    cell.rightImage.hidden = YES;
                    cell.statuImgv.hidden = YES;
                    cell.timeBackView.layer.borderColor = [UIColor colorWithRed:61.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0].CGColor;
                    cell.dateLb.backgroundColor = [UIColor colorWithRed:61.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0];
                    
                    CGRect frame = cell.timeBackView.frame;
                    frame.origin.x = 20;
                    cell.timeBackView.frame = frame;
                    
                    cell.timeBackViewLeftWidth.constant = 12;
                    cell.lineImageLeftWidth.constant = 5;
                }
                OfferPartyTalentsModel *dataModel = model.offerModal;
                cell.weekLb.text = [MyCommon getWeekDay:dataModel.jobfair_time];
                cell.dateLb.text = [dataModel.jobfair_time substringToIndex:10];
                cell.startTimeLb.text = [dataModel.jobfair_time substringFromIndex:11];
                cell.title.attributedText = model.attStringTitle;
                cell.job.attributedText = model.attStringContent;
                cell.address.attributedText = model.attStringDetial;
                
                return cell;
            }
                break;
            case JobSearchType:
            {
                static NSString *CellIdentifier = @"MyJobSearchCtlCell";
                MyJobSearchCtlCell *cell = (MyJobSearchCtlCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"MyJobSearchCtlCell" owner:self options:nil] lastObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                NewJobPositionDataModel *dataModal = model.jobModel;
                [cell cellInitWithImage:dataModal.logo positionName:@"" time:dataModal.updatetime companyName:@"" salary:dataModal.xzdy welfare:dataModal.fldy region:dataModal.regionname gznum:dataModal.gznum edu:dataModal.edus count:dataModal.zpnum  tagColor:dataModal.tagColor isky:[dataModal.is_ky isEqualToString:@"2"]];
                cell.positionNameLb_.text = @"";
                cell.companyNameLb_.text = @"";
                [cell.positionNameLb_ setAttributedText:model.attStringTitle];
                [cell.companyNameLb_ setAttributedText:model.attStringContent];
                return cell;
            }
                break;
            default:
                break;
        }
        
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    else if (indexPath.row == [dataListArr[indexPath.section] count]+1)
    {
        ELTodaySearchMoreCtl *ctl = [[ELTodaySearchMoreCtl alloc] init];
        ELTodaySearchModal *modal = dataListArr[indexPath.section][0];
        ctl.searchType = modal.modelType;
        ctl.keyText = searchBar_.text;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else
    {
        ELTodaySearchModal *model = dataListArr[indexPath.section][indexPath.row-1];
        switch (model.modelType)
        {
            case ExpertSearchType:
            case SameTradeSearchType:
            {
                if (model.personId.length > 0)
                {
                    ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
                    [self.navigationController pushViewController:personCenterCtl animated:YES];
                    [personCenterCtl beginLoad:model.personId exParam:nil];
                }
            }
                break;
            case GroupSearchType:
            {
                if ([model.openstatus isEqualToString:@"3"] && (![model.group_user_rel isEqualToString:@"30"] || ![Manager shareMgr].haveLogin)) {
                    return;
                }
                if (model.group_id.length > 0)
                {
                    Groups_DataModal * dataModal = [[Groups_DataModal alloc] init];
                    dataModal.id_ = model.group_id;
                    dataModal.personCnt_ = [model.group_person_cnt integerValue];
                    dataModal.articleCnt_ = [model.group_article_cnt integerValue];
                    
                    ELGroupDetailCtl *detailCtl_ = [[ELGroupDetailCtl alloc] init];
                    [detailCtl_ beginLoad:dataModal exParam:nil];
                    [self.navigationController pushViewController:detailCtl_ animated:YES];
                    detailCtl_.isMine = YES;
//                    detailCtl_.pushFromMe_ = YES;
                }
            }
                break;
            case ArticleSearchType:
            {
                if (model.article_id.length > 0) {
                    ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
                    [self.navigationController pushViewController:articleDetailCtl animated:YES];
                    Article_DataModal *modal = [[Article_DataModal alloc] init];
                    modal.id_ = model.article_id;
                    [articleDetailCtl beginLoad:modal exParam:nil];
                }
            }
                break;
            case OfferSearchType:
            {
                OfferPartyDetailIndexCtl *offerDetailCtl = [[OfferPartyDetailIndexCtl alloc] init];
                offerDetailCtl.offerPartyModel = model.offerModal;
                offerDetailCtl.resumeComplete = resumeComplete;
                if (model.offerModal.iscome) {
                    offerDetailCtl.isSignUp = YES;
                }
                else
                {
                    offerDetailCtl.isSignUp = NO;
                }
                [self.navigationController pushViewController:offerDetailCtl animated:YES];
                [offerDetailCtl beginLoad:nil exParam:nil];

                
            }
                break;
            case JobSearchType:
            {
                NewJobPositionDataModel *dataModal = model.jobModel;
                if (![dataModal.zptype isEqualToString:@"1"]) {
                    [BaseUIViewController showAlertView:@"" msg:@"该职位已停招" btnTitle:@"关闭"];
                    return;
                }
                ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
                zwVO.zwID_ = dataModal.positionId;
                zwVO.zwName_ = dataModal.jtzw;
                zwVO.companyID_ = dataModal.uid;
                PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
                [self.navigationController pushViewController:detailCtl animated:YES];
                [detailCtl beginLoad:zwVO exParam:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)operationAction
{
    if ([Manager shareMgr].haveLogin) {
        if (!joinCon_) {
            joinCon_ = [self getNewRequestCon:NO];
        }
        [joinCon_ joinGroup:[Manager getUserInfo].userId_ group:groudID content:@" "];
    }else{
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
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

- (IBAction)cancelBtnRespone:(UIButton *)sender
{
    [NBSAppAgent setCustomerData:@"cancle" forKey:@"ELTodayFocusSearchCtl"];
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    tableView_.hidden = NO;
    [searchBar_ resignFirstResponder];
    [self beginLoad:nil exParam:nil];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [tapView removeFromSuperview];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar_.text.length == 0)
    {
        tableView_.hidden = YES;
        searchFinishLb.text = @"";
        canSearchImage.hidden = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar_ resignFirstResponder];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [tableView_ addSubview:tapView];
    return YES;
}

-(UIView *) getNoDataSuperView
{
    return tableView_;
}

-(void) showNoDataOkView:(BOOL)flag
{
    [MyLog Log:[NSString stringWithFormat:@"showNoDataOkView flag=%d",flag] obj:self];
    
    if(flag){
        UIView *noDataOkSuperView = [self getNoDataSuperView];
        UIView *noDataOkView = [self getNoDataView];
        if(noDataOkSuperView && noDataOkView ){
            [noDataOkSuperView addSubview:noDataOkView];
            
            //set the rect
            CGRect rect = noDataOkView.frame;
            rect.origin.x = (int)((noDataOkSuperView.frame.size.width - rect.size.width)/2.0);
            rect.origin.y = 0;
            [noDataOkView setFrame:rect];
        }else{
            [MyLog Log:@"noDataSuperView or noDataView is null,if you want to show noDataOkView, please check it" obj:self];
        }
    }
}


@end
