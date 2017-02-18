//
//  ELArticleHeaderView.h
//  jobClient
//
//  Created by 一览iOS on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELArticleDetailModel.h"
#import "Expert_DataModal.h"
#import "ArticleDetailCtl.h"

@interface ELArticleHeaderView : UIView

@property (nonatomic,assign) BOOL isFromNews;
@property (nonatomic,assign) CGFloat viewHeight;
@property (nonatomic,weak) ArticleDetailCtl *articleDetailCtl;
@property (nonatomic,copy) NSString *articleId;
@property (nonatomic,assign) BOOL haveComment;

-(void)setMyModal:(ELArticleDetailModel *)myModal;

-(void)attentionSuccessRefresh:(BOOL)isSuccess;

-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl;

-(void)loadDataWithIsFromNews:(BOOL)isNew;

@end
