//
//  ConsultantContactCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ConsultantContactCtl.h"
#import "ConsultantContactList.h"
#import "ConsultantHRDataModel.h"

@interface ConsultantContactCtl ()
{
    ConsultantContactList    *messageList;
    ConsultantContactList    *phoneList;
    NSString                *type;   //0私信   5 电话
    ConsultantHRDataModel   *inModel;
}

@end

@implementation ConsultantContactCtl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"联系记录";
    [self setNavTitle:@"联系记录"];
    messageList = [[ConsultantContactList alloc] init];
    [messageList beginLoad:inModel exParam:@"5"];
    [self.view addSubview:messageList.view];
    [self addChildViewController:messageList];
    /*
    phoneList = [[ConsultantContactList alloc] init];
    [phoneList beginLoad:inModel exParam:@"0"];
    CGRect frame = scroview.frame;
    frame.size.width = ScreenWidth;
    scroview.frame = frame;
    [scroview setContentSize:CGSizeMake(ScreenWidth *2, 0)];
    [scroview addSubview:messageList.view];
    [self addChildViewController:messageList];
    [scroview addSubview:phoneList.view];
    [self addChildViewController:phoneList];
    [messageList.view setFrame:scroview.bounds];
    [phoneList.view setFrame:scroview.bounds];
    CGRect rect = phoneList.view.frame;
    rect.origin.x = scroview.bounds.size.width;
    [phoneList.view setFrame:rect];
    
    [_leftBtn setTitleColor:[UIColor colorWithRed:223.0/255.0 green:61.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    */
    // Do any additional setup after loading the view from its nib.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel = dataModal;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)btnResponse:(id)sender
{
    if (sender == _leftBtn || sender == _rightBtn) {
        [self changBtnStauts:sender];
    }
}
- (void)changBtnStauts:(id)sender
{
    UIButton *button = sender;
    if (button == _leftBtn) {
        [_leftBtn setTitleColor:[UIColor colorWithRed:223.0/255.0 green:61.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [scroview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (button == _rightBtn)
    {
        [_rightBtn setTitleColor:[UIColor colorWithRed:223.0/255.0 green:61.0/255.0 blue:65.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [scroview setContentOffset:CGPointMake(scroview.frame.size.width, 0) animated:YES];
    }
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
