//
//  User_DataModal.h
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status_DataModal.h"
#import "CompanyInfo_DataModal.h"
#import "UserJob_DataModal.h"

@interface User_DataModal : Status_DataModal

@property (nonatomic, copy) NSString        *project_title;
@property(nonatomic,strong) NSString        *userId_;
@property(nonatomic,strong) NSString        *jobfair_person_id;
@property(nonatomic,strong) NSString        *joinState;
@property(nonatomic,strong) NSString        *pwd_;
@property(nonatomic,strong) NSString        *verifyCode_;
@property(nonatomic,strong) NSString        *img_;
@property(nonatomic,strong) NSString        *imgSmall_;
@property(nonatomic,strong) NSString        *imgMid_;
@property(nonatomic,copy) NSString        *identity_;      //标识身份
@property(nonatomic,strong) NSData          *imageData_;
@property(nonatomic,assign) BOOL            bImageLoad_;
@property(nonatomic,strong) NSString        *name_;
@property(nonatomic,strong) NSString        *nickname_;
@property(nonatomic,strong) NSString        *company_;
@property(nonatomic,strong) NSString        *sendtime_;
@property(nonatomic,strong) NSString        *salary_;
@property(nonatomic,strong) NSString        *regiondetail_;
@property(nonatomic,strong) NSString        *age_;
@property(nonatomic,strong) NSString        *eduName_;
@property(nonatomic,strong) NSString        *regionProvince_;      //所在省
@property(nonatomic,strong) NSString        *regionCity_;          //所在市
@property(nonatomic,strong) NSString        *regionHka_;           //编码
@property(nonatomic,strong) NSString        *uname_;
@property(nonatomic,strong) NSString        *intro_;            //个性签名
@property(nonatomic,strong) NSString        *motto_;            //???
@property(nonatomic,strong) NSString        *firstName_;
@property(nonatomic,strong) NSString        *mobile_;
@property(nonatomic,strong) NSString        *tel_;
@property(nonatomic,strong) NSString        *dutyCode_;
@property(nonatomic,strong) NSString        *sex_;
@property(nonatomic,strong) NSString        *bday_;
@property(nonatomic,strong) NSString        *email_;
@property(nonatomic,strong) NSString        *eduId_;            //学历
@property(nonatomic,strong) NSString        *zym_;              //专业名称
@property(nonatomic,strong) NSString        *zye_;              //专业类别
@property(nonatomic,strong) NSString        *qq_;
@property(nonatomic,strong) NSString        *regionId_;
@property(nonatomic,strong) NSString        *gzNum_;            //工作年限
@property(nonatomic,strong) NSString        *hka_;              //籍guan
@property(nonatomic,strong) NSString        *school_;           //毕业院校
@property(nonatomic,strong) NSString        *major_;
@property(nonatomic,strong) NSString        *certNum_;          //身份证
@property(nonatomic,strong) NSString        *postCode_;         //邮编
@property(nonatomic,strong) NSString        *addr_;             //地址
@property(nonatomic,assign) BOOL            bSelected_;
@property(nonatomic, copy) NSString         *tradeId; //行业编号
@property(nonatomic, copy) NSString         *tradeName;//行业名称
@property(nonatomic, copy) NSString         *intentionJob;//意向职位
@property(nonatomic, copy) NSString         *isCanContract;//联系方式  1有
@property(nonatomic, copy) NSString         *userType;//内部用户  0  2 外部用户
@property(nonatomic, strong) NSString       *newmail;//    0 已读 1 未读
@property(nonatomic, strong) NSString       *keyWorkStr;//    0 已读 1 未读
@property (strong,nonatomic) NSString       *kj;    /**<1保密人才*/
@property(nonatomic,strong) NSString        *prnd_;


@property(nonatomic,strong) NSString         *role_;
@property(nonatomic,strong) NSString         *gpId_;
@property(nonatomic,strong) NSString         *job_;
@property(nonatomic,strong) NSString         *recomJob_;
@property(nonatomic,assign) BOOL             isExpert_;//是否是行家
@property(nonatomic,strong) NSString         *trade_;
@property(nonatomic,assign) BOOL             isHr;
@property(nonatomic,strong) NSMutableArray   *jobArr_;

@property(nonatomic,assign) BOOL             invitePerm_;
@property(nonatomic,assign) BOOL             publishPerm_;

@property(nonatomic,strong) NSString        *languageLevel_;  //语言能力
@property(nonatomic,strong) NSString        *computerLevel_;  //计算机能力
@property(nonatomic,strong) NSString        *companyNature_;  //公司性质
@property(nonatomic,strong) NSString        *percent;         //同行比较百分比
@property(nonatomic,copy) NSString *tongguo;

@property(nonatomic,strong) CompanyInfo_DataModal  * companyModal_;

//绑定公司的已发面试中添加的字段
@property(nonatomic,assign) BOOL            havePic_;
@property(nonatomic,assign) BOOL            haveAudio_;
@property(nonatomic,assign) BOOL            isGWTJ_;   //标识“顾问推荐”
@property(nonatomic,assign) BOOL            isOpen; //标识是否保密
@property(nonatomic,assign) BOOL            isNewmail_;    //标识是否新的 0 未读   (一览精选解析的时候取！所以相反，其余的正常)
@property(nonatomic,strong) NSString        *emailId_; //面试通知邮件id
@property(nonatomic,strong) NSString        *isDown; //顾问下载
@property(nonatomic,strong) NSString        *zpId_;

