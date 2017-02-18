//
//  ELToolTipJobCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnResponeBlock)(NSInteger type);

@interface ELToolTipJobCtl :UIViewController

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property(nonatomic,copy) btnResponeBlock btnBlock;

@property(nonatomic,assign) BOOL isShow;

/*
    stringOne为第一行内容，stringTwo为第二行内容  传空则不显示，最少为一行
    block返回值1为取消  2为确认
 */
-(void)showViewCtlWithAttStringOne:(NSMutableAttributedString *)stringOne attStringTwo:(NSMutableAttributedString *)stringTwo btnRespone:(btnResponeBlock)block;

/*
    block返回值3为停止  4为删除
 */
-(void)showDeleteAndStopViewCtlBtnRespone:(btnResponeBlock)block;

-(void)hideViewCtl;

-(void)showViewCtl;

@end
