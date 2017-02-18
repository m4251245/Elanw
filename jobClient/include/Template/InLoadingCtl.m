//
//  InLoadingCtl.m
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "InLoadingCtl.h"

@interface InLoadingCtl ()

@end

@implementation InLoadingCtl

@synthesize txtLb_;

-(id) init
{
    self = [self initWithNibName:@"InLoadingCtl" bundle:nil];
    
    
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
	// Do any additional setup after loading the view.
    
    //设置圆角
    CALayer *layer=[self.view layer];
    [layer setMasksToBounds:YES];
    //[layer setBorderWidth:1.0];
    [layer setCornerRadius:6.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
