//
//  ZoneSelViewController.m
//  jobClient
//
//  Created by 一览ios on 16/8/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ZoneSelViewController.h"
#import "CondictionList_DataModal.h"
#import "FMDB.h"
#import "DataBase.h"
#import "SqlitData.h"
#import "Experience_SelectionTableViewCell.h"
#import "UIScrollView+touch.h"

@interface ZoneSelViewController ()<UITableViewDelegate,UITableViewDataSource,ExDelegate>{
    NSMutableArray *leftDataArr;
    NSMutableArray *rightDataArr;
    DataBase *dataBase;
    NSMutableArray *dataArr;
    NSString *selectedOtherStr;
    UIView *bgView;
    
    NSString *edu_zoneStr;
    NSString *age_zoneStr;
    NSString *status_zoneStr;
    NSString *leftString;
    NSString *rigntString;
    
    BOOL leftClicked;
    BOOL rightClicked;
    
    NSMutableArray *hotRegionArr;
}
@property (retain, nonatomic)UITableView *leftTable;
@property (retain, nonatomic)UITableView *rightTable;
@property (retain, nonatomic) UIButton *backBtn;
@property (retain, nonatomic)UITableView *mainTable;
@end

@implementation ZoneSelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark--初始化UI
-(void)configUI{
    
    [self createBg];
    self.view.backgroundColor = [UIColor clearColor];
    _backBtn.layer.cornerRadius = 3;
    _backBtn.layer.masksToBounds = YES;
    
    _backBtn.layer.borderWidth = 1;
    _backBtn.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTable.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
    dataArr = [NSMutableArray array];
}
//table设置
-(void)createBg{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 93 - 64 - 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    _leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, bgView.frame.size.height - 67) style:UITableViewStylePlain];
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    [bgView addSubview:_leftTable];
    _leftTable.hidden = YES;
    
    _rightTable = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, bgView.frame.size.height - 67) style:UITableViewStylePlain];
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    [bgView addSubview:_rightTable];
    _rightTable.hidden = YES;
    _rightTable.separatorColor = UIColorFromRGB(0xecedec);
    _rightTable.tableFooterView = [[UIView alloc]init];
    
    _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, bgView.frame.size.height - 67) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [bgView addSubview:_mainTable];
    _mainTable.hidden = YES;
    _mainTable.separatorColor = UIColorFromRGB(0xecedec);
    _mainTable.tableFooterView = [[UIView alloc]init];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_backBtn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    _backBtn.frame = CGRectMake(16, ScreenHeight - 93 - 64 - 44 - 52, ScreenWidth - 32,37);
    [bgView addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainTable registerNib:[UINib nibWithNibName:@"Experience_SelectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"Experience_SelectionTableViewCellId"];
}

#pragma mark--加载数据
-(void)loadData{
    
    [dataArr removeAllObjects];
    [self reconfigUI];
    NSNumber *isSel = getUserDefaults(@"bottomBtn_isSelected");
    BOOL isBottomSel = [isSel boolValue];
    if (!isBottomSel) {
        edu_zoneStr = nil;
        age_zoneStr = nil;
        status_zoneStr = nil;
        leftString = @"全国";
        rigntString = nil;
        [rightDataArr removeAllObjects];
        [_leftTable scrollRectToVisible:CGRectMake(0, 0, ScreenWidth/2, _leftTable.frame.size.height) animated:NO];
        [_mainTable scrollRectToVisible:CGRectMake(0, 0, _mainTable.frame.size.width, _mainTable.frame.size.height) animated:NO];
    }
    if (self.moreSelType == ZoneType) {
        _leftTable.hidden = NO;
        _rightTable.hidden = NO;
        _mainTable.hidden = YES;
        dataBase = [DataBase shareDatabase];
        leftDataArr = [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:@"select * from region_web where level='1'"]];
        SqlitData *hotVO = [SqlitData new];
        hotVO.provinceName = @"热门城市";
        [leftDataArr insertObject:hotVO atIndex:1];
        
        NSMutableArray *arrHot = [[NSMutableArray alloc] initWithObjects:@"北京",@"上海",@"天津",@"重庆",@"广州市",@"深圳市",@"武汉市",@"南京市",@"杭州市",@"成都市",@"西安市",nil];
        NSArray *arrHotId = @[@"110000",@"310000",@"120000",@"500000",@"440100",@"440300",@"420100",@"320100",@"330100",@"510100",@"610100"];
        hotRegionArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrHot.count; i++) {
            SqlitData *modal = [SqlitData new];
            modal.provinceName = arrHot[i];
            modal.provinceld = arrHotId[i];
            [hotRegionArr addObject:modal];
        }
        
        [_leftTable reloadData];
        [_rightTable reloadData];
    }
    else{
        _leftTable.hidden = YES;
        _rightTable.hidden = YES;
        _mainTable.hidden = NO;
        if (self.moreSelType == More_EduType) {//学历
            [self Edu];
        }
        else if(self.moreSelType == More_AgeType){
            [self age];
        }
        else if(self.moreSelType == More_ReadStatusType){
            [self readStatus];
        }
        [_mainTable reloadData];
    }
    if (_isZone) {
        _backBtn.hidden = YES;
    }
    else{
        _backBtn.hidden = NO;
    }
}

