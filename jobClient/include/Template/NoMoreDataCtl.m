//
//  NoMoreDataCtl.m
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "NoMoreDataCtl.h"
//#import "SameTradeListCtl.h"

//默认的图标
static NSString *defaultIcoName = NULL;

@interface NoMoreDataCtl ()

@end

@implementation NoMoreDataCtl
@synthesize txtLb_;
-(id) init
{
    self = [self initWithNibName:NoMoreDataCtl_Xib_Name bundle:nil];
    
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
        defaultIcoName = [CommonConfig getValueByKey:@"NoMoreDataCtl_ImageView_Ico" category:@"Resources"];
    }
    
    if( defaultIcoName && ![defaultIcoName isEqualToString:@""] ){
        [imageView_ setImage:[UIImage imageNamed:defaultIcoName]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
