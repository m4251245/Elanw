//
//  PreRequestCon.h
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
		Request Con
 
 ***************************/

#import <Foundation/Foundation.h>
#import "PreCommon.h"
#import "XMLParser.h"
#import "Login_DataModal.h"
#import "CondictionList_DataModal.h"
#import "Op_DataModal.h"
#import "ErrorInfo.h"

@class PreRequestCon;

@protocol PreLoadDataDelegate

//start load data
-(void) loadDataBegin:(PreRequestCon *)con parserType:(XMLParserType)type;

//load data finish
-(void) loadDataComplete:(PreRequestCon *)con code:(ErrorCode)code dataArr:(NSArray *)dataArr parserType:(XMLParserType)type;

@optional
-(void) initOp:(PreRequestCon *)con soapMsg:(NSString *)soapMsg tableName:(NSString *)tableName;

@end

//本地缓存有效期(最大有数期的天数)
#define LocalRAM_Max_Day                            -120

@interface PreRequestCon : NSObject<XMLParserDelegate> {
	NSURLConnection			*conn_;
	NSMutableData			*receivedData_;         //用以接收数据的临时缓存
	
    NSString                *requestStr_;           //请求的str
    
	XMLParser				*xmlParser_;
	XMLParserType			parserType_;
	
    id                      exParam_;
}

@property(nonatomic,retain) NSString                *requestStr_;
@property(nonatomic,assign) XMLParserType			parserType_;
@property(nonatomic,assign) id<PreLoadDataDelegate>	delegate_;

//获取请求类型
+(NSString *) getRequestStr:(XMLParserType)type;

//检查是否需要放入缓存
+(BOOL) checkDataNeedSave:(XMLParserType)type;

//检查是否需要缓存到本地
+(BOOL) checkLocalDBSave:(XMLParserType)type;

//设置登录的dataModal
+(void) setLoginDataModal:(Login_DataModal *)dataModal;

//send soap msg
-(void) connectBySoapMsg:(NSString *)soapMsg tableName:(NSString *)op;

//stop conn
-(void) stopConn;

//初始化接口(请求secret和access_token)(接口用户名,密码)
-(void) initOp:(NSString *)user pwd:(NSString *)pwd;

//加载图片
-(void) loadImage:(NSString *)imagePath;

//登录
-(void) doLogin:(NSString *)userName pwd:(NSString *)pwd;

//找回密码新接口
-(void) findSercet:(NSString *)email;

//注册
-(void) regest:(NSString *)email userName:(NSString *)userName pwd:(NSString *)pwd realName:(NSString *)realName phoneNumber:(NSString *)phoneNumber statusCode:(NSInteger)code typeStr:(NSString *)typeStr;

//提交意见
-(void) giveAdvice:(NSString *)msg contact:(NSString *)contact;

//设置推送
-(void) setSubscribeConfig:(NSString *)clientName clientVersion:(NSString *)clientVersion deviceId:(NSString *)deviceId deviceToken:(NSString *)deviceToken flagStr:(NSString *)flagStr startHour:(NSString *)startHour endHour:(NSString *)endHour betweenHour:(NSString *)betweenHour schoolId:(NSString *)schoolId schoolName:(NSString *)schoolName;

//更新使用数量
-(void) updateUseCount;

//检查更新
-(void) getVersion;

//获取宣讲会信息
-(void) getXjh:(NSString *)keywords sId:(NSString *)sId sname:(NSString *)sname cId:(NSString *)cId cname:(NSString *)cname regionId:(NSString *)regionId regionType:(NSInteger)type dateStr:(NSString *)dateStr dateType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//获取招聘会信息
-(void) getZph:(NSString *)keywords sId:(NSString *)sId sname:(NSString *)sname regionId:(NSString *)regionId regionType:(NSInteger)type dateStr:(NSString *)dateStr dateType:(NSInteger)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//获取职业的力量列表(新接口)
-(void) loadProfessPowerList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//加载职业指导/职场风雨/面试指南...
-(void) loadProfessInfo:(NSInteger)infoType pageIndex:(NSInteger)pageIndex;

