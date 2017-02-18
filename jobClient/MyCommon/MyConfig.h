//
//  MyConfig.h
//  MBA
//
//  Created by sysweal on 13-11-21.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareManger.h"
#import "UIImage+FixOrientation.h"
#import <UMSocialCore/UMSocialCore.h>

#define UMAPPKEY                   @"54bdd236fd98c5e6c20002a5"             //友盟APPkey
//old 52e0fc3456240b5a2a040a47
#define UMSHARETYPEARRAY  [NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil] //友盟分享类型
//#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
//#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0

//typedef enum
//{
//    FromAskComment,             //问答答案评论
//    FromAskLike,                //问答答案点赞
//    FromAskCommit,              //问答答案提交
//    FromXWComment,              //薪闻评论回复或提交
//    FromXWTJExpertDetail,       //查看薪闻内推荐行家详情
//    FromXWAskExpert,            //薪闻内向推荐行家提问
//    FromXZYCTJExpertDetail,     //查看薪资预测内推荐行家详情
//    FromXZYCAskExpert,          //薪资预测内向推荐行家提问
//    FromXZPHDBPTJExpertDetail,  //查看薪指排行大比拼内推荐行家详情
//    FromXZPHDBPAskExpert,       //薪指排行大比拼内向推荐行家提问
//    FromSalaryForecast,         //查看薪资预测更多分页
//    FromSalaryCompete,          //薪酬比一比
//    FromOthersSalaryCompete,    //他人比拼页面的薪酬比一比
//    FromGXSPublish,             //发表灌薪水
//    FromGXSComment,             //灌薪水评论回复或提交
//    FromPublishArticle,         //发表话题、文章
//    FromAskQuestion,            //我要提问
//    FromJoinGroup,              //加入社群
//    FromCreateGroup,            //创建社群
//    FromMe,                     //“我“模块
//    FromMore,                   //”更多模块“
//    FromMySearchJob,            //求职模块的搜索订阅
//    FromMyResume,               //我的简历
//    FromApplyZW,                //申请职位
//    FromSubscribeZW,            //订阅职位
//    FromCollectZW,              //收藏职位
//    FromAttendCompany,          //关注企业
//    FromAskHR,                  //向企业HR提问
//    FromFollowOthers,           //关注他人
//    FromCheckOthersPubDetail,   //查看他人发表详情
//    FromCheckOthersAnswerDetail,//查看他人回答详情
//    FromCheckOthersGroupsDetail,//查看他人社群详情
//    FromAskOthers,              //向他人提问
//    FromMyGroups,               //我的社群
//    FromCheckTJGroupsDetail,    //产看推荐社群的详情
//    FromZTDH,                   //职同道合
//    
//}RegistType;


//注册来源
typedef enum
{
    FromNotKnown,           //未知来源
    FromYL,                 //一览弹出选项
    FromXW,                 //薪闻模块
    FromXZ,                 //薪指模块
    FromZD,                 //职导模块
    FromQZ,                 //求职模块
    FromSQ,                 //社群模块
    FromHJ,                 //行家模块
    FromZTDH,               //职同道合模块
    FromMe,                 //"我"模块
    FromMore,               //“更多”模块
    FromMessage,            //消息模块
    FromXjh,                //宣讲会
    FromZph,                //招聘会
    FromMessageSet,         //消息设置
    FromHI,                 //好友动态信息
    FromCompany,            //绑定企业
    
}RegisteType;


#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)



//RGB转UIColor（不带alpha值）
//#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SEVENTEENFONT_FRISTTITLE           [UIFont fontWithName:@"STHeitiSC-Light" size:17]//标题字体
#define FIFTEENFONT_TITLE                  [UIFont fontWithName:@"STHeitiSC-Light" size:15]//一级字体
#define FOURTEENFONT_CONTENT               [UIFont fontWithName:@"STHeitiSC-Light" size:14]//一级字体
#define THIRTEENFONT_CONTENT               [UIFont fontWithName:@"STHeitiSC-Light" size:13]//13号字体
#define TWEELVEFONT_COMMENT                [UIFont fontWithName:@"STHeitiSC-Light" size:12]//二级字体
#define ELEVEN_TIME                        [UIFont fontWithName:@"STHeitiSC-Light" size:11] //三级字体
#define NINEFONT_TIME                      [UIFont fontWithName:@"STHeitiSC-Light" size:9] //三级字体



