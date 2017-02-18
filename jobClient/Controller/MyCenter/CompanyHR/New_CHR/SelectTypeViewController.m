//
//  SelectTypeViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/29.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "CondictionList_DataModal.h"
#import "TradeZWModel.h"
#import "Experience_SelectionTableViewCell.h"
#import "More_NewTableViewCell.h"
#import "SqlitData.h"
#import "SearchParam_DataModal.h"
@interface SelectTypeViewController ()<UITableViewDelegate,UITableViewDataSource,ExDelegate>{
    NSMutableArray *dataArr;
    NSMutableDictionary *selectedDic;
    NSMutableArray *positionSelectionArr;
    UIButton *bottomBtn;
    NSMutableDictionary *resumeMoreDataDic;
    
    SqlitData *receivePriveceData;
    CondictionList_DataModal *moreEduDataVO;
    CondictionList_DataModal *moreAgeDataVO;
    CondictionList_DataModal *moreStatusDataVO;
    
    NSMutableArray *jobTimeArr;//场次
    NSMutableArray *positionArr;//职位
    NSString *isPositionFirstSel;//职位的不限
    
    NSString *statusStr;//状态
    NSString *experenceStr;//经验
    NSString *eduStr;//学历
    NSString *ageStr;//年龄
    NSString *selecStr;//筛选
    NSString *timesStr;//场次
    NSString *downStatusStr;//主动下载状态
    NSString *workAge;//工作年限
    NSString *turnStatus;//转发给我状态
    NSString *readStatus;//阅读状态
    
    BOOL isCellSelected;
    BOOL isRepeat;
    
    NSString *lowAge;
    NSString *highAge;
    NSString *lowWorkAge;
    NSString *highWorkAge;
}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,copy) NSString *selectedTitleStr;
@end

@implementation SelectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark--初始化UI
-(void)configUI{
    _type = -1;
    selectedDic = [NSMutableDictionary dictionary];
    dataArr = [NSMutableArray array];
    positionArr = [NSMutableArray array];
    jobTimeArr = [NSMutableArray array];
    positionSelectionArr = [NSMutableArray array];

    self.view.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 93 - 64 - 44)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor whiteColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorColor = UIColorFromRGB(0xedeced);
    [_bgView addSubview:_table];
    
    bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.backgroundColor = UIColorFromRGB(0xe13e3e);
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    bottomBtn.layer.cornerRadius = 2;
    bottomBtn.layer.masksToBounds = YES;
    bottomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_bgView addSubview:bottomBtn];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.hidden = YES;
    
//    [_table registerNib:[UINib nibWithNibName:@"Experience_SelectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"Experience_SelectionTableViewCellId"];
    
    [self addNotify];
}



#pragma mark--加载数据
-(void)loadData{
    [dataArr removeAllObjects];
    [self selectionDeal];
    [self reConfigUIWithType:NO];
    [_table reloadData];
}

-(void)selectionDeal{
    bottomBtn.hidden = YES;
    if (_selecType == PositionType) {//职位
        bottomBtn.hidden = NO;
        [self position];
    }
     else if(_selecType == DeliverStatusType){//投递应聘状态
            [self dealStatus];
        }
        else if(_selecType == ExperenceType){//经验
            [self experience];
        }
        else if(_selecType == DeliverMoreType){//更多
            
            [self more];
            NSNumber *isSel = getUserDefaults(@"bottomBtn_isSelected");
            BOOL isBottomSel = [isSel boolValue];
            if (!isBottomSel) {
                receivePriveceData = nil;
                moreEduDataVO = nil;
                moreAgeDataVO = nil;
                moreStatusDataVO = nil;
            }
            bottomBtn.frame = CGRectMake(16, dataArr.count*44+15, ScreenWidth - 32, 39);
            bottomBtn.hidden = NO;
            
        }
        else if(_selecType == ELTimesType){//一览精选场次
            [self jobTime];
        }
        else if(_selecType == DownStatusType){//主动下载状态
            [self mainDealStatus];
        }
        else if(_selecType == AgeType){//年龄
            [self ageSet];
        }
        else if(_selecType == SelectType){//筛选
            [self selectedType];
        }
        else if(_selecType == EduType){//学历
            [self dealEdu];
        }
        else if(_selecType == WorkAgeAll){//工作年限
            [self workAgeAll];
        }
        else if(_selecType == Turn_Status){//转发给我状态
            [self turnStatusData];
        }
        else if (_selecType == read_Status){//阅读状态
            [self readStatus];
        }
}

