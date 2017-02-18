//
//  MessageRefreshCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MessageRefreshCtl.h"
#import "ExRequetCon.h"

@interface MessageRefreshCtl ()
{
    RequestCon   *countCon;
}
@end

@implementation MessageRefreshCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)requestCount
{
    if (!countCon) {
        countCon = [self getNewRequestCon:YES];
    }
    [countCon getMessageCnt:[Manager getUserInfo].userId_];
//    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
//    NSString * function = @"getMessageSidebarCnt";
//    NSString * op = @"yl_app_push_busi";
//     [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
//         NSDictionary *dic = result;
//         if ([dic isKindOfClass:[NSDictionary class]]) {
//             NSDictionary * dataDic = [dic objectForKey:@"data"];
//             if ([dataDic isKindOfClass:[NSDictionary class]]) {
//                 Message_DataModal * model = [[Message_DataModal alloc] init];
//                 model.toolBarGroupCnt = [[dataDic objectForKey:@"group_dynamic_cnt"] integerValue];
//                 model.companyCnt = [[dataDic objectForKey:@"resume_read_cnt"] integerValue];
//                 model.messageCnt = [[dataDic objectForKey:@"message_cnt"] integerValue];
//                 model.resumeCnt = [[dataDic objectForKey:@"resume_cnt"] integerValue];
//                 model.questionCnt = [[dataDic objectForKey:@"question_cnt"] integerValue];
//                 model.myInterViewCnt = [[dataDic objectForKey:@"yuetan_cnt"] integerValue];
//                 model.sameTradeMessageCnt = 0;
//                 model.friendMessageCnt = 0;
//                 [Manager shareMgr].messageCountDataModal = model;
//                 [self checkNewMessageCount];
//             }
//         }
//     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//         
//     }];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetMessageCtn:
        {
            if (dataArr.count == 0) {
                return;
            }
            [Manager shareMgr].messageCountDataModal = [dataArr objectAtIndex:0];
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"msgNewsNum" object:nil userInfo:@{@"num":@([Manager shareMgr].messageCountDataModal.messageCnt)}];
            
            NSInteger allNum = [Manager shareMgr].messageCountDataModal.companyCnt + [Manager shareMgr].messageCountDataModal.myInterViewCnt + [Manager shareMgr].messageCountDataModal.questionCnt + [Manager shareMgr].messageCountDataModal.resumeCnt;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"myManagerNum" object:nil userInfo:@{@"num":@(allNum),@"oaNum":@([Manager shareMgr].messageCountDataModal.oaMsgCount)}];
        }
            break;
        default:
            break;
    }
}

//设置top 和bottom 的红点
-(void)checkNewMessageCount
{
//    [[Manager shareMgr].tabView_ setTabBarNewMessage];    //设置tabbar消息栏
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
