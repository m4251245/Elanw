//
//  ExRequetCon.h
//  MBA
//
//  Created by sysweal on 13-11-11.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 主要用于扩展接口
 ContactCtl
 @interface RequestCon (Op)
 ******************************/

#import <Foundation/Foundation.h>
#import "RequestCon.h"
#import "Common.h"
#import "User_DataModal.h"
#import "Upload_DataModal.h"
#import "PersonDetailInfo_DataModal.h"
#import "ShareMessageModal.h"
#import "ZWModel.h"
#import "SearchParam_DataModal.h"

//请求类型
typedef enum
{
    Request_Image = 0,          //请求图片
    Request_UploadVoiceFile,    //上传语音文件
    Request_UploadPhotoFile,    //上传图片
    
    //华丽的分割线  以上是post 以下是get  请不要改变type的顺序
    Request_GetAccessToken,     //获取accessToken
    Request_ValidUserName,      //验证用户名
    Request_Login,              //请求登录
    Request_Register,           //请求注册
    Request_SaveInfo,           //保存个人信息
    Request_GetNews,            //请求薪闻
    Request_AddComment,         //添加评论
    Request_AddGxsComment,      //添加灌薪水评论
    Request_sendAMessage,       //发私信
    Request_LeaveMessage,       //留言
    Request_GetPersonalMsgList, //私信列表
    Request_deleteMsgById,      //删除单条私信
    Request_AddArticleFavorite, //收藏文章
    Request_ScanQrCode,          //扫描二维码
    gunwenJieBang,                  //顾问解绑
    Request_LoginAuth,          //登录授权
    Request_GetServiceNumber,   //无法获取验证码，第一步操作
    Request_RegistNoCode,       //无法获取验证码，注册
    Request_GetArticleFavoriteList, //收藏文章列表
    Request_GetContactList,     //留言联系人列表
    Request_GetNewNewsList,     //新消息列表
    Request_DeletePersonAllMsg,     //删除某个联系人信息
    Request_GetArticleDetail,   //请求文章详情
    Request_CommentList,        //请求评论列表
    Request_CommentListOld,
    Request_GroupChatList,      //获取群聊记录列表
    gunwenLoginWith,            //招聘顾问登录
    Request_UserInfo,           //请求个人信息
    Request_MyGroups,           //请求我的社群
    Request_GroupsArticle,      //请求社群话题列表
    Request_MyPubilsh,          //请求我的发表
    Request_GroupsArticleDetail, //请求我的社群的话题列表详情
    Request_FeedBack,           //请求我的反馈
    Request_CheckVersion,       //请求检查更新
    Request_CheckVersionByHide, //请求后台检查更新
    Request_Home,               //请求一览大厅
    Request_ExpertList,         //请求专家列表
    Request_Follow,             //请求关注行家
    Request_shareArticleDyanmic, //文章分享到动态
    Request_CancelFollow,       //请求取消关注
    Request_RecommendGroup,     //请求推荐社群
    Request_SearchGroup,        //请求搜索社群
    Request_JoinGroup,          //请求加入社群
    Request_JoinGroupTwo,       //请求加入社群无提示
    Request_SubjectList,        //请求专题列表
    Request_SubjectDetail,      //请求专题详情
    Request_SalaryList,         //请求薪指列表
    Request_ViewPoint,          //请求精品观点
    Request_isExpert,           //请求是否为专家
    Request_JobGuide,           //请求职导列表
    Request_JobGuideDetail,     //请求职导详情
    Request_ResetPwd,           //请求修改密码
    Request_SalaryPercent,      //请求薪酬百分比
    Request_SalaryRank,         //请求薪资排行榜
    Request_SetSubscribeConfig, //注册推送
    Request_RecommandJob,       //请求推荐职位
    Request_FindPassword,       //请求找回密码
    Request_SetArticleLiked,    //请求对文章添加赞
    Request_SetCommentLiked,    //请求对评论添加赞
    Request_RegestPhone,        //请求发送验证码
    Request_FreshSalaryList,    //请求应届生薪指列表
    Request_NewsRecommendExpert,  //请求薪闻详情内的推荐行家
    Request_ExpertAnswerList,   //请求专家问答列表
    Request_AskExpert,          //请求向专家提问
    Request_JobGuideQuesList,   //请求职导问题列表
    Request_XjhList,            //请求宣讲会列表
    Request_ZphList,            //请求招聘会列表
    Request_CommentContent,     //请求精品评论的评论内容
    Request_XjhDetail,          //请求宣讲会详情
    Request_ZphDetail,          //请求招聘会详情
    Request_CreatedAssociation, //请求创建的社群
    Request_MyAnswerList,       //请求我的已回答列表
    Request_MyNotAnswerList,    //请求我的待回答列表
    Request_AnswerQuestion,     //请求回答问题
    Request_SubscibeJob,        //请求订阅职位
    Request_GetJobSubscribedList, //请求职位订阅列表
    Request_DeleteJobSubscribed, //请求删除职位订阅
    Request_MyFollower,          //请求我的关注
    Request_MyFans,              //请求我的粉丝
    Request_ShareArticle,        //请求发表文章
    Request_PublishTopic,        //请求发表话题
    Request_CreateGroup,         //请求创建社群
    Request_GroupsCanPublish,    //请求可以发表话题的社群
    Request_GetGroupInfo,        //请求获取社群信息
    Request_GetGroupMember,      //请求获取社群成员
    Request_GetGroupCreater,     //请求社群的群主
    Request_InvitePeople,        //请求邀请新成员
    Request_InviteFansList,      //请求听众邀请列表
    Request_InviteFans,          //请求邀请听众
    Request_GetPushSetMessage,   //请求消息设置信息
    Request_QuitGroup,           //请求退出社群
    Request_SetPermission,       //请求设置社群权限
    Request_MyInviteList,        //请求我的受邀列表
    Request_HandleGroupInvitation, //请求处理社群邀请
    Request_HandleGroupApply,    //请求处理社群申请
    Request_UpdatePushSettings,   //请求批量消息设置
    Request_InitPushSettings,     //请求初始化推送设置
    Request_GetGroupPermission,   //请求社群的权限
    Request_SetGroupPermission,   //请求设置社群的权限
    Request_UpdateAnserSupportCount, //请求问答点赞
    Request_SubmitAnswerComment,     //请求问答评论
    Request_GetAnswerCommentList,   //请求获取问答评论
    Request_AskQuest,               //请求提问
    Request_FindPhonePwd,           //手机找回密码
    Request_CheckCode,              //校验获取的验证码
    Request_ResetPhonePwd,          //重置手机密码
    Request_UploadMyImg,            //上传头像
    Request_GetJobGuideByTag,       //根据分类获取职导列表
    Request_GetRequestJoinList,     //获取别人申请加入的消息列表（不管是否是群主有权限审核的人都会收到相关推送）
    Request_GetCreateGroupCnt,      //获取创建社群的数量
    Request_SomeCitySalaryRank,     //获取多个城市的薪资百分比
    Request_SalaryRankByMoney,      //根据薪资区间获取所占百分比
    Request_InviteSMS,              //获取邀请短信
    //简历中心接口
    Request_GetWorkApplyList,                   //获取工作申请记录列表
    Request_GetPositionDetails,                 //获取职位详情
    Request_CollectPosition,                    //请求收藏职位
    Request_GetResumeCenterMessage,             //请求职位申请记录、收藏记录、面试通知、谁看过我 的数量
    Request_GetPositionApplyCollectList,        //请求职位收藏列表
    Request_DeleteCollectPosition,              //请求删除收藏职位
    Request_GetInterviewMessageList,            //请求面试通知列表
    Request_getInterviewMessageDetail,          //请求面试通知详情
    Request_GetResumeVisitList,                 //请求简历访问列表
    Request_RefreshResume,                      //请求刷新简历
    Request_GetResumeStatus,                    //请求求职状态
    Request_UpdateResumeStatus,                 //请求更新求职状态
    Request_UpdateResumeVisible,                //请求更新简历保密设置
    Request_GetResumeVisible,                   //请求简历保密设置状态
    Request_GetResumePath,                      //请求简历路径
    Request_GetTheSamePersonList,               //请求职同道合列表
    //找工作新接口
    Request_FindJobList,            //搜索工作列表
    Request_ApplyOneZw,             //申请单个职位
    Request_ApplyZW,                //申请职位，可批量
    Request_CompanyHRAnswer,        //请求企业的HR问答
    Request_CompanyEnvironment,     //请求企业办公环境
    Request_CompanyEmployee,        //请求企业用人理念
    Request_CompanyShare,           //请求企业员工分享
    Request_CompanyTeam,            //请求企业团队
    Request_CompanyDevelopment,     //请求企业未来
    Request_CompanyAllZW,           //请求公司所有职位
    Request_RelatedCompanyList,     //请求相关雇主列表
    Request_AskCompanyHR,           //向雇主HR提问
    Request_GetEdusInfo,            //请求教育背景
    Request_UpdateEdusInfo,         //请求更新教育背景
    Request_AddEdusInfo,            //请求添加教育背景
    Request_SalaryArticleList,      //请求灌薪水文章列表
    Request_SalaryArticleAndCommentList,  //请求灌薪水文章和评论列表
    Request_ShareSalaryArticle,     //发表灌薪水文章
    Request_UpdateNickName,         //请求设置昵称
    Request_PermissionInGroup,      //获取某人在社群内的权限
    Request_GetArticleFileInfo,     //获取文档信息
    Request_AddAttentionCompany,        //请求关注企业
    Request_CancelAttentionCompany,     //请求取消关注企业
    Request_GetAttentionCompanyList,    //请求企业关注列表
    Request_UploadImgData,              //请求上传图片数据
    Request_ShareLogs,                  //分享成功后调用
    Request_GetSalaryPrediction,        //请求获取薪酬预测
    Request_GetSalaryExpert,            //获取职导推荐行家
    Request_GetResumeRcomparison,       //请求简历比较数据
    Request_MessageList,                //获取所有消息列表
    Request_OneMessageList,             //获取一类消息的列表
    Request_GetPersonDetail,            //请求用户信息
    Request_addQuestionnaire,           //请求问卷调查
    Request_GetYl1001HIList,            //请求HI模块的列表
    Request_CompanyLogin,               //请求绑定公司账号登录
    Request_CompanyHRDetail,            //请求绑定公司信息
    Request_CompanyInterviewEmail,      //请求绑定公司的面试确认通知
    Request_CompanyQuestion,            //请求绑定公司的问答
    Request_CompanyResume,              //请求绑定公司的违约简历
    Request_CompanyRecommendedResume,   //请求公司推荐的简历
    Request_CompanySearchResume,        //企业搜索简历
    Request_CompanyIslookPersonContact, //请求公司是否能够查看用户的联系方式
    Request_SetRecommendResumeReaded,   //请求设置推荐的简历已阅
    Request_DownloadResume,             //请求公司推荐的简历
    Request_ResumeURL,                  //请求预览简历的url
    Request_ResumeZbar,                 //请求简历预览二维码
    Request_PositionDetail3GURL_,       //请求职位详情3GURL
    Request_DoHRAnswer,                 //回答绑定公司中的问题
    Request_SetResumePass,              //设置简历是否合适
    Request_GetCompanyOtherHR,          //请求绑定公司的其他hr
    Request_TranspondResume,            //转发简历(企业)
    Request_TranspondGuwenResume,       //转发简历(顾问)
    Request_GetInterviewModel,          //获取公司的面试模板
    Request_GetCompanyZWForUsing,       //获取公司在招职位
    Request_SendInterview,              //发送面试通知
    Request_GetServiceUrl,              //获取服务信息的url
    Request_ArticleAddLike,             //文章添加赞
    Request_BindingCompany,             //绑定企业和个人
    Request_GetBindingCompany,          //获取绑定的企业
    Request_GetPositionNameWith,        //请求职位名称
    Request_GetCompanyPositionDetailUrl, //请求公司详情URL
    Request_SetNewMailRead,             //设置简历已阅
    Request_AttendCareerSchool,             //添加关注学校
    Request_ChangAttendCareerSchool,        //取消关注学校
    Request_GetAttendSchoolList,            //请求关注学校列表
    Request_GetSchoolXJHList,           //请求学校宣讲会列表
    Request_SalaryCompareResult,        //请求薪资大比拼结果（新）
    Request_AddResumePhoto,             //添加简历图片
    Request_GetResumePhotoAndVoice,     //请求简历图片语音
    Request_DeleteResumeImage,              //删除简历图片
    Request_AddResumeVoice,             //添加简历语音
    Request_SalarySearchResult,         //请求薪资搜索比拼结果
    Request_SalarySearchResult2,         //请求薪资搜索比拼结果（新）
    Request_CancelBindCompany,          //请求解绑企业
    Request_AddAttentionSchoolWithUserId,   //根据学校名称添加关注
    Request_HISearchExpert,             //hi模块内的行家搜索
    Request_NearbyWork,                 //获取身边工作
    Request_DetectBinding,              //请求是第三方绑定状态
    Request_BuildPerson,                //创建账号并绑定第三方
    Request_MyCenterVisit,              //个人主页访问统计
    Request_UpdateGroups,               //更新社群信息
    Request_GetSchoolZPShareUrl,        //获取校园招聘活动分享的url
    Request_getSameTradePerson,         //获取同行
    Request_getNewSameTradePerson,      //或取新的同行数据
    Request_GetFriend,                  //获取听众我的关注
    //Request_CreateNewGroup,             //新建群聊
    Request_getNewFriendAndComment,         //获取新朋友和评论的数量
    Request_GetMyArticleCommentList,        //请求我的文章评论列表
    Request_GetMyCommentList,               //请求谁评论了我的文章列表(消息)
    Request_GetPersonCenterData,           //获取个人主页信息
    Request_SystemNotificationList,         //获取关于我的系统通知（消息）
    Request_SayHiList,                      //获取打招呼列表(消息)
    Request_LetterList,                     //获取留言列表(消息)
    Request_GroupsMessageList,              //社群消息列表(消息)
    Request_GetTagsList,                    //获取默认标签列表
    Request_GetTradeTagsList,               //获取行业标签列表
    Request_GetSkillTradeTagsList,          //获取想学技能行业标签列表
    Request_GetHotTagAndChildTag,          //获取热门标签和第一个标签的子标签
    Request_GetTagsBySecondTag,              //通过二级标签获取第三级标签
    Request_GetJobTagsList,               //获取职业标签列表
    Request_UpdateTagsList,                 //修改标签
    Request_SendMessage,                    //打招呼
    Request_MyAQlist,                       //请求我的回答（消息模块）
    Request_AnswerInterview,                //专访回答
    Request_InterviewList,                  //获取小编专访列表
    Request_GetShowMoreAnswer,              //访问更多专访权限
    Request_GetMessageCtn,                  //获取消息模块的各项新消息数
    Request_GetTraderPeson,                 //找他搜索接口
    Request_GetGroupsCount,                 //获取社群数量
    Request_GetCompanyCollectionResume,     //获取企业收藏的简历
    Request_GetCompanyTurnTomeResume,     //获取转发给我的简历
    Request_CollectResume,                  //企业收藏简历
    Request_GetSalaryArticleByES,           //搜索灌薪水文章
    Request_GetSalaryArticleListByES,       //搜索薪水入口文章列表
    Request_GetSalaryNavList,               //薪水导航列表
    Request_GetProfessionList,              //职业列表
    Request_GetProfessionChildList,         //第三级职业列表
    Request_GetResumeComplete,              //查看简历完整度
    Request_DeleteArticle,                  //删除文章
    Request_ToReport,                       //举报非法文章
    Request_SetRecommendArticle,            //社群置顶文章列表
    Request_SaveRecommendSet,               //保存置顶话题
    Request_DeleteGroupArticle,             //删除社群文章
    Request_AnswerDetailNew,                //请求问答详情（新）
    Request_Sleep,                          //记录用户休眠
    Request_Quit,                           //记录用户退出
    Request_LogOut,                         //记录用户注销
    Request_GetInveteGroupWithUserId,       //请求有邀请权限的社群列表
    Request_GetPersonInfoWithPersonId,      //请求个人 信息（简历）
    Request_inviteSearchFans,               //听众中搜索
    Request_ResumeCommentTag,               //简历评论标签
    Request_DownloadResumeList,             //下载简历列表
    Request_ResumeCommentList,              //简历评价列表
    Request_OtherCompanyAccountList,        //其他关联企业账号
    Request_AddResumeComment,               //添加简历评价
    Request_ReceiveMessage,                 //接收到推送消息后的回调
    Request_GetSalaryCompeteSum,            //薪资比拼的总数
    Request_GetExposureSalaryNum,            //曝工资的总数
    Request_SaveExposureSalary,            //保存曝工资
    Request_ResumeInfo,                     //简历信息
    Request_updateResumeInfo,               //跟新简历信息
    Request_MyBadgesList,                   //徽章列表
    Request_MyPrestige,                     //用户声望
    requestBingdingStatusWith,          //获取HR绑定
    Request_TopAD,                          //首页顶部的广告
    Request_SheidCompany,           //屏蔽公司列表
    Request_GetCompany,             //搜索公司列表
    Request_setSheidCompany,   //设置或取消屏蔽公司
    Request_MyPrestigeList,              //声望列表
    Request_GetPersonCenter1,   //个人中心1
    Request_GetPersonCenter2,   //个人中心2
    Request_GetOrderReocrd,     //简历订单记录列表
    Request_GetSalaryOrderRecord,     //查薪订单记录列表
    Request_GetOrderServiceInfo, //获取服务的信息
    Request_GetResumeApplyServiceInfo, //获取简历推送服务的信息
    Request_ApplyResumeRecommend, //简历直推申请
    Request_GetSalaryServiceInfo, //获取薪职服务的信息
    Request_GetQuerySalaryCount, //获取查薪指的次数
    Request_GenShoppingCart, //生成购物车
    Request_GetServiceStatus,    //获取用户购买服务的状态
    Request_ResumeApplyStatus,    //简历推送申请的状态
    Request_MessageClickLog,     //点击通知时的日子记录
    Request_GetWXPrepayId,       //微信支付的prepayID
    Request_GetQuerySalaryList,         //查询薪酬的列表
    Request_ResumeCompare,          //简历比较
    Request_GetMyGroupsJobAndCompany, //获取职业群和公司群列表
    Request_SearchGroupsArticle,    //搜索社群话题
    request_SalaryTypeChange,     //灌薪水三种类型
    getMessageWithId,                   //获取我的消息
    getAllMessageWithId,               //获取我的所有消息个数
    request_NewPublicArticle,       //最新发表
    request_TodayFocusList,     //今日看点列表
    Request_HeadButtonList,     //列表头部按钮顺序(职位列表，社群列表，薪指列表)
    request_TotalTradeList,     //公司群热门行业列表
    request_SalaryMap,     //薪指预测图表
    Request_SalaryHotJobList,   //查工资页面的热门行业列表
    Request_getMoreHotIndustry, //更多热门专业
    request_getSalaryForecast, //薪资预测
    Request_getShareMessageOther, //分享信息
    Request_delegateMessage,  //红点消除
    Request_ExposureTitle,  //曝工资评论的标题
    Request_getWhoLikeMeList,  //谁赞了我
    getHrMessageWithLoginId,  //获取hr或者人才信息
    Request_deleteWhoLikeMeMessage, //谁赞了我红点消除
    Request_GetArticleApply,  //活动报名提交
    Request_GetOfferPartyList, //offer派列表
    Request_GetUserOfferPartyList, //user offer派列表
    Request_GetUserOfferPartyCompanyList, //user offer派company列表
    Request_DeliverOfferPartyResume, //DeliverOfferPartyResume
    Request_GetOfferPartyCompanyList, //offer派company列表
    Request_GetOfferPartyPersonCnt, //offer人数统计
    Request_GetCompanyInfo, //企业信息
    Request_GetHeaderOfferPai,//企业后台首页广告
    Request_GetOfferPartyPersonList, //offer派分类简历列表
    Request_DealResumeStates, //批量处理简历的状态
    Request_nearWords, //附近职位
    Request_ConsultantSearchResume,     //顾问搜索简历
    Request_GuwenLoadResumeList,//顾问已下载简历列表
    Request_GuwenRecomResumeList,  //顾问推荐简历列表
    Request_GuwenCallPerson,              //顾问请求OA打电话
    Request_GunwenLoadResume,       //顾问下载简历
    Request_GunwenLoadConstanct, //下载简历联系方式
    Request_GunwenSearchCompany,  //根据意向职位搜索再招企业
    Request_GunwenTrade,    //获取顾问行业
    Request_RecommendPerson,//推荐人才
    Request_IsUpdateAddressBook, //是否上传过通讯录
    Request_UpdateAddressBook,  //上传通讯录
    Request_AddressBookList,    //一览通讯录列表
    Request_consultantVisitNum,     //获取顾问联系记录数量
    request_GetGuwenVistList,           //获取顾问回访简历列表
    request_GetReplyList,           //获取回访记录列表
    request_addVisit,               //添加回访记录
    Request_GetPersonOfferPartyCount,     //获取个人参与offer派数量
    Request_SendAddressBookFriend,   //点击通讯录好友发送请求
    Request_AddVoteLogs,       //点击互动请求借口
    Request_UpdatePushSet,   //请求更新消息设置
    Request_GetPersonListByFairId,     //顾问按类型请求offer派人才列表
    Request_GetJobFairCompany,         //offer可推荐企业列表
    Request_RecommendPersonToCompany,      //人才可以推荐的简历列表
    Request_GetOfferPartyCount,             //offer人才数量返回
    Request_joinPerson,                     //确认人才到场
    Request_SignInOfferParty,                     //offer 派签到
    Request_GetRecommentInfo,   //推荐详情
    Request_GetItemCompany,     //已确认适合/已发offer/已上岗企业列表
    Request_GetUnRecomPersonList,  //未推荐列表
    Request_AskQuestTags,       //请求提问标签
    Request_GetClickDomainList,  //文章可点击域名
    RequestReadMarkWithTuijianId,
    Request_GetLatelyJobfairList,  //获取所有未举办的offer派
    Request_AddPersonToOffer,    //offer派报名
    Request_getLastTelTime,     //获取最后通话时间
    Request_getJobGuideExpertList,  //获取职导行家列表
    Request_getExpertInfo, //获取行家信息
    Request_GetGuwenEmail,  //获取顾问邮箱
    Request_SenderResumeToGuwenEmail,  //发送邮件给顾问邮箱
    Request_GetReplyCommentList,//问答详情回复列表
    Request_GetExpertCommentList,//行家评价列表
    Request_GetAddtExpertComment,//职导对行家评价
    Request_GetApplicationList, //更多应用
    Request_GetMyAccount, //我的账户
    Request_GetRewardList, //打赏记录
    Request_ApplyCash, //申请提现
    Request_DashangShoppingCart,//打赏订单
//    request_expertOrder, //生成行家约谈订单
    request_PayWithyuer, //余额支付
    Request_OfferPartyDetailUrl, //offer派详情URL
    Request_AspectantDisList, //我的约谈列表
    Request_ActivityJoinList,//参加的活动列表
    Request_ActivityPublishList,
    Request_ActivityPeopleList, //活动成员列表
    Request_getCourseList, //选择课程列表
    Request_getZpListWithCompanyId, //在招职位列表
    Request_getZWFBInfoWithCompanyId, //获取职位发布信息
    Request_ADDJob,     //发布职位
    refreshbingdingStatusWith,    //请求顾问模块的count
    Request_getArticleRewardImg,     //文章打赏者头像
    Request_getMyRewardList,   //我的打赏列表
    Request_TodaySearchList,   //app综合搜索
    Request_MyGroupArticleList,   //社群文章列表
    Request_GetExpertRegionList, //约谈 行家常用地址
    Request_SearchMoreArticleList, //更多文章列表
    Request_SearchMoreGroupList, //综合搜索之更多社群
    
}RequestType;



