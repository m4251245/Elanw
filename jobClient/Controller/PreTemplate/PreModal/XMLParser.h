//
//  XMLParser.h
//  HelpMe
//
//  Created by wang yong on 11/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
		XML Parser
 
 ***************************/

#import <Foundation/Foundation.h>
#import "PreCommon.h"
//#import "GDataXMLNode.h"
#import "PreStatus_DataModal.h"

@class  GDataXMLDocument;
#define Request_OK                          @"OK"
#define Request_Fail_Resume                 @"简历不完整！"

//个人详情
#define PersonDetailInfo_UpdateTime         @"updatetime"           //简历刷新时间
#define PersonDetailInfo_phone              @"phone"                //固定电话
#define PersonDetailInfo_qq                 @"oicq"                 //qq
#define PersonDetailInfo_http               @"http"                 //个人主页
#define PersonDetailInfo_posts              @"posts"                //邮篇
#define PersonDetailInfo_shouji             @"shouji"               //手机
#define PersonDetailInfo_email              @"email"                //email
#define PersonDetailInfo_address            @"address"              //..
#define PersonDetailInfo_pic                @"pic"                  //个人图像
#define PersonDetailInfo_kj                 @"kj"                   //是否公开简历，即保密设置
#define PersonDetailInfo_iname              @"iname"                //姓名
#define PersonDetailInfo_gznum              @"gznum"                //工作年限
#define PersonDetailInfo_sex                @"sex"                  //性别
#define PersonDetailInfo_edu                @"edu"                  //最高学历
#define personDetailInfo_hka                @"hka"                  //籍贯
#define PersonDetailInfo_bday               @"bday"                 //出生日期
//#define PersonDetailInfo_Address_Sheng      @"hkb"                  //现居住地:省
//#define PersonDetailInfo_Address_Shi        @"shi"                  //现居住地:shi
//#define PersonDetailInfo_Address_Xian       @"xian"                 //现居住地:县
#define PersonDetailInfo_Region             @"regionid"             //现居住地
#define PersonDetailInfo_zcheng             @"zcheng"               //现有职称
#define PersonDetailInfo_marry              @"marry"                //婚姻状态
#define PersonDetailInfo_zzmm               @"zzmm"                 //政治面貌
#define PersonDetailInfo_mzhu               @"mzhu"                 //民族
#define PersonDetailInfo_jobtype            @"jobtype"              //求职类型
#define PersonDetailInfo_job                @"job"                  //意向职位1
#define PersonDetailInfo_jobs               @"jobs"                 //意向职位2
#define PersonDetailInfo_job1               @"job1"                 //意向职位3
#define PersonDetailInfo_city               @"city"                 //意向地区1
#define PersonDetailInfo_gzdd1              @"gzdd1"                //意向地区2
#define PersonDetailInfo_gzdd5              @"gzdd5"                //意向地区3
#define PersonDetailInfo_workdate           @"workdate"             //可到职日期
#define PersonDetailInfo_yuex               @"yuex"                 //期望月薪
#define PersonDetailInfo_grzz               @"grzz"                 //自我评价
#define PersonDetailInfo_school             @"school"               //毕业院校
#define PersonDetailInfo_byday              @"byday"                //毕业日期
#define PersonDetailInfo_zye                @"zye"                  //专业类别
#define PersonDetailInfo_zym                @"zym"                  //专业名称
#define PersonDetailInfo_edus               @"edus"                 //教育背景描述
#define PersonDetailInfo_gzjl               @"gzjl"                 //工作经验/(实习)经历
#define PersonDetailInfo_othertc            @"othertc"              //技能特长描述
#define PersonDetailInfo_isOld              @"isOld"                //新旧简历的标识

typedef enum {
    ProfessInfo_ZhiDao  = 62,               //职业指导
    ProfessInfo_FengYu  = 63,               //职场风雨
    ProfessInfo_JinRang = 64,               //求职锦囊
    ProfessInfo_ZhiZuo  = 65,               //简历制作
    ProfessInfo_ZhiNan  = 66,               //面试指南
}BoardIdType;

