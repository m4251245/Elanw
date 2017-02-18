//
//  CompanyInfo_DataModal.h
//  iPadJobClient
//
//  Created by job1001 job1001 on 11-12-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


/********************************************
    公司信息的dataModal(不包含公司简介)
 ********************************************/

#import <Foundation/Foundation.h>
#import "PageInfo.h"
#import "CultureContent_DataModal.h"
#import "CompanyHRAnswer_DataModal.h"
@class User_DataModal;


typedef enum {
    Info_Unknown,
    ZW_Update,
    ZW_New,
    Info_Update,
}MessageType;

@interface CompanyInfo_DataModal : PageInfo {
    NSString                        *companyID_;            //公司id
    NSString                        *email_;                //email
    NSString                        *cname_;                //公司名称
    NSString                        *cxz_;                  //公司性质，比如"有限公司"
    NSString                        *yuangong_;             //公司员工数
    NSString                        *phone_;                //人事部电话
    NSString                        *fax_;                  //人事部传真
    NSString                        *address_;              //公司地址
    NSString                        *regionid_;             //所属地区的id
    NSString                        *classid_;              //所属行业的id
    NSString                        *weblink_;              //公司网址
    NSString                        *logoPath_;             //公司logo
    NSString                        *tradeId_;              //行业id
    NSString                        *totalId_;              //总行业id
    NSString                        *des_;                  //公司简介
    NSString                        *addInfo_;              //详细地址
    NSMutableArray                  *albumArr_;             //存放办公环境相册数组
    NSMutableArray                  *hrAnswerArr_;          //问答数组
    NSMutableArray                  *zwArr_;                //职位数组
    NSMutableArray                  *developmentArr_;       //企业发展数组
    NSMutableArray                  *employeeArr_;          //用人理念数组
    NSMutableArray                  *teamArr_;              //团队数组
    NSMutableArray                  *shareArr_;             //分享数组
    CultureContent_DataModal        *culture_;              //企业文化
    CompanyHRAnswer_DataModal       *answerModal_;          //问答数据
    NSInteger                       answerSum_;             //问答总数
    NSInteger                       picSum_;                //图片总数
    NSInteger                       zwSum_;                 //职位总数
}
@property (nonatomic, copy) NSString *trade;
@property (nonatomic, retain) NSString *companyID_;
@property (nonatomic, retain) NSString *jobId;
@property (nonatomic, copy) NSString *offerPartyId;//offer派id
@property (nonatomic, retain) NSString *email_;
@property (nonatomic, retain) NSString *cname_;
@property (nonatomic, retain) NSString *cxz_;
@property (nonatomic, retain) NSString *yuangong_;
@property (nonatomic, retain) NSString *phone_;
@property (nonatomic, retain) NSString *fax_;
@property (nonatomic, retain) NSString *address_;
@property (nonatomic, retain) NSString *regionid_;
@property (nonatomic, retain) NSString *classid_;
@property (nonatomic, strong) NSString *trade_;
@property (nonatomic, strong) NSString *des_;
@property (nonatomic, strong) NSString *weblink_;
@property (nonatomic, strong) NSString *logoPath_;
@property (nonatomic, strong) NSString *tradeId_;
@property (nonatomic, strong) NSString *totalId_;
@property (nonatomic, assign) BOOL     followStatus_;
@property (nonatomic, strong) NSMutableArray *albumArr_;
@property (nonatomic, strong) NSMutableArray *hrAnwerArr_;
@property (nonatomic, strong) NSMutableArray *zwArr_;
@property (nonatomic, strong) NSMutableArray *developmentArr_;
@property (nonatomic, strong) NSMutableArray *employeeArr_;
@property (nonatomic, strong) NSMutableArray *teamArr_;
@property (nonatomic, strong) NSMutableArray *shareArr_;
@property (nonatomic, strong) NSString *addInfo_;
@property (nonatomic, strong) CultureContent_DataModal *culture_;
@property (nonatomic, strong) CompanyHRAnswer_DataModal * answerModal_;
@property (nonatomic, assign) NSInteger answerSum_;
@property (nonatomic, assign) NSInteger picSum_;
@property (nonatomic, assign) NSInteger zwSum_;
@property (nonatomic, assign) NSInteger followNum_;
@property (nonatomic, assign) NSInteger resumeCnt_;//投递应聘
@property (nonatomic, assign) NSInteger resumeUnReadCnt;//投递应聘简历未读数
@property (assign, nonatomic) NSInteger adviserRecommendCnt;//顾问推荐数，一览精选
@property (assign, nonatomic) NSInteger downloadRecommendCnt;//主动下载数
@property (assign, nonatomic) NSInteger tempSaveResumeCnt;//暂存数
@property (nonatomic, assign) NSInteger interviewCnt_;//面试数
@property (nonatomic, assign) NSInteger sendToMeCnt;//转发给我
@property (nonatomic, assign) NSInteger questionCnt_;//人才提问数
@property (nonatomic, assign) NSInteger offerPartyCnt;//offer派数量
@property (nonatomic, assign) NSInteger kpbCnt;//快聘宝数量
@property (nonatomic, assign) NSInteger vphCnt;//V聘会数量
@property (assign, nonatomic) NSInteger offerPartyRecommendCnt; //offer派中推荐的简历数
@property (nonatomic, assign) NSInteger resumeRecommendUnreadCnt;//推荐的简历未读数
@property (nonatomic, assign) NSInteger offerNewMessage;//offer派有新动态
@property (nonatomic, strong) NSString *pname_;
@property (nonatomic, strong) NSString *pnames_;
@property (nonatomic, strong) NSString *crnd_;
@property (nonatomic, strong) NSString *companyNews_;
@property (nonatomic, strong) NSString *zwUpdateCnt_;
@property (nonatomic, strong) NSString *isGroup_;
@property (nonatomic, assign) NSInteger colResumeCnt_;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, assign) BOOL     seleted;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *isRecommend;
@property (nonatomic, assign) MessageType messageType_;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, copy) NSString *regionName;