//获取文章列表(2职业指导,3职场风雨 ,4简历制作,5求职锦囊,6面试指南)
-(void) getArticleList:(NSInteger)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取文章详情
-(void) getArticleDetail:(NSString *)keyId;

//加载职业的力量详情
-(void) loadProfessPowerDetail:(NSString *)newsId;

//加载职业的力量详情上一篇
-(void) loadPreProfessPowerDetail:(NSString *)keyId;

//加载职业的力量详情上一篇
-(void) loadNextProfessPowerDetail:(NSString *)keyId;

//加载职业指导/职场风雨/面试指南...详情
-(void) loadProfessDetailInfo:(NSInteger)infoType newId:(NSString *)newId;

//加载上一篇
-(void) loadPreProfessDetailInfo:(NSString *)keyId;

//加载下一篇
-(void) loadNextProfessDetailInfo:(NSString *)keyId;

//加载职位详情
-(void) getZWDetail:(NSString *)zwId companyId:(NSString *)companyId;

//申请职位
-(void) applyZW:(NSString *)zwId companyId:(NSString *)companyId;

//收藏职位
-(void) favZW:(NSString *)zwId companyId:(NSString *)companyId;

//加载企业详情
-(void) getCompanyDetail:(NSString *)companyId;

//搜索职位
//搜索职位(uid:即companyId)
-(NSString *) searchJob:(NSString *)keywords regionId:(NSString *)regionId zwId:(NSString*)zwId zwStr:(NSString *)zwStr tradeId:(NSString *)tradeId bParent:(BOOL)bParent dateId:(NSString *)dateId majorId:(NSString *)majorId jobtypeId:(NSString *)jobTypeId keyType:(NSInteger)keyType bCampusSearch:(BOOL)flag uid:(NSString *)uid showMode:(NSString *)showMode pageIndex:(NSInteger)pageIndex;

//由url来搜索(从历史搜索条件来搜索)
-(void) searchByHitory:(NSString *)url pageIndex:(NSInteger)pageIndex;

//搜索身边招聘企业
-(NSString *) searchMapCompany:(NSInteger)bCampusSearch keywords:(NSString *)keywords keyType:(NSInteger)keyType majorId:(NSString *)majorId totalId:(NSString *)totalId tradeId:(NSString *)tradeId lng:(double)lng lat:(double)lat rang:(NSString *)rang  pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//从历史记录中搜索身边招聘企业
-(void) searchMapCompanyByHis:(NSString *)partSoapMsg lng:(double)lng lat:(double)lat pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//身边招聘企业职位(新接口)
-(void) getMapCompanyZW:(NSInteger)bCampusSearch uid:(NSString *)uid keywords:(NSString *)keywords keyType:(NSInteger)keyType majorId:(NSString *)majorId totalId:(NSString *)totalId tradeId:(NSString *)tradeId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//加载企业简介
-(void) getCompanyDes:(NSString *)companyId;

//加载企业其它职位
-(void) getCompanyOtherZW:(NSString *)companyId;

//获取测试项目题
-(void) getProgramQuestion:(NSString *)userId paramId:(NSString *)programId questionId:(NSString *)questionId answer:(NSString *)answer bReset:(BOOL)bReset;

//获取测试答案
-(void) getTestResult:(NSString *)userId paramId:(NSString *)programId;

//获取测试项目
-(void) getTestProgram:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//换大米
-(void) getMoneyRice:(NSString *)regionId money:(NSString *)money;

//薪酬查询
-(void) loadSalary:(NSString *)zwParentId zwParentStr:(NSString *)zwParentStr zwSubId:(NSString *)zwSubId zwSubStr:(NSString *)zwSubStr regionParentId:(NSString *)regionParentId regionSubId:(NSString *)regionSubId eduId:(NSString *)eduId gzNum:(NSString *)gzNum currentSalary:(NSString *)currentSalary;