typedef enum{
	Null_XMLParser,
    
    MarryType_XMLParser,                    //婚姻类型
    ZWDateType_XMLParser,                   //职位的时间类型
    EduType_XMLParser,                      //学历类型
    YearType_XMLParser,                     //工作经验
    PostionLevel_XMLParser,                 //现有职称
    PoliticsType_XMLParser,                 //政治面貌
    NationType_XMLParser,                   //民族
    JobType_XMLParser,                      //求职类型
	WorkDateType_XMLParser,                 //可到职日期
    ZyeType_XMLParser,                      //专业类别
    ZyeTypeAll_XMLParser,                   //所有专业类别
    MajorName_XMLParser,                    //专业名称
    CompanyEmployesType_XMLParser,          //公司规模
    CompanyAttType_XMLParser,               //公司性质
    YearSalary_XMLParser,                   //年薪
    YearBouns_XMLParser,                    //年终奖
    MapRang_XMLParser,                      //定位范围
    PartJob_XMLParser,                      //职位类型
    PlaceOrigin_XMLParser,                  //省份选择
    
    InitOp_XMLParser,                       //获取配置
    Image_XMLParser,                        //加载图片
	DoLogin_XMLParser,                      //登录
    FindSercet_XMLParser,                   //找回密码
    Regest_XMLParser,                       //注册
    AddAdvice_XMLParser,                    //意见反馈
    SetSubscribe_XMLParser,                 //推送设置
    UpdateUseCount_XMLParser,               //更新使用次数
    GetVersion_XMLParser,                   //获取版本信息
    GetXjh_XMLParser,                       //宣讲会列表
    GetZph_XMLParser,                       //招聘会列表
    SetSubscribeReadFlag_XMLParser,         //设置已阅标识
    ProfessionPower_XMLParser,              //职业的力量
    ProfessionPower_Detail_XMLParser,       //职业的力量详情
    PreProfessionPower_Detail_XMLParser,    //上一篇
    NextProfessionPower_Detail_XMLParser,   //下一篇
    GetProfessInfo_ZhiDao_XMLParser,        //职业指导
    GetProfessInfo_FengYu_XMLParser,        //职场风雨
    GetProfessInfo_JinRan_XMLParser,        //求职锦囊
    GetProfessInfo_ZhiZuo_XMLParser,        //简历制作
    GetProfessInfo_ZhiNan_XMLParser,        //面试指南
    GetProfessDetailInfo_XMLParser,         //对应的详情
    GetPreProfessDetailInfo_XMLParser,      //上一篇详情
    GetNextProfessDetailInfo_XMLParser,     //下一篇详情
    GetArticleList_XMLParser,               //获取文章列表
    GetArticleDetail_XMLParser,             //获取文章详情
    SearchZW_Detail_XMLParser,              //职位详情
    ZW_Apply_XMLParser,                     //申请职位
    ZW_Fav_XMLParser,                       //收藏职位
    GetCompanyDetail_XMLParser,             //获取企业详情
    SearchResult_XMLParser,                 //职位搜索
    GetMapCompany_XMLParser,                //身边招聘企业
    GetMapCompanhyZW_XMLParser,             //身边招聘职位
    GetCompanyDes_XMLParser,                //企业的描述
    CompanyOther_ZW_XMLParser,              //企业其它职位
    ProgramQuestion_XMLParser,              //获取测试题
    TestResult_XMLParser,                   //获取测试答案
    TestProgram_XMLParser,                  //职业测试类型
    RiceMoney_XMLParser,                    //换大米
    GetSalary_XMLParser,                    //薪酬查询
    GetSchoolList_XMLParser,                //获取学校列表
    GetTalentMarket_XMLParser,              //人才市场
    AddSubscribe_XMLParser,                 //新增订阅
    GetXjhDetail_XMLParser,                 //获取宣讲会详情
    AddParticipate_XMLParser,               //参与
    RefreshAddCnt_XMLParser,                //刷新参与
    GetZphDetail_XMLParser,                 //获取招聘会详情
    AddBBS_XMLParser,                       //新增评论
    AddCompanyReply_XMLParser,              //新增企评
    GetMyCommmentList_XMLParser,            //获取评论列表
    AddAgree_XMLParser,                     //添加支持
    GetCompanyReplyList_XMLParser,          //获取企业回复列表
    AddCompanyComment_XMLParser,            //增加企评
    GetCompanyCommentList_XMLParser,        //获取企业评论列表
    GetLookHistory_XMLParser,               //查看历史浏览记录
    GetAttention_XMLParser,                 //获取我的关注日程
    ReSetSercet_XMLParser,                  //修改密码
    GetResumeStatus_XMLParser,              //获取求职状态
    UpdateResumeStatus_XMLParser,           //更新求职状态
    GetResumeSercet_XMLParser,              //获取保密设置
    UpdateResumeSercet_XMLParser,           //更新保密设置
    ApplyCountDetail_XMLParser,             //申请列表
    FavCountDetail_XMLParser,               //收藏列表
    DelFavZW_XMLParser,                     //删除收藏职位
    ResumeNotifiDetail_XMLParser,           //面试通知详情
    UpdateNotifiStatus_XMLParser,           //更新面试通知状态
    ResumeNotifiCtl_XMLParser,              //获取面试通知列表
    GetSubscribe_XMLParser,                 //获取订阅列表
    DelSubscribe_XMLParser,                 //删除某条订阅
    ApplyCount_XMLParser,                   //申请数
    FavCount_XMLParser,                     //收藏数
    ResumeNotifiCount_XMLParser,            //面试通知数
    CompanyLookedCount_XMLParser,           //简历被阅数
    RefreshResume_XMLParser,                //刷新简历
    
    GetResumePath_XMLParser,                //加载简历路径
    PersonInfo_XMLParser,                   //获取个人信息
    
    App_LogoList_XMLParser,                 //logoList
    Near_SchoolList_XMLParser,              //附近的院校
    Attention_SchoolList_XMLParser,         //关注的学校
    CancelAttention_School_XMLParser,       //取消关注
    AddAttention_School_XMLParser,          //关注某学校
    GetMySchoolInfoList_XMLParser,          //获取我的学校信息
    MyCntInfo_XMLParser,                    //我的相关数量信息
    MyMsgList_XMLParser,                    //我的消息列表
    PublisherMsgList_XMLParser,             //发布者消息列表
    MsgContent_XMLParser,                   //消息内容
    SchoolInfo_XMLParser,                   //某学校的相关信息
    SetMySchool_XMLParser,                  //设置我的学校
    
    Update_PersonImage_XMLParser,           //更新个人图像
    Delete_PersonImage_XMLParser,           //删除个人图像
    UpdateResume_BaseInfo_XMLParser,        //更新基本个人信息
    UpdateResume_WantJob_XMLParser,         //更新求职意向
    UpdateResume_OldEdu_XMLParser,          //更新教育背景(旧简历)
    UpdateResume_OldWorks_XMLParser,        //更新工作经历(旧简历)
    UpdateResume_SkillInfo_XMLParser,       //更新技能(旧简历)
    
    GetResume_Edu_XMLParser,                //获取教育背景
    UpdateResume_Edu_XMLParser,             //更新教育背景
    AddResume_Edu_XMLParser,                //新增教育背景
    DelResume_Edu_XMLParser,                //删除教育背景
    
    GetResume_Work_XMLParser,               //获取工作经历列表
    UpdateResume_Work_XMLParser,            //更新工作经历
    AddResume_Work_XMLParser,               //新增工作经历
    DelResume_Work_XMLParser,               //删除工作经历
    
    GetResume_PersonCer_XMLParser,          //获取证书列表
    UpdateResume_PersonCer_XMLParser,       //更新证书
    AddResume_PersonCer_XMLParser,          //新增证书
    DelResume_PersonCer_XMLParser,          //删除证书
    
    GetResume_PersonAward_XMLParser,        //获取个人奖项
    UpdateResume_PersonAward_XMLParser,     //更新个人奖项
    AddResume_PersonAward_XMLParser,        //新增奖项
    DelResume_PersonAward_XMLParser,        //删除个人奖项
    
    GetResume_PersonLeader_XMLParser,       //获取学生干部经历
    UpdateResume_PersonLeader_XMLParser,    //更新学生干部经历
    AddResume_PersonLeader_XMLParser,       //新增学生干部经历
    DelResume_PersonLeader_XMLParser,       //删除学生干部经历
    
    GetResume_PersonProject_XMLParser,      //获取项目活动
    UpdateResume_PersonProject_XMLParser,   //更新项目活动
    AddResume_PersonProject_XMLParser,      //新增项目活动
    DelResume_PersonProject_XMLParser,      //删除项目活动经历
    
    GetResume_StudentLeader_XMLParser,      //获取干部经历
    UpdateResume_StudentLeader_XMLParser,   //更新干部经历
    AddResume_StudentLeader_XMLParser,      //新增干部经历
    DelResume_StudentLeader_XMLParser,      //删除干部经历
    
    GetResume_Project_XMLParser,            //获取项目活动经历
    UpdateResume_Project_XMLParser,         //更新项目活动经历
    AddResume_Project_XMLParser,            //新增项目活动经历
    DelResume_Project_XMLParser,            //删除项目活动经历
    
}XMLParserType;