#pragma mark--请求数据

#pragma mark--代理
#pragma mark--scroll代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark-tableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"settingCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.selecType == DeliverMoreType){//更多
        return [self table:tableView indexPath:indexPath];
    }
    
    CondictionList_DataModal *dataVO = dataArr[indexPath.row];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 31, 16, 18, 18)];
    img.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    [cell.contentView addSubview:img];
    img.hidden = YES;
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, ScreenWidth * 0.7, 20)];
    titleLb.font = [UIFont systemFontOfSize:15];
    if (dataVO.positionMark.length > 0 || [dataVO.positionMark isEqualToString:@""]) {//职位
        if ([dataVO.id_ isEqualToString:_condictionList_DataModal.id_]) {
            dataVO.bSelected_ = YES;
            _condictionList_DataModal = nil;
        }
        [self deal:titleLb image:img dataModel:dataVO];
    }
    else{
        titleLb.text = dataVO.str_;
        if(_selecType == DeliverStatusType){//投递应聘状态
            [self fromStr:statusStr toStr:dataVO.str_ label:titleLb img:img];
        }
        else if(_selecType == ExperenceType){//经验
            if (indexPath.row == 2) {
//                Experience_SelectionTableViewCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"Experience_SelectionTableViewCellId" forIndexPath:indexPath];
                Experience_SelectionTableViewCell *experienceCell = [[NSBundle mainBundle]loadNibNamed:@"Experience_SelectionTableViewCell" owner:self options:nil].firstObject;
                experienceCell.delegate = self;
                experienceCell.sureBtn.tag = indexPath.row + 12120;
                if (lowWorkAge.length > 0 && highWorkAge.length > 0) {
                    experienceCell.lowTxt.text = lowWorkAge;
                    experienceCell.highTxt.text = highWorkAge;
                }
                return experienceCell;
            }
            else{
                [self fromStr:experenceStr toStr:dataVO.str_ label:titleLb img:img];
            }
        }
        else if(_selecType == ELTimesType){//一览精选场次
            [self fromStr:timesStr toStr:dataVO.str_ label:titleLb img:img];
        }
        else if(_selecType == DownStatusType){//主动下载状态
           [self fromStr:downStatusStr toStr:dataVO.str_ label:titleLb img:img];
        }
        else if(_selecType == AgeType){//年龄
            if (indexPath.row == 1) {
//                Experience_SelectionTableViewCell *ageCell = [tableView dequeueReusableCellWithIdentifier:@"Experience_SelectionTableViewCellId" forIndexPath:indexPath];
                Experience_SelectionTableViewCell *ageCell = [[NSBundle mainBundle]loadNibNamed:@"Experience_SelectionTableViewCell" owner:self options:nil].firstObject;
                ageCell.delegate = self;
                ageCell.sureBtn.tag = indexPath.row + 12120;
                if (lowAge.length > 0 && highAge.length > 0) {
                    ageCell.lowTxt.text = lowAge;
                    ageCell.highTxt.text = highAge;
                }
                return ageCell;
            }
            else{
                [self fromStr:ageStr toStr:dataVO.str_ label:titleLb img:img];
            }
        }
        else if(_selecType == SelectType){//筛选
            [self fromStr:selecStr toStr:dataVO.str_ label:titleLb img:img];
        }
        else if(_selecType == EduType){//学历
            [self fromStr:eduStr toStr:dataVO.str_ label:titleLb img:img];
        }
        else if(_selecType == WorkAgeAll){//工作年限
            [self fromStr:workAge toStr:dataVO.str_ label:titleLb img:img];
        }
        else if(_selecType == Turn_Status){//转发给我状态
            [self fromStr:turnStatus toStr:dataVO.str_ label:titleLb img:img];
        }
        else if (_selecType == read_Status){//阅读状态
             [self fromStr:readStatus toStr:dataVO.str_ label:titleLb img:img];
        }
    }
    [cell.contentView addSubview:titleLb];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selecType == ExperenceType) {
        if (indexPath.row == 2){
            return 48;
        }
    }
    if (self.selecType == AgeType) {
        if (indexPath.row == 1) {
            return 48;
        }
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CondictionList_DataModal *dataVO = dataArr[indexPath.row];
    if (self.selecType == DeliverMoreType) {
        isCellSelected = YES;
        if ([_delegate respondsToSelector:@selector(moreSelBtnClick:)]) {
            [_delegate moreSelBtnClick:indexPath];
        }
        return;
    }
    if (dataVO.positionMark.length > 0 || [dataVO.positionMark isEqualToString:@""]){//职位
        [self dealPositionMutableSel:dataVO];
    }
    else{
       if(_selecType == DeliverStatusType){//投递应聘状态
           statusStr = dataVO.str_;
        }
        else if(_selecType == ExperenceType){//经验
            if (indexPath.row == 2) {
                return;
            }
            experenceStr = dataVO.str_;
            UITextField *lowTxt = [self.view viewWithTag:101010];
            UITextField *highTxt = [self.view viewWithTag:101011];
            lowTxt.text = @"";
            highTxt.text = @"";
            
        }
        else if(_selecType == ELTimesType){//一览精选场次
            timesStr = dataVO.str_;
        }
        else if(_selecType == DownStatusType){//主动下载状态
            downStatusStr = dataVO.str_;
        }
        else if(_selecType == AgeType){//年龄
            if (indexPath.row == 1) {
                return;
            }
            ageStr = dataVO.str_;
            UITextField *lowTxt = [self.view viewWithTag:101010];
            UITextField *highTxt = [self.view viewWithTag:101011];
            lowTxt.text = @"";
            highTxt.text = @"";
            
        }
        else if(_selecType == SelectType){//筛选
            selecStr = dataVO.str_;
        }
        else if(_selecType == EduType){//学历
            eduStr = dataVO.str_;
        }
        else if(_selecType == WorkAgeAll){//工作年限
            workAge = dataVO.str_;
        }
        else if(_selecType == Turn_Status){
            turnStatus = dataVO.str_;
        }
        else if (_selecType == read_Status){
            readStatus = dataVO.str_;
        }
        self.selectBolck(dataVO);
    }
    [_table reloadData];
}

