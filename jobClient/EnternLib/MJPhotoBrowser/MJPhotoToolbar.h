//
//  MJPhotoToolbar.h
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCon.h"

@protocol MJPhotoToolbarDelegate <NSObject>

@optional
//返回要删除的图片index
- (void)personCenterDelegatePhoto:(NSString *)index;

- (void)resumeDelegatePhoto:(NSString *)index;

- (void)simplifyResumeDelegatePhoto:(NSString *)index;

@end

@interface MJPhotoToolbar : UIView<LoadDataDelegate>
{
    RequestCon          *likeCon_;
   
}

// 所有的图片对象
@property (nonatomic, strong) NSMutableArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic,assign) id <MJPhotoToolbarDelegate> delegate_;

@property (nonatomic,assign) NSUInteger toolbarType_;

@property (nonatomic,strong) NSString   *type;

@property (nonatomic,assign) BOOL       isMyCenter;

@end
