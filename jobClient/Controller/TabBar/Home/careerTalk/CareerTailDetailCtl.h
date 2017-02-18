//
//  CareerTailDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-7-9.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
@class NewCareerTalkDataModal;
@interface CareerTailDetailCtl :BaseListCtl<UIWebViewDelegate>
{
    IBOutlet    UILabel     *titleLb_;
    IBOutlet    UILabel     *timeLb_;
    IBOutlet    UILabel     *addLb_;
    IBOutlet    UILabel     *companyName;
    IBOutlet    UIView      *timeAndAddView_;
    IBOutlet    UIView      *headView_;
    
    IBOutlet UIView *companyView;
    
    NewCareerTalkDataModal *inModal_;      //传进来的值
    float cellHeight_;
    BOOL isReadData_;
    RequestCon *shareLogsCon_;
    IBOutlet UIButton    *attenBtn_;
    IBOutlet UIButton    *companyBtn;
    RequestCon          *attendCon_;
    BOOL                isFollow_;
}

@property (nonatomic,assign) BOOL isPop;

@end
