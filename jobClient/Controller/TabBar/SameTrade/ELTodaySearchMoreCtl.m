//
//  ELTodaySearchMoreCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELTodaySearchMoreCtl.h"
#import "ELSameTradeSearchCell.h"
#import "YLOfferListCtlCell.h"
#import "ELTodayJobSearchCell.h"
#import "YLOfferApplyUrlCtl.h"
#import "ELPersonCenterCtl.h"
#import "SearchGroupArticleCell.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "SameTradeCell.h"
#import "OfferPartyTalentsModel.h"
#import "NewJobPositionDataModel.h"
#import "ELGroupDetailCtl.h"


@interface ELTodaySearchMoreCtl () <UISearchBarDelegate,CondictionChooseDelegate,ConditionItemCtlDelegate,changeJobSearchCondictionDelegate>
{
    IBOutlet UIButton *cancelBtn;
    IBOutlet UISearchBar *searchBar_;
    UIView *tapView;
    
    CondictionList_DataModal        *regionDataModal_;
    CondictionList_DataModal        *tradeDataModal_;
    
    DBTools               *db_;
    
    __weak IBOutlet NSLayoutConstraint *regionBtnW;
    
    __weak IBOutlet NSLayoutConstraint *tradeBtnW;
    
    __weak IBOutlet NSLayoutConstraint *salaryBtnW;
    
    __weak IBOutlet NSLayoutConstraint *moreBtnW;
    
    ELJobSearchCondictionChangeCtl *condictionCtl;
    
    __weak IBOutlet UIImageView *regionIcon;
    
    __weak IBOutlet UIImageView *tradeIcon;
    
    __weak IBOutlet UIImageView *salaryIcon;
    
    __weak IBOutlet UIImageView *screenIcon;
}
@end

