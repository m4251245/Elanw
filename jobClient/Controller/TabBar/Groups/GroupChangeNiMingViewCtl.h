//
//  GroupChangeNiMingViewCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-4-23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeNiMingDelegate <NSObject>
@optional
-(void)changeNiMingWithBtnRespone:(UIButton *)sender;

@end

@interface GroupChangeNiMingViewCtl :UIViewController

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *changeView;

@property (weak, nonatomic) IBOutlet UIImageView *sTitleImage;

@property (weak, nonatomic) IBOutlet UILabel *sTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *sChangeImage;

@property (weak, nonatomic) IBOutlet UIImageView *nTitleImage;
@property (weak, nonatomic) IBOutlet UILabel *nTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *nChangeImage;

@property(nonatomic,assign) BOOL isShowView;

@property (weak,nonatomic) id <changeNiMingDelegate> changeNiMingDelegate;

-(void)viewWithShow:(UIImage *)sImage sName:(NSString *)sName nImage:(UIImage *)nImage nName:(NSString *)nName isNiMing:(BOOL)isNiMing;

-(void)viewWithHide;

@end
