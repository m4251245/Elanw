//
//  YLOfferListCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/7/22.
//  Copyright (c) 2015年 YL1001. All rights reserved.

//

#import "YLOfferListCtl.h"
#import "YLOfferListCtlCell.h"
#import "YLOfferApplyUrlCtl.h"
#import "OfferPartyDetailIndexCtl.h"
#import "MyOfferPartyIndexCtl.h"
#import "OfferPartyDetailIndexCtl.h"
#import "ELJobSearchCondictionChangeCtl.h"
#import "OfferPartyTalentsModel.h"
#import "ResumeCompleteModel.h"

@interface YLOfferListCtl () <ChooseHotCityDelegate, UITextFieldDelegate,changeJobSearchCondictionDelegate>
{
    RequestCon *resumeCon;
    BOOL resumeComplete;
    IBOutlet UIButton   * searchBtn_;
    IBOutlet UIButton   * regionBtn_;
    ELJobSearchCondictionChangeCtl  *condictionCtl;
    BOOL againRefreshList;
    
    CondictionList_DataModal *regionModal;
}
@end

@implementation YLOfferListCtl

-(void)dealloc{
    [_bgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        bHeaderEgo_ = YES;
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Offer派";
    _keywordsTF.tintColor = UIColorFromRGB(0xe13e3e);
    [self addObserVer];
    // Do any additional setup after loading the view from its nib.
    NSString *str = [Manager shareMgr].regionName_;
    if (!str || [str isEqual:[NSNull null]] || str == nil)
    {
        str = @"全国";
    }
    
    [regionBtn_ setTitle:str forState:UIControlStateNormal];
    CALayer *layer = regionBtn_.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f].CGColor;
    layer = _jobBtn.layer;
    layer.borderWidth = 0.5;
    layer.borderColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f].CGColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUp:) name:@"MyOfferPartyDetailCtlSignUpOfferParty" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUp:) name:@"YLOfferApplyUrlCtlSignUpOfferParty" object:nil];
    
    if (!condictionCtl)
    {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,153,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 153)];
        condictionCtl.delegate_ = self;
    }
    [self configUI];
}

-(void)configUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 89, ScreenWidth, ScreenHeight - 64 - 89)];
    _bgView.backgroundColor = UIColorFromRGB(0x000000);
    _bgView.alpha = 0.4;
    _bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
}

- (void)refreshSignUp:(NSNotification *)notification
{
    [self refreshLoad:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([Manager shareMgr].haveLogin)
    {
        if (!resumeCon) {
            resumeCon = [self getNewRequestCon:NO];
        }
        [resumeCon getResumeComplete:[Manager getUserInfo].userId_];
    }
    self.navigationItem.title = @"Offer派";
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.title = @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

#pragma mark--通知
-(void)addObserVer{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moreCacel:) name:@"moreCacel" object:nil];
}

-(void)moreCacel:(NSNotification *)notyfi{
    _bgView.hidden = YES;
}


#pragma mark--数据请求
-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:NO];
    }
    
    NSString * idstr = @"";//地区
    if (regionModal) {
        idstr = regionModal.id_;
    }
    else
    {
        idstr = [CondictionListCtl getRegionId:regionBtn_.titleLabel.text];
    }
    
    NSString *kword = @"";//搜索关键词
    if ([MyCommon removeAllSpace:_keywordsTF.text].length > 0) {
        kword = [MyCommon removeAllSpace:_keywordsTF.text];
    }
    
    NSString *jobId = @"";//职位关键词
    if (_selectJob) {
        jobId = _selectJob.tagId_;
    }
    
    if ([Manager shareMgr].haveLogin)
    {
        [con getLatelyJobfairList:15 pageIndex:requestCon_.pageInfo_.currentPage_ personId:[Manager getUserInfo].userId_ regionId:idstr keyWord:kword fromType:@"offer" jobId:jobId];
    }
    else
    {
        [con getLatelyJobfairList:15 pageIndex:requestCon_.pageInfo_.currentPage_ personId:@" " regionId:idstr keyWord:kword fromType:@"offer" jobId:jobId];
    }
//    请求地区
    [self requestZone];
//    请求所有岗位
    [self requestAllJobs];
}

