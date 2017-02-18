//
//  Author_DataModal.h
//  Association
//
//  Created by 一览iOS on 14-1-14.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"
//#import "Article_DataModal.h"

@interface Author_DataModal :PageInfo


@property(nonatomic,strong) NSString *  id_;                 //用户id
@property(nonatomic,strong) NSString *  nickname_;           //呢称
@property(nonatomic,strong) NSString *  img_;                //头像地址
@property(nonatomic,strong) NSString *  company_;            //公司
@property(nonatomic,strong) NSString *  companyId_;            //公司
@property(nonatomic,strong) NSString *  post_;               //职位
@property(nonatomic,copy)   NSString *  iname_;              //名称
@property(nonatomic,strong) NSString *  isDV;                //是否是大V
@property(nonatomic,strong) NSString *  type_;               //用户类型
@property(nonatomic,assign) NSInteger       articleNum_;         //文章数量
@property(nonatomic,assign) NSInteger       replyNum_;           //回复数量
@property(nonatomic,strong)  NSData  *  imageData_;
@property(nonatomic,assign)   BOOL      bImageLoad_;
@property(nonatomic,strong) NSString *  createrName_;
@property(nonatomic,strong) NSString *  sex_;

@property(nonatomic,strong) NSString *  email_;
@property(nonatomic,strong) NSString *  mobilequhao_;
@property(nonatomic,strong) NSString *  mobile_;
@property(nonatomic,strong) NSString *  job_;
@property(nonatomic,strong) NSString *  idate_;
@property(nonatomic,copy) NSString *  zw_;
@property(nonatomic,strong) NSString *  gznum_;
@property(nonatomic,strong) NSString *  signature_;
@property(nonatomic,strong) NSString *  trade_;
@property(nonatomic,strong) NSString *  group_rel;
@property(nonatomic,strong) NSString *  age_;
@end