#define DARKBLACKCOLOR     [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0]        //深黑色
#define BLACKCOLOR         [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]        //黑色
#define GRAYCOLOR          [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]     //灰色
#define LIGHTGRAYCOLOR     [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0]     //深灰色
#define REDCOLOR           [UIColor colorWithRed:237.0/255.0 green:15.0/255.0 blue:27.0/255.0 alpha:1.0]       //红色

#define PINGLUNHUI [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]

#define PINGLUNHONG UIColorFromRGB(0xe13e3e) //西瓜红

#define FONEREDCOLOR UIColorFromRGB(0xfa3434) //字体红色

//STHeitiSC-Medium
// 	STHeitiSC-Light

//是否有新版本
BOOL                                bHaveNewVersoin;

#define Min_Comment_Length          2
#define Max_Comment_Length          180

#define CheckCode_Login             @"yilan1001&&job1001"

#define MyClientName                @"iphone_yl1001new_client"


#define APPDownloadURL              @"http://itunes.apple.com/us/app/yi-lan-ying-cai/id468319885?l=zh&ls=1&mt=8"

#define GroupZbar                   @"http://m.yl1001.com/group/v/"
#define ShareYLZbar                 @"http://m.yl1001.com/apps/?p=TWZJ001"

#define ResumeZbar                  @"http://www.job1001.com/companyServe/personId/"

#define OfferPai                    @"offerpai"

//行业数据文件名称
#define TradeDataName               @"trade_archive_1_8.data"
//数据库中的专业表
#define DB_Table_Major              @"major"





//一些配置key
#define Config_Key_User             @"user_name"
#define Config_Key_Pwd              @"user_pwd"
#define Config_Key_RemberPwd        @"pwd_rember"
#define Config_Key_UserID           @"user_id"
#define Config_Key_UserName         @"name"
#define Config_Key_UserSex          @"sex"
#define Config_Key_UserPrnd         @"prnd"
#define Config_Key_UserImg          @"pic"
#define Config_Key_CheckCode        @"check_code"
#define Config_Key_VerifyUserID     @"verify_userId"

#define Config_Key_DeviceToken      @"device_token"
#define Config_Key_BackgroundStatus @"background_status"
#define Config_Key_CheckLogin       @"check_login"

#define Config_Key_PushSet          @"push_set"

//表及接口的定义

