//
//  BigImgCtl.h
//  jobClient
//
//  Created by YL1001 on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"

@interface BigImgCtl : BaseUIViewController
{
    IBOutlet UIScrollView  * scrollView_;
    IBOutlet UIImageView   * imgView_;
    IBOutlet UIButton      * backBtn_;
    
    
    NSString               * imgUrl_;
    NSString               * wh_;
    
    float                    height_;
    float                    width_;
    
}

@end
