//
//  Op_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 初始化接口DataModal
 ****************************************/

#import <Foundation/Foundation.h>


@interface Op_DataModal : NSObject {
    NSString                *sercet_;       //加密值
    NSString                *access_token_; //token值
    
    NSString                *serviceAddress_;//服务器地址
}

@property(nonatomic,retain) NSString                *sercet_;
@property(nonatomic,retain) NSString                *access_token_;
@property(nonatomic,retain) NSString                *serviceAddress_;

@end