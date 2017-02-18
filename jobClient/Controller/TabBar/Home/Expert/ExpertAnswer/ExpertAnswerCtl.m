//
//  ExpertAnswerCtl.m
//  Association
//
//  Created by 一览iOS on 14-3-6.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ExpertAnswerCtl.h"
#import "ExpertAnswerCtl_Cell.h"
#import "Answer_DataModal.h"
#import "NoLoginPromptCtl.h"


@interface ExpertAnswerCtl () <NoLoginDelegate>
{
  
}

@end



@implementation ExpertAnswerCtl

-(id) init
{
    self = [super init];
    
    bFooterEgo_ = YES;
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"专家详情";
    [self setNavTitle:@"专家详情"];
    askBtn_.layer.cornerRadius = 4.0;
    detailBtn_.layer.cornerRadius = 4.0;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:234.0/255.0 blue:241.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (inModal_) {
        nameLb_.text = inModal_.iname_;
        answerCntLb_.text = [NSString stringWithFormat:@"%ld",(long)inModal_.answerCnt_];
        goodatLb_.text = [NSString stringWithFormat:@"擅长领域:%@",inModal_.goodat_];
        if (!inModal_.job_ ||[inModal_.job_ isEqual:[NSNull null]]) {
            inModal_.job_ = @"暂无";
        }
        
        jobLb_.text = [NSString stringWithFormat:@"职位/职称:%@",inModal_.job_];
        gznumLb_.text = [NSString stringWithFormat:@"从业年限:%@",inModal_.gznum_];
        companyLb_.text = [NSString stringWithFormat:@"公司/单位:%@",inModal_.company_];
        //introLb_.text = inModal_.content_;
        introLb_.text = inModal_.content_;
//        float h = [Common setLbByText:introLb_ text:[NSString stringWithFormat:@"行家简介:%@",inModal_.content_] font:nil];
        CGRect rect = headView_.frame;
        rect.size.height = CGRectGetMaxY(introLb_.frame) + 8;
        headView_.frame = rect;

        tableView_.tableHeaderView = headView_;
        [tableView_ reloadData];
        
        lineView_.frame = CGRectMake(0, headView_.frame.size.height-1, 320, 1);
        
        [imgView_ sd_setImageWithURL:[NSURL URLWithString:inModal_.img_] placeholderImage:nil];
    }
    
    
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    showDetail_ = NO;
    [super beginLoad:dataModal exParam:exParam];
    [self updateCom:nil];
}

-(void)getDataFunction:(RequestCon *)con
{
    [con getExpertAnswerList:inModal_.id_ page:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_Image:
        {
            @try {
                if (![inModal_.img_ isEqual:[NSNull null]]) {
                    if ([inModal_.img_ isEqualToString:requestCon.url_]) {
                        inModal_.imageData_ = [dataArr objectAtIndex:0];
                    }
                }
                [imgView_ setImage:[UIImage imageWithData:inModal_.imageData_]];
                [tableView_ reloadData];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }

        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExpertAnswerCtl_Cell";
    
    ExpertAnswerCtl_Cell   *cell = (ExpertAnswerCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpertAnswerCtl_Cell" owner:self options:nil] lastObject];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.imgView_.layer.cornerRadius = 10.0;
        cell.bigView_.layer.cornerRadius = 2.0;
    }
    
    Answer_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    dataModal.img_ = inModal_.img_;
    dataModal.expertName_ = inModal_.iname_;
    dataModal.expertJob_ = inModal_.job_;
    dataModal.expertgznum_ = inModal_.gznum_;
    dataModal.isMine_ = NO;
    
    cell.nameLb_.text = [NSString stringWithFormat:@"%@:",dataModal.quizzerName_];
    cell.questionLb_.text = dataModal.questionTitle_;
    cell.answerLb_.text = dataModal.content_;
    
    [cell.imgView_ sd_setImageWithURL:[NSURL URLWithString:inModal_.img_] placeholderImage:nil];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"TA的回答";
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    Answer_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    AnswerDetailCtl *answerCtl_ = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:answerCtl_ animated:YES];
    [answerCtl_ beginLoad:dataModal.questionId_ exParam:exParam];
}

-(void)btnResponse:(id)sender
{
    if (![Manager shareMgr].haveLogin) {
        [[NoLoginPromptCtl noLoginManagerWithDelegate:self] showNoLoginCtlView];
        //[ self showChooseAlertView:3 title:@"您尚未登录" msg:@"请先登录" okBtnTitle:@"登录" cancelBtnTitle:@"取消"];
        return;
    }
    if(sender == askBtn_){
        
        AskDefaultCtl* askDefaultCtl_ = [[AskDefaultCtl alloc]init];
        askDefaultCtl_.backCtlIndex = self.navigationController.viewControllers.count-1;
        [self.navigationController pushViewController:askDefaultCtl_ animated:YES];
        [askDefaultCtl_ beginLoad:inModal_.id_ exParam:nil];
        
    }
}

-(void)loginDelegateCtl
{
    [[Manager shareMgr] loginOut];
    [Manager shareMgr].haveLogin = NO;
}

-(void)alertViewChoosed:(UIAlertView *)alertView index:(int)index type:(int)type
{
    switch ( type ) {
        case 3:
        {
            [[Manager shareMgr] loginOut];
            [Manager shareMgr].haveLogin = NO;
        }
            
            break;
            
        default:
            break;
    }
    
}

@end
