//
//  CellFrameModel.h
//  jobClient
//
//  Created by 一览ios on 15/2/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

/**
 *  保存cell以及其子视图的Rect
 */

#import <Foundation/Foundation.h>

@interface CellFrameModel : NSObject

@property(nonatomic,assign) CGRect nameLbRect;
@property(nonatomic,assign) CGRect timeLbRect;
@property(nonatomic,assign) CGRect articleViewRect;
@property(nonatomic,assign) CGRect articleContentLbRect;
@property(nonatomic,assign) CGRect addLikeViewRect;
@property(nonatomic,assign) CGRect commentViewRect;
@property(nonatomic,assign) CGRect showImgViewRect;
@property(nonatomic,assign) CGRect addCommentBtnRect;

@property(nonatomic,assign) CGRect zwLbRect;
@property(nonatomic,assign) CGRect articleTypeLbRect;
@property(nonatomic,assign) CGRect articleOwnLbRect;

@property(nonatomic,assign) CGRect cellRect;

@property(nonatomic,assign) CGRect TitleEmojiLbFrame;

@end
