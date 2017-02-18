//
//  ExJSONParser.h
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 主要用于扩展数据解析
 ContactCtl
 @interface JSONParser (Parser)
 ******************************/

#import <Foundation/Foundation.h>
#import "JSONParser.h"
#import "PageInfo.h"

//将解析方法扩展一下
@interface JSONParser (MyParser)

//解析token
-(void) parserAccessToken:(NSDictionary *)dic;
 
//解析登录
-(void) parserLogin:(NSDictionary *)dic;

//解析注册手机
-(void) parserRegestPhone:(NSDictionary *)dic;

//解析注册
-(void) parserRegister:(NSDictionary *)dic;

//解析注册推送
-(void)parsersetSubscribeConfig:(NSDictionary*)dic;

//解析保存个人信息
-(void) parserSaveInfo:(NSDictionary *)dic;

//解析分页信息
-(PageInfo *) parserPageInfo:(NSDictionary *)dic;

//解析薪闻列表
-(void) parserNewsList:(NSDictionary *)dic;

//解析薪闻详情内的推荐专家信息
-(void)parserNewsRecommendExpert:(NSDictionary*)dic;

//解析文章详情
-(void) parserArticleDetail:(NSDictionary *) dic;

//解析评论列表
-(void) parserCommentList:(NSDictionary *)dic;

//解析添加评论
-(void) parserAddComment:(NSDictionary *)dic;

//解析个人信息
-(void) parserUserInfo:(NSDictionary *) dic;

//解析我的社群
-(void) parserMyGroupsList:(NSDictionary *) dic;

//解析推荐社群
-(void) parserRecommendGroupsList:(NSDictionary *) dic;

//解析社群话题列表
-(void)parserGroupArticleList:(NSDictionary*)dic;

//解析我的发表列表
-(void)parserMyPubilshList:(NSDictionary*)dic;

//解析我的社群的话题详情
-(void)parserGroupArticleDetail:(NSDictionary*)dic;

//解析意见反馈
-(void) parserGiveAdvice:(NSDictionary *)dic;

//解析版本检查
-(void) parserVersionCheck:(NSDictionary *)dic;

//解析一览大厅列表
-(void) parserHomeList:(NSDictionary*) dic;

//解析推荐行家列表
-(void) parserExpertList:(NSDictionary*)dic;

//解析关注行家
-(void) parserFollowExpert:(NSDictionary*)dic;

//解析取消关注行家
-(void)parserCaccelFollowExpert:(NSDictionary*)dic;

//解析加入社群
-(void)parserJoinGroup:(NSDictionary*)dic;

//解析专题列表
-(void)parserSubjextList:(NSDictionary*)dic;

//解析专题详情
-(void)parserSubjectDetail:(NSDictionary*)dic;


//解析薪指列表
-(void)parserSalaryList:(NSDictionary*)dic;

//解析精品观点列表
-(void)ParserViewPointList:(NSDictionary*)dic;

//解析精品评论内容
-(void)parserCommentContent:(NSDictionary*)dic;

//解析是否专家
-(void)parserIsExpert:(NSDictionary *)dic;

//解析职导列表
-(void)parserJobGuideList:(NSDictionary *)dic;

//解析职导详情
-(void)parserJobGuideDetail:(NSDictionary*)dic;

//解析修改密码
-(void)parserResetPwd:(NSDictionary*)dic;

//解析薪酬百分比
-(void)parserSalaryPercent:(NSDictionary*)dic;

//解析注册推送
-(void)parserRegistNotifice:(NSDictionary*)dic;

//解析推荐职位
-(void)parserRecommendJob:(NSDictionary*)dic;

//解析找回密码
-(void)parserFindPassword:(NSDictionary*)dic;

//解析应届生薪指列表
-(void)parserFreshSalaryList:(NSDictionary*)dic;

//解析专家问答列表
-(void)parserExpertAnswerList:(NSDictionary*)dic;

