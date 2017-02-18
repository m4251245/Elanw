//
//  Subject_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-22.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "PageInfo.h"

@interface Subject_DataModal : PageInfo

@property(nonatomic,strong) NSString * zasId_;
@property(nonatomic,strong) NSString * zasiId_;
@property(nonatomic,strong) NSString * status_;
@property(nonatomic,strong) NSString * title_;
@property(nonatomic,strong) NSString * addtime_;
@property(nonatomic,strong) NSString * content_;
@property(nonatomic,strong) NSString * pic_;
@property(nonatomic,strong) NSData   * imageData_;
@property(nonatomic,assign) BOOL       bImageLoad_;
@property(nonatomic,strong) NSString * articleId_;
@property(nonatomic,strong) NSString * proId_;
@property(nonatomic,strong) NSString * preface_;
@property(nonatomic,strong) NSString * conclusion_;
@property(nonatomic,strong) NSString * url_;
@property(nonatomic,strong) NSString * viewCnt_;
@property(nonatomic,strong) NSString * commentCnt_;


@end
