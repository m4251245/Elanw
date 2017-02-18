//
//  RequestResumeCompleteCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-24.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "RequestResumeCompleteCtl.h"
@interface RequestResumeCompleteCtl ()

@end

@implementation RequestResumeCompleteCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getResumeComplete:[Manager getUserInfo].userId_];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetResumeComplete:
        {
            [_delegate GetCompleteSuccess:[dataArr objectAtIndex:0]];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
