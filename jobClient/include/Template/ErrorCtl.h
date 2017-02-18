//
//  ErrorCtl.h
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/***************************
 
        ErrorCtl
 
 ***************************/

#import <UIKit/UIKit.h>
#import "Common.h"

//#define ErrorCtl_Xib_Name           @"ErrorCtl"

@class ErrorCtl;

@protocol ErrorCtlDelegate <NSObject>

@optional
-(void) reloadData:(ErrorCtl *)ctl sender:(id)sender;

@end


@interface ErrorCtl : UIViewController
{
    IBOutlet    UIImageView         *imageView_;
}

@property(nonatomic,assign) id<ErrorCtlDelegate>        delegate_;
@property(nonatomic,weak)   IBOutlet UIButton           *clickBtn_;
@property(nonatomic,weak)   IBOutlet UILabel            *txtLb_;

-(IBAction) btnClick:(id)sender;

@end
