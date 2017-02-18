//
//  ELInterviewListCell.h
//  jobClient
//
//  Created by YL1001 on 15/11/26.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELAspectantDiscuss_Modal.h"


@interface ELInterviewListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *contentBgView;
@property (strong, nonatomic) IBOutlet UIView *timeBgView;
@property (strong, nonatomic) IBOutlet UILabel *TimeLb;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UIImageView *personImg;
@property (strong, nonatomic) IBOutlet UILabel *infoLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personImgleading;

- (void)giveDataModel:(ELAspectantDiscuss_Modal *)dataModal;




@end