//解析问答详情（新）
-(void)parserAnswerDetailNew:(NSDictionary *)dic;

//解析提问专家
-(void)parserAskExpert:(NSDictionary*)dic;

//解析职导问答列表
-(void)parserJobGuideQuesList:(NSDictionary*)dic;

//解析创建的社群列表
-(void)parserCreatedAssociation:(NSDictionary*)dic;

//解析我的已回答列表
-(void)parserMyAnswerList:(NSDictionary*)dic;

//解析我的待回答列表
-(void)parserMyNotAnswerList:(NSDictionary*)dic;

//解析回答问题
-(void)parserAnswerQuestion:(NSDictionary *)dic;

//解析订阅职位
-(void)parserSubscribeJob:(NSDictionary *)dic;

//解析职位订阅列表
-(void)parserJobSubscribedList:(NSDictionary *)dic;

//解析删除职位订阅
-(void)parserDeleteSubscribe:(NSDictionary *)dic;

//解析我的关注/粉丝
-(void)parserMyFollower:(NSDictionary *)dic;

//解析发表文章
-(void)parserShareArticle:(NSDictionary*)dic;

//解析发表话题
-(void)parserPublishTopic:(NSDictionary*)dic;

//解析有权发表话题的社群
-(void)parserGroupsCanPublish:(NSDictionary*)dic;

//解析创建社群
-(void)parserCreateGroup:(NSDictionary*)dic;

//解析社群信息
-(void)parserGroupInfo:(NSDictionary*)dic;

//解析社群成员
-(void)parserGroupMember:(NSDictionary*)dic;

//解析发送要邀请
-(void)parserInvitePeople:(NSDictionary*)dic;

//解析听众邀请列表
-(void)parserInviteFansList:(NSDictionary*)dic;

//解析邀请听众
-(void)parserInviteFans:(NSDictionary*)dic;

//解析消息设置信息
-(void)parserGetPushSetMessage:(NSDictionary *)dic;


//解析更新推送设置
-(void)parserUpdatePushSet:(NSDictionary *)dic;

//解析批量更新推送设置
-(void)parserUpdatePushSettings:(NSDictionary *)dic;

//解析退出社群
-(void)parserQuitGroup:(NSDictionary*)dic;

//解析社群受邀列表
-(void)parserMyInviteList:(NSDictionary*)dic;

//解析处理社群申请
-(void)parserHandleGroupApply:(NSDictionary*)dic;

//解析处理社群邀请
-(void)parserHandleGroupInvitation:(NSDictionary*)dic;

//解析初始化推送设置
-(void)parserInitPushSetting:(NSDictionary*)dic;


//解析获取社群的权限
-(void)parserGetGroupPermission:(NSDictionary*)dic;

//解析设置社群的权限
-(void)parserSetGroupPermission:(NSDictionary*)dic;

//解析请求问答点赞
- (void)parserUpdateAnserSupportCount:(NSDictionary *)dic;

//解析请求增加问答评论
- (void)parserSubmitAnwserComment:(NSDictionary *)dic;

//解析获取问答评论
- (void)parserGetAnswerCommentList:(NSDictionary *)dic;

//解析提问
- (void)parserAskQuest:(NSDictionary *)dic;

//解析找回密码
-(void) parserFindPwd:(NSDictionary *)dic;

//解析核对验证码
-(void) parserCheckCode:(NSDictionary *)dic;

//解析重置密码
-(void)parserResetNewPwd:(NSDictionary *)dic;

//解析上传头像
-(void)parserUploadMyImg:(NSDictionary*)dic;

//解析创建的社群的数量
-(void)parserCreateGroupCount:(NSDictionary*)dic;

//解析获取多个城市的薪资百分比
-(void)parserSomeCitySalaryRank:(NSDictionary*)dic;


//解析薪资段获取的百分比(用于柱状图)
-(void)parserSalaryRankByMoney:(NSDictionary*)dic;

//解析获取社群邀请短信
-(void)parserGroupInviteSMS:(NSDictionary*)dic;

