//
//  YLMessageLikeLeftCell.h
//  jobClient
//
//  Created by 一览iOS on 15/5/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveMessage_DataModel.h"
#import "Article_DataModal.h"
#import "MLEmojiLabel.h"

@interface YLMessageLikeLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *titleImageBtn;

@property (weak, nonatomic) IBOutlet UIButton *cotentImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushArticleBtn;

@property (nonatomic,strong) MLEmojiLabel *titleEmoji;
@property (nonatomic,strong) MLEmojiLabel *contentEmoji;

-(void)giveDataModal:(LeaveMessage_DataModel *)modal;

@end
