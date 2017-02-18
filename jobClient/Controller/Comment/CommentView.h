//
//  CommentView.h
//  Association
//
//  Created by 一览iOS on 14-1-26.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView


@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *nameLb_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *dateLb_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *contentLb_;
@property(nonatomic,unsafe_unretained) IBOutlet UILabel             *indexLb_;



//设置属性
-(void) setAtt;
@end
