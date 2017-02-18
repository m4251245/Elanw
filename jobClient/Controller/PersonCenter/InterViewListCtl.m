//
//  InterViewListCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "InterViewListCtl.h"
#import "InterviewListCell.h"
#import "InterviewDataModel.h"

@interface InterViewListCtl ()

@end

@implementation InterViewListCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)reciveNewMesageAction:(NSNotificationCenter *)notifcation{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"小编专访";
    [self setNavTitle:@"小编专访"];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (_isMyCenter) {
        
    }else
    {
        
    }
}

- (void)getDataFunction:(RequestCon *)con
{
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getInterviewList:userId pageSize:20 pageIndex:requestCon_.pageInfo_.currentPage_];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    userId = dataModal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InterviewDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    float questHeight = [Common getDynHeight:model.question_ objWidth:ScreenWidth-50 font:FOURTEENFONT_CONTENT];
    float answerHeight = 15;
    if (![model.answer_ isEqualToString:@""]) {
        answerHeight = [Common getDynHeight:model.answer_ objWidth:ScreenWidth-50 font:FOURTEENFONT_CONTENT];
    }
    return 44+questHeight+answerHeight;
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_InterviewList:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InterviewListCell";
    InterviewListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InterviewListCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.bgView_.layer.borderWidth = 0.5;
        cell.bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
        //样式
        [cell.questionLb_ setFont:FOURTEENFONT_CONTENT];
        [cell.questionLb_ setTextColor:UIColorFromRGB(0x333333)];
        [cell.answerLb_ setFont:FOURTEENFONT_CONTENT];
        [cell.answerLb_ setTextColor:UIColorFromRGB(0x666666)];
        cell.answerBtn_.layer.cornerRadius = 2.0;
        cell.answerBtn_.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:71.0/255.0 blue:76.0/255.0 alpha:1.0].CGColor;
        cell.answerBtn_.layer.borderWidth = 0.5;
        cell.answerBtn_.layer.masksToBounds = YES;
    }
    
    InterviewDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    if (_isMyCenter) {
        if ([model.answer_ isEqualToString:@""]) {
            [cell.answerBtn_ setHidden:NO];
            [cell.rightImgv_ setHidden:YES];
        }else{
            [cell.answerBtn_ setHidden:YES];
            [cell.rightImgv_ setHidden:NO];
        }
    }else{
        [cell.answerBtn_ setHidden:YES];
        [cell.rightImgv_ setHidden:YES];
    }
    
    [cell.questionLb_ setText:model.question_];
    [cell.answerLb_ setText:model.answer_];
    CGRect questRect = cell.questionLb_.frame;
    float questionHeight = [Common getDynHeight:model.question_ objWidth:ScreenWidth-50 font:FOURTEENFONT_CONTENT];
    questRect.size.height = questionHeight;
    questRect.size.width = ScreenWidth-50;
    [cell.questionLb_ setFrame:questRect];
    if ([model.answer_ isEqualToString:@""]) {
        CGRect anserRect = cell.answerLb_.frame;
        anserRect.origin.y = questRect.origin.y + questRect.size.height + 10;
        anserRect.size.width = ScreenWidth-50;
        [cell.answerLb_ setFrame:anserRect];
    }else{
        CGRect anserRect = cell.answerLb_.frame;
        anserRect.size.height = [Common getDynHeight:model.answer_ objWidth:ScreenWidth-50 font:FOURTEENFONT_CONTENT];
        anserRect.origin.y = questRect.origin.y + questRect.size.height + 10;
        anserRect.size.width = ScreenWidth-50;
        [cell.answerLb_ setFrame:anserRect];
    }
    
    float height = cell.answerLb_.frame.origin.y + cell.answerLb_.frame.size.height + 12;
    [cell.bgView_ setFrame:CGRectMake(10, 5, ScreenWidth-20, height)];
    
    CGRect rightImgvRect = cell.rightImgv_.frame;
    rightImgvRect.origin.y = (height-rightImgvRect.size.height)/2;
    [cell.rightImgv_ setFrame:rightImgvRect];
    
    return cell;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if (_isMyCenter) {
        InterviewDataModel *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        InterviewAnswerCtl *answerCtl = [[InterviewAnswerCtl alloc]init];
        answerCtl.block = ^(){
            [tableView_ reloadData];
            if (self.block) {
                self.block();
            }
        };
        [answerCtl beginLoad:model exParam:nil];
        [self.navigationController pushViewController:answerCtl animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