//获取某地区的学校
-(void) getSchoolList:(NSString *)regionId regionType:(NSInteger)regionType bAttentionAtt:(BOOL)flag;

//加载人才市场
-(void) loadTalentMarket:(NSString *)regionStr key:(NSString *)key;

//新增一条订阅
-(void) addSubscribe:(NSString *)sId sname:(NSString *)sname cId:(NSString *)cId cname:(NSString *)cname regionId:(NSString *)regionId subscribeType:(NSInteger)subscribeType;

//获取宣讲会详情
-(void) getXjhDetail:(NSString *)xjhId;

//参与宣讲会/招聘会
-(void) addParticipate:(NSString *)deviceId xjhId:(NSString *)xjhId zphId:(NSString *)zphId clientName:(NSString *)clientName;

//刷新参与人数
-(void) refreshAddCnt:(NSString *)deviceId xjhId:(NSString *)xjhId zphId:(NSString *)zphId;

//获取招聘会详情
-(void) getZphDetail:(NSString *)zphId;

//增加评论/回复
-(void) addMyComment:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName content:(NSString *)content pId:(NSString *)pId;

//增加评论/回复(职业的力量)
-(void) addProfessComment:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName content:(NSString *)content pId:(NSString *)pId;

//增加企业回复
-(void) addCompanyReply:(NSString *)commentId personId:(NSString *)personId desc:(NSString *)desc;

//获取评论列表
-(void) getMyCommentList:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName pId:(NSString *)pId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取评论/回复列表(职业的力量)
-(void) getProfessCommentList:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName pId:(NSString *)pId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//顶一下评论
-(void) addCommentAgree:(NSString *)projectIndity keyId:(NSString *)keyId;

//顶一下评论(职业的力量)
-(void) addProfessCommentAgree:(NSString *)projectIndity keyId:(NSString *)keyId;

//获取企业回复列表
-(void) getCompanyReplyList:(NSString *)commentId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//给企业评论
-(void) addCompanyComment:(NSString *)companyId point:(NSInteger)point title:(NSString *)title good:(NSString *)good bad:(NSString *)bad;

//获取企业评论列表
-(void) getCompanyCommentList:(NSString *)companyId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取最近浏览历史
-(void) getHistoryList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//获取我的关注
-(void) getMyAttentionList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//设置某条订阅已被看过
-(void) setSubscribeReadFlag:(NSString *)subscribeId;

//修改密码
-(void) resetPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd;

//加载求职状态
-(void) loadResumeStatus;

//更新求职状态
-(void) updateResumeGetJobStatus:(NSInteger)code;

//加载保密状态
-(void) loadResumeSercet;

//更新保密设置
-(void) updateResumeSercetStatus:(NSInteger)code;

//获取职位申请数详情
-(void) loadApplyHistoryCountDetail:(NSInteger)pageIndex;

//获取职位收藏数详情
-(void) loadFavHistoryCountDetail:(NSInteger)pageIndex;

//删除收藏职位
-(void) delFavZW:(NSString *)keyId;

//获取职位的时间类型
-(void) getZWDateType;

//获取面试通知详情
-(void) loadResumeNotiDetail:(NSString *)boxId;

//更新面试通知的状态
-(void) updateMailBoxStatus:(NSString *)boxId;

//获取面试通知列表(以前为http请求,现在改为webservice请求)
-(void) getMailBoxList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取订阅列表
-(void) getSubscribeList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//删除某订阅
-(void) delSubscribe:(NSString *)subscribeId;

//获取职位申请数
-(void) loadApplyHistoryCount;

//获取职位收藏数
-(void) loadFavHistoryCount;

//获取面试通知数
-(void) loadResumtNotiCount;

//获取谁看过的简历数
-(void) loadResumeBeLookedCount;