#define Table_Func_SaveUserInfo       @"editCard"
#define Table_Op_SaveUserInfo         @"persondeal"
#define Table_Func_GetNewsList        @"getYl1001XwArtList"
#define Table_Op_GetNewsList          @"salarycheck_all"
#define Table_Op_sendAMessage         @"zd_person_msg"//发私信
#define Table_Func_sendAMessage       @"sendAMessage"
#define Table_Op_LeaveMessage         @"zd_person_msg_busi"//留言
#define Table_Func_LeaveMessage       @"busi_add_msg"
#define Table_Op_GetPersonalMsgList    @"zd_person_msg_busi"//私信列表
#define Table_Func_GetPersonalMsgList  @"get_person_msg_list"
#define Table_Op_AddArticleFavorite    @"yl_favorite"//文章收藏
#define Table_Func_AddArticleFavorite  @"addArticleFavorite"
#define Table_Op_GetArticleFavoriteList    @"yl_favorite"//文章收藏列表
#define Table_Func_GetArticleFavoriteList  @"getArticleFavoriteList"
#define Table_Op_GetContactList       @"zd_person_msg_busi"//留言列表
#define Table_Func_GetContactList     @"busi_get_contact_list"
#define Table_Op_ScanQrCode           @"company_qrcode_login"//扫描二维码登录
#define Table_Func_ScanQrCode         @"scanlQrcode"
#define Table_Func_LoginAuth          @"authorizedLogin"//登录授权
#define Table_Op_addGxsComment        @"salarycheck_all_busi"//灌薪水评论
#define Table_Func_addGxsComment      @"addGxsComment"
#define Table_Func_GetArticleDetail   @"getArtDetail"
#define Table_Func_GetNewsRecommendExpert   @"busi_getAppXwRecomendExpert"
#define Table_Func_GetCommentList     @"getXwCommentList"
#define Table_Func_AddComment         @"addComment"
#define Table_Func_GetUserInfo        @"new_get_person_common_detail"
#define Table_Op_GetUserInfo          @"zd_person"
#define Table_Func_GetMyGroups        @"busi_getMyGroupsTrend"
#define Table_Op_GetMyGroups          @"groups"
#define Table_Func_GetGroupArticle    @"busi_getGroupsArticleTrend3"
#define Table_Func_GetMyPulish        @"getArtListByProNew"
#define Table_Func_GetGroupArticlDetail @"getArtContent"
#define Table_Func_FeedBack           @"feedbackcenter"
#define Table_Op_FeedBack             @"insertObject"
#define Table_Version                 @"api_call_log"
#define Table_Op_Version              @"getClientVersionInfo"
#define Table_Func_Home               @"getGroupsNewsFeed"
#define Table_Op_Home                 @"groups_newsfeed"
#define Table_Func_Expert             @"busi_getYl1001RecommendExpert"
#define Table_Func_SearchExpert       @"search_user"
#define Table_Op_Follow               @"zd_person_follow_rel"
#define Table_Func_Follow             @"addPersonFollow"
#define Table_Func_CancelFollow       @"delPersonFollow"
#define Table_Func_RecommendGroups    @"busi_getY1001RecommendGroup"
#define Table_Func_SearchGroups       @"busi_searchGroup"
#define Table_Func_JoinGroup          @"doRequestJoin"
#define Table_Op_JoinGroup            @"groups_person"
#define Table_Func_GetSubjectList     @"busi_get_subject_list_new"
#define Table_Op_GetSubjectList       @"zd_act_subject"
#define Table_Func_GetSubjectDetail   @"busi_get_subject_info_detail"
#define Table_Op_GetSubjectDetail     @"zd_act_subject_info"
#define Table_Func_GetSalaryList      @"doSearch"
#define Table_Op_GetSalaryList        @"resume_salary_cnt_basic"
#define Table_Func_GetViewPointList   @"busi_get_subject_classic_comment_by_id"
#define Table_Op_GetViewPointList     @"zd_act_subject_info"
#define Table_Func_GetCommentContent  @"busi_getCommentInfo"
#define Table_Op_GetCommentContent    @"comm_comment"
#define Table_Func_IsExpert           @"busi_isExpert"
#define Table_Func_GetJobGuide        @"getListContainNextInfo"
#define Table_Op_GetJobGuide          @"workstar_qikan"
#define Table_Func_GetJobGuideDetail  @"getArticleDetail"
#define Table_Func_ResetPwd           @"updatePassword"
#define Table_Func_GetSalaryPercent   @"calcSalaryRankSet"
#define Table_Func_GetSalaryRank      @"getResumeSalaryHighList"
#define Table_Func_SetSubscribrConfig @"setSubscribeConfig"
#define Table_Op_SetSubscribrConfig   @"app_subscribe_config"
#define Table_Func_GetRecommendJob    @"getxinzhiTjzw"
#define Table_Op_GetRecommendJob      @"company_info"
#define Table_Func_FindPassword       @"getPassAction"
#define Table_Func_AddArticleLiked    @"busi_setArticleLikeCnt"
#define Table_Func_AddCommentLiked    @"agreeComment"
#define Table_Op_AddCommentLiked      @"comm_comment"
#define Table_Func_RegistPhone        @"sendRegCodeToMobile"
#define Table_Op_RegistPhone          @"common_reg_auth"
#define Table_Func_FreshSalary        @"busi_getYJSZyRelatedInfo"
#define Table_Func_Regist             @"ylDoReg2014"
#define Table_Func_ExpertAnswerList   @"get_answer_list_expert"
#define Table_Op_ExpertAnswerList     @"zd_ask_answer"
#define Table_Func_AnswerDetail       @"getAnswerList"
#define Table_Op_AskExpert            @"zd_ask_question"
#define Table_Func_AskExpert          @"submitZhiyeQuestion"
#define Table_Func_JobGuideQuesList   @"busi_get_question_list"
#define Table_Func_XjhList            @"getCurrentXjh"
#define Table_Func_XjhDetail          @"getXjhDetail"
#define Table_Op_XjhList              @"cps_xjh"
#define Table_Func_ZphList            @"getCurrentZph"
#define Table_Func_ZphDetail          @"getZphDetail"
#define Table_Op_ZphList              @"cps_zph"
#define Table_Func_CreatedAssociation @"busi_getUserGroupListCreated2"
#define Table_Op_CreatedAssociation   @"groups"
#define Table_Func_MyAnswerList       @"busi_new_get_answer_list"
#define Table_Func_MyNotAnswerList    @"busi_get_question_list"
#define Table_Func_SubmitAnswer       @"submitAnswer"
#define Table_Op_SubscribeJob         @"person_zw_subscribe"
#define Table_Func_SubscribeJob       @"addsubscribe"
#define Table_Func_GetSubscribeJobList @"getMyAndroidSubscribe"
#define Table_Func_DeleteSubscribedJOb @"deleteSubscribe"
#define Table_Func_MyFollower          @"new_get_follow_list"
#define Table_Op_MyFollower            @"zd_person_follow_rel"
#define Table_Func_ShareArticle        @"shareArticle"
#define Table_Func_PublishTopic        @"addArticle"
#define Table_Func_GroupsCanPublish    @"busi_getCanPublishGroup"
#define Table_Func_CreateGroup         @"createGroup"
#define Table_Func_GetGroupInfo        @"getGroupInfoById"
#define Table_Func_GetGroupMember      @"getGroupMember"
#define Table_Op_GetGroupMember        @"groups_person"
#define Table_Func_GetMyGroup          @"getMyGroupsTrend"
#define Table_Op_GetMygroup            @"groups_busi"