//ExDelegate
-(void)sureBtnClicked:(UIButton *)btn{
    experenceStr = @"";
    ageStr = @"";
    [self.view endEditing:YES];
    UITextField *lowTxt = [self.view viewWithTag:101010];
    UITextField *highTxt = [self.view viewWithTag:101011];
    CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
    dataVO.id_ = lowTxt.text;
    dataVO.id_1 = highTxt.text;
    if (lowTxt.text.length > 0 && highTxt.text.length > 0) {
        dataVO.str_ = [NSString stringWithFormat:@"%@-%@",lowTxt.text,highTxt.text];
        if (self.selecType == AgeType) {
            NSInteger lowNum = [lowTxt.text integerValue];
            NSInteger highNum = [highTxt.text integerValue];
            if (lowNum <= highNum) {
                lowAge = lowTxt.text;
                highAge = highTxt.text;
            }
            else{
                [self alert:@"请输入正确的年龄"];
                return;
            }
        }
        else if (self.selecType == ExperenceType) {
            NSInteger lowNum = [lowTxt.text integerValue];
            NSInteger highNum = [highTxt.text integerValue];
            if (lowNum <= highNum) {
                lowWorkAge = lowTxt.text;
                highWorkAge = highTxt.text;
            }
            else{
                [self alert:@"请输入正确工作年限"];
                return;
            }
        }
    }
    else{
        if (self.selecType == AgeType) {
            [self alert:@"请输入正确的年龄"];
        }
        if (self.selecType == ExperenceType) {
            [self alert:@"请输入工作年限"];
        }
        return;
    }
    self.selectBolck(dataVO);
}

#pragma mark--事件
-(void)bottomBtnClick:(UIButton *)sender{
    if (isCellSelected) {
        kUserDefaults(@(YES), @"bottomBtn_isSelected");
    }
    else{
        kUserDefaults(@(NO), @"bottomBtn_isSelected");
    }
    kUserSynchronize;
    if(self.selecType == PositionType){
        self.selectBolck(positionSelectionArr);
    }
    else if(self.selecType == DeliverMoreType){
        SearchParam_DataModal *searchVO = [SearchParam_DataModal new];
        searchVO.regionId_ = receivePriveceData.provinceld;
        searchVO.eduId_ = moreEduDataVO.id_;
        searchVO.age1 = moreAgeDataVO.id_;
        searchVO.age2 = moreAgeDataVO.id_1;
        searchVO.workTypeName_ = moreStatusDataVO.id_;
        searchVO.isRepeat = isRepeat;
        self.selectBolck(searchVO);
    }
    [_table reloadData];
}

