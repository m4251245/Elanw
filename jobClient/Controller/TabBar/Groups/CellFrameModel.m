//
//  CellFrameModel.m
//  jobClient
//
//  Created by 一览ios on 15/2/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CellFrameModel.h"

@implementation CellFrameModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameLbRect = CGRectZero;
        _timeLbRect = CGRectZero;
        _articleViewRect = CGRectZero;
        _articleContentLbRect = CGRectZero;
        _addLikeViewRect = CGRectZero;
        _commentViewRect = CGRectZero;
        _showImgViewRect = CGRectZero;
        _addCommentBtnRect = CGRectZero;
        _cellRect = CGRectZero;
    }
    return self;
}
@end