//解析职位详情
-(void)parserGetPositionDetails:(NSDictionary *)dic;

//请求收藏职位
-(void)parserCollectPosition:(NSDictionary *)dic;

//请求职位申请记录、收藏记录、面试通知、谁看过我 的数量
-(void)parserGetResumeCenterMessage:(NSDictionary *)dic;


//解析申请单个职位
-(void)parserApplyOneZW:(NSDictionary*)dic;

//解析申请职位，可批量
-(void)parserApplyZW:(NSDictionary*)dic;

//解析请求删除收藏职位
-(void)parserDeleteCollectPosition:(NSDictionary *)dic;

//解析请求面试通知详情
-(void)parserGetInterviewMessageDetail:(NSDictionary *)dic;

//解析请求刷新简历
-(void)parserRefreshResume:(NSDictionary *)dic;

//解析请求求职状态
-(void)parserGetResumeStatus:(NSDictionary *)dic;

//解析请求更新求职状态
-(void)parserUpdateResumeStatus:(NSDictionary *)dic;


//解析企业HR问答
-(void)parserCompanyHRAnswerList:(NSDictionary*)dic;

//解析企业未来
-(void)parserCompanyDevelopment:(NSDictionary *)dic;

//解析企业用人理念
-(void)parserCompanyEmployee:(NSDictionary*)dic;

//解析企业团队
-(void)parserCompanyTeam:(NSDictionary*)dic;

//解析企业员工分享
-(void)parserCompanyShare:(NSDictionary *)dic;


//解析请求简历保密设置
-(void)parserUpdateResumeVisible:(NSDictionary *)dic;


//解析公司在招所有职位列表
-(void)parserCompanyAllZWlist:(NSDictionary*)dic;
 

//解析请求简历保密设置状态
-(void)parserGetResumeVisible:(NSDictionary *)dic;

//解析请求简历路径
-(void)parserGetResumePath:(NSDictionary *)dic;

//请求职同道合列表
-(void)parserGetTheSamePersonList:(NSDictionary *)dic;


//解析相关雇主列表
-(void)parserRelatedCompanyList:(NSDictionary*)dic;

//解析向HR提问
-(void)parserAskHR:(NSDictionary*)dic;

//解析请求教育背景
-(void)parserGetEdusInfo:(NSDictionary *)dic;

//解析请求更新教育背景
-(void)parserUpdateEdusInfo:(NSDictionary *)dic;

//解析添加教育背景
-(void)parserAddEdusInfo:(NSDictionary *)dic;

//解析获取灌薪水列表
-(void)parserGetSalaryArticle:(NSDictionary *)dic;

//解析发表灌薪水文章
-(void)parserShareSalaryArticle:(NSDictionary*)dic;

//解析设置昵称
-(void)updateNickName:(NSDictionary *)dic;

//解析某人在社群里地权限
-(void)parserPermissionInGroup:(NSDictionary*)dic;

//解析文档信息
-(void)parserFileInfo:(NSDictionary*)dic;

//解析请求关注企业
-(void)parserAddAttentionCompany:(NSDictionary*)dic;

//解析请求取消关注企业
-(void)parserCancelAttentionCompany:(NSDictionary*)dic;

//解析上传图片
-(void)parserUploadImgData:(NSDictionary*)dic;

//请求获取薪酬预测
-(void)parserGetSalaryPrediction:(NSDictionary *)dic;

//解析请求职导推荐行家
-(void)parserGetSalaryExpert:(NSDictionary *)dic;

//解析请求简历对比数据
-(void)parserGetResumeRcomparison:(NSDictionary *)dic;

//解析消息列表
-(void)parserMessageList:(NSDictionary*)dic;

//解析某种类型的消息列表
-(void)parserOneMessageList:(NSDictionary*)dic;

//解析分享成功后的记录
-(void)parserShareLogs:(NSDictionary*)dic;

