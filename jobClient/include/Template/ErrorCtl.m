//
//  ErrorCtl.m
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "ErrorCtl.h"

//默认的图标名称
static NSString    *defaultIcoName = NULL;

@interface ErrorCtl ()

@end

@implementation ErrorCtl

@synthesize delegate_,clickBtn_,txtLb_;

-(id) init
{
    self = [self initWithNibName:@"ErrorCtl" bundle:nil];
    
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
    
    if( defaultIcoName == NULL ){
        defaultIcoName = [CommonConfig getValueByKey:@"ErrorCtl_ImageView_Ico" category:@"Resources"];
    }
    
    if( defaultIcoName && ![defaultIcoName isEqualToString:@""] ){
        [imageView_ setImage:[UIImage imageNamed:defaultIcoName]];
    }
    
    [clickBtn_ setTitle:@"" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnClick:(id)sender
{
    if( sender == clickBtn_ ){
        [delegate_ reloadData:self sender:sender];
    }
}

@end
