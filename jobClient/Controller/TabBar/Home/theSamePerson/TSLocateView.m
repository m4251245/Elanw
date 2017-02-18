//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"
#import "TSLocation.h"
#import "CondictionList_DataModal.h"
#import "Constant.h"
#import "FMDatabase.h"

#define kDuration 0.3

@implementation TSLocateView

@synthesize locatePicker;
@synthesize locate;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        provinces = [[NSMutableArray alloc]init];
        cities = [[NSMutableArray alloc]init];
        if( !regionArr ){
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *pathname = [path lastObject];
            NSString *dbPath = [pathname stringByAppendingPathComponent:@"data.db"];
            FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
            @try {
                if (![db open]) {
                    NSLog(@"Could not open db.");
                }
                NSString *sql = [NSString stringWithFormat:@"select * from region_choosen"];
                FMResultSet *rs = [db executeQuery:sql];
                NSMutableArray *resulArr = [NSMutableArray arrayWithCapacity:533];
                while ([rs next]) {
                    CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
                    model.id_ = [rs stringForColumn:@"selfId"];
                    model.pId_ = [rs stringForColumn:@"parentId"];
                    model.str_ = [rs stringForColumn:@"selfName"];
                    model.bParent_ = [rs boolForColumn:@"level"];
                    [resulArr addObject:model];
                }
                regionArr = resulArr;
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                [db close];
            }
        }
        
        for (CondictionList_DataModal *model in regionArr) {
            if (model.bParent_) {
                [provinces addObject:model];
            }
        }
        
        CondictionList_DataModal *dataModel = [provinces objectAtIndex:0];
        for (CondictionList_DataModal *model in regionArr) {
            if ([dataModel.id_ isEqualToString:model.pId_]) {
                [cities addObject:model];
            }
        }
        //初始化默认数据
        self.locate = [[TSLocation alloc] init];
        CondictionList_DataModal *provinceModel = [provinces objectAtIndex:0];
        CondictionList_DataModal *citieModel = [cities objectAtIndex:0];
        self.locate.state = provinceModel.str_;
        self.locate.city = citieModel.str_;
        self.locate.id_ = citieModel.id_;
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            CondictionList_DataModal *model = [provinces objectAtIndex:row];
            return model.str_;
            break;
            
        }
        case 1:
        {
            CondictionList_DataModal *model = [cities objectAtIndex:row];
            return model.str_;
            break;
        }
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            [cities removeAllObjects];
            CondictionList_DataModal *provinceModel = [provinces objectAtIndex:row];
            for (CondictionList_DataModal *model in regionArr) {
                if ([provinceModel.id_ isEqualToString:model.pId_]) {
                    [cities addObject:model];
                }
            }
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            
            self.locate.state = provinceModel.str_;
            CondictionList_DataModal *model = [cities objectAtIndex:0];
            self.locate.city = model.str_;
            self.locate.id_ = model.id_;
            break;
        }
            
        case 1:
        {
            CondictionList_DataModal *model = [cities objectAtIndex:row];
            self.locate.city = model.str_;
            self.locate.id_ = model.id_;
            break;
        }
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
    
    [[[UIApplication sharedApplication].delegate.window.rootViewController.view viewWithTag:2000] removeFromSuperview];
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    [[[UIApplication sharedApplication].delegate.window.rootViewController.view viewWithTag:2000] removeFromSuperview];
}

@end
