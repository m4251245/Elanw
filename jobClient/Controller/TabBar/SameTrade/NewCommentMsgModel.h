//
//  NewCommentMsgModel.h
//  jobClient
//
//  Created by 一览iOS on 14-10-28.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface NewCommentMsgModel : PageInfo

@property(nonatomic,strong) NSString *articleTitle_;
@property(nonatomic,strong) NSString *name_;
@property(nonatomic,strong) NSString *commentPhoto_;
@property(nonatomic,strong) NSString *commentcontent_;
@property(nonatomic,strong) NSString *totalCount_;
@property(nonatomic,strong) NSString *isVisit_;
@property(nonatomic,strong) NSString *createTime_;
@property(nonatomic,strong) NSString *articleId_;

@end
