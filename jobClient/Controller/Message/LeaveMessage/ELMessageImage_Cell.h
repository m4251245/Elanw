//
//  ELMessageImage_Cell.h
//  jobClient
//
//  Created by 一览iOS on 15/9/1.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveMessage_DataModel.h"

@protocol ImageCellDelegate <NSObject>

-(void)hideKeyBord;

@end

@interface ELMessageImage_Cell : UITableViewCell
{
    LeaveMessage_DataModel *inModal;
    MJPhotoBrowser *photoBrowser_;
}

@property (weak,nonatomic) id <ImageCellDelegate> cellDelegate;

@property (strong, nonatomic) UIImageView *titleImage;

@property (strong, nonatomic) UIButton *bgBtnView;
@property (strong, nonatomic) UILabel *dateLb;
@property (strong, nonatomic) UIImageView *contentImage;
@property (nonatomic, strong) UILabel *nameLb;
@property (strong, nonatomic) UIButton *retryBtn;

@property (nonatomic, assign) BOOL isShowNameLb;

-(void)giveDataModal:(LeaveMessage_DataModel *)modal;

@end
