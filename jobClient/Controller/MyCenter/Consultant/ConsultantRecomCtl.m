//
//  ConsultantRecomCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantRecomCtl.h"
#import "ConsultantRecomCell.h"
#import "ConsultantHRDataModel.h"
#import "ConsultantResumePreviewCtl.h"
#import "ConsultantSearchCell.h"

@interface ConsultantRecomCtl ()<UITextFieldDelegate>
{
    ConsultantHRDataModel *inModel;
}
@end

@implementation ConsultantRecomCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.title = @"已推荐简历";
    [self setNavTitle:@"已推荐简历"];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 120, 44)];
    
    UIImageView *bgImgv = [[UIImageView alloc]init];
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth - 120, 24)];
    bgImgv.layer.cornerRadius = 12;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    UITextField *keyWorkTf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth - 120, 24)];
    keyWorkTf.returnKeyType = UIReturnKeySearch;
    keyWorkTf.placeholder = @"请输入姓名搜索";
    [keyWorkTf setFont:FOURTEENFONT_CONTENT];
    [keyWorkTf setTextColor:BLACKCOLOR];
    keyWorkTf.delegate = self;
    [keyWorkTf setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:keyWorkTf];
    _keyWorkTf = keyWorkTf;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_search_def.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.titleView = searchView;
    // Do any additional setup after loading the view from its nib.
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
}

- (void)getDataFunction:(RequestCon *)con
{
    [super getDataFunction:con];
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    NSString *keywords = @"";//按姓名查询
    if (_keyWorkTf.text && ![[_keyWorkTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        keywords = _keyWorkTf.text;
    }
    [con guwenRecomResumeList:inModel.salerId keywords:keywords pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

#pragma mark - UITAbleViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ConsultantSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantSearchCell" owner:self options:nil] lastObject];
        cell.redMark.hidden = YES;
        cell.lockImage.hidden = YES;
        cell.visitorBtn.hidden = YES;
    }
    User_DataModal *model = requestCon_.dataArr_[indexPath.row];
    
    [cell.photoImagv sd_setImageWithURL:[NSURL URLWithString:model.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [cell.name setText:model.name_];
    NSString *descStr = [NSString stringWithFormat:@"推荐场次：%@",model.project_title];
    [cell.contentDescLb setText:descStr];
    [cell.jobLb setText:[NSString stringWithFormat:@"推荐职位:%@",model.recomJob_]];
    
    NSString *time = [model.sendtime_ substringToIndex:10];
    [cell.timeLb setText:[NSString stringWithFormat:@"推荐时间：%@",time]];
    if ([model.sex_ isEqualToString:@"男"]) {
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else{
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }
    [cell.gender setTitle:model.age_ forState:UIControlStateNormal];
    
    if (![model.newmail isEqualToString:@"0"]) {
        [cell.noReadMark setHidden:NO];
    }else{
        [cell.noReadMark setHidden:YES];
    }
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal *model = selectData;
    ConsultantResumePreviewCtl *consultantResumePreviewCtl = [[ConsultantResumePreviewCtl alloc] init];
    consultantResumePreviewCtl.recommendFlag = _recommendFlag;
    [self.navigationController pushViewController:consultantResumePreviewCtl animated:YES];
    consultantResumePreviewCtl.salerId = inModel.salerId;
    [consultantResumePreviewCtl beginLoad:model exParam:inModel.salerId];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _keyWorkTf) {
        [_keyWorkTf resignFirstResponder];
        [self refreshLoad:nil];
    }
    return YES;
}

- (void)rightBarBtnResponse:(id)sender
{
    [_keyWorkTf resignFirstResponder];
    [self refreshLoad:nil];
}


@end
