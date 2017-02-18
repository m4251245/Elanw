//
//  SalarySelectionViewController.m
//  jobClient
//
//  Created by 一览ios on 16/5/26.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "SalarySelectionViewController.h"
#import "CommonConfig.h"
#import "MyConfig.h"
@interface SalarySelectionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *dataArr;
    NSArray *typeArr;
    NSInteger sel;
}
@property (weak, nonatomic) IBOutlet UITableView *conTable;

@end

@implementation SalarySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configUI];
}

#pragma mark--配置界面

-(void)configUI{
    _conTable.separatorColor = UIColorFromRGB(0xecedec);
    
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    titleLB.text = @"薪资选择";
    titleLB.textColor = [UIColor whiteColor];
    titleLB.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = titleLB;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark--加载数据
-(void)loadData{
    dataArr = @[@"￥1万以下",@"￥1-2万",@"￥2-3万",@"￥3-4万",@"￥4-5万",@"￥5-6万",@"￥6-8万",@"￥8-10万",@"￥10-15万",@"￥15-30万",@"￥30-50万",@"￥50-100万",@"￥100万以上"];
    typeArr = @[@"1",@"2",@"3",@"4",@"12",@"5",@"6",@"7",@"13",@"8",@"9",@"10",@"11"];
    
//    NSString *userName = [CommonConfig getDBValueByKey:Config_Key_User];
//    NSString *usr_selected_salary = [NSString stringWithFormat:@"%@selected_salary",userName];
//    NSInteger selected = [getUserDefaults(usr_selected_salary) integerValue];
//    NSInteger selected = [_selSalaryIdx integerValue];
    sel = -1;
    for (int i = 0 ; i < dataArr.count; i++) {
        if ([_selSalaryIdx isEqualToString:dataArr[i]]) {
            sel = i;
        }
    }
}

#pragma mark--代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *registerId = @"myCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerId];
    }
    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:102];
    if (!titleLab) {
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        titleLab.tag = 102;
        titleLab.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
        [cell.contentView addSubview:titleLab];
    }
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 31, 16, 18, 18)];
    img.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    [cell.contentView addSubview:img];
    
    if (indexPath.row == sel) {
        img.hidden = NO;
        titleLab.textColor = UIColorFromRGB(0xe13e3e);
    }
    else{
        img.hidden = YES;
        titleLab.textColor = UIColorFromRGB(0x333333);
    }
    titleLab.text = dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _myBlock(dataArr[indexPath.row]);
    NSInteger num = [typeArr[indexPath.row] integerValue];
    NSString *userName = [CommonConfig getDBValueByKey:Config_Key_User];
    NSString *usr_selected_salary = [NSString stringWithFormat:@"%@selected_salary",userName];
    kUserDefaults(@(num), usr_selected_salary);
    kUserSynchronize;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--事件
-(void)back:(UIBarButtonItem *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
