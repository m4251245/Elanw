//
//  VersionInfo_DataModal.h
//  MBA
//
//  Created by sysweal on 13-12-13.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfo_DataModal : NSObject

@property(nonatomic,strong) NSString    *version_;  //版本号
@property(nonatomic,strong) NSString    *url_;      //下载地址
@property(nonatomic,strong) NSString    *msg_;      //更新的内容
@property(nonatomic,strong) NSString    *level_;

@end
