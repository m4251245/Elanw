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

typedef enum : NSUInteger {
    AccessTokenTypeOne=1,
    AccessTokenTypeTwo,
    AccessTokenTypeThree,
    AccessTokenTypeFour
} AccessTokenType;

@interface AccessToken_DataModal : NSObject

@property(nonatomic,strong) NSString    *sercet_;       //密码
@property(nonatomic,strong) NSString    *accessToken_;  //token
//@property(nonatomic,strong) NSDate      *lastDate_;     //最近更新的时间

-(void)saveDataModalWithUserDefaultType:(AccessTokenType)type;
-(void)getDataModalWithUserDefaultType:(AccessTokenType)type;

@end
