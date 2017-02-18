//
//  ResumeComment_DataModal.h
//  jobClient
//
//  Created by YL1001 on 15/1/27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface ResumeComment_DataModal : PageInfo

@property(nonatomic,strong) NSString * id_;
@property(nonatomic,strong) NSString * labelId_;
@property(nonatomic,strong) NSString * companyId_;
@property(nonatomic,strong) NSString * companyName_;
@property(nonatomic,strong) NSString * updatetime_;
@property(nonatomic,strong) NSString * author_;
@property(nonatomic,strong) NSString * content_;
@property(nonatomic,strong) NSString * personId_;
@property(nonatomic,strong) NSString * cmailId_;

@end
