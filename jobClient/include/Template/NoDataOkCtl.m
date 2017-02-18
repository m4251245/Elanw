//
//  NoDataOkCtl.m
//  Template
//
//  Created by sysweal on 13-9-29.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

#import "NoDataOkCtl.h"

@interface NoDataOkCtl ()
{
    
}

@end

@implementation NoDataOkCtl
@synthesize txtLb_;
-(id) init
{
    if (self = [super init]) {
        self = [self initWithNibName:@"NoDataOkCtl" bundle:nil];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


@end
