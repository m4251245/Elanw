//
//  RecruitmentCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-27.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "RecruitmentCtl.h"
#import "Xjh_Zph_DataModal.h"
#import "FreshCtl_Cell.h"
#import "JobFairDetailCtl.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "NewCareerTalkDataModal.h"

#define TODAYCOLOR [UIColor colorWithRed:61.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0]
#define OTHERCOLOR [UIColor colorWithRed:125.0/255.0 green:147.0/255.0 blue:166.0/255.0 alpha:1.0]

@interface RecruitmentCtl () <changeJobSearchCondictionDelegate,UISearchBarDelegate>
{
    ELJobSearchCondictionChangeCtl *condictionCtl;
    
    __weak IBOutlet UIButton *regionChangeBtn;
    
    __weak IBOutlet UIButton *timeChangeBtn;
    
    CondictionList_DataModal *timeChangeModel;
    UIView *bgView;
    CondictionList_DataModal *regionChangeModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *reginImg;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@end

@implementation RecruitmentCtl

-(id)init
{
    self = [super init];
    
    bFooterEgo_ = YES;
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserVer];
//    self.navigationItem.title = @"招聘会";
    [self setNavTitle:@"招聘会"];
    regionChangeModel = [CondictionList_DataModal new];
    NSString *str =  [MMLocationManager shareLocation].lastProvince;
    if (!str || [str isEqual:[NSNull null]] || str == nil)
    {
        [regionChangeBtn setTitle:@"全国" forState:UIControlStateNormal];
    }
    else
    {
        [regionChangeBtn setTitle:str forState:UIControlStateNormal];
    }
    tableView_.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    tableView_.backgroundView = nil;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchBar.delegate = self;
    _searchBar.tintColor = UIColorFromRGB(0xe13e3e);
    [self configUI];
    
    //无数据是ImageView的顶部距离
    self.imgTopSpace = 80;
}

-(void)configUI{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 108 + 44, ScreenWidth, ScreenHeight - 64 - 44 - 44)];
    bgView.backgroundColor = UIColorFromRGB(0x000000);
    bgView.alpha = 0.4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
}

-(void)viewDidDisappear:(BOOL)animated{
    bgView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--通知
-(void)addObserVer{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moreCacel:) name:@"moreCacel" object:nil];
}

