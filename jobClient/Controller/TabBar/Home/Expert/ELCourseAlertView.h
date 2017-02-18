//
//  ELCourseAlertView.h
//  jobClient
//
//  Created by 一览iOS on 16/12/14.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELCourseAlertDelegate <NSObject>
    
-(void)delegateRightBtnClick;

@end

@interface ELCourseAlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (nonatomic,weak) id <ELCourseAlertDelegate> alertDelegate;

-(instancetype)initWithTitle:(NSString *)title;
-(void)showView;

@end
