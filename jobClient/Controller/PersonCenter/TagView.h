//
//  TagView.h
//  jobClient
//
//  Created by 一览ios on 15/2/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class personTagModel;

typedef void(^TagClickBlock)(personTagModel* tagModel);

@interface TagView : UIScrollView

@property(strong, nonatomic) NSArray *tagArray;

@property (strong, nonatomic) TagClickBlock clickBlock;

@end
