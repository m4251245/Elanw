//
//  SelectionTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/8/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionTableViewCell : UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier title:(NSString *)title;
@property(nonatomic,retain)UIButton *selBtn;

@end