//将接口方法扩展一下
@interface RequestCon (Op)

//pragma mark 发私信
- (void)sendMsgContent:(NSString *)content from:(NSString *)fromUserId to:(NSString *)toUserId;

//pragma mark 留言
- (void)leaveMsgContent:(NSString *)content from:(NSString *)fromUserId to:(NSString *)toUserId hrFlag:(BOOL)hrFlag shareType:(NSString *)shareType productType:(NSString *)productType recordId:(NSString *)recordId;

//pragma mark 私信列表
- (void)getPersonalMsgListWithFrom:(NSString *)fromUserId to:(NSString *)toUserId productType:(NSString *)productType recordId:(NSString *)recordId;

#pragma mark 删除单条私信
- (void)deletePersonMsg:(NSString *)userId msgId:(NSString *)msgId;

//#pragma makr 获取留言联系人列表
- (void)getContactListWithUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

#pragma mark 删除某个联系人的信息
- (void)deletePersonAllMsg:(NSString *)receiveId fromId:(NSString *)fromId;

//pragma mark 文章收藏
- (void)addArticleFavorite:(NSString *)articleId userId:(NSString *)userId type:(NSString *)type;

#pragma mark 附件收藏
- (void)addArticleMediaFavorite:(NSString *)articleId userId:(NSString *)userId type:(NSString *)type;

