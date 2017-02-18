//
//  ChangeRegionViewController.m
//  changeRegion
//
//  Created by 一览iOS on 14-12-15.
//  Copyright (c) 2014年 TestDemo. All rights reserved.
//

#import "ChangeRegionViewController.h"
#import "DataBase.h"
#import "SqlitData.h"

@interface ChangeRegionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL        bLocation_;
    SqlitData   *leftModel;
    SqlitData   *rightModel;
}
@property (nonatomic,strong) UITableView *tableOne;
@property (nonatomic,strong) UITableView *tableTwo;
@property (nonatomic,strong) NSMutableArray *arrOne;
@property (nonatomic,strong) NSMutableArray *arrTwo;
@property (nonatomic,strong) DataBase *dataBase;

@end

@implementation ChangeRegionViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"完成";
        _navigationBarStatus = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"选择地区";
    [self setNavTitle:@"选择地区"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectModel) name:@"JOBSEARCHGETREGIONSUCCESS" object:nil];
}

-(void)creatTableView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height-64;
    
    self.tableOne = [[UITableView alloc] initWithFrame:CGRectMake(0,0,width/2-1, height) style:UITableViewStylePlain];
    self.tableOne.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableOne.dataSource = self;
    self.tableOne.delegate = self;
    self.tableOne.bounces = NO;
    self.tableOne.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableOne.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableOne];
    
    self.tableTwo = [[UITableView alloc] initWithFrame:CGRectMake(width/2,0,width/2, height) style:UITableViewStylePlain];
    self.tableTwo.dataSource = self;
    self.tableTwo.delegate = self;
    self.tableTwo.bounces = NO;
    self.tableOne.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableTwo.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableTwo.separatorColor = UIColorFromRGB(0xecedec);
    self.tableTwo.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableTwo];
    
    self.dataBase = [DataBase shareDatabase];
    
    self.arrOne = [[NSMutableArray alloc] initWithArray:[self.dataBase selectWithString:@"select * from region_web where level='1'"]];
    for (NSInteger i = 0;i<self.arrOne.count;i++) {
        if ([[self.arrOne[i] provinceName] isEqualToString:@"全国"]) {
            SqlitData *data = self.arrOne[i];
            [self.arrOne removeObjectAtIndex:i];
            [self.arrOne insertObject:data atIndex:0];
            break;
        }
    }
//初始数据处理
    [self changeSelectModel];
}

-(void)changeSelectModel{
    self.arrTwo = [[NSMutableArray alloc] init];

    if (_selectedVO.selected) {
        rightModel = _selectedVO;
        for (SqlitData *data in self.arrOne) {
            if ([rightModel.parentld isEqualToString:data.provinceld]) {
                leftModel = data;
            }
        }
        _arrTwo = [[NSMutableArray alloc] initWithArray:[self getDataArrWithId:rightModel.parentld]];
    }
    else{
        if (!(_selectedVO.provinceName.length > 0)) {
            _selectedVO.provinceName = @"全国";
        }
        leftModel = _selectedVO;
        _arrTwo = [[NSMutableArray alloc] initWithArray:[self getDataArrWithId:leftModel.provinceld]];
    }
    
    [_tableOne reloadData];
    [_tableTwo reloadData];
}

-(void)rightBarBtnResponse:(id)sender
{
    if (!rightModel && !leftModel) {
        return;
    }
    if (rightModel) {
        if (self.blockString) {
            self.blockString(rightModel);
        }
    }else if (leftModel){
        if (self.blockString) {
            self.blockString(leftModel);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.navigationItem.title = @"选择地区";
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        if(IOS8)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位失败"
                                                           message:@"请在 “设置-隐私-定位服务” 中进行设置"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"设置", nil];
            alert.tag = 1001;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"定位失败"
                                                           message:@"请在 “设置-隐私-定位服务” 中进行设置"
                                                          delegate:self
                                                 cancelButtonTitle:@"关闭"
                                                 otherButtonTitles:nil];
            alert.tag = 1001;
            [alert show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1001)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(NSArray *)getDataArrWithId:(NSString *)provinceld{
    if (!provinceld || [provinceld isEqualToString:@""]) {
        return nil;
    }
    return [self.dataBase selectWithString:[NSString stringWithFormat:@"select * from region_web where parentId='%@'",provinceld]];

} 

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGFloat width = ScreenWidth/2.0;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15,15,width-40,18)];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textColor = UIColorFromRGB(0x333333);
    lable.tag = 1000;
    [cell.contentView addSubview:lable];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(width-34,15,18,18)];
    image.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    image.tag = 2000;
    [cell.contentView addSubview:image];

    lable.textColor = [UIColor blackColor];
    SqlitData *dataModel;
    if (tableView == self.tableOne) {
        image.hidden = YES;
        dataModel = self.arrOne[indexPath.row];
        if ([dataModel.provinceName isEqualToString:leftModel.provinceName]) {
            lable.textColor = UIColorFromRGB(0xe13e3e);
            cell.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        }
        else{
            lable.textColor = UIColorFromRGB(0x333333);
            cell.contentView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        }
    }else if (tableView == self.tableTwo){
        cell.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        dataModel = self.arrTwo[indexPath.row];
        if ([dataModel.provinceName isEqualToString:rightModel.provinceName]) {
            lable.textColor = UIColorFromRGB(0xe13e3e);
            image.hidden = NO;
        }else{
            lable.textColor = UIColorFromRGB(0x333333);
            image.hidden = YES;
        }
        
    }
    lable.text = dataModel.provinceName;
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableOne) {
        return _arrOne.count;
    }
    else if (tableView == self.tableTwo)
    {
        return _arrTwo.count;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableOne){
        SqlitData *modelOne = self.arrOne[indexPath.row];
        leftModel = nil;
        rightModel = nil;
        leftModel = modelOne;
        [self.arrTwo removeAllObjects];
        if (![modelOne.provinceName isEqualToString:@"全国"]) {
            [self.arrTwo addObjectsFromArray:[self getDataArrWithId:modelOne.provinceld]];
        }
        [self.tableOne reloadData];
        ;
    }
    else if (tableView == self.tableTwo){
        rightModel = self.arrTwo[indexPath.row];
    }
    [self.tableTwo reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