//解析提交问卷调查
-(void)parserAddQuestionnaire:(NSDictionary *)dic;

//解析HI模块列表
-(void)parserYL1001HIList:(NSDictionary*)dic;

//解析请求用户详情
-(void)parserGetPersonDetailWithPersonId:(NSDictionary *)dic;

//解析公司登录
-(void)parserCompanyLogin:(NSDictionary*)dic;

//解析绑定公司的信息
-(void)parserCompanyHRDetail:(NSDictionary*)dic;

//解析绑定公司的已发面试通知
-(void)parserCompanyInterview:(NSDictionary*)dic;

//解析绑定公司的提问
-(void)parserCompanyQuestion:(NSDictionary*)dic;

//解析绑定公司的未读简历
-(void)parserCompanyResume:(NSDictionary*)dic;

//解析简历预览的url
-(void)parserResumeUrl:(NSDictionary*)dic;

//解析职位详情3GURL
- (void)parserPositionDetail3GURL:(NSDictionary *)dic;

//解析回答绑定公司的问题
-(void)parserDoHRAnswer:(NSDictionary*)dic;

//解析设置简历是否通过
-(void)parserSetResumePass:(NSDictionary*)dic;

//解析绑定公司的其他HR列表
-(void)parserCompanyOtherHR:(NSDictionary*)dic;

//解析转发简历
-(void)parserTranspondResume:(NSDictionary*)dic;

//解析公司面试模板
-(void)parserInterviewModel:(NSDictionary*)dic;

//解析公司在招职位
-(void)parserCompanyZWForUsing:(NSDictionary*)dic;

//解析发送面试通知
-(void)parserSendInterview:(NSDictionary*)dic;

//解析获取服务信息的url
-(void)parserServiceURL:(NSDictionary*)dic;

//解析文章添加赞
-(void)parserArticleAddLike:(NSDictionary*)dic;


//解析绑定公司和个人
-(void)parserBindingCompany:(NSDictionary*)dic;

//解析获取绑定的公司
-(void)parserGetBindingCompany:(NSDictionary*)dic;


//解析职位名称
- (void)getPositionName:(NSDictionary *)dic;

//解析公司详情URL
- (void)parserCompanyDetailUrl:(NSDictionary *)dic;

//解析设置简历已阅
-(void)parserSetNewMailRead:(NSDictionary*)dic;


//解析添加关注学校
- (void)parserAttendCareerSchool:(NSDictionary *)dic;


//解析取消关注学校
- (void)parserChangAttendCareerSchool:(NSDictionary *)dic;

//解析请求我关注学校列表
- (void)getAttendSchoolList:(NSDictionary *)dic;

//解析学校宣讲会列表
- (void)parserGetSchoolXJHList:(NSDictionary *)dic;

//解析薪指排行大比拼结果
-(void)parserSalaryCompareResult:(NSDictionary*)dic;

//解析语音上传
-(void)parserUpdateVoiceFile:(NSDictionary *)dic;

//解析上传图片
- (void)parserUploadPhoto:(NSDictionary *)dic;

//解析添加简历图片
- (void)parserAddResumePhoto:(NSDictionary *)dic;

//解析获取简历图片语音
- (void)parserGetResumePhotoAndVoice:(NSDictionary *)dic;

//删除简历图片
- (void)parserDeleteResumeImage:(NSDictionary *)dic;

//解析添加简历语音
- (void)parserAddResumeVoice:(NSDictionary *)dic;

//解析薪指搜索比拼结果
-(void)parserSalarySearchResult:(NSDictionary*)dic;

//解析解除绑定
-(void)parserCancelBindCompany:(NSDictionary*)dic;

//解析注册时请求添加关注学校
- (void)parserAddAttentionSchool:(NSDictionary *)dic;

//解析hi模块的行家搜索
-(void)parserHISearchExpert:(NSDictionary*)dic;

//获取身边工作
- (void)parserGetNearbyWork:(NSDictionary *)dic;