-(void) switchAction:(id)sender
{
    UISwitch * switchBtn = (UISwitch *)sender;
    if (switchBtn.isOn) {
        isRepeat = YES;
    }
    else{
        isRepeat = NO;
    }
}
#pragma mark--通知


-(void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify:) name:@"ZoneSelected_Already" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotified:) name:@"OtherSelected_Already" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePositionNotified:) name:@"position_data_success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJobTimeNotify:) name:@"JobTime_data_success" object:nil];
}
//地区
-(void)receiveNotify:(NSNotification *)notify{
    NSDictionary *userInfo = notify.userInfo;
    receivePriveceData = userInfo[@"ZoneSelected"];
    if (receivePriveceData) {
        [_table reloadData];
    }
}

//其他
-(void)receiveNotified:(NSNotification *)notify{
    NSDictionary *userInfo = notify.userInfo;
    NSNumber *num = notify.object;
    if ([num integerValue] == 1 && _deliverType == 0) {
        moreEduDataVO = userInfo[@"OtherSelected"];
    }
    else if (([num integerValue] == 2 && _deliverType == 0)||([num integerValue] == 1 && _deliverType == 2)){
        moreAgeDataVO = userInfo[@"OtherSelected"];
    }
    else if([num integerValue] == 3 && _deliverType == 0){
        moreStatusDataVO = userInfo[@"OtherSelected"];
    }
    [_table reloadData];
}
//职位
-(void)receivePositionNotified:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    positionArr = dic[@"position_get"];
}

-(void)receiveJobTimeNotify:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    jobTimeArr = dic[@"JobTime_data"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark--业务逻辑
//弹框
-(void)alert:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:title    delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil];
    [alert show];
}
//设置label和img状态
-(void)fromStr:(NSString *)fromStr toStr:(NSString *)toStr label:(UILabel *)titleLb img:(UIImageView *)img{
    if ([fromStr isEqualToString:toStr]) {
        titleLb.textColor = UIColorFromRGB(0xe13e3e);
        img.hidden = NO;
    }
    else{
        titleLb.textColor = UIColorFromRGB(0x333333);
        img.hidden = YES;
    }
}

