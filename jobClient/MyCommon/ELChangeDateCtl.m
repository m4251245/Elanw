//
//  ELChangeDateCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELChangeDateCtl.h"

@interface ELChangeDateCtl ()
{
    
    __weak IBOutlet UIView *backView;
    
    __weak IBOutlet UIButton *cancelBtn;
    
    __weak IBOutlet UIButton *finishBtn;
    __weak IBOutlet UIButton *todayBtn;
    __weak IBOutlet UIDatePicker *_datePicker;
    BOOL isShow;
    
    __weak IBOutlet UIView *dateBackView;
}
@end

@implementation ELChangeDateCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_pickerMode > 0) {
        _datePicker.datePickerMode = _pickerMode;
    }else{
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    if (_showMinDate) {
        _datePicker.minimumDate = [NSDate date];
    }else{
        _datePicker.maximumDate = [NSDate date];
    }
    
    cancelBtn.clipsToBounds = YES;
    cancelBtn.layer.cornerRadius = 3.0;
    
    finishBtn.clipsToBounds = YES;
    finishBtn.layer.cornerRadius = 3.0;
    
    todayBtn.clipsToBounds = YES;
    todayBtn.layer.cornerRadius = 3.0;
    
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewCtl)]];
    
//    dateBackView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height - dateBackView.frame.size.height,320,215);
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (IBAction)btnRespone:(UIButton *)sender
{
    if (sender == todayBtn)
    {
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        dataModal.changeDate = [_datePicker date];
        dataModal.pId_ = @"至今";
        if (_changeDateBlock) {
            _changeDateBlock(dataModal);
        }
    }
    else if (sender == finishBtn)
    {
        CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
        NSString *dateStr = [PreCommon getDateStr:[_datePicker date]];
        dataModal.changeDate = [_datePicker date];
        if (dateStr.length > 7)
        {
            dataModal.str_ = [NSString stringWithFormat:@"%@年-%@月",[dateStr substringWithRange:NSMakeRange(0,4)],[dateStr substringWithRange:NSMakeRange(5,2)]];
            dataModal.id_ = dataModal.str_;
            dataModal.pId_ = [NSString stringWithFormat:@"%@-%@",[dateStr substringWithRange:NSMakeRange(0,4)],[dateStr substringWithRange:NSMakeRange(5,2)]];
            if ([[_datePicker date] isEqualToDate:[[NSDate date] laterDate:[_datePicker date]]])
            {
                dataModal.isFutureTime = YES;
            }
            dataModal.oldString = dateStr;
        }
        if (_changeDateBlock) {
            _changeDateBlock(dataModal);
        }
    }
    [self hideViewCtl];
}

-(void)showViewCtlCurrentDate:(NSDate *)date WithBolck:(changeDateCtlBlock)block
{
    if (isShow)
    {
        return;
    }
    _changeDateBlock = block;
    
    CGRect frame = self.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = frame;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
    NSLog(@"%lf",self.view.frame.size.width);
    CGRect frameOne = self.view.frame;
    frameOne.origin.y = 0;
    [UIView animateWithDuration:0.2 animations:^
    {
        self.view.frame = frameOne;
    }];
    
    isShow = YES;
    if (_showTodayBtn)
    {
        todayBtn.hidden = NO;
    }
    else
    {
        todayBtn.hidden = YES;
    }
    if (date)
    {
        _datePicker.date = date;
    }
    else
    {
        _datePicker.date = [NSDate date];
    }
}

-(void)hideViewCtl
{
    [self.view removeFromSuperview];
    isShow = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
