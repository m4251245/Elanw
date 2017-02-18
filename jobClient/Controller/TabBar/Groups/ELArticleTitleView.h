//
//  ELArticleTitleView.h
//  jobClient
//
//  Created by 一览iOS on 16/5/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELArticleDetailModel.h"
#import "Expert_DataModal.h"
#import "ArticleDetailCtl.h"

@interface ELArticleTitleView : UIView

@property (nonatomic,weak) ArticleDetailCtl *articleDetailCtl;
@property(nonatomic,assign) CGFloat backBtnHeight;
@property(nonatomic,assign) CGFloat webViewY;
@property(nonatomic,copy) NSString *type_;
@property(nonatomic,assign) BOOL isFromGroup_;

@property(nonatomic,weak) IBOutlet UIView *titleViewThree;
@property (weak, nonatomic) IBOutlet UIView *coverView;


-(instancetype)initWithArticleCtl:(ArticleDetailCtl *)articleCtl;
-(void)setMyDataModal:(ELArticleDetailModel *)modal;

-(void)addFavoriteSueecss:(BOOL)addOrCancel;
-(void)scrollViewWithTitleView:(UIScrollView *)scrollView withHeight:(CGFloat)backViewHeight;
@end
