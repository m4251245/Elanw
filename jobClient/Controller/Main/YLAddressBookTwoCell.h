//
//  YLAddressBookTwoCell.h
//  jobClient
//
//  Created by 一览iOS on 15/6/18.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLAddressBookTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
