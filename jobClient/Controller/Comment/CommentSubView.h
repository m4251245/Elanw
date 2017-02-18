//
//  CommentSubView.h
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSubView : UIView

@property(nonatomic,unsafe_unretained) IBOutlet UIView              *contentView_;
@property(nonatomic,unsafe_unretained) IBOutlet UIButton            *imgBtn_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *nameLb_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *dateLb_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *contentLb_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *indexLb_;

//设置属性
-(void) setAtt:(BOOL)border;

@end
