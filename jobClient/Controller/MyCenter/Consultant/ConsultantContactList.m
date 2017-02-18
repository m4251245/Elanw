//
//  ConsultantContactList.m
//  jobClient
//
//  Created by 一览ios on 15/6/23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantContactList.h"
#import "ConsultantSearchCell.h"
#import "ConsultantResumePreviewCtl.h"
#import "ConsultantVisitorReplyList.h"


@interface ConsultantContactList ()
{
    ConsultantHRDataModel   *inModel;
    NSString                *messageType;
}
@end

@implementation ConsultantContactList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    bHeaderEgo_ = YES;
    bFooterEgo_ = YES;
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshCount:) name:@"ConsultantFreshCount" object:nil];
}

-(void)freshCount:(NSNotification *)fication{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self refreshLoad:nil];
    });
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
    messageType = exParam;  
}

-(void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getGuwenVistList:[Manager getHrInfo].userName type:messageType pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_];
}

- (void)btnResponse:(id)sender
{

}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ConsultantSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantSearchCell" owner:self options:nil] lastObject];
    }
    User_DataModal *model = requestCon_.dataArr_[indexPath.row];
    
    [cell.photoImagv sd_setImageWithURL:[NSURL URLWithString:model.img_] placeholderImage:[UIImage imageNamed:@"bg__xinwen.png"]];
    [cell.name setText:model.name_];
    NSString *descStr = nil;
    if ([model.gzNum_ isEqualToString:@"0.0"] || [model.gzNum_ isEqualToString:@""]) {
        model.gzNum_ = @"0";
    }
    NSString *edu = nil;
    if ([model.eduName_ isEqualToString:@""]) {
        edu = @"";
    }else{
        edu = [NSString stringWithFormat:@"| %@",model.eduName_];
    }
    if ([model.regionCity_ isEqualToString:@""]) {
        descStr = [NSString stringWithFormat:@"%@年经验 %@",model.gzNum_,edu];
    }else{
        descStr = [NSString stringWithFormat:@"%@ | %@年经验 %@",model.regionCity_,model.gzNum_,edu];
    }
    [cell.contentDescLb setText:descStr];
    [cell.jobLb setText:[NSString stringWithFormat:@"意向职位:%@",model.job_]];
    
    if ([messageType isEqualToString:@"5"]) {
        [cell.visitorBtn setHidden:YES];
    }else{
        [cell.visitorBtn setHidden:NO];
        cell.visitorBtn.tag = indexPath.row + 1000;
        [cell.visitorBtn addTarget:self action:@selector(visitorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *time = [model.sendtime_ substringToIndex:10];
    [cell.timeLb setText:time];
    if ([model.sex_ isEqualToString:@"男"]) {
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_boy2.png"] forState:UIControlStateNormal];
    }else{
        [cell.gender setBackgroundImage:[UIImage imageNamed:@"icon_girl2.png"] forState:UIControlStateNormal];
    }
    [cell.gender setTitle:model.age_ forState:UIControlStateNormal];
    return cell;
}

- (void)visitorBtnClick:(UIButton *)button
{
    long  index = button.tag - 1000;
    User_DataModal *model = requestCon_.dataArr_[index];
    ConsultantVisitorReplyList *replayList = [[ConsultantVisitorReplyList alloc] init];
    [replayList beginLoad:model exParam:nil];
    [self.navigationController pushViewController:replayList animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    User_DataModal *model = selectData;
    ConsultantResumePreviewCtl *consultantResumePreviewCtl = [[ConsultantResumePreviewCtl alloc] init];
    consultantResumePreviewCtl.salerId = inModel.salerId;
    [self.navigationController pushViewController:consultantResumePreviewCtl animated:YES];
    [consultantResumePreviewCtl beginLoad:model exParam:inModel.salerId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
