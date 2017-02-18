//
//  ELEmailTranspondCtl.m
//  jobClient
//
//  Created by 一览iOS on 2017/1/19.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELEmailTranspondCtl.h"
#import "CompanyOtherHR_DataModal.h"
#import "ELTranspondAddPeopleCtl.h"
#import "ELTranspondEditorCtl.h"
#import "ELResumeTypeChangeCtl.h"

@interface ELEmailTranspondCtl () <UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *companyId_;
    ELBaseLabel *nameLb;
    ELBaseLabel *jobLb;
    UITextView *emailTV;
    ELBaseLabel *countLb;
    UITableView *tableView_;
    RequestCon *listCon;
    NSMutableArray *dataArr_;
    NSMutableArray *emailArr;
    User_DataModal *_userModal;
    NSIndexPath *selectIndexPath;
    NSString *jobId;
}
@end

@implementation ELEmailTranspondCtl

-(instancetype)init{
    self = [super init];
    if (self){
        rightNavBarStr_ = @"确定";
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self.view addSubview:tableView];
        tableView_ = tableView;
        dataArr_ = [[NSMutableArray alloc] init];
        emailArr = [[NSMutableArray alloc] init];
        [self creatTableViewHeaderView];
        [self creatFootView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"转发简历"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:emailTV];  
}

-(void)textDidChange{
    NSInteger length = 180-emailTV.text.length;
    countLb.text = [NSString stringWithFormat:@"%ld",(long)(length>0?length:0)];
}

-(void)creatTableViewHeaderView{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];    
    headView.clipsToBounds = YES;
    
    ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"人才信息" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(16,15,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,15,label.width+3,label.height);
    [headView addSubview:label];
    
    
    UIView *backOneView = [[UIView alloc] initWithFrame:CGRectMake(-1,CGRectGetMaxY(label.frame)+5,ScreenWidth+2,96)];
    backOneView.layer.borderWidth = 1.0;
    backOneView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    backOneView.layer.masksToBounds = YES;
    backOneView.backgroundColor = [UIColor whiteColor];
    
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"姓名" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,20,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,24);
    [backOneView addSubview:label];
    
    nameLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(60,14,ScreenWidth-86,20)];
    nameLb.textAlignment = NSTextAlignmentRight;
    [backOneView addSubview:nameLb];
    
    ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(16,48,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [backOneView addSubview:line];
    
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"应聘岗位" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,20,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,72);
    [backOneView addSubview:label];
    
    jobLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(120,62,ScreenWidth-150,20)];
    jobLb.textAlignment = NSTextAlignmentRight;
    [backOneView addSubview:jobLb];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-24,0,8,13)];
    image.image = [UIImage imageNamed:@"right_jiantou_image"];
    image.center = CGPointMake(image.center.x,72);
    [backOneView addSubview:image];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(70,48,ScreenWidth-70,48);
    [button addTarget:self action:@selector(jobChangeRespone:) forControlEvents:UIControlEventTouchUpInside];
    [backOneView addSubview:button];
    
    [headView addSubview:backOneView];
    
    UIView *backTwoView = [[UIView alloc] initWithFrame:CGRectMake(-1,CGRectGetMaxY(backOneView.frame)+10,ScreenWidth+2,124)];
    backTwoView.backgroundColor = [UIColor whiteColor];
    backTwoView.layer.borderWidth = 1.0;
    backTwoView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    backTwoView.layer.masksToBounds = YES;
    
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"邮件正文" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,13,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,13,label.width+3,label.height);
    [backTwoView addSubview:label];
    
    emailTV = [[UITextView alloc] initWithFrame:CGRectMake(12,40,ScreenWidth-24,124-40-25)];
    emailTV.delegate = self;
    emailTV.textColor = UIColorFromRGB(0x212121);
    emailTV.font = [UIFont systemFontOfSize:16];
    emailTV.textContainerInset = UIEdgeInsetsZero;
    [backTwoView addSubview:emailTV];
    emailTV.text = @"请您评审一下，若觉得合适我们将安排面试。";
        
    countLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:10] title:@"180" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(ScreenWidth-100,124-15,84,10)];
    countLb.textAlignment = NSTextAlignmentRight;
    [backTwoView addSubview:countLb];
        
    [headView addSubview:backTwoView];
    
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"评审人" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,backTwoView.bottom+15,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,backTwoView.bottom+15,label.width+3,label.height);
    [headView addSubview:label];
    
    headView.frame = CGRectMake(0,0,ScreenWidth,label.bottom+5);
    tableView_.tableHeaderView = headView;
    
    [self textDidChange];
}

