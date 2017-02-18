//
//  CommentImageListView.h
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//评论底部图片的列表

#import <UIKit/UIKit.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


//评论缩略图宽高
//#define COMMENT_IMAGE_WIDTH 80
//#define COMMENT_IMAGE_HEIGHT 80
//
//#define COMMENT_IMAGE_MARGIN 10

static double COMMENT_IMAGE_WIDTH = 80;
static double COMMENT_IMAGE_HEIGHT = 80;
static double COMMENT_IMAGE_MARGIN = 10;

@interface CommentImageListView : UIView<UIGestureRecognizerDelegate, MJPhotoBrowserDelegate>

//缩略图
@property (nonatomic, strong) NSArray *imageUrls;
//大图
@property (nonatomic, strong) NSArray *bigImageUrls;

- (void)photoBrowserHide:(MJPhotoBrowser *)photoBrowser;

//计算总高度
+ (CGSize)imageSizeWithCount:(NSInteger)count;

@end
