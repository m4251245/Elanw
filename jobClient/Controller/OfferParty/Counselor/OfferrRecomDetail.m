//
//  OfferrRecomDetail.m
//  jobClient
//
//  Created by 一览ios on 15/7/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OfferrRecomDetail.h"
#import "RecomResumeDetailCell.h"
#import "OfferToRecomResumeCtl.h"

@interface OfferrRecomDetail ()
{
    User_DataModal *inModel;
}
@end

@implementation OfferrRecomDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noShowNoDataView = YES;
    
    if (![_navTitle isEqualToString:@""] && _navTitle) {
        self.navigationItem.title = _navTitle;
    }
    else
    {
        self.navigationItem.title = @"推荐详情";
    }
    
    if ([_navTitle isEqualToString:@"Offer详情"] || [_navTitle isEqualToString:@"上岗详情"]) {
        _recommentBtn.hidden = YES;
    }
    else
    {
        _recommentBtn.hidden = NO;
    }

    bHeaderEgo_ = NO;
    bFooterEgo_ = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"OfferRecomRefresh" object:nil];
    
    _recommentBtn.layer.cornerRadius = 2.0;
    if (_consultantCompanyFlag) {
        _recommentBtn.hidden = YES;
    }
}

- (void)refreshList:(NSNotification *)notry
{
    [self refreshLoad:nil];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    [_imagev sd_setImageWithURL:[NSURL URLWithString:inModel.img_]placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [_name setText:inModel.name_];
    NSString *city = inModel.regionCity_;
    NSString *workAge = inModel.gzNum_;
    NSString *eduName = inModel.eduName_;
    NSString *sex = inModel.sex_;
    [_genderBtn setTitle:inModel.age_ forState:UIControlStateNormal];
    if ([sex isEqualToString:@"男"]) {
        [_genderBtn setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else if ([sex isEqualToString:@"女"]){
        [_genderBtn setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }else{
        [_genderBtn setBackgroundImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    }
    
    NSDictionary *nameAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *lineAttr = @{NSFontAttributeName:THIRTEENFONT_CONTENT, NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]init];
    if (city) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:city attributes:nameAttr]];
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
    }
    if (workAge) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@年工作经验", workAge] attributes:nameAttr]];
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" | " attributes:lineAttr]];
    }
    if (eduName) {
        [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", eduName] attributes:nameAttr]];
    }
    _desc.attributedText = attrString;
    if (inModel.job_) {
        _job.text =[NSString stringWithFormat:@"应聘: %@", inModel.job_];
    }else{
        _job.text = @"";
    }
    if (inModel.sendtime_.length>10) {
        _time.text = [inModel.sendtime_ substringToIndex:10];
    }else{
        _time.text = inModel.sendtime_;
    }

}

- (void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getRecommentInfo:inModel.jobfair_person_id];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetRecommentInfo:
        {
//            if (dataArr.count <= 0) {
//                [self showNoDataOkView:NO];
//            }
        }
            break;
        default:
            break;
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == _recommentBtn) {
        OfferToRecomResumeCtl *recomCtl = [[OfferToRecomResumeCtl alloc] init];
        [recomCtl beginLoad:inModel exParam:nil];
        recomCtl.jobfair_id = _jobfair_id;
        [self.navigationController pushViewController:recomCtl animated:YES];
    }
}

#pragma mark - UItableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    RecomResumeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecomResumeDetailCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    User_DataModal *userModel = requestCon_.dataArr_[indexPath.row];
    [cell.job setText:[NSString stringWithFormat:@"推荐岗位:%@",userModel.job_]];
    [cell.company setText:userModel.company_];
    
    switch (userModel.resumeType) {
        case 1:
        {
            cell.statusLb.text = @"顾问推荐";
        }
            break;
        case 2:
        {
            cell.statusLb.text = @"主动投递";
        }
            break;
        case 3:
        {
            cell.statusLb.text = @"通过初选";
        }
            break;
        case 4:
        {
            cell.statusLb.text = @"已录用";
        }
            break;
        case 5:
        {
            cell.statusLb.text = @"已上岗";
        }
            break;
        case 6:
        {
            cell.statusLb.text = @"面试合格";
        }
            break;
        case 7:
        {
            cell.statusLb.text = @"面试不合格";
        }
            break;
        case 8:
        {
            cell.statusLb.text = @"等候面试";
        }
            break;
        case 10:
        {
            cell.statusLb.text = @"不通过初选";
        }
            break;
        case 12:
        {
            cell.statusLb.text = @"待确定";
        }
            break;
        default:
        {
            [cell.statusLb setHidden:YES];
        }
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return requestCon_.dataArr_.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
