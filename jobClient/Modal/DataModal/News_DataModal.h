//
//  News_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-8.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"
#import "User_DataModal.h"

typedef enum
{
    News_Unknown,   //未知
    News_Famous,    //名家专栏
    News_Today,     //今日薪闻
    News_Pay,       //灌薪水
    News_Wage,      //晒工资
    News_Journey,   //薪路历程
    News_Test,      //职业测试
}NewsType;

@interface News_DataModal : PageInfo

@property(nonatomic,assign) NewsType      type_;
@property(nonatomic,strong) NSString      *id_;
@property(nonatomic,strong) NSString      *catId_;
@property(nonatomic,strong) NSString      *ownname_;
@property(nonatomic,strong) NSString      *title_;
@property(nonatomic,strong) NSString      *updatetime_;
@property(nonatomic,strong) NSString      *lastCommenttime_;
@property(nonatomic,assign) NSInteger     viewCount_;
@property(nonatomic,assign) NSInteger     commentCount_;
@property(nonatomic,assign) NSInteger     likeCount_;
@property(nonatomic,strong) User_DataModal *author_;
@property(nonatomic,assign) BOOL           bImageLoad_;        //是否已经加载图片
@property(nonatomic,strong) NSData         *imageData_;        //图片data
@property(nonatomic,strong) NSString       *content_;
@property(nonatomic,strong) NSString       *summary_;
@property(nonatomic,strong) NSString       *idatetime_;
@property(nonatomic,strong) NSString       *thum_;
@property(nonatomic,strong) NSString       *xw_type_;
@property(nonatomic,strong) NSString       *url_;
@property(nonatomic,strong) NSMutableArray  *  articleImgArray;
@end
