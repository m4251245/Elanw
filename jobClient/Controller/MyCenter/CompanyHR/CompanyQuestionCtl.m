//
//  CompanyQuestionCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CompanyQuestionCtl.h"
#import "CompanyQuestionCtl_Cell.h"
#import "CompanyHRAnswer_DataModal.h"


@interface CompanyQuestionCtl ()
{
    NSString * companyId_;
}

@end

@implementation CompanyQuestionCtl
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"人才提问";
    [self setNavTitle:@"人才提问"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationItem.title = @"人才提问";
}

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationItem.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
    
}

-(void)getDataFunction:(RequestCon *)con
{
    [con companyQuestion:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

#pragma mark - tableview delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyQuestionCtl_Cell";
    CompanyQuestionCtl_Cell *cell = (CompanyQuestionCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CompanyQuestionCtl_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    [cell.askNameLb_ setFont:FOURTEENFONT_CONTENT];
    [cell.askNameLb_ setTextColor:BLACKCOLOR];
    [cell.timeLb_ setFont:ELEVEN_TIME];
    [cell.timeLb_ setTextColor:LIGHTGRAYCOLOR];
    [cell.questionLb_ setTextColor:BLACKCOLOR];
    [cell.answerLb_ setTextColor:GRAYCOLOR];
    
    CompanyHRAnswer_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    [cell.userImg_ sd_setImageWithURL:[NSURL URLWithString:dataModal.quizzerPic_] placeholderImage:[UIImage imageNamed:@"bg__xinwen"]];
    NSString * str = @"";
    @try {
        str = [dataModal.quizzerName_ substringToIndex:1];
    }
    @catch (NSException *exception) {
        
    }
    
    if ([dataModal.quizzerSex_ isEqualToString:@"男"]) {
        str = [NSString stringWithFormat:@"%@先生",str];
    }
    else if ([dataModal.quizzerSex_ isEqualToString:@"女"]){
        str = [NSString stringWithFormat:@"%@女士",str];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@**",str];
    }
    
    cell.askNameLb_.text = [NSString stringWithFormat:@"%@问:",str];
    cell.timeLb_.text = [NSString stringWithFormat:@"%@",dataModal.questionIdate_];
    [Common setLbByText:cell.questionLb_ text:[MyCommon translateHTML:dataModal.questionTitle_] font:FOURTEENFONT_CONTENT];
    [cell.answerBtn_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.answerBtn_.tag = indexPath.row;
    
    
    if (dataModal.isAnswered_) {
        cell.answerView_.hidden = NO;
        CGRect rect = cell.answerView_.frame;
        rect.origin.y = cell.questionLb_.frame.origin.y + cell.questionLb_.frame.size.height + 8;
        [Common setLbByText:cell.answerLb_ text:[MyCommon translateHTML:dataModal.answerContent_] font:FOURTEENFONT_CONTENT];
        rect.size.height = cell.answerLb_.frame.origin.y + cell.answerLb_.frame.size.height;
        cell.answerView_.frame = rect;
        
        cell.answerBtn_.alpha = 0.0;
    }
    else
    {
        cell.answerView_.hidden = YES;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyHRAnswer_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    float height = [Common getDynHeight:dataModal.questionTitle_ objWidth:265.0 font:FOURTEENFONT_CONTENT];
    height = height > 21 ? height : 21;
    if (!dataModal.isAnswered_) {
         return height + 50;
    }
    else
    {
        float answerHeight = [Common getDynHeight:dataModal.answerContent_ objWidth:265.0 font:FOURTEENFONT_CONTENT];
        return height + 50 + answerHeight + 20 + 8 + 8;
    }
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];

//    CompanyHRAnswer_DataModal * dataModal = selectData;
//    Answer_DataModal * answerModal = [[Answer_DataModal alloc] init];
//    answerModal.questionId_ = dataModal.id_;
//    answerModal.questionTitle_ = dataModal.questionTitle_;
//    answerModal.quizzerName_ = dataModal.quizzerName_;
//    SubmitAnswerCtl * submitAnswerCtl = [[SubmitAnswerCtl alloc] init];
//    submitAnswerCtl.type_ = 1;
//    submitAnswerCtl.delegate_ = self;
//    [self.navigationController pushViewController:submitAnswerCtl animated:YES];
//    [submitAnswerCtl beginLoad:answerModal exParam:companyId_];
    
}


-(void)btnResponse:(id)sender
{
    UIButton * btn = sender;
    CompanyHRAnswer_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag];
    Answer_DataModal * answerModal = [[Answer_DataModal alloc] init];
    answerModal.questionId_ = dataModal.id_;
    answerModal.questionTitle_ = dataModal.questionTitle_;
    NSString * str = @"";
    @try {
        str = [dataModal.quizzerName_ substringToIndex:1];
    }
    @catch (NSException *exception) {
        
    }
    
    if ([dataModal.quizzerSex_ isEqualToString:@"男"]) {
        str = [NSString stringWithFormat:@"%@先生",str];
    }
    else if ([dataModal.quizzerSex_ isEqualToString:@"女"]){
        str = [NSString stringWithFormat:@"%@女士",str];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@**",str];
    }

    answerModal.quizzerName_ = str;
    SubmitAnswerCtl * submitAnswerCtl = [[SubmitAnswerCtl alloc] init];
    submitAnswerCtl.type_ = 1;
    submitAnswerCtl.delegate_ = self;
    [self.navigationController pushViewController:submitAnswerCtl animated:YES];
    [submitAnswerCtl beginLoad:answerModal exParam:companyId_];
}


#pragma SubmitAnswerCtlDelegate
-(void)submitOK
{
    [self refreshLoad:nil];
    [delegate_ submitAnswerOK];
}

@end