//pragma mark 获取文章收藏的列表
- (void)getArticleFavoriteList:(NSString *)userId type:(NSString *)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//获取图片
-(void) loadImage:(NSString *)path;

//获取接口token
-(void) getAccessToken:(NSString *)user pwd:(NSString *)pwd time:(long)time;

//登录
-(void) doLogin:(NSString *)user pwd:(NSString *)pwd;

//注册手机号
-(void) regestPhone:(NSString *)phone;

//注册
-(void) doRegister:(NSString*)uname  pwd:(NSString*)pwd  regSource:(NSString*)regSource verifyCode:(NSString*)verifyCode;

//设置推送
-(void) setSubscribeConfig:(NSString *)clientName clientVersion:(NSString *)clientVersion deviceId:(NSString *)deviceId deviceToken:(NSString *)deviceToken flagStr:(NSString *)flagStr startHour:(NSString *)startHour endHour:(NSString *)endHour betweenHour:(NSString *)betweenHour userId:(NSString*)userId;

//保存个人信息
-(void)saveUserInfo:(NSString *)personId job:(NSString *)zw sex:(NSString *)sex pic:(NSString *)pic name:(NSString *)name trade:(NSString *)trade company:(NSString *)company nickname:(NSString *)nickname signature:(NSString *)signature personIntro:(NSString *)personIntro expertIntro:(NSString *)expertIntro hkaId:(NSString *)hkaId school:(NSString *)school zym:(NSString *)zym rctypeId:(NSString *)rctypeId regionStr:(NSString *)regionStr workAge:(NSString *)workage brithday:(NSString *)brithday;

//保存个人信息 新接口
-(void)saveUserInfo:(NSString *)personId job:(NSString *)zw sex:(NSString *)sex pic:(NSString *)pic name:(NSString *)name trade:(NSString *)trade company:(NSString *)company nickname:(NSString *)nickname signature:(NSString *)signature  hkaId:(NSString *)hkaId school:(NSString *)school zym:(NSString *)zym rctypeId:(NSString *)rctypeId regionStr:(NSString *)regionStr workAge:(NSString *)workage brithday:(NSString *)brithday tradeId:(NSString *)tradeId  tradeName:(NSString *)tradeName;

//获取薪闻信息
-(void) getNewsList:(NSInteger)pageIndex  pagesize:(NSInteger)pageSize  catagory:(NSString*)catId;

//获取文章详情
-(void) getArticleDetail:(NSString*)articleId;

//获取薪闻详情内的推荐行家
-(void)getRecommendExpertInNews;

//获取评论列表
-(void)getCommentList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize  article:(NSString*)articleId parentId:(NSString*)parentId userId:(NSString*)userId;

//获取评论列表old
-(void)getCommentList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize  article:(NSString*)articleId parentId:(NSString*)parentId;

//添加评论
-(void) addComment:(NSString *)objectId parentId:(NSString *)parentId userId:(NSString *)userId content:(NSString *)content  proID:(NSString*)proid;

#pragma mark 匿名发表评论
-(void) addComment:(NSString *)objectId parentId:(NSString *)parentId userId:(NSString *)userId content:(NSString *)content  proID:(NSString*)proid clientId:(NSString *)clientId;

//获取个人信息
-(void) getUserInfo:(NSString*)userId;

//获取我的社群列表
-(void) getMyGroups:(NSString*)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchArr:(NSString *)searchText type:(NSString *)type;

//获取社群话题列表
-(void) getGroupsArticleList:(NSString*)groupId  user:(NSString *)userId keyWord:(NSString *)keyWord page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize topArticle:(NSString *)topArticle;

//获取我的发表列表
-(void) getMyPublishList:(NSString*)userID  page:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize status:(NSString*)status;

//获取我的社群的话题详情
-(void) getGroupsArticleDetail:(NSString*)articleId;

//意见反馈
-(void) giveAdvice:(NSString *)msg contact:(NSString *)contact;

//版本检查
-(void) checkClientVersion:(NSString *)clientName;

//版本检查(隐式)
-(void) checkClientVersionByHide:(NSString *)clientName;

//请求一览大厅信息列表
-(void) getHomeList:(NSString*)userId  searchType:(NSString*)type  page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求专家列表
-(void) getExpertList:(NSString*)userId  page:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize  expertName:(NSString*)expertName;

//请求关注行家
-(void) followExpert:(NSString *)userId  expert:(NSString *)expertId;

//请求取消关注行家
-(void) cancelFollowExpert:(NSString *)userId  expert:(NSString*)expertId;

//请求推荐社群
-(void)getRecommendGroups:(NSString*)userId  page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求搜索社群
-(void)getGroupsBySearch:(NSString*) userId   keyword:(NSString*)keyword  page:(NSInteger) pageIndex  pageSize:(NSInteger)pageSize;

//请求加入社群
-(void)joinGroup:(NSString*)userId  group:(NSString*)groupId content:(NSString *)content;

//请求专题列表
-(void)getSubjectList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

//请求专题详情
-(void)getSubjectDetail:(NSString*)subjectId;

//请求薪指列表
-(void)getSalaryList:(NSString*)keyword keywordFlag:(NSString *)keywordFlag region:(NSString*)regionid  page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize  userId:(NSString*)userId;

//获取薪资比拼的总数
-(void)getSalaryCompeteSum;

//请求精品观点列表
-(void)getViewPoint:(NSString * )zasId;

//请求精品评论内容
-(void)getCommentContent:(NSString*)commentId;


//请求是否为专家
-(void)getIsExpert:(NSString*)personId;

//请求职导列表
-(void)getJobGuideList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

//请求职导详情
-(void)getJobGuideDetail:(NSString*)keyId;

//请求修改密码
-(void)resetPassword:(NSString*)userId  oldPwd:(NSString*)oldPwd   newPwd:(NSString *)newPwd;

//请求薪酬百分比
//-(void)getSalaryPercent:(NSString*)place  zw:(NSString*)zw  salary:(NSString*)salary  haveKW:(BOOL)haveKW;

