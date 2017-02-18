//
//  RiceMoney_DataModal.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-8-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/****************************************
 换大米dataModal
 ****************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface RiceMoney_DataModal : PageInfo {
    NSString                        *name_;     //名称
    NSString                        *max_;      //最大值
    NSString                        *min_;      //最小值
    NSString                        *money_;    //量
    NSString                        *per_;      //百分比
    NSString                        *dangwei_;  //单位
    
    NSString                        *imageOnPic_;   //亮pic
    NSString                        *imageOffPic_;  //暗pic
    
    NSData                          *imageData_;
    
    
    NSString                        *number_;   //数字(根据返回来的数据自己再解析出来的)
    NSString                        *des_;      //描述(根据返回来的数据自己再解析出来的)
}

@property(nonatomic,retain) NSString                        *name_;
@property(nonatomic,retain) NSString                        *max_;
@property(nonatomic,retain) NSString                        *min_;
@property(nonatomic,retain) NSString                        *money_;
@property(nonatomic,retain) NSString                        *per_;
@property(nonatomic,retain) NSString                        *dangwei_;
@property(nonatomic,retain) NSString                        *imageOnPic_;
@property(nonatomic,retain) NSString                        *imageOffPic_;
@property(nonatomic,retain) NSData                          *imageData_;
@property(nonatomic,retain) NSString                        *number_;
@property(nonatomic,retain) NSString                        *des_;

@end