@class XMLParser;

@protocol XMLParserDelegate

-(void) parserFinish:(XMLParser *)parser code:(ErrorCode)code dateArr:(NSArray *)dataArr parserType:(XMLParserType)type;

@end


@interface XMLParser : NSObject {
	GDataXMLDocument        *doc_;

	ErrorCode				code_;
	NSMutableArray			*dataArr_;
	
	NSString                *soapMsg_;
    BOOL                    bFromDB_;
    
	//id<XMLParserDelegate>	delegate_;
}

@property(nonatomic,retain) NSString                *soapMsg_;
@property(nonatomic,assign) BOOL                    bFromDB_;
@property(nonatomic,assign) id<XMLParserDelegate>	delegate_;

//init data
-(void) initData;

//release data
-(void) releaseData;

//开始解数据，总接口
-(void) parserXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;

//初始化接口
-(void) parserInitOpXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析登录
-(void) parserDoLoginXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析找回密码
-(void) parserFindPwdXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析注册
-(void) parserRegestXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析提交意见反馈
-(void) parserAddAdviceXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析设置订阅信息
-(void) parserSetSubscribeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析版本信息
-(void) parserGetVersionXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析宣讲会
-(void) parserXjhXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析招聘会
-(void) parserZphXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职业的力量列表
-(void) parserProfessionPowerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职业的力量详情
-(void) parserProfessionPowerDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职业指导/职场风雨...
-(void) parserGetProfessInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职业指导/...上一篇
-(void) parserGetPreProfessInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职业指导/...下一篇
-(void) parserGetNextProfessInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析文章列表
-(void) parserArticleListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析文章详情
-(void) parserArticleDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析职位详情
-(void) parserZWDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//申请职位
-(void) parserApplyZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职位收藏
-(void) parserFavZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析公司详情
-(void) parserCompanyDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析搜索返回来的数据
-(void) parserSearchResultXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//身边招聘公司的职位
-(void) parserGetMapCompanyZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析公司其它职位
-(void) parserCompanyOtherZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析企业描述
-(void) parserCompanyDesXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析测试题目
-(void) parserTestQuestionXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析测试结果
-(void) parserTestResultXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析测试项目
-(void) parserTestProgramXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析换大米
-(void) parserRiceMoneyXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析薪酬查询的结果
-(void) parserGetSalaryXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析学校列表
-(void) parserSchoolListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//人才market
-(void) parserTalentMarketXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析新增订阅
-(void) parserAddSubscribeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析宣讲会详情
-(void) parserXjhDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析参与
-(void) parserAddParticipateXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析刷新参与
-(void) parserRefreshAddParticipateXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析招聘会详情
-(void) parserZphDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析添加评论
-(void) parserAddMyCommentXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析新增企业回复
-(void) parserAddCompanyReplyXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析获取评论列表
-(void) parserGetMyCommentListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析支持评论
-(void) parserAddAgreeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析企业回复列表
-(void) parserCompanyReplyListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析新增企业评论
-(void) parserAddCompanyCommentXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析企业评论列表
-(void) parserCompanyCommentListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析设置订阅状态
-(void) parserSetSubscribeReadFlagXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析修改密码
-(void) parserResetPwdXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取求职状态
-(void) parserGetResumeStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//更新求职状态
-(void) parserUpdateResumeStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取保密状态
-(void) parserGetResumeSercetXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//更新保密设置
-(void) parserUpdateResumeSercetStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职位申请记录
-(void) parserApplyDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职位收藏记录
-(void) parserFavDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//删除收藏职位
-(void) parserDelFavZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//简历被公司查看
//-(void) parserCompanyLookedDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//面试通知详情
-(void) parserResumeNotifiDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//面试通知状态更改
-(void) parserUpdateResumeNotifiStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//面试通知
-(void) parserResumeNotifiXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析订阅列表
-(void) parserSubscribeListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析删除某订阅
-(void) parserDelSubscribeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//面试通知数
-(void) parserResumeNotifiCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职位申请数
-(void) parserApplyCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//简历被阅数
-(void) parserBeCompanyLookedCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//职位收藏数
-(void) parserFavCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//刷新简历
-(void) parserRefreshResumeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析更新个人图像
-(void) parserUpdatePersonImageXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//解析删除个人图像
-(void) parserDeletePersonImageXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//更新联系方式
-(void) parserUpdateContactXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取教育背景
-(void) parserGetResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserUpdateResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserAddResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserDelResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取工作经历
-(void) parserGetResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserUpdateResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserAddResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserDelResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取证书
-(void) parserGetResumeCerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserAddResumeCerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserDelResumeCerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//个人奖项
-(void) parserGetResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserAddResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserUpdateResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserDelResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//学生干部经历
-(void) parserGetStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserAddStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserUpdateStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserDelStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//项目活动经历
-(void) parserGetProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserAddProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserUpdateProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
-(void) parserDelProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取简历路径
-(void) parserResumePathXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//获取个人信息
-(void) parserGetPersonInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//logo列表
-(void) parserLogoListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//附近的学校列表
-(void) parserNearSchoolListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//关注的学校
-(void) parserAttentionSchoolListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//取消关注
-(void) parserCancelAttentionSchoolXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//添加关注
-(void) parserAddAttentionSchoolXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//学校相关信息
-(void) parserSchoolInfoListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//我的消息
-(void) parserMyMsgListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//发布者下的消息列表
-(void) parserPublisherMsgListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//消息内容
-(void) parserMsgContentXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
//我的数量信息
-(void) parserMyCntInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType;
@end
