//
//  CommentImageListView.m
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//评论的图片

#import "CommentImageListView.h"

@interface CommentImageListView()
{
    UIImageView *_bigPicImgv;
    MJPhotoBrowser  *_photoBrowser;

}
@end

@implementation CommentImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //总共最多9张图片
        for (int i = 0; i<9; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlbumn:)];
            gesture.delegate = self;
            //imageview默认用户不能点击
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:gesture];
            imageView.tag = 200 + i;
            [self addSubview:imageView];
        }
        return self;
    }
    return nil;
}

-(instancetype)init{
    self = [self initWithFrame:CGRectZero];
    if (self){
        
    }
    return self;
}
#pragma mark 点击查看大图
- (void)tapGesture:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag - 200;
    NSString *bigPicUrl = _bigImageUrls[index];
    if(!bigPicUrl || [bigPicUrl isEqualToString:@""]){
        return;
    }
    if (_bigPicImgv == nil) {
        _bigPicImgv = [[UIImageView alloc]init];
        _bigPicImgv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _bigPicImgv.backgroundColor = [UIColor blackColor];
        _bigPicImgv.userInteractionEnabled = YES;
        _bigPicImgv.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleBigPic:)];
        [_bigPicImgv addGestureRecognizer:gesture];
    }
    //未添加到视图中
    if (!_bigPicImgv.superview) {
        
        [_bigPicImgv sd_setImageWithURL:[NSURL URLWithString:bigPicUrl] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        [[UIApplication sharedApplication].keyWindow addSubview:_bigPicImgv];
        CGPoint point = [sender locationInView:nil];
        _bigPicImgv.frame = CGRectMake(point.x, point.y, 20, 20);
        [UIView animateWithDuration:.4 animations:^{
            _bigPicImgv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        }];
    }
}

#pragma mark 点击缩小
- (void)scaleBigPic:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    [view removeFromSuperview];
}

#pragma mark
//- (void)show:(NSString *)imageURL
//{
//    if (_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc]init];
//        _scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//        _scrollView.backgroundColor = [UIColor blackColor];
//        _scrollView.userInteractionEnabled = YES;
////        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleBigPic:)];
////        [_bigPicImgv addGestureRecognizer:gesture];
//    }
//

#pragma mark
- (void)showAlbumn:(UITapGestureRecognizer *)sender
{
    _photoBrowser = [[MJPhotoBrowser alloc] init];
    _photoBrowser.isposition_ = YES;
    _photoBrowser.delegate = self;
    NSMutableArray *photos = [NSMutableArray array];
    for (int i=0; i<_imageUrls.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_imageUrls[i]]; // 图片路径
        [photos addObject:photo];
    }
    _photoBrowser.photos = photos; // 设置所有的图片
    NSInteger indexInt = sender.view.tag - 200;
    _photoBrowser.currentPhotoIndex = indexInt; // 弹出相册时显示的第一张图片是？
    [_photoBrowser show];
}



- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    NSInteger imageCount = imageUrls. count;
    NSInteger subCount = self.subviews.count;
    // 遍历所有的ImageView
    for (int i = 0; i<subCount;  i++) {
        // 1.取出i位置对应的图片控件
        UIImageView *child = self.subviews[i];
        // 2.i位置对应的图片控件 没有 图片
        if (i >= imageCount) {
            child.hidden = YES;
        } else {
            child.hidden = NO;
            // 只有一张图
            if (imageCount == 1) {
                child.frame = CGRectMake(0, 0, COMMENT_IMAGE_WIDTH, COMMENT_IMAGE_HEIGHT);
                child.contentMode = UIViewContentModeScaleAspectFit;
            } else {
                // 3.设置frame
                int divide = (imageCount == 4) ? 2 : 3;
                // 列数
                int column = i%divide;
                // 行数
                int row = i/divide;
                // 很据列数和行数算出x、y
                int childX = column * (COMMENT_IMAGE_WIDTH + COMMENT_IMAGE_MARGIN);
                int childY = row * (COMMENT_IMAGE_HEIGHT + COMMENT_IMAGE_MARGIN);
                child.frame = CGRectMake(childX, childY, COMMENT_IMAGE_WIDTH, COMMENT_IMAGE_HEIGHT);
                child.contentMode = UIViewContentModeScaleToFill;
            }
            // 4.设置图片url
            
            [child sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]] placeholderImage:[UIImage imageNamed:@"noPic.png"] options:SDWebImageAllowInvalidSSLCertificates];
        }
    }

}

#pragma mark 计算图片的总高度
+ (CGSize)imageSizeWithCount:(NSInteger)count
{
    if (count == 1) return CGSizeMake(COMMENT_IMAGE_WIDTH, COMMENT_IMAGE_HEIGHT);
    // 1.总行数
    NSInteger rows = (count + 2)/3;
    // 2.总高度
    CGFloat height = rows * COMMENT_IMAGE_HEIGHT + (rows - 1) * COMMENT_IMAGE_MARGIN;
    // 3.总列数
    NSInteger columns = (count>=3) ? 3 : count;
    // 4.总宽度
    CGFloat width = columns * COMMENT_IMAGE_WIDTH + (columns - 1) * COMMENT_IMAGE_MARGIN;
    return CGSizeMake(width, height);
}

- (void)photoBrowserHide:(MJPhotoBrowser *)photoBrowser
{
    
}
@end
