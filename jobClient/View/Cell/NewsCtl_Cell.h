//
//  NewsCtl_Cell.h
//  Association
//
//  Created by 一览iOS on 14-1-8.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article_DataModal.h"

@interface NewsCtl_Cell : UITableViewCell


@property(nonatomic,weak) IBOutlet UIImageView * imageView_;
@property(nonatomic,weak) IBOutlet UILabel * titleLb_;
@property(nonatomic,weak) IBOutlet UILabel * descLb_;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property(nonatomic,strong) Article_DataModal *dataModalOne;

@end
