//
//  NoDataOkCtl.h
//  Template
//
//  Created by sysweal on 13-9-29.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/***************************
 
 NoDataOkCtl
 
 ***************************/

#import <UIKit/UIKit.h>
#import "Common.h"

//#define NoDataOkCtl_Xib_Name            @"NoDataOkCtl"

@interface NoDataOkCtl : UIViewController
{
    
}

@property (nonatomic, weak) IBOutlet  UILabel *txtLb_;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopSpace;


@end