//刷新简历
-(void) refreshResume;

//更新个人图片
-(void) updatePersonImage:(UIImage *)image;

//删除个人图片
-(void) deletePersonImage;

//更新简历->基本资料
-(void) updateResumeBaseInfo:(NSString *)name gznum:(NSString *)gznum sex:(NSInteger)sexStatus edu:(NSString *)edu hka:(NSString *)hka birthday:(NSString *)birthday nowRegion:(NSString *)nowRegion phoneNum:(NSString *)phoneNum email:(NSString *)email zcheng:(NSString *)zcheng marray:(NSString *)marray zzmm:(NSString *)zzmm mzhu:(NSString *)mzhu;

//更新简历->求职意向
-(void) updateResumeWantJob:(NSString *)jobtype zw1:(NSString *)zw1 zw2:(NSString *)zw2 zw3:(NSString *)zw3 region1:(NSString *)region1 region2:(NSString *)region2 region3:(NSString *)region3 workdate:(NSString *)workdate yuex:(NSString *)yuex grzz:(NSString *)grzz;

//加载教育背景(新版)
-(void) loadResumeEdu;

//更新教育背景
-(void) updateResumeEdu:(NSString *)myId school:(NSString *)school startDate:(NSString *)startDate endDate:(NSString *)endDate edu:(NSString *)edu eduId:(NSString *)eduId zye:(NSString *)zye zym:(NSString *)zym des:(NSString *)des bToNow:(BOOL)bToNow;

//新增教育背景
-(void) addResumeEdu:(NSString *)school startDate:(NSString *)startDate endDate:(NSString *)endDate edu:(NSString *)edu eduId:(NSString *)eduId zye:(NSString *)zye zym:(NSString *)zym des:(NSString *)des bToNow:(BOOL)bToNow;

//删除教育背景
-(void) delResumeEdu:(NSString *)myId;

//加载工作经历(新版)
-(void) loadResumeWork;

//更新工作经历
-(void) updateResumeWork:(NSString *)workId cname:(NSString *)cname bCompanySercet:(BOOL)bCompanySercet startDate:(NSString *)startDate endDate:(NSString *)endDate yuangong:(NSString *)yuangong cxz:(NSString *)cxz zwType:(NSString *)zwType zwName:(NSString *)zwName bSalarySercet:(BOOL)bSalarySercet monthSalary:(NSString *)monthSalary yearSalary:(NSString *)yearSalary yearBouns:(NSString *)yearBouns des:(NSString *)des bOversea:(BOOL)bOversea bToNow:(BOOL)bToNow;

//新增工作经历
-(void) addResumeWork:(NSString *)cname bCompanySercet:(BOOL)bCompanySercet startDate:(NSString *)startDate endDate:(NSString *)endDate yuangong:(NSString *)yuangong cxz:(NSString *)cxz zwType:(NSString *)zwType zwName:(NSString *)zwName bSalarySercet:(BOOL)bSalarySercet monthSalary:(NSString *)monthSalary yearSalary:(NSString *)yearSalary yearBouns:(NSString *)yearBouns des:(NSString *)des bOversea:(BOOL)bOversea bToNow:(BOOL)bToNow;

//删除工作经历
-(void) delResumeWork:(NSString *)workId;

//加载个人证书
-(void) loadPersonCer;

//更新证书
-(void) updatePersonCer:(NSString *)cerId cerName:(NSString *)cerName cerType:(NSString *)type scores:(NSString *)scores yearStr:(NSString *)year monthStr:(NSString *)month;

//新增证书
-(void) addPersonCer:(NSString *)cerName cerType:(NSString *)type scores:(NSString *)scores yearStr:(NSString *)year monthStr:(NSString *)month;

//删除证书
-(void) delPersonCer:(NSString *)cerId;

//加载个人奖项
-(void) loadPersonAward;

//新增个人奖项
-(void) addPersonAward:(NSString *)awardDesc date:(NSString *)awardDate;

