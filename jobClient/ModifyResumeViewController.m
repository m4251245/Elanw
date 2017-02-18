//
//  ModifyResumeViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ModifyResumeViewController.h"
#import "ResumeHeaderViewController.h"
#import "SectionHeaderView.h"
#import "BaseInfoTableViewCell.h"
#import "DetailConTableViewCell.h"
#import "SkillTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PersonInfo_ResumeCtl.h"
#import "WorkResume_DataModal.h"
#import "EditorWorkExperienceCtl.h"
#import "CondictionPlaceCtl.h"
#import "NoneContentTableViewCell.h"
#import "PersonDetailInfo_DataModal.h"
#import "New_PersonDataModel.h"
#import "Person_eduDataModel.h"
#import "Person_infoDataModel.h"
#import "Person_workDataModel.h"
#import "Person_projectDataModel.h"
#import "Person_trainDataModel.h"
#import "EduBackGroudDetailCtl.h"
#import "IntroduceMyselfCtl.h"
#import "Skill_ResumeCtl.h"
#import "ELTrainDetailCtl.h"
#import "ProjectViewController.h"
#import "LineSpaceHelper.h"
#import "ProExperinceTableViewCell.h"



#define pictureHeight 238
static NSInteger kHEADER_BTN_TAG = 1236530;
//EditorWorkExperienceDelegate
@interface ModifyResumeViewController ()<PersonInfo_ResumeCtlDelegate,BaseResumeDelegate>{
    NSInteger arrLenth;
    BOOL btnState;//展开收起状态
    NSString *personId;
    New_PersonDataModel *personDataVO;
    UIView *navView;//导航栏
    UIButton *backBtn;//返回
    UILabel *titleLb;//导航标题
    NSMutableArray *addArrary;//展开的数据数组
    BOOL isFirst;
    BOOL isIntoBack;
    NSString *rctype;
    BOOL noFirstLoadData;
}
@property (strong, nonatomic) UIView *myHeaderView;
@property (retain, nonatomic) UIImageView *bgImgView;
@end

@implementation ModifyResumeViewController
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    self.footerRefreshFlag = NO;
    self.headerRefreshFlag = NO;
    self.showNoDataViewFlag = NO;
    self.showNoMoreDataViewFlag = NO;
    self.noRefershLoadData = YES;
    [super viewDidLoad];
    self.self.fd_interactivePopDisabled = YES;
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:YES];
   
    if (![AFNetworkReachabilityManager sharedManager].isReachable  && [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusUnknown)
    {
        [self showNoNetworkView:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self setFd_prefersNavigationBarHidden:YES];
    [super viewWillDisappear:animated];
}

-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
}

#pragma mark--配置界面
-(void)configUI{
    if (!_myHeaderView) {
        _myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,392)];
    }
    _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, pictureHeight)];
    _bgImgView.image = [UIImage imageNamed:@"background_header.png"];
    _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImgView.clipsToBounds = YES;
    [_myHeaderView addSubview:_bgImgView];
    
    ResumeHeaderViewController *resumeVC = [[ResumeHeaderViewController alloc]init];
    resumeVC.view.frame = _myHeaderView.frame;
    resumeVC.hBackBtn.hidden = YES;
    [self addChildViewController:resumeVC];
    [_myHeaderView addSubview:resumeVC.view];
    [_myHeaderView insertSubview:_bgImgView belowSubview:resumeVC.view];
    self.tableView.tableHeaderView = _myHeaderView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"myBaseInfoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailConTableViewCell" bundle:nil] forCellReuseIdentifier:@"myDetailConTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SkillTableViewCell" bundle:nil] forCellReuseIdentifier:@"mySkillTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProExperinceTableViewCell" bundle:nil] forCellReuseIdentifier:@"myProExperinceTableViewCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self configNavBar];
}
#pragma mark--导航栏透明处理
-(void)configNavBar{
    UIColor *color = UIColorFromRGB(0xe13e3e);
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.alpha = 0;
    navView.backgroundColor = color;
    [self.view addSubview:navView];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"back_white_new"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    titleLb = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 100)/2, 20, 100, 44)];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.text = @"我的简历";
    titleLb.textColor = [UIColor whiteColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.alpha = 0;
    [self.view addSubview:titleLb];
}

