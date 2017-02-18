//
//  ShareMessageModal.h
//  jobClient
//
//  Created by 一览iOS on 15-5-13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article_DataModal.h"

@interface ShareMessageModal : NSObject

@property(nonatomic,copy) NSString *personId;
@property(nonatomic,copy) NSString *personName;
@property(nonatomic,copy) NSString *person_pic;
@property(nonatomic,copy) NSString *person_zw;

@property(nonatomic,copy) NSString *position_id;
@property(nonatomic,copy) NSString *position_name;
@property(nonatomic,copy) NSString *position_logo;
@property(nonatomic,copy) NSString *position_salary;
@property(nonatomic,copy) NSString *position_company;
@property(nonatomic,copy) NSString *position_company_id;

@property(nonatomic,copy) NSString *article_id;
@property(nonatomic,copy) NSString *article_title;
@property(nonatomic,copy) NSString *article_thumb;
@property(nonatomic,copy) NSString *article_summary;

@property(nonatomic,copy) NSString *groupId;
@property(nonatomic,copy) NSString *groupName;
@property(nonatomic,copy) NSString *groupPic;
@property(nonatomic,copy) NSString *groupPersonCnt;
@property(nonatomic,copy) NSString *groupArticleCnt;

@property(nonatomic,copy) NSString *person_gznum;
@property(nonatomic,copy) NSString *person_edu;

@property(nonatomic,copy) NSString *imageUrl;

@property(nonatomic,copy) NSString *shareType;
@property(nonatomic,copy) NSString *shareContent;

-(void)setDataWithModal:(Article_DataModal *)modal;

@end
