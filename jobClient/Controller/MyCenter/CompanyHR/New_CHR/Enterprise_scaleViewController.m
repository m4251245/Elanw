//
//  Enterprise_scaleViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/28.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "Enterprise_scaleViewController.h"

@interface Enterprise_scaleViewController ()<UITableViewDelegate,UITableViewDataSource>{

}
@property (weak, nonatomic) IBOutlet UITableView *cScaleTable;
@property(nonatomic,retain)NSArray *dataArr;
@end

@implementation Enterprise_scaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
}

#pragma mark--初始化UI

-(void)configUI{
    if (_selectedType == 1) {
//        self.navigationItem.title = @"企业规模";
        [self setNavTitle:@"企业规模"];
    }
    else{
//        暂时所属行业没有用这个类
//        [self setNavTitle:@"所属行业"];
    }
    [_cScaleTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    _cScaleTable.separatorColor = UIColorFromRGB(0xecedec);
    [self leftButtonItem:@"back_white_new"];
    _cScaleTable.tableFooterView = [UIView new];
}

#pragma mark--加载数据
-(void)loadData{
    if (_selectedType == 1) {
        _dataArr = @[@"1 - 49人",@"50 - 99人",@"100 - 499人",@"500 - 999人",@"1000人以上"];
    }
    [_cScaleTable reloadData];
}

#pragma mark--请求数据
-(void)requestData:(NSString *)selScale{
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    //组装请求参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:_cScaleName forKey:@"yuangong_before"];
    [conditionDic setObject:selScale forKey:@"yuangong"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&contact_arr=%@",_companyId,conDicStr];
    NSString *function = @"editCompanyInfo";
    NSString *op = @"company_info_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSString *status = result[@"status"];
        if ([status isEqualToString:@"TRUE"]) {
            if (_MyBlock) {
                _MyBlock(selScale);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

#pragma mark--代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.text = _dataArr[indexPath.row];
    [cell.contentView addSubview:titleLb];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 31, 16, 18, 18)];
    img.image = [UIImage imageNamed:@"ic_done_black_36dp"];
    [cell.contentView addSubview:img];
    if([_cScaleName isEqualToString:_dataArr[indexPath.row]]){
        titleLb.textColor = UIColorFromRGB(0xe13e3e);
        img.hidden = NO;
    }
    else{
        titleLb.textColor = UIColorFromRGB(0x333333);
        img.hidden = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self requestData:self.dataArr[indexPath.row]];
}

#pragma mark--事件
-(void)leftBtnClick:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--通知

#pragma mark--业务逻辑

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
