//
//  ProfessionPower_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

/********************************************
 职业的力量与力量详情数据模块
 ********************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface ProfessionPower_DataModal : PageInfo {
	NSString                *newsID_;                                   //期号的id
	NSString                *newsTitle_;                                //title
	NSString                *newsCount_;                                //第几期
	NSString                *newsDate_;                                 //date
	NSString                *imagePath_;                                //图片的path
	
    NSString                *preId_;                                    //上一篇id
    NSString                *preTitle_;                                 //上一篇title
    NSString                *preQikan_;                                 //上一期
    NSString                *nextId_;                                   //下一篇id
    NSString                *nextTitle_;                                //下一篇title
    NSString                *nextQikan_;                                //下一期
    
    //详情里面的内容
	NSString                *newsAuthor_;                               //作者
	NSMutableString         *newsContent_;                              //内容
    
    //详情状态
    NSString                *status_;
    NSString                *code_;
    NSString                *msg_;
    
    NSData                  *imageData_;                                //图片内容
    
    BOOL                    bImageDataLoaded_;                          //图片数据是否加载完成
}

@property(nonatomic,retain) NSString                *newsID_;
@property(nonatomic,retain) NSString                *newsTitle_;
@property(nonatomic,retain) NSString                *newsCount_;
@property(nonatomic,retain) NSString                *newsDate_;
@property(nonatomic,retain) NSString                *imagePath_;
@property(nonatomic,retain) NSString                *preId_;
@property(nonatomic,retain) NSString                *preTitle_;
@property(nonatomic,retain) NSString                *preQikan_;
@property(nonatomic,retain) NSString                *nextId_;
@property(nonatomic,retain) NSString                *nextTitle_;
@property(nonatomic,retain) NSString                *nextQikan_;
@property(nonatomic,retain) NSMutableString         *newsContent_;
@property(nonatomic,retain) NSString                *newsAuthor_;
@property(nonatomic,retain) NSString                *status_;
@property(nonatomic,retain) NSString                *code_;
@property(nonatomic,retain) NSString                *msg_;
@property(nonatomic,retain) NSData                  *imageData_;
@property(nonatomic,assign) BOOL                    bImageDataLoaded_;


@end