//第三方登录 解析是否绑定
- (void)parserDetectBinding:(NSDictionary *)dic;

//解析创建并绑定第三方
-(void)parserBuildPerson:(NSDictionary *)dic;

//解析个人主页访问记录
-(void)parserMyCenterVisitLog:(NSDictionary*)dic;

//更新社群信息
- (void)parserUpdateGroups:(NSDictionary *)dic;

//获取校园招聘活动的分享url
-(void)parserSchoolZPShareUrl:(NSDictionary*)dic;

//解析获取同行
- (void)parserGetSameTradePerson:(NSDictionary *)dic;

//解析获取听众我的关注
-(void)parserGetFriend:(NSDictionary *)dic;

//解析获取同行中新朋友和新评论的数量
- (void)parserGetNewFriendAndComment:(NSDictionary *)dic;

//解析获取我的文章评论列表
-(void)parserGetMyArticleCommentList:(NSDictionary *)dic;

//解析获取主页中心信息
- (void)parserGetPersonCenterData:(NSDictionary *)dic;

//解析最新评论列表(消息)
-(void)parserMyCommentList:(NSDictionary*)dic;

//解析我的系统通知列表（消息）
-(void)parserMySystemNotification:(NSDictionary*)dic;

//解析打招呼列表（消息）
-(void)parserSayHiList:(NSDictionary*)dic;

//解析留言列表(消息)
-(void)parserLetterList:(NSDictionary*)dic;

//解析社群消息（消息）
-(void)parserGroupsMessageList:(NSDictionary*)dic;

//解析获取默认标签
- (void)parserGetTagsList:(id)dic;

//解析修改标签
- (void)parserUpdateTagsList:(NSDictionary *)dic;

//打招呼 留言
- (void)parserSendMessage:(NSDictionary *)dic;

//解析我的问答（消息）
-(void)parsermyAQlist:(NSDictionary*)dic;

//回答专访问题
- (void)parserAnswerInterviewQuestion:(NSDictionary *)dic;

//获取小编专访列表
- (void)parserGetInterviewList:(NSDictionary *)dic;

//解析是否有权限查看更多小编专访
- (void)parserGetShowMoreAnswer:(NSDictionary *)dic;

//解析消息模块各项的新消息数
-(void)parserMessageCnt:(NSDictionary*)dic;

//解析找他搜索
- (void)parserGetTraderPeson:(NSDictionary *)dic;

//解析获取社群数量
- (void)parserGetGroupsCnt:(NSDictionary *)dic;

//解析获取企业收藏简历的列表
-(void)parserCompanyCollectionResume:(NSDictionary*)dic;

//解析企业收藏简历
-(void)parserCollectResume:(NSDictionary*)dic;

//查看简历完整度
- (void)parserGetResumeComplete:(NSDictionary *)dic;

//解析删除文章
- (void)parserDeleteArticle:(NSDictionary *)dic;

//解析举报非法文章
-(void)parserToReportIllegalArticle:(NSDictionary*)dic;

//解析获取社群置顶话题列表
- (void)parserSetRecommendArticle:(NSDictionary *)dic;

//修改置顶话题
- (void)parserSaveRecommendSet:(NSDictionary *)dic;

//解析删除社群文章
- (void)parserDeleteGroupArticle:(NSDictionary *)dic;

//解析留言 给他人留言
-(void)parserLeaveMsg:(NSDictionary *)dic;

//解析发私信
-(void)parserSendPersonalMsg:(NSDictionary *)dic;

//解析私信列表
-(void)parserPersonalMsgList:(NSDictionary *)dic;

//解析留言联系人列表 分页
-(void)parserGetContactList:(NSDictionary *)dic;

//解析文章收藏
-(void)parserAddArticleFavorite:(NSDictionary *)dic;

//解析文章收藏列表
-(void)parserGetArticleFavoriteList:(NSDictionary *)dic;

//解析扫描二维码
-(void)parserScanQrCode:(NSDictionary *)dic;