#pragma mark--请求数据

#pragma mark--代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_leftTable]) {
        return leftDataArr.count;
    }
    else if([tableView isEqual:_rightTable]){
        return rightDataArr.count;
    }
    else{
        return dataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"settingCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, ScreenWidth * 0.7, 20)];
    titleLb.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:titleLb];
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    if ([tableView isEqual:_leftTable]) {
        SqlitData *dataVO = leftDataArr[indexPath.row];
        titleLb.text = dataVO.provinceName;
        titleLb.textColor = UIColorFromRGB(0x333333);
        if ([leftString isEqualToString:dataVO.provinceName]) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        else{
            cell.contentView.backgroundColor = UIColorFromRGB(0xf4f4f4);
        }
    }
    else{
        [cell.contentView addSubview:img];
        if ([tableView isEqual:_rightTable]) {
            img.frame = CGRectMake(ScreenWidth/2 - 31, 16, 18, 18);
            SqlitData *dataVO = rightDataArr[indexPath.row];
            titleLb.text = dataVO.provinceName;
            [self fromStr:rigntString toStr:dataVO.provinceName label:titleLb image:img];
        }
        if ([tableView isEqual:_mainTable]) {
            img.frame = CGRectMake(ScreenWidth - 31, 16, 18, 18);
            CondictionList_DataModal *dataVO = dataArr[indexPath.row];
            titleLb.text = dataVO.str_;
            if (self.moreSelType == More_AgeType) {
                if (indexPath.row == 1) {
                    Experience_SelectionTableViewCell *experienceCell = [tableView dequeueReusableCellWithIdentifier:@"Experience_SelectionTableViewCellId" forIndexPath:indexPath];
                    experienceCell.delegate = self;
                    experienceCell.sureBtn.tag = indexPath.row + 12120;
                    return experienceCell;
                }
                else{
                    [self fromStr:age_zoneStr toStr:dataVO.str_ label:titleLb image:img];
                }
            }
            if (self.moreSelType == More_EduType) {
                [self fromStr:edu_zoneStr toStr:dataVO.str_ label:titleLb image:img];
            }
            if(self.moreSelType == More_ReadStatusType){
                [self fromStr:status_zoneStr toStr:dataVO.str_ label:titleLb image:img];
            }
        }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.moreSelType == More_AgeType) {
        if (indexPath.row == 1){
            return 48;
        }
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kUserDefaults(@(YES), @"bottomBtn_isSelected");
    kUserSynchronize;
    if ([tableView isEqual:_leftTable]) {
        SqlitData *dataVO = leftDataArr[indexPath.row];
        leftClicked = YES;
        leftString = dataVO.provinceName;
        if ([dataVO.provinceName isEqualToString:@"全国"]) {
            rigntString = nil;
            rightDataArr = nil;
            if ([_delegate respondsToSelector:@selector(rightCellSelected)]) {
                [_delegate rightCellSelected];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ZoneSelected_Already" object:nil userInfo:@{@"ZoneSelected":dataVO}];
        }
        else{
            if ([dataVO.provinceName isEqualToString:@"热门城市"]) {
                rightDataArr = [[NSMutableArray alloc] initWithArray:hotRegionArr];
            }
            else{
                rightDataArr =  [[NSMutableArray alloc] initWithArray:[dataBase selectWithString:[NSString stringWithFormat:@"select * from region_web where parentId='%@'",dataVO.provinceld]]];
            }
            [_rightTable reloadData];
            [_leftTable reloadData];
        }
        
    }
    else if([tableView isEqual:_rightTable]){
        SqlitData *dataVO = rightDataArr[indexPath.row];
        rigntString = dataVO.provinceName;
        rightClicked = YES;
        [_rightTable reloadData];
        if ([_delegate respondsToSelector:@selector(rightCellSelected)]) {
            [_delegate rightCellSelected];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ZoneSelected_Already" object:nil userInfo:@{@"ZoneSelected":dataVO}];
    }
    else{
        CondictionList_DataModal *dataVO = dataArr[indexPath.row];
        [_mainTable reloadData];
        if ([_delegate respondsToSelector:@selector(rightCellSelected)]) {
            [_delegate rightCellSelected];
        }
        if (self.moreSelType == More_EduType) {
            edu_zoneStr = dataVO.str_;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"OtherSelected_Already" object:@(1) userInfo:@{@"OtherSelected":dataVO}];
        }
        
         if (self.moreSelType == More_AgeType){
            age_zoneStr = dataVO.str_;
            UITextField *lowTxt = [self.view viewWithTag:101010];
            UITextField *highTxt = [self.view viewWithTag:101011];
            lowTxt.text = @"";
            highTxt.text = @"";
             
             if (_resumeType == ResumeTypePersonDelivery) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"OtherSelected_Already" object:@(2) userInfo:@{@"OtherSelected":dataVO}];
             }else if (_resumeType == ResumeTypeAdviserRecommend){
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"OtherSelected_Already" object:@(1) userInfo:@{@"OtherSelected":dataVO}];
             }
            
        }
        else if(self.moreSelType == More_ReadStatusType){
            status_zoneStr = dataVO.str_;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"OtherSelected_Already" object:@(3) userInfo:@{@"OtherSelected":dataVO}];
        }
        
    }
}

