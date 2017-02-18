//
//  New_HeaderBtn.h
//  jobClient
//
//  Created by 一览ios on 16/7/29.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class New_HeaderBtn;
@protocol New_HeaderDelegate <NSObject>

-(void)newHeaderBtnClick:(UITapGestureRecognizer *)sender;

@end

@interface New_HeaderBtn : UIView
@property (weak, nonatomic) IBOutlet UIImageView *titleImg
;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *markImg;

@property (nonatomic, weak) id <New_HeaderDelegate> delegate;

@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title arrCount:(NSInteger)count;

-(void)configImg;

@end