//薪闻类型ID
#define Debug_Test_Cate_ID                  @"3871375952258867"
#define Debug_Famous_Cate_ID                @"3331337652365888"
#define Debug_Today_Cate_ID                 @"4611339637907913"
#define Debug_Pay_Cate_ID                   @"1621367812906633"
#define Debug_Wage_ID                       @"5531368441909233"
#define Debug_Jounary_ID                    @"3601372211994623"

#define Release_Test_Cate_ID                @""
#define Release_Famous_Cate_ID              @"2531368839200840"
#define Release_Today_Cate_ID               @"1081368758381920"
#define Release_Pay_Cate_ID                 @"5711368758336654"
#define Release_Wage_ID                     @"7351368758603743"
#define Release_Jounary_ID                  @"2661372229361224"


//约定的薪资段
#define Salary_1                            @"0-2000"
#define Salary_2                            @"2000-4000"
#define Salary_3                            @"4000-6000"
#define Salary_4                            @"6000-8000"
#define Salary_5                            @"8000-10000"
#define Salary_6                            @"10000-12000"
#define Salary_7                            @"12000-14000"
#define Salary_8                            @"14000-16000"
#define Salary_9                            @"16000-18000"
#define Salary_10                           @"18000-20000"
#define Salary_11                           @"20000-100000000"

//表情正则表达式
#define Custom_Emoji_Regex @"\\[[A-Z\\u4e00-\\u9fa5]+\\]"



#define QR_PERSON_TYPE  @"QR_PERSON_TYPE"
#define QR_GROUP_TYPE   @"QR_GROUP_TYPE"

//分享的页面类型
//0其他
//1薪闻
//2文章
//3职位
//4雇主
//5社群 社群文章
//6职业的力量
//7话职场
//8问答
//9个人主页
//10薪资比拼页面
//11一览app下载页面
//12查薪指页面
//13宣讲会
//14招聘会


@interface MyConfig : NSObject

@end
