//
//  ELGroupDetailCtl.h
//  jobClient
//
//  Created by YL1001 on 16/12/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

@protocol ELGroupDetailCtlDelegate <NSObject>

@optional

- (void)refresh;
- (void)joinSuccess;
- (void)quitGroupSuccess;
- (void)updateGroupImgSuccess:(NSString *)img;

@end

@interface ELGroupDetailCtl : ELBaseListCtl

@property (nonatomic, assign) id<ELGroupDetailCtlDelegate> delegate;
@property(nonatomic,assign) BOOL isMine;
@property (nonatomic,assign) BOOL isCompanyGroup;
@property (nonatomic,assign) BOOL isGroupPop;
@property (nonatomic,assign) BOOL isZbar; //表示来自二维码扫描进入，用于返回上上层页面

@property (nonatomic,assign) BOOL isSwipe;//是否默认滑到右边

@property (nonatomic,copy)void (^mblock)();

@end