-(void)requestZone{
    
    NSMutableArray * offerRegionArr = [[NSMutableArray alloc] init];
    CondictionList_DataModal *dataModalOne = [[CondictionList_DataModal alloc] init];
    dataModalOne.id_ = @"";
    dataModalOne.str_ = @"全国";
    [offerRegionArr addObject:dataModalOne];
    
    [ELRequest postbodyMsg:@"" op:@"offerpai_busi" func:@"getAllRegionNameArr" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         NSDictionary *dicOne = result[@"data"];
         for (NSString *key in dicOne)
         {
             NSDictionary *dicTwo = dicOne[key];
             NSString *str = dicTwo[@"regionName"];
             if ([str containsString:@"上海"] || [str containsString:@"北京"] ||[str containsString:@"天津"]  || [str containsString:@"重庆"]) {
                 CondictionList_DataModal *modalOne = [[CondictionList_DataModal alloc] init];
                 modalOne.str_ = dicTwo[@"regionName"];
                 modalOne.id_ = dicTwo[@"regionid"];
                 [offerRegionArr addObject:modalOne];
             }else{
                 NSArray *arr = dicOne[key][@"shi"];
                 if ([arr isKindOfClass:[NSArray class]])
                 {
                     for (NSDictionary *subDic in arr)
                     {
                         CondictionList_DataModal *modalOne = [[CondictionList_DataModal alloc] init];
                         modalOne.str_ = subDic[@"regionName"];
                         modalOne.id_ = subDic[@"regionid"];
                         [offerRegionArr addObject:modalOne];
                     }
                 }
             }
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"offerPaiZoneSel" object:@(1) userInfo:@{@"offerPaiZone" : offerRegionArr}];
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         
     }];
}

