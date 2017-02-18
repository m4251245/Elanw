//
//  ELResumeTranspondCtl.m
//  jobClient
//
//  Created by 一览iOS on 2017/1/20.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELResumeTranspondCtl.h"
#import "CompanyOtherHR_DataModal.h"
#import "ELTranspondAddPeopleCtl.h"
#import "ELTranspondEditorCtl.h"
#import "ELChangeDateCtl.h"
#import "ELResumeTypeChangeCtl.h"
#import "InterviewModel_DataModal.h"
#import "ELNewResumePreviewCtl.h"

@interface ELResumeTranspondCtl ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *companyId_;
    NSString *jobId;
    
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
    UITextField *timeTF;
    UISwitch *messageSwitch;
    UIView *companyMessageView;
    ELBaseButton *offButton;
    UIImageView *offImg;
    ELBaseLabel *companyName;
    ELBaseLabel *companyPlace;
    ELBaseLabel *companyPeople;
    ELBaseLabel *companyPhone;
    ELBaseLabel *interviewTemplate;
    
    ELBaseLabel *bottomLb;
    UIView *headerView;
    
    ELChangeDateCtl *changeDateCtl;
}

@end

@implementation ELResumeTranspondCtl

-(instancetype)init{
    self = [super init];
    if (self){
        rightNavBarStr_ = @"发送";
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
    [self setNavTitle:@"邀请面试"];
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
    
    ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"候选人" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(16,15,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,15,label.width+3,label.height);
    [headView addSubview:label];
    
    UIView *backOneView = [[UIView alloc] initWithFrame:CGRectMake(-1,CGRectGetMaxY(label.frame)+5,ScreenWidth+2,358)];
    backOneView.layer.borderWidth = 1.0;
    backOneView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    backOneView.layer.masksToBounds = YES;
    backOneView.backgroundColor = [UIColor whiteColor];
    
    //姓名
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"姓名" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,24);
    [backOneView addSubview:label];
    
    nameLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(60,14,ScreenWidth-86,20)];
    nameLb.textAlignment = NSTextAlignmentRight;
    [backOneView addSubview:nameLb];
    
    ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(16,48,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [backOneView addSubview:line];
    
    //应聘岗位
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
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,96,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [backOneView addSubview:line];
    
    //面试时间
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"面试时间" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,20,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,120);
    [backOneView addSubview:label];
    
    timeTF = [[UITextField alloc] initWithFrame:CGRectMake(120,110,ScreenWidth-150,20)];
    timeTF.textColor = UIColorFromRGB(0x757575);
    timeTF.font = [UIFont systemFontOfSize:16];
    timeTF.textAlignment = NSTextAlignmentRight;
    timeTF.delegate = self;
    timeTF.placeholder = @"请选择";
    timeTF.enabled = NO;
    [backOneView addSubview:timeTF];

    image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-24,0,8,13)];
    image.image = [UIImage imageNamed:@"right_jiantou_image"];
    image.center = CGPointMake(image.center.x,120);
    [backOneView addSubview:image];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,96,ScreenWidth,48);
    [button addTarget:self action:@selector(timeChangeRespone:) forControlEvents:UIControlEventTouchUpInside];
    [backOneView addSubview:button];
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,144,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [backOneView addSubview:line];
    
    //邮件正文
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"邮件正文" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,158,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,158,label.width+3,label.height);
    [backOneView addSubview:label];
    
    emailTV = [[UITextView alloc] initWithFrame:CGRectMake(12,184,ScreenWidth-24,100)];
    emailTV.delegate = self;
    emailTV.textColor = UIColorFromRGB(0x212121);
    emailTV.font = [UIFont systemFontOfSize:16];
    emailTV.textContainerInset = UIEdgeInsetsZero;
    emailTV.text = @"您的简历比较符合我司的职位要求，很高兴邀请您参加面谈，请注意面试的地点和时间，若行程有变请及时联系告知。";
    [backOneView addSubview:emailTV];
    
    countLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:10] title:@"180" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(ScreenWidth-100,294,84,10)];
    countLb.textAlignment = NSTextAlignmentRight;
    [backOneView addSubview:countLb];
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,310,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [backOneView addSubview:line];
    
    //同时发送短信通知
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"同时发送短信通知" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,334);
    [backOneView addSubview:label];
    
    messageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-66,320,50,30)];
    [backOneView addSubview:messageSwitch];
    
    [headView addSubview:backOneView];
    
    //公司信息
    companyMessageView = [[UIView alloc] initWithFrame:CGRectMake(-1,CGRectGetMaxY(backOneView.frame)+10,ScreenWidth+2,288)];
    companyMessageView.backgroundColor = [UIColor whiteColor];
    companyMessageView.clipsToBounds = YES;
    companyMessageView.layer.borderWidth = 1.0;
    companyMessageView.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    companyMessageView.layer.masksToBounds = YES;
    companyMessageView.userInteractionEnabled = YES;
    [companyMessageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyMessageChangeRespone:)]];
    
    CGFloat centerY = 24;
    
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"公司信息" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,centerY);
    [companyMessageView addSubview:label];
    
    offButton = [ELBaseButton getNewButtonWithFont:[UIFont systemFontOfSize:14] title:@"收起  " textColor:UIColorFromRGB(0x9e9e9e) Target:self action:@selector(showCompanyMessageBtnRespone:) frame:CGRectMake(ScreenWidth-70,0,60,48)];
    offButton.isShow = YES;
    [companyMessageView addSubview:offButton];
    
    offImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30,0,13,13)];
    offImg.image = [UIImage imageNamed:@"img_spread"];
    offImg.center = CGPointMake(offImg.center.x,centerY);
    offImg.transform=CGAffineTransformMakeRotation(M_PI);
    [companyMessageView addSubview:offImg];
    
    centerY += 48;
    
    //面试模板
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"面试模板" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,centerY);
    [companyMessageView addSubview:label];
    
    interviewTemplate = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(110,0,ScreenWidth-140,18)];
    interviewTemplate.textAlignment = NSTextAlignmentRight;
    interviewTemplate.center = CGPointMake(interviewTemplate.center.x,centerY);
    [companyMessageView addSubview:interviewTemplate];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-24,0,8,13)];
    image.image = [UIImage imageNamed:@"right_jiantou_image"];
    image.center = CGPointMake(image.center.x,centerY);
    [companyMessageView addSubview:image];
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,centerY+24,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [companyMessageView addSubview:line];
    
    centerY += 48;
    //公司名称
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"公司名称" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,centerY);
    [companyMessageView addSubview:label];
    
    companyName = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(110,0,ScreenWidth-126,18)];
    companyName.textAlignment = NSTextAlignmentRight;
    companyName.center = CGPointMake(companyName.center.x,centerY);
    [companyMessageView addSubview:companyName];
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,centerY+24,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [companyMessageView addSubview:line];
    
    centerY += 48;
    //面试地点
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"面试地点" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,centerY);
    [companyMessageView addSubview:label];
    
    companyPlace = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(110,0,ScreenWidth-140,18)];
    companyPlace.textAlignment = NSTextAlignmentRight;
    companyPlace.center = CGPointMake(companyPlace.center.x,centerY);
    [companyMessageView addSubview:companyPlace];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-24,0,8,13)];
    image.image = [UIImage imageNamed:@"right_jiantou_image"];
    image.center = CGPointMake(image.center.x,centerY);
    [companyMessageView addSubview:image];
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,centerY+24,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [companyMessageView addSubview:line];
    
    centerY += 48;
    //联系人
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"联系人" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,centerY);
    [companyMessageView addSubview:label];
    
    companyPeople = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(110,0,ScreenWidth-140,18)];
    companyPeople.textAlignment = NSTextAlignmentRight;
    companyPeople.center = CGPointMake(companyPeople.center.x,centerY);
    [companyMessageView addSubview:companyPeople];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-24,0,8,13)];
    image.image = [UIImage imageNamed:@"right_jiantou_image"];
    image.center = CGPointMake(image.center.x,centerY);
    [companyMessageView addSubview:image];
    
    line = [[ELLineView alloc] initWithFrame:CGRectMake(16,centerY+24,ScreenWidth-16,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [companyMessageView addSubview:line];
    
    centerY += 48;
    //联系电话
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"联系电话" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,centerY);
    [companyMessageView addSubview:label];
    
    companyPhone = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(110,0,ScreenWidth-140,18)];
    companyPhone.textAlignment = NSTextAlignmentRight;
    companyPhone.center = CGPointMake(companyPeople.center.x,centerY);
    [companyMessageView addSubview:companyPhone];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-24,0,8,13)];
    image.image = [UIImage imageNamed:@"right_jiantou_image"];
    image.center = CGPointMake(image.center.x,centerY);
    [companyMessageView addSubview:image];
    
    [headView addSubview:companyMessageView];
    
    bottomLb = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"评审人" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,companyMessageView.bottom+15,200,0)];
    [bottomLb sizeToFit];
    bottomLb.frame = CGRectMake(16,companyMessageView.bottom+15,bottomLb.width+3,bottomLb.height);
    [headView addSubview:bottomLb];
    
    headView.frame = CGRectMake(0,0,ScreenWidth,bottomLb.bottom+5);
    
    headerView = headView;
    
    tableView_.tableHeaderView = headerView;
    
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
    if (!jobLb.text || [[jobLb.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"应聘岗位不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if (!timeTF.text || [[timeTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"面试时间不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if (!emailTV.text || [[emailTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"邮件正文不能为空" msg:nil btnTitle:@"确定"];
        return;
    }
    if (!interviewTemplate.text || [[interviewTemplate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [BaseUIViewController showAlertView:@"请选择面试模板" msg:nil btnTitle:@"确定"];
        return;
    }
//    if(dataArr_.count <= 0) {
//        [BaseUIViewController showAlertView:@"请选择或添加评审人" msg:nil btnTitle:@"确定"];
//        return;
//    }
    
    NSString * function = @"sendInterviewNotify";
    NSString * op = @"company_person_busi";
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary * interview_info = [[NSMutableDictionary alloc] init];
    NSString *interview_type = @"email";
    if (messageSwitch.on) {
        interview_type = @"sms+email";
    }
    [interview_info setObject:interview_type forKey:@"interview_type"];
    [interview_info setObject:_userModal.tradeId forKey:@"tradeid"];
    [interview_info setObject:_userModal.zpId_ forKey:@"ap_id"];
    [interview_info setObject:[emailTV.text stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:@"mailtext"];
    [interview_info setObject:timeTF.text forKey:@"inter_time"];
    [interview_info setObject:companyPlace.text forKey:@"address"];
    [interview_info setObject:companyPeople.text forKey:@"pname"];
    [interview_info setObject:companyPhone.text forKey:@"phone"];
    [interview_info setObject:jobLb.text forKey:@"jobname"];
    [interview_info setObject:nameLb.text forKey:@"person_name"];
    
    NSString *condition_arr_str = @"";
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        NSMutableDictionary *condition_arr = [[NSMutableDictionary alloc] init];
        [condition_arr setObject:synergy_id forKey:@"synergy_m_id"];
        condition_arr_str = [jsonWriter stringWithObject:condition_arr];
    }
    
    NSMutableDictionary *resume_info = [[NSMutableDictionary alloc] init];
    if (_userModal.forKey.length > 0) {
        [resume_info setObject:_userModal.forKey forKey:@"forkey"];
        [resume_info setObject:_userModal.forType forKey:@"fortype"];
        [resume_info setObject:_userModal.companyId forKey:@"reid"];
        //[updateDic setObject:@"20" forKey:@"state"];
    }
    
    NSMutableDictionary *review_info_arr = [[NSMutableDictionary alloc] init];
    NSInteger index = 1;
    for (CompanyOtherHR_DataModal *modal in dataArr_) {
        if (modal.name_ && modal.contactEmail_){
            
            [review_info_arr setObject:@{@"name":modal.name_,@"email":modal.contactEmail_} forKey:[NSString stringWithFormat:@"k%ld",(long)index]];
            index ++;
        }
    }
    
    NSString * interview_info_str = [jsonWriter stringWithObject:interview_info];
    NSString * resume_info_str = [jsonWriter stringWithObject:resume_info];
    
    NSString *review_info_arr_str = @"";
    if (review_info_arr.count > 0) {
        review_info_arr_str = [jsonWriter stringWithObject:review_info_arr];
    }
    
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&resume_info=%@&review_info_arr=%@&condition_arr=%@&interview_info=%@",[Manager getUserInfo].companyModal_.companyID_,
                         _userModal.userId_,
                         resume_info_str,
                         review_info_arr_str,
                         condition_arr_str,
                         interview_info_str];

    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"发送中" success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            Status_DataModal * dataModal = [[Status_DataModal alloc] init];
            dataModal.status_ = [dic objectForKey:@"status"];
            dataModal.des_ = [dic objectForKey:@"status_desc"];
            dataModal.code_ = [dic objectForKey:@"code"];
            
            if ([dataModal.code_ isEqualToString:@"200"]) {
                
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"发送成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ELResumeTranspondCtlSuccess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
//                NSInteger count = self.navigationController.childViewControllers.count;
//                ELNewResumePreviewCtl *ctl  =self.navigationController.childViewControllers[count-2];
//                if ([ctl isKindOfClass:[ELNewResumePreviewCtl class]]) {
//                    ELNewResumePreviewCtl *previewCtl = (ELNewResumePreviewCtl *)ctl;
//                    [previewCtl refreshLoad:nil];
//                }
//                [self.navigationController popToViewController:ctl animated:YES];
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

#pragma mark - 公司信息修改
-(void)companyMessageChangeRespone:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:companyMessageView];
    if (CGRectContainsPoint(CGRectMake(70,interviewTemplate.center.y-24,ScreenWidth-70,48),point)){
        //面试模板
        ELResumeTypeChangeCtl *ctl = [[ELResumeTypeChangeCtl alloc] init];
        ctl.changeType = TemplateType;
        ctl.block = ^(id model){
            if ([model isKindOfClass:[InterviewModel_DataModal class]]) {
                InterviewModel_DataModal * dataModal = model;
                interviewTemplate.text = dataModal.temlname_;
                companyName.text = dataModal.cname_;
                companyPhone.text = dataModal.phone_;
                companyPeople.text = dataModal.pname_;
                companyPlace.text = dataModal.address_;
            }
        };
        [ctl beginLoad:nil exParam:nil];
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
    }else if (CGRectContainsPoint(CGRectMake(70,companyPlace.center.y-24,ScreenWidth-70,48),point)){
        //面试地点
        ELResumeTypeChangeCtl *ctl = [[ELResumeTypeChangeCtl alloc] init];
        ctl.changeType = PlaceType;
        ctl.editorContent = companyPlace.text;
        ctl.block = ^(id model){
            if ([model isKindOfClass:[NSString class]]) {
                companyPlace.text = model;
            }
        };
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
        
    }else if (CGRectContainsPoint(CGRectMake(70,companyPeople.center.y-24,ScreenWidth-70,48),point)){
        //联系人
        ELResumeTypeChangeCtl *ctl = [[ELResumeTypeChangeCtl alloc] init];
        ctl.changeType = PeopleType;
        ctl.editorContent = companyPeople.text;
        ctl.block = ^(id model){
            if ([model isKindOfClass:[NSString class]]) {
                companyPeople.text = model;
            }
        };
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
    }else if (CGRectContainsPoint(CGRectMake(70,companyPhone.center.y-24,ScreenWidth-70,48),point)){
        //联系电话
        ELResumeTypeChangeCtl *ctl = [[ELResumeTypeChangeCtl alloc] init];
        ctl.changeType = PhoneType;
        ctl.editorContent = companyPhone.text;
        ctl.block = ^(id model){
            if ([model isKindOfClass:[NSString class]]) {
                companyPhone.text = model;
            }
        };
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
    }
}

#pragma mark - 显示和隐藏公司信息
-(void)showCompanyMessageBtnRespone:(ELBaseButton *)sender{
    CGRect frame = companyMessageView.frame;
    if(sender.isShow){
        frame.size.height = 48;
        sender.isShow = NO;
        offImg.transform=CGAffineTransformMakeRotation(0);
        [offButton setTitle:@"展示  " forState:UIControlStateNormal];
    }else{
        frame.size.height = 288;
        sender.isShow = YES;
        offImg.transform=CGAffineTransformMakeRotation(M_PI);
        [offButton setTitle:@"收起  " forState:UIControlStateNormal];
    }
    companyMessageView.frame = frame;
    
    frame = bottomLb.frame;
    frame.origin.y = companyMessageView.bottom+15;
    bottomLb.frame = frame;
    headerView.frame = CGRectMake(0,0,ScreenWidth,bottomLb.bottom+5);
    tableView_.tableHeaderView = headerView;
}

#pragma mark - 同事中添加点击事件
-(void)addPeople:(UIButton *)sender{
    ELTranspondAddPeopleCtl *ctl = [[ELTranspondAddPeopleCtl alloc] init];
    ctl.dataArr_ = emailArr;
    __weak ELResumeTranspondCtl *emailCtl = self;
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
    __weak ELResumeTranspondCtl *emailCtl = self;
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

#pragma mark - 面试时间选择
-(void)timeChangeRespone:(UIButton *)sender{
    [self dismissKeyboard];
    if (!changeDateCtl)
    {
        changeDateCtl = [[ELChangeDateCtl alloc] init];
        changeDateCtl.showTodayBtn = NO;
        changeDateCtl.showMinDate = YES;
        changeDateCtl.pickerMode = UIDatePickerModeDateAndTime;
    } 
    [changeDateCtl showViewCtlCurrentDate:nil WithBolck:^(CondictionList_DataModal *dataModal)
     {
         NSString *str = [dataModal.changeDate stringWithFormatDefault];
         timeTF.text = [str substringToIndex:16];
     }];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    _userModal = dataModal;
    nameLb.text = _userModal.name_;
    jobLb.text = _userModal.job_;
    jobId = _userModal.zpId_;
    companyId_ = exParam;
    if ([Manager getUserInfo].companyModal_) {
        CompanyInfo_DataModal *companyModel = [Manager getUserInfo].companyModal_;
        companyName.text = companyModel.cname_;
        companyPhone.text = companyModel.phone_;
        companyPeople.text = companyModel.pname_;
        companyPlace.text = companyModel.address_;
        interviewTemplate.text = @"默认模板";
    }
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
    __weak ELResumeTranspondCtl *emailCtl = self;
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