//企业后台简历预览字段
@property(nonatomic,copy) NSString *companyId;
@property(nonatomic,copy) NSString *blocId;   //公司集团Id
@property(nonatomic,copy) NSString *forKey;
@property(nonatomic,copy) NSString *forType;
@property(nonatomic,copy) NSString *fromType;
@property(nonatomic,copy) NSString *sr_id;

//绑定公司的未读简历中添加的字段
@property(nonatomic,assign) BOOL            isPassed_;
@property(nonatomic,assign) BOOL            isTotalTrade;

@property(nonatomic,assign) NSInteger  questionCnt_;
@property(nonatomic,assign) NSInteger  answerCnt_;
@property(nonatomic,assign) NSInteger  followCnt_;
@property(nonatomic,assign) NSInteger  fansCnt_;
@property(nonatomic,assign) NSInteger  letterCnt_;
@property(nonatomic,assign) NSInteger  publishCnt_;
@property(nonatomic,assign) NSInteger  groupsCnt_;
@property(nonatomic,assign) NSInteger  followStatus_;
@property(nonatomic,assign) NSInteger  groupsCreateCnt_;
@property(nonatomic,assign) NSInteger  companyAttenCnt_;

@property(nonatomic,assign) BOOL haveNewMessage_;

@property(nonatomic, copy) NSString *recommendId;//简历推荐的ID
@property(nonatomic, copy) NSString *resumeId;//简历ID

@property(nonatomic,copy) NSString *wait_mianshi;
@property(nonatomic,copy) NSString *report;
@property(nonatomic,copy) NSString *reportUrl;
//企业hr offer派 专家意见查看用
@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, copy) NSString *pages;
@property (assign, nonatomic) NSInteger resumeType;  //1 通过初选  2 不通过初选  3 待确定
@property (assign, nonatomic) NSInteger joinstate;   //到场状态：0 未确认，1 已到场，2 未到场，3 初次确认，4 最终确认，5 确认不到场，6离场
@property(nonatomic, copy) NSString *interviewState; //面试状态
@property(nonatomic, copy) NSString *recommendState; //推荐的状态
@property(nonatomic, copy) NSString *deliverState;   //投递来源
@property(nonatomic, copy) NSString *waiteNum;       //等候人数
@property(nonatomic, assign) BOOL notOperating;   //未做任何操作
@property(nonatomic, copy) NSString *updateTime;
@property(nonatomic, copy) NSString         *leaveState;//已离场
@property(nonatomic, copy) NSString         *tuijianName;//推荐人
@property(nonatomic, copy) NSString         *commentContent;//推荐理由
@property(nonatomic, copy) NSString *add_user;

@property(nonatomic, copy) NSString *jlType;
@property(nonatomic, copy) NSString *role_id;
@property(nonatomic, copy) NSString *secret;
@property(nonatomic, copy) NSString *jobfair_id;


//如果内容为空,则返回@""
+(NSString *) processNULL:(NSString *)str;

//获取内容,为空时返回"暂无"
+(NSString *) getVlaue:(NSString *)str;

//获取性别
+(NSString *) getSexStr:(NSString *)sex;


//add 5.9.5
@property(nonatomic, copy) NSString *is_yanzhengshouji;//是否验证手机 1未验证 2已验证
@property(nonatomic, copy) NSString *is_bindshouji;//是否绑定手机 1未绑定 2已绑定

@property(nonatomic, copy) NSString *token;
@end

@interface ELOfferPeopleModel : PageInfo

@property (nonatomic, copy) NSString *gznum;
@property (nonatomic, copy) NSString *job_text;
@property (nonatomic, copy) NSString *eduId;
@property (nonatomic, copy) NSString *yuex;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *gzdd1;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *isOld;
@property (nonatomic, copy) NSString *is_weituo;
@property (nonatomic, copy) NSString *personNumber;
@property (nonatomic, copy) NSString *gzdd5;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, copy) NSString *iname;
@property (nonatomic, copy) NSString *gj;
@property (nonatomic, copy) NSString *job1;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *post_tags;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *shouji;
@property (nonatomic, copy) NSString *yixiangcity;
@property (nonatomic, copy) NSString *pStatus;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *jobs;
@property (nonatomic, copy) NSString *bday;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *edus;
@property (nonatomic, copy) NSString *secret;

-(id)initWithDic:(NSDictionary *)dic;

@end

@interface ELGWRecommentModel : NSObject

@property (nonatomic, copy) NSString *tuijian_id;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, copy) NSString *project_title;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *job_name;
@property (nonatomic, copy) NSString *read_state;
@property (nonatomic, copy) NSString *jobfair_id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *job_id;
@property (nonatomic, copy) NSString *person_id;
@property (nonatomic, copy) NSString *edus;
@property (nonatomic, copy) NSString *person_name;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *gznum;

-(id)initWithDic:(NSDictionary *)dic;

@end

@interface ELGWSearchModel : NSObject

@property (nonatomic, copy) NSString *gznum;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *eduId;
@property (nonatomic, copy) NSString *bday;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *gzdd1;
@property (nonatomic, copy) NSString *edus;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *isOld;
@property (nonatomic, copy) NSString *personNumber;
@property (nonatomic, copy) NSString *gzdd5;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *id_;
@property (nonatomic, copy) NSString *iname;
@property (nonatomic, copy) NSString *job1;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *regionid;
@property (nonatomic, copy) NSString *post_tags;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *shouji;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *job_text;
@property (nonatomic, copy) NSString *yixiangcity;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *jobs;
@property (nonatomic, copy) NSString *kj;

-(id)initWithDic:(NSDictionary *)dic;

@end
