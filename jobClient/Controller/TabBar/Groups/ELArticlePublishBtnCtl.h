//
//  ELArticlePublishBtnCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/5/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELArticleDetailModel.h"
#import "Expert_DataModal.h"
#import "ArticleDetailCtl.h"

@interface ELArticlePublishBtnCtl : UIView

@property(nonatomic,assign) BOOL showViewCtl;

-(void)setMyDataModal_:(ELArticleDetailModel *)myDataModal;
-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl;

@end
