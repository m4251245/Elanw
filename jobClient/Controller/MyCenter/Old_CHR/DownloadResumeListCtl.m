//
//  DownloadResumeListCtl.m
//  jobClient
//
//  Created by YL1001 on 15/1/26.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "DownloadResumeListCtl.h"
#import "CHRResumeCell.h"
#import "OthersResumePreviewCtl.h"
#import "ELJobSearchCondictionChangeCtl.h"

@interface DownloadResumeListCtl ()<changeJobSearchCondictionDelegate>
{
    NSString * companyId_;
    
    IBOutlet UIButton *_regionBtn;     /**<地区 */
    IBOutlet UIButton *_exprienceBtn;  /**<经验 */
    IBOutlet UIButton *_ageBtn;        /**<年龄 */
    IBOutlet UIButton *_eduBtn;        /**<学历要求 */
    
    NSMutableArray *_btnArr;   /**<存放按钮 */
    UIButton *_selectedBtn;    /**<选中按钮 */
    
    ELJobSearchCondictionChangeCtl *condictionChangeCtl;
    SearchParam_DataModal   *_searchModel;
}

@end

@implementation DownloadResumeListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _searchModel = [[SearchParam_DataModal alloc] init];
    
    _btnArr = [[NSMutableArray alloc] initWithObjects:_regionBtn, _exprienceBtn, _ageBtn, _eduBtn, nil];
    
    [self confiBtnTitleFrame];
    
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:myRightBarBtnItem_];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightNavigationItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
    self.navigationItem.title = @"已下载简历";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([refreshHeaderView_ isLoading]) {
        [refreshHeaderView_  egoRefreshScrollViewDataSourceDidFinishedLoading:tableView_];
        _shouldRefresh = YES;
    }
    
    [condictionChangeCtl hideView];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getDownloadResumeList:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20 search:_searchModel];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_CompanySearchResume:
            _shouldRefresh = NO;
            
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHRResumeCell";
    CHRResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHRResumeCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.statusLb.hidden = YES;
        cell.joinStateLb.hidden = YES;
    }
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:userModel.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    cell.userNameLb.text = userModel.name_;
    
    NSString *city = userModel.regionCity_;
    NSString *workAge = userModel.gzNum_;
    NSString *eduName = userModel.eduName_;

    NSString *sex = userModel.sex_;
    [cell.sexBtn setTitle:userModel.age_ forState:UIControlStateNormal];
    
    if ([sex isEqualToString:@"男"]) {
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }
    else if ([sex isEqualToString:@"女"]){
        [cell.sexBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.sexBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    
    NSDictionary *nameAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
    
    if (city.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:city attributes:nameAttr]];
    }
    
    if (workAge.length > 0) {
        if (attrString.length > 0) 
        {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@年工作经验", workAge] attributes:nameAttr]];
    }
    
    if (eduName.length > 0) {
        if (attrString.length > 0) 
        {
            [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
        }
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", eduName] attributes:nameAttr]];
    }
    
    cell.summaryLb.attributedText = attrString;
    
    if (userModel.job_) {
        cell.jobLb.text =[NSString stringWithFormat:@"应聘: %@", userModel.job_];
    }
    else{
        cell.jobLb.text = @"";
    }
    
    if (userModel.updateTime.length>10) {
        cell.timeLb.text = [userModel.updateTime substringToIndex:10];
    }
    else{
        cell.timeLb.text = userModel.updateTime;
    }
    
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal * dataModal = selectData;
    OthersResumePreviewCtl * resumePreviewCtl = [[OthersResumePreviewCtl alloc] init];
    resumePreviewCtl.bRecommended_ = YES;
    resumePreviewCtl.resumeType = ResumeTypeDownload;
    [self.navigationController pushViewController:resumePreviewCtl animated:YES];
    [resumePreviewCtl beginLoad:dataModal exParam:companyId_];
}


- (void)btnResponse:(id)sender
{
    if (sender == _regionBtn) {
        
        SqlitData *data = [[SqlitData alloc] init];
        data.provinceld = _searchModel.regionId_;
        
        [self showCondictionChangeView:RegionChange selectModal:data];
    }
    else if (sender == _exprienceBtn)
    {
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = _searchModel.experienceName;
        data.id_ = _searchModel.experienceValue1;
        data.id_1 = _searchModel.experienceValue2;
        
        [self showCondictionChangeView:ExperienceChange selectModal:data];
    }
    else if (sender == _ageBtn)
    {
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = _searchModel.workAgeName_;
        data.id_ = _searchModel.workAgeValue_;
        data.id_1 = _searchModel.workAgeValue_1;
        [self showCondictionChangeView:AgeChange selectModal:data];
    }
    else if (sender == _eduBtn)
    {
        CondictionList_DataModal *data = [[CondictionList_DataModal alloc] init];
        data.str_ = _searchModel.eduName_;
        data.id_ = _searchModel.eduId_;
        [self showCondictionChangeView:EducationChange selectModal:data];
    }
    
    _selectedBtn = (UIButton *)sender;
}

- (void)showCondictionChangeView:(CondictionChangeType)changeType selectModal:(id)selectModal
{
    if (!condictionChangeCtl)
    {
        condictionChangeCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,104,ScreenWidth,[UIScreen mainScreen].bounds.size.height - 104)];
        condictionChangeCtl.delegate_ = self;
    }
    
    if (condictionChangeCtl.currentType == changeType)
    {
        [condictionChangeCtl hideView];
        return;
    }
    
    [condictionChangeCtl hideView];
    [condictionChangeCtl creatViewWithType:changeType selectModal:selectModal];
    [condictionChangeCtl showView];
}

#pragma mark - changeJobSearchCondictionDelegate
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel
{
    switch (changeType)
    {
        case RegionChange:
        {
            SqlitData *modal = dataModel;
            _searchModel.regionStr_ = modal.provinceName;
            _searchModel.regionId_ = modal.provinceld;
            [_regionBtn setTitle:modal.provinceName forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        case ExperienceChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            _searchModel.experienceName = modal.str_;
            _searchModel.experienceValue1 = modal.id_;
            _searchModel.experienceValue2 = modal.id_1;
            [_exprienceBtn setTitle:modal.str_ forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        case AgeChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if ([modal.str_ isEqualToString:@""]) {
                modal.str_ = @"不限";
            }
            _searchModel.workAgeName_ = modal.str_;
            _searchModel.workAgeValue_ = modal.id_;
            _searchModel.workAgeValue_1 = modal.id_1;
            [_ageBtn setTitle:modal.str_ forState:UIControlStateNormal];
            [self refreshLoad:nil];
        }
            break;
        case EducationChange:
        {
            CondictionList_DataModal *modal = dataModel;
            [_eduBtn setTitle:modal.str_ forState:UIControlStateNormal];
            _searchModel.eduName_ = modal.str_;
            _searchModel.eduId_ = modal.id_;
            [self refreshLoad:nil];
        }
            break;
        default:
            break;
    }
    
    [self confiBtnTitleFrame];
}

- (void)confiBtnTitleFrame
{
    CGFloat btnWidth = ScreenWidth / 4;
    
    for (UIButton *btn in _btnArr) {
        if (btn == _selectedBtn) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btnWidth - btn.imageView.frame.size.width
                                                                - btn.titleLabel.intrinsicContentSize.width) / 2, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, (btnWidth - btn.imageView.frame.size.width
                                                              - btn.titleLabel.intrinsicContentSize.width) / 2 + btn.titleLabel.intrinsicContentSize.width, 0, 0);
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
