//
//  CultureContent_DataModal.h
//  Association
//
//  Created by YL1001 on 14-6-26.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CultureContent_DataModal : NSObject

@property(nonatomic,strong) NSString        * id_;
@property(nonatomic,strong) NSString        * cid_;             //公司id
@property(nonatomic,strong) NSString        * mainTitle_;       //主标题
@property(nonatomic,strong) NSString        * subTitle_;        //子标题
@property(nonatomic,strong) NSString        * content_;         //内容
@property(nonatomic,strong) NSString        * idatetime_;
@property(nonatomic,strong) NSString        * updatetime_;

@property(nonatomic,strong) NSString        * managerName_;
@property(nonatomic,strong) NSString        * managerSex_;
@property(nonatomic,strong) NSString        * managerZW_;
@property(nonatomic,strong) NSString        * managerImg_;
@property(nonatomic,strong) NSString        * managerIntro_;

@end
