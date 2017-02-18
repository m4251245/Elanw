//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhotoToolbar.h"

typedef void(^myPhotoBlock) (NSString *index);

@protocol MJPhotoBrowserDelegate;


@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate,MJPhotoToolbarDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSMutableArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic, assign) NSUInteger  type_;  //2个人中心   1简历    5简版简历

@property (nonatomic, assign) BOOL          isMyCenter;

@property (nonatomic, assign) BOOL          isposition_;
// 显示
- (void)show;

- (void)setViewHiden;

@property(nonatomic,copy) myPhotoBlock block;

@end

@protocol MJPhotoBrowserDelegate <NSObject>

@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

//已经完成
-(void) photoBrowserHide:(MJPhotoBrowser *)photoBrowser;

//个人中心删除图片成功回调
- (void)personCenterDelegateSuccess:(NSString *)index;

#pragma mark - 完整版简历删除图片
- (void)resumeDelegatePhotoSuccess:(NSString *)index;

#pragma mark - 简版简历删除图片
- (void)simplifyResumeDelegatePhotoSuccess:(NSString *)index;

@end