#pragma mark--加载数据
-(void)beginLoad:(id)param exParam:(id)exParam {
    [super beginLoad:param exParam:exParam];
    addArrary = [NSMutableArray array];
    personId = [Manager getUserInfo].userId_;
    [self loadData];
    if (!noFirstLoadData) {
        [BaseUIViewController showLoadView:YES content:nil view:nil];
        noFirstLoadData = YES;
    }
}

-(void)loadData{
    [self requestHeaderInfoData];
    [self requestAllData];
}

//请求头部数据
-(void)requestHeaderInfoData{
   
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:personId forKey:@"personId"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@&where=%@&slaveInfo=%@",condictionStr,@"1=1",@"1"];
    NSString * function = @"getPersonDetail";
    NSString * op = @"person_sub_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        personDataVO = [[New_PersonDataModel alloc]init];
        [personDataVO setValuesForKeysWithDictionary:result];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:personDataVO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendData" object:nil userInfo:@{@"array":arr}];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:personDataVO.resume_status forKey:@"resume_status"];
        [defaults synchronize];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//请求所有信息
-(void)requestAllData{
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = @"get_all_person_info";
    NSString * op = @"person_sub_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        [self dealData:result];
//        arrLenth = _dataArray.count;
        [self.tableView reloadData];
        
        [BaseUIViewController showLoadView:NO content:nil view:nil];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];

}
#pragma mark-请求数据成功后处理
-(void)dealData:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        //  个人基本信息
        NSDictionary *personInfoDic = result[@"person_info"];
        Person_infoDataModel *personInfoVO = [Person_infoDataModel new];
        if([personInfoDic isKindOfClass:[NSDictionary class]] && !([personInfoDic isEqual:[NSNull null]])){
            [personInfoVO setValuesForKeysWithDictionary:personInfoDic];
            NSArray *personInfoArr = @[personInfoVO];
            rctype = personInfoVO.rctypeId;
            [_dataArray addObject:@{@"title":@"基本信息",@"state":@"编辑",@"dataArray":personInfoArr}];
            //  工作经历
            [self dic:result dicKey:@"person_work" title:@"工作经历" dataModel:@"Person_workDataModel"];
            //  教育经历
            [self dic:result dicKey:@"person_edus" title:@"教育经历" dataModel:@"Person_eduDataModel"];
            //  项目经历
            [self dic:result dicKey:@"person_project" title:@"项目经验" dataModel:@"Person_projectDataModel"];
            
            //  自我评价
            if (personInfoVO.grzz.length > 0) {
                [_dataArray addObject:@{@"title":@"自我评价",@"state":@"编辑",@"dataArray":@[personInfoVO.grzz]}];
            }
            else{
                [_dataArray addObject:@{@"title":@"自我评价",@"state":@"编辑",@"dataArray":@[]}];
            }
            
            //  技能特长
            if (personInfoVO.othertc.length > 0) {
                [addArrary addObject:@{@"title":@"技能特长",@"state":@"编辑",@"dataArray":@[personInfoVO.othertc]}];
            }
            else{
                [addArrary addObject:@{@"title":@"技能特长",@"state":@"编辑",@"dataArray":@[]}];
            }
            
            //    培训经历
            id myarr = result[@"person_train"];
            NSMutableArray *addArr = [NSMutableArray array];
            if ([myarr isKindOfClass:[NSNull class]] || [myarr isEqual:[NSNull null]]) {
                [addArrary addObject:@{@"title":@"培训经历",@"state":@"添加",@"dataArray":@[]}];
            }
            else
            {
                for (NSDictionary *dic in myarr) {
                    Person_trainDataModel *VO = [Person_trainDataModel new];
                    [VO setValuesForKeysWithDictionary:dic];
                    [addArr addObject:VO];
                }
                [addArrary addObject:@{@"title":@"培训经历",@"state":@"添加",@"dataArray":addArr}];
            }
            
            if (isIntoBack) {
                if (btnState) {
                    [_dataArray addObjectsFromArray:addArrary];
                }
            }
        }
        
    }
}

