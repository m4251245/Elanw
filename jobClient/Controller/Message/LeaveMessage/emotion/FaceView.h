//
// 
//  jobClient
//
//  Created by 一览ios on 14/12/8.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//  表情

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *);

@interface FaceView : UIView {
 @private
    NSMutableArray *items;
}

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *selectedFaceName; //记下选中表情的名称
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, copy) SelectBlock block;
@end
