//
//  DateTimeCtl.h
//  MBA
//
//  Created by sysweal on 13-12-15.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"

@class DateTimeCtl;
@protocol DateTimeCtlDelegate <NSObject>

-(void) dateTimeChoosed:(DateTimeCtl *)ctl datetime:(NSString *)datetime;

-(void) dateTimeCance:(DateTimeCtl *)ctl;

@end

@interface DateTimeCtl : BaseUIViewController

@property(nonatomic,weak)   IBOutlet    UIDatePicker    *datePicker_;
@property(nonatomic,weak)   IBOutlet    UIButton        *setBtn_;
@property(nonatomic,weak)   IBOutlet    UIButton        *cancelBtn_;
@property(nonatomic,assign) id<DateTimeCtlDelegate>     delegate_;

@end
