//
//  PushPublishCtl.m
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PushPublishCtl.h"
#import "MessageCtl_Cell.h"
#import "PushPublishCtl_Cell.h"

@interface PushPublishCtl ()

@end

@implementation PushPublishCtl
@synthesize type_;

-(id)init
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
//     self.navigationItem.title = @"最新发表";
    [self setNavTitle:@"最新发表"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if (type_ == 1) {
//        self.navigationItem.title = @"最新发表";
        [self setNavTitle:@"最新发表"];
    }
    if (type_ == 2) {
//        self.navigationItem.title = @"我的问答";
        [self setNavTitle:@"我的问答"];
    }
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSString * msgType = @"";
    if (type_ == 1) {
        msgType = @"190,250";
    }
    if (type_ == 2) {
        msgType = @"180,181";
    }
    [con getOneMessageList:0 msgType:msgType status:0 userId:[Manager getUserInfo].userId_ pageSize:10 page:requestCon_.pageInfo_.currentPage_];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_OneMessageList:
        {
            for (NSInteger i = (requestCon_.pageInfo_.currentPage_-1) *10; i < requestCon_.pageInfo_.currentPage_*10;++i) {
                Message_DataModal * bModal = [requestCon_.dataArr_ objectAtIndex:i];
                NSDate  * date = [MyCommon getDate:bModal.time_];
                NSString * timeStr =@"";
                if (type_ == 1) {
                     timeStr = [CommonConfig getDBValueByKey:@"LastCheckPublishMessage_Time"];
                    if (!timeStr) {
                        NSDate * now = [NSDate date];
                        timeStr = [MyCommon getDateStr:now format:@"yyyy-MM-dd HH:mm:ss"];
                        [CommonConfig setDBValueByKey:@"LastCheckPublishMessage_Time" value:timeStr];
                    }
                }
                else{
                    timeStr = [CommonConfig getDBValueByKey:@"LastCheckAQMessage_Time"];
                    if (!timeStr) {
                        NSDate * now = [NSDate date];
                        timeStr = [MyCommon getDateStr:now format:@"yyyy-MM-dd HH:mm:ss"];
                        [CommonConfig setDBValueByKey:@"LastCheckAQMessage_Time" value:timeStr];
                    }
                    
                }
                NSDate * lastDate = [MyCommon getDate:timeStr];
                if ([lastDate earlierDate:date] == lastDate) {
                    bModal.beNew_ = @"new";
                }
                else
                    bModal.beNew_ = @"old";
            }
            
            
            NSDate * now = [NSDate date];
            if (type_ == 1) {
                if (requestCon_.pageInfo_.currentPage_ == 1) {
                    [CommonConfig setDBValueByKey:@"LastCheckPublishMessage_Time" value:[MyCommon getDateStr:now format:@"yyyy-MM-dd HH:mm:ss"]];
                }
            }
            if (type_ == 2) {
                if (requestCon_.pageInfo_.currentPage_ == 1) {
                    [CommonConfig setDBValueByKey:@"LastCheckAQMessage_Time" value:[MyCommon getDateStr:now format:@"yyyy-MM-dd HH:mm:ss"]];
                }
                
            }
        }
            break;
            
        default:
            break;
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCtlCell";
    
    PushPublishCtl_Cell *cell = (PushPublishCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        //cell = [[MainCtl_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PushPublishCtl_Cell" owner:self options:nil] lastObject];
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Message_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    
    if (type_ == 1) {
        if ([dataModal.type_ isEqualToString:@"190"]) {
            
            @try {
                cell.companyLb_.text = [dataModal.extraDic_ objectForKey:@"name"];
                cell.contentLb_.text = [NSString stringWithFormat:@"发表了:%@",[dataModal.extraDic_ objectForKey:@"tit"]];
            }
            @catch (NSException *exception) {
                
            }
            
            
        }
        if ([dataModal.type_ isEqualToString:@"250"]) {

            @try {
                cell.companyLb_.text = [dataModal.extraDic_ objectForKey:@"name"];
                cell.contentLb_.text = [NSString stringWithFormat:@"评论了:%@",[dataModal.extraDic_ objectForKey:@"tit"]];
            }
            @catch (NSException *exception) {
                
            }

        }
    }
    
    if (type_ == 2) {
        if ([dataModal.type_ isEqualToString:@"180"]) {
            cell.companyLb_.text = [dataModal.extraDic_ objectForKey:@"name"];
            cell.contentLb_.text = [NSString stringWithFormat:@"回答了您的问题:%@",[dataModal.extraDic_ objectForKey:@"tit"]];
        }
        if ([dataModal.type_ isEqualToString:@"181"]) {
            cell.companyLb_.text = [dataModal.extraDic_ objectForKey:@"name"];
            cell.contentLb_.text = [NSString stringWithFormat:@"向您提了问题:%@",[dataModal.extraDic_ objectForKey:@"tit"]];
        }
    }
    
    NSDate * date = [MyCommon getDate:dataModal.time_];
    NSString * str = [MyCommon compareCurrentTime:date];
    cell.timeLb_.text = str;
    if ([dataModal.messageId_ isEqualToString:@"yilanwelcome"]) {
        cell.timeLb_.text = @"";
    }
    
    if ([dataModal.beNew_ isEqualToString:@"new"]) {
        cell.markNewImg_.alpha = 1.0;
    }
    else
        cell.markNewImg_.alpha = 0.0;
    
    return cell;
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    Message_DataModal * dataModal = selectData;
    dataModal.beNew_ = @"old";
    [tableView_ reloadData];
    if ([dataModal.messageId_ isEqualToString:@"yilanwelcome"]) {
        return;
    }
    
//    if (type_ == 2) {
//        //有提问被回答时的消息
//        if ([dataModal.type_ isEqualToString:@"180"]) {
//
//            MyAskQuestionCtl *askQuestionCtl = [[MyAskQuestionCtl alloc] init];
//            [askQuestionCtl changeStatus:1];
//            [self.navigationController pushViewController:askQuestionCtl animated:YES];
//            [askQuestionCtl beginLoad:nil exParam:nil];
//            
//            
//        }
//    
//        if ([dataModal.type_ isEqualToString:@"181"]) {
//            //有被提问消息时的消息
//            MyAnswerCenterCtl *answerCenterCtl = [[MyAnswerCenterCtl alloc] init];
//            [answerCenterCtl changeStatus:1];
//            [self.navigationController pushViewController:answerCenterCtl animated:YES];
//            [answerCenterCtl beginLoad:nil exParam:nil];
//        }
//    }
    
    if (type_ == 1) {
        //我关注的用户有发表时的消息或者我发表的文章有新评论
        Article_DataModal * articleModal = [[Article_DataModal alloc] init];
        articleModal.id_ = [dataModal.extraDic_ objectForKey:@"aid"];
        ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc] init];
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:articleModal exParam:nil];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
    
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Message_DataModal * dataModal = [messageArr_ objectAtIndex:indexPath.row];
    
    
    if ([dataModal.messageId_ isEqualToString:@"yilanwelcome"]) {
        [BaseUIViewController showAlertView:@"此消息无法删除" msg:nil btnTitle:@"确定"];
        return;
    }
    //删除数据库表中的数据
    [[MyDataBase defaultDB] deleteSQL:[NSString stringWithFormat:@"messageId='%@'",dataModal.messageId_] tableName:DB_Table_Message];
    if (indexPath.row<[messageArr_ count]) {
        [messageArr_ removeObjectAtIndex:indexPath.row];//移除数据源的数据
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
    }
    
    if ([messageArr_ count] < 1) {
        Message_DataModal *dataModal = [[Message_DataModal alloc] init];
        dataModal.messageId_   = @"yilanwelcome";
        dataModal.type_  = @"1000";
        dataModal.publishName_ = @"已经没有相关信息了！";
        dataModal.content_ = @"";
        dataModal.time_ = @"";
        dataModal.userId_ = [Manager getUserInfo].userId_;
        dataModal.beNew_ = @"always";
        [messageArr_ addObject:dataModal];
    }
    
    [tableView_ reloadData];
    
}


@end
