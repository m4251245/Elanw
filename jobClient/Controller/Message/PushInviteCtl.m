//
//  PushInviteCtl.m
//  Association
//
//  Created by YL1001 on 14-5-12.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "PushInviteCtl.h"
#import "PushPublishCtl_Cell.h"
#import "MyJobSearchCtl.h"
@interface PushInviteCtl ()

@end

@implementation PushInviteCtl

-(id)init
{
    self = [super init];
    
    bFooterEgo_ = YES;
    //messageArr_ = [[NSMutableArray alloc] init];
    
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
//    self.navigationItem.title = @"工作机会";
    [self setNavTitle:@"工作机会"];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}


//-(void)beginLoad:(id)dataModal exParam:(id)exParam
//{
//    messageArr_ = dataModal;
//    messageArr_ = (NSMutableArray*)[[messageArr_ reverseObjectEnumerator] allObjects];
//    
//    [tableView_ reloadData];
//}


-(void)getDataFunction:(RequestCon *)con
{
    [con getOneMessageList:0 msgType:@"40,50,210" status:0 userId:[Manager getUserInfo].userId_ pageSize:10 page:requestCon_.pageInfo_.currentPage_];
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
                NSString * timeStr = [CommonConfig getDBValueByKey:@"LastCheckJobMessage_Time"];
                if (!timeStr) {
                    NSDate * now = [NSDate date];
                    timeStr = [MyCommon getDateStr:now format:@"yyyy-MM-dd HH:mm:ss"];
                    [CommonConfig setDBValueByKey:@"LastCheckJobMessage_Time" value:timeStr];
                }
                NSDate * lastDate = [MyCommon getDate:timeStr];
                if ([lastDate earlierDate:date] == lastDate) {
                    bModal.beNew_ = @"new";
                }
                else
                    bModal.beNew_ = @"old";
            }
            if (requestCon_.pageInfo_.currentPage_ == 1) {
                NSDate * date = [NSDate date];
                [CommonConfig setDBValueByKey:@"LastCheckJobMessage_Time" value:[MyCommon getDateStr:date format:@"yyyy-MM-dd HH:mm:ss"]];
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
    
    if ([dataModal.type_ isEqualToString:@"50"]) {
        @try {
            //NSRange range = [dataModal.content_ rangeOfString:@"阅读了您的简历!"];
            cell.companyLb_.text = [dataModal.extraDic_ objectForKey:@"tit"];
        }
        @catch (NSException *exception) {
            
        }
        
        cell.contentLb_.text = @"阅读了您的简历!";
    }
    if ([dataModal.type_ isEqualToString:@"40"]) {
        cell.companyLb_.text = [dataModal.extraDic_ objectForKey:@"tit"];
        cell.contentLb_.text = @"向您发送了一个面试通知";
    }
    
    if ([dataModal.type_ isEqualToString:@"210"]) {
        cell.companyLb_.text = @"职位订阅";
        cell.contentLb_.text = dataModal.content_;
    }
    
    if ([dataModal.type_ isEqualToString:@"40"]||[dataModal.type_ isEqualToString:@"50"]||[dataModal.type_ isEqualToString:@"210"]) {
        NSDate * date = [MyCommon getDate:dataModal.time_];
        NSString * str = [MyCommon compareCurrentTime:date];
        cell.timeLb_.text = str;
        
        
        if ([dataModal.beNew_ isEqualToString:@"new"]) {
            cell.markNewImg_.alpha = 1.0;
        }
        else
            cell.markNewImg_.alpha = 0.0;
    }
    
    return cell;
    
    
}


-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    Message_DataModal * dataModal = selectData;
    
    dataModal.beNew_ = @"old";
    [tableView_ reloadData];
    
    if ([dataModal.type_ isEqualToString:@"40"]) {
        //面试通知
        if (!resumeNotifyCtl_) {
            resumeNotifyCtl_ = [[InterviewMessageListCtl alloc] init];
        }
        [self.navigationController pushViewController:resumeNotifyCtl_ animated:YES];
        [resumeNotifyCtl_ beginLoad:nil exParam:nil];
        
    }
    if ([dataModal.type_ isEqualToString:@"50"]) {
        //简历被查看
        if (!companyLookedDetailCtl_) {
            companyLookedDetailCtl_ = [[ResumeVisitorListCtl alloc] init];
        }
        [self.navigationController pushViewController:companyLookedDetailCtl_ animated:YES];
        [companyLookedDetailCtl_ beginLoad:nil exParam:nil];
    }
    if ([dataModal.type_ isEqualToString:@"210"]) {
        //职位订阅
        if (![Manager shareMgr].subscribedJobsCtl_) {
            [Manager shareMgr].subscribedJobsCtl_ = [[SubscribedJobsCtl alloc] init];
        }
        [Manager shareMgr].subscribedJobsCtl_.type_ = 1;
        [self.navigationController pushViewController:[Manager shareMgr].subscribedJobsCtl_ animated:YES];
        [[Manager shareMgr].subscribedJobsCtl_ beginLoad:[dataModal.extraDic_ objectForKey:@"aid"] exParam:nil];
    }
    
}

-(void)backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
    
    
    

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