#pragma mark--代理
#pragma mark-scorll代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollY = scrollView.contentOffset.y;
    if (scrollY > 108) {
        CGFloat alpha = MIN(1, 1 - (108 + 64 - scrollY)/64);
        navView.alpha = alpha;
        titleLb.alpha = alpha;
    }else{
        navView.alpha = 0 ;
        titleLb.alpha = 0;
    }
    
    // 下拉 纵向偏移量变小 变成负的
    if ( scrollY < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = pictureHeight - scrollY;
        // 图片放大比例
        CGFloat scale = totalOffset / pictureHeight;
        CGFloat width = ScreenWidth;
        // 拉伸后图片位置
        _bgImgView.frame = CGRectMake(-(width * scale - width) / 2, scrollY, width * scale, totalOffset);
    }
    
}
#pragma mark-table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_dataArray.count > 0){
        return _dataArray.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _dataArray[section];
    NSArray* arr = dic[@"dataArray"];
    if (arr.count <= 0 && dic) {
        return 1;
    }
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic;
    if (indexPath.section < _dataArray.count) {
       dic = _dataArray[indexPath.section];
    }
    
    NSArray *arr = dic[@"dataArray"];
//    基本信息
    if (indexPath.section == 0) {
        Person_infoDataModel *personInfoVO;
        if (indexPath.row < arr.count) {
            personInfoVO = arr[indexPath.row];
        }
        BaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myBaseInfoTableViewCell" forIndexPath:indexPath];
        
        cell.selectedBackgroundView.frame = cell.frame;
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xbb3434);
        
        cell.nameLab.text = personInfoVO.iname;
        cell.birthLab.text = personInfoVO.bday;
        cell.workAgeLab.text = personInfoVO.gznum;
        cell.sexLab.text = personInfoVO.sex;
        cell.indentiLab.text = [self rcType:personInfoVO.rctypeId];;
        cell.placeOriginLab.text = [CondictionPlaceCtl getRegionDetailAddress:personInfoVO.hka];
        cell.liveLab.text = [CondictionPlaceCtl getRegionDetailAddress:personInfoVO.regionid];
        cell.phoneLab.text = personInfoVO.shouji;
        cell.mainBoxLab.text = personInfoVO.email;
        return cell;
    }
//    没有数据显示
    static NSString *myCell = @"myCell";
    if (arr.count <= 0) {
        NoneContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"NoneContentTableViewCell" owner:self options:nil].firstObject;
        }
        cell.noneConLb.text = [self noneContent:indexPath.section];
        return cell;
    }
//    自我评价和技能特长
    if ([dic[@"title"] isEqualToString:@"自我评价"] || [dic[@"title"] isEqualToString:@"技能特长"]) {
        SkillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mySkillTableViewCell" forIndexPath:indexPath];
        cell.mainConLab.attributedText = [LineSpaceHelper dealStrWithLineSpace:[self dealRerunStr:arr.firstObject]];
        cell.mainConLab.numberOfLines = 2;
        return cell;
    }
    if ([dic[@"title"] isEqualToString:@"工作经历"] || [dic[@"title"] isEqualToString:@"项目经验"]) {
        ProExperinceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myProExperinceTableViewCell" forIndexPath:indexPath];
        [self myProCell:cell data:arr idx:indexPath withDic:dic];
        return cell;
    }
