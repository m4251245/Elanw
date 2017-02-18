//
//  PersonQRCodeCtl.h
//  jobClient
//
//  Created by 一览ios on 15/8/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "User_DataModal.h"

@interface PersonQRCodeCtl : BaseUIViewController

@property (weak,nonatomic)  IBOutlet   UIView *contentView;    /**<需要显示的View*/
@property (weak, nonatomic) IBOutlet UIImageView *photoImgv;   /**<头像*/
@property (weak, nonatomic) IBOutlet UIImageView *qrImgv;   /**<二维码图片*/
@property (weak, nonatomic) IBOutlet UILabel     *nameLb;   /**<名字*/
@property (weak, nonatomic) IBOutlet UILabel     *descLb;   /**<职业/头衔*/
@property (weak, nonatomic) IBOutlet UIButton    *saveBtn;   /**<保存二维码*/
@property (weak, nonatomic) IBOutlet UIButton    *dissMissBtn;  /**<viewdiss*/
@property (weak, nonatomic) IBOutlet UIImageView    *photoImgv2;  /**<viewdiss*/
@property (weak, nonatomic) IBOutlet UIImageView    *tapImgv;  /**<viewdiss*/

-(void)show;
- (void)dismiss;
-(instancetype)initWithDataModal:(User_DataModal *)dataModel;

@end
