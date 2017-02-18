//
//  Experience_SelectionTableViewCell.h
//  jobClient
//
//  Created by 一览ios on 16/8/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExDelegate <NSObject>

-(void)sureBtnClicked:(UIButton *)btn;

@end

@interface Experience_SelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *lowTxt;
@property (weak, nonatomic) IBOutlet UITextField *highTxt;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,assign)id<ExDelegate>delegate;

@end
