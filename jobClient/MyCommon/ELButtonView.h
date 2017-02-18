//
//  ELButtonView.h
//  ceshi
//
//  Created by 一览iOS on 16/11/11.
//  Copyright © 2016年 client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextSpecial.h"

@protocol ClickDelegate <NSObject>

@optional
-(void)clickDelegateWithModel:(TextSpecial *)model;
-(void)linkDelegateBtnRespone:(TextSpecial *)model;

@end

@interface ELButtonView : UIView

@property (nonatomic,weak) id <ClickDelegate> clickDelegate;
@property (nonatomic,strong) NSMutableAttributedString *AttributedText;
@property (nonatomic,assign) NSInteger numberlines;
@property (nonatomic,strong) UIColor *contentColor;
@property (nonatomic,strong) UIFont *contentFont;

/*
    showline与linkCanClick都设置为YES,可实现链接变色可点击
    点击事件需事先ClickDelegate代理方法linkDelegateBtnRespone
 */
@property (nonatomic,assign) BOOL showLink; //是否展示链接
@property (nonatomic,assign) BOOL linkCanClick; //链接是否可点击
@property (nonatomic,strong) UIColor *linkColor; //链接颜色
@property (nonatomic,strong) UIColor *selectLinkBackColor;//点击链接时的背景色

-(void)refreshClickWithArr:(NSArray <TextSpecial *>*)arr;

-(instancetype)initWithTwoTypeFrame:(CGRect)frame;
-(void)layoutFrame;

@end


