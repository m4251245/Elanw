//
//  TestProgram_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 测试项目dataModal
 ****************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface TestProgram_DataModal : PageInfo {
    NSString                        *id_;           //主键
    NSString                        *title_;        //标题
    NSString                        *img_;          //图标
    int                             cnt_;          //已经参与测试者数量
    NSString                        *desc_;         //描述

    NSData                          *imageData_;    //图片
}

@property(nonatomic,retain) NSString                        *id_;
@property(nonatomic,retain) NSString                        *title_;
@property(nonatomic,retain) NSString                        *img_;
@property(nonatomic,assign) int                             cnt_;
@property(nonatomic,retain) NSString                        *desc_;
@property(nonatomic,retain) NSData                          *imageData_;

@end
