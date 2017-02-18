//
//  JobSearch_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface JobSearch_DataModal : PageInfo {
    NSString                *companyID_;                //公司id
    NSString                *zwID_;                     //职位id
    NSString                *zwName_;                   //zwName
    NSString                *companyName_;              //companyName
    NSString                *regionName_;               //regionName
    NSString                *major_;                    //专业要求
    NSString                *updateTime_;               //更新时间 
    
    NSString                *zwFavKeyId_;               //职位收藏的职位主键
    
    BOOL                    bChoosed_;                  //是否被选中
    
    BOOL                    bRead_;                     //是否已阅
    
    NSString                *jtzw_;                     //搜索的关键字
    NSString                *cnameAll_;                 //公司全称
    NSString                *regionId_;                 //地址id
}

@property(nonatomic,retain) NSString        *companyID_;
@property(nonatomic,retain) NSString        *zwID_;
@property(nonatomic,retain) NSString        *zwName_;
@property(nonatomic,retain) NSString        *companyName_;
@property(nonatomic,retain) NSString        *regionName_;
@property(nonatomic,retain) NSString        *major_;
@property(nonatomic,retain) NSString        *updateTime_;
@property(nonatomic,retain) NSString        *zwFavKeyId_;
@property(nonatomic,assign) BOOL            bChoosed_;
@property(nonatomic,assign) BOOL            bRead_;
@property(nonatomic,strong) NSString        *jtzw_;
@property(nonatomic,strong) NSString        *cnameAll_;
@property(nonatomic,strong) NSString        *province_;         //省
@property(nonatomic,strong) NSString        *city_;             //市
@property(nonatomic,strong) NSString        *county;            //县
@property(nonatomic,strong) NSString        *salary_;
@property(nonatomic, copy) NSString         *minSalary;
@property(nonatomic, copy) NSString         *maxSalary;
@property(nonatomic, copy) NSString         *salaryType;
@property(nonatomic,strong) NSString        *companyLogo_;
@property(nonatomic,strong) NSMutableArray  *welfareArray_;
@property(nonatomic,assign) BOOL            isKy_;
@property(nonatomic,strong) NSString        *gznum_;
@property(nonatomic, copy) NSString         *minGzNum;
@property(nonatomic, copy) NSString         *maxGzNum;
@property(nonatomic,strong) NSString        *edu_;
@property(nonatomic,strong) NSString        *count_;
@property(nonatomic,strong) NSString        *regionId_;
@property(nonatomic,strong) UIColor         *tagColor;
@property(nonatomic,copy)   NSString        *zptype;
@property(nonatomic,strong) NSString           *latNum;
@property(nonatomic,strong) NSString           *longnum;
@property(nonatomic,strong) NSString           *jobtypes;  //工作类型
@property(nonatomic,strong) NSString        *nearByWords;
@property(nonatomic,strong) NSString        *geo_diff;     //距离

@property(nonatomic,strong) NSString        *rcType; //人才类型
@property(nonatomic,strong) NSString        *tjNumber;//一览精选

@property(nonatomic,strong) NSMutableAttributedString *positionAttstring;
@property(nonatomic,strong) NSMutableAttributedString *companyAttString;

- (instancetype)initWithPageInfoDictionary:(NSDictionary *)dic;

@end