//更新个人奖项
-(void) updatePersonAward:(NSString *)awardId awardDesc:(NSString *)awardDesc date:(NSString *)awardDate;

//删除个人奖项
-(void) delPersonAward:(NSString *)awardId;

//加载学生干部经历
-(void) loadPersonStudentLeader;

//新增学生干部经历
-(void) addPersonStudentLeader:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des;

//更新学生干部经历
-(void) updatePersonStudentLeader:(NSString *)leaderId startDate:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des;

//删除学生干部经历
-(void) delPersonStudentLeader:(NSString *)leaderId;

//加载项目活动经历
-(void) loadPersonProject;

//新增项目活动经历
-(void) addPersonProject:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des gainDes:(NSString *)gainDes;

//更新项目活动经历
-(void) updatePersonPorject:(NSString *)projectId startDate:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des gainDes:(NSString *)gainDes;

//删除项目活动经历
-(void) delPersonProject:(NSString *)projectId;

//更新教育背景(旧版的更新)
-(void) updateResumeOldEduInfo:(NSString *)name school:(NSString *)school bydate:(NSString *)bydate zye:(NSString *)zye zym:(NSString *)zym des:(NSString *)des;

//更新简历->工作经验(旧版的更新)
-(void) updateResumeOldWorksInfo:(NSString *)text;

//更新简历->工作技能
-(void) updateResumeSkill:(NSString *)text;

//获取简历路径
-(void) loadResumePath:(NSString *)showResumeType;

//获取个人信息
-(void) loadPersonInfo;

//获取logoList
-(void) getLogoList:(NSString *)appName modelKey:(NSString *)modelKey;

//获取附近的院校
-(void) getNearSchoolList:(float)lat lng:(float)lng;

//获取关注的学校
-(void) getAttentionSchoolList:(NSString *)schoolId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//关注某些学校
-(void) addAttentionSchool:(NSArray *)schoolNameArr clientName:(NSString *)clientName clientVersion:(NSString *)clientVersion;

//取消关注的学校's
-(void) cancelAttentioinSchool:(NSArray *)schoolNameArr;

//获取我的学校信息
-(void) getMySchoolInfoList:(NSString *)schoolId schoolName:(NSString *)schoolName pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取我的消息
-(void) getMyMsgList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取发布者的消息列表
-(void) getPublisherMsgList:(NSString *)publisherId publisherIdType:(NSInteger)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取消息内容
-(void) getMsgContent:(NSString *)msgId;

//获取某学校的相关信息
-(void) getSchoolInfoList:(NSString *)schoolId schoolName:(NSString *)schoolName pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//获取相关数量信息
-(void) getMyCntInfo:(NSString *)schoolId schoolName:(NSString *)schoolName;

//设置我的学校
-(void) setMySchool:(NSString *)schoolId schoolName:(NSString *)schoolName;

//获取学历类型
-(void) getEduType;

//获取工作经验
-(void) getYearType;

//获取现有职称
-(void) getPostionLevelType;

//获取婚姻类型
-(void) getMarryType;

//政治面貌
-(void) getPoliticsType;

//民族
-(void) getNationType;

//求职类型
-(void) getJobType;

//可到职日期选择
-(void) getWorkDateType;

//专业类别
-(void) getZyeType;

//所有专业类别
-(void) getZyeAllType;

//专业名称
-(void) getMajorNameType:(CondictionList_DataModal *)dataModal;

//公司规模
-(void) getCompanyEmployType;

//公司性质
-(void) getCompanyAttType;

//年薪
-(void) getYearSalaryType;

//年终奖选择
-(void) getYearBounsType;

//定位范围
-(void) getMapRangType;

//职位类型
-(void) GetPartJobType;

//获取数据
-(NSArray *) getLocalData:(XMLParserType)type;

@end

extern Op_DataModal     *opDataModal;
extern Login_DataModal  *loginDataModal;