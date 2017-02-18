//
//  MyJobGuide_RewardCell.h
//  jobClient
//
//  Created by YL1001 on 16/1/13.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyJobGuide_RewardCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *contentLb;

-(void)setCount:(NSString *)count withContent:(NSString *)content;
+(CGFloat)getCellHeight;

@end
