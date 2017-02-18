//
//  ModalViewController.h
//  Association
//
//  Created by 一览iOS on 14-2-17.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ModalViewController : UIViewController
{
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
}

@property(nonatomic,weak) IBOutlet UIImageView * imageView_;

//自己视图的单击事件
-(void) viewSingleTap:(id)sender;
@end