//请求薪资排行榜
-(void)getSalaryRank:(NSString*)regionId  zw:(NSString*)zw  salary:(NSString*)salary;

//注册推送
//-(void)setSubscribeConfig:(NSString *)deviceToken  user:(NSString*)userId clientName:(NSString*)clientName startHour:(NSInteger)startHour  endHour:(NSInteger)endHour clientVersion:(NSString*)clientVersion betweenHour:(NSInteger)betweenHour;

//请求推荐职位
-(void)getRecommendJobList:(NSString*)job  regionid:(NSString*)regionid  salary:(NSString*)salary isEmail:(NSString*)isemail  email:(NSString*)email username:(NSString*)username sex:(NSString*)sex;

//请求找回密码
-(void)findPassword:(NSString*)email;

//请求给文章添加赞
-(void)addArticleLiked:(NSString*)artixleId;

//请求应届生薪指列表
-(void)getFreshSalaryList:(NSString*)zym  minWorkAge:(NSString*)minWorkAge  maxWorkAge:(NSString*)maxWorkAge regionId:(NSString*)regionId page:(NSInteger)page  pageSize:(NSInteger)pageSize;

//请求专家问答列表
-(void)getExpertAnswerList:(NSString*)expertId  page:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

//请求问答详情（新）
-(void)getAnswerDetailNew:(NSString *)questionId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex personId:(NSString *)personId;

//请求向专家提问
-(void)askExpert:(NSString*)uid  question:(NSString*)content  expert:(NSString*)expertId;

//请求职导问答列表
-(void)getJobGuideQuesList:(NSString*)type keywords:(NSString*)kw pagesize:(NSInteger)pagesize pageindex:(NSInteger)pageindex isSolved:(NSInteger)isSholved userId:(NSString*)userId  belongs:(NSString*)belongs;

-(void)myJobGroudeCtlList:(NSString *)searchText typeId:(NSString *)typeId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex tradeId:(NSString *)tradeId totalId:(NSString *)totalId;

//请求分类的职导问答列表
-(void)getJobGuideQuesListByTag:(NSString*)typeId  pagesize:(NSInteger)pagesize pageindex:(NSInteger)pageindex;

//请求招聘会列表
-(void)getZphList:(NSString*)regionId  pagesize:(NSInteger)pagesize  pageindex:(NSInteger)pageindex kw:(NSString*)kw timeType:(NSString *)timeType dateType:(NSString *)searchDateType;

//请求宣讲会列表
-(void)getXjhList:(NSString*)regionId pagesize:(NSInteger)pagesize pageindex:(NSInteger)pageinde  kw:(NSString*)kw userId:(NSString *)userId schoolId:(NSString *)schoolId schoolName:(NSString *)schoolName timeType:(NSString *)timeType
   searchDateType:(NSString *)searchDateType;

//请求宣讲会详情
-(void)getXjhDetail:(NSString*)xjhId personId:(NSString *)personId;

//请求招聘会详情
-(void)getZphDetail:(NSString*)zphId;

//请求创建的社群
-(void)getAssociationCreatedBySomeone:(NSString*)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize person:(NSString*)personId;

//请求我的已回答列表
-(void)getMyAnswerList:(NSString *)userId  pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求我的待回答列表
-(void)getMyNotAnswerList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求回答问题
-(void)answerQuestion:(NSString*)userId questionId:(NSString*)questionId content:(NSString*)content;

//请求订阅职位
-(void)subscribeJob:(NSString*)personId regionId:(NSString*)regionId keyword:(NSString*)kewword tradeId:(NSString*)tradeId;

//请求职位订阅列表
-(void)getJobSubscribedList:(NSString*)personId;

//请求删除职位订阅
-(void)deleteJobSubscribed:(NSString *)personId  jobId:(NSString*)jobId;

//请求我的关注
-(void)getMyFollower:(NSString*)userId personId:(NSString *)personId type:(NSInteger)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex kw:(NSString*)kw;

//请求发表文章
-(void)shareArticle:(NSString*)userId userName:(NSString*)userName type:(NSInteger)type title:(NSString*)title showContent:(NSInteger)showContent addComment:(NSInteger)addComment showComment:(NSInteger)showComment  content:(NSString*)content  thumb:(NSString*)thumb kw:(NSString*)kw cateName:(NSString *)cateName;

//发表话题
-(void)publishTopic:(NSString*)userId  groupId:(NSString*)groupId ownId:(NSString*)ownId title:(NSString*)title content:(NSString*)content thumb:(NSString*)thumb kw:(NSString*)kw isCompany:(BOOL)isCompany Type:(NSString *)type;

//请求可以发表话题的社群
-(void)getGroupsCanPublish:(NSString*)userId;

//创建社群
-(void)createGroup:(NSString*)userId name:(NSString*)name intro:(NSString*)intro tags:(NSString*)tags openStatus:(NSInteger)status photo:(NSString *)photo;

//获取社群信息
-(void)getGroupInfo:(NSString*)groupId  userId:(NSString*)userId;

//获取社群成员
-(void)getGroupMember:(NSString*)groupId  page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize  userId:(NSString*)userId userRole:(NSString*)userRole;


//通讯录邀请新成员
-(void)invitePeople:(NSString*)personId  groupId:(NSString*)groupId;

//获取听众邀请列表
-(void)getInviteFansList:(NSString *)userId  groupId:(NSString*)groupId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//请求邀请听众
-(void)inviteFans:(NSString*)groupId  userId:(NSString*)userId fansId:(NSString*)fansId;

//听众中搜索
-(void)inviteSearch:(NSString *)searchString userId:(NSString *)userId personId:(NSString *)personId pageIndex:(NSInteger)pageIndex;
//请求消息设置信息
-(void)getPushSetMessage:(NSString *)userId;

//请求更新消息设置
-(void)updatePushSet:(NSString *)userId type:(NSString *)type status:(NSString *)status;

//请求批量更新消息设置
-(void)updatePushSettings:(NSString *)userId settingArr:(NSMutableDictionary *)setingDic;


//请求退出社群
-(void)quitGroups:(NSString *)groupId  userId:(NSString*)userId;

//请求我的受邀列表
-(void)getMyInviteList:(NSString*)userId type:(NSString*)type page:(NSInteger)page pageSize:(NSInteger)pageSize;

//请求处理社群申请
-(void)handleGroupApply:(NSString *)groupId reqUserId:(NSString *)reqUserId resUserId:(NSString *)resUserId dealType:(NSString *)dealType losgId:(NSString *)losgId;

//请求处理社群邀请
-(void)handleGroupInvitation:(NSString *)groupId reqUserId:(NSString *)reqUserId resUserId:(NSString *)resUserId dealType:(NSString *)dealType losgId:(NSString *)losgId;

//请求初始化推送设置
-(void)initPushSettings:(NSString*)userId;


//请求获取社群的权限
-(void)getGroupPermission:(NSString*)groupId;

//请求设置社群的权限
-(void)setGroupPermission:(NSString*)groupId userId:(NSString*)userId joinStatus:(NSInteger)joinStatus publishStatus:(NSInteger)publishStatus inviteStatus:(NSInteger)inviteStatus publishArray:(NSArray*)publishArray inviteArray:(NSArray*)inviteArray;


//请求问答点赞
- (void)updateAnserSupportCount:(NSString *) userId anserId:(NSString *)anserId type:(NSString *)type updateType:(NSString *)updateType updateNum:(NSString *)num;

//请求问答评论
- (void)submitAnwserComment:(NSString *)userId answerId:(NSString *)answerId content:(NSString *)content parentid:(NSString *)parentid reUserId:(NSString *)reUserId;

//请求获取问答评论
-(void)getAnswerCommentList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize  answerId:(NSString*)answerId parentId:(NSString *)parentId;


//请求提问
-(void)askQuest:(NSString*)uid expertId:(NSString*)expertId question:(NSString*)content type:(NSString *)type questionTag:(NSString *)questionTag tradeId:(NSString *)tradeId;

//找回密码
-(void) findPwd:(NSString *)mobile;


//校验找回密码中的验证码
-(void)checkCode:(NSString*)findpwdId  code:(NSString*)code;

//重置密码
-(void)resetPwd:(NSString*)uname findId:(NSString*)findId  newPWD:(NSString*)pwd;

//上传头像
-(void)uploadMyImg:(NSString*)userId  uname:(NSString*)uname imgStr:(NSString *)imgStr;

//获取别人申请加入社群的列表
//-(void)getRequestJoinList:(NSString*)userID;

//获取创建的社群数量
-(void)getCreateGroupCount:(NSString*)userId;

//获取多个城市的薪资百分比
//-(void)getSomeCitySalaryRank:(NSString*)regionIds zw:(NSString*)zw salary:(NSString*)salary  haveKW:(BOOL)haveKW;

//根据薪资段获取百分比
-(void)getSalaryRankByMoney:(NSString*)money regionId:(NSString*)regionId zw:(NSString*)zw;

//获取邀请短信
-(void)getInviteSMS:(NSString*)groupId  name:(NSString*)groupName number:(NSString*)groupNumber;


//获取工作申请记录列表
-(void)getWorkApplyList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//获取职位详情
-(void)getPositionDetails:(NSString *)positionId;

//请求收藏职位
-(void)collectPosition:(NSString *)userId positionId:(NSString *)positionId;

//请求职位申请记录、收藏记录、面试通知、谁看过我 的数量
-(void)getResumeCenterMessage:(NSString *)userId;


//搜索工作列表
-(void)getFindJobList:(NSString*)tradeId regionId:(NSString*)reginId  kw:(NSString*)kw time:(NSString *)timeNum eduId:(NSString *)eduId workAge:(NSString *)workAge workAge1:(NSString *)workAge1 payMent:(NSString *)payMent workType:(NSString *)workType page:(NSInteger)page pageSize:(NSInteger)pageSize highlight:(NSString *)highlight;

//申请单个职位
-(void)applyOneZW:(NSString*)userId zwid:(NSString*)zwid cid:(NSString*)cid jobName:(NSString*)jobName;

//申请职位，可批量
-(void)applyZWWithList:(NSArray *)zwArray userId:(NSString*)userId;

//请求职位收藏列表
-(void)getPositionApplyCollectList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求删除收藏职位
-(void)deleteCollectPosition:(NSString *)userId positionId:(NSString *)positionId;

