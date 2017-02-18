//
//  ConsultantLoadResumeCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantLoadResumeCtl.h"
#import "ConsultantSearchCell.h"
#import "ExRequetCon.h"
#import "ConsultantHRDataModel.h"
#import "ConsultantResumePreviewCtl.h"
#import "ELJobSearchCondictionChangeCtl.h"

@interface ConsultantLoadResumeCtl ()<UITextFieldDelegate,changeJobSearchCondictionDelegate>
{
    UIView *headerView;
    ELJobSearchCondictionChangeCtl *condictionCtl;
    CondictionList_DataModal *selectModel;
    NSMutableArray *positionChangeArr;
}
@end

@implementation ConsultantLoadResumeCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setNavTitle:@"已下载简历"];
  
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 120, 44)];
    
    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth - 120, 24)];
    bgImgv.layer.cornerRadius = 12;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    UITextField *keyWorkTf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth - 120, 24)];
    _keyWorkTf = keyWorkTf;
    keyWorkTf.returnKeyType = UIReturnKeySearch;
    keyWorkTf.placeholder = @"请输入姓名搜索";
    [keyWorkTf setFont:FOURTEENFONT_CONTENT];
    [keyWorkTf setTextColor:BLACKCOLOR];
    keyWorkTf.delegate = self;
    [keyWorkTf setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:keyWorkTf];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_search_def.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.titleView = searchView;
    positionChangeArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self refreshLoad];
}

-(void)viewDidDisappear:(BOOL)animated{
    [condictionCtl hideView];
}

-(void)changeTap:(UITapGestureRecognizer *)sender{
    if (positionChangeArr.count <= 0) {
        return;
    }
    [_keyWorkTf resignFirstResponder];
    if (!condictionCtl)
    {
        condictionCtl = [[ELJobSearchCondictionChangeCtl alloc] initWithFrame:CGRectMake(0,108,ScreenWidth,ScreenHeight - 108)];
        condictionCtl.delegate_ = self;
        condictionCtl.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    if (condictionCtl.currentType == GWMyresumeListPositionChange)
    {
        [condictionCtl hideView];
        [self updateColorTextWithShow:NO];
        return;
    }
    [condictionCtl hideView];
    condictionCtl.gwPositionArr = [[NSMutableArray alloc] initWithArray:positionChangeArr];
    [condictionCtl creatViewWithType:GWMyresumeListPositionChange selectModal:selectModel];
    [condictionCtl showView];
    [self updateColorTextWithShow:YES];
}

#pragma mark - changeJobSearchCondictionDelegate
-(void)cancelChangeDelegate{
    [self updateColorTextWithShow:NO];
}
-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel{
    switch (changeType) {
        case GWMyresumeListPositionChange:
        {
            CondictionList_DataModal *modal = dataModel;
            if (modal) {
                selectModel = modal;
                [self updateHeaderFrame];
                [self updateColorTextWithShow:NO];
                [self refreshLoad];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)updateColorTextWithShow:(BOOL)show
{
    UILabel *label = (UILabel *)[headerView viewWithTag:2001];
    UIImageView *image = (UIImageView *)[headerView viewWithTag:2002];
    if (show){
        label.textColor = UIColorFromRGB(0xe13e3e);
        image.image = [UIImage imageNamed:@"小筛选下拉more-sel"];
    }else{
        label.textColor = UIColorFromRGB(0x333333);
        image.image = [UIImage imageNamed:@"小筛选下拉more"];
    }
}

-(void)updateHeaderFrame{
    UILabel *label = (UILabel *)[headerView viewWithTag:2001];
    UIImageView *image = (UIImageView *)[headerView viewWithTag:2002];
    NSString *str = @"全部分组";
    if (selectModel) {
        if (selectModel.str_ && ![selectModel.str_ isEqualToString:@""]) {
            str = selectModel.str_;
        }
    }
    label.text = str;
    [label sizeToFit];
    CGFloat width = label.frame.size.height < (ScreenWidth-70) ? label.frame.size.height:(ScreenWidth-70);
    label.frame = CGRectMake(0,(headerView.frame.size.height-label.frame.size.height)/2.0,label.frame.size.width,width);
    image.frame = CGRectMake(label.frame.size.width+3,18,5,3);
    
    CGRect frame = headerView.frame;
    frame.size.width = CGRectGetMaxX(image.frame)+3;
    frame.origin.x = (ScreenWidth-frame.size.width)/2.0;
    headerView.frame = frame;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self requestListData];
    if (positionChangeArr.count <= 0){
        [self requestJobChangeData];
    }
}

-(void)requestListData{
    NSString *keywords = @"";//按姓名查询
    if (_keyWorkTf.text.length > 0 && ![[_keyWorkTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        keywords = _keyWorkTf.text;
    }
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)self.pageInfo.currentPage_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = @"";
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    if (keywords.length > 0){
        [searchDic setObject:keywords forKey:@"key_iname"];
    }
    if (selectModel) {
        if (selectModel.id_ && ![selectModel.id_ isEqualToString:@""]) {
            [searchDic setObject:selectModel.id_ forKey:@"categoryid"];
        }
    }
    if (searchDic.count > 0) {
        searchStr = [jsonWriter stringWithObject:searchDic];
    }
    
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"sa_user_id=%@&condition_arr=%@&search_arr=%@",self.salerId,conDicStr,searchStr];
    NSString * function = @"myPersonList";
    NSString * op = @"app_jjr_api_busi";
    [ELRequest newBodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]){
            [self parserPageInfo:dic];
            NSArray *arr = dic[@"data"];
            if ([arr isKindOfClass:[NSArray class]]){
                for (NSDictionary *subDic in arr) {
                    User_DataModal *dataModal = [[User_DataModal alloc] init];
                    ELOfferPeopleModel *model = [[ELOfferPeopleModel alloc] initWithDic:subDic];
                    dataModal.name_ = model.iname;
                    dataModal.job_ = model.job;
                    dataModal.sex_ = model.sex;
                    dataModal.mobile_ = model.shouji;
                    dataModal.sendtime_ = model.update_time;
                    dataModal.eduName_ = model.edus;
                    dataModal.userId_ = model.id_;
                    dataModal.img_ = model.pic;
                    dataModal.regionCity_ = model.region_name;
                    dataModal.gzNum_ = [NSString stringWithFormat:@"%ld",(long)[model.gznum intValue]];
                    dataModal.age_ = [NSString stringWithFormat:@"%ld",(long)[model.age intValue]];
                    //dataModal.isCanContract = @"";
                    //dataModal.isDown = @"1";
                    dataModal.tradeId = @"";
                    dataModal.secret = model.secret;
                    [_dataArray addObject:dataModal];
                }
            }
        }
        [self.tableView reloadData];
        [self finishReloadingData];
        [self refreshEGORefreshView];
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        [self finishReloadingData];
        [self refreshEGORefreshView];
    }];
}

