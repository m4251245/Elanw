//
//  KeyboardReturnCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-4-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/*******************************
 
        KeyboardCtl
    主要用于隐藏keyboard
 *******************************/


#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"

//#define KeyboardReturnCtl_Xib_Name                  @"KeyboardReturnCtl"

@interface KeyboardReturnCtl : PreBaseUIViewController {
    IBOutlet    UIButton                            *returnBtn_;    //用于让keyboard返回的btn
}

@end


//当前哪个处于键盘焦点状态
extern UIView *currentFocusView;