-(void)requestAllJobs{
    NSMutableArray * offerJobArr = [[NSMutableArray alloc] init];
    [ELRequest postbodyMsg:@"" op:@"offerpai_busi" func:@"getClassifyArr" requestVersion:YES progressFlag:NO progressMsg:@"" success:^(NSURLSessionDataTask *operation, NSDictionary *result) {
        
        personTagModel *model = [[personTagModel alloc] init];
        model.tagId_ = @"";
        model.tagName_ = @"所有岗位";
        [offerJobArr addObject:model];
        
        [result enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            personTagModel *tag = [[personTagModel alloc]init];
            tag.tagId_ = key;
            tag.tagName_ = obj;
            [offerJobArr addObject:tag];
            
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"offerPaiZoneSel" object:@(2) userInfo:@{@"offerPaiZone" : offerJobArr}];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
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
        case Request_GetLatelyJobfairList://最近的offer派
        {
            if (!againRefreshList)
            {
                againRefreshList = YES;
                if (requestCon_.dataArr_.count <= 0 && ![regionBtn_.titleLabel.text isEqualToString:@"全国"])
                {
                    [self getNoDataView].hidden = YES;
                    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                    dispatch_after(time, dispatch_get_main_queue(), ^{
                        //在指定时间后,要做的事情
                        [regionBtn_ setTitle:@"全国" forState:UIControlStateNormal];
                        [self refreshLoad:nil];
                        [self getNoDataView].hidden = NO;
                    });
                    return;
                }
            }
            self.noDataTips = @"当前区域暂未有offer派，敬请期待";
            self.noDataImgStr = @"img_search_noData.png";
            self.imgTopSpace = 68;
        }
            break;
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    cell.title.text = dataModel.jobfair_name;
    cell.job.text = dataModel.jobfair_zhiwei;
    cell.address.text = dataModel.place_name;
   
    if (dataModel.iscome){
        cell.statuImgv.hidden = NO;
        cell.statuImgv.image = [UIImage imageNamed:@"op_sign_in.png"];
        cell.timeBackView.layer.borderColor = UIColorFromRGB(0xe79945).CGColor;
        cell.dateLb.backgroundColor = UIColorFromRGB(0xe79945);
    }
    else if (dataModel.isjoin) {
        cell.statuImgv.hidden = NO;
        cell.statuImgv.image = [UIImage imageNamed:@"op_applyed.png"];
        cell.timeBackView.layer.borderColor = UIColorFromRGB(0xe74845).CGColor;
        cell.dateLb.backgroundColor = UIColorFromRGB(0xe74845);
    }
    else{
        cell.statuImgv.hidden = YES;
        cell.timeBackView.layer.borderColor = [UIColor colorWithRed:61.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0].CGColor;
        cell.dateLb.backgroundColor = [UIColor colorWithRed:61.0/255.0 green:176.0/255.0 blue:170.0/255.0 alpha:1.0];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if ([_keywordsTF isFirstResponder]) {
        [_keywordsTF resignFirstResponder];
        return;
    }
    OfferPartyTalentsModel *selectModel = requestCon_.dataArr_[indexPath.row];
    OfferPartyDetailIndexCtl *offerDetailCtl = [[OfferPartyDetailIndexCtl alloc] init];
    offerDetailCtl.offerPartyModel = selectModel;
    offerDetailCtl.resumeComplete = resumeComplete;
    if (selectModel.iscome) {
        offerDetailCtl.isSignUp = YES;
    }
    else
    {
        offerDetailCtl.isSignUp = NO;
    }
    [self.navigationController pushViewController:offerDetailCtl animated:YES];
    [offerDetailCtl beginLoad:nil exParam:nil];
}


-(void)btnResponse:(id)sender
{
    [_keywordsTF resignFirstResponder];
    if (sender == regionBtn_) 
    {
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,153,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 153)];
            condictionCtl.delegate_ = self;
        }
        if (condictionCtl.currentType == OfferPaiRegionChange)
        {
            _bgView.hidden = YES;
            [condictionCtl hideView];
            return;
        }
        _bgView.hidden = YES;
        [condictionCtl hideView];
        
        CondictionList_DataModal *modal;
        if(regionModal)
        {
            modal = regionModal;
        }
        else
        {
            modal = [[CondictionList_DataModal alloc] init];
            modal.str_ = regionBtn_.titleLabel.text;
            if ([modal.str_ isEqualToString:@"全国"]) 
            {
                modal.id_ = @"";
            }
            else
            {
                modal.id_ = [CondictionListCtl getRegionId:regionBtn_.titleLabel.text];
            }
        }
        
        [condictionCtl creatViewWithType:OfferPaiRegionChange selectModal:modal];
        _bgView.hidden = NO;
        [condictionCtl showView];  
        
    }
    else if (sender == searchBtn_) 
    {
        [_keywordsTF resignFirstResponder];
        [self refreshLoad:nil];
    }
    else if (sender == _jobBtn){//岗位
        if (!condictionCtl)
        {
            condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,153,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 153)];
            condictionCtl.delegate_ = self;
        }
        if (condictionCtl.currentType == OfferPaiJobChange)
        {
            _bgView.hidden = YES;
            [condictionCtl hideView];
            return;
        }
        _bgView.hidden = YES;
        [condictionCtl hideView];
        
        personTagModel *modal;
        if(_selectJob)
        {
            modal = _selectJob;
        }
        else
        {
            modal = [[personTagModel alloc] init];
            modal.tagName_ = @"所有岗位";
            modal.tagId_ = @"";
        }
        
        [condictionCtl creatViewWithType:OfferPaiJobChange selectModal:modal];
        _bgView.hidden = NO;
        [condictionCtl showView]; 
        
    }
}

-(void)chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    [regionBtn_ setTitle:city forState:UIControlStateNormal];
    [self refreshLoad:nil];
}

-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType) {
        case OfferPaiRegionChange:
        {
            _bgView.hidden = YES;
            regionModal = (CondictionList_DataModal *)dataModel;
            [regionBtn_ setTitle:regionModal.str_ forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        case OfferPaiJobChange:
        {
            _bgView.hidden = YES;
            _selectJob = (personTagModel *)dataModel;
            [_jobBtn setTitle:_selectJob.tagName_ forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_keywordsTF resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _bgView.hidden = YES;
    [condictionCtl hideView];
    [super viewWillDisappear:animated];
    [_keywordsTF resignFirstResponder];
}

-(void)backBarBtnResponse:(id)sender
{
    [condictionCtl hideView];
    [super backBarBtnResponse:sender];
}

-(void)hideRegionChangeView
{
    if(condictionCtl)
    {
        [condictionCtl hideView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self refreshLoad:nil];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!_bgView.hidden) {
        _bgView.hidden = YES;
    }
    [self hideRegionChangeView];
    return YES;
}

@end