//解析登录授权
-(void)parserLoginAuth:(NSDictionary *)dic;

//解析获取职业标签
- (void)parserGetJobTagsList:(NSDictionary *)dic;

//解析记录用户当前状态
-(void)parserUserStatus:(NSDictionary*)dic;

//解析评论列表old
-(void) parserCommentListOld:(NSDictionary *)dic;

//解析获取服务码
-(void)parserGetServiceNumber:(NSDictionary *)dic;

//解析无验证码注册
-(void)parserRegistNoCode:(NSDictionary *)dic;

//解析获取有邀请权限的社群
-(void)parserGetInveteGroupWithUserId:(NSDictionary *)dic;

//解析请求个人信息
- (void)parserGetPersonInfo:(NSDictionary *)dic;

//解析简历下载 企业查看用户的联系方式
-(void)parserDownloadResume:(NSDictionary*)dic;

//解析简历评价标签列表
-(void)parserResumeCommentTagList:(NSDictionary*)dic;

//解析简历下载列表
-(void)parserDownloadResumeList:(NSDictionary *)dic;

//解析简历评论列表
-(void)parserResumeCommentList:(NSDictionary *)dic;

//解析其他关联企业的账号列表
-(void)parserOtherCompanyAccountList:(NSDictionary*)dic;

//解析添加简历评价
-(void)parserAddResumeComment:(NSDictionary*)dic;

//人才简历列表
-(void)parserCompanySearchResume:(NSDictionary *)dic;

//解析接收到推送消息的回调结果
-(void)parserReceiveMessageCallback:(NSDictionary*)dic;

//解析薪资比拼的总次数
-(void)parserSalaryCompareSum:(NSDictionary*)dic;

//解析简历信息
- (void)parserGetResumeInfo:(NSDictionary *)dic;

//解析简历更新
- (void)parserUpdateResumeInfoWithPersonId:(NSDictionary *)dic;

//解析首页顶部广告
-(void)parserTopAD:(NSDictionary*)dic;

#pragma mark - 解析获取屏蔽公司列表
- (void)parserGetSheidCompanyList:(NSDictionary *)dic;

#pragma mark - 解析搜索公司
- (void)parserGetCompany:(NSDictionary *)dic;

#pragma mark - 解析设置或取消屏蔽公司
- (void)parserSetSheidCompany:(NSDictionary *)dic;

#pragma mark - 解析个人中心1
- (void)parserGetPersonCenter1:(NSDictionary *)dic;

#pragma mark - 解析个人中心2
- (void)parserGetPersonCenter2:(NSDictionary *)dic;

#pragma mark - 解析点击通知记录日志
- (void)parserMessageClickLog:(NSDictionary *)dic;

//解析社群话题列表
-(void)parserSearchGroupArticleList:(NSDictionary*)dic;

#pragma mark - 解析我的消息
-(void)parsergetMessageWith:(NSDictionary*)dic;

#pragma mark - 解析最新发表
-(void)parsergetNewPublicArticle:(NSDictionary*)dic;


#pragma mark - 解析头部按钮顺序
-(void)parserTableHeadButtonList:(NSDictionary*)dic;

#pragma mark - 解析查工资页面的热门行业列表
-(void)parserSalaryHotJobList:(NSDictionary*)dic;


#pragma mark - 解析看前景薪酬预测
- (void)parserGetSalaryForecastWithZyName:(NSDictionary *)dic;

#pragma mark - 解析HR或者人才信息
- (void)parserGetHrMessageWithLoginI:(NSDictionary *)dic;

//解析企业HR 顾问绑定情况
- (void)parserBingdingStatusWith:(NSDictionary *)dic;

//顾问绑定登录
- (void)parserGunwenLoginWith:(NSDictionary *)dic;

//解析解绑顾问
- (void)paserGunwenJieBang:(NSDictionary *)dic;

//解析顾问搜索简历
- (void)paserGunwenSearchResume:(NSDictionary *)dic;

