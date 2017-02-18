//
//  NoGroupdCtl.m
//  jobClient
//
//  Created by YL1001 on 14/11/10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "NoGroupdCtl.h"

@interface NoGroupdCtl ()

@end

@implementation NoGroupdCtl
@synthesize imgView_,btn1_,btn2_,contentLb_;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnResponse:(id)sender
{
    if (sender == btn1_) {
        if (![Manager shareMgr].recGroupsCtl_) {
            [Manager shareMgr].recGroupsCtl_ = [[RecommendGroupsCtl alloc] init];
        }
        [self.navigationController pushViewController:[Manager shareMgr].recGroupsCtl_ animated:YES];
        [[Manager shareMgr].recGroupsCtl_ beginLoad:nil exParam:nil];
    }
    else if (sender == btn2_){
        [Manager shareMgr].groupCreateCtl_ = [[CreaterGroupCtl alloc] init];
         [Manager shareMgr].creatGroupStartIndex = self.navigationController.viewControllers.count;
        [Manager shareMgr].groupCreateCtl_.enterType_ = 1;
        [self.navigationController pushViewController:[Manager shareMgr].groupCreateCtl_ animated:YES];
        [[Manager shareMgr].groupCreateCtl_ beginLoad:nil exParam:nil];

    }
}

@end
