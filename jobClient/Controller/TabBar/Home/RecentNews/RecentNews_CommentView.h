//
//  RecentNews_CommentView.h
//  jobClient
//
//  Created by YL1001 on 14-10-18.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributedLabel.h"

@interface RecentNews_CommentView : UIView

@property(nonatomic,weak) IBOutlet  UIImageView      * useImg_;
@property(nonatomic,weak) IBOutlet  UILabel          * contentLb_;
@property(nonatomic,weak) IBOutlet  UILabel          * timeLb_;
@property(nonatomic,assign) int                        labelTag;

@end