//请求面试通知列表
-(void)getInterviewMessageList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求面试通知详情
-(void)getInterviewMessageDetail:(NSString *)interviewId readStatus:(NSString *)status;


//请求简历访问列表
-(void)getResumeVisitList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求刷新简历
-(void)refreshResume:(NSString *)userId;

//请求求职状态
-(void)getResumeStatus:(NSString *)userId;

//请求更新求职状态
-(void)updateResumeStatus:(NSString *)userId statusKey:(NSString *)statusKey;


//请求企业HR问答
-(void)getCompanyHRAnswerList:(NSString*)cid pageIndex:(NSInteger)pageIndex;

//请求企业办公环境
-(void)getCompanyEnvironment:(NSString*)cid;

//请求企业用人理念
-(void)getCompanyEmployee:(NSString*)cid;

//请求企业员工分享
-(void)getCompanyShare:(NSString*)cid;

//请求企业团队
-(void)getCompanyTeam:(NSString*)cid;

//请求企业未来
-(void)getCompanyDevelopment:(NSString*)cid;


//请求更新简历保密设置
-(void)updateResumeVisible:(NSString *)userId limitsKey:(NSString *)limitsKey;

//请求公司所有职位
-(void)getCompanyAllZWList:(NSString*)cid  pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

//请求简历保密设置状态
-(void)getResumeVisible:(NSString *)userId;

//请求简历路径
-(void)getResumePath:(NSString *)userId contactType:(NSString *)contactType tradeid:(NSString *)tradeid templateName:(NSString *)templateName;

//请求职同道合列表
-(void)getTheSamePersonList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求相关雇主列表
-(void)getRelatedCompanyList:(NSString*)totalId  pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//向雇主HR提问题
-(void)askCompanyHR:(NSString*)userId  content:(NSString*)content type:(NSString*)type  companyId:(NSString*)companyId;

//请求教育背景
-(void)getEdusInfo:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求更新教育背景
-(void)updateEdusInfo:(NSString *)userId startTime:(NSString *)startTime endTime:(NSString *)endTime schoolName:(NSString *)schoolName majorType:(NSString *)majorType majorName:(NSString *)majorName eduId:(NSString *)eduId edusId:(NSString *)edusId;

//请求添加教育背景
-(void)addEdusInfo:(NSString *)userId startTime:(NSString *)startTime endTime:(NSString *)endTime schoolName:(NSString *)schoolName majorType:(NSString *)majorType majorName:(NSString *)majorName eduId:(NSString *)eduId;

//请求灌薪水文章列表
-(void)getSalaryArticle:(NSString*)job pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString*)userId;

#pragma mark 灌薪水和评论的列表
- (void)getSalaryArticleAndCommentList:(NSString *)articleId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString*)userId;
 
//发表灌薪水文章
-(void)shareSalaryArticle:(NSString*)userId  job:(NSString*)job  title:(NSString*)title content:(NSString*)content sourceId:(NSString*)articleId;

//请求设置昵称
-(void)updateNickName:(NSString *)userId nickName:(NSString *)nickName;

//获取某人在社群内的权限
-(void)getPermissionInGroup:(NSString*)groupId  userId:(NSString*)userId;

//获取文档信息
-(void)getArticleFileInfo:(NSString*)articleId;

//请求关注企业
-(void)addAttentionCompany:(NSString *)userId companyId:(NSString *)companyId;

//请求取消关注企业
-(void)cancelAttentionCompany:(NSString *)userId companyId:(NSString *)companyId;

//请求企业关注列表
-(void)getAttentionCompanyList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求上传图片数据
-(void)uploadImgData:(NSString*)imgCode;

//分享成功后调用
-(void)shareSuccessLogs:(NSString*)type url:(NSString*)url  userId:(NSString*)userId role:(NSString*)role shareType:(NSString*)shareType;

//请求获取薪酬预测
-(void)getSalaryPrediction:(NSString *)keyWord;

//请求职导列表推荐行家
-(void)getSalaryExpert:(NSString *)userId;

//请求简历对比数据
-(void)getResumeRcomparison:(NSString *)userId personId:(NSString *)personId personSalary:(NSString *)personSalary;

//请求所有消息类型的列表
-(void)getMessageList:(NSInteger)pushType msgType:(NSString*)msgType status:(NSInteger)status userId:(NSString*)userId;

//请求一种消息类型的列表
-(void)getOneMessageList:(NSInteger)pushType msgType:(NSString*)msgType status:(NSInteger)status userId:(NSString*)userId pageSize:(NSInteger)pageSize page:(NSInteger)pageIndex;

//请求提交问卷调查
-(void)addQuestionnaireWithItemId:(NSString *)itemId userId:(NSString *)userId userInfoDic:(NSMutableDictionary *)userInfoDic conditionDic:(NSMutableDictionary *)conditionDic;

//请求Hi模块的数据列表
-(void)getYL1001HIList:(NSString*)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求用户详情
-(void)getPersonDetailWithPersonId:(NSString *)personId userId:(NSString *)userId;

//请求公司登录
-(void)companyLogin:(NSString*)userName pwd:(NSString*)pwd safeCode:(NSString*)safeCode;

//请求绑定公司的信息
-(void)companyHRDetail:(NSString*)companyId;

//企业搜简历
-(void)companySearchResumeCompanyId:(NSString *)companyId regionId:(NSString *)regionId eduId:(NSString *)eduId workeAge:(NSString *)gznum workeAge1:(NSString *)gznum1 keyWord:(NSString *)keyword pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchType:(NSString *)searchType;

//请求绑定公司的面试确认通知
-(void)companyInterviewEmail:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求绑定公司的人才提问
-(void)companyQuestion:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//请求绑定公司的未读简历
-(void)companyResume:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize jobid:(NSString*)jobid searchModal:(SearchParam_DataModal *)searchModal;

//请求简历预览的url
-(void)getResumeURL:(NSString*)userId roletype:(NSString*)roletype companyId:(NSString*)companyId analyze:(NSString *)analyze;
//请求推荐简历预览
-(void)getRecReportURL:(NSString*)userId roletype:(NSString*)roletype companyId:(NSString*)companyId tjtype:(NSString *)tjtype tjid:(NSString *)tjid;

//简历预览二维码请求
-(void)getResumeZbar:(NSString *)personId roletype:(NSString *)roletype companyId:(NSString *)companyId;

//请求职位详情3GURL
- (void)getPositionDetail3GURLWithUserId:(NSString *)userId positionId:(NSString *)positionId location:(NSString *)location;

//回答绑定公司中的问题
-(void)doHRAnswer:(NSString*)companyId  questionId:(NSString*)qId answererId:(NSString*)answererId content:(NSString*)content;

//设置简历是否合适
-(void)setResumePass:(NSString*)resumeId isPass:(NSString*)isPass crnd:(NSString*)crnd;

//获取绑定公司的其他HR列表
-(void)getCompanyOtherHR:(NSString*)companyId;

//转发简历（企业）
-(void)transpondResume:(NSString*)companyId personId:(NSString*)personId flag:(NSString*)flag title:(NSString*)title email:(NSString*)email conditionArr:(NSDictionary *)condictionDic;

//转发简历（顾问）
-(void)transpondResume:(NSString*)owerId personId:(NSString*)personId email:(NSString*)email title:(NSString*)title conditionArr:(NSDictionary *)condictionDic;


//获取公司面试模板
-(void)getInterviewModel:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//获取公司在招职位
-(void)getCompanyZWForUsing:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//发送面试通知
-(void)sendInterview:(NSString*)type  jianliId:(NSString*)jianliId  tradeId:(NSString*)tradeId companyId:(NSString*)companyId personId:(NSString*)personId zpId:(NSString*)zpId mailtext:(NSString*)mailtext year:(NSString*)year month:(NSString*)month day:(NSString*)day hour:(NSString*)hour min:(NSString*)min address:(NSString*)address pname:(NSString*)pname phone:(NSString*)phone offerId:(NSString *)offerId templname:(NSString*)templname isOfferPartyInvite:(BOOL)isOfferParty loginId:(NSString *)loginId recommndId:(NSString *)recommndId interviewType:(NSString *)interviewType;

//获取服务信息的url
-(void)getServiceUrl:(NSString*)companyId;

//文章添加赞
-(void)addArticleLike:(NSString*)articleId;

//评论添加赞
-(void)addCommentLike:(NSString*)commentId type:(NSString *)type;

//绑定企业和个人
-(void)bindingCompany:(NSString*)companyId personId:(NSString*)personId synergyId:(NSString *)synergyId;

//获取绑定的企业账号
-(void)getBindingCompany:(NSString*)personId;

//获取职位名称
- (void)getPositionNameWith:(NSString *)positionId;

//请求公司详情3GURL
- (void)getCompanyDetail3GURLWithUserId:(NSString *)userId companyId:(NSString *)companyId;

//设置简历已阅
-(void)setNewMailRead:(NSString*)companyId personId:(NSString*)personId cmailId:(NSString*)cmailId;

//添加关注学校
- (void)attendCareerSchoolWithSchollId:(NSString *)schoolId_ userId:(NSString *)userId;


//取消关注学校
- (void)changAttendCareerSchoolWithSchoolId:(NSString *)schoolId_ userId:(NSString *)userIds;

//请求我关注学校列表
- (void)getAttendSchoolListWithUserId:(NSString *)userId pageSize:(NSInteger)pageSize_ pageIndex:(NSInteger)pageIndex_;

//请求学校宣讲会列表
- (void)getSchoolXJHListWithSchoolId:(NSString *)schoolId_ pageSize:(NSInteger)pageSize_ pageIndex:(NSInteger)pageIndex_;

//请求薪资大比拼结果（新）
-(void)getSalaryCompareResult:(NSString*)userId zw:(NSString*)zw kwflag:(NSString*)kwflag salary:(NSString*)salary regionId:(NSString*)regionId bg:(NSString*)bg;

//上传语音文件
- (void)upLoadVoiceFile:(NSData *)data fileName:(NSString *)name;
//请求薪资搜索比拼结果（新）
-(void)getSalarySearchResult:(NSString*)zw kwflag:(NSString*)kwflag salary:(NSString*)salary regionId:(NSString*)regionId userId:(NSString*)userId tradeId:(NSString*)tradeId tradeName:(NSString*)tradeName;

//请求解除绑定
-(void)cancelBindCompany:(NSString*)companyId  personId:(NSString*)personId;

//上传图片
-(void)uploadPhotoData:(NSData *)data name:(NSString *)name;