//解析顾问已下载简历列表
- (void)paserGuwenLoadResumeList:(NSDictionary *)dic;

//解析顾问已推荐简历列表
- (void)paserGuwenRecomResumeList:(NSDictionary *)dic;

//解析顾问OA打电话
- (void)paserGuwenCallPerson:(NSDictionary *)dic;

// 解析顾问下载简历
- (void)paserGunwenLoadResume:(NSDictionary *)dic;

// 解析下载人才联系
- (void)paserGunwenLoadConstanct:(NSDictionary *)dic;

//解析根据意向职位搜索在招企业
- (void)paserGunwenSearchCompany:(NSDictionary *)dic;

//解析顾问行业
- (void)paserGunwenTrade:(NSDictionary *)dic;

//解析推荐简历
- (void)paserRecommendPerson:(NSDictionary *)dic;

//解析获取招聘顾问回访简历列表
- (void)paserGetGuwenVistList:(NSDictionary *)dic;

//解析获取回访列表
-(void)paserGetReplyList:(NSDictionary *)dic;

//解析添加回访记录
-(void)paserAddVisit:(NSDictionary *)dic;

//解析按类型请求offer派人才列表
//-(void)paserGetPersonListByFairId:(NSDictionary *)dic;

//offer可推荐企业列表
-(void)paserGetJobFairCompany:(NSDictionary *)dic;

//解析人才可推荐到的企业列表
-(void)paserRecommendPersonToCompany:(NSDictionary *)dic;

//顾问offer派人才返回
-(void)paserGetOfferPartyCount:(NSDictionary *)dic;

//确认人才到场状态
-(void)paserJoinPerson:(NSDictionary *)dic;

//解析推荐详情
-(void)paserGetRecommentInfo:(NSDictionary *)dic;

//解析已确认适合/已发offer/已上岗企业列表
- (void)paserGetItemCompany:(NSDictionary *)dic;

//未推荐列表
-(void)paserGetUnRecomPersonList:(NSDictionary *)dic;

//解析职导行家列表
- (void)parsergetJobGuideExpertList:(NSDictionary *)dic;

//解析行家信息
- (void)parserJobGuideExpertInfo:(NSDictionary *)dic;

//获取最后通话时间
- (void)paserGetLastTelTime:(NSDictionary *)dic;

//解析顾问邮箱
-(void)paserGetGuwenEmail:(NSDictionary *)dic;

// 发送邮件给顾问
-(void)paserSenderResumeToGuwenEmail:(NSDictionary *)dic;

//解析问答详情回复列表
- (void)parserReplyCommentList:(NSDictionary *)dic;

//解析行家评价列表
- (void)parserExpertCommentList:(NSDictionary *)dic;

//解析职导对行家评价
- (void)parserAddExpertComment:(NSDictionary *)dic;

//解析更多应用列表
- (void)parserApplicationList:(NSDictionary *)dic;

//解析打赏订单生成
- (void)parserDashangShoppingCart:(NSDictionary *)dic;

//解析余额支付
- (void)parserPayWithyuer:(NSDictionary *)dic;

//解析我的约谈列表
- (void)parserAspectantDisList:(NSDictionary *)dic;

//解析约谈选择课程列表
- (void)parserInterviewCourseList:(NSDictionary *)dic;

//在招职位列表
-(void)parserGetZpListWithCompanyId:(NSDictionary *)dic;

//解析获取发布网站信息
-(void)parserGetZWFBInfoWithCompanyId:(NSDictionary *)dic;

//解析发布戒指
- (void)parserAddPositionWithCompanyId:(NSDictionary *)dic;

//解析文章打赏
- (void)parserArticleRewardImg:(NSDictionary *)dic;

#pragma mark - 我的打赏列表
- (void)parserMyRewardList:(NSDictionary *)dic;

#pragma mark - 行家常用地址
- (void)parserExpertRegionList:(NSDictionary *)dic;


@end

@interface ExJSONParser : NSObject

@end
