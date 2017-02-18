//
//  ResumeSercetCtl.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-11-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/******************************
 
        设置简历的保密状态
 
 ******************************/

#import <UIKit/UIKit.h>
#import "PreBaseResultListCtl.h"

#define ResumeSercetCtl_Xib_Name            @"ResumeSercetCtl"
#define ResumeSercetCtl_Title               @"保密设置"

#define ResumeSercetCtl_ValidateSeconds     7*24*3600

@interface ResumeSercetCtl : PreBaseResultListCtl {
    PreRequestCon                                  *updateCon_;
    NSArray                                     *statusArr_;    //状态arr
    
    int                                         currentStatus_; //当前状态
    int                                         selectStatus_;  //选中的状态
}

//重置
-(void) reSetInfo;

@end