-(void)requestJobChangeData{
    [ELRequest newBodyMsg:[NSString stringWithFormat:@"sa_user_id=%@",self.salerId] op:@"app_jjr_api_busi" func:@"getCategoryAndStatistical" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        NSArray *arr = result;
        if ([arr isKindOfClass:[NSArray class]]) {
            if (!positionChangeArr) {
                positionChangeArr = [[NSMutableArray alloc] init];
            }
            for (NSDictionary *dic in arr) {
                CondictionList_DataModal *model = [[CondictionList_DataModal alloc] init];
                model.str_ = dic[@"name"];
                model.id_ = [NSString stringWithFormat:@"%ld",(long)[dic[@"id"] intValue]];
                [positionChangeArr addObject:model];
            }
            [self refreshHeader];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)refreshHeader
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.userInteractionEnabled = YES;
    [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTap:)]];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = UIColorFromRGB(0x333333);
    lable.tag = 2001;
    [headerView addSubview:lable];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,5,3)];
    image.tag = 2002;
    [headerView addSubview:image];
    
    UIView *headBack = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,40)];
    headBack.backgroundColor = [UIColor whiteColor];
    [headBack addSubview:headerView];
    self.tableView.tableHeaderView = headBack;
    [self updateHeaderFrame];
    [self updateColorTextWithShow:NO];
    [self adjustFooterViewFrame];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ConsultantSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantSearchCell" owner:self options:nil] lastObject];
    }
    User_DataModal *model = _dataArray[indexPath.row];
    
    [cell.photoImagv sd_setImageWithURL:[NSURL URLWithString:model.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [cell.name setText:model.name_];
    NSString *descStr = nil;
    if (!model.gzNum_ || [model.gzNum_ isEqualToString:@"0.0"] || [model.gzNum_ isEqualToString:@""]) {
        model.gzNum_ = @"0";
    }
    NSString *edu = nil;
    if (!model.eduName_ || [model.eduName_ isEqualToString:@""]) {
        edu = @"";
    }else{
        edu = [NSString stringWithFormat:@"| %@",model.eduName_];
    }
    if ([model.regionCity_ isEqualToString:@""] || !model.regionCity_) {
        descStr = [NSString stringWithFormat:@"%@年经验 %@",model.gzNum_,edu];
    }else{
        descStr = [NSString stringWithFormat:@"%@ | %@年经验 %@",model.regionCity_,model.gzNum_,edu];
    }
    [cell.contentDescLb setText:descStr];
    [cell.jobLb setText:[NSString stringWithFormat:@"意向职位:%@",model.job_]];
    
    NSString *time = [model.sendtime_ substringToIndex:10];
    [cell.timeLb setText:time];
    if ([model.sex_ isEqualToString:@"男"]) {
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else{
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }
    
//    [cell.gender setTitle:model.age_ forState:UIControlStateNormal];
    if(model.age_.length < 3){
        if([model.age_ isEqualToString:@"暂无"]){
            [cell.gender setTitle:@"无" forState:UIControlStateNormal];
        }
        else{
            [cell.gender setTitle:model.age_ forState:UIControlStateNormal];
        }
    }
    else{
        [cell.gender setTitle:@"无" forState:UIControlStateNormal];
    }
    if ([model.secret isEqualToString:@"1"]) {
        cell.lockImage.hidden = NO;
    }else{
        cell.lockImage.hidden = YES;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User_DataModal *model = _dataArray[indexPath.row];
    ConsultantResumePreviewCtl *consultantResumePreviewCtl = [[ConsultantResumePreviewCtl alloc] init];
    consultantResumePreviewCtl.salerId = _salerId;
    consultantResumePreviewCtl.downloadFlag = _downloadFlag;
    [self.navigationController pushViewController:consultantResumePreviewCtl animated:YES];
    [consultantResumePreviewCtl beginLoad:model exParam:self.salerId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _keyWorkTf) {
        [_keyWorkTf resignFirstResponder];
        [self refreshLoad];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [condictionCtl hideView];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [condictionCtl hideView];
}

-(void)leftBarButtonItemClick:(UIButton *)btn{
    [condictionCtl hideView];
    [_keyWorkTf resignFirstResponder];
    [super leftBarButtonItemClick:btn];
}

- (void)rightBarBtnResponse:(id)sender
{
    [condictionCtl hideView];
    [_keyWorkTf resignFirstResponder];
    [self refreshLoad];
}

@end
