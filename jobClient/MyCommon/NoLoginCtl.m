//
//  NoLoginCtl.m
//  Association
//
//  Created by 一览iOS on 14-1-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "NoLoginCtl.h"

@interface NoLoginCtl ()

@end

@implementation NoLoginCtl
@synthesize loginBtn_,delegate_;

-(id)init
{
    self = [self initWithNibName:@"NoLoginCtl" bundle:nil];
    
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnclick:(id)sender
{
    [delegate_ showLoginCtl:self];
}

@end
