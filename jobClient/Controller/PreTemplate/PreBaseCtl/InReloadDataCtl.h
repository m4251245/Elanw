//
//  InReloadDataCtl.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-4.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define InReloadDataCtl_Xib_Name            @"InReloadDataCtl"

@interface InReloadDataCtl : UIViewController{
    IBOutlet    UILabel                     *textLb_;
}

@property(nonatomic,retain) UILabel         *textLb_;

@end
