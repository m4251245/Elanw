//
//  New_PhotoSelectionViewController.h
//  jobClient
//
//  Created by 一览ios on 16/8/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@protocol LogoPhotoSelectCtlDelegate <NSObject>

- (void)hadFinishSelectPhoto:(NSArray *)imageArr;

@end

@interface New_PhotoSelectionViewController : BaseUIViewController

@property(nonatomic,assign)id<LogoPhotoSelectCtlDelegate>delegate;

@property (nonatomic,assign) int imageType;

@end