//更多
-(More_NewTableViewCell *)table:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    More_NewTableViewCell *moreCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!moreCell) {
        moreCell = [[NSBundle mainBundle]loadNibNamed:@"More_NewTableViewCell" owner:self options:nil].firstObject;
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    moreCell.nameLb.text = dataArr[indexPath.row];
    if ((indexPath.row == 2 && _deliverType == 2) ||(indexPath.row == 4 && _deliverType == 0)) {
        [moreCell.switchBtn setOn:isRepeat];
        moreCell.switchBtn.hidden = NO;
        moreCell.DetailLb.hidden = YES;
        moreCell.rightMarkImg.hidden = YES;
        [moreCell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    else{
        moreCell.switchBtn.hidden = YES;
        moreCell.DetailLb.hidden = NO;
        moreCell.rightMarkImg.hidden = NO;
    }
    if (indexPath.row == 0) {
        moreCell.DetailLb.text = receivePriveceData.provinceName;
    }
    else if(indexPath.row == 1 && _deliverType == 0){
        moreCell.DetailLb.text = moreEduDataVO.str_;
    }
    else if((indexPath.row == 2 && _deliverType == 0) || (indexPath.row == 1 && _deliverType == 2)){
        moreCell.DetailLb.text = moreAgeDataVO.str_;
    }
    else if(indexPath.row == 3){
        moreCell.DetailLb.text = moreStatusDataVO.str_;
    }
    return moreCell;
}

//处理职位多选状态
-(void)dealPositionMutableSel:(CondictionList_DataModal *)dataVO{
    if ([dataVO.str_ isEqualToString:@"不限"]) {
        for (CondictionList_DataModal *VO in positionSelectionArr) {
            VO.bSelected_ = NO;
        }
        [positionSelectionArr removeAllObjects];
        isPositionFirstSel = dataVO.str_;
    }
    else{
        isPositionFirstSel = nil;
        if (!dataVO.bSelected_) {
            dataVO.bSelected_ = YES;
            [positionSelectionArr addObject:dataVO];
        }
        else{
            dataVO.bSelected_ = NO;
            [positionSelectionArr removeObject:dataVO];
        }
    }
}

//处理职位选择数据
-(void)deal:(UILabel *)titleLb image:(UIImageView *)img dataModel:(CondictionList_DataModal *)dataVO{
    if ([dataVO.positionMark isEqualToString:@"1"]) {
        titleLb.text = [NSString stringWithFormat:@"%@(在招)",dataVO.str_];
    }
    else if(([dataVO.positionMark isEqualToString:@"0"])){
        titleLb.text = [NSString stringWithFormat:@"%@(停招)",dataVO.str_];
    }
    else{
        titleLb.text = dataVO.str_;
    }
    
    if ([dataVO.str_ isEqualToString:isPositionFirstSel]) {
        titleLb.textColor = UIColorFromRGB(0xe13e3e);
        img.hidden = NO;
    }
    else{
        if(!dataVO.bSelected_){
            if ([dataVO.positionMark isEqualToString:@"1"]) {
                titleLb.textColor = UIColorFromRGB(0x333333);
            }
            else{
                titleLb.textColor = UIColorFromRGB(0xaaaaaa);
            }
            if ([dataVO.str_ isEqualToString:@"不限"]) {
                titleLb.textColor = UIColorFromRGB(0x333333);
            }
            img.hidden = YES;
        }
        else{
            titleLb.textColor = UIColorFromRGB(0xe13e3e);
            img.hidden = NO;
        }
    }
   
}
//table大小设置
-(void)reConfigUIWithType:(BOOL)isRequest{
    if (dataArr.count > 0) {
        if (self.selecType == DeliverMoreType) {
            _bgView.frame = CGRectMake(0, 0, ScreenWidth, 44 * dataArr.count + 67);
            _table.frame = CGRectMake(0, 0, ScreenWidth, 44 * dataArr.count);
        }
        else{
            if (44 * dataArr.count > ScreenHeight - 64 - 44 - 93) {
                _bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44 - 93);
                if (self.selecType == PositionType) {
                    _table.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44 - 93 - 67);
                    bottomBtn.frame = CGRectMake(16, ScreenHeight - 52 - 93 - 64 - 44, ScreenWidth - 32, 39);
                }
                else{
                    _table.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44 - 93);
                }
                
            }
            else{
                _table.frame = CGRectMake(0, 0, ScreenWidth, 44 * dataArr.count + 4);
                if (self.selecType == PositionType) {
                    _bgView.frame = CGRectMake(0, 0, ScreenWidth, 44 * dataArr.count + 67);
                    bottomBtn.frame = CGRectMake(16, _table.bottom + 10, ScreenWidth - 32, 39);
                }
                else{
                    _bgView.frame = CGRectMake(0, 0, ScreenWidth, 44 * dataArr.count + 4);
                }
                
            }
        }
    }
    else{
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, 0);
        _table.frame = CGRectMake(0, 0, ScreenWidth, 0);
    }
}



//学历
-(void)dealEdu{
    NSArray *eduNameArr = @[@"不限", @"博士后", @"博士", @"MBA", @"硕士", @"本科", @"大专", @"中专", @"中技", @"高中", @"初中"];
    NSArray *eduValueArray_ = [[NSArray alloc]initWithObjects:@"", @"90", @"80", @"75", @"70", @"60", @"50", @"40", @"30", @"20", @"10",nil];
    for (int i = 0; i < eduNameArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.str_ = eduNameArr[i];
        dataVO.id_ = eduValueArray_[i];
        [dataArr addObject:dataVO];
    }
}
//投递状态
-(void)dealStatus{
    NSArray *statusStrArr;
    NSArray *statusNumArr;
    if(_deliverType == 0){
        statusStrArr = @[@"不限", @"待处理", @"合适简历", @"等待面试", @"通过面试",@"已发offer",@"不合适"];
        statusNumArr = @[@"",@"0", @"1", @"20", @"40", @"60",@"5"];
    }
    else if(_deliverType == 2){
        statusStrArr = @[@"不限", @"待处理", @"合适简历",@"已到场",@"等待面试",@"通过面试",@"已发offer",@"不合适"];
        statusNumArr = @[@"",@"0", @"1", @"30", @"20", @"40", @"60",@"5"];
    }
    for (int i = 0; i < statusStrArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.str_ = statusStrArr[i];
        dataVO.id_ = statusNumArr[i];
        [dataArr addObject:dataVO];
    }
}
//主动下载状态
-(void)mainDealStatus{

    NSArray *statusStrArr = @[@"不限", @"等待面试", @"通过面试",@"已发offer",@"不合适"];
    NSArray *statusNumArr = @[@"", @"20", @"40", @"60",@"5"];
    for (int i = 0; i < statusStrArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.str_ = statusStrArr[i];
        dataVO.id_ = statusNumArr[i];
        [dataArr addObject:dataVO];
    }
}

