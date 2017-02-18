//
//  PreCommonConfig.h
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
		Common_Config
 
 ***************************/

#import <Foundation/Foundation.h>
#import "PreCommonRequest.h"

//#ifdef __i386__
//#    define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#    define NSLog(...) {}
//#endif

#define Op_User                                     @"iphone"
#define Op_Pwd                                      @"123"
//#define WebServiceAddress                           @"http://192.168.60.201/webservice/index.php?"
#define WebServiceAddress                           @"http://www.job1001.com/webservice/index.php?"
#define WebService_Param_Secret                     @"secret="
#define WebService_Param_AccessToken                @"access_token="
#define WebService_Param_DebugMode                  @"debugModel="
#define WebService_DebugMode                        @"0"                                    //为1时，为debug模试

//用于加密的连接字符串［String m=uid+"jobxieqh"]
#define	PersonResume_Add_MD5						@"jobxieqh"

//百度统计appKey
#define Baidu_AppKey                                @"9e958fa85f"

//tradeId/totalId
#define TotalId                                     @""
#define TradeId                                     @""

#define Client_Type                                 @"iphone_campus_client"
#define Client_Name_NoType                          @"campus_client"
#define Client_Name                                 @"iPhone版职升机"
#define Client_Current_Version                      @"1.8"
#define Client_URL                                  @"http://yjs.job1001.com/"

//回调url
#define CallBackURL                                 @"oauth1://job1001.campus.com"

#define DownLoadMethod                              @"iPhone版客户端下载:在AppStore或者iTunes中搜索\"职升机\"下载即可\nAndroid版下载地址:http://www.job1001.com/3g/zsj.php"

#define InReload_DefaultText                        @"正在加载..."

#define StatusHeight                                20.0
//#define MainWidth                                   320.0
//#define MainHeight                                  ([[UIScreen mainScreen] bounds].size.height - StatusHeight)
//#define TabBar_Height                               49.0
//#define NavBar_Height                               44.0

//评分地址
#define GivePoint_URL                               @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=536857233"

#define Cer_Date_Add_Inditifer                      @"-"

//alert view auto release seconds
#define AlertView_Release_Seconds                   2

//事件提前几小时提醒(共提醒两次)
#define Event_Alarm_Hours_1                         24
#define Event_Alarm_Hours_2                         3

#define Article_PageSize                            25

//最多保存多少条记录(历史记录)
#define Save_SearchHistory_Max_Count                10

//评论的ProjectIndity的定义
//薪酬查询
#define SalarySearch_Comment_Indity                 @"salary_search"
//换大米
#define RiceMoney_Comment_Indity                    @"salary_search"
//宣讲会中的企业评论
#define SeminarDetailCtl_Company_Indity             @"seminar_company"
//职业测试
#define ProgramTest_Indity                          @"evaluation"
//资迅
#define ProfessInfo_Indity                          @"profess"

//logo模块key的定义
#define FindJob_MainCtl_ModelKey                    @"campus_find_job_main"
#define ProfessInfo_MainCtl_ModelKey                @"campus_profess_info_main"

//bg name
#define BG_Default                                  @"bg_default@2x.png"
#define BG_Main_Moon                                @"bg_moon@2x.png"
#define BG_SearchBar                                @"bg_searchbar.png"
#define BG_Cell_1                                   @"bg_cell_1.png"

//序列化文件名称定义
//#define AreaDataFile_Name                           @"area_archive_1_7.data"                     //被序列化的工作地区文件
#define TradeDataFile_Name                          @"trade_archive_1_8.data"                    //被序列化的工作地区文件
#define JobDataFile_Name                            @"jobCategoryArchive_1_7.data"              //被序列化的工作地区文件
#define Job_DB_FileName                             @"db_campus.sqlite"                         //db name
#define TokenStr_FileName                           @"subscribe_token"                          //本地tokenStr存放文件名
#define Laster_Login_User                           @"login_user.data"                          //最近的登录用户(Id)信息
#define LoginDataFile_Name                          @"login_dataModal.data"                     //login dataModal的序列化文件数据
#define School_User                                 @"school_user.data"                         //

