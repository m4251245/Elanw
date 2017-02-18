
//
//  PersonCenterDataModel.h
//  jobClient
//
//  Created by 一览iOS on 14-10-29.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expert_DataModal.h"
#import "PhotoVoiceDataModel.h"
#import "VoiceFileDataModel.h"

@interface PersonCenterDataModel : NSObject

@property (nonatomic,strong) Expert_DataModal    *userModel_;
@property (nonatomic,strong) VoiceFileDataModel  *voiceModel_;
@property (nonatomic,strong) NSMutableArray      *photoListArray_;
@property (nonatomic,strong) NSMutableArray      *articleListArray_;
@property (nonatomic,strong) NSMutableArray      *tagListArray_;
@property (nonatomic,strong) NSMutableArray      *skillListArray_;
@property (nonatomic,strong) NSMutableArray      *fieldListArray_;
@property (nonatomic,strong) NSMutableArray      *visitListArray_;
@property (nonatomic,strong) NSMutableArray      *groupListArray_;
@property (nonatomic,strong) NSMutableArray      *interviewArray_;
@property (nonatomic,strong) NSMutableArray      *badgeArray_;
@property (nonatomic,strong) NSMutableArray      *shareArticleArray_;
@property (nonatomic,strong) NSMutableArray      *daShangPeopleArr;
@property (nonatomic,strong) NSMutableArray      *goodTradeArr;

@property(nonatomic,assign) CGRect                      photoListRect;
@property(nonatomic,assign) CGRect                      articleListRect;
@property(nonatomic,assign) CGRect                      tagListRect;
@property(nonatomic,assign) CGRect                      fieldListRect;
@property(nonatomic,assign) CGRect                      skillListRect;
@property(nonatomic,assign) CGRect                      baseInfoRect;
@property(nonatomic,assign) CGRect                      selfIntroRect;
@property(nonatomic,assign) CGRect                      interviewRect;
@property(nonatomic,assign) CGRect                      groupListRect;
@property(nonatomic,assign) CGRect                      articleCollectionRect;
@property(nonatomic,assign) CGRect                      perFectCtlRect;
@property(nonatomic,assign) CGRect                      visitorCtlRect;
@property(nonatomic,assign) CGRect                      expertIntroRect;
@property(nonatomic,assign) CGRect                      shareArticleRect;
@property (nonatomic,assign) BOOL                 isPerfect;

-(void)giveDataDicPerson:(NSDictionary *)dic;
-(void)giveDataDicAbout:(NSDictionary *)dic;

@end
