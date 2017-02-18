//
//  Qikan_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-2-11.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface Qikan_DataModal :PageInfo


@property(nonatomic,strong) NSString * qikanId_;
@property(nonatomic,strong) NSString * qikan_;
@property(nonatomic,strong) NSString * template_;
@property(nonatomic,strong) NSString * title_;
@property(nonatomic,strong) NSString * articleId_;
@property(nonatomic,strong) NSString * banner_;
@property(nonatomic,strong) NSString * thum_;
@property(nonatomic,strong) NSString * orders_;
@property(nonatomic,strong) NSString * isHome_;
@property(nonatomic,strong) NSString * clicks_;
@property(nonatomic,strong) NSString * idate_;
@property(nonatomic,strong) NSString * name_;
@property(nonatomic,strong) NSString * ischeck_;
@property(nonatomic,strong) NSString * checkName_;
@property(nonatomic,strong) NSString * checkTime_;
@property(nonatomic,strong) NSString * daoyu_;
@property(nonatomic,strong) NSString * titleImg_;
@property(nonatomic,strong) NSString * filePath_;
@property(nonatomic,strong) NSString * jobs_;
@property(nonatomic,strong) NSString * typeId_;
@property(nonatomic,strong) NSString * topictype_;
@property(nonatomic,strong) NSString * personImg_;
@property(nonatomic,strong) NSString * interviewor_;
@property(nonatomic,strong) NSString * uid_;
@property(nonatomic,strong) NSString * tags_;
@property(nonatomic,strong) NSString * nextTitle_;
@property(nonatomic,strong) NSString * nextId_;
@property(nonatomic,strong) NSString * nextQikan_;
@property(nonatomic,strong) NSData   * imageData_;
@property(nonatomic,assign) BOOL       bImageLoad_;
@property(nonatomic,strong) NSString * content_;

-(Qikan_DataModal *)initWithJobGuideListDictionary:(NSDictionary *)subDic;

-(Qikan_DataModal *)initWithJobGuideDetailDictionary:(NSDictionary *)subDic;

@end
