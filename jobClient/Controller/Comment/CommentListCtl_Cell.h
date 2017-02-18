//
//  CommentListCtl_Cell.h
//  MBA
//
//  Created by sysweal on 13-11-20.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment_DataModal.h"

@interface CommentListCtl_Cell : UITableViewCell<ClickDelegate>

@property(nonatomic,unsafe_unretained)  IBOutlet    UIButton    *picBtn_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UILabel     *nameLb_;
@property(nonatomic,unsafe_unretained)  IBOutlet    UILabel     *dateLb_;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbRight;

@property(nonatomic,strong) ELButtonView *contentLb;

@property(nonatomic,strong) Comment_DataModal *dataModal;

@end
