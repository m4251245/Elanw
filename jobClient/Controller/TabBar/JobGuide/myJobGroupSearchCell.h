//
//  myJobGroupSearchCell.h
//  jobClient
//
//  Created by 一览iOS on 15-1-21.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer_DataModal.h"

@interface myJobGroupSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *quseLable;

@property (weak, nonatomic) IBOutlet UILabel *typeLableOne;
@property (weak, nonatomic) IBOutlet UILabel *typeLableTwo;
@property (weak, nonatomic) IBOutlet UILabel *typeLableThree;
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;
@property (weak, nonatomic) IBOutlet UILabel *answeCount;

-(void)giveDataWithModal:(Answer_DataModal *)dataModal;

@end
