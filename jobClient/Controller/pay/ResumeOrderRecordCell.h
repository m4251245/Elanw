//
//  ResumeOrderRecordCell.h
//  jobClient
//
//  Created by 一览iOS on 15-3-7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderType_DataModal.h"

@interface ResumeOrderRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *workExpreience;

@property (weak, nonatomic) IBOutlet UILabel *ordertype;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;
 
-(void)giveDateWithModal:(OrderType_DataModal *)dataModal;

@end