@property (nonatomic, strong) NSString *m_isAddZp;//添加职位权限 0不可， 1可以
@property (nonatomic, strong) NSString *m_isDown; //添加找简历权限 0不可， 1可以
@property (nonatomic, strong) NSString *m_status;//状态0未激活 3已激活　5停止
@property (nonatomic, strong) NSString *m_id;//协同帐号的编号id
@property (nonatomic, strong) NSString *m_dept_id;//部门编号id
@property (nonatomic, strong) NSString *synergy_id;//协同账号id

@property(nonatomic, assign) NSInteger recommand_no_read;//一览精选未读数
@property(nonatomic, assign) NSInteger forword_no_read;//转发给我未读数

//----------地图才用到的字段
@property(nonatomic,strong) NSString *lng_;  //经度
@property(nonatomic,strong) NSString *lat_;  //纬度
@property(nonatomic,strong) NSString *zpCount_;  //招聘数量
@property(nonatomic,assign) BOOL     canEdit_;
@property(nonatomic,strong) NSString *positionId;
@property(nonatomic,strong) NSString *positionName;
@property(nonatomic,strong) NSString *companyLogo;
@property(nonatomic,strong) NSString *gznum;
@property(nonatomic,strong) NSString *edus;
@property(nonatomic,strong) NSString *salary;
@property(nonatomic,copy) NSString *zpType;
@property(nonatomic,strong) NSMutableArray *tagArray;

//－－－－－－－－企业hr
@property(nonatomic, copy) NSString *startDate;//服务开始时间
@property(nonatomic, copy) NSString *endDate;//服务结束时间
@property(nonatomic, copy) NSString *serviceVersion;//服务版本
@property (assign, nonatomic) NSInteger jobStatus;//求职状态

//－－－－－－－－职位推荐消息
@property(nonatomic, strong) NSString *readStatus;  //是否已读 1已读  0未读

@property (strong, nonatomic) User_DataModal *userModal;

@end

@interface ELCompanyInfoModel : PageInfo

@property (nonatomic, copy) NSString *project_title;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *bd_user;
@property (nonatomic, copy) NSString *job_name;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *delivery_id;
@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, copy) NSString *edus;
@property (nonatomic, copy) NSString *project_type;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *tj_state;
@property (nonatomic, copy) NSString *gznum;

@property (nonatomic, assign) BOOL seleted;
@property (nonatomic,assign) BOOL isCancel;

-(id)initWithDic:(NSDictionary *)dic;

@end

