//
//  FileInfoCtl.h
//  jobClient
//
//  Created by YL1001 on 14-7-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "Article_DataModal.h"
#import "BigImgCtl.h"

@interface FileInfoCtl : BaseUIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView   * scrollView_;
    IBOutlet UILabel        * pagesLb_;
    IBOutlet UILabel        * errorLb_;
    
    Article_DataModal  * inModal_;
    Article_DataModal  * myModal_;
    NSMutableArray     * imgViewArr_;
    
    BigImgCtl          * bigImgCtl_;
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
}

@end