@implementation ELTodaySearchMoreCtl


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchBar_.delegate = self;
    searchBar_.hidden = YES;
    [searchBar_ setBackgroundImage:[UIImage imageNamed:@""]];
    [searchBar_ setBackgroundColor:PINGLUNHONG];
    
    [searchBar_ setTintColor:PINGLUNHONG];
    
    self.navigationItem.titleView = searchBar_;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    tapView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tapView addGestureRecognizer:tap];
    searchBar_.showsCancelButton = NO;
    
    searchBar_.text = _keyText;
    
    if (_searchType == JobSearchType)
    {
        self.noDataViewStartY = 40;
        _searchParam = [[SearchParam_DataModal alloc] init];
        NSString *keyWord = [searchBar_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([[Manager shareMgr] haveLogin]) {
            if (![keyWord isEqualToString:@""] &&![keyWord isKindOfClass:[NSNull class]]&&keyWord != nil) {
                if (!db_) {
                    db_ = [[DBTools alloc]init];
                }
                [db_ createTableForSearch];
                [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionStr:_searchParam.regionStr_ tradeStr:_searchParam.tradeStr_];
            }
        }
        
        _colorArr = [NSArray arrayWithObjects:Color1,Color2,Color3,Color4,Color5,Color6,Color1,Color2,Color3,Color4,Color5,Color6,Color1,Color2,Color3,Color4,Color5,Color6,nil];
        NSArray *paymentArray_ = [[NSArray alloc]initWithObjects:@"不限",@"面议",@"3000以下",@"3000及以上",@"5000及以上",@"7000及以上",@"10000及以上",nil];
        NSArray *paymentValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"lt||3000",@"gte||3000",@"gte||5000",@"gte||7000",@"gte||10000",nil];
        _payMentArray = [[NSArray alloc]initWithObjects:paymentArray_,paymentValueArray_, nil];
        
        _searchParam.eduId_ = @"";
        _searchParam.payMentValue_ = @"";
        _searchParam.workAgeValue_ = @"";
        _searchParam.workTypeValue_ = @"";
        _searchParam.workTypeName_ = @"";
        _searchParam.eduName_ = @"";
        _searchParam.payMentName_ = @"";
        _searchParam.timeName_ = @"";
        _searchParam.workAgeName_ = @"";
        _searchParam.tradeId_ = @"1000";
        _searchParam.tradeStr_ = @"所有行业";
        
        CGFloat width = ScreenWidth/4.0;
        regionBtnW.constant = width;
        tradeBtnW.constant = width;
        salaryBtnW.constant = width;
        moreBtnW.constant = width;
        
        tableView_.tableHeaderView = self.searchContentView_;
        
        _searchParam.regionStr_ = [Manager shareMgr].regionName_;
        _searchParam.regionId_ = [CondictionListCtl getRegionId:_searchParam.regionStr_];
        [self setBtnTitle:_searchParam.regionStr_];
    }
    [self beginLoad:nil exParam:nil];
    
    [self hideSuccessDelegate];
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
    }
    return self;
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager getUserInfo].userId_) {
        userId = @"";
    }
    switch (_searchType)
    {
        case ExpertSearchType://行家
        {
             [con getTraderPeson:userId pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ keyWord:[MyCommon removeAllSpace:searchBar_.text] isExpert:@"1" withJobType:0];
        }
            break;
        case SameTradeSearchType://同行
        {
            [con getTraderPeson:userId pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_ keyWord:[MyCommon removeAllSpace:searchBar_.text] isExpert:@"" withJobType:0];
        }
            break;
        case ArticleSearchType://话题
        {
            [con getArticleBySearchKeyword:searchBar_.text page:requestCon_.pageInfo_.currentPage_ pageSize:20];
        }
            break;
        case GroupSearchType://社群
        {
            [con getTodayMoreGroupSearchWithKeyword:[MyCommon removeAllSpace:searchBar_.text] page:requestCon_.pageInfo_.currentPage_ pageSize:20 searchFrom:@"all" useId:nil];
            //[con getGroupsBySearch:userId keyword:[MyCommon removeAllSpace:searchBar_.text] page:requestCon_.pageInfo_.currentPage_ pageSize:15];
        }
            break;
        case OfferSearchType://offer派
        {
            [con getLatelyJobfairList:15 pageIndex:requestCon_.pageInfo_.currentPage_ personId:@"" regionId:@"" keyWord:[MyCommon removeAllSpace:searchBar_.text] fromType:@"fromType" jobId:@""];
        }
            break;
        case JobSearchType://职位
        {
            NSString *keyWord = [searchBar_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            _searchParam.searchKeywords_ = keyWord;
            if ([[Manager shareMgr] haveLogin])
            {
                if (![keyWord isEqualToString:@""] &&![keyWord isKindOfClass:[NSNull class]] && keyWord != nil)
                {
                    if (_searchParam.tradeStr_ == nil || [_searchParam.tradeStr_ isEqualToString:@""])
                    {
                        _searchParam.tradeStr_ = @"所有行业";
                        _searchParam.tradeId_ = @"1000";
                    }
                    if (!db_) {
                        db_ = [[DBTools alloc]init];
                    }
                    [db_ createTableForSearch];
                    [db_ deleteData:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionStr:@"" tradeStr:@""];
                    [db_ insertTableForSearch:[Manager getUserInfo].userId_ searchKeyWords:keyWord regionId:@"" regionStr:@"" tradeId:@"" tradeStr:@"" searchTime:[PreCommon getCurrentDateTime] searchType:[NSString stringWithFormat:@"%ld",(long)_searchParam.searchType_]];
                }
            }
            
            if ([_searchParam.regionId_ isEqualToString:@""] || _searchParam.regionId_ == nil)
            {
                [_regionBtn_ setTitle:@"全国" forState:UIControlStateNormal];
                _searchParam.regionId_ = @"100000";
                _searchParam.regionStr_ = @"全国";
            }
            
            [con getFindJobList:_searchParam.tradeId_ regionId:_searchParam.regionId_ kw:_searchParam.searchKeywords_ time:_searchParam.timeStr_ eduId:_searchParam.eduId_ workAge:_searchParam.workAgeValue_ workAge1:nil payMent:_searchParam.payMentValue_ workType:_searchParam.workTypeValue_ page:requestCon_.pageInfo_.currentPage_ pageSize:20 highlight:@"1"];
        }
            break;
        default:
            break;
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetTraderPeson://同行、行家
        {
            for (ELSameTradePeopleFrameModel *model in dataArr){
                [model changeSearchKeyWord];
            }
            [tableView_ reloadData];
        }
            break;
        case Request_SearchMoreGroupList://社群
        {
            for (ELTodaySearchModal *model in dataArr) {
                if (!model.attStringTitle) {
                    model.attStringTitle = [[NSMutableAttributedString alloc] initWithString:model.group_name];
                    [model.attStringTitle setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
                }
            }
            [tableView_ reloadData];
        }
            break;
        case Request_GetLatelyJobfairList://offer派
        {
            for (OfferPartyTalentsModel *model in dataArr)
            {
                model.attStringTitle = [[NSMutableAttributedString alloc] initWithString:model.jobfair_name];
                [model.attStringTitle setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
                
                model.attStringContent = [[NSMutableAttributedString alloc] initWithString:model.jobfair_zhiwei];
                [model.attStringContent setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
                model.attStringDetial = [[NSMutableAttributedString alloc] initWithString:model.place_name];
                [model.attStringDetial setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
            }
            
            [tableView_ reloadData];
        }
            break;
        case Request_FindJobList://职位
        {
            for (int i = 0; i < [dataArr count]; i++)
            {
                NewJobPositionDataModel *dataModal = [dataArr objectAtIndex:i];
                UIColor *tagColor = [_colorArr objectAtIndex:(i%_colorArr.count)];
                dataModal.tagColor = tagColor;
                dataModal.positionAttstring = [[NSMutableAttributedString alloc] initWithString:dataModal.jtzw];
                [self changeColor:dataModal.positionAttstring withSearchKeyWord:searchBar_.text];
                
                NSString *companyname;
                if (dataModal.cname.length > 0)
                {
                    companyname = dataModal.cname;
                }else
                {
                    companyname = dataModal.cname_all;
                }
                dataModal.companyAttString = [[NSMutableAttributedString alloc] initWithString:companyname];
                [self changeColor:dataModal.companyAttString withSearchKeyWord:searchBar_.text];
            }
            [tableView_ reloadData];
        }
            break;
        case Request_SearchMoreArticleList: //话题
        {
            for (ELTodaySearchModal *dataModal in dataArr)
            {
                dataModal.attStringContent = [dataModal.summary getHtmlAttStringWithFont:FOURTEENFONT_CONTENT color:GRAYCOLOR];
               [dataModal.attStringContent setChangeKeyWord:searchBar_.text color:[UIColor redColor]];
            }
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_searchType)
    {
        case ExpertSearchType:
        case SameTradeSearchType:
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
            break;
        case ArticleSearchType:
        {
            ELTodaySearchModal *model = requestCon_.dataArr_[indexPath.row];
            static NSString *CellIdentifier = @"SearchGroupArticleCell";
            SearchGroupArticleCell *cell = (SearchGroupArticleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchGroupArticleCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.titleLb setFont:FIFTEENFONT_TITLE];
                [cell.titleLb setTextColor:BLACKCOLOR];
                [cell.contentLb setFont:FOURTEENFONT_CONTENT];
                [cell.contentLb setTextColor:GRAYCOLOR];
                cell.titleImage.frame = CGRectMake(20,10,72,52);
                cell.titleLb.frame = CGRectMake(98,8,ScreenWidth-110,15);
            }
            if (model.title.length > 0)
            {
                cell.titleLb.hidden = NO;
                cell.lineImage.frame = CGRectMake(10,94,ScreenWidth,1);
                cell.contentLb.frame = CGRectMake(98,30,ScreenWidth-110,30);
                cell.timeLb.frame = CGRectMake(98,65,ScreenWidth-110,20);
            }
            else
            {
                cell.titleLb.hidden = YES;
                cell.lineImage.frame = CGRectMake(10,74,ScreenWidth,1);
                cell.contentLb.frame = CGRectMake(98,10,ScreenWidth-110,30);
                cell.timeLb.frame = CGRectMake(98,45,ScreenWidth-110,20);
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
                cell.personImage.clipsToBounds = YES;
                cell.personImage.layer.cornerRadius = 3.0;
                cell.personImage.frame = CGRectMake(10,12,35,35);
                cell.expertImage.frame = CGRectMake(52,13,13,14);
                cell.content.frame = CGRectMake(52,32,ScreenWidth-70,17);
                cell.lineImage.frame = CGRectMake(-10,59,ScreenWidth+10,1);
            }
            ELTodaySearchModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            cell.title.frame = CGRectMake(52,10,ScreenWidth-70,20);
            cell.expertImage.hidden = YES;
            
            cell.content.text = [NSString stringWithFormat:@"社长:%@  |  成员:%ld  |  话题:%ld",dataModal.person_iname,(long)[dataModal.group_person_cnt integerValue],(long)[dataModal.group_article_cnt integerValue]];
            cell.title.attributedText = dataModal.attStringTitle;
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:dataModal.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq"]];
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
                frame.origin.x = 10;
                cell.timeBackView.frame = frame;
                
                cell.title.frame = CGRectMake(94,6,ScreenWidth-112,23);
                cell.job.frame = CGRectMake(94,29,ScreenWidth-112,15);
                cell.address.frame = CGRectMake(94,46,ScreenWidth-112,15);
                cell.lineImage.frame = CGRectMake(-10,68,ScreenWidth+10,1);
            }
             OfferPartyTalentsModel *dataModel = requestCon_.dataArr_[indexPath.row];
             cell.weekLb.text = [MyCommon getWeekDay:dataModel.jobfair_time];
             cell.dateLb.text = [dataModel.jobfair_time substringToIndex:10];
             cell.startTimeLb.text = [dataModel.jobfair_time substringFromIndex:11];
             cell.title.attributedText = dataModel.attStringTitle;
             cell.job.attributedText = dataModel.attStringContent;
             cell.address.attributedText = dataModel.attStringDetial;
             return cell;
        }
            break;
        case JobSearchType:
        {
            static NSString *CellIdentifier = @"ELTodayJobSearchCell";
            ELTodayJobSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ELTodayJobSearchCell" owner:self options:nil] lastObject];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.jobImage.frame = CGRectMake(10,12,68,42);
                cell.speedLb.frame = CGRectMake(50,46,28,8);
                cell.jobSalary.frame = CGRectMake(86,36,ScreenWidth-103,12);
                cell.jobCompany.frame = CGRectMake(86,56,ScreenWidth-105,12);
                cell.lineImage.frame = CGRectMake(-10,79,ScreenWidth+10,1);
            }
            NewJobPositionDataModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            
            [cell.jobImage sd_setImageWithURL:[NSURL URLWithString:dataModal.logo] placeholderImage:nil];
            NSString *salary_ = dataModal.xzdy;
            salary_ = [salary_ stringByReplacingOccurrencesOfString:@"--" withString:@"-"];
            salary_ = [salary_ stringByReplacingOccurrencesOfString:@" 年薪" withString:@""];
            salary_ = [salary_ stringByReplacingOccurrencesOfString:@" 月薪" withString:@""];
            salary_ = [salary_ stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            
            if ([salary_ isEqualToString:@"面议"]) {
                [cell.jobSalary setText:salary_];
            }else{
                [cell.jobSalary setText:[NSString stringWithFormat:@"￥%@",salary_]];
            }
            
            NSString *region_ = dataModal.regionname;
            NSArray *regionArray = [region_ componentsSeparatedByString:@"-"];
            if ([regionArray count] == 2) {
                region_ = [regionArray objectAtIndex:1];
            }else{
                region_ = [regionArray objectAtIndex:0];
            }
            
            CGSize size = [region_ sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] constrainedToSize:CGSizeMake(65, 0)];
            if (size.width < 20) {
                size.width = 20;
            }
            CGRect regionRect = cell.jobRegion.frame;
            regionRect.size.width = size.width + 3;
            regionRect.origin.x = cell.frame.size.width - regionRect.size.width - 15;
            [cell.jobRegion setFrame:regionRect];
            [cell.jobRegion setText:region_];
            if ([dataModal.is_ky isEqualToString:@"2"]) {
                [cell.speedLb setHidden:NO];
            }else{
                [cell.speedLb setHidden:YES];
            }
            if ([dataModal.logo isEqualToString:@"http://img3.job1001.com/uppic/nocypic.gif"])
            {
                [cell.jobImage setImage:[UIImage imageNamed:@"positionDefaulLogo.png"]];
            }
            cell.jobName.text = @"";
            cell.jobCompany.text = @"";
            [cell.jobName setAttributedText:dataModal.positionAttstring];
            [cell.jobCompany setAttributedText:dataModal.companyAttString];
            cell.jobName.frame = CGRectMake(86,12,ScreenWidth-110-cell.jobRegion.frame.size.width,14);
            
            return cell;
        }
            break;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_searchType) {
        case ExpertSearchType:
        case SameTradeSearchType:
        {
            return 93.0f;
        }
            break;
        case GroupSearchType:
        {
            return 60.0;
        }
            break;
            
        case ArticleSearchType:
        {
            ELTodaySearchModal *model = requestCon_.dataArr_[indexPath.row];
            if (model.title.length > 0)
            {
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
            return 82.0;
        }
            break;
        default:
            break;
    }
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_searchType) {
        case ExpertSearchType:
        case SameTradeSearchType:
        {
            ELSameTradePeopleFrameModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            ELPersonCenterCtl *personCenterCtl = [[ELPersonCenterCtl alloc] init];
            [self.navigationController pushViewController:personCenterCtl animated:YES];
            [personCenterCtl beginLoad:model.peopleModel.personId exParam:nil];
        }
            break;
        case ArticleSearchType:
        {
            ELTodaySearchModal *model = requestCon_.dataArr_[indexPath.row];
            if (model.article_id.length > 0) {
                ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
                [self.navigationController pushViewController:articleDetailCtl animated:YES];
                Article_DataModal *modal = [[Article_DataModal alloc] init];
                modal.id_ = model.article_id;
                [articleDetailCtl beginLoad:modal exParam:nil];
            }
        }
            break;
        case GroupSearchType:
        {
            ELTodaySearchModal *model = requestCon_.dataArr_[indexPath.row];
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
//                detailCtl_.pushFromMe_ = YES;
            }
        }
            break;
        case OfferSearchType:
        {
            YLOfferApplyUrlCtl *ctl = [[YLOfferApplyUrlCtl alloc] init];
            ctl.modal = requestCon_.dataArr_[indexPath.row];
            ctl.resumeComplete = _resumeComplete;
            [self.navigationController pushViewController:ctl animated:YES];
            [ctl beginLoad:nil exParam:nil];
        }
            break;
        case JobSearchType:
        {
            ZWDetail_DataModal *zwVO = [ZWDetail_DataModal new];
            NewJobPositionDataModel *dataModal = requestCon_.dataArr_[indexPath.row];
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


-(void)changeColor:(NSMutableAttributedString *)attString withSearchKeyWord:(NSString *)text
{
    NSString *fontLeft = @"<font color=red>";
    NSString *fontRight = @"</font>";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if ([attString.string containsString:fontLeft])
    {
        NSInteger startIndex = 10000;
        BOOL saveString = NO;
        
        for (NSInteger i = 0; i<attString.string.length;)
        {
            NSString *string = [attString.string substringFromIndex:i];
            NSString *str = @"";
            if (saveString && [string containsString:fontRight])
            {
                str = [attString.string substringWithRange:NSMakeRange(i,fontRight.length)];
            }
            else if([string containsString:fontLeft])
            {
                str = [attString.string substringWithRange:NSMakeRange(i,fontLeft.length)];
            }
            
            if ([str isEqualToString:fontLeft])
            {
                [arr addObject:[NSValue valueWithRange:NSMakeRange(i,fontLeft.length)]];
                i += (fontLeft.length);
                startIndex = i;
                saveString = YES;
            }
            else if([str isEqualToString:fontRight] && startIndex < i)
            {
                [arr addObject:[NSValue valueWithRange:NSMakeRange(i,fontRight.length)]];
                
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(startIndex,i-startIndex)];
                i += (fontRight.length);
                startIndex = 100000;
                saveString = NO;
            }
            else
            {
                i++;
            }
        }
    }else if ([attString.string rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound){
            for (NSInteger i = 0; i<=(attString.string.length-text.length) ;i++)
            {
                NSString *str = [attString.string substringWithRange:NSMakeRange(i,text.length)];
                if ([str rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
                {
                    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i,text.length)];
                }
            }
    }
    
    for (NSInteger i = arr.count-1;i>=0; i--)
    {
        [attString replaceCharactersInRange:[arr[i] rangeValue] withString:@""];
    }
}


-(void)tap:(UITapGestureRecognizer *)sender
{
    [searchBar_ resignFirstResponder];
    [tapView removeFromSuperview];
}

- (IBAction)cancelBtnRespone:(UIButton *)sender
{
    [searchBar_ resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar_ resignFirstResponder];
    [condictionCtl hideView];
    [self refreshLoad:nil];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [tapView removeFromSuperview];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar_ resignFirstResponder];
    [condictionCtl hideView];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [tableView_ addSubview:tapView];
    return YES;
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
    if (condictionCtl) {
        [condictionCtl hideView];
    }
}

-(void)creatChangeCtlType:(CondictionChangeType)type modal:(id)modal withButton:(UIButton *)sender withImage:(UIImageView *)image{
    if (!condictionCtl)
    {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,104,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 104)];
        condictionCtl.delegate_ = self;
        [condictionCtl setBackViewBlackColor];
    }
    if(condictionCtl.currentType == type)
    {
        [condictionCtl hideView];
        return;
    }
    [condictionCtl hideView];
    [condictionCtl creatViewWithType:type selectModal:modal];
    [condictionCtl showView];
    [sender setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    image.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
}

-(void)btnResponse:(id)sender
{
    if( sender == _regionBtn_ )
    {
        SqlitData *data = [[SqlitData alloc] init];
        data.provinceld = _searchParam.regionId_;
        [self creatChangeCtlType:RegionChange modal:data withButton:_regionBtn_ withImage:regionIcon];
    }
    else if (sender == _tradeBtn)
    {
        [self creatChangeCtlType:TradeChange modal:tradeDataModal_ withButton:_tradeBtn withImage:tradeIcon];
    }
    else if (sender == _salaryBtn)
    {
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.id_ = _searchParam.payMentValue_;
        modal.str_ = _searchParam.payMentName_;        
        [self creatChangeCtlType:SalaryMonthChange modal:modal withButton:_salaryBtn withImage:salaryIcon];
    }
    else if (sender == _screenBtn)
    {
        [self creatChangeCtlType:MoreChange modal:_searchParam withButton:_screenBtn withImage:screenIcon];
    }
}

-(void)hideSuccessDelegate{
    [_regionBtn_ setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_tradeBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_salaryBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_screenBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    regionIcon.image = [UIImage imageNamed:@"小筛选下拉more"];
    tradeIcon.image = [UIImage imageNamed:@"小筛选下拉more"];
    salaryIcon.image = [UIImage imageNamed:@"小筛选下拉more"];
    screenIcon.image = [UIImage imageNamed:@"小筛选下拉more"];
}

-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case RegionChange:
        {
            SqlitData *modal = (SqlitData *)dataModel;
            [self chooseCityToSearch:modal];
        }
            break;
        case TradeChange:
        {
            tradeDataModal_ = (CondictionList_DataModal *)dataModel;
            if( !tradeDataModal_ || tradeDataModal_.id_ == nil ){
                [_tradeBtn setTitle:@"所有行业" forState:UIControlStateNormal];
                _searchParam.tradeId_ = @"1000";
                _searchParam.tradeStr_ = @"所有行业";
            }else{
                [_tradeBtn setTitle:tradeDataModal_.str_ forState:UIControlStateNormal];
                _searchParam.tradeId_ = tradeDataModal_.id_;
                _searchParam.tradeStr_ = tradeDataModal_.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        case SalaryMonthChange:
        {
            CondictionList_DataModal *modal = (CondictionList_DataModal *)dataModel;
            _searchParam.payMentValue_ = modal.id_;
            _searchParam.payMentName_ = modal.str_;
            if ([modal.id_ isEqualToString:@"lt||3000"]) {
                [_salaryBtn setTitle:@"3000以下" forState:UIControlStateNormal];
            }else if ([modal.id_ isEqualToString:@"gte||3000"]) {
                [_salaryBtn setTitle:@"3000以上" forState:UIControlStateNormal];
            }else if ([modal.id_ isEqualToString:@"gte||5000"]) {
                [_salaryBtn setTitle:@"5000以上" forState:UIControlStateNormal];
            }else if ([modal.id_ isEqualToString:@"gte||7000"]){
                [_salaryBtn setTitle:@"7000以上" forState:UIControlStateNormal];
            }else if ([modal.id_ isEqualToString:@"gte||10000"]){
                [_salaryBtn setTitle:@"10000" forState:UIControlStateNormal];
            }else{
                [_salaryBtn setTitle:_searchParam.payMentName_ forState:UIControlStateNormal];
            }
            [self refreshLoad:nil];
        }
            break;
        case MoreChange:
        {
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}


#pragma mark 行业选择回调
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetTradeType:
        {
            tradeDataModal_ = dataModal;
            if( !tradeDataModal_ || tradeDataModal_.id_ == nil ){
                [_tradeBtn setTitle:@"所有行业" forState:UIControlStateNormal];
                _searchParam.tradeId_ = @"1000";
                _searchParam.tradeStr_ = @"所有行业";
            }else{
                [_tradeBtn setTitle:tradeDataModal_.str_ forState:UIControlStateNormal];
                _searchParam.tradeId_ = tradeDataModal_.id_;
                _searchParam.tradeStr_ = tradeDataModal_.str_;
            }
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark-月薪条件回调
- (void)conditionSeletedOK:(conditionType)type conditionName:(NSString *)conditionName conditionValue:(NSString *)conditionValue conditionValue1:(NSString *)conditionValue1
{
    switch (type) {
        case condition_PayMent:
            _searchParam.payMentValue_ = conditionValue;
            _searchParam.payMentName_ = conditionName;
            if ([conditionValue isEqualToString:@"lt||3000"]) {
                [_salaryBtn setTitle:@"3000以下" forState:UIControlStateNormal];
            }else if ([conditionValue isEqualToString:@"gte||3000"]) {
                [_salaryBtn setTitle:@"3000以上" forState:UIControlStateNormal];
            }else if ([conditionValue isEqualToString:@"gte||5000"]) {
                [_salaryBtn setTitle:@"5000以上" forState:UIControlStateNormal];
            }else if ([conditionValue isEqualToString:@"gte||7000"]){
                [_salaryBtn setTitle:@"7000以上" forState:UIControlStateNormal];
            }else if ([conditionValue isEqualToString:@"gte||10000"]){
                [_salaryBtn setTitle:@"10000" forState:UIControlStateNormal];
            }else{
                [_salaryBtn setTitle:_searchParam.payMentName_ forState:UIControlStateNormal];
            }
            [self refreshLoad:nil];
            break;
        default:
            break;
    }
}

- (void)conditionSelectedOK:(SearchParam_DataModal *)searchParam
{
    _searchParam = searchParam;
    [self refreshLoad:nil];
    [self changConditionLbView];
}

- (void)changConditionLbView
{
    NSString *tempString = @"";
    if (_searchParam.workAgeName_ != nil && ![_searchParam.workAgeName_ isEqualToString:@"不限"] && ![_searchParam.workAgeName_ isEqualToString:@""]) {
        tempString = _searchParam.workAgeName_;
    }
    if (_searchParam.timeName_ != nil && ![_searchParam.timeName_ isEqualToString:@"所有日期"] && ![_searchParam.timeName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, _searchParam.timeName_];
        }else{
            tempString = _searchParam.timeName_;
        }
    }
    if (_searchParam.eduName_ != nil && ![_searchParam.eduName_ isEqualToString:@"不限"] && ![_searchParam.eduName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, _searchParam.eduName_];
        }else {
            tempString = _searchParam.eduName_;
        }
    }
    if (_searchParam.workTypeName_ != nil && ![_searchParam.workTypeName_ isEqualToString:@"不限"] && ![_searchParam.workTypeName_ isEqualToString:@""]) {
        if (![tempString isEqualToString:@""]) {
            tempString = [NSString stringWithFormat:@"%@-%@",tempString, _searchParam.workTypeName_];
        }else{
            tempString = _searchParam.workTypeName_;
        }
    }
}

- (void)chooseCityToSearch:(SqlitData *)regionModel
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = regionModel.provinceName;
    dataModal.id_ = regionModel.provinceld;
    
    regionDataModal_ = dataModal;
    
    //地区参数添加道搜索参数
    _searchParam.regionStr_ = dataModal.str_;
    _searchParam.regionId_ = dataModal.id_;
    
    [self setBtnTitle:_searchParam.regionStr_];
    //地区参数改变后自动请求
    [self refreshLoad:nil];
}

-(void)setBtnTitle:(NSString*)str
{
    if (str.length >= 3) {
        [_regionBtn_ setTitle:[str substringWithRange:NSMakeRange(0, 3)] forState:UIControlStateNormal];
    }else{
        [_regionBtn_ setTitle:str forState:UIControlStateNormal];
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
