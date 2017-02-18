//
//  Login_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//登录状态
typedef enum
{
    LoginFail,
    LoginOK,
}LoginState;

@interface Login_DataModal : NSObject {
    LoginState                  loginState_;            //登录状态
    
    NSString                    *msg_;                  //msg
    NSString                    *status_;               //登录成功时status="OK"
    NSString                    *personId_;             //personID
    NSString                    *iname_;                //中文名称?(eg.张先生)
    NSString                    *uname_;                //名称
    NSString                    *prnd_;                 //随机码
    NSString                    *tradeId_;              //行业id
    NSString                    *totalId_;              //总网id
    NSString                    *pwd_;                  //pwd
    
    NSString                    *pic_;                  //图标
    NSString                    *school_;               //学校
    NSString                    *majorCatId_;           //专业分类id
    NSString                    *majorStr_;             //专业名称
    NSString                    *sex_;                  //性别
    
    NSString                    *updateTime_;           //更新时间
    
    NSDate                      *createDate_;           //创建时间,用于判断有效期
}

@property(nonatomic,assign) LoginState                  loginState_;
@property(nonatomic,retain) NSString                    *msg_;
@property(nonatomic,retain) NSString                    *status_;
@property(nonatomic,retain) NSString                    *personId_;
@property(nonatomic,retain) NSString                    *iname_;
@property(nonatomic,retain) NSString                    *uname_;
@property(nonatomic,retain) NSString                    *prnd_;
@property(nonatomic,retain) NSString                    *tradeId_;
@property(nonatomic,retain) NSString                    *totalId_;
@property(nonatomic,retain) NSString                    *pwd_;
@property(nonatomic,retain) NSString                    *pic_;
@property(nonatomic,retain) NSString                    *school_;
@property(nonatomic,retain) NSString                    *majorCatId_;
@property(nonatomic,retain) NSString                    *majorStr_;
@property(nonatomic,retain) NSString                    *sex_;
@property(nonatomic,retain) NSString                    *updateTime_;
@property(nonatomic,retain) NSDate                      *createDate_;

@end