-(void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,67)];
    footView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    CGFloat width = (ScreenWidth-47)/2.0;
    
    ELBaseButton *button = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:16] title:@"选择同事" textColor:UIColorFromRGB(0xe13e3e) Target:self action:@selector(addPeople:) frame:CGRectMake(16,10,width,48)];
    [button setBorderWidth:1 borderColor:UIColorFromRGB(0xe13e3e)];
    [button setLayerCornerRadius:3.0];
    button.backgroundColor = [UIColor whiteColor];
    [footView addSubview:button];
    
    button = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:16] title:@"＋ 添加评审人" textColor:[UIColor whiteColor] Target:self action:@selector(addPeopleOne:) frame:CGRectMake(width+31,10,width,48)];
    [button setLayerCornerRadius:3.0];
    button.backgroundColor = UIColorFromRGB(0xe13e3e);
    [footView addSubview:button];
    
    tableView_.tableFooterView = footView;
}

-(void)rightBarBtnResponse:(id)sender{
    //发送面试邀请
    if ([[jobLb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"应聘岗位不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if ([[emailTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"邮件正文不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if(dataArr_.count <= 0) {
        [BaseUIViewController showAlertView:@"请选择或添加评审人" msg:nil btnTitle:@"确定"];
        return;
    }
    
    NSString * function = @"send_out_resume";
    NSString * op = @"company_person_busi";
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary * send_info = [[NSMutableDictionary alloc] init];
    [send_info setObject:jobId forKey:@"jobid"];
    [send_info setObject:[emailTV.text stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"title"];
    if (_userModal.forKey.length > 0) {
        [send_info setObject:_userModal.forKey forKey:@"forkey"];
    }
    [send_info setObject:jobLb.text forKey:@"jobname"];
    [send_info setObject:nameLb.text forKey:@"person_name"];
    if (_userModal.fromType) {
        [send_info setObject:_userModal.fromType forKey:@"tjtype"];
    }
    
    NSString *condition_arr_str = @"";
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        NSMutableDictionary *condition_arr = [[NSMutableDictionary alloc] init];
        [condition_arr setObject:synergy_id forKey:@"synergy_m_id"];
        condition_arr_str = [jsonWriter stringWithObject:condition_arr];
    }
    
    NSMutableDictionary *accept_person_info = [[NSMutableDictionary alloc] init];
    NSInteger index = 1;
    for (CompanyOtherHR_DataModal *modal in dataArr_) {
        if (modal.name_ && modal.contactEmail_){
            
            [accept_person_info setObject:@{@"name":modal.name_,@"email":modal.contactEmail_} forKey:[NSString stringWithFormat:@"k%ld",(long)index]];
            index ++;
        }
    }
    
    
    NSString * send_info_str = [jsonWriter stringWithObject:send_info];
    NSString *accept_person_info_str = [jsonWriter stringWithObject:accept_person_info];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&accept_person_info=%@&condition_arr=%@&send_info=%@",[Manager getUserInfo].companyModal_.companyID_,
                         _userModal.userId_,
                         accept_person_info_str,
                         condition_arr_str,
                         send_info_str];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"发送中" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            Status_DataModal * dataModal = [[Status_DataModal alloc] init];
            dataModal.status_ = [dic objectForKey:@"status"];
            dataModal.des_ = [dic objectForKey:@"status_desc"];
            dataModal.code_ = [dic objectForKey:@"code"];
            
            if ([dataModal.code_ isEqualToString:@"200"]) {
                
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"发送成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if([dataModal.des_ isKindOfClass:[NSString class]] && ![dataModal.des_ isEqualToString:@""]){
                [BaseUIViewController showAlertViewContent:dataModal.des_ toView:nil second:1.0 animated:YES];
            }else{
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"出错了，请稍后再试"];
            }
        }else{
            [BaseUIViewController showAutoDismissSucessView:nil msg:@"出错了，请稍后再试"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 同事中添加点击事件
-(void)addPeople:(UIButton *)sender{
    ELTranspondAddPeopleCtl *ctl = [[ELTranspondAddPeopleCtl alloc] init];
    ctl.dataArr_ = emailArr;
    __weak ELEmailTranspondCtl *emailCtl = self;
    ctl.block = ^{
        [emailCtl changeReload];
    };
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}
-(void)changeReload{
    for (CompanyOtherHR_DataModal * dataModal in emailArr){
        if (dataModal.bChoosed_ && !dataModal.bSelected_){
            dataModal.bSelected_ = YES;
            [dataArr_ addObject:dataModal];
            [tableView_ reloadData];
        }
    }
}

#pragma mark - 自定义添加点击事件
-(void)addPeopleOne:(UIButton *)sender{
    ELTranspondEditorCtl *ctl = [[ELTranspondEditorCtl alloc] init];
    ctl.selectArr = dataArr_;
    __weak ELEmailTranspondCtl *emailCtl = self;
    ctl.block = ^(id dataModal){
        [emailCtl addPeopleSuccessReload:dataModal];
    };
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}

-(void)addPeopleSuccessReload:(id)dataModal{
    if (dataModal) {
        if ([dataModal isKindOfClass:[NSMutableArray class]]) {
            for (CompanyOtherHR_DataModal *modal in dataModal){
                [self changeWithModel:modal];
            }
        }else{
            [self changeWithModel:dataModal];
        }
        [tableView_ reloadData];
    }
}

#pragma mark - 判断添加的modal是否包含在同事中
-(void)changeWithModel:(CompanyOtherHR_DataModal *)modal{
    CompanyOtherHR_DataModal *selectModal = modal;
    for (CompanyOtherHR_DataModal *modalOne in emailArr) {
        if ([modal.name_ isEqualToString:modalOne.name_] && [modal.contactEmail_ isEqualToString:modalOne.contactEmail_]) {
            modalOne.bChoosed_ = YES;
            modalOne.bSelected_ = YES;
            selectModal = modalOne;
            break;
        }
    }
    [dataArr_ addObject:selectModal];
}

#pragma mark - 应聘岗位选择
-(void)jobChangeRespone:(UIButton *)sender{
    ELResumeTypeChangeCtl *ctl = [[ELResumeTypeChangeCtl alloc] init];
    ctl.changeType = JobType;
    ctl.block = ^(id model){
        if ([model isKindOfClass:[CondictionList_DataModal class]]) {
            CondictionList_DataModal *dataModel = model;
            jobLb.text = dataModel.str_;
            jobId = dataModel.id_;
        }
    };
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _userModal = dataModal;
    nameLb.text = _userModal.name_;
    jobLb.text = _userModal.job_;
    jobId = _userModal.zpId_;
    companyId_ = exParam;
    if (!listCon) {
        listCon = [self getNewRequestCon:NO];
    }
    [BaseUIViewController showLoadView:YES content:@"" view:nil];
    [listCon getCompanyOtherHR:companyId_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetCompanyOtherHR:
        {
            if (dataArr.count > 0) {
                [emailArr addObjectsFromArray:dataArr];
            }
        }
            break;
        case Request_TranspondResume:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:dataModal.des_ msg:nil seconds:2.0];
                //[delegate_ removeView];
            }
            else
                [BaseUIViewController showAutoDismissFailView:dataModal.des_ msg:nil seconds:2.0];
        }
            break;
        case Request_TranspondGuwenResume:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"转发成功" msg:nil seconds:2.0];
                //[delegate_ removeView];
            }
            else
                [BaseUIViewController showAutoDismissFailView:@"转发失败" msg:@"请稍后再试" seconds:2.0];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyOtherHR_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ELLineView *topLine = [[ELLineView alloc] initWithFrame:CGRectMake(16,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        topLine.tag = 11;
        [cell.contentView addSubview:topLine];
        
        ELLineView *bottomLine = [[ELLineView alloc] initWithFrame:CGRectMake(0,59,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        bottomLine.tag = 12;
        [cell.contentView addSubview:bottomLine];
        
        ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,12,ScreenWidth-66,18)];
        label.tag = 13;
        [cell.contentView addSubview:label];
        
        label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(16,34,ScreenWidth-66,16)];
        label.tag = 14;
        [cell.contentView addSubview:label];
        
        ELBaseButton *button = [ELBaseButton getNewButtonWithNormalImageName:@"ic_transresume_del" selectImgName:@"ic_transresume_del" Target:self action:@selector(deleteBtnRespone:) frame:CGRectMake(ScreenWidth-50,8,44,44)];
        button.tag = 15;
        [cell.contentView addSubview:button];
    }
    ELLineView *topLine = (ELLineView *)[cell.contentView viewWithTag:11];
    ELLineView *bottomLine = (ELLineView *)[cell.contentView viewWithTag:12];
    ELBaseLabel *usernameLb = (ELBaseLabel *)[cell.contentView viewWithTag:13];
    ELBaseLabel *emailLb = (ELBaseLabel *)[cell.contentView viewWithTag:14];
    ELBaseButton *deleteBtn = (ELBaseButton *)[cell.contentView viewWithTag:15];
    deleteBtn.indexPathRow = indexPath.row;
    CompanyOtherHR_DataModal * dataModal = [dataArr_ objectAtIndex:indexPath.row];
   
    if (indexPath.row == 0){
        topLine.frame = CGRectMake(0,0,ScreenWidth,1);
    }else{
        topLine.frame = CGRectMake(16,0,ScreenWidth,1);
    }
    if (indexPath.row == dataArr_.count-1){
        bottomLine.hidden = NO;
    }else{
         bottomLine.hidden = YES;
    }
    usernameLb.text = dataModal.name_;
    emailLb.text = dataModal.contactEmail_;
    return cell;
}

