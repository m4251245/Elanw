//
//  ElanIntroduceCtl.m
//  Association
//
//  Created by YL1001 on 14-6-18.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ElanIntroduceCtl.h"

@interface ElanIntroduceCtl ()

@end

@implementation ElanIntroduceCtl

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
//    self.navigationItem.title = @"一览介绍";
    [self setNavTitle:@"一览介绍"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
