//
//  AboutUsCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-20.
//  Copyright (c) 2014年 job1001. All rights reserved.
//
#import "AboutUsCtl.h"
#import "ELVersionIterationRecordCtl.h"


@interface AboutUsCtl ()

@end

@implementation AboutUsCtl
@synthesize weblinkBtn_,introBtn_,agreementBtn_;

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

    [self setNavTitle:@"关于我们"];
    NSString *version = Version_Show;
    version = [version stringByReplacingOccurrencesOfString:@"v" withString:@"V "];
    _versonLb.text = [NSString stringWithFormat:@"%@ 版本", version];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnResponse:(id)sender
{
    if (sender == weblinkBtn_) {
        WebLinkCtl *webLink = [[WebLinkCtl alloc] init];
        [self.navigationController pushViewController:webLink animated:YES];
        [webLink beginLoad:Nil exParam:Nil];
    }
    if (sender == introBtn_) {
        ELVersionIterationRecordCtl *iterationCtl = [[ELVersionIterationRecordCtl alloc] init];
        [self.navigationController pushViewController:iterationCtl animated:YES];
        [iterationCtl beginLoad:nil exParam:nil];
    }
    if (sender == agreementBtn_) {
        AgreementCtl *agreementCtl = [[AgreementCtl alloc] init];
        [self.navigationController pushViewController:agreementCtl animated:YES];
    }
}

-(void)introDidFinish
{
    self.navigationController.navigationBar.alpha = 1.0;
}

@end
