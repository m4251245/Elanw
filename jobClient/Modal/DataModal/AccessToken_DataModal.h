//
//  AccessToken_DataModal.h
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 接口token凭证
 AccessToken_DataModal
 
 ******************************/

#import <Foundation/Foundation.h>

@interface AccessToken_DataModal : NSObject

@property(nonatomic,strong) NSString    *sercet_;       //密码
@property(nonatomic,strong) NSString    *accessToken_;  //token

@end