-(void)deleteBtnRespone:(ELBaseButton *)button{
    if (button.indexPathRow >= 0 && button.indexPathRow <dataArr_.count) {
         CompanyOtherHR_DataModal * dataModal = dataArr_[button.indexPathRow];
        dataModal.bChoosed_ = NO;
        dataModal.bSelected_ = NO;
        [dataArr_ removeObjectAtIndex:button.indexPathRow];
        [tableView_ reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyOtherHR_DataModal * dataModal = dataArr_[indexPath.row];
    ELTranspondEditorCtl *ctl = [[ELTranspondEditorCtl alloc] init];
    ctl.isEditor = YES;
    ctl.name = dataModal.name_;
    ctl.email = dataModal.contactEmail_;
    selectIndexPath = indexPath;
    __weak ELEmailTranspondCtl *emailCtl = self;
    ctl.block = ^(id dataModal){
        [emailCtl editorSuccessReloadWithModal:dataModal];
    };
    [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
}
#pragma mark - 编辑成功回调
-(void)editorSuccessReloadWithModal:(id)dataModal{
    if (!dataModal) {
        //modal为nil是表示删除
        if (selectIndexPath.row < dataArr_.count){
            CompanyOtherHR_DataModal * dataModal = dataArr_[selectIndexPath.row];
            dataModal.bChoosed_ = NO;
            dataModal.bSelected_ = NO;
            [dataArr_ removeObjectAtIndex:selectIndexPath.row];
            [tableView_ reloadData];
        }
        return;
    }
    if (selectIndexPath.row < dataArr_.count){
        CompanyOtherHR_DataModal *oldModel = dataArr_[selectIndexPath.row];
        CompanyOtherHR_DataModal *newModel = dataModal;
        if (![oldModel.name_ isEqualToString:newModel.name_] || ![oldModel.contactEmail_ isEqualToString:newModel.contactEmail_]) {
            oldModel.bChoosed_ = NO;
            oldModel.bSelected_ = NO;
            
            for (CompanyOtherHR_DataModal *model in emailArr) {
                if ([model.name_ isEqualToString:newModel.name_] && [model.contactEmail_ isEqualToString:newModel.contactEmail_]) {
                    model.bSelected_ = YES;
                    model.bChoosed_ = YES;
                    newModel = model;
                    break;
                }
            }
            [dataArr_ replaceObjectAtIndex:selectIndexPath.row withObject:newModel];
            [tableView_ reloadData];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView == emailTV)
    {
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:emailTV wordsNum:180];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    tableView_.contentInset = UIEdgeInsetsZero;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    CGRect rect1 = [emailTV.superview convertRect:emailTV.frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - self.keyBoardHeight - 66))
    {
        CGFloat height = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - self.keyBoardHeight - 66));
        tableView_.contentOffset = CGPointMake(0,height + tableView_.contentOffset.y);
    }
    tableView_.contentInset = UIEdgeInsetsMake(0,0,self.self.keyBoardHeight,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
