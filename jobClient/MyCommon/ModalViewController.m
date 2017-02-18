//
//  ModalViewController.m
//  Association
//
//  Created by 一览iOS on 14-2-17.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ModalViewController.h"


@interface ModalViewController ()

@end

@implementation ModalViewController
@synthesize imageView_;

-(id)init
{
    self = [super initWithNibName:@"ModalViewController" bundle:nil];
   
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
     self.view.backgroundColor = [UIColor clearColor];
    
    imageView_.userInteractionEnabled = YES;
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:imageView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewSingleTap:(id)sender
{
    [self.view removeFromSuperview];
    
}

@end
