//
//  TranspondResumeCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-12.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  邮件转发

#import "TranspondResumeCtl.h"
#import "CompanyOtherHR_Cell.h"
#import "CompanyOtherHR_DataModal.h"

@interface TranspondResumeCtl ()
{
    NSString * companyId_;
    CompanyOtherHR_DataModal * selectedModal_;
}

@end

@implementation TranspondResumeCtl
@synthesize delegate_,url_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bHeaderEgo_ = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView_.scrollEnabled = NO;
    scrollView_.pagingEnabled = YES;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _backView.layer.cornerRadius = 8.0f;
    _backView.layer.masksToBounds = YES;
    
    commitBtn_.layer.cornerRadius = 4.0f;
    commitBtn_.layer.masksToBounds = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    companyId_ = exParam;
    selectedModal_ = nil;
    [emailTX_ setText:@""];
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    
    [con getCompanyOtherHR:companyId_];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetCompanyOtherHR:
        {
            CGRect frame;
            if (requestCon.dataArr_.count == 0) {
                tableView_.hidden = YES;
                
                frame = _backView.frame;
                frame.size.height = 160.0f;
                _backView.frame = frame;
                
                frame = commitBtn_.frame;
                frame.origin.y = 113.0f;
                commitBtn_.frame = frame;
            }
            else if (requestCon.dataArr_.count < 5 && requestCon.dataArr_.count > 0)
            {
                tableView_.hidden = NO;
                
                frame = tableView_.frame;
                frame.size.height = requestCon.dataArr_.count * 28;
                tableView_.frame = frame;
                
                frame = commitBtn_.frame;
                frame.origin.y = CGRectGetMaxY(tableView_.frame) + 10;
                commitBtn_.frame = frame;
                
                frame = _backView.frame;
                frame.size.height = CGRectGetMaxY(commitBtn_.frame) + 10;
                _backView.frame = frame;
            }
            else
            {
                tableView_.hidden = NO;
            }
        }
            break;
        case Request_TranspondResume:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:dataModal.des_ msg:nil seconds:2.0];
                [delegate_ removeView];
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
                [delegate_ removeView];
            }
            else
                [BaseUIViewController showAutoDismissFailView:@"转发失败" msg:@"请稍后再试" seconds:2.0];
        }
            break;

        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyOtherHR_Cell";
    
    CompanyOtherHR_Cell *cell = (CompanyOtherHR_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyOtherHR_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    CompanyOtherHR_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    if (!dataModal.bChoosed_) {
        [cell.slelectImg_ setImage:[UIImage imageNamed:@"ico_select_off"]];
    }
    else
        [cell.slelectImg_ setImage:[UIImage imageNamed:@"ico_select_on"]];
    
    cell.nameLb_.text = [NSString stringWithFormat:@"%@(%@)",dataModal.name_,dataModal.contactEmail_];
    
    
    return cell;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    CompanyOtherHR_DataModal * dataModal = selectData;
    if (dataModal.bChoosed_) {
        return;
    }
    else
    {
        for (CompanyOtherHR_DataModal * modal in requestCon_.dataArr_) {
            modal.bChoosed_ = NO;
        }
        dataModal.bChoosed_ = YES;
        
        emailTX_.text = dataModal.contactEmail_;
        
        [tableView_ reloadData];
        
    }
}

-(void)btnResponse:(id)sender
{
    if (sender == clostBtn_) {
        //[delegate_ removeView];
        [self.view removeFromSuperview];
    }
    else if (sender == commitBtn_) {
        if ([[emailTX_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [BaseUIViewController showAlertView:@"请选择或者填写联系人的邮箱后再发送" msg:nil btnTitle:@"确定"];
            return;
        }
        if (!transferon_) {
            transferon_ = [self getNewRequestCon:NO];
        }
        NSString * flag = @"";
        NSDictionary *conditionDic = nil;
        if (inModal_.isGWTJ_) {//外发的简历
            flag = @"tj";
        }else if(_type == TranspondAdviserRecommend){//offer派中招聘顾问推荐
            flag = @"salertj";
            conditionDic = @{@"tuijian_id":inModal_.recommendId,@"tjtype":inModal_.jlType,@"fromtype":@"app"};
        }else if (_resumeType == ResumeTypePersonDelivery){//人才投递
            flag = @"cmailbox";
        }else if (_resumeType == ResumeTypeAdviserRecommend ){//顾问推荐
            flag = @"tjresume";
        }else if (_resumeType == ResumeTypeDownload){//已下载
            flag = @"cfavorite";
        }else if (_resumeType == ResumeTypeTempSearch || _resumeType == ResumeTypeTempSaved){//企业简历搜索 暂存简历
            flag = @"search";
        }else{
            flag = @"cmailbox";//人才投递的
        }
        
        NSString * title = [NSString stringWithFormat:@"%@的简历邮件",inModal_.name_];
        NSString *salerId = [Manager getHrInfo].salerId;
        
        if (_isGUWEN == YES) {
            [transferon_ transpondResume:salerId personId:inModal_.userId_ email:emailTX_.text title:title conditionArr:conditionDic];
        }else{
            [transferon_ transpondResume:companyId_ personId:inModal_.userId_ flag:flag title:title email:emailTX_.text conditionArr:conditionDic];
        }
        
    }
    else if (sender == backBtn_)
    {
        [delegate_ backView];
        [self.view removeFromSuperview];
    }
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.view target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    //singleTapRecognizer_.delegate = self;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.view ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [emailTX_ resignFirstResponder];
}

//按类型进行分享
-(void)share:(NSInteger)shareType
{
   NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1024"  ofType:@"png"];
   
   NSString * sharecontent = [NSString stringWithFormat:@"%@的微简历",inModal_.name_];
   
   NSString * titlecontent = @"微简历";
   
   NSString * url = url_;
    NSLog(@"-------------------------%@",url);
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    //调用分享
    [[ShareManger sharedManager] shareSingleWithType:[NSString stringWithFormat:@"%ld",(long)shareType] ctl:self title:titlecontent content:sharecontent image:image url:url];
}

@end
