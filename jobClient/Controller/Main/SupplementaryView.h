//
//  SupplementaryView.h
//  jobClient
//
//  Created by 一览ios on 15/10/13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonQRCodeCtl.h"
@interface SupplementaryView : UICollectionReusableView<NoLoginDelegate>
{
    PersonQRCodeCtl  *qrCodeCtl;
}
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *qrBtn;
@property (weak, nonatomic) IBOutlet UIImageView *markImv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *zwdescLb;
@property (weak, nonatomic) IBOutlet UIButton *bianzBtn;
@property (weak, nonatomic) IBOutlet UIButton *personCentenBtn;
@property (weak, nonatomic) IBOutlet UIButton *morPhotoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *morphotoImgv;
@property (weak, nonatomic) IBOutlet UIView *morView;

@property (weak, nonatomic) IBOutlet UIView            *voicePlayView_;
@property (weak, nonatomic) IBOutlet UIButton          *voiceBtn_;
@property (weak, nonatomic) IBOutlet UIButton          *voicePlayBtn_;
@property (weak, nonatomic) IBOutlet UILabel           *voiceTimeLb_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbToCenter;

@property (weak, nonatomic) IBOutlet UIImageView *personPhotoImage;

- (void)changFrame;

@end
