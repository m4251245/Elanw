//
//  WorkApplyDataModel.h
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"

@interface WorkApplyDataModel :PageInfo

@property(nonatomic,strong)NSString *id_;           //id
@property(nonatomic,strong)NSString *applyDate_;    //更新日期
@property(nonatomic,strong)NSString *applyTime_;    //申请时间
@property(nonatomic,strong)NSString *jobId_;        //职位id
@property(nonatomic,strong)NSString *jobName_;      //职位名称
@property(nonatomic,strong)NSString *userId_;       //用户Id
@property(nonatomic,strong)NSString *applyName_;    //申请人姓名
@property(nonatomic,strong)NSString *companyID_;    //企业id
@property(nonatomic,strong)NSString *companyName_;  //企业名
@property(nonatomic,strong)NSString *companyNum_;   //企业编号
@property(nonatomic,strong)NSString *tradeId_;      //行业Id
@property(nonatomic,strong)NSString *regionName_;   //地区
@property(nonatomic,strong)NSString *title_;        //招聘标题
@property(nonatomic,assign)BOOL     isSeleted_;     //是否选中
@property(nonatomic,strong)NSString *logo_;         //Logo
@property(nonatomic,strong)NSString *interviewTime_;        //面试通知发出时间
@property(nonatomic,strong)NSString *isRead_;               //阅读标识 1已阅 0未阅
@property(nonatomic,strong)NSString *resumeStatus;

@property(nonatomic,strong)NSString *readCount_;            //简历访问次数
@property(nonatomic,strong)NSString *companyNature_;        //企业性质


@property(nonatomic,assign) BOOL        isSelected;
@property(nonatomic,strong)NSString     *readTime_;   //被查阅时间
@property(nonatomic,strong)NSString     *collectTime_;   //感兴趣收藏时间
@property(nonatomic,strong)NSString     *unqualTime_;   //不合格通知时间
@property(nonatomic,strong)NSString     *mailTime_;   //面试通知时间
@property(nonatomic,strong)NSString     *sendTime_;   //投递简历成功时间
@property(nonatomic,strong)NSString     *salary;      //薪资
@property(nonatomic,strong)NSString     *lastViewTime_;  //企业后台最后操作时间
@property(nonatomic,strong)NSMutableArray *welfareArray_;  //企业后台最后操作时间


@property(nonatomic,copy) NSString *gwId;
@property(nonatomic,copy) NSString *gwName;
@property(nonatomic,copy) NSString *gwHeadImage;
@property(nonatomic,copy) NSString *gwContent;
@property(nonatomic,assign) BOOL showMessageView;


@end
