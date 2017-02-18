//
//  ELInterviewPlaceCtl.h
//  jobClient
//
//  Created by YL1001 on 15/10/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELInterviewPlaceCtl : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *timeBtn;      /**<时间Btn */
@property (strong, nonatomic) IBOutlet UIButton *placeBtn;     /**<地点Btn */
@property (strong, nonatomic) IBOutlet UIButton *delectBtn;    /**<删除Btn */
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) NSString *ydrId;                 /**<地点Id */
@property (strong, nonatomic) IBOutlet UILabel *titleLb;

@end
