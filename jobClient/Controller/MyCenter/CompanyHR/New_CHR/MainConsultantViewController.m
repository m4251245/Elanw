//
//  MainConsultantViewController.m
//  jobClient
//
//  Created by 一览ios on 16/8/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "MainConsultantViewController.h"
#import "ConsultMainHeaderView.h"
#import "SelectionTableViewCell.h"
#import "AdviceTableViewCell.h"
#import "StarTableViewCell.h"
@interface MainConsultantViewController ()<UITableViewDelegate,UITableViewDataSource>{
    ConsultMainHeaderView *headerView;
    NSArray *cellArr;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MainConsultantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark--初始化UI
-(void)configUI{
//    self.navigationItem.title = @"专属顾问";
    [self setNavTitle:@"专属顾问"];
    headerView = [[ConsultMainHeaderView alloc]init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 114);
    _table.tableHeaderView = headerView;
    
    [_table registerClass:[SelectionTableViewCell class] forCellReuseIdentifier:@"SelectionTableViewCellId"];
    [_table registerClass:[AdviceTableViewCell class] forCellReuseIdentifier:@"AdviceTableViewCellId"];
    [_table registerClass:[StarTableViewCell class] forCellReuseIdentifier:@"StarTableViewCellId"];
}

#pragma mark--加载数据
-(void)loadData{
    cellArr = @[@"StarTableViewCell",@"AdviceTableViewCell",@"SelectionTableViewCell"];
}

#pragma mark--请求数据

#pragma mark--代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *SelectionTableViewCellId = @"SelectionTableViewCellId";
//    static NSString *AdviceTableViewCellId = @"AdviceTableViewCellId";
//    static NSString *StarTableViewCellId = @"StarTableViewCellId";
    
    if (0 <= indexPath.row && indexPath.row <= 2) {
        
    }
    else if(indexPath.row == 3){
        
    }
    else{
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 114;
}

#pragma mark--事件

#pragma mark--通知

#pragma mark--业务逻辑

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
