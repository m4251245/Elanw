//
//  DateTimeCtl.m
//  MBA
//
//  Created by sysweal on 13-12-15.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "DateTimeCtl.h"

@interface DateTimeCtl ()

@end

@implementation DateTimeCtl

@synthesize datePicker_,setBtn_,cancelBtn_,delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.preferredContentSize = CGSizeMake(310, 203);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) btnResponse:(id)sender
{
    if( sender == setBtn_ ){
        NSString *format = @"yyyy-MM-dd HH:mm";
        if( datePicker_.datePickerMode == UIDatePickerModeDate ){
            format = @"yyyy-MM-dd";
        }
        [delegate_ dateTimeChoosed:self datetime:[MyCommon getDateStr:datePicker_.date format:format]];
    }else if( sender == cancelBtn_ ){
        [delegate_ dateTimeCance:self];
    }
}

@end