#pragma mark - sureBtnClicked
-(void)sureBtnClicked:(UIButton *)btn{
    kUserDefaults(@(YES), @"bottomBtn_isSelected");
    kUserSynchronize;
    [self.view endEditing:YES];
    UITextField *lowTxt = [self.view viewWithTag:101010];
    UITextField *highTxt = [self.view viewWithTag:101011];
    CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
    dataVO.id_ = lowTxt.text;
    dataVO.id_1 = highTxt.text;
    if (lowTxt.text.length > 0 && highTxt.text.length > 0) {
        NSInteger lowNum = [lowTxt.text integerValue];
        NSInteger highNum = [highTxt.text integerValue];
        if (lowNum <= highNum) {
            dataVO.str_ = [NSString stringWithFormat:@"%@-%@",lowTxt.text,highTxt.text];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的年龄"    delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的年龄"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    age_zoneStr = @"";
    if ([_delegate respondsToSelector:@selector(rightCellSelected)]) {
        [_delegate rightCellSelected];
    }
    if (_resumeType == ResumeTypePersonDelivery) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"OtherSelected_Already" object:@(2) userInfo:@{@"OtherSelected":dataVO}];
    }else if (_resumeType == ResumeTypeAdviserRecommend){
         [[NSNotificationCenter defaultCenter]postNotificationName:@"OtherSelected_Already" object:@(1) userInfo:@{@"OtherSelected":dataVO}];
    }
}