//简历添加图片
-(void)addResumePhoto:(NSString *)userId oldPhotoId:(NSString *)oldPhotoId photoModel:(Upload_DataModal *)model requestType:(NSString *)requestType;

//获取简历图片语音
- (void)getResumePhotoAndVoice:(NSString *)userId;

//删除简历图片
- (void)deleteResumeImage:(NSString *)userId photoId:(NSString *)photoId;

//添加简历语音
- (void)addResumeVoice:(NSString *)userId voiceName:(NSString *)voiceName voiceDesc:(NSString *)voiceDesc voicePath:(NSString *)voicePath voiceTime:(NSString *)voiceTime voiceId:(NSString *)voiceId voiceCateId:(NSString *)voiceCateId type:(NSString *)type;

//注册时请求添加关注学校
- (void)addAttentionSchoolWithUserId:(NSString *)userId schoolName:(NSString *)schoolName;

//请求hi模块的行家搜索
-(void)getHISearchExpertList:(NSString*)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize expertName:(NSString*)expertName;

//获取身边工作
- (void)getNearbyWork:(NSString *)searchType_ keyWords:(NSString *)keyWords_ keyType:(NSString *)keyType_ majorId:(NSString *)majorId_ totalId:(NSString *)totalId_ tradeId:(NSString *)tradeId_ lng:(NSString *)lng_ lat:(NSString *)lat_ range:(NSString *)range_ pageSize:(NSString *)pageSize_ pageIndx:(NSString *)pageIndex_;

//第三方登录 判断是否绑定
- (void)detectBindingWithConnectSource:(NSString *)connectSource_ openId:(NSString *)openId_;

//常见账号并绑定第三方账号
- (void)bulidPersonWithConnectSource:(NSString *)connectSource_ openId:(NSString *)openId_ userName:(NSString *)userName_ nickName:(NSString *)nickName_ sex:(NSString *)sex_ picSmall:(NSString *)picSmall_ picMiddle:(NSString *)picMiddle_ picOriginal:(NSString *)picOriginal_;

//个人主页访问统计
-(void)myCenterVisitLog:(NSString*)userId visitorId:(NSString*)visitorId;

//更新社群信息
- (void)updateGroups:(NSString *)userId_ groupId:(NSString *)groupId_ groupName:(NSString *)groupName_ groupIntro:(NSString *)groupIntro_ groupTag:(NSString *)groupTag_ openStatus:(NSString *)openStatus_ groupPic:(NSString *)groupPIC_;

//获取校园招聘活动分享的url
-(void)getSchoolZPShareUrl:(NSString*)userId  zwId:(NSString*)zwid;

//获取同行
- (void)getSameTradePerson:(NSString *)userId_ pageIndex:(NSInteger)pageIndex_;

//获取听众和我的关注
-(void)getFriendWithUserId:(NSString *)userId_ followType:(NSString *)type_ visitorPid:(NSString *)visitorPid_ isnew:(NSString *)isnew_ loginLastTime:(NSString *)lastTime_ pageIndex:(NSInteger)pageIndex_ pageSize:(NSInteger)pageSize_;

//获取听众邀请列表
-(void)getFriendWithUserId:(NSString *)userId_ pageIndex:(NSInteger)pageIndex_ pageSize:(NSInteger)pageSize_ groupId:(NSString *)groupId personIname:(NSString *)personIname;

//获取同行中新朋友和新评论的数量
- (void)getNewFriendAndComment:(NSString *)userId homeTime:(NSString *)time;

//获取我的文章评论列表
-(void)getMyArticleCommentList:(NSString *)userId_ homeTime:(NSString *)time pageIndex:(NSInteger)pageIndex_ pageSize:(NSInteger)pageSize_;

//获取主页中心信息
- (void)getPersonCenterData:(NSString *)userId loginPersonId:(NSString *)loginPersonId;

//获取最新评论列表（消息模块）
-(void)getMyCommentList:(NSString*)userId pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex;

//获取关于我的系统通知（消息模块）
-(void)getMySystemNotificationList:(NSString*)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageindex;

//获取打招呼列表（消息模块）
-(void)getSayHiList:(NSString*)userId type:(NSInteger)type pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex showtime:(NSString*)showtime;

//获取留言列表(消息模块)
-(void)getLetterList:(NSString*)userId pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex;

//获取社群消息列表（消息模块）
-(void)getGroupMessageList:(NSString*)userId pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex showtime:(NSString*)showtime;

//获取默认标签
- (void)getTagsList:(NSString *)tagsType;

//修改标签
- (void)updateTagsList:(NSString *)userId tagListString:(NSString *)tagListString tagType:(NSString *)tagType;

//打招呼
- (void)sendMessage:(NSString *)userId_ type:(NSString *)type_ inviteId:(NSString *)inviteId_;

//请求我的问答列表（消息）
-(void)getMyAQList:(NSString*)userId type:(NSInteger)type pageInde:(NSInteger)pageIndex pageSize:(NSInteger)pageSize showtime:(NSString*)showtime;

//回答专访问题
- (void)answerInterviewQuestion:(NSString *)userId_ questId:(NSString *)questId_ answerContent:(NSString *)answerContent;

//获取小编专访列表
- (void)getInterviewList:(NSString *)userId pageSize:(NSInteger)pageSize_ pageIndex:(NSInteger)pageIndex_;

//是否有权限查看更多小编专访
- (void)getShowMoreAnswer:(NSString *)userId;

//获取消息模块的各项新消息数
-(void)getMessageCnt:(NSString*)userId;

//找他搜索
- (void)getTraderPeson:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex keyWord:(NSString *)keyWord isExpert:(NSString *)expert withJobType:(NSInteger)type;

//获取社群数量
- (void)getGroupsCount:(NSString *)userId;

//获取企业收藏简历的列表
-(void)getCompanyCollectionResume:(NSString *)companyId isGroup:(NSString *)isgroup pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex searchModel:(SearchParam_DataModal *)searchModel;

//企业收藏简历
-(void)collectResume:(NSString*)companyId personId:(NSString*)personId;

//搜索灌薪水文章
-(void)getSalaryArticleByES:(NSString*)kw pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize personId:(NSString *)personId;

//查看简历完整度
- (void)getResumeComplete:(NSString *)userId;

//删除文章
- (void)deleteArticle:(NSString *)userId articleId:(NSString *)articleId;

//举报非法文章
-(void)toReportIllegalArticle:(NSString *)title  content:(NSString*)content personId:(NSString*)personId productCode:(NSString*)code productId:(NSString*)productId;

//社群话题置顶列表
- (void)setRecommendArticle:(NSString *)groupId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

//修改置顶话题
- (void)saveRecommendSet:(NSString *)groupId userId:(NSString *)userId articleId:(NSString *)articleId type:(NSString *)type;

//删除社群文章
- (void)deleteGroupArticle:(NSString *)userId groupId:(NSString *)groupId articleId:(NSString *)articleId;

// pc扫描二维码登录
- (void)scanQrcodeWithCompanyId:(NSString *)companyId userId:(NSString *)userId url:(NSString *)url;

//授权登录
- (void)authorizedLoginWithCompanyId:(NSString *)companyId userId:(NSString *)userId url:(NSString *)url;

// 获取行业标签
- (void)getTradeTagsList;

// 获取职业标签
- (void)getJobTagsListWithTradeId:(NSString *)tradeId;

// 无法获取验证码时 第一步操作
- (void)getServiceNumberWithPhone:(NSString *)phone;

//无法获取验证码注册
- (void)registNoCodeWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code snumber:(NSString *)snumber;

////记录用户当前状态
//-(void)markStatus:(int)status;

//获取有社群邀请权限的社群
- (void)getInveteGroupWithUserId:(NSString *)userId vistorId:(NSString *)vistorId;

//请求个人信息
- (void)getPersonInfoWithPersonId:(NSString *)personId;

// 获取公司推荐的简历
- (void)getCompanyRecommendedResume:(NSString *)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize jobid:(NSString *)jobid searchModal:(SearchParam_DataModal *)searchModal;

//公司查看用户的简历的联系信息
- (void)downloadResume:(NSString *)companyId userId:(NSString *)userId;

// 企业是否能够查看人才联系方式(用于预览推荐简历时是下载，还是发送面试通知)
- (void)companyIslookPersonContact:(NSString *)companyId userId:(NSString *)userId;

//设置推荐的简历已经阅读
- (void)setRecommendResumeReaded:(NSString *)recommendId;

//验证用户名
- (void)doValidUserName:(NSString *)userName;


//简历评价标签
-(void)getResumeCommentTagList:(NSString *)type;

//获取下载简历列表
-(void)getDownloadResumeList:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize search:(SearchParam_DataModal *)searchModel;

//获取简历评价列表
-(void)getResumeCommentList:(NSString*)companyId personId:(NSString*)personId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//其他关联企业账号
-(void)getOtherCompanyAccountList:(NSString*)companyId jobId:(NSString*)jobId;

//添加简历评价
-(void)addResumeComment:(NSString*)companyId cmailId:(NSString*)cmailId personId:(NSString*)personId author:(NSString*)author content:(NSString*)content type:(NSString*)type mid:(NSString*)mid jobId:(NSString*)jobId;


//分享文章到动态
-(void)shareArticleDynamicArticleId:(NSString *)article_id andPersonId:(NSString *)person_id;

//接收到推送消息后的回调
-(void)receiveMessageType:(NSString*)type messageId:(NSString*)messageId;

//请求简历信息
- (void)getResumeInfoWithPersonId:(NSString *)personId;

//更新简历信息
- (void)updateResumeInfoWithPersonId:(NSString *)personId personDetailModel:(PersonDetailInfo_DataModal *)model;

//获取想学技能行业标签
- (void)getSkillTradeTagsList;

//获取热门标签和第一个标签的子标签
- (void)getHotTagAndChildTag:(NSString *)tradeId;

//根据二级标签获取第三级标签
- (void)getTagsBySecondTag:(NSString *)secondTagId;

#pragma mark - 获取屏蔽公司列表
- (void)getSheidCompanyList:(NSString *)personId;

#pragma mark - 搜索公司
- (void)getCompanyWithCompanyName:(NSString *)name pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

#pragma mark - 设置或取消屏蔽公司
- (void)setSheidCompanyWithPersonId:(NSString *)personId companyList:(NSMutableArray *)companyArray;

//徽章列表
-(void)getMyBadgesListWithPageIndex:(NSInteger)page pageSize:(NSInteger)page_size personId:(NSString *)personId;

