//
//  ELGroupTypeChangeView.h
//  jobClient
//
//  Created by 一览iOS on 16/7/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELGroupListTypeCountModel;

typedef void(^buttonSelectBlock)(ELGroupListTypeCountModel *dataModal);

@interface ELGroupTypeChangeView : UIView

@property (nonatomic,strong) NSMutableArray *buttonNameArr;
@property (nonatomic,copy) buttonSelectBlock selectBlock;
@property (nonatomic,assign) CGFloat viewHeight;

@end
