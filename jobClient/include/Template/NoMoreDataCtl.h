//
//  NoMoreDataCtl.h
//  Template
//
//  Created by sysweal on 13-9-26.
//  Copyright (c) 2013年 sysweal. All rights reserved.
//

/***************************
 
 NoMoreDataCtl
 
 ***************************/

#import <UIKit/UIKit.h>
#import "Common.h"

#define NoMoreDataCtl_Xib_Name          @"NoMoreDataCtl"

@interface NoMoreDataCtl : UIViewController
{
    IBOutlet    UIImageView             *imageView_;
//    IBOutlet    UILabel                 *txtLb_;
}
@property (strong, nonatomic) IBOutlet UILabel *txtLb_;

@end