//用户声望
-(void)getMyPrestige:(NSString *)presonId;

//首页顶部的广告
-(void)getTopAD:(NSString*)userId Type:(NSString *)type;

//声望列表
-(void)getMyPrestigeList:(NSString *)personId pageIndex:(NSInteger)page pageSize:(NSInteger)pageSize;

#pragma mark - 个人中心接口1
- (void)getPersonCenter1:(NSString *)userId loginPersonId:(NSString *)loginPersonId;

#pragma mark - 个人中心接口2
- (void)getPersonCenter2:(NSString *)userId loginPersonId:(NSString *)loginPersonId;

//订单记录列表
-(void)getOrderRecord:(NSString *)rodcoId pageSize:(NSInteger)pagesize serviceCode:(NSString *)code gwcFor:(NSString *)gwcFor pageIndex:(NSInteger)page;
 
#pragma mark 获取服务的信息
- (void)getOrderServiceInfo:(NSString *)serviceType;

#pragma mark 简历推荐服务信息
- (void)getResumeApplyServiceInfo:(NSString *)userId;

#pragma mark 购物车订单生成
- (void)genShoppingCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId expertId:(NSString *)expertId;

#pragma mark 简历直推申请
- (void)applyResumeRecommend:(NSString *)userId serviceDetailId:(NSString *)serviceDetailId;

#pragma mark 购物车订单生成
- (void)genShoppingCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId number:(NSInteger)num expertId:(NSString *)expertId;

#pragma mark 获取用户是否购买过服务
- (void)getServiceStatus:(NSString *)ownerType userId:(NSString *)userId serviceCode:(NSString *)serviceCode;

#pragma mark 简历推送的状态
- (void)getResumeApplyStatus:(NSString *)userId;

#pragma mark 根据订单ID获取微信支付的prepay ID
- (void)getWXPrepayId:(NSString *)orderId;

#pragma mark 获取新的同行
- (void)getNewSameTradePerson:(NSString *)userId_ expertFlag:(NSString *)expertFlag pageIndex:(NSInteger)pageIndex_;

#pragma mark 查询薪酬纪录的列表
- (void)getQuerySalaryList:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark 记录点击通知时的日志
-(void)postMessageClickLog:(NSString*)userId messageId:(NSString*)messageId title:(NSString*)title type:(NSString*)type time:(NSString*)time;

#pragma mark 简历比较
- (void)resumeCompareWithUserId:(NSString *)myId anotherId:(NSString *)anotherId;

#pragma mark 请求薪资搜索比拼结果（新）
-(void)getSalarySearchResult2:(NSString*)zw kwflag:(NSString*)kwflag salary:(NSString*)salary regionId:(NSString*)regionId userId:(NSString *)userId tradeId:(NSString *)tradeId tradeName:(NSString *)tradeName orderId:(NSString *)orderId;

#pragma mark 获取薪职服务的类型
- (void)getSalaryServiceType;

#pragma mark 查薪订单列表
-(void)getSalaryOrderRecord:(NSString *)personId pageSize:(NSInteger)pagesize  pageIndex:(NSInteger)page;

#pragma mark 获取查薪指的次数
- (void)getSalaryQueryCountWithUserId:(NSString *)userId;

#pragma mark 纪录广告点击量
- (void)addAdClickCount:(NSString *)adId userId:(NSString *)userId clientId:(NSString *)clientId;

#pragma mark 今日看点列表
- (void)getTodayFoucsListByUserId:(NSString *)userId currentPage:(NSInteger)page pageSize:(NSInteger)pageSize;

//请求职业群、公司群列表
-(void)getMyGroupsJobWithCompanyList:(NSString *)userId group_source:(NSInteger)source pageIndex:(NSInteger)page pageSize:(NSInteger)pageSize tradeId:(NSString *)tradeId totalId:(NSString *)totalId code:(NSString *)code;

//搜索社群话题列表
-(void) searchGroupsArticleList:(NSString*)groupId  user:(NSString *)userId keyWord:(NSString *)keyWord page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize topArticle:(NSString *)topArticle;

//灌薪水三种类型选择
-(void)getSalaryTypeWithOwn_id:(NSString *)own_id getJingFlag:(NSString *)get_jing_flag getSysFlag:(NSString *)get_sys_flag page:(NSInteger)page pageSize:(NSInteger)page_size type:(NSInteger)type;

//请求加入社群无提示
-(void)joinGroupTwo:(NSString *)userId group:(NSString *)groupId content:(NSString *)content;

//公司群添加评论
-(void) addComment:(NSString *)objectId parentId:(NSString *)parentId userId:(NSString *)userId content:(NSString *)content  proID:(NSString*)proid insider:(NSString *)insider;

#pragma mark 薪水入口列表
-(void)getSalaryArticleListWithUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

#pragma mark 薪水导航列表
-(void)getSalaryNavList;

#pragma mark - 我的消息
-(void)getMessageWith:(NSString *)userId;

#pragma mark - 最新发表
- (void)getNewPublicArticle:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;


#pragma mark 列表头部按钮顺序(职位列表，社群列表，薪指列表)
-(void)getTableViewHeadButtonList:(NSInteger)type;


#pragma mark 职业列表
- (void)getProfessionList;

#pragma mark 第三级职业列表
- (void)getProfessionChildListWithParentName:(NSString *)pName;

//公司群热门行业分类
-(void)getTradeType:(NSInteger)page page_size:(NSInteger)pageSize;


#pragma mark 查工资页面的热门专业列表
-(void)getSalaryHotJobList:(NSInteger)type;

#pragma mark 薪指预测图表
- (void)getSalaryMap:(NSString *)regionId position:(NSString *)position;

#pragma mark - 更多热门专业列表
-(void)getMoreHotIndustry;

#pragma mark - 看前景薪酬预测
- (void)getSalaryForecastWithZyName:(NSString*)zyName minWorkAge:(NSString *)minWorkAge maxWorkAge:(NSString *)maxWorkAge matchModel:(NSString *)matchModel;

#pragma mark - 分享信息给好友
-(void)getShareMessageWithSend_uid:(NSString *)sendUid receiveId:(NSString *)receiveId receiveName:(NSString *)receiveName content:(NSString *)centent dataModal:(ShareMessageModal *)shareDataModal;

#pragma mark - 红点消除
-(void)delegateMessageShow:(NSString *)userId;

#pragma mark 获取曝工资评论的标题
- (void)getExposureTitle;

#pragma mark 获取曝薪资总数
-(void)getExposureSalaryNum;

#pragma mark 保存曝工资的信息
- (void)saveExposureSalaryInfo:(NSString *)companyName job:(NSString *)job salary:(NSString *)salary regionId:(NSString *)regionId userId:(NSString *)userId article:(NSString *)articleId comment:(NSString *)comment clientId:(NSString *)clientId;

#pragma mark - 谁赞了我列表
-(void)getWhoLikeMeListPersonId:(NSString *)person_id page:(NSInteger)page pageSize:(NSInteger)pageSize;

- (void)getHrMessageWithLoginId:(NSString *)userId visitorId:(NSString *)visitorId;

#pragma mark - 谁赞了我列表红点消除
-(void)deleteWhoLikeMeMessagePersonId:(NSString *)person_id praiseId:(NSString *)praise_id;

#pragma mark - 活动提交报名
-(void)getApplyWithArticleId:(NSString *)article_id personId:(NSString *)person_id personIname:(NSString *)person_iname personPhone:(NSString *)person_phone personRemark:(NSString *)person_remark personCompany:(NSString *)person_company personGroup:(NSString *)person_group person_jobs:(NSString *)person_jobs person_email:(NSString *)person_email;

#pragma mark offer派列表
- (void)getOfferPartyListByCompanyId:(NSString *)companyId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

#pragma mark user offer派列表
- (void)getUserOfferPartyListByUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize fromeType:(NSString *)type;

#pragma mark user offer派公司列表
- (void)getUserOfferPartyCompanyList:(NSString *)userId offerPartyId:(NSString *)offerPartyId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

#pragma mark offer派投递简历
- (void)deliverResumeToOfferParty:(NSString *)offerPartyId userId:(NSString *)userId companyId:(NSString *)companyId jobId:(NSString *)jobId;

#pragma mark  offer派所有公司列表 职位的公司
- (void)getOfferPartyCompanyList:(NSString *)offerPartyId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;

#pragma mark offer派 人数统计
- (void)getOfferPartyPersonCnt:(NSString *)offerPartyId companyId:(NSString *)companyId withFromType:(NSString *)fromType;

#pragma mark 获取企业的信息
- (void)getCompanyInfoById:(NSString *)companyId;

#pragma mark offer派分类简历列表
//- (void)getOfferPersonList:(NSString *)offerPartyId companyId:(NSString *)companyId personType:(NSString *)personType keywords:(NSString *)keywords searchDic:(NSDictionary *)searchDic pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize salerName:(NSString *)salerName;

#pragma mark 批量处理简历的状态
- (void)dealResumeStates:(NSArray *)resumeIdArray state:(NSString *)state type:(NSString *)type role:(NSString *)role roleId:(NSString *)roleId;

#pragma mark - 获取HR顾问绑定状态
- (void)bingdingStatusWith:(NSString *)userId;

#pragma mark - 招聘顾问登录
- (void)gunwenLoginWith:(NSString *)oaUserName pswd:(NSString *)oaPswd userId:(NSString *)userId;

#pragma mark - 顾问解绑
- (void)gunwenJieBang:(NSString *)salerid personId:(NSString *)personId;

#pragma mark - 附近职位
- (void)nearWorksWithLng:(NSString *)lng Lat:(NSString *)lat Range:(NSInteger)range keWord:(NSString *)keyWords tradeId:(NSString *)tradeId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize geo_diff:(NSInteger)geo_diff;

#pragma mark - 顾问搜索简历
- (void)gunwenSearchResume:(NSString *)keyWords tradeId:(NSString *)tradeId regionId:(NSString *)regionId gznum:(NSString *)gznum gznum1:(NSString *)gznum1 rctypes:(NSString *)rctypes personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex withIsTotal:(BOOL)isTotal searchType:(NSString *)searchType salerName:(NSString *)salerName;

#pragma mark - 顾问已下载简历列表
- (void)guwenLoadResumeList:(NSString *)salerId keywords:(NSString *)keywords pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 顾问已推荐简历列表
- (void)guwenRecomResumeList:(NSString *)personId keywords:(NSString *)keywords pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 顾问打电话OA
- (void)guwenCallPerson:(NSString *)saler_uname personId:(NSString *)personId personMmobile:(NSString *)personMobile;