//场次
-(void)jobTime{
    if (jobTimeArr.count > 0) {
        dataArr = [NSMutableArray arrayWithArray:jobTimeArr];
        [self reConfigUIWithType:NO];
        [_table reloadData];
        return;
    }
}

//职位
-(void)position{
    if (positionArr.count > 0) {
        dataArr = [NSMutableArray arrayWithArray:positionArr];
        [self reConfigUIWithType:NO];
        [_table reloadData];
        return;
    }
}
//经验
-(void)experience{
    NSArray *ageArray_ = [[NSArray alloc]initWithObjects:@"不限",@"应届毕业生",@"", nil];
    NSArray *ageValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"", nil];
    NSArray *ageValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"0",@"", nil];
    for (int i = 0; i < ageArray_.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.id_ = ageValueArray_[i];
        dataVO.str_ = ageArray_[i];
        dataVO.id_1 = ageValueArray_1[i];
        [dataArr addObject:dataVO];
    }
}

//筛选
-(void)selectedType{
    NSArray *selArr = @[@"全部",@"转发评审",@"面试评审"];
    for (int i = 0; i < selArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.str_ = selArr[i];
        [dataArr addObject:dataVO];
    }
}

//转发给我状态
-(void)turnStatusData{
    NSArray *turnStatusArr = @[@"不限",@"未评审",@"评审通过",@"评审不通过"];
    for (int i = 0; i < turnStatusArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.str_ = turnStatusArr[i];
        [dataArr addObject:dataVO];
    }
}

//年龄
-(void)ageSet{

    NSArray *ageArray_ = [[NSArray alloc]initWithObjects:@"不限",@"", nil];
    NSArray *ageValueArray_ = [[NSArray alloc]initWithObjects:@"",@"", nil];
    NSArray *ageValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"", nil];
    for (int i = 0; i < ageArray_.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.id_ = ageValueArray_[i];
        dataVO.str_ = ageArray_[i];
        dataVO.id_1 = ageValueArray_1[i];
        [dataArr addObject:dataVO];
    }
}

//阅读状态
- (void)readStatus
{
    NSArray *readStatusArr = [[NSArray alloc]initWithObjects:@"不限",@"已阅",@"未阅", nil];
    NSArray *readStatusValueArr = [[NSArray alloc]initWithObjects:@"",@"1",@"0", nil];
    for (int i = 0; i < readStatusArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.id_ = readStatusValueArr[i];
        dataVO.str_ = readStatusArr[i];
        [dataArr addObject:dataVO];
    }
}
//更多
-(void)more{
    
    NSArray *resumeMoreDataArr;
    if (_deliverType == 2) {
        resumeMoreDataArr = @[@"地区",@"年龄"];
    }else if (_deliverType == 0){
        resumeMoreDataArr = @[@"地区",@"学历",@"年龄",@"阅读状态",@"过滤重复简历"];
    }
    
    dataArr = [NSMutableArray arrayWithArray:resumeMoreDataArr];
}


//工作年限
-(void)workAgeAll{
    NSArray *workAgeArray_;
    NSArray *workAgeValueArray_;
    NSArray *workAgeValueArray_1;
    if (_isGuwen) {
        workAgeArray_ = [[NSArray alloc]initWithObjects:@"不限",@"应届毕业生",@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年及以上", nil];
        workAgeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"0",@"1",@"3",@"5",@"10", nil];
        workAgeValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"",@"1",@"3",@"5",@"10",@"0", nil];
    }
    else{
        workAgeArray_ = [[NSArray alloc]initWithObjects:@"不限",@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年及以上", nil];
        workAgeValueArray_ = [[NSArray alloc]initWithObjects:@"",@"0",@"1",@"3",@"5",@"10", nil];
        workAgeValueArray_1 = [[NSArray alloc]initWithObjects:@"",@"1",@"3",@"5",@"10",@"0", nil];
    }
    for (int i = 0; i < workAgeArray_.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.id_ = workAgeValueArray_[i];
        dataVO.str_ = workAgeArray_[i];
        dataVO.id_1 = workAgeValueArray_1[i];
        [dataArr addObject:dataVO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