-(void)moreCacel:(NSNotification *)notyfi{
    bgView.hidden = YES;
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [_searchBar setText:@""];
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString *locStr = nil;
    if (regionChangeBtn.titleLabel.text.length > 0) {
        locStr = regionChangeBtn.titleLabel.text;
    }else{
        locStr =  [MMLocationManager shareLocation].lastProvince;
    }
    if ([locStr containsString:@"省"]) {
        locStr = [locStr stringByReplacingOccurrencesOfString:@"省" withString:@""];
    }
    NSString * idstr = [CondictionListCtl getRegionId:locStr];
    NSString *timeId = @"";
    if (timeChangeModel.id_.length > 0)
    {
        timeId = timeChangeModel.id_;
    }
    [con getZphList:idstr pagesize:10 pageindex:requestCon_.pageInfo_.currentPage_ kw:_searchBar.text timeType:timeId dateType:@"40"];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_ZphList:
        {
            for (NewCareerTalkDataModal *zphVO in dataArr) {
                zphVO.weekday = [MyCommon getWeekDay:zphVO.sdate];
            }
        }
            break;

        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    
    FreshCtl_Cell *cell = (FreshCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Campus_Xjh_Cell" owner:self options:nil] lastObject];
        cell.dateView_.layer.cornerRadius = 4.0;
        [cell.dateView_.layer setMasksToBounds:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        UIView *cellBgView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView = cellBgView;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    NewCareerTalkDataModal *zphVO = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    cell.titleLb_.text = [MyCommon translateHTML:zphVO.title];
    cell.dateLb_.text = [zphVO.sdate substringToIndex:10];
    cell.weekdayLb_.text = zphVO.weekday;
    cell.timeLb_.text = [zphVO.sdate substringFromIndex:11];
    cell.schoolLb_.text = [MyCommon translateHTML:zphVO.sname];
    if(!zphVO.sname || [zphVO.sname isEqualToString:@""]){
        cell.schoolLb_.text = zphVO.addr;
    }
    
    
    NSString *todayString = [[MyCommon getNowTime] substringToIndex:10];
    cell.dateView_.clipsToBounds = YES;
    cell.dateView_.layer.borderWidth = 0.5;
    
    if ([todayString isEqualToString:cell.dateLb_.text]) {
//        cell.bgColor.backgroundColor = TODAYCOLOR;
        cell.bgColor.image = [UIImage createImageWithColor:TODAYCOLOR];
        cell.dateView_.layer.borderColor = TODAYCOLOR.CGColor;
    }
    else
    {
//        cell.bgColor.backgroundColor = OTHERCOLOR;
        cell.bgColor.image = [UIImage createImageWithColor:OTHERCOLOR];
        cell.dateView_.layer.borderColor = OTHERCOLOR.CGColor;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_searchBar resignFirstResponder];
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    NewCareerTalkDataModal * dataModal = selectData;
    
    dataModal.type = 1;

    JobFairDetailCtl *detailCtl = [[JobFairDetailCtl alloc]init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:dataModal exParam:exParam];
}

-(void)btnResponse:(id)sender
{
    [_searchBar resignFirstResponder];
    if (sender == regionBtn_)
    {
        if (![Manager shareMgr].regionListCtl_) {
            [Manager shareMgr].regionListCtl_ = [[RegionCtl alloc] init];
        }
        [self.navigationController pushViewController:[Manager shareMgr].regionListCtl_ animated:YES];
        [[Manager shareMgr].regionListCtl_ beginLoad:nil exParam:nil];
        [Manager shareMgr].regionListCtl_.delegate_ = self;
    }
    else if (sender == searchBtn_) {
        
        [self refreshLoad:nil];
    }
    else if (sender == regionChangeBtn)
    {
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,148,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 148)];
            condictionCtl.delegate_ = self;
        }
        if(condictionCtl.currentType == XJHRegionChange)
        {
            
            [condictionCtl hideView];
            bgView.hidden = YES;
            return;
        }
        
        [condictionCtl hideView];
        bgView.hidden = YES;
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        NSString *regiontitle = regionChangeBtn.titleLabel.text;
        if ([regiontitle containsString:@"省"])
        {
            regiontitle = [regiontitle stringByReplacingOccurrencesOfString:@"省" withString:@""];
        }
        NSString * idstr = [CondictionListCtl getRegionId:regiontitle];
        modal.id_ = idstr;
        modal.str_ = regiontitle;
        modal.bParent_ = regionChangeModel.bParent_;
        modal.bSelected_ = regionChangeModel.bSelected_;
        [condictionCtl creatViewWithType:XJHRegionChange selectModal:modal];
        [condictionCtl showView];
        bgView.hidden = NO;
    }
    else if (sender == timeChangeBtn)
    {
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,148,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 148)];
            condictionCtl.delegate_ = self;
        }
        if(condictionCtl.currentType == XJHTimeChange)
        {
            
            [condictionCtl hideView];
            bgView.hidden = YES;
            return;
        }
        
        [condictionCtl hideView];
        bgView.hidden = YES;
        CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
        modal.str_ = timeChangeBtn.titleLabel.text;
        [condictionCtl creatViewWithType:XJHTimeChange selectModal:modal];
        [condictionCtl showView];
        bgView.hidden = NO;
    }
}

#pragma CondictionListDelegate
-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal
{
    if( !dataModal ){
        dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.str_ = @"全国";
    }
    
    switch ( ctl.type_ ) {
        case CondictionType_Region:
        {
            [regionBtn_ setTitle:dataModal.str_ forState:UIControlStateNormal];
            
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}
#pragma ChooseHotCityDelegate
-(void)chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    [regionBtn_ setTitle:city forState:UIControlStateNormal];
    [self refreshLoad:nil];
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    [_searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = [MyCommon removeAllSpace:searchBar.text];
    [self refreshLoad:nil];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    if (condictionCtl)
    {
        [condictionCtl hideView];
    }
    if (!bgView.hidden) {
        bgView.hidden = YES;
    }
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
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
}
-(void)hideKeyboard
{
    [_searchBar resignFirstResponder];
}

-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType) {
        case XJHRegionChange:
        {
            bgView.hidden = YES;
            CondictionList_DataModal *modal = (CondictionList_DataModal *)dataModel;
            [regionChangeBtn setTitle:modal.str_ forState:UIControlStateNormal];
            regionChangeModel.str_ = modal.str_;
            regionChangeModel.id_ = modal.id_;
            regionChangeModel.bSelected_ = modal.bSelected_;
            regionChangeModel.bParent_ = modal.bParent_;
            [self refreshLoad:nil];
        }
            break;
        case XJHTimeChange:
        {
            bgView.hidden = YES;
            CondictionList_DataModal *modal = (CondictionList_DataModal *)dataModel;
            [timeChangeBtn setTitle:modal.str_ forState:UIControlStateNormal];
            timeChangeModel = modal;
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bgView.hidden = YES;
    if (condictionCtl)
    {
        [condictionCtl hideView];
    }
}

-(void)dealloc{
    [bgView removeFromSuperview];
}

@end