#pragma mark - 顾问下载简历
- (void)gunwenLoadResume:(NSString *)salerName rencaiId:(NSString *)rencaiId;

#pragma mark - 下载人才联系
- (void)gunwenLoadConstanct:(NSString *)salerName rencaiId:(NSString *)rencaiId;

#pragma mark - 根据意向职位搜索在招企业
- (void)gunwenSearchCompany:(NSString *)job tradeid:(NSString *)tradeid personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex regionId:(NSString *)regionId gznum:(NSString *)gznum rctypes:(NSString *)rctypes;

#pragma mark - 顾问获取行业
- (void)gunwenTrade:(NSString *)personId;

#pragma mark - 推荐简历
- (void)recommendPerson:(NSString *)rcPersonId salerUname:(NSDictionary *)salerUname companyStr:(NSArray *)companyArr zwName:(NSString *)zwName;

#pragma mark - 上传通讯录判断
-(void)getIsUpdateAddressBook:(NSString *)personId;

#pragma mark - 上传手机通讯录
-(void)updateAddressBook:(NSDictionary *)dic IsFirst:(BOOL)isFirst personId:(NSString *)personId ylPerson:(BOOL)ylPerson groupId:(NSString *)groupId;

#pragma mark - 一览通讯录好友列表
-(void)addressBookListPage:(NSInteger)page pageSize:(NSInteger)pageSize personId:(NSString *)personId ylPerson:(BOOL)ylPerson groupId:(NSString *)groupId;

#pragma mark - 获取顾问联系记录数量
- (void)consultantVisitNum:(NSString *)selaName;


#pragma mark - 获取招聘顾问回访简历列表
- (void)getGuwenVistList:(NSString *)salerUsername type:(NSString *)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark 个人参与offerparty的数量
- (void)getPersonOfferPartyCount:(NSString *)userId;

#pragma mark - 点击通讯录好友发送请求
-(void)sendAddressBookFriend:(NSString *)personId contactId:(NSString *)contactId;

#pragma mark - 获取回访列表
-(void)getReplyList:(NSString *)personId type:(NSString *)messageType pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 添加回访记录
-(void)addVisit:(NSString *)saler_id recodeId:(NSString *)recodeId personid:(NSString *)personId content:(NSString *)content type:(NSString *)type;

#pragma mark - 点击互动请求
-(void)sendAddVoteLogsGaapId:(NSString *)gaapId personId:(NSString *)personId clientId:(NSString *)clientId;

#pragma mark - 按类型请求offer派人才列表
//-(void)getPersonListByFairId:(NSString *)jobfair_id personType:(NSString *)person_type status:(NSString *)status salerId:(NSString *)saler_id keywords:(NSString *)keywords pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - offer可推荐企业列表
-(void)getJobFairCompany:(NSString *)jobfair_id personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark = offer批量推荐人才给企业
-(void)recommendPersonToCompany:(NSString *)jobfairid companyID:(NSArray *)companyArray personID:(NSString *)personID salerId:(NSString *)salerId isLineUPFlag:(BOOL)lineUp;

#pragma mark - 顾问offer派中心
-(void)getOfferPartyCount:(NSString *)jobfairId;

#pragma mark - 确认人才到场
- (void)joinPerson:(NSString *)jobfairpersonId jonstate:(NSString *)state roleId:(NSString *)roleId role:(NSString *)role editDesc:(NSString *)editDesc;

#pragma mark 扫描二维码签到
- (void)signInOfferPartyId:(NSString *)offerPartyId userId:(NSString *)userId roleId:(NSString *)roleId role:(NSString *)role;

#pragma mark- 推荐详情列表
- (void)getRecommentInfo:(NSString *)jobfairpersonId;

#pragma mark - 我的消息所有个数
-(void)getAllMessageWith:(NSString *)userId;

#pragma mark - 已确认适合/已发offer/已上岗企业列表
- (void)getItemCompany:(NSString *)item jobfair_id:(NSString *)jobfairid personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 顾问未推荐人才列表
- (void)getUnRecomPersonList:(NSString *)jobfair_id pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 请求提问标签
- (void)getAskQuestTags;

#pragma mark - 文章可点击域名
-(void)getClickDomainList;

#pragma mark - 未阅简历处理
-(void)readMarkWithTuijianId:(NSString *)tuijianId;

#pragma mark - 获取未举办offer派列表
-(void)getLatelyJobfairList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex personId:(NSString *)personId regionId:(NSString *)regionId keyWord:(NSString *)keyWord fromType:(NSString *)fromType jobId:(NSString *)jobId;

#pragma mark - offer派报名
-(void)addPersonToOfferPersonId:(NSString *)personid jobFairId:(NSString *)jobDairId;

#pragma mark - offer最后通话时间
- (void)getLastTelTime:(NSString *)personId;

#pragma mark - 职导行家列表
- (void)getJobGuideExpertList:(NSString *)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize productType:(NSInteger)productType regionId:(NSString *)regionId regionName:(NSString *)regionName;

#pragma mark - 职导行家信息
- (void)getExpertInfo:(NSString *)expertId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize  userId:(NSString *)userId;

#pragma mark - 获取顾问邮箱
-(void)getGuwenEmail:(NSString *)role_id;

#pragma mark - 发送邮件给顾问
-(void)senderResumeToGuwenEmail:(NSString *)role_id personId:(NSString *)person_id email:(NSString *)email;

#pragma mark - 获取问答详情回复列表
-(void)getReplyCommentList:(NSString*)answerId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize;


#pragma mark - 行家评论列表
-(void)getExpertCommentWithExpertId:(NSString *)expertId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

#pragma mark - 职导对行家评论
-(void)getAddExpertComment:(NSString *)userId expertId:(NSString *)expertId content:(NSString *)content type:(NSString *)type typeId:(NSString *)typeId star:(NSString *)star;

#pragma mark - 我的分享文章列表
-(void) getMyShareArticleList:(NSString*)userID page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize status:(NSString*)status;

//#pragma mark - 我的收藏文章/附件
//- (void)getMyFavoriteList:(NSString *)userId type:(NSString *)type;

#pragma mark - 更多应用
- (void)getApplicationList:(NSString *)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize phoneType:(NSInteger)type;

#pragma mark 我的账户
- (void)getMyAccount:(NSString *)userId;

#pragma mark 打赏记录
- (void)getRewardList:(NSString *)userId type:(NSString *)type page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

#pragma mark 提现申请
- (void)cashApply:(NSString *)userId money:(NSString *)money summary:(NSString *)summary  account:(NSString *)account accName:(NSString *)accName;

#pragma mark 打赏订单生成
- (void)genShoppingDaShangCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId tagetUserId:(NSString *)tagetUserId number:(NSString *)num productType:(NSString *)productType productId:(NSString *)productId;

//#pragma mark 行家约谈订单生成
//- (void)genShoppingCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId num:(double)num courseId:(NSString *)courseId mobile:(NSString *)mobile question:(NSString *)question intro:(NSString *)intro;

//余额支付
- (void)payWithyuer:(NSString *)gwc_id;
////企业后台首页广告
//-(void)getHeaderOfferPaiById:(NSString *)companyId;

#pragma mark offer派详情URL
- (void)getOfferPartyDetailUrl:(NSString *)offerPartyId;

#pragma mark 我的约谈
- (void)getAspectantDisListWithUserId:(NSString *)userId status:(NSInteger)status page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize otherCond:(NSString *)otherCond;

#pragma mark - 活动列表
-(void)getActivityListWithPersonId:(NSString *)personId page:(NSString *)page pageSize:(NSString *)pageSize type:(NSInteger)type;

#pragma mark - 活动成员列表
-(void)getActivityPeopleListWithPersonId:(NSString *)personId articleId:(NSString *)articleId page:(NSString *)page pageSize:(NSString *)pageSize;

#pragma mark - 约谈选择课程列表
-(void)getInterViewCourseListWithPersonId:(NSString *)personId;

#pragma mark - 在招职位列表
-(void)getZpListWithCompanyId:(NSString *)companyId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 获取发布网站信息
-(void)getZWFBInfoWithCompanyId:(NSString *)companyId;

#pragma mark - 发布职位
- (void)addPositionWithCompanyId:(NSString *)companyId dataModel:(ZWModel *)model;

#pragma mark - 顾问模块count
- (void)refreshbingdingStatusWith:(NSString *)userId;

#pragma mark - 文章打赏
- (void)getArticleRewardImg:(NSString *)articleId;

#pragma mark - 我的打赏列表
- (void)getMyRewardList:(NSString *)personId userId:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - App综合搜索
-(void)getTodaySearchListKeyWord:(NSString *)keyWord;

#pragma mark - 社群文章列表
-(void)getGroupArticleListPersonId:(NSString *)personId loginPersonId:(NSString *)loginPersonId page:(NSInteger)page pageSize:(NSInteger)pageSize;

#pragma mark - 行家常用地址
-(void)getExpertRegionList:(NSString *)expertId page:(NSInteger)page pageSize:(NSInteger)pageSize;

#pragma mark - 请求搜索更多文章
-(void)getArticleBySearchKeyword:(NSString*)keyword  page:(NSInteger) pageIndex  pageSize:(NSInteger)pageSize;

#pragma mark - 综合搜索之社群搜索
-(void)getTodayMoreGroupSearchWithKeyword:(NSString*)keyword  page:(NSInteger)page  pageSize:(NSInteger)pageSize searchFrom:(NSString *)searchFrom useId:(NSString *)useId;

//转发给我
-(void)getTurnToMeResume:(NSString *)companyId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex searchModel:(SearchParam_DataModal *)searchModel;

#pragma mark - //顾问搜索简历新
-(void)guwenSearchConWithKeyword:(NSString *)keyword salarid:(NSString *)salarId  pageSize:(NSInteger)pageSize page:(NSInteger)page model:(SearchParam_DataModal *)model searchType:(NSString *)searchType;

#pragma mark--新消息列表
-(void)getNewNewsListWithUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

#pragma mark--新建群聊
-(void)newGroupUserId:(NSString *)userId members:(NSArray *)member;

#pragma mark--获取群聊记录列表
-(void)getGroupChatList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize article:(NSString*)articleId parentId:(NSString *)parentId userId:(NSString *)userId;

@end

@interface ExRequetCon : NSObject

@end
