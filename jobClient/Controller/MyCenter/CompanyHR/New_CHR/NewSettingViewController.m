//
//  NewSettingViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "NewSettingViewController.h"
#import "Companyinfo_ViewController.h"
#import "ELBeGoodAtTradeChangeCtl.h"
#import "TagSelected_ViewController.h"
#import "CompanyName_settingViewController.h"
#import "HRLoginCtl.h"
#import "New_CompanyDataModel.h"

@interface NewSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSArray *dataArr;
    NSString *mainCname;
    New_CompanyDataModel *comVO;
    NSString *lightTag;
    NSString *pName;
    NSString *pJob;
    NSString *pMail;
}
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation NewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configUI];
    
}
#pragma mark--配置界面
-(void)configUI{
    _settingTableView.backgroundColor = UIColorFromRGB(0xf0f0f0);

    [self setNavTitle:@"企业账号设置"];
    [self leftButtonItem:@"back_white_new"];
    _settingTableView.tableFooterView = [self configFooter];
    _settingTableView.separatorColor = UIColorFromRGB(0xe0e0e0);
}

-(UIView *)configFooter{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 15, ScreenWidth, 50);
    [btn setTitle:@"解除绑定" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:UIColorFromRGB(0xe13e3e) forState:UIControlStateNormal];
    [view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark--加载数据
-(void)loadData{
    dataArr = @[@[@"企业信息"],@[@"企业亮点标签"],@[@"招聘负责人",@"负责人职位",@"简历接收邮箱"]];
    [self requestData];
}

#pragma mark--数据请求
-(void)requestData{
    [BaseUIViewController showLoadView:YES content:nil view:nil];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",_companyId];
    NSString *function = @"getCompanyInfo";
    NSString *op = @"company_info_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dataDic = (NSDictionary *)result;
        comVO = [New_CompanyDataModel new];
        [comVO setValuesForKeysWithDictionary:dataDic];
        lightTag = [NSString stringWithFormat:@"%d个标签",comVO.tag_arr.count];
        pName = comVO.pname;
        pJob = comVO.pnames;
        pMail = comVO.email;
        [_settingTableView reloadData];
        [BaseUIViewController showLoadView:NO content:nil view:nil];

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];

    }];
}

#pragma mark--代理
#pragma mark--tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = dataArr[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"settingCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *arr = dataArr[indexPath.section];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textColor = UIColorFromRGB(0x333333);
    titleLb.text = arr[indexPath.row];
    [cell.contentView addSubview:titleLb];
    
    UILabel *rightConLb = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 20, 15, ScreenWidth/2 - 10, 20)];
    rightConLb.font = [UIFont systemFontOfSize:15];
    rightConLb.textColor = UIColorFromRGB(0x757575);
    rightConLb.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:rightConLb];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 25, 18, 8, 13)];
    img.image = [UIImage imageNamed:@"right_grey.png"];
    [cell.contentView addSubview:img];
    
    if (indexPath.section == 1) {
        rightConLb.text = lightTag;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self labelSetting:rightConLb withLabelName:pName];
        }
        else if (indexPath.row == 1) {
            [self labelSetting:rightConLb withLabelName:pJob];
        }
        else if (indexPath.row == 2) {
            [self labelSetting:rightConLb withLabelName:pMail];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1 && indexPath.section != 0) {
        return;
    }
    WS(weakSelf);
    if(indexPath.section == 0){
        Companyinfo_ViewController *comVC = [[Companyinfo_ViewController alloc]init];
        comVC.companyId = _companyId;
//        comVC.cInfoVO = comVO;
        [self.navigationController pushViewController:comVC animated:YES];
    }
    if (indexPath.section == 1) {
        TagSelected_ViewController *tagVC = [[TagSelected_ViewController alloc]init];
        tagVC.companyId = _companyId;
        tagVC.myBlock = ^(NSArray *selArr){
            lightTag = [NSString stringWithFormat:@"%lu个标签",(unsigned long)selArr.count];
            [weakSelf.settingTableView reloadData];
            [weakSelf requestData];
        };
        tagVC.tagMarkArr = comVO.tag_arr;
        [self.navigationController pushViewController:tagVC animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self didSelectManagerAndPosition:2 withNowCname:pName];
        }
        if (indexPath.row == 1) {
            [self didSelectManagerAndPosition:3 withNowCname:pJob];
        }
        if (indexPath.row == 2){
            [self didSelectManagerAndPosition:4 withNowCname:pMail];
        }
    }
}

#pragma mark--alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //解绑企业
            //设置请求参数
            NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@",_companyId,[Manager getUserInfo].userId_];
            NSString * function = @"cancelBingDing";
            NSString * op   =   @"company_info";
            
            //发送请求
            [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
                NSInteger statu = [result integerValue];
                if (statu == 1) {
                    [CommonConfig setDBValueByKey:@"companyID" value:@""];
                    [BaseUIViewController showAutoDismissSucessView:@"解绑成功" msg:nil];
                    UIViewController *ctl  = self.navigationController.childViewControllers[0];
                    [self.navigationController popToViewController:ctl animated:NO];
                    HRLoginCtl *loginCtl = [[HRLoginCtl alloc]init];
                    [self.navigationController pushViewController:loginCtl animated:YES];
                    [Manager shareMgr].messageCountDataModal.companyCnt = 0;
                    NSInteger allNum = [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.resumeCnt;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
                }
                else
                {
                    [BaseUIViewController showAutoDismissFailView:@"解绑失败" msg:@"请稍后再试"];
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark--事件
-(void)leftBtnClick:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
}
//解除绑定
-(void)logoutClick:(UIButton *)btn{
    [self showChooseAlertView:1 title:@"温馨提示" msg:@"确定解绑企业？解除绑定后将需要重新登录" okBtnTitle:@"确定退出" cancelBtnTitle:@"取消"];
}

-(void)showChooseAlertView:(int)type title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:okBtnTitle,cancelBtnTitle,nil];
    alert.tag = type;
    [alert show];
}

#pragma mark--业务逻辑
-(void)didSelectManagerAndPosition:(NSInteger)numIdx withNowCname:(NSString *)nowCname{
    __weak typeof(self) WeakSelf = self;
    CompanyName_settingViewController *cnameVC = [[CompanyName_settingViewController alloc]init];
    cnameVC.cType = numIdx;
    cnameVC.nowCname = nowCname;
    cnameVC.companyId = _companyId;
    cnameVC.MyBlock = ^(NSString *cname){
        if (numIdx == 2) {
            pName = cname;
        }
        else if(numIdx == 3){
            pJob = cname;
        }
        else if(numIdx == 4){
            pMail = cname;
        }
        [WeakSelf.settingTableView reloadData];
    };
    [self.navigationController pushViewController:cnameVC animated:YES];
}

-(void)labelSetting:(UILabel *)label withLabelName:(NSString *)labelTxt{
    label.text = labelTxt;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
