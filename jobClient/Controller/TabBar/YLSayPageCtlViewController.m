//
//  YLSayPageCtlViewController.m
//  jobClient
//
//  Created by 一览iOS on 15/7/8.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLSayPageCtlViewController.h"

@interface YLSayPageCtlViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation YLSayPageCtlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backView.clipsToBounds = YES;
    self.backView.layer.cornerRadius = 5.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.backGroundView addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    [self.view removeFromSuperview];
}

- (IBAction)btnRespone:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 100:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPDownloadURL]];
        }
            break;
        case 200:
        {
            MessageContact_DataModel * dataModal = [[MessageContact_DataModel alloc] init];
            dataModal.userId = @"15476338";
            dataModal.isExpert = @"1";
            dataModal.userIname = @"一览小助手";
            dataModal.pic = @"http://img105.job1001.com/myUpload2/201503/10/1425978515_391.gif";
            dataModal.gzNum = @"10.0";
            dataModal.userZW = @"产品经理";
            dataModal.age = @"10";
            dataModal.sameCity = @"1";
            dataModal.sex = @"女";
            MessageDailogListCtl *ctl = [[MessageDailogListCtl alloc]init];
            [Manager shareMgr].centerNav_.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
            [ctl beginLoad:dataModal exParam:nil];
            

        }
            break;
        case 300:
            break;
        default:
            break;
    }
    [self.view removeFromSuperview];
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
