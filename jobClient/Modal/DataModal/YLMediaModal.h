//
//  YLMediaModal.h
//  jobClient
//
//  Created by 一览iOS on 15/6/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLMediaModal : NSObject

@property(nonatomic,copy) NSString *id_;
@property(nonatomic,copy) NSString *article_id;
@property(nonatomic,copy) NSString *src;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *udate;
@property(nonatomic,copy) NSString *file_pages;
@property(nonatomic,copy) NSString *file_swf;
@property(nonatomic,copy) NSString *file_html;
@property(nonatomic,copy) NSString *title;

@property(nonatomic,copy) NSString *orderby;
@property(nonatomic,copy) NSString *stat;
@property(nonatomic,copy) NSString *postfix;
@property(nonatomic,copy) NSString *titleImage;

-(YLMediaModal *)initWithDictionary:(NSDictionary *)dic;

+(NSString *)getStringWithPostfix:(NSString *)str;

+(NSString *)getImageNameWithString:(NSString *)str;

@end