//    其他
    DetailConTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myDetailConTableViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.section * 100 + indexPath.row;
    [self ctlTableCell:indexPath arr:arr numLines:nil withDic:dic];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColorFromRGB(0xe13e3e);
    btn.frame = CGRectMake(16, 15, view.frame.size.width - 32, 50);
    if (!btnState) {
        [btn setTitle:@"展开更多模块" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"more@2x"] forState:UIControlStateNormal];
    }
    else{
        [btn setTitle:@"收起更多模块" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"less@2x"] forState:UIControlStateNormal];
    }
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    
    [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    view.userInteractionEnabled = YES;
    if (section == _dataArray.count - 1) {
        return view;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_dataArray.count > 0){
        NSDictionary *dic = _dataArray[section];
        SectionHeaderView *sectionHeader = [[SectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        sectionHeader.headerTitleLb.text = dic[@"title"];
        [sectionHeader.editBtn setTitle:dic[@"state"] forState:UIControlStateNormal];
        [sectionHeader.editBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        sectionHeader.editBtn.tag = kHEADER_BTN_TAG + section;
        if (section == 0) {
            NSArray *arr = dic[@"dataArray"];
            sectionHeader.unWholeLb.hidden = [self isShowState:arr];
        }
        return sectionHeader;
    }
    return nil;
}
//use thirdParty autolayout label 自适应高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count > 0) {
        NSDictionary *dic = _dataArray[indexPath.section];
        NSArray *arr = dic[@"dataArray"];
        if (indexPath.section == 0) {
            return 285;
        }
        
        if (arr.count <= 0){
            return 55.0;
        }
        
        if ([dic[@"title"] isEqualToString:@"自我评价"] || [dic[@"title"] isEqualToString:@"技能特长"]) {
            return [tableView fd_heightForCellWithIdentifier:@"mySkillTableViewCell" cacheByIndexPath:indexPath configuration:^(SkillTableViewCell * cell) {
                cell.mainConLab.numberOfLines = 2;
                cell.mainConLab.attributedText = [LineSpaceHelper dealStrWithLineSpace:[self dealRerunStr:arr.firstObject]];
            }];
        }
        
        else if ([dic[@"title"] isEqualToString:@"工作经历"] || [dic[@"title"] isEqualToString:@"项目经验"]){
            return [tableView fd_heightForCellWithIdentifier:@"myProExperinceTableViewCell" cacheByIndexPath:indexPath configuration:^(ProExperinceTableViewCell* cell) {
                [self myProCell:cell data:arr idx:indexPath withDic:dic];
           
            }] + 6;
        }
        else{
            return [tableView fd_heightForCellWithIdentifier:@"myDetailConTableViewCell" cacheByIndexPath:indexPath configuration:^(DetailConTableViewCell * cell) {
                [self ctlTableCell:indexPath arr:arr numLines:cell withDic:dic];
                
            }] + 8;
        }
    }
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dataArray.count > 0) {
        if (section == _dataArray.count - 1) {
            return 80.0;
        }
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isIntoBack = YES;
    if (_dataArray.count <= 0) {
        return;
    }
    NSDictionary *dic = _dataArray[indexPath.section];
    NSArray *arr = dic[@"dataArray"];
    if (arr.count <= 0){
        return; 
    }
    __block ModifyResumeViewController *BlockSelf = self;
    if (indexPath.section == 1) {
        Person_workDataModel *workV0 = arr[indexPath.row];
        EditorWorkExperienceCtl *editorWorkCtl = [[EditorWorkExperienceCtl alloc ] init];
        editorWorkCtl.allCount = arr.count;
        editorWorkCtl.myBlock = ^{
            [BlockSelf refreshAllData];
        };
        [editorWorkCtl beginLoad:workV0 exParam:@"1"]; //更新
        [self.navigationController pushViewController:editorWorkCtl animated:YES];
    }
    if (indexPath.section == 2) {
        
        EduBackGroudDetailCtl *ctl = [[EduBackGroudDetailCtl alloc] init];
        ctl.allCount = arr.count;
        ctl.addOrEditor = 2;
        Person_eduDataModel *modal = arr[indexPath.row];
        ctl.eduVO = modal;
        
        ctl.addOrEditorBlock = ^(NSString *type)
        {
             [BlockSelf refreshAllData];
        };
        
        [self.navigationController pushViewController:ctl animated:YES];
    }
    if (indexPath.section == 3) {
        Person_projectDataModel *proDataModel = arr[indexPath.row];
        ProjectViewController *projectVC = [[ProjectViewController alloc]init];
        projectVC.isYjs = rctype;
        projectVC.proType = @"2";
        projectVC.proVO = proDataModel;
        projectVC.addOrEditorBlock = ^(NSString *state){
            [BlockSelf refreshAllData];
        };
        [self.navigationController pushViewController:projectVC animated:YES];
    }
    
    if (indexPath.section == 4){
        [self intoIntro];
    }
    if(indexPath.section == 5){
        [self intoSkill];
    }
    if (indexPath.section == 6) {
        Person_trainDataModel *trainVO = arr[indexPath.row];
        ELTrainDetailCtl *ctl = [[ELTrainDetailCtl alloc] init];
        ctl.allCount = arr.count;
        ctl.addOrEditor = 2;
        ctl.cellIndex = indexPath.row;
        ctl.trainVO = trainVO;
        
        ctl.addOrEditorBlock = ^(ProjectResume_DataModal *dataModal,NSString *type)
        {
            [BlockSelf refreshAllData];
        };
        
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#pragma mark- 添加工作经历回调成功
//-(void)editorSuccess{
//    [self refreshAllData];
//}
//PersonInfo_ResumeCtlDelegate 修改个人信息代理回调
-(void)personInfoChang{
    NSLog(@"9999999999999999999999999999");
}
#pragma mark-编辑个人信息回调
-(void)backCtl{
    [self refreshAllData];
}

#pragma BaseResumeDelegate
-(void) resumeInfoChanged:(BaseResumeCtl *)ctl modal:(PersonDetailInfo_DataModal *)modal
{
    
}

#pragma mark--事件

-(IBAction)backBtnClick:(id)sender{
    [self.tableView setContentOffset:CGPointZero];
    [self.navigationController popViewControllerAnimated:YES];
}

//底部按钮点击
-(IBAction)bottomBtnClick:(UIButton *)sender{
    
    if (!btnState) {
        [_dataArray addObjectsFromArray:addArrary];
    }
    else {
//        NSRange range = {arrLenth,addArrary.count};
//        [_dataArray removeObjectsInRange:range];
        [_dataArray removeLastObject];
        [_dataArray removeLastObject];
    }
    
    btnState = !btnState;
    [self.tableView reloadData];
    
    NSInteger section = 0;
    NSDictionary *dic;
    if (_dataArray.count > 0) {
       section  = _dataArray.count - 1;
        dic = _dataArray.lastObject;
    }
    
    NSArray *array = [dic objectForKey:@"dataArray"];
    NSInteger row = 0;
    if (array.count > 0) {
        row = array.count - 1;
    }
    if (section > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(IBAction)headerBtnClick:(UIButton *)btn{
    isIntoBack = YES;
    NSInteger btnTagMark = btn.tag - kHEADER_BTN_TAG;
    if (_dataArray.count == 0) {
        return;
    }
    NSDictionary *dic = _dataArray[btnTagMark];
    NSArray *arr = dic[@"dataArray"];
    __block ModifyResumeViewController *BlockSelf = self;
    switch (btnTagMark) {
        case 0:
        {
            PersonInfo_ResumeCtl *personInfo = [[PersonInfo_ResumeCtl alloc]init];
            [personInfo beginLoad:nil exParam:nil];
            [personInfo loginOff];
            [personInfo setHaveUpdateComFlag:NO];
            personInfo.delegate = self;
            personInfo.resumeDelegate_ = self;
            personInfo.personVO = personDataVO;
            
            personInfo.myBlock = ^(NSString *str){
                [BlockSelf refreshAllData];
            };
            [self.navigationController pushViewController:personInfo animated:YES];
        }
            break;
        case 1:
        {
         //工作经历
            Person_workDataModel *workV0 = [Person_workDataModel new];
            EditorWorkExperienceCtl *editorWorkCtl = [[EditorWorkExperienceCtl alloc ] init];
//            editorWorkCtl.delegate = self;
            editorWorkCtl.myBlock = ^{
                [BlockSelf refreshAllData];
            };
            [editorWorkCtl beginLoad:workV0 exParam:@"0"]; //增加
            [self.navigationController pushViewController:editorWorkCtl animated:YES];
        }
            break;
        case 2:
        {//教育经历
            EduBackGroudDetailCtl *ctl = [[EduBackGroudDetailCtl alloc] init];
            ctl.allCount = arr.count;
            ctl.addOrEditor = 1;
            ctl.addOrEditorBlock = ^(NSString *type)
            {
                [BlockSelf refreshAllData];
               
            };
            [self.navigationController pushViewController:ctl animated:YES];

        }
            break;
        case 3:
            [self intoPro];
            break;
        case 4:
            [self intoIntro];
            break;
        case 5:
            [self intoSkill];
            break;
        case 6:
            [self intoTrainDetail];
            break;
        default:
            break;
    }
}

#pragma mark--业务逻辑
-(void)dic:(id)result dicKey:(NSString *)key title:(NSString *)title dataModel:(NSString *)dataModel{
    id arr = result[key];
    if ([arr isEqual:[NSNull null]] || [arr isKindOfClass:[NSNull class]]) {
        [_dataArray addObject:@{@"title":title,@"state":@"添加",@"dataArray":@[]}];
    }
    else{
        NSMutableArray *addArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            id VO = [[NSClassFromString(dataModel) alloc]init];
            [VO setValuesForKeysWithDictionary:dic];
            [addArr addObject:VO];
        }
        [_dataArray addObject:@{@"title":title,@"state":@"添加",@"dataArray":addArr}];
    }
}
//求职身份
-(NSString *)rcType:(NSString *)rcType{
    if ([rcType isEqualToString:@"1"]) {
        return @"社会人才";
    }
    else if([rcType isEqualToString:@"0"]){
        return @"应届生";
    }
    return nil;
}
//项目经历
-(void)myProCell:(ProExperinceTableViewCell *)cell data:(NSArray *)arr idx:(NSIndexPath *)indexPath withDic:(NSDictionary *)dic{
    
    if ( [dic[@"title"] isEqualToString:@"工作经历"] ) {
        Person_workDataModel *workVO = arr[indexPath.row];
        NSString *stopStr;
        if ([workVO.istonow isEqualToString:@"1"]) {
            stopStr = @"至今";
        }else{
            stopStr = [self endTime:workVO.stopdate];
        }
        cell.timeLb.text = [NSString stringWithFormat:@"%@ 至 %@",[self startTime:workVO.startdate],stopStr];
        cell.proNameLb.text = [NSString stringWithFormat:@"%@",workVO.company];
//        cell.detailLbToBottom.constant = 10;
        cell.desLb.textColor = UIColorFromRGB(0x333333);
        NSString *salary;
        if (workVO.salarymonth.length > 0) {
            salary = [NSString stringWithFormat:@"%@元/月",workVO.salarymonth];
        }
        else{
            salary = @"未填写";
        }
        cell.desLb.text = [NSString stringWithFormat:@"%@ | %@",workVO.jtzw,salary];
        cell.gainLb.attributedText = [LineSpaceHelper dealStrWithLineSpace:[self dealRerunStr:workVO.workdesc]];
        cell.gainLb.numberOfLines = 2;
    }
    else if([dic[@"title"] isEqualToString:@"项目经验"]){
        NSString *stopStr;
        Person_projectDataModel *projectVO = arr[indexPath.row];
        if ([projectVO.person_projectistonow isEqualToString:@"1"]) {
            stopStr = @"至今";
        }else{
            stopStr = [self endTime:projectVO.person_projectstopdate];
        }
        
        cell.timeLb.text = [NSString stringWithFormat:@"%@ 至 %@",[self startTime:projectVO.person_projectstartdate],stopStr];
        cell.proNameLb.text = [NSString stringWithFormat:@"%@",projectVO.person_projectName];
        cell.proNameLb.numberOfLines = 2;
        cell.desLb.numberOfLines = 2;
        cell.gainLb.numberOfLines = 2;
        cell.desLb.textColor = UIColorFromRGB(0x888888);
        if (projectVO.person_projectGain.length > 0) {
            cell.gainBottom.constant = 10;
            NSString *gainStr = [NSString stringWithFormat:@"【 收获成果】%@",[self dealRerunStr:projectVO.person_projectGain]];
            cell.gainLb.attributedText = [LineSpaceHelper dealStrWithLineSpace:gainStr];
        }
        else{
            cell.gainBottom.constant = 0;
            cell.gainLb.text = [self dealRerunStr:projectVO.person_projectGain];
        }
        NSString *detailStr = [NSString stringWithFormat:@"【项目描述】%@",[self dealRerunStr:projectVO.person_projectDesc]];
        cell.desLb.attributedText = [LineSpaceHelper dealStrWithLineSpace:detailStr];
    }

}

-(void)ctlTableCell:(NSIndexPath *)indexPath arr:(NSArray *)arr numLines:(DetailConTableViewCell *)cell withDic:(NSDictionary *)dic{
    if (!cell) {
        cell = [self.view viewWithTag:100 * indexPath.section + indexPath.row];
    }
    cell.detailLab.numberOfLines = 0;
    if([dic[@"title"] isEqualToString:@"教育经历"]){//教育经历
        Person_eduDataModel *eduVO = arr[indexPath.row];
        NSString *stopStr;
        if ([eduVO.istonow isEqualToString:@"1"]) {
            stopStr = @"至今";
        }else{
            stopStr = [self endTime:eduVO.stopdate];
        }
        cell.timeLab.text = [NSString stringWithFormat:@"%@ 至 %@",[self startTime:eduVO.startdate],stopStr];
        cell.introLab.text = [self dealEduSchool:eduVO.school eduId:eduVO.eduId major:eduVO.zym];
        if (eduVO.edus.length == 0) {
            cell.detailLbToBottom.constant = 0;
        }
        else{
            cell.detailLbToBottom.constant = 10;
        }
        cell.detailLab.attributedText = [LineSpaceHelper dealStrWithLineSpace:[self dealRerunStr:eduVO.edus]];
        cell.detailLab.numberOfLines = 2;
    }
    else if([dic[@"title"] isEqualToString:@"培训经历"]){//培训经历
        Person_trainDataModel *trainVO = arr[indexPath.row];
        NSString *stopStr;

        if ([trainVO.train_istonow isEqualToString:@"1"]) {
            stopStr = @"至今";
        }else{
            stopStr = [self endTime:trainVO.train_enddate];
        }
        cell.timeLab.text = [NSString stringWithFormat:@"%@ 至 %@",[self startTime:trainVO.train_startdate],stopStr];
        cell.introLab.text = [NSString stringWithFormat:@"%@ | %@",trainVO.train_institution,trainVO.train_cource];
        if (trainVO.train_cource.length == 0) {
            cell.detailLbToBottom.constant = 0;
        }
        else{
            cell.detailLbToBottom.constant = 10;
        }
        cell.detailLab.text = [self dealRerunStr:trainVO.train_desc];
    }
}

//处理‘\n’
-(NSString *)dealRerunStr:(NSString *)detailStr{
    if ([detailStr containsString:@"\n"]) {
        NSArray *arr = [detailStr componentsSeparatedByString:@"\n"];
        NSString *str = [arr componentsJoinedByString:@""];
        return str;
    }
    return detailStr;
}

//截取字符串
-(NSString *)dealGetProDetail:(NSString *)detailStr{
    if (detailStr.length >= 34) {
        detailStr = [detailStr substringToIndex:34];
    }
    return detailStr;
}
//处理开始结束时间
- (NSString *)startTime:(NSString *)timeStart
{
    if (timeStart.length < 7) {
        return @"";
    }
    return [timeStart substringWithRange:NSMakeRange(0, 7)];
}

//处理开始结束时间
-(NSString *)endTime:(NSString *)timeEnd{
    //add 2016.5.27
    if (timeEnd.length < 7 ||!timeEnd) {
        return @"";
    }
    if ([timeEnd isEqualToString:@"0000-00-00"] || [timeEnd isEqualToString:@"9999-12-00"]) {
        return @"至今";
    }
    else{
        return [timeEnd substringWithRange:NSMakeRange(0, 7)];
    }
}

//处理学校，学历，专业
-(NSString *)dealEduSchool:(NSString *)school eduId:(NSString *)eduId major:(NSString *)major{
    if (school.length > 0 && eduId.length > 0 && major > 0) {
        return [NSString stringWithFormat:@"%@ | %@ | %@",school,[PreCondictionListCtl getEduStr:eduId],major];
    }
    else if(school.length > 0 && eduId.length > 0){
        return [NSString stringWithFormat:@"%@ | %@",school,[PreCondictionListCtl getEduStr:eduId]];
    }
    else if(school.length > 0 && major > 0){
        return [NSString stringWithFormat:@"%@ | %@",school,major];
    }
    else if(eduId.length > 0 && major > 0){
        return [NSString stringWithFormat:@"%@ | %@",[PreCondictionListCtl getEduStr:eduId],major];
    }
    return school;
}

//没有数据默认显示
-(NSString *)noneContent:(NSInteger)noneContentIndex{
    NSArray *noneArr = @[@"",@"暂未添加工作经历",@"暂未添加教育经历",@"暂未添加项目经验",@"暂未编辑自我评价",@"暂未编辑技能特长",@"暂未添加培训经历"];
    if (noneContentIndex < noneArr.count) {
        return noneArr[noneContentIndex];
    }
    return @"";
}

//推出自我评价
-(void)intoIntro{
    __block ModifyResumeViewController *BlockSelf = self;
    //自我评价
    NSDictionary *allInfoDic = _dataArray[0];
    Person_infoDataModel *infoModel = allInfoDic[@"dataArray"][0];
    IntroduceMyselfCtl *introduceCtl = [[IntroduceMyselfCtl alloc] init];
    introduceCtl.backBlock = ^(PersonDetailInfo_DataModal *personData){
        [BlockSelf refreshAllData];
    };
    [introduceCtl beginLoad:infoModel.grzz exParam:nil];
    [self.navigationController pushViewController:introduceCtl animated:YES];
}
//推出技能特长
-(void)intoSkill{
    __block ModifyResumeViewController *BlockSelf = self;
    NSDictionary *allInfoDic = _dataArray[0];
    Person_infoDataModel *infoModel = allInfoDic[@"dataArray"][0];
    Skill_ResumeCtl *skillCtl = [[Skill_ResumeCtl alloc] init];
    skillCtl.block = ^{
        [BlockSelf refreshAllData];
    };
    [skillCtl beginLoad:infoModel.othertc exParam:nil];
    [self.navigationController pushViewController:skillCtl animated:YES];
}
//刷新数据
-(void)refreshAllData{
    [_dataArray removeAllObjects];
    [addArrary removeAllObjects];
    [self refreshLoad];
}
//推出培训经历
-(void)intoTrainDetail{
    __block ModifyResumeViewController *BlockSelf = self;
    NSDictionary *allInfoDic = _dataArray[6];
    NSArray *arr = allInfoDic[@"dataArray"];
    ELTrainDetailCtl *ctl = [[ELTrainDetailCtl alloc] init];
    ctl.allCount = arr.count;
    ctl.addOrEditor = 1;
    ctl.addOrEditorBlock = ^(ProjectResume_DataModal *dataModal,NSString *type)
    {
        [BlockSelf refreshAllData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}
//推出项目经验
-(void)intoPro{
    __block ModifyResumeViewController *BlockSelf = self;
    ProjectViewController *projectVC = [[ProjectViewController alloc]init];
    projectVC.isYjs = rctype;
    projectVC.proType = @"1";
    projectVC.addOrEditorBlock = ^(NSString *state){
        if ([state isEqualToString:@"add"]) {
            [BlockSelf refreshAllData];
        }
    };
    [self.navigationController pushViewController:projectVC animated:YES];
}
//是否隐藏信息完善
-(BOOL)isShowState:(NSArray *)arr{
    Person_infoDataModel *personInfoVO = arr[0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *resume_status = [defaults valueForKey:@"resume_status"];
    
    if (personInfoVO.iname.length > 0 && personInfoVO.sex.length > 0 && personInfoVO.regionid.length > 0 && (personInfoVO.hka.length > 0 && ![personInfoVO.hka isEqualToString:@"0"]) && personInfoVO.rctypeId.length > 0 && personInfoVO.bday.length > 0 && personInfoVO.shouji.length > 0 && personInfoVO.email.length > 0 && personInfoVO.gznum.length > 0 ) {
        if (resume_status.length > 0 && ([resume_status isEqualToString:@"4"] || [resume_status isEqualToString:@"5"] || [resume_status isEqualToString:@"6"] || [resume_status isEqualToString:@"7"])) {
            return YES;
        }
    }
    return NO;
}

//网络异常提示
- (void)showNoNetworkView:(BOOL)flag
{
    //显示
    if( flag ){
        UIView *superView = [self getSuperView];
        UIView *myView = [self getNoNetworkView];
        
        if( superView && myView ){
            [myView removeFromSuperview];
            [superView addSubview:myView];
            [myView setFrame:CGRectMake(0, _myHeaderView.frame.size.height - 114, self.tableView.frame.size.width, self.tableView.contentSize.height)];
        }else{
            [MyLog Log:@"error view's super view or error view is null" obj:self];
        }
    }
    //不显示
    else{
        [[self getNoNetworkView] removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}


@end