//本地db table的定义
#define DB_Campus_Event                             @"campus_event"                             //`关联校招的事件表
#define DB_UserInfo_TableName                       @"user"                                     //数据库中用户信息表
#define DB_LookHistory_TableName                    @"look_history"                             //历史记录表
#define DB_Subscribe_Config                         @"subscribe_config"                         //本地订阅配置表
#define DB_AppTheme_TableName                       @"app_theme"                                //当前主题
#define DB_SearchHistory_TableName                  @"search_history_info"                      //历史搜索记录
#define DB_TableName_PersonZWReadHistory            @"person_zw_read_history"                   //职位历史记录表
#define DB_TableName_CacheData                      @"cache_data"                               //本地缓存表
#define DB_TableName_AppConfig                      @"app_config"                               //程序配置
#define Dyn_RegionConfig_Name                       @"dyn_region"
#define DB_TestRecoder                              @"test_recoder"                             //测试记录表
#define DB_Major                                    @"major"                                    //本地专业表

//一些请求db name的定义
#define Request_TableName_Init_Op                   @"init_log"
#define Request_TableName_School                    @"school"
#define Request_TableName_Xjh                       @"cps_xjh"
#define Request_TableName_MapCompany                @"map_company"
#define Request_TableName_Zph                       @"cps_zph"
#define Request_TableName_Person                    @"person"
#define TableName_LogAdvice                         @"feedbackcenter"                       //用于接收意见反馈信息的表
#define TableName_TypeId                            @"100110011001"
#define TableName_Company                           @"company"
#define TableName_Mailbox                           @"pmailbox"
#define TableName_Person                            @"person"
#define TableName_PersonSlave                       @"person_slave"
#define TableName_PersonCer                         @"person_cer"                           //个人证书信息
#define TableName_PersonEdu                         @"person_edus"                          //教育背景
#define TableName_PersonWork                        @"person_work"                          //工作经历表
#define TableName_PersonAward                       @"person_award"                         //学生奖项表
#define TableName_PersonStudentLeader               @"person_studentLeader"                 //干部经历表
#define TableName_PersonProject                     @"person_project"                       //项目活动经历
#define TableName_Article                           @"article"                              //文章
#define TableName_WorkStart_QiKan                   @"workstar_qikan"                       //职业的力量
#define TableName_MapApi                            @"api_map"
#define TableName_CpsPublishInfo                    @"cps_publish_info"                     //发布的信息
#define TableName_Attention                         @"cps_attention"                        //关注表
#define TableName_Comment                           @"job_comment"                          //评论
#define TableName_ZW                                @"zp"
#define TableName_PartJob                           @"cps_partjob"
#define TableName_TestProgram                       @"cp_program"
#define TableName_ProgramQuestion                   @"cp_testrecord"
#define TableName_RiceMoney                         @"cps_changesubstance"
#define TableName_Major                             @"zyrep"
#define TableName_PersonDeal                        @"persondeal"
#define TableName_Favorite                          @"pfavorite"
#define TableName_AppSubscribe_Config               @"app_subscribe_config"
#define TableName_Participate                       @"cps_participate"
#define TableName_Comment_New                       @"comm_bbs"
#define TableName_ProfessComment                    @"workstar_comment"
#define TableName_CompanyComment                    @"qp_comment"
#define TableNaem_API_Log                           @"api_call_log"
#define TableName_AppLogo                           @"app_logo"
#define TableName_School_Attention                  @"cps_sch_attention"
#define TableName_PublishMsg                        @"cps_publish_msg"
#define TableName_Msg                               @"cps_msg"


@interface PreCommonConfig : NSObject {
    
}

//get service address
+(NSString *) getServiceDefaultAddress;

//get alert view release seconds
+(int) getAlertViewReleaseSeconds;

//get bg name
+(NSString *) getBgName;

//由时间获取bg
+(NSString *) getBgNameByTime;

//get search bg name
+(NSString *) getSearchBarBgName;

//由星期获取颜色
+(UIColor *) getWeekDayColor:(NSString *)week;

//获取恢色边框颜色
+(UIColor *) getBoundsGrayColor;

//获取请求的操时时间
+(int) getRequestTimeOutSeconds;

@end
