//
//  ErrorLoadCtl.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-11-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/***************************
 
 ErrorLoadCtl Class
 
 ***************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//#define ErrorLoadCtl_Xib_Name           @"ErrorLoadCtl"

@interface ErrorLoadCtl : UIViewController {
    IBOutlet    UILabel                 *textLb_;
}

@property(nonatomic,retain) UILabel                 *textLb_;

@end
