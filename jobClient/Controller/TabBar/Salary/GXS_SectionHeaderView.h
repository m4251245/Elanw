//
//  GXS_SectionHeaderView.h
//  jobClient
//
//  Created by YL1001 on 14-9-29.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface GXS_SectionHeaderView : UIView

@property(nonatomic,weak) IBOutlet UIView   * contentView_;
@property(nonatomic,weak) IBOutlet GCPlaceholderTextView * textView_;
@property(nonatomic,weak) IBOutlet UIButton * moreBtn_;
@property(nonatomic,weak) IBOutlet UIButton * publishBtn_;
@property(nonatomic,weak) IBOutlet UITextField * nickNameTF_;
@property(nonatomic,weak) IBOutlet UILabel  * titleLb_;

@end
