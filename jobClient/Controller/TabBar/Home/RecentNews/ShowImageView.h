//
//  ShowImageView.h
//  jobClient
//
//  Created by 一览ios on 15-1-23.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJPhotoBrowser.h"

typedef void(^imageClickBlock)();

@interface ShowImageView : UIView<MJPhotoBrowserDelegate>
{
    NSMutableArray      *imageArray_;
}

- (void)returnShowImageSizeWith:(NSArray *)imageArray;
- (void)returnShowImageViewWith:(NSArray *)imageArray;
@property (nonatomic,copy) imageClickBlock imageClickBlock;
@property(nonatomic,assign) BOOL noBtnClick;

@end