#pragma mark--事件
- (void)backBtnClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(backBtnClicked:)]) {
        [_delegate backBtnClicked:sender];
    }
}

#pragma mark--通知

#pragma mark--业务逻辑
-(void)fromStr:(NSString *)fromStr toStr:(NSString *)toStr label:(UILabel *)titleLb image:(UIImageView *)img{
    if ([fromStr isEqualToString:toStr]) {
        img.hidden = NO;
        titleLb.textColor = UIColorFromRGB(0xe13e3e);
    }
    else{
        img.hidden = YES;
        titleLb.textColor = UIColorFromRGB(0x333333);
    }
}

-(void)label:(UILabel *)titleLb image:(UIImageView *)img idx:(NSIndexPath *)indexPath{
    CondictionList_DataModal *dataVO = dataArr[indexPath.row];
    if (dataVO.bSelected_ == YES) {
        img.hidden = NO;
        titleLb.textColor = UIColorFromRGB(0xe13e3e);
    }
    else{
        img.hidden = YES;
        titleLb.textColor = UIColorFromRGB(0x333333);
    }
}
//重新设定table大小
-(void)reconfigUI{
    if (self.moreSelType == ZoneType) {
        bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44 - 93);
        if (_isZone) {
            _rightTable.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, bgView.frame.size.height);
            _leftTable.frame = CGRectMake(0, 0, ScreenWidth/2, bgView.frame.size.height);
        }
        else{
            _rightTable.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, bgView.frame.size.height - 67);
            _leftTable.frame = CGRectMake(0, 0, ScreenWidth/2, bgView.frame.size.height - 67);
            _backBtn.frame = CGRectMake(16, ScreenHeight - 93 - 64 - 44 - 52, ScreenWidth - 32,39);
        }
    }
//    else if(self.moreSelType == More_EduType){
//        bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 93 - 64 - 44);
//        _mainTable.frame = CGRectMake(0, 0, ScreenWidth, bgView.frame.size.height - 67);
//        _backBtn.frame = CGRectMake(16, ScreenHeight - 93 - 64 - 44 - 52, ScreenWidth - 32,39);
//    }
    else{
        bgView.frame = CGRectMake(0, 0, ScreenWidth, 44 * 5 + 67);
        _mainTable.frame = CGRectMake(0, 0, ScreenWidth, 44 * 5);
        _backBtn.frame = CGRectMake(16, 44 * 5 + 15, ScreenWidth - 32,39);
    }
}
//学历
-(void)Edu{
    NSArray *eduNameArr = @[@"不限", @"博士后", @"博士", @"MBA", @"硕士", @"本科", @"大专", @"中专", @"中技", @"高中", @"初中"];
    NSArray *eduValueArray_ = [[NSArray alloc]initWithObjects:@"", @"90", @"80", @"75", @"70", @"60", @"50", @"40", @"30", @"20", @"10",nil];
    for (int i = 0; i < eduNameArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.str_ = eduNameArr[i];
        dataVO.id_ = eduValueArray_[i];
        [dataArr addObject:dataVO];

    }
}
//年龄
-(void)age{
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
-(void)readStatus{
    NSArray *readStatusArr = [[NSArray alloc]initWithObjects:@"不限",@"已阅",@"未阅", nil];
    NSArray *readStatusValueArr = [[NSArray alloc]initWithObjects:@"",@"1",@"0", nil];
    for (int i = 0; i < readStatusArr.count; i++) {
        CondictionList_DataModal *dataVO = [CondictionList_DataModal new];
        dataVO.id_ = readStatusValueArr[i];
        dataVO.str_ = readStatusArr[i];
        [dataArr addObject:dataVO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
