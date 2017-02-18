//
//  ExJSONParser.m
//  MBA
//
//  Created by sysweal on 13-11-12.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "ExJSONParser.h"
#import "ExRequetCon.h"
#import "AccessToken_DataModal.h"
#import "User_DataModal.h"
#import "News_DataModal.h"
#import "Comment_DataModal.h"
#import "Author_DataModal.h"
#import "ConsultantHRDataModel.h"
#import "Groups_DataModal.h"
#import "Article_DataModal.h"
#import "VersionInfo_DataModal.h"
#import "Home_DataModal.h"
#import "Expert_DataModal.h"
#import "Subject_DataModal.h"
#import "Qikan_DataModal.h"
#import "Answer_DataModal.h"
#import "Xjh_Zph_DataModal.h"
#import "ZWDetail_DataModal.h"
#import "PushSetDateModel.h"
#import "GroupInvite_DataModal.h"
#import "GroupPermission_DataModal.h"
#import "WorkApplyDataModel.h"
#import "ZWDetail_DataModal.h"
#import "CountInfoDataModel.h"
#import "CompanyLogin_DataModal.h"
#import "JobSearch_DataModal.h"
#import "CompanyInfo_DataModal.h"
#import "CompanyHRAnswer_DataModal.h"
#import "CultureContent_DataModal.h"
#import "EduResume_DataModal.h"
#import "SalaryDateModel.h"
#import "CompanyOtherHR_DataModal.h"
#import "InterviewModel_DataModal.h"
#import "School_DataModal.h"
#import "SalaryResult_DataModal.h"
#import "Upload_DataModal.h"
#import "PhotoVoiceDataModel.h"
#import "NewCommentMsgModel.h"
#import "PersonCenterDataModel.h"
#import "personTagModel.h"
#import "SysNotification_DataModal.h"
#import "InterviewDataModel.h"
#import "ResumeCompleteModel.h"
#import "AD_dataModal.h"
#import "LeaveMessage_DataModel.h"
#import "MessageContact_DataModel.h"
#import "ServiceCode_DataModal.h"
#import "PersonDetailInfo_DataModal.h"
#import "ResumeCommentTag_DataModal.h"
#import "ResumeComment_DataModal.h"
#import "peopleResumeDataModal.h"
#import "PersonDetailInfo_DataModal.h"
#import "BadgeModal.h"
#import "OrderType_DataModal.h"
#import "OrderService_DataModal.h"
#import "NewAnswerListModal.h"
#import "NewAnswerDetailDataModal.h"
#import "HotJob_DataModel.h"
#import "MessageCenterDataModel.h"
#import "SameTradeSection_DataModal.h"
#import "SalaryForecastModel.h"
#import "WhoLikeMeDataModal.h"
#import "YLMediaModal.h"
#import "YLAddressBookModal.h"
#import "MyConfig.h"
#import "ELAspectantDiscuss_Modal.h"
#import "MsgDetail_DataModal.h"
#import "Reward_DataModal.h"
#import "ELTodaySearchModal.h"
#import "ELGroupListDetailModel.h"
#import "ELGroupArticleDetailModel.h"
#import "MyQuestionAndAnswerModal.h"
#import "JobGuideQuizModal.h"
#import "ELGroupListTwoModel.h"
#import "TodayFocusFrame_DataModal.h"
#import "JobGuideExpertModal.h"
#import "AnswerDetialModal.h"
#import "NewCareerTalkDataModal.h"
#import "ELGroupDetailModal.h"
#import "NewResumeNotifyDataModel.h"
#import "NewJobPositionDataModel.h"
#import "ELSalaryModel.h"
#import "MyTradeRecordModal.h"
#import "ELCommentModel.h"
#import "NearPositionDataModel.h"
#import "ELActivityModel.h"
#import "ELSameTrameArticleModel.h"
#import "NewApplyRecordDataModel.h"
#import "ELSalaryResultModel.h"
#import "ELGroupCommentModel.h"
#import "ELActivityPeopleFrameModel.h"
#import "ELUserModel.h"
#import "ELSameTradePeopleFrameModel.h"
#import "NewPositionCollectDataModel.h"
#import "CareCompanyDataModel.h"
#import "OfferPartyTalentsModel.h"
#import "ELSalaryResultDetailModel.h"
#import "ELGroupCommentModel.h"
#import "ELAnswerLableView.h"
#import "OfferHeaderDataModel.h"
#import "ELAnswerLableModel.h"
#import "TodayFocusListCtl.h"
#import "TurnTomeResumeModel.h"
#import "OfferPartyResumeEnumeration.h"
#import "ELButtonView.h"

#import "ELNewNewsListVO.h"
#import "ELNewNewsInfoVO.h"
#import "ELNewsListDAO.h"

@implementation JSONParser (MyParser)

//总入口
-(void) parserDic:(NSDictionary *)dic requestType:(NSInteger)type
{
    //self.requestType = type;
    @try {
        switch ( type ) {
            case Request_Image:
                if( dic ){
                    NSData *imgData = (NSData*)dic;
                    [dataArr_ addObject:[NSData dataWithData:imgData]];
                }
                break;
            case Request_GetAccessToken:
                [self parserAccessToken:dic];
                break;
            case Request_ActivityJoinList:
            case Request_ActivityPublishList:
                [self parserActivityList:dic widthType:type];
                break;
            case Request_AddVoteLogs:
                [self sendAddVoteLogs:dic];
                break;
            case Request_Login:
                [self parserLogin:dic];
                break;
            case Request_ValidUserName:
                [self parserValidUserName:dic];
                break;
            case gunwenLoginWith:
                [self parserGunwenLoginWith:dic];
                break;
            case Request_Register:
                [self parserRegister:dic];
                break;
            case gunwenJieBang:
                [self paserGunwenJieBang:dic];
                break;
            case Request_SaveInfo:
                [self parserSaveInfo:dic];
                break;
            case Request_MyGroupArticleList:
                [self getMyGroupArticleListDic:dic];
                break;
            case Request_GetNews:
                [self parserNewsList:dic];
                break;
            case getAllMessageWithId:
                [self getAllMessageCountDictionary:dic];
                break;
            case Request_GetArticleDetail:
                [self parserArticleDetail:dic];
                break;
            case Request_CommentList:
                [self parserCommentList:dic];
                break;
            case Request_GetLatelyJobfairList:
                [self parserGetOfferPartyList:dic];
                break;
            case Request_AddComment:
            case Request_IsUpdateAddressBook:
                [self parserAddComment:dic];
                break;
            case Request_AddGxsComment:
                [self parserAddGxsComment:dic];
                break;
            case Request_UserInfo:
                [self parserUserInfo:dic];
                break;
            case Request_MyGroups:
                [self parserMyGroupsList:dic];
                break;
            case Request_GunwenLoadConstanct:
                [self paserGunwenLoadConstanct:dic];
                break;
            case Request_GetRecommentInfo:
                [self paserGetRecommentInfo:dic];
                break;
            case Request_GroupsArticle:
                [self parserGroupArticleList:dic];
                break;
            case Request_SearchGroupsArticle:
                [self parserSearchGroupArticleList:dic];
                break;
            case Request_ResumeZbar:
                [self getResumeZbarDictionary:dic];
                break;
            case Request_MyPubilsh:
                [self parserMyPubilshList:dic];
                break;
            case Request_GroupsArticleDetail:
                [self parserGroupArticleDetail:dic];
                break;
            case Request_FeedBack:
                [self parserGiveAdvice:dic];
                break;
            case Request_CheckVersionByHide:
                [self parserVersionCheck:dic];
                break;
            case requestBingdingStatusWith:
                [self parserBingdingStatusWith:dic];
                break;
            case refreshbingdingStatusWith:
                [self parserBingdingStatusWith:dic];
                break;
            case Request_CheckVersion:
                [self parserVersionCheck:dic];
                break;
            case Request_Home:
                [self parserHomeList:dic];
                break;
            case Request_ExpertList:
                [self parserExpertList:dic];
                break;
            case Request_Follow:
                [self parserFollowExpert:dic];
                break;
            case Request_CancelFollow:
                [self parserCaccelFollowExpert:dic];
                break;
            case Request_RecommendGroup:
                [self parserRecommendGroupsList:dic];
                break;
            case Request_SearchGroup:
                [self parserRecommendGroupsList:dic];
                break;
            case Request_JoinGroup:
            case Request_JoinGroupTwo:
                [self parserJoinGroup:dic];
                break;
            case Request_SubjectList:
                [self parserSubjextList:dic];
                break;
            case getHrMessageWithLoginId:
                [self parserGetHrMessageWithLoginI:dic];
                break;
            case Request_SubjectDetail:
                [self parserSubjectDetail:dic];
                break;
            case Request_SalaryList:
                [self parserSalaryList:dic];
                break;
            case Request_GetClickDomainList:
                [self getClickDomainListDic:dic];
                break;
            case Request_ViewPoint:
                [self ParserViewPointList:dic];
                break;
            case Request_CommentContent:
                [self parserCommentContent:dic];
                break;
            case Request_isExpert:
                [self parserIsExpert:dic];
                break;
            case Request_JobGuide:
                [self parserJobGuideList:dic];
                break;
            case Request_JobGuideDetail:
                [self parserJobGuideDetail:dic];
                break;
            case Request_ResetPwd:
                [self parserResetPwd:dic];
                break;
            case Request_SalaryPercent:
                [self parserSalaryPercent:dic];
                break;
            case Request_SalaryRank:
                [self parserSalaryList:dic];
                break;
            case Request_SetSubscribeConfig:
                [self parserRegistNotifice:dic];
                break;
            case Request_RecommandJob:
                [self parserRecommendJob:dic];
                break;
            case Request_FindPassword:
                [self parserFindPassword:dic];
                break;
            case Request_SetArticleLiked:
                [self parserAddComment:dic];
                break;
            case Request_RegestPhone:
                [self parserRegestPhone:dic];
                break;
            case Request_FreshSalaryList:
                [self parserFreshSalaryList:dic];
                break;
            case Request_NewsRecommendExpert:
                [self parserNewsRecommendExpert:dic];
                break;
            case Request_ExpertAnswerList:
                [self parserExpertAnswerList:dic];
                break;
            case Request_AnswerDetailNew:
                [self parserAnswerDetailNew:dic];
                break;
            case Request_AskExpert:
                [self parserAskExpert:dic];
                break;
            case Request_JobGuideQuesList:
                [self parserJobGuideQuesList:dic];
                break;
            case Request_GetJobGuideByTag:
                [self parserJobGuideQuesList:dic];
                break;
            case Request_XjhList:
//                [self parserXjhZphList:dic];
                [self parserXjhAndZph:dic];
                break;
            case Request_ZphList:
//                [self parserXjhZphList:dic];
                [self parserXjhAndZph:dic];
                break;
            case Request_XjhDetail:
//                [self parserXjhDetail:dic];
                [self parserXjhAndZphDetail:dic];
                break;
            case Request_ZphDetail:
//                [self parserZphDetail:dic];
                [self parserXjhAndZphDetail:dic];
                break;
            case Request_CreatedAssociation:
                [self parserCreatedAssociation:dic];
                break;
            case Request_MyNotAnswerList:
                [self parserMyNotAnswerList:dic];
                break;
            case Request_MyAnswerList:
                [self parserMyAnswerList:dic];
                break;
            case Request_AnswerQuestion:
                [self parserAnswerQuestion:dic];
                break;
            case Request_SubscibeJob:
                [self parserSubscribeJob:dic];
                break;
            case Request_GetJobSubscribedList:
                [self parserJobSubscribedList:dic];
                break;
            case Request_DeleteJobSubscribed:
                [self parserDeleteSubscribe:dic];
                break;
            case Request_MyFollower:
                [self parserMyFollower:dic];
                break;
            case Request_ShareArticle:
                [self parserShareArticle:dic];
                break;
            case Request_PublishTopic:
                [self parserPublishTopic:dic];
                break;
            case Request_GroupsCanPublish:
                [self parserGroupsCanPublish:dic];
                break;
            case Request_CreateGroup:
                [self parserCreateGroup:dic];
                break;
            case Request_GetGroupInfo:
                [self parserGroupInfo:dic];
                break;
            case Request_GetGroupMember:
                [self parserGroupMember:dic];
                break;
            case Request_GetGroupCreater:
                [self parserGroupMember:dic];
                break;
            case Request_InvitePeople:
                [self parserInvitePeople:dic];
                break;
            case Request_InviteFansList:
                [self parserInviteFansList:dic];
                break;
            case Request_InviteFans:
                [self parserInviteFans:dic];
                break;
            case Request_GetPushSetMessage:
                [self parserGetPushSetMessage:dic];
                break;
            case Request_UpdatePushSet:
                [self parserUpdatePushSet:dic];
                break;
            case Request_QuitGroup:
                [self parserQuitGroup:dic];
                break;
            case Request_MyInviteList:
                [self parserMyInviteList:dic];
                break;
            case Request_HandleGroupInvitation:
                [self parserHandleGroupInvitation:dic];
                break;
            case Request_HandleGroupApply:
                [self parserHandleGroupApply:dic];
                break;
            case Request_UpdatePushSettings:
                [self parserUpdatePushSettings:dic];
                break;
            case Request_InitPushSettings:
                [self parserInitPushSetting:dic];
                break;
            case Request_GetGroupPermission:
                [self parserGetGroupPermission:dic];
                break;
            case Request_SetGroupPermission:
                [self parserSetGroupPermission:dic];
                break;
            case Request_DeliverOfferPartyResume://offer派投递简历
                [self parserValidUserName:dic];
                break;
            case Request_UpdateAnserSupportCount:
                [self parserUpdateAnserSupportCount:dic];
                break;
            case Request_SubmitAnswerComment:
            [self parserSubmitAnwserComment:dic];
                break;
            case Request_GetAnswerCommentList:
                [self parserGetAnswerCommentList:dic];
                break;
            case Request_AskQuest:
                [self parserAskQuest:dic];
                break;
            case Request_FindPhonePwd:
                [self parserFindPwd:dic];
                break;
            case Request_CheckCode:
                [self parserCheckCode:dic];
                break;
            case Request_ResetPhonePwd:
                [self parserResetNewPwd:dic];
                break;
            case Request_UploadMyImg:
                [self parserUploadMyImg:dic];
                break;
            case Request_GetCreateGroupCnt:
                [self parserCreateGroupCount:dic];
                break;
            case Request_SomeCitySalaryRank:
                [self parserSomeCitySalaryRank:dic];
                break;
            case Request_SalaryRankByMoney:
                [self parserSalaryRankByMoney:dic];
                break;
            case Request_InviteSMS:
                [self parserGroupInviteSMS:dic];
                break;

            case Request_GetWorkApplyList:
//                [self parserGetWorkApplyList:dic];
                [self parserWorkApply:dic];
                break;
            case Request_GetPositionDetails:
                [self parserGetPositionDetails:dic];
                break;
            case Request_CollectPosition:
                [self parserCollectPosition:dic];
                break;
            case Request_GetResumeCenterMessage:
                [self parserGetResumeCenterMessage:dic];
                break;
            case Request_FindJobList:
//                [self parserFindJobList:dic];
                [self parserSearchPosition:dic];
                break;
            case Request_ApplyZW:
                [self parserApplyZW:dic];
                break;
            case Request_GetPositionApplyCollectList:
//                [self parserGetPositionApplyCollectList:dic];
                [self parserPositionCollection:dic];
                break;
            case Request_DeleteCollectPosition:
                [self parserDeleteCollectPosition:dic];
                break;
            case Request_GetInterviewMessageList:
//                [self parserGetInterviewMessageList:dic];
                [self parserResumeVisited:dic];
                break;
            case Request_getInterviewMessageDetail:
                [self parserGetInterviewMessageDetail:dic];
//                [self parserResumeVisited:dic];
                break;
            case Request_ApplyOneZw:
                [self parserApplyOneZW:dic];
                break;
            case Request_GetResumeVisitList:
//                [self parserGetResumeVisitList:dic];
                [self parserResumeVisited:dic];
                break;
            case Request_RefreshResume:
                [self parserRefreshResume:dic];
                break;
            case Request_GetResumeStatus:
                [self parserGetResumeStatus:dic];
                break;
            case Request_UpdateResumeStatus:
                [self parserUpdateResumeStatus:dic];
                break;
            case Request_CompanyHRAnswer:
                [self parserCompanyHRAnswerList:dic];
                break;
            case Request_CompanyDevelopment:
                [self parserCompanyDevelopment:dic];
                break;
            case Request_CompanyEmployee:
                [self parserCompanyEmployee:dic];
                break;
            case Request_CompanyShare:
                [self parserCompanyShare:dic];
                break;
            case Request_CompanyTeam:
                [self parserCompanyTeam:dic];
                break;
            case Request_UpdateResumeVisible:
                [self parserUpdateResumeVisible:dic];
                break;
            case Request_GetResumeVisible:
                [self parserGetResumeVisible:dic];
                break;
            case Request_GetResumePath:
                [self parserGetResumePath:dic];
                break;
            case Request_GetTheSamePersonList:
                [self parserGetTheSamePersonList:dic];
                break;
            case Request_CompanyAllZW:
                [self parserCompanyAllZWlist:dic];
                break;
            case Request_RelatedCompanyList:
                [self parserRelatedCompanyList:dic];
                break;
            case Request_AskCompanyHR:
                [self parserAskHR:dic];
                break;
            case Request_GetEdusInfo:
                [self parserGetEdusInfo:dic];
                break;
            case Request_UpdateEdusInfo:
                [self parserUpdateEdusInfo:dic];
                break;
                
            case Request_AddEdusInfo:
                [self parserAddEdusInfo:dic];
                break;
            case Request_SalaryArticleList:
                [self parserGetSalaryArticle:dic];
                break;
            case request_SalaryTypeChange:
                [self parserSalaryTypeChange:dic];
                break;
            case Request_SalaryArticleAndCommentList:
                [self parserGetSalaryArticleAndCommentList:dic];
                break;
            case Request_AddArticleFavorite://收藏文章
                [self parserAddArticleFavorite:dic];
                break;
            case Request_GetArticleFavoriteList://收藏文章列表
                [self parserGetArticleFavoriteList:dic];
                break;
            case Request_sendAMessage://发私信
                [self parserSendPersonalMsg:dic];
                break;
            case Request_LeaveMessage://留言
                [self parserLeaveMsg:dic];
                break;
            case Request_GetPersonalMsgList://私信列表
                [self parserPersonalMsgList:dic];
                break;
            case Request_deleteMsgById://删除私信
                [self parserSaveExposureSalary:dic];
                break;
            case Request_GetContactList://留言联系人列表
                [self parserGetContactList:dic];
                break;
            case Request_GetNewNewsList://新消息列表
                [self parserNewNewsList:dic];
                break;
            //case Request_CreateNewGroup:
               // [self parserAddGroup:dic];
                //break;
            case Request_DeletePersonAllMsg://删除某个联系人的信息
                [self parserSaveExposureSalary:dic];
                break;
            case Request_ScanQrCode://扫描二维码
                [self parserScanQrCode:dic];
                break;
            case Request_LoginAuth://授权登录
                [self parserLoginAuth:dic];
                break;
            case Request_GetServiceNumber://获取服务码
                [self parserGetServiceNumber:dic];
                break;
            case Request_RegistNoCode://无验证码注册
                [self parserRegistNoCode:dic];
                break;
            case Request_ShareSalaryArticle:
                [self parserShareSalaryArticle:dic];
                break;
            case Request_UpdateNickName:
                [self updateNickName:dic];
                break;
            case Request_PermissionInGroup:
                [self parserPermissionInGroup:dic];
                break;
            case Request_GetArticleFileInfo:
                [self parserFileInfo:dic];
                break;
            case Request_AddAttentionCompany:
                [self parserAddAttentionCompany:dic];
                break;
            case Request_CancelAttentionCompany:
                [self parserCancelAttentionCompany:dic];
                break;
            case Request_GetAttentionCompanyList:
//                [self parserGetAttentionCompanyList:dic];
                [self parserCareCompany:dic];
                break;
            case Request_UploadImgData:
                [self parserUploadImgData:dic];
                break;
            case Request_GetSalaryPrediction:
                [self parserGetSalaryPrediction:dic];
                break;
            case Request_GetSalaryExpert:
                [self parserGetSalaryExpert:dic];
                break;
            case Request_GetResumeRcomparison:
                [self parserGetResumeRcomparison:dic];
                break;
            case Request_MessageList:
                [self parserMessageList:dic];
                break;
            case Request_OneMessageList:
                [self parserOneMessageList:dic];
                break;
            case Request_ShareLogs:
                [self parserShareLogs:dic];
                break;
            case Request_addQuestionnaire:
                [self parserAddQuestionnaire:dic];
                break;
            case Request_GetYl1001HIList:
                [self parserYL1001HIList:dic];
                break;
            case Request_GetPersonDetail:
                [self parserGetPersonDetailWithPersonId:dic];
                break;
            case Request_CompanyLogin:
                [self parserCompanyLogin:dic];
                break;
            case Request_CompanyHRDetail:
                [self parserCompanyHRDetail:dic];
                break;
            case Request_CompanyInterviewEmail:
                [self parserCompanyInterview:dic];
                break;
            case Request_CompanyQuestion:
                [self parserCompanyQuestion:dic];
                break;
            case Request_CompanyResume:
                [self parserCompanyResume:dic];
                break;
            case Request_CompanyRecommendedResume:
                [self parserCompanyRecommendedResume:dic];
                break;
            case Request_ResumeURL:
                [self parserResumeUrl:dic];
                break;
            case Request_PositionDetail3GURL_:
                [self parserPositionDetail3GURL:dic];
                break;
            case Request_DoHRAnswer:
                [self parserDoHRAnswer:dic];
                break;
            case Request_SetResumePass:
                [self parserSetResumePass:dic];
                break;
            case Request_GetCompanyOtherHR:
                [self parserCompanyOtherHR:dic];
                break;
            case Request_TranspondResume:
                [self parserTranspondResume:dic];
                break;
            case Request_TranspondGuwenResume:
                [self parserTranspondResume:dic];
                break;
            case Request_GetInterviewModel:
                [self parserInterviewModel:dic];
                break;
            case Request_GetCompanyZWForUsing:
                [self parserCompanyZWForUsing:dic];
                break;
            case Request_SendInterview:
                [self parserSendInterview:dic];
                break;
            case Request_GetServiceUrl:
                [self parserServiceURL:dic];
                break;
            case Request_ArticleAddLike:
                [self parserArticleAddLike:dic];
                break;
            case Request_BindingCompany:
                [self parserBindingCompany:dic];
                break;
            case Request_GetBindingCompany:
                [self parserGetBindingCompany:dic];
                break;
            case Request_GetPositionNameWith:
                [self getPositionName:dic];
                break;
            case Request_GetCompanyPositionDetailUrl:
                [self parserCompanyDetailUrl:dic];
                break;
            case Request_SetNewMailRead:
                [self parserSetNewMailRead:dic];
                break;
            case Request_AttendCareerSchool:
                [self parserAttendCareerSchool:dic];
                break;
            case Request_ChangAttendCareerSchool:
                [self parserChangAttendCareerSchool:dic];
                break;
            case Request_GetAttendSchoolList:
                [self getAttendSchoolList:dic];
                break;
            case Request_GetSchoolXJHList:
                [self parserGetSchoolXJHList:dic];
                break;
            case Request_SalaryCompareResult:
                [self parserSalaryCompareResult:dic];
                break;
            case Request_UploadVoiceFile:
                [self parserUpdateVoiceFile:dic];
                break;
            case Request_UploadPhotoFile:
                [self parserUploadPhoto:dic];
                break;
            case Request_AddResumePhoto:
                [self parserAddResumePhoto:dic];
                break;
            case Request_GetResumePhotoAndVoice:
                [self parserGetResumePhotoAndVoice:dic];
                break;
            case Request_DeleteResumeImage:
                [self parserDeleteResumeImage:dic];
                break;
            case Request_AddResumeVoice:
                [self parserAddResumeVoice:dic];
                break;
            case Request_SalarySearchResult:
                [self parserSalarySearchResult:dic];
                break;
            case Request_SalarySearchResult2:
                [self parserSalarySearchResult2:dic];
                break;
            case Request_CancelBindCompany:
                [self parserCancelBindCompany:dic];
                break;
            case Request_AddAttentionSchoolWithUserId:
                [self parserAddAttentionSchool:dic];
                break;
            case Request_HISearchExpert:
                [self parserHISearchExpert:dic];
                break;
            case Request_NearbyWork:
                [self parserGetNearbyWork:dic];
                break;
            case Request_DetectBinding:
                [self parserDetectBinding:dic];
                break;
            case Request_BuildPerson:
                [self parserBuildPerson:dic];
                break;
            case Request_MyCenterVisit:
                [self parserMyCenterVisitLog:dic];
                break;
            case Request_UpdateGroups:
                [self parserUpdateGroups:dic];
                break;
            case Request_GetSchoolZPShareUrl:
                [self parserSchoolZPShareUrl:dic];
                break;
            case Request_GuwenLoadResumeList:
                [self paserGuwenLoadResumeList:dic];
                break;
            case Request_getSameTradePerson:
                [self parserGetSameTradePerson:dic];
                break;
            case Request_getNewSameTradePerson:
                [self parserGetNewSameTradePerson:dic];
                break; 
            case Request_GetFriend:
                [self parserGetFriend:dic];
                break;
            case Request_getNewFriendAndComment:
                [self parserGetNewFriendAndComment:dic];
                break;
            case  Request_GuwenCallPerson:
                [self paserGuwenCallPerson:dic];
                break;
            case Request_GetMyArticleCommentList:
                [self parserGetMyArticleCommentList:dic];
                break;
            case Request_GetPersonCenterData:
                [self parserGetPersonCenterData:dic];
                break;
            case Request_GetMyCommentList:
                [self parserMyCommentList:dic];
                break;
            case Request_SystemNotificationList:
                [self parserMySystemNotification:dic];
                break;
            case Request_SayHiList:
                [self parserSayHiList:dic];
                break;
            case Request_LetterList:
                [self parserLetterList:dic];
                break;
            case Request_GroupsMessageList:
                [self parserGroupsMessageList:dic];
                break;
            case Request_GetTagsList:
                [self parserGetTagsList:dic];
                break;
            case Request_GetTradeTagsList:
                [self parserGetTradeTagsList:dic];
                break;
            case Request_GetSkillTradeTagsList:
                [self parserGetSkillTradeTagsList:dic];
                break;
            case Request_GunwenLoadResume:
                [self paserGunwenLoadResume:dic];
                break;
            case Request_GetHotTagAndChildTag:
                [self GetHotTagAndChildTag:dic];
                break;
            case Request_GetTagsBySecondTag:
                [self parserGetSkillTradeTagsList:dic];
                break;
            case Request_GetJobTagsList:
                [self parserGetJobTagsList:dic];
                break;
            case Request_UpdateTagsList:
                [self parserUpdateTagsList:dic];
                break;
            case Request_SendMessage:
                [self parserSendMessage:dic];
                break;
            case Request_MyAQlist:
                [self parsermyAQlist:dic];
                break;
            case Request_AnswerInterview:
                [self parserAnswerInterviewQuestion:dic];
                break;
            case Request_InterviewList:
                [self parserGetInterviewList:dic];
                break;
            case Request_GetShowMoreAnswer:
                [self parserGetShowMoreAnswer:dic];
                break;
            case Request_GetMessageCtn:
                [self parserMessageCnt:dic];
                break;
            case Request_GetTraderPeson:
                [self parserGetTraderPeson:dic];
                break;
            case Request_GetGroupsCount:
                [self parserGetGroupsCnt:dic];
                break;
            case Request_GetCompanyCollectionResume:
                [self parserCompanyCollectionResume:dic];
                break;
            case Request_GetCompanyTurnTomeResume:
                [self parserCompanyTurnToMeResume:dic];
                break;
            case Request_DownloadResume:
                [self parserDownloadResume:dic];
                break;
            case Request_CompanyIslookPersonContact:
                [self parserDownloadResume:dic];
                break;
            case Request_CollectResume:
                [self parserCollectResume:dic];
                break;
            case Request_GetSalaryArticleByES:
                [self parserGetSalaryArticle:dic];
                break;
            case Request_GetSalaryArticleListByES:
                [self parserGetSalaryArticleListByES:dic];
                break;
            case Request_GetSalaryNavList:
                [self parserGetSalaryNavList:dic];
                break;
            case Request_GetProfessionList:
                [self parserGetProfessionList:dic];
                break;
            case Request_GetProfessionChildList:
                [self parserGetProfessionChildList:dic];
                break;
            case Request_GetResumeComplete:
                [self parserGetResumeComplete:dic];
                break;
            case Request_DeleteArticle:
                [self parserDeleteArticle:dic];
                break;
            case Request_ToReport:
                [self parserToReportIllegalArticle:dic];
                break;
            case Request_SetRecommendArticle:
                [self parserSetRecommendArticle:dic];
                break;
            case Request_SaveRecommendSet:
                [self parserSaveRecommendSet:dic];
                break;
            case Request_DeleteGroupArticle:
                [self parserDeleteGroupArticle:dic];
                break;
            case Request_LogOut:
            case Request_Sleep:
            case Request_Quit:
                [self parserUserStatus:dic];
                break;
            case Request_CommentListOld:
                [self parserCommentListOld:dic];
                break;
            case Request_ActivityPeopleList:
                [self parserActivityPeopleListDictionary:dic];
                break;
            case Request_GetInveteGroupWithUserId:
                [self parserGetInveteGroupWithUserId:dic];
                break;
            case Request_GetPersonInfoWithPersonId:
                [self parserGetPersonInfo:dic];
                break;
            case Request_inviteSearchFans:
                [self searchInviteFans:dic];
                break;
            case Request_ResumeCommentTag:
                [self parserResumeCommentTagList:dic];
                break;
            case Request_DownloadResumeList:
                [self parserDownloadResumeList:dic];
                break;
            case Request_ResumeCommentList:
                [self parserResumeCommentList:dic];
                break;
            case Request_OtherCompanyAccountList:
                [self parserOtherCompanyAccountList:dic];
                break;
            case Request_AddResumeComment:
                [self parserAddResumeComment:dic];
                break;
            case Request_shareArticleDyanmic:
                [self parserShareArticleDyanmic:dic];
                break;
            case Request_CompanySearchResume:
                [self parserCompanySearchResume:dic];
                break;
            case Request_ReceiveMessage:
                [self parserReceiveMessageCallback:dic];
                break;
            case Request_GetSalaryCompeteSum:
                [self parserSalaryCompareSum:dic];
                break;
            case Request_ResumeInfo:
                [self parserGetResumeInfo:dic];
                break;
            case Request_updateResumeInfo:
                [self parserUpdateResumeInfoWithPersonId:dic];
                break;
            case Request_SheidCompany:
                [self parserGetSheidCompanyList:dic];
                break;
            case Request_GetCompany:
                [self parserGetCompany:dic];
                break;
            case Request_setSheidCompany:
                [self parserSetSheidCompany:dic];
                break;
            case Request_MyBadgesList:
                [self parserMybadgesList:dic];
                break;
            case Request_MyPrestige:
                [self parserMyPrestige:dic];
                break;
            case Request_TopAD:
                [self parserTopAD:dic];
                break;
            case Request_MyPrestigeList:
                [self parserMyPrestigeList:dic];
                break;
            case Request_GetPersonCenter1:
                [self parserGetPersonCenter1:dic];
                break;
            case Request_GetPersonCenter2:
                [self parserGetPersonCenter2:dic];
                break;
            case Request_GetOrderReocrd:
                [self parserOrderRecord:dic];
                break;
            case Request_GetSalaryOrderRecord:
                [self parserSalaryOrderRecord:dic];
                break;
            case Request_GetOrderServiceInfo:
                [self parserOrderServiceInfo:dic];
                break;
            case Request_GetResumeApplyServiceInfo:
                [self parserResumeApplyServiceInfo:dic];
                break;
            case Request_GetSalaryServiceInfo:
                [self parserSalaryServiceInfo:dic];
                break;
            case Request_GenShoppingCart:
                [self parserGenShoppingCart:dic];
                break;
            case Request_DashangShoppingCart:
                [self parserDashangShoppingCart:dic];
                break;
            case Request_ApplyResumeRecommend:
                [self parserGetShareMessage:dic];
                break;
            case Request_GetServiceStatus:
                [self parserGetServiceStatus:dic];
                break;
            case Request_ResumeApplyStatus:
                [self parserResumeApplyStatus:dic];
                break;
            case Request_GetWXPrepayId:
                [self parserGetServiceStatus:dic];
                break;
            case Request_MessageClickLog:
                [self parserMessageClickLog:dic];
                break;
            case Request_GetMyGroupsJobAndCompany:
                [self parserGetGroupJobAndCompany:dic];
                break;
            case Request_GetQuerySalaryList:
                [self parserGetQuerySalaryList:dic];
                break;
            case Request_ResumeCompare:
                [self parserResumeCompare:dic];
                break;
            case Request_GetQuerySalaryCount:
                [self parserGetQuerySalaryCount:dic];
                break;
            case request_TodayFocusList://今日看点
                [self parserTodayFocusList:dic];
                break;
            case getMessageWithId:
                [self parsergetMessageWith:dic];
                break;
            case request_NewPublicArticle:
                [self parsergetNewPublicArticle:dic];
                break;
            case Request_HeadButtonList:
                [self parserTableHeadButtonList:dic];
                break;
            case request_TotalTradeList:
                [self parserTotalTradeListDic:dic];
                break;
            case Request_SalaryHotJobList:
                [self parserSalaryHotJobList:dic];
                break;
            case request_SalaryMap://薪指图表
                [self parserGetQuerySalaryCount:dic];
                break;
            case Request_getMoreHotIndustry:
                [self getMoreHoIndustryListDictionary:dic];
                break;
            case request_getSalaryForecast:
                [self parserGetSalaryForecastWithZyName:dic];
                break;
            case Request_getShareMessageOther:
                [self parserGetShareMessage:dic];
                break;
            case Request_delegateMessage:
                [self parserDelegateMessage:dic];
                break;
            case Request_ExposureTitle:
                [self parserExposureTitle:dic];
                break;
            case Request_GetExposureSalaryNum://曝工资用户数
                [self parserExposureTitle:dic];
                break;
            case Request_SaveExposureSalary://保存曝工资
                [self parserSaveExposureSalary:dic];
                break;
            case Request_getWhoLikeMeList:
                [self getWhoLikeMeDictionary:dic];
                break;
            case Request_deleteWhoLikeMeMessage:
                [self deleteWhoLikeMeMessage:dic];
                break;
            case Request_GetArticleApply:
                [self parserGetArticleApply:dic];
                break;
            case Request_GetOfferPartyList://offer派列表
                [self parserGetOfferPartyList:dic];
                break;
            case Request_GetUserOfferPartyList://user offer派列表
                [self parserGetOfferPartyList:dic];
                break;
            case Request_GetUserOfferPartyCompanyList://user offer派company列表
                [self parserUserOfferPartyCompanyList:dic];
                break;
            case Request_GetOfferPartyCompanyList://offer派company列表
                [self parserOfferPartyCompanyList:dic];
                break;
            case Request_GetOfferPartyPersonCnt://offer派人数统计
                [self parserExposureTitle:dic];
                break;
            case Request_GetCompanyInfo://企业信息
                [self parserGetCompanyInfo:dic];
                break;
//            case Request_GetHeaderOfferPai:
//            {
//                [self parserGetCompanyHeader:dic];
//            }
//                break;
            case Request_GetOfferPartyPersonList://简历列表
//                [self parserOfferPartyPersonList:dic];
                break;
            case Request_DealResumeStates://简历批量处理
                [self parserExposureTitle:dic];
                break;
            case Request_nearWords://附近职位
//                [self paserNearWords:dic];
                [self parserNearPosition:dic];
                break;
            case Request_ConsultantSearchResume:
                [self paserGunwenSearchResume:dic];
                break;
            case Request_GuwenRecomResumeList:
                [self paserGuwenRecomResumeList:dic];
                break;
            case Request_GunwenSearchCompany:
                [self paserGunwenSearchCompany:dic];
                break;
            case Request_GunwenTrade:
                [self paserGunwenTrade:dic];
                break;
            case Request_RecommendPerson:
                [self paserRecommendPerson:dic];
                break;
            case Request_UpdateAddressBook:
            case Request_AddressBookList:
                [self getAddressBookDictionary:dic];
                break;
            case Request_consultantVisitNum:
                //[self paserConsultantVisitNum:dic];
                break;
            case request_GetGuwenVistList:
                [self paserGetGuwenVistList:dic];
                break;
            case request_GetReplyList:
                [self paserGetReplyList:dic];
                break;
            case request_addVisit:
                [self paserAddVisit:dic];
                break;
            case Request_GetPersonOfferPartyCount:
                [self parserGetServiceStatus:dic];
                break;
//            case Request_GetPersonListByFairId:
////                [self paserGetPersonListByFairId:dic];
//                break;
            case Request_GetJobFairCompany:
                [self paserGetJobFairCompany:dic];
                break;
            case Request_RecommendPersonToCompany:
                [self paserRecommendPersonToCompany:dic];
                break;
            case Request_GetOfferPartyCount:
                [self paserGetOfferPartyCount:dic];
                break;
            case Request_joinPerson:
                [self paserJoinPerson:dic];
                break;
            case Request_SignInOfferParty://offer派签到
                [self paserJoinPerson:dic];
                break;
            case Request_SearchMoreGroupList:
                [self parserMoreGoupListDictionary:dic];
                break;
            case Request_GetItemCompany:
                [self paserGetItemCompany:dic];
                break;
            case Request_GetUnRecomPersonList:
                [self paserGetUnRecomPersonList:dic];
                break;
            case Request_AskQuestTags: //解析请求提问标签
                [self paserAskQuestTags:dic];
                break;
            case Request_AddPersonToOffer:
                [self addPersonToOfferDictionary:dic];
                break;
            case Request_getLastTelTime:
                [self paserGetLastTelTime:dic];
                break;
            case Request_getJobGuideExpertList:
                [self parsergetJobGuideExpertList:dic];
                break;
//            case Request_getExpertInfo:
//                [self parserJobGuideExpertInfo:dic];
//                break;
            case Request_GetGuwenEmail:
                [self paserGetGuwenEmail:dic];
                break;
            case Request_GetReplyCommentList:
                [self parserReplyCommentList:dic];
                break;
            case Request_GetExpertCommentList:
                [self parserExpertCommentList:dic];
                break;
            case Request_GetAddtExpertComment:
                [self parserAddExpertComment:dic];
                break;
            case Request_GetApplicationList:
                [self parserApplicationList:dic];
                break;
            case Request_GetMyAccount:
                [self paserGetOfferPartyCount:dic];
                break;
            case Request_GetRewardList:
                [self paserGetRewardRecord:dic];
                break;
            case Request_ApplyCash:
                [self parserAddComment:dic];
                break;
            case request_PayWithyuer:
                [self parserPayWithyuer:dic];
                break;
            case Request_OfferPartyDetailUrl:
                [self parserExposureTitle:dic];
                break;
            case Request_AspectantDisList:
                [self parserAspectantDisList:dic];
                break;
            case Request_getCourseList:
                [self parserInterviewCourseList:dic];
                break;
            case Request_getZpListWithCompanyId:
                [self parserGetZpListWithCompanyId:dic];
                break;
            case Request_getZWFBInfoWithCompanyId:
                [self parserGetZWFBInfoWithCompanyId:dic];
                break;
            case Request_ADDJob:
                [self parserAddPositionWithCompanyId:dic];
                break;
            case Request_getArticleRewardImg:
                [self parserArticleRewardImg:dic];
                break;
            case Request_getMyRewardList:
                [self parserMyRewardList:dic];
                break;
            case Request_TodaySearchList:
            {
                [dataArr_ addObject:dic];
            }
                break;
            case Request_GetExpertRegionList:
            {
                [self parserExpertRegionList:dic];
            }
                break;
            case  Request_SearchMoreArticleList:
            {
                [self parserMoreArticleList:dic];
            }
                break;
            case Request_GroupChatList:
                [self parserGroupChatList:dic];
                break;
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//解析token
-(void) parserAccessToken:(NSDictionary *)dic
{
    AccessToken_DataModal *dataModal = [[AccessToken_DataModal alloc] init];
    
    dataModal.sercet_ = [dic objectForKey:@"secret"];
    dataModal.accessToken_ = [dic objectForKey:@"access_token"];
    
    [dataArr_ addObject:dataModal];
}


//解析用户名是否存在
-(void) parserValidUserName:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc]init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}

//解析登录
-(void) parserLogin:(NSDictionary *)dic
{
    User_DataModal *dataModal = [[User_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"errorno"];
    dataModal.des_ = [dic objectForKey:@"errortips"];
    NSDictionary * infoDic = [dic objectForKey:@"errorinfo"];
    dataModal.userId_ = [infoDic objectForKey:@"id"];
    dataModal.name_ = [infoDic objectForKey:@"iname"];
    dataModal.uname_ = [infoDic objectForKey:@"uname"];
    dataModal.img_ = [infoDic objectForKey:@"pic"];
    dataModal.sex_ = [infoDic objectForKey:@"sex"];
    dataModal.prnd_ = [infoDic objectForKey:@"Prnd"];
    dataModal.school_ = [infoDic objectForKey:@"school"];
    dataModal.nickname_ = [infoDic objectForKey:@"nickname"];
    NSString *city = [infoDic objectForKey:@"place_city"];
    NSString *province = [infoDic objectForKey:@"place_province"];
    dataModal.hka_= [NSString stringWithFormat:@"%@%@",province,city];
    dataModal.zye_ = [infoDic objectForKey:@"job"];
    dataModal.tradeName = [infoDic objectForKey:@"tradeName"];
    dataModal.intentionJob = [infoDic objectForKey:@"intention_job"];
    dataModal.job_ = [infoDic objectForKey:@"job_now"];
    dataModal.followCnt_ = [[infoDic objectForKey:@"follow_cnt"] integerValue];
    dataModal.identity_ = [infoDic objectForKey:@"rctypeId"];
    dataModal.isExpert_ = [[infoDic objectForKey:@"is_expert"] boolValue];
    dataModal.role_ = [infoDic objectForKey:@"rctypeId"];  //0为应届生 1为社会人才
    dataModal.groupsCreateCnt_ = [[infoDic objectForKey:@"groups_create_cnt"]integerValue];
    dataModal.tradeId = [infoDic objectForKey:@"tradeid"];//行业ID
    dataModal.is_bindshouji = [infoDic objectForKey:@"is_bindshouji"];
    dataModal.is_yanzhengshouji = [infoDic objectForKey:@"is_yanzhengshouji"];
    dataModal.mobile_ = [infoDic objectForKey:@"shouji"];
    dataModal.token = [infoDic objectForKey:@"token"];
    [dataArr_ addObject:dataModal];
}

//解析注册手机
-(void) parserRegestPhone:(NSDictionary *)dic
{
    NSMutableString * str = [[NSMutableString alloc] initWithString:dic.description];
    
    NSInteger index = [MyCommon IndexOfContainingString:@"{" FromString:str type:YES];
    if (index > 0) {
        NSString * str = [dic.description substringFromIndex:index];
        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    
    Status_DataModal *dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析注册
-(void)parserRegister:(NSDictionary *)dic
{
    User_DataModal * dataModal = [[User_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    NSDictionary * personArr = [dic objectForKey:@"personArr"];
    dataModal.userId_ = [personArr objectForKey:@"personId"];
    dataModal.uname_ = [personArr objectForKey:@"uname"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析注册推送
-(void)parsersetSubscribeConfig:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析保存个人信息
-(void)parserSaveInfo:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析分页信息
-(PageInfo *) parserPageInfo:(NSDictionary *)dic
{
    PageInfo *pageInfo = [[PageInfo alloc] init];
    @try {
        dic = [dic objectForKey:@"pageparam"];
        pageInfo.pageCnt_ = [[dic objectForKey:@"pages"] intValue];
        pageInfo.totalCnt_ = [[dic objectForKey:@"sums"] intValue];
        if(![dic objectForKey:@"pages"])
        {
            pageInfo.pageCnt_ = pageInfo.totalCnt_/10.0 ;
        }
        
    }
    @catch (NSException *exception) {
        [MyLog Log:@"parser pageInfo error!!!" obj:self];
    }
    @finally {
        
    }
    
    return pageInfo;
}


//解析薪闻列表
-(void)parserNewsList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Article_DataModal *newsModal = [[Article_DataModal alloc]init];

//        News_DataModal * newsModal = [[News_DataModal alloc] init];
        
        newsModal.pageCnt_ = pageInfo.pageCnt_;
        newsModal.totalCnt_ = pageInfo.totalCnt_;
        
        newsModal.id_ = [subDic objectForKey:@"article_id"];
        newsModal.catId_ = [subDic objectForKey:@"cat_id"];
        if ([newsModal.catId_ isEqualToString: Release_Famous_Cate_ID]) {
            newsModal.type_ = News_Famous;
        }
        else if ([newsModal.catId_ isEqualToString:Release_Today_Cate_ID]){
            newsModal.type_ = News_Today;
        }
        else if([newsModal.catId_ isEqualToString:Release_Test_Cate_ID]){
            newsModal.type_ = News_Test;
        }
        else if ([newsModal.catId_ isEqualToString:Release_Pay_Cate_ID]){
            newsModal.type_ = News_Pay;
        }
        else if ([newsModal.catId_ isEqualToString:Release_Wage_ID]){
            newsModal.type_ = News_Wage;
        }
        else if ([newsModal.catId_ isEqualToString:Release_Jounary_ID]){
            newsModal.type_ = News_Journey;
        }
        
        //newsModal.ownname_ = [subDic objectForKey:@"own_name"];
        newsModal.url_ = [subDic objectForKey:@"_url"];
        newsModal.title_ = [MyCommon filterHTML:[subDic objectForKey:@"title"]];
        newsModal.viewCount_ = [[subDic objectForKey:@"v_cnt"] integerValue];
        newsModal.commentCount_ = [[subDic objectForKey:@"c_cnt"] integerValue];
        newsModal.likeCount_ = [[subDic objectForKey:@"like_cnt"] integerValue];
        newsModal.xw_type_ = [subDic objectForKey:@"xw_type"];
        //newsModal.updatetime_ = [subDic objectForKey:@"sysUpdatetime"];
       // newsModal.lastCommenttime_ = [subDic objectForKey:@"last_comment_time"];
        newsModal.summary_ = [subDic objectForKey:@"content"];
        newsModal.thum_ = [subDic objectForKey:@"thumb"];
        newsModal.thum_ = [MyCommon convertImagePath:newsModal.thum_];
        newsModal.summary_ = [MyCommon filterHTML:newsModal.summary_];
        newsModal.summary_ = [MyCommon removeHTML2:newsModal.summary_];
        newsModal.summary_ = [MyCommon filterDoubleWrapLine:newsModal.summary_];
        newsModal.summary_ = [newsModal.summary_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        newsModal.summary_ = [newsModal.summary_ stringByReplacingOccurrencesOfString:@"/r" withString:@""];
        newsModal.summary_ = [newsModal.summary_ stringByReplacingOccurrencesOfString:@"/n" withString:@""];
        //newsModal.author_ = [self parserAuthor:[subDic objectForKey:@"authorinfo"]];
        [dataArr_ addObject:newsModal];        
    }
}


//解析薪闻详情内的推荐专家信息
-(void)parserNewsRecommendExpert:(NSDictionary*)dic
{
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] initWithExpertDetailDictionary:dic];
    [dataArr_ addObject:dataModal];
}

//解析薪闻中的作者信息
-(User_DataModal*)parserAuthor:(NSDictionary*)dic
{
    User_DataModal * userModal = [[User_DataModal alloc] init];
    
    userModal.userId_ = [dic objectForKey:@"author_id"];
    userModal.name_ = [dic objectForKey:@"author_nickname"];
    userModal.img_ = [dic objectForKey:@"author_img"];
    
    return userModal;
}

//解析文章详情
-(void) parserArticleDetail:(NSDictionary *) dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    
    for ( NSDictionary *subDic in arr ) {
        Article_DataModal *dataModal = [[Article_DataModal alloc]init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        dataModal.articleImgArray = [subDic objectForKey:@"_pic_list"];
        dataModal.id_ = [subDic objectForKey:@"article_id"];
        dataModal.content_ = [subDic objectForKey:@"content"];
        dataModal.ownname_ = [subDic objectForKey:@"own_name"];
        dataModal.updatetime_ = [subDic objectForKey:@"ctime"];
        dataModal.commentCount_ = [[subDic objectForKey:@"c_cnt"] integerValue];
        dataModal.viewCount_ = [[subDic objectForKey:@"v_cnt"] integerValue];
        dataModal.likeCount_ = [[subDic objectForKey:@"like_cnt"] integerValue];
        dataModal.isLike_ = [[subDic objectForKey:@"_is_favorite"] boolValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dataModal.updatetime_ longLongValue]];
        NSString * dateFomate = @"yyyy-MM-dd HH:mm:ss";
        dataModal.updatetime_ = [MyCommon getDateStr:date format:dateFomate];
        
        dataModal.content_ = dataModal.content_;
        dataModal.title_ = [MyCommon filterHTML:[subDic objectForKey:@"title"]];
        dataModal.thum_  = [subDic objectForKey:@"thumb"];
        dataModal.summary_ = [subDic objectForKey:@"summary"];
        
        
        [dataArr_ addObject:dataModal];
        
    }
    
    
}

//解析文章评论列表
-(void) parserCommentList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for ( NSDictionary *subDic in arr ) {
            ELGroupCommentModel *dataModal = [[ELGroupCommentModel alloc] initWithDictionaryOne:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataModal changeCellHeight];
            dataModal.isLiked = [Manager getIsLikeStatus:dataModal.id_];
            [dataArr_ addObject:dataModal];
        }
    }
}

//解析评论
-(Comment_DataModal *) parserCommentModal:(NSDictionary *)dic
{
    Comment_DataModal *dataModal = [[Comment_DataModal alloc] init];
    dataModal.id_ = [dic objectForKey:@"id"];
    dataModal.userId_ = [dic objectForKey:@"user_id"];
    dataModal.objectId_ = [dic objectForKey:@"article_id"];
    dataModal.datetime_ = [dic objectForKey:@"ctime"];
    dataModal.content_ = [dic objectForKey:@"content"];
    dataModal.content_ = [MyCommon filterHTML:dataModal.content_];
    //dataModal.content_ = [MyCommon removeHTML2:dataModal.content_];
    dataModal.agreeCount = [[dic objectForKey:@"agree"] integerValue];
    dataModal.picList = dic[@"_pic_list"];
//    @try {
//        NSArray * child = [dic objectForKey:@"child_list"];
//        if (child) {
//            for (NSDictionary * subDic in child) {
//                Comment_DataModal * subcomment = [self parserCommentModal:subDic];
//                
//                [dataModal.childList_ addObject:subcomment];
//            }
//            
//        }
//        
//    }
//    @catch (NSException *exception) {
//        dataModal.next_ = nil;
//    }
//    @finally {
//    }
    
    @try {
//        dataModal.author = [self parserAuthorInfo:[dic objectForKey:@"authorinfo"]];
        //评论人信息
        Author_DataModal *authorDataModel = [[Author_DataModal alloc]init];
        NSDictionary *authorDict = dic[@"_person_detail"];
        authorDataModel.id_ = authorDict[@"personId"];
        authorDataModel.iname_ = authorDict[@"person_iname"];
        authorDataModel.nickname_ = authorDict[@"person_nickname"];
        authorDataModel.img_ = authorDict[@"person_pic"];
        dataModal.author = authorDataModel;
        
        NSDictionary *parentAuthorDict = dic[@"_parent_person_detail"];
        if (parentAuthorDict) {
            Author_DataModal *parentAuthorDataModel = [[Author_DataModal alloc]init];
            parentAuthorDataModel.iname_ = parentAuthorDict[@"person_iname"];
            dataModal.parentAuthor = parentAuthorDataModel;
        }
        
    }
    @catch (NSException *exception) {
        dataModal.author = nil;
    }
    @finally {
    }
    
    //父评论
    @try {
        NSDictionary *parentCommentDict = dic[@"_parent_comment"];
        if (parentCommentDict) {
            Comment_DataModal *parentComment = [self parserCommentModal:parentCommentDict];
            dataModal.parent_ = parentComment;
        }
    }
    @catch (NSException *exception) {
        dataModal.parent_ = nil;
    }
    @finally {
    }
    
    return dataModal;
}

//解析作者信息
-(Author_DataModal*)parserAuthorInfo:(NSDictionary *)dic
{
    Author_DataModal * datamodal = [[Author_DataModal alloc] init];
    
    datamodal.id_ = [dic objectForKey:@"author_id"];
    datamodal.nickname_ = [dic objectForKey:@"author_nickname"];
    datamodal.img_ = [dic objectForKey:@"person_pic"];
    if (!datamodal.img_||[datamodal.img_ isEqual:[NSNull null]]||[datamodal.img_ isEqualToString:@""]||[datamodal.img_ isEqualToString:@"http://img.job1001.com/myUpload/pic.gif"]) {
        datamodal.img_ = [dic objectForKey:@"author_img"];
    }
    datamodal.articleNum_ = [[dic objectForKey:@"author_article_num"] integerValue];
    datamodal.replyNum_ = [[dic objectForKey:@"author_article_reply_num"] integerValue];
    datamodal.company_ = [dic objectForKey:@"author_company_name"];
    datamodal.post_ = [dic objectForKey:@"author_post"];
    datamodal.isDV  = [dic objectForKey:@"author_isdv"];
    datamodal.type_ = [dic objectForKey:@"author_type"];
    datamodal.iname_ = [dic objectForKey:@"author_iname"];
    datamodal.createrName_ = [dic objectForKey:@"person_iname"];
    
    return datamodal;
    
    
}

//解析添加评论
-(void) parserAddComment:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:dataModal];
}

//解析灌薪水评论
-(void) parserAddGxsComment:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}


//解析个人信息
-(void) parserUserInfo:(NSDictionary *) dic
{
    User_DataModal * dataModal = [[User_DataModal alloc] init];
    
    dataModal.userId_ = [dic objectForKey:@"personId"];
    dataModal.name_ = [dic objectForKey:@"person_iname"];
    dataModal.sex_ = [dic objectForKey:@"person_sex"];
    dataModal.email_ = [dic objectForKey:@"person_emial"];
    dataModal.zym_ = [dic objectForKey:@"trade_job_desc"];
    dataModal.zye_ = [dic objectForKey:@"person_zw"];
    dataModal.motto_ = [dic objectForKey:@"person_signature"];
    dataModal.nickname_ = [dic objectForKey:@"person_nickname"];
    dataModal.img_ = [dic objectForKey:@"person_pic"];
    dataModal.company_ = [dic objectForKey:@"person_company"];
    dataModal.job_ = [dic objectForKey:@"person_job_now"];
    dataModal.identity_ = [dic objectForKey:@"rctypeId"];
    
    NSDictionary * expertDic = [dic objectForKey:@"expert_detail"];
    dataModal.isExpert_ = [[expertDic objectForKey:@"is_expert"] boolValue];
    
    NSDictionary * countDic = [dic objectForKey:@"count_list"];
    dataModal.followCnt_ = [[countDic objectForKey:@"follow_count"] integerValue];
    dataModal.fansCnt_ = [[countDic objectForKey:@"fans_count"] integerValue];
    dataModal.publishCnt_ = [[countDic objectForKey:@"publish_count"] integerValue];
    dataModal.groupsCnt_ = [[countDic objectForKey:@"groups_mine_count"] integerValue];
    dataModal.groupsCreateCnt_ = [[countDic objectForKey:@"groups_count"] integerValue];
    dataModal.answerCnt_ = [[countDic objectForKey:@"answer_count"] integerValue];
    dataModal.questionCnt_ = [[countDic objectForKey:@"question_count"] integerValue];
    dataModal.companyAttenCnt_ = [[countDic objectForKey:@"company_count"] integerValue];
    dataModal.regionProvince_ = [dic objectForKey:@"place_province"];
    dataModal.regionCity_ = [dic objectForKey:@"place_city"];
    dataModal.regionHka_ = [dic objectForKey:@"hka"];
    dataModal.mobile_ = [dic objectForKey:@"person_mobile"];
    //登录用户名
    dataModal.uname_   = [dic objectForKey:@"person_mobile"];
    [dataArr_ addObject:dataModal];
    
}

//解析我的社群
-(void) parserMyGroupsList:(NSDictionary *) dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSDictionary *subDic = [dic objectForKey:@"data"];
    NSArray *arr = [subDic objectForKey:@"group_list"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dicOne in arr){
            ELGroupListDetailModel *model = [[ELGroupListDetailModel alloc] initWithDictionary:dicOne];
            model.pageCnt_ = pageInfo.pageCnt_;
            model.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:model];
        }
    }
}

-(Groups_DataModal *)creatGroup:(NSDictionary *)subDic andPage:(PageInfo *)pageInfo
{
    Groups_DataModal *dataModal = [[Groups_DataModal alloc] init];
    dataModal.pageCnt_ = pageInfo.pageCnt_;
    dataModal.totalCnt_ = pageInfo.totalCnt_;
    if ([Manager shareMgr].haveLogin) {
        dataModal.code_ = [[subDic objectForKey:@"group_person_rel"] objectForKey:@"code"];
    }
    dataModal.intro_ = [subDic objectForKey:@"group_intro"];
    dataModal.openstatus_ = [subDic objectForKey:@"group_open_status"];
    dataModal.idatetime_ = [subDic objectForKey:@"idatetime"];
    dataModal.id_ = [subDic objectForKey:@"group_id"];
    dataModal.createrId_ = [subDic objectForKey:@"group_person_id"];
    dataModal.name_ = [subDic objectForKey:@"group_name"];
    dataModal.groupCode_ = [subDic objectForKey:@"group_number"];
    dataModal.isCreater_ = [[subDic objectForKey:@"is_grouper"] boolValue];
    dataModal.tags_ = [subDic objectForKey:@"group_tag_names"];
    dataModal.pic_ = [subDic objectForKey:@"group_pic"];
    dataModal.personCnt_ = [[subDic objectForKey:@"group_person_cnt"]intValue];
    dataModal.articleCnt_ = [[subDic objectForKey:@"group_article_cnt"] integerValue];
    dataModal.msgCtn_ = [[subDic objectForKey:@"_dynamic_cnt"] integerValue];

    @try {
        dataModal.publishPerm_ = [[[subDic objectForKey:@"_perm_list"] objectForKey:@"topic_publish"] boolValue];
    }
    @catch (NSException *exception) {
        dataModal.publishPerm_ = NO;
    }
    
    @try {
        dataModal.invitePerm_ = [[[subDic objectForKey:@"_perm_list"] objectForKey:@"member_invite"] boolValue];
    }
    @catch (NSException *exception) {
        dataModal.invitePerm_ = NO;
    }
    if ([subDic objectForKey:@"_article_list"] && ![[subDic objectForKey:@"_article_list"] isEqual:[NSNull null]] )
    {
        NSDictionary * artDic = [[subDic objectForKey:@"_article_list"] objectAtIndex:0];
        if (artDic) {
            dataModal.firstArt_ = [[Article_DataModal alloc] init];
            dataModal.firstArt_.id_ = [artDic objectForKey:@"article_id"];
            dataModal.firstArt_.title_ = [artDic objectForKey:@"title"];
            dataModal.firstArt_.idatetime_ = [artDic objectForKey:@"ctime_date"];
        }
    }
    else {
        if ([subDic objectForKey:@"_article"] && ![[subDic objectForKey:@"_article"] isEqual:[NSNull null]] ) {
            NSDictionary * artDic = [[subDic objectForKey:@"_article"] objectAtIndex:0];
            dataModal.firstArt_ = [[Article_DataModal alloc] init];
            dataModal.firstArt_.id_ = [artDic objectForKey:@"article_id"];
            dataModal.firstArt_.personID_ = [artDic objectForKey:@"own_id"];
            dataModal.firstArt_.title_ = [artDic objectForKey:@"title"];
            dataModal.firstArt_.personName_ = [[artDic objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
            if ([artDic objectForKey:@"_comment"] && ![[artDic objectForKey:@"_comment"] isEqual:[NSNull null]]) {
                NSDictionary * commentDic = [[artDic objectForKey:@"_comment"] objectAtIndex:0];
                dataModal.firstComm_ = [[Comment_DataModal alloc] init];
                dataModal.firstComm_.id_ = [commentDic objectForKey:@"id"];
                dataModal.firstComm_.objectId_ = [commentDic objectForKey:@"article_id"];
                dataModal.firstComm_.userId_ = [commentDic objectForKey:@"user_id"];
                dataModal.firstComm_.userName_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
            }
            else
            {
                dataModal.firstComm_ = nil;
            }
        }
    }
    return dataModal;
}

//解析推荐社群
-(void) parserRecommendGroupsList:(NSDictionary *) dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Groups_DataModal *dataModal = [self parserGroups:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//解析单个社群信息
-(Groups_DataModal*)parserGroups:(NSDictionary*)dic
{
    Groups_DataModal * dataModal = [[Groups_DataModal alloc] init];
    dataModal.groupCode_ = [dic objectForKey:@"group_number"];
    dataModal.id_ = [dic objectForKey:@"group_id"];
    dataModal.createrId_ = [dic objectForKey:@"group_person_id"];
    dataModal.name_ = [dic objectForKey:@"group_name"];
    dataModal.code_ = [[dic objectForKey:@"group_person_rel"] objectForKey:@"code"];
    dataModal.intro_ = [dic objectForKey:@"group_intro"];
    dataModal.openstatus_ = [dic objectForKey:@"group_open_status"];
    dataModal.personCnt_ = [[dic objectForKey:@"group_person_cnt"] integerValue];
    dataModal.articleCnt_ = [[dic objectForKey:@"group_article_cnt"] integerValue];
    dataModal.creater_ = [self parserGroupAuthor:[dic objectForKey:@"group_person_detail"]];
    dataModal.idatetime_ = [dic objectForKey:@"idatetime"];
    dataModal.tags_ = [dic objectForKey:@"group_tag_names"];
    dataModal.pic_ = [dic objectForKey:@"group_pic"];
    @try {
        NSDictionary * artDic = [[dic objectForKey:@"_article_list"] objectAtIndex:0];
        if (artDic) {
            dataModal.firstArt_ = [[Article_DataModal alloc] init];
            dataModal.firstArt_.id_ = [artDic objectForKey:@"article_id"];
            dataModal.firstArt_.title_ = [artDic objectForKey:@"title"];
            dataModal.firstArt_.idatetime_ = [artDic objectForKey:@"ctime_date"];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return dataModal;
}

//解析社群创建者信息
-(Expert_DataModal *)parserGroupAuthor:(NSDictionary*)dic
{
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
    
    dataModal.id_ = [dic objectForKey:@"personId"];
    dataModal.iname_ = [dic objectForKey:@"person_iname"];
    dataModal.sex_ = [dic objectForKey:@"person_sex"];
    dataModal.email_ = [dic objectForKey:@"person_email"];
    dataModal.mobilequhao_ = [dic objectForKey:@"person_mobile_quhao"];
    dataModal.mobile_ = [dic objectForKey:@"person_mobile"];
    dataModal.job_ = [dic objectForKey:@"person_job_now"];
    dataModal.gznum_ = [dic objectForKey:@"person_gznum"];
    dataModal.company_ = [dic objectForKey:@"person_cpmpany"];
    dataModal.img_ = [dic objectForKey:@"person_pic"];
    dataModal.nickname_ = [dic objectForKey:@"person_nickname"];
    dataModal.signature_ = [dic objectForKey:@"person_signature"];
    dataModal.group_rel = [[dic objectForKey:@"group_person_rel"] objectForKey:@"code"];
    return dataModal;
}


//解析社群话题列表
-(void)parserGroupArticleList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
//    NSDictionary *groupDic = [[dic objectForKey:@"data"]objectForKey:@"group"];  //社群详情
//    ELGroupDetailModal *groupMessageDataModal = [[ELGroupDetailModal alloc] initWithDictionary:groupDic];
    
    NSArray *topArray = [[dic objectForKey:@"data"] objectForKey:@"top_article"];
    NSMutableArray  *topArticleArray = [[NSMutableArray alloc]init];
    if ([topArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *topDic in topArray) {
            TodayFocusFrame_DataModal *dataModal = [[TodayFocusFrame_DataModal alloc] init];
            ELGroupArticleDetailModel *model = [[ELGroupArticleDetailModel alloc] initWithDictionary:topDic];
            dataModal.groupRecommentModel = model;
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [topArticleArray addObject:dataModal];
        }
    }
    NSArray *arr = [[dic objectForKey:@"data"] objectForKey:@"article"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for ( NSDictionary *subDic in arr ) {
            TodayFocusFrame_DataModal *dataModal = [[TodayFocusFrame_DataModal alloc] init];
            ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:subDic];
            if (model.content.length > 0) {
                model.summary = model.content;
            }
            dataModal.articleType_ = Article_Group;
            
            dataModal.sameTradeArticleModel = model;
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            if(model.article_id) {
                [dataArr_ addObject:dataModal];
            }
        }
    }
    NSMutableArray *groupMessageArray = [[NSMutableArray alloc]init];
//    [groupMessageArray addObject:groupMessageDataModal];
    [groupMessageArray addObject: topArticleArray];
    [dataArr_ addObject:groupMessageArray];
}


//解析社群话题列表
-(void)parserSearchGroupArticleList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for ( NSDictionary *subDic in arr ) {
            Article_DataModal *dataModal = [self parserArticle:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:dataModal];
        }
    }
}


//解析单个社群话题列
-(Article_DataModal*)parserArticle:(NSDictionary*)dic
{
    Article_DataModal * datamodal = [[Article_DataModal alloc] init];
    datamodal.id_ = [dic objectForKey:@"article_id"];
    if ([[dic objectForKey:@"_is_top"] isEqualToString:@"0"]) {
        datamodal.isTop_ = NO;
    }else{
        datamodal.isTop_ = YES;
    }
    datamodal.title_ = [dic objectForKey:@"title"];
    datamodal.viewCount_ = [[dic objectForKey:@"v_cnt"] integerValue];
    datamodal.commentCount_ = [[dic objectForKey:@"c_cnt"] integerValue];
    datamodal.likeCount_ = [[dic objectForKey:@"like_cnt"] integerValue];
    datamodal.idatetime_ = [dic objectForKey:@"ctime"];
    datamodal.updatetime_ = [dic objectForKey:@"sysUpdatetime"];
    datamodal.lastCommenttime_ = [dic objectForKey:@"last_comment_time"];
    datamodal.zhiyeId_ = [dic objectForKey:@"zhiye"];
    datamodal.thum_ = [dic objectForKey:@"thumb"];
    datamodal.zhiyeName_ = [dic objectForKey:@"zhiye_name"];
    //内容
    datamodal.content_ = [dic objectForKey:@"content"];
    datamodal.content_ = [MyCommon removeHTML2:datamodal.content_];
    datamodal.content_ = [MyCommon filterHTML:datamodal.content_];
    datamodal.content_ = [MyCommon filterDoubleWrapLine:datamodal.content_];
    datamodal.content_ = [datamodal.content_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    datamodal.content_ = [datamodal.content_ stringByReplacingOccurrencesOfString:@"/r" withString:@""];
    datamodal.content_ = [datamodal.content_ stringByReplacingOccurrencesOfString:@"/n" withString:@""];

    
    //简介
    datamodal.summary_ = [dic objectForKey:@"summary"];
    //datamodal.summary_ = [MyCommon removeHTML2:datamodal.summary_];
//    datamodal.summary_ = [MyCommon filterHTML:datamodal.summary_];
//    datamodal.summary_ = [MyCommon filterDoubleWrapLine:datamodal.summary_];
//    datamodal.summary_ = [datamodal.summary_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//    datamodal.summary_ = [datamodal.summary_ stringByReplacingOccurrencesOfString:@"/r" withString:@""];
//    datamodal.summary_ = [datamodal.summary_ stringByReplacingOccurrencesOfString:@"/n" withString:@""];
    
    //发表人信息
    datamodal.imageArray_ = [dic objectForKey:@"_pic_list"];
    NSDictionary * personDic = [dic objectForKey:@"_person_detail"];
    datamodal.personName_ = [ personDic objectForKey:@"person_iname"];
    datamodal.personID_ = [personDic objectForKey:@"personId"];
    datamodal.personImg_ = [personDic objectForKey:@"person_pic"];
    datamodal.nickName_ = [personDic objectForKey:@"person_nickname"];
    datamodal.expert_ = [[Expert_DataModal alloc] init];
    datamodal.expert_.zw_ = [personDic objectForKey:@"person_zw"];
    //所有评论数组
    NSArray * commentArr = [dic objectForKey:@"_comment_list"];
    if (!commentArr||[commentArr isEqual:[NSNull null]]) {
        datamodal.commentArr_ = nil;
    }
    else{
        for (NSDictionary * commentDic in commentArr) {
            Comment_DataModal * dataModal = [[Comment_DataModal alloc] init];
            dataModal.id_ = [commentDic objectForKey:@"id"];
            dataModal.objectId_ = [commentDic objectForKey:@"article_id"];
            dataModal.parentId = [commentDic objectForKey:@"parent_id"];
            dataModal.userId_ = [commentDic objectForKey:@"user_id"];
            dataModal.content_ = [commentDic objectForKey:@"content"];
            dataModal.content_ = [MyCommon translateHTML:dataModal.content_];
            dataModal.datetime_ = [commentDic objectForKey:@"ctime"];
            dataModal.userName_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
            dataModal.imageUrl_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_pic"];
            dataModal.nickName_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_nickname"];
            NSDictionary* parentDic = [commentDic objectForKey:@"_parent_person_detail"];
            dataModal.parent_ = [[Comment_DataModal alloc] init];
            if ([parentDic isKindOfClass:[NSDictionary class]]) {
                dataModal.parent_.userId_ = [parentDic objectForKey:@"personId"];
                dataModal.parent_.userName_ = [parentDic objectForKey:@"person_iname"];
                dataModal.parent_.imageUrl_ = [parentDic objectForKey:@"person_pic"];
                dataModal.parent_.nickName_ = [parentDic objectForKey:@"person_nickname"];
            }else{
                dataModal.parent_.userId_ = @"";
                dataModal.parent_.userName_ = @"";
                dataModal.parent_.imageUrl_ = @"";
                dataModal.parent_.nickName_ = @"";
            }
            [datamodal.commentArr_ addObject:dataModal];
        }
    }
    return  datamodal;
}

//解析我的发表列表
-(void)parserMyPubilshList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * dataArray = [dic objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSNull class]]) {//没有数据
        dataArray = @[];
    }
    for (NSDictionary * subDic in dataArray) {
        TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:subDic];
        if (model._activity_info) {
            dataModal.isActivityArtcle = YES;
            model._activity_info.person_id = model.personId;
            model._activity_info.person_pic = model.person_pic;
            model._activity_info.person_iname = model.person_iname;
        }
        dataModal.articleType_ = Article_Follower;
        if (model._group_info) {
            if (model._group_info.group_id && ![model._group_info.group_id isEqualToString:@""]) {
                dataModal.articleType_ = Article_Group;
            }
        }
        dataModal.sameTradeArticleModel = model;
        if(model.article_id) {
            [dataArr_ addObject:dataModal];
        }
    }//结束循环
}

//解析我的社群的话题详情
-(void)parserGroupArticleDetail:(NSDictionary*)dic
{
    Article_DataModal * dataModal = [[Article_DataModal alloc] initWithArticleDetailDictionary:dic];
    NSDictionary *expertDic = [[dic objectForKey:@"data"] objectForKey:@"person_detail"];
    Expert_DataModal *model = [[Expert_DataModal alloc]initWithArticleDetailExpertNSDctionary:expertDic];
    [dataArr_ addObject:dataModal];
    [dataArr_ addObject:model];
}

//解析意见反馈
-(void) parserGiveAdvice:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:dataModal];
}

//解析版本检查
-(void) parserVersionCheck:(NSDictionary *)dic
{
    VersionInfo_DataModal *dataModal = [[VersionInfo_DataModal alloc] init];
    
    dataModal.version_ = [dic objectForKey:@"version"];
    dataModal.url_ = [dic objectForKey:@"url"];
    dataModal.msg_ = [dic objectForKey:@"msg"];
    dataModal.level_ = [dic objectForKey:@"level"];
    
    [dataArr_ addObject:dataModal];
}



//解析一览大厅列表
-(void) parserHomeList:(NSDictionary*) dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Home_DataModal *dataModal = [self parserHomeData:subDic];
        
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        if (!dataModal.totalCnt_) {
            dataModal.totalCnt_ = 0 ;
            dataModal.pageCnt_ = 0 ;
        }
        else
            dataModal.pageCnt_ = dataModal.totalCnt_/6.0;
        [dataArr_ addObject:dataModal];
    }

}

//解析一览大厅单个动态
-(Home_DataModal*)parserHomeData:(NSDictionary*)dic
{
    Home_DataModal * dataModal = [[Home_DataModal alloc] init];
    
    dataModal.updatetime_ = [dic objectForKey:@"updatetime"];
    NSString * typeStr = [dic objectForKey:@"nf_type"];
    if ([typeStr isEqualToString:@"yl1001_follower"]) {
        dataModal.type_ = Home_Expert;
    }
    else if ([typeStr isEqualToString:@"yl1001_group"])
    {
        dataModal.type_ = Home_Groups;
    }
    else{
        dataModal.type_ = Home_Others;
    }
    dataModal.typeId_ = [dic objectForKey:@"nf_type_id"];
    
    if (dataModal.type_ == Home_Expert) {
        dataModal.personInfo = [self parserPersonInfo:[dic objectForKey:@"_person_info_"]];
    }
    if (dataModal.type_ == Home_Groups) {
        dataModal.groupInfo = [self parserGroups:[dic objectForKey:@"_group_info_"]];
    }
    
    
    
    NSArray * list = [dic objectForKey:@"_article_list_"];
    NSDictionary * commentList = [dic objectForKey:@"_article_comment_list_"];
    for (int i = 0 ; i < [list count]; ++i) {
        NSDictionary * subDic = [list objectAtIndex:i];
        Article_DataModal * article = [self parserArticleInfo:subDic];
        NSString * key = [NSString stringWithFormat:@"comment_%@",article.id_];
        NSArray * comment = [commentList objectForKey:key];
        if (!comment||[comment isEqual:[NSNull null]]) {
            article.commentContent_  = nil;
        }
        else{
            article.commentContent_ = [[comment objectAtIndex:0] objectForKey:@"content"];
            article.commentContent_ = [MyCommon filterHTML:article.commentContent_];
            article.commentContent_ = [MyCommon removeHTML2:article.commentContent_];
            article.commentContent_ = [MyCommon filterDoubleWrapLine:article.commentContent_];
            NSDictionary * persondic = [[comment objectAtIndex:0] objectForKey:@"_person_detail"];
            article.commentpersonName_ = [persondic objectForKey:@"person_iname"];
        }
        
        
        [dataModal.articleArray_ addObject:article];
    }
    
    return dataModal;
    
}


//解析一览大厅中的行家信息
-(Expert_DataModal*) parserPersonInfo:(NSDictionary *) dic
{
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
    
    dataModal.id_ = [dic objectForKey:@"personId"];
    dataModal.iname_ = [dic objectForKey:@"person_iname"];
    dataModal.zw_ = [dic objectForKey:@"person_zw"];
    dataModal.introduce_ = [dic objectForKey:@"intro"];
    
    dataModal.email_ = [dic objectForKey:@"person_email"];
    dataModal.sex_ = [dic objectForKey:@"person_sex"];
    dataModal.job_ = [dic objectForKey:@"person_job_now"];
    dataModal.gznum_ = [dic objectForKey:@"person_gznum"];
    dataModal.company_ = [dic objectForKey:@"person_company"];
    dataModal.nickname_ = [dic objectForKey:@"person_nickname"];
    dataModal.signature_ = [dic objectForKey:@"person_signature"];
    dataModal.trade_ = [dic objectForKey:@"trade_job_desc"];
    dataModal.followStatus_ = 1;
    dataModal.img_ = [dic objectForKey:@"person_pic"];
    
    
    NSDictionary * expertDetail = [dic objectForKey:@"expert_detail"];
    dataModal.goodat_ = [expertDetail objectForKey:@"good_at"];
    
    NSDictionary * countlist = [dic objectForKey:@"count_list"];
    dataModal.questionCnt_ = [[countlist objectForKey:@"question_count"] integerValue];
    dataModal.answerCnt_ = [[countlist objectForKey:@"answer_count"] integerValue];
    dataModal.followCnt_ = [[countlist objectForKey:@"follow_count"] integerValue];
    dataModal.fansCnt_ = [[countlist objectForKey:@"fans_count"] integerValue];
    dataModal.letterCnt_ = [[countlist objectForKey:@"letter_count"] integerValue];
    dataModal.publishCnt_ = [[countlist objectForKey:@"publish_count"] integerValue];
    dataModal.groupsCnt_ = [[countlist objectForKey:@"groups_count"] integerValue];
    
    return dataModal;
    
}

//解析一览大厅的话题信息
-(Article_DataModal*)parserArticleInfo:(NSDictionary*)subDic
{
    Article_DataModal * newsModal = [[Article_DataModal alloc] init];
    
    
    newsModal.catId_ = [subDic objectForKey:@"pro_id"];
    newsModal.id_ = [subDic objectForKey:@"article_id"];
    newsModal.ownname_ = [subDic objectForKey:@"own_name"];
    if (!newsModal.ownname_) {
        NSDictionary * dic = [subDic objectForKey:@"_person_detail"];
        newsModal.ownname_ = [dic objectForKey:@"person_iname"];
    }
    newsModal.title_ = [subDic objectForKey:@"title"];
    newsModal.viewCount_ = [[subDic objectForKey:@"v_cnt"] integerValue];
    newsModal.commentCount_ = [[subDic objectForKey:@"c_cnt"] integerValue];
    newsModal.likeCount_ = [[subDic objectForKey:@"like_cnt"] integerValue];
    newsModal.updatetime_ = [subDic objectForKey:@"sysUpdatetime"];
    newsModal.lastCommenttime_ = [subDic objectForKey:@"last_comment_time"];
    newsModal.summary_ = [subDic objectForKey:@"summary"];
    if (newsModal.summary_ && ![newsModal.summary_ isEqualToString:@""]) {
        //newsModal.summary_ = [MyCommon filterHTML:newsModal.summary_];
        //newsModal.summary_ = [MyCommon removeHTML2:newsModal.summary_];
        //newsModal.summary_ = [MyCommon filterDoubleWrapLine:newsModal.summary_];
        //newsModal.summary_ = [newsModal.summary_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        //newsModal.summary_ = [newsModal.summary_ stringByReplacingOccurrencesOfString:@"/r" withString:@""];
        //newsModal.summary_ = [newsModal.summary_ stringByReplacingOccurrencesOfString:@"/n" withString:@""];
    }
   
    
    newsModal.fileUrl_ = [subDic objectForKey:@"file_url"];
    newsModal.fileId_ = [subDic objectForKey:@"file_id"];
    newsModal.fileName_ = [subDic objectForKey:@"file_name"];
    newsModal.fileExe_ = [subDic objectForKey:@"file_exe"];
    newsModal.filePages_ = [[subDic objectForKey:@"file_pages"] integerValue];
    newsModal.fileDownloadCnt_ = [[subDic objectForKey:@"file_download_cnt"] integerValue];
    newsModal.fileGrade_ = [subDic objectForKey:@"file_grade"];
    newsModal.fileSize_ = [subDic objectForKey:@"file_size"];
    newsModal.filePath_ = [subDic objectForKey:@"file_path"];
    newsModal.fileHtmlPath_ = [subDic objectForKey:@"file_html_path"];
    
    if (newsModal.fileId_) {
        newsModal.summary_ = @"内容为文档内容，暂不支持查看";
    }
    
    return newsModal;

}

//解析推荐行家列表
-(void) parserExpertList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        //Expert_DataModal *dataModal = [self parserExpertInfo:subDic];
        Article_DataModal * dataModal = [self parserExpertArticleInfo:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        //dataModal.isExpert_ = YES;
        [dataArr_ addObject:dataModal];
    }

}


-(Article_DataModal*)parserExpertArticleInfo:(NSDictionary*)dic
{
    Article_DataModal * dataModal = [[Article_DataModal alloc] init];
    dataModal.expert_ = [[Expert_DataModal alloc] init];
    dataModal.articleType_ = Article_Follower;
    dataModal.isTJExpertArticle_ = YES;
    NSDictionary* expertDic = [dic objectForKey:@"person_detail"];
    dataModal.expert_.id_ = [expertDic objectForKey:@"personId"];
    dataModal.expert_.iname_ = [dic objectForKey:@"person_iname"];
    dataModal.expert_.img_ = [expertDic objectForKey:@"person_pic"];
    dataModal.expert_.zw_ = [expertDic objectForKey:@"person_zw"];
    dataModal.expert_.isExpert_ = [[[expertDic objectForKey:@"expert_detail"] objectForKey:@"is_expert"] boolValue];
    
    @try {
        NSDictionary* articleDic = [[expertDic objectForKey:@"article_list"] objectAtIndex:0];
        dataModal.id_ = [articleDic objectForKey:@"article_id"];
        dataModal.title_ = [articleDic objectForKey:@"title"];
        dataModal.thum_ = [articleDic objectForKey:@"thumb"];
        dataModal.idatetime_ = [articleDic objectForKey:@"ctime"];
        dataModal.viewCount_ = [[articleDic objectForKey:@"v_cnt"] integerValue];
        dataModal.commentCount_ = [[articleDic objectForKey:@"c_cnt"] integerValue];
        dataModal.likeCount_ = [[articleDic objectForKey:@"like_cnt"] integerValue];
        dataModal.imageArray_ = [articleDic objectForKey:@"_pic_list"];
        dataModal.summary_  = [articleDic objectForKey:@"summary"];
        //所有评论数组
        NSArray * commentArr = [articleDic objectForKey:@"_comment_list"];
        if (!commentArr||[commentArr isEqual:[NSNull null]]) {
            dataModal.commentArr_ = nil;
        }
        else{
            
            for (NSDictionary * commentDic in commentArr) {
                Comment_DataModal * commentModal = [[Comment_DataModal alloc] init];
                commentModal.id_ = [commentDic objectForKey:@"id"];
                commentModal.objectId_ = [commentDic objectForKey:@"article_id"];
                commentModal.parentId = [commentDic objectForKey:@"parent_id"];
                commentModal.userId_ = [commentDic objectForKey:@"user_id"];
                commentModal.content_ = [commentDic objectForKey:@"content"];
                commentModal.datetime_ = [commentDic objectForKey:@"ctime"];
                //commentModal.content_ = [MyCommon translateHTML:dataModal.content_];
                commentModal.userName_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
                commentModal.imageUrl_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_pic"];
                commentModal.nickName_ = [[commentDic objectForKey:@"_person_detail"] objectForKey:@"person_nickname"];
                NSDictionary* parentDic = [commentDic objectForKey:@"_parent_person_detail"];
                commentModal.parent_ = [[Comment_DataModal alloc] init];
                @try {
                    commentModal.parent_.userId_ = [parentDic objectForKey:@"personId"];
                    commentModal.parent_.userName_ = [parentDic objectForKey:@"person_iname"];
                    commentModal.parent_.imageUrl_ = [parentDic objectForKey:@"person_pic"];
                    commentModal.parent_.nickName_ = [parentDic objectForKey:@"person_nickname"];
                }
                @catch (NSException *exception) {
                    commentModal.parent_.userId_ = @"";
                    commentModal.parent_.userName_ = @"";
                    commentModal.parent_.imageUrl_ = @"";
                    commentModal.parent_.nickName_ = @"";
                }
                @finally {
                    
                }
                [dataModal.commentArr_ addObject:commentModal];
            }
            
        }

    }
    @catch (NSException *exception) {
        dataModal.commentArr_ = nil;
    }
    
    
    return dataModal;

}


//解析单个行家信息
-(Expert_DataModal*)parserExpertInfo:(NSDictionary*)dic
{
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
    
    dataModal.id_ = [dic objectForKey:@"personId"];
    dataModal.iname_ = [dic objectForKey:@"person_iname"];
    dataModal.zw_ = [dic objectForKey:@"person_zw"];
    dataModal.introduce_ = [dic objectForKey:@"intro"];
    
    NSDictionary * personDetail = [dic objectForKey:@"person_detail"];
    dataModal.email_ = [personDetail objectForKey:@"person_email"];
    dataModal.sex_ = [personDetail objectForKey:@"person_sex"];
    dataModal.job_ = [personDetail objectForKey:@"person_zw"];
    dataModal.gznum_ = [personDetail objectForKey:@"person_gznum"];
    dataModal.company_ = [personDetail objectForKey:@"person_company"];
    dataModal.nickname_ = [personDetail objectForKey:@"person_nickname"];
    dataModal.signature_ = [personDetail objectForKey:@"person_signature"];
    dataModal.trade_ = [personDetail objectForKey:@"trade_job_desc"];
    dataModal.followStatus_ = [[personDetail objectForKey:@"rel"] integerValue];
    dataModal.img_ = [personDetail objectForKey:@"person_pic"];
    if (!dataModal.img_) {
        dataModal.img_ = [dic objectForKey:@"person_pic"];
    }
    
    NSDictionary * expertDetail = [personDetail objectForKey:@"expert_detail"];
    dataModal.goodat_ = [expertDetail objectForKey:@"good_at"];
    if(!dataModal.goodat_||[dataModal.goodat_ isEqualToString:@""])
    {
        dataModal.goodat_ = @"暂无";
    }
    dataModal.isExpert_ = [[expertDetail objectForKey:@"is_expert"] boolValue];
    NSDictionary * countlist = [personDetail objectForKey:@"count_list"];
    dataModal.questionCnt_ = [[countlist objectForKey:@"question_count"] integerValue];
    dataModal.answerCnt_ = [[countlist objectForKey:@"answer_count"] integerValue];
    dataModal.followCnt_ = [[countlist objectForKey:@"follow_count"] integerValue];
    dataModal.fansCnt_ = [[countlist objectForKey:@"fans_count"] integerValue];
    dataModal.letterCnt_ = [[countlist objectForKey:@"letter_count"] integerValue];
    dataModal.publishCnt_ = [[countlist objectForKey:@"publish_count"] integerValue];
    dataModal.groupsCreateCnt_ = [[countlist objectForKey:@"groups_count"] integerValue];
    dataModal.groupsCnt_ = [[countlist objectForKey:@"groups_mine_count"] integerValue];
    
    //文章
    NSArray *articleArray = [personDetail objectForKey:@"article_list"];
    if ([articleArray isKindOfClass:[NSArray class]]) {
        NSDictionary *articleDic = [articleArray objectAtIndex:0];
        dataModal.articleId_ = [articleDic objectForKey:@"article_id"];
        dataModal.articleTitle_ = [articleDic objectForKey:@"title"];
        dataModal.articleImg_ = [articleDic objectForKey:@"thumb"];
        dataModal.articleVCnt_ = [[articleDic objectForKey:@"v_cnt"] integerValue];
        dataModal.articleCCnt_ = [[articleDic objectForKey:@"c_cnt"] integerValue];
        dataModal.articleLCnt_ = [[articleDic objectForKey:@"like_cnt"] integerValue];
        dataModal.articleCtime_ = [articleDic objectForKey:@"ctime"];
        dataModal.articleSummary_ = [articleDic objectForKey:@"summary"];
    }
    
    return dataModal;
    
}


//解析关注行家
-(void) parserFollowExpert:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    if ([dataModal.status_ isEqualToString:Success_Status]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFollowCnt" object:nil];
    }
    [dataArr_ addObject:dataModal];
    if([dataModal.status_ isEqualToString:@"OK"])
    {
        [[Manager shareMgr] showSayViewWihtType:4];
    }
}

//解析取消关注行家
-(void)parserCaccelFollowExpert:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    
    if ([dataModal.status_ isEqualToString:Success_Status]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MinusFollowCnt" object:nil];
    }
    
    [dataArr_ addObject:dataModal];
}

//解析加入社群
-(void)parserJoinGroup:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.status_ = [dataModal.status_ uppercaseString];
    
    [dataArr_ addObject:dataModal];

    if([dataModal.status_ isEqualToString:@"OK"])
    {
        [[Manager shareMgr] showSayViewWihtType:2];
    }
}

//解析专题列表
-(void)parserSubjextList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Subject_DataModal *dataModal = [self parserSubject:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        [dataArr_ addObject:dataModal];
    }
}

//解析单个专题
-(Subject_DataModal*)parserSubject:(NSDictionary*)dic
{
    Subject_DataModal * dataModal = [[Subject_DataModal alloc] init];
    
    dataModal.zasId_ = [dic objectForKey:@"zas_id"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.title_ = [dic objectForKey:@"title"];
    dataModal.addtime_ = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
    dataModal.content_ = [dic objectForKey:@"short_content"];
    dataModal.content_ = [MyCommon filterDoubleWrapLine:dataModal.content_];
    dataModal.content_ = [MyCommon removeHTML2:dataModal.content_];
    dataModal.content_ = [MyCommon filterHTML:dataModal.content_];
    //dataModal.content_ = [MyCommon removeWarpLine:dataModal.content_];
    dataModal.pic_ = [dic objectForKey:@"subject_pic"];
    dataModal.articleId_ = [dic objectForKey:@"article_id"];
    dataModal.proId_ = [dic objectForKey:@"pro_id"];
    
    return dataModal;
}


//解析专题详情
-(void)parserSubjectDetail:(NSDictionary*)dic
{
    Subject_DataModal * dataModal = [[Subject_DataModal alloc] init];
    
    dataModal.zasId_ = [dic objectForKey:@"zas_id"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.title_ = [dic objectForKey:@"title"];
    dataModal.addtime_ = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addtime"]];
    if (![[dic objectForKey:@"content" ] isKindOfClass:[NSString class]]) {
        dataModal.content_ = @"";
        
    }
    else
        dataModal.content_ = [dic objectForKey:@"content"];
    
    dataModal.content_ = [MyCommon convertHTML:dataModal.content_];
    NSArray * picArr = [dic objectForKey:@"all_pic"];
    if (!picArr||[picArr isEqual:[NSNull null]]) {
        dataModal.pic_ = nil;
    }
    else
        dataModal.pic_ = [[picArr objectAtIndex:0] objectForKey:@"pic"];
    dataModal.articleId_ = [dic objectForKey:@"article_id"];
    dataModal.proId_ = [dic objectForKey:@"pro_id"];
    dataModal.viewCnt_ = [dic objectForKey:@"view_count"];
    dataModal.commentCnt_ = [dic objectForKey:@"comm_count"];
    dataModal.preface_ = [dic objectForKey:@"preface"];
    dataModal.conclusion_ = [dic objectForKey:@"conclusion"];
    dataModal.url_ = [dic objectForKey:@"url"];
    
    [dataArr_ addObject:dataModal];
}

//解析薪指列表
-(void)parserSalaryList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    @try {
        NSArray *arr = [dic objectForKey:@"data"];
        for (NSDictionary *subDic in arr ) {
            ELSalaryResultModel *dataModal = [[ELSalaryResultModel alloc] initWithSalaryDictionary:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:dataModal];
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

//解析单个薪指信息
-(User_DataModal*)parserPersonSalary:(NSDictionary *)dic
{
    User_DataModal * dataModal = [[User_DataModal alloc] init];
    dataModal.userId_ =  [User_DataModal getVlaue:[dic objectForKey:@"person_id"]];
    dataModal.name_ = [User_DataModal getVlaue:[dic objectForKey:@"person_iname"]];
    dataModal.zye_ = [User_DataModal getVlaue:[dic objectForKey:@"jtzw"]];
    dataModal.sex_ = [dic objectForKey:@"person_sex"];
    dataModal.gzNum_ = [User_DataModal getVlaue:[dic objectForKey:@"person_gznum"]];
    dataModal.sendtime_ = [User_DataModal getVlaue:[dic objectForKey:@"sendtime_show"]];
    dataModal.regiondetail_ = [User_DataModal getVlaue:[dic objectForKey:@"zw_regionid_show"]];
    dataModal.salary_ = [User_DataModal getVlaue:[dic objectForKey:@"person_yuex"]];
    dataModal.zym_ = [User_DataModal getVlaue:[dic objectForKey:@"zw_typename"]];
    dataModal.eduName_ = [User_DataModal getVlaue:[dic objectForKey:@"edu_name"]];
    dataModal.regionId_ = [User_DataModal getVlaue:[dic objectForKey:@"zw_regionid"]];
    dataModal.school_ = [User_DataModal getVlaue:[dic objectForKey:@"school"]];
    dataModal.img_ = [dic objectForKey:@"_pic"];
    dataModal.age_ = [dic objectForKey:@"person_age"];
    
    return dataModal;
}

//解析应届生薪指列表
-(void)parserFreshSalaryList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * dataArr = [dic objectForKey:@"data"];
    if ([dataArr isKindOfClass:[NSArray class]] && dataArr.count) {
        for (NSDictionary * subDic in dataArr) {
            ELSalaryResultModel *dataModal = [[ELSalaryResultModel alloc] initWithSalaryDictionary:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:dataModal];
        }
    }
}


//解析精品观点列表
-(void)ParserViewPointList:(NSDictionary*)dic
{
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
        dataModal.id_ = [subDic objectForKey:@"expert_id"];
        dataModal.iname_ = [subDic objectForKey:@"expert_name"];
        dataModal.img_ = [subDic objectForKey:@"expert_pic"];
        dataModal.is_article = [subDic objectForKey:@"is_article"];
        if ([dataModal.is_article isEqualToString:@"1"]) {
            dataModal.articleId_ = [subDic objectForKey:@"article_id"];
        }
        else
            dataModal.articleId_ = [subDic objectForKey:@"comment_id"];
        if (![subDic objectForKey:@"content"]||![[subDic objectForKey:@"content"] isKindOfClass:[NSString class]]) {
            dataModal.content_ = @"";
        }
        else
            dataModal.content_ = [subDic objectForKey:@"content"];
        //dataModal.content_ = [MyCommon removeWarpLine:dataModal.content_];
        dataModal.ctime_ = [subDic objectForKey:@"ctime"];
        dataModal.commentCnt_ = [subDic objectForKey:@"comm_count"];
        [dataArr_ addObject:dataModal];
    }
}

//解析精品评论内容
-(void)parserCommentContent:(NSDictionary*)dic
{
    NSString * content = [dic objectForKey:@"content"];
    [dataArr_ addObject:content];
}

//解析是否专家
-(void)parserIsExpert:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc] init];
    
    NSString *str = [dic objectForKey:@"result"];
    //NSString *str = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    if([str intValue] > 0 ){
        dataModal.status_ = Success_Status;
    }
    
    [dataArr_ addObject:dataModal];

}

//解析职导列表
-(void)parserJobGuideList:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Qikan_DataModal * dataModal = [[Qikan_DataModal alloc] initWithJobGuideListDictionary:subDic];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//解析职导详情
-(void)parserJobGuideDetail:(NSDictionary*)dic
{
    Qikan_DataModal * dataModal = [[Qikan_DataModal alloc] initWithJobGuideDetailDictionary:dic];
    [dataArr_ addObject:dataModal];
}

//解析修改密码
-(void)parserResetPwd:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析薪酬百分比
-(void)parserSalaryPercent:(NSDictionary*)dic
{
    NSDictionary * percent = [dic objectForKey:@"data"];
    
    [dataArr_ addObject:percent];
}


//解析注册推送
-(void)parserRegistNotifice:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}


//解析推荐职位
-(void)parserRecommendJob:(NSDictionary*)dic
{
    NSDictionary * dic1 = [dic objectForKey:@"data"];
    User_DataModal * dataModal = [[User_DataModal alloc] init];
    
    dataModal.status_ = [dic1 objectForKey:@"status"];
    dataModal.code_ = [dic1 objectForKey:@"code"];
    dataModal.des_ = [dic1 objectForKey:@"status_desc"];
    
    NSDictionary * subdic = [dic1 objectForKey:@"data"];
    
   
    
    dataModal.zye_ = [subdic objectForKey:@"jtzw"];
    dataModal.company_ = [subdic objectForKey:@"cname_all"];
    if (!dataModal.company_ || [dataModal.company_ isEqualToString:@""]) {
        dataModal.company_ = [subdic objectForKey:@"cname"];
    }
    dataModal.regiondetail_ = [subdic objectForKey:@"regionid_name"];
    dataModal.zym_ = [subdic objectForKey:@"trade"];
    dataModal.sendtime_ = [subdic objectForKey:@"updatetime"];
    
    [dataArr_ addObject:dataModal];
}

//解析找回密码
-(void)parserFindPassword:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析专家问答列表
-(void)parserExpertAnswerList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Answer_DataModal * dataModal = [[Answer_DataModal alloc] init];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        dataModal.answerId_ = [subDic objectForKey:@"answer_id"];
        dataModal.questionId_ = [subDic objectForKey:@"question_id"];
        dataModal.quizzerId_ = [subDic objectForKey:@"uid"];
        dataModal.content_ = [subDic objectForKey:@"answer_content"];
        if (dataModal.content_ && ![dataModal.content_ isEqual:[NSNull null]]&&![dataModal.content_ isEqualToString:@""]) {
            dataModal.content_ = [MyCommon filterHTML:dataModal.content_];
            dataModal.content_ = [MyCommon removeHTML2:dataModal.content_];
            dataModal.content_ = [MyCommon filterDoubleWrapLine:dataModal.content_];
            dataModal.content_ = [dataModal.content_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            dataModal.content_ = [dataModal.content_ stringByReplacingOccurrencesOfString:@"/r" withString:@""];
            dataModal.content_ = [dataModal.content_ stringByReplacingOccurrencesOfString:@"/n" withString:@""];
        }

        dataModal.supportCnt_ =[subDic objectForKey:@"answer_support_count"];
        dataModal.unsupportCnt_ = [subDic objectForKey:@"answer_unsupport_count"];
        dataModal.commentCnt_ = [subDic objectForKey:@"answer_comment_count"];
        dataModal.collectCnt_ = [subDic objectForKey:@"answer_collect_count"];
        dataModal.reportCnt_ = [subDic objectForKey:@"report_count"];
        dataModal.lastUpdatetime = [subDic objectForKey:@"answer_lastupdate"];
        dataModal.managerstatus_ = [subDic objectForKey:@"manage_status"];
        dataModal.questionTitle_ = [subDic objectForKey:@"question_title"];
        dataModal.quesReplyCnt_ = [subDic objectForKey:@"question_replys_count"];
        dataModal.quesViewCnt_ = [subDic objectForKey:@"question_view_count"];
        dataModal.quesFollowCnt_ = [subDic objectForKey:@"question_follow_count"];
        dataModal.quesLastUpdate_ = [subDic objectForKey:@"question_lastupdate"];
        dataModal.quizzerName_ = [subDic objectForKey:@"uname"];
        dataModal.sysUpdatetime_ = [subDic objectForKey:@"sysUpdatetime"];
        
        [dataArr_ addObject:dataModal];
    }
}

//解析问答详情（新）
-(void)parserAnswerDetailNew:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    
    NSDictionary * dicOne = [dic objectForKey:@"data"];
    
    AnswerDetialModal *answerDetialModal = [[AnswerDetialModal alloc] initWithDictionary:dicOne];
    answerDetialModal.old_question_content = answerDetialModal.question_content;
    NSString *giveTextStr = answerDetialModal.question_title;
    giveTextStr = [MyCommon MyfilterHTML:giveTextStr];
    answerDetialModal.question_title = [MyCommon translateHTML:giveTextStr];
    
    giveTextStr = answerDetialModal.question_content;
    giveTextStr = [MyCommon MyfilterHTML:giveTextStr];
    answerDetialModal.question_content = [MyCommon translateHTML:giveTextStr];
    if (answerDetialModal) {
        NSNotification *notification = [NSNotification notificationWithName:@"parserAnswerDetailNew" object:nil userInfo:[NSDictionary dictionaryWithObject:answerDetialModal forKey:@"modal"]];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    NSArray *arr = [dicOne objectForKey:@"answer_list"];
    if ([arr isKindOfClass:[NSArray class]]){
        ELButtonView *contentText = [[ELButtonView alloc] initWithTwoTypeFrame:CGRectMake(0,0,ScreenWidth-60,30)];
        ELButtonView *replyText = [[ELButtonView alloc] initWithTwoTypeFrame:CGRectMake(0,0,ScreenWidth-60,30)];
        for (NSDictionary *subDic in arr)
        {
            AnswerListModal *answerListModal = [[AnswerListModal alloc] initWithDictionary:subDic];
            answerListModal.pageCnt_ = page.pageCnt_;
            answerListModal.totalCnt_ = page.totalCnt_;
            [answerListModal creatAttString];
            [answerListModal changeAnswerContent:contentText];
            [answerListModal changeReplyContent:replyText];
            if([answerListModal.manage_status integerValue] == 0 ){
                answerListModal.cellHeight += 53;
            }else{
                answerListModal.cellHeight += 9;
            }
            NSString *giveTextStr = answerListModal.answer_content;
            giveTextStr = [MyCommon MyfilterHTML:giveTextStr];
            answerListModal.answer_content = [MyCommon translateHTML:giveTextStr];
            [dataArr_ addObject:answerListModal];
        }
    }
}

//解析提问专家
-(void)parserAskExpert:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    
    [dataArr_ addObject:dataModal];
    
}

//解析职导问答列表
-(void)parserJobGuideQuesList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        ELAnswerLableView *lableView = [[ELAnswerLableView alloc] init];
        lableView.frame = CGRectMake(0,0,ScreenWidth-16,0);
        UILabel *lable = [[UILabel alloc] init];
        lable.numberOfLines = 2;
        lable.font = [UIFont systemFontOfSize:16];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
        for (NSDictionary * subDic in arr) {
            JobGuideQuizModal *dataModal = [[JobGuideQuizModal alloc] initWithDictionary:subDic];  
            dataModal.pageCnt_ = page.pageCnt_;
            dataModal.totalCnt_ = page.totalCnt_;
            if (dataModal.tradeid && [dataModal.tradeid integerValue] != 0) {
                CondictionList_DataModal *model = [CondictionTradeCtl returnModelWithTradeId:dataModal.tradeid];
                if (model){
                    model.pName = [CondictionTradeCtl getTotalNameWithTotalId:model.pId_];
                    if (!dataModal.lableArr) {
                        dataModal.lableArr = [[NSMutableArray alloc] init];
                    }
                    ELAnswerLableModel *lableModel = [[ELAnswerLableModel alloc] init];
                    lableModel.name = [NSString stringWithFormat:@"%@-%@",model.pName,model.str_];
                    lableModel.colorType = GrayColorType;
                    lableModel.tradeModel = model;
                    [dataModal.lableArr addObject:lableModel];
                }
            }
            if ([dataModal.tag_info isKindOfClass:[NSArray class]]) {
                if (!dataModal.lableArr) {
                    dataModal.lableArr = [[NSMutableArray alloc] init];
                }
                for (NSString *name in dataModal.tag_info) {
                    ELAnswerLableModel *lableModel = [[ELAnswerLableModel alloc] init];
                    lableModel.name = name;
                    lableModel.colorType = CyanColorType;
                    [dataModal.lableArr addObject:lableModel];
                }
            }
            //用户名及行业
            NSMutableAttributedString *personStr;
            if (dataModal.person_detail.person_job_now && ![dataModal.person_detail.person_job_now isEqualToString:@""]){
                personStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@",dataModal.person_detail.person_iname,dataModal.person_detail.person_job_now]];
                [personStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbdbdbd) range:NSMakeRange(dataModal.person_detail.person_iname.length,personStr.string.length - dataModal.person_detail.person_iname.length)];
            }else if (dataModal.person_detail.person_zw && ![dataModal.person_detail.person_zw isEqualToString:@""]){
                personStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ · %@",dataModal.person_detail.person_iname,dataModal.person_detail.person_zw]];
                [personStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbdbdbd) range:NSMakeRange(dataModal.person_detail.person_iname.length,personStr.string.length - dataModal.person_detail.person_iname.length)];
            }else{
                personStr = [[NSMutableAttributedString alloc] initWithString:dataModal.person_detail.person_iname];
            }
            dataModal.personNameAttString = personStr;
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataModal.question_title];
            [string addAttributes:attributes range:NSMakeRange(0,string.length)];
            lable.frame = CGRectMake(0,0,ScreenWidth-28,0);
            [lable setAttributedText:string];
            [lable sizeToFit];
            
            dataModal.contentAttString = string;
            CGFloat lableHeight = 0;
            if (dataModal.lableArr) {
                lableHeight = [lableView getViewHeightWithModel:dataModal.lableArr];
            }
            dataModal.cellHeight = lableHeight+lable.height + (lableHeight>0 ? 113:100);
            
            [dataArr_ addObject:dataModal];  
        }
    }
}

//解析宣讲会和招聘会
-(void)parserXjhAndZph:(NSDictionary *)dic{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]){
        for (NSDictionary * subDic in arr){
            NewCareerTalkDataModal *dataModal = [NewCareerTalkDataModal new];
            dataModal.pageCnt_ = page.pageCnt_;
            dataModal.totalCnt_ = page.totalCnt_;
            [dataModal setValuesForKeysWithDictionary:subDic];
            [dataArr_ addObject:dataModal];
        }
    }
}
//宣讲会招聘会详情
-(void)parserXjhAndZphDetail:(NSDictionary *)dic{
    NewCareerTalkDataModal *dataModal = [NewCareerTalkDataModal new];
    [dataModal setValuesForKeysWithDictionary:dic];
    [dataArr_ addObject:dataModal];
}

//解析创建的社群列表
-(void)parserCreatedAssociation:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * array = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in array) {
        Home_DataModal * dataModal = [self paserOneCreatedAssociation:subDic];
        
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        if (!dataModal.totalCnt_) {
            dataModal.totalCnt_ = 0 ;
            dataModal.pageCnt_ = 0 ;
        }
        else
            dataModal.pageCnt_ = dataModal.totalCnt_/10.0;
        [dataArr_ addObject:dataModal];
    }
}

//解析单个创建的社群信息
-(Home_DataModal*)paserOneCreatedAssociation:(NSDictionary*)dic
{
    Home_DataModal * dataModal = [[Home_DataModal alloc] init];
    
    dataModal.groupInfo = [self parserGroups:dic];
    
    NSArray * list = [dic objectForKey:@"_article_list"];
    if (list && ![list isEqual:[NSNull null]]) {
        //NSDictionary * commentList = [dic objectForKey:@"_article_comment_list_"];
        for (int i = 0 ; i < [list count]; ++i) {
            NSDictionary * subDic = [list objectAtIndex:i];
            Article_DataModal * article = [self parserArticleInfo:subDic];
            
            [dataModal.articleArray_ addObject:article];
        }
    }
    
    return dataModal;
}

//解析我的已回答列表
-(void)parserMyAnswerList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Answer_DataModal * dataModal = [[Answer_DataModal alloc] init];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        dataModal.answerId_ = [subDic objectForKey:@"answer_id"];
        dataModal.questionId_ = [subDic objectForKey:@"question_id"];
        dataModal.content_ = [subDic objectForKey:@"answer_content"];
        if (dataModal.content_ && ![dataModal.content_ isEqual:[NSNull null]]&&![dataModal.content_ isEqualToString:@""]) {
            dataModal.content_ = [MyCommon filterHTML:dataModal.content_];
            dataModal.content_ = [MyCommon removeHTML2:dataModal.content_];
            dataModal.content_ = [MyCommon filterDoubleWrapLine:dataModal.content_];
            dataModal.content_ = [dataModal.content_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
            dataModal.content_ = [dataModal.content_ stringByReplacingOccurrencesOfString:@"/r" withString:@""];
            dataModal.content_ = [dataModal.content_ stringByReplacingOccurrencesOfString:@"/n" withString:@""];
        }
        
        dataModal.supportCnt_ =[subDic objectForKey:@"answer_support_count"];
        dataModal.unsupportCnt_ = [subDic objectForKey:@"answer_unsupport_count"];
        dataModal.commentCnt_ = [subDic objectForKey:@"answer_comment_count"];
        dataModal.collectCnt_ = [subDic objectForKey:@"answer_collect_count"];
        dataModal.reportCnt_ = [subDic objectForKey:@"report_count"];
        dataModal.lastUpdatetime = [subDic objectForKey:@"answer_lastupdate"];
        dataModal.managerstatus_ = [subDic objectForKey:@"manage_status"];
        
        NSDictionary * questionDic = [subDic objectForKey:@"question_detail"];
        dataModal.questionTitle_ = [questionDic objectForKey:@"question_title"];
        dataModal.quesReplyCnt_ = [questionDic objectForKey:@"question_replys_count"];
        dataModal.quesViewCnt_ = [questionDic objectForKey:@"question_view_count"];
        dataModal.quesFollowCnt_ = [questionDic objectForKey:@"question_follow_count"];
        dataModal.quesLastUpdate_ = [questionDic objectForKey:@"question_lastupdate"];
        dataModal.sysUpdatetime_ = [questionDic objectForKey:@"sysUpdatetime"];
        
        NSDictionary * quizzerDic= [questionDic objectForKey:@"person_detail"];
        dataModal.quizzerId_ = [quizzerDic objectForKey:@"personId"];
        dataModal.quizzerName_ = [quizzerDic objectForKey:@"person_iname"];
        dataModal.img_ = [quizzerDic objectForKey:@"person_pic"];
        
        
        [dataArr_ addObject:dataModal];
    }

}

//解析我的待回答列表
-(void)parserMyNotAnswerList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Answer_DataModal * dataModal = [[Answer_DataModal alloc] init];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        dataModal.questionId_ = [subDic objectForKey:@"question_id"];
        dataModal.questionTitle_ = [subDic objectForKey:@"question_title"];
        dataModal.quesReplyCnt_ = [subDic objectForKey:@"question_replys_count"];
        dataModal.quesViewCnt_ = [subDic objectForKey:@"question_view_count"];
        dataModal.commentCnt_ = [subDic objectForKey:@"comment_count"];
        NSDictionary * quizzerDic= [subDic objectForKey:@"person_detail"];
        dataModal.quizzerId_ = [quizzerDic objectForKey:@"personId"];
        dataModal.quizzerName_ = [quizzerDic objectForKey:@"person_iname"];
        dataModal.questionTime_ = [subDic objectForKey:@"question_idate"];
        [dataArr_ addObject:dataModal];
    }
}


//解析回答问题
-(void)parserAnswerQuestion:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析订阅职位
-(void)parserSubscribeJob:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析职位订阅列表
-(void)parserJobSubscribedList:(NSDictionary *)dic
{
    NSArray * arr = (NSArray *)dic;
    @try {
        for (NSDictionary * subDic in arr) {
            ZWDetail_DataModal * dataModal = [[ZWDetail_DataModal alloc] init];
            dataModal.zwID_ = [subDic objectForKey:@"zw_subscribe_id"];
            dataModal.personId_ = [subDic objectForKey:@"zw_subscribe_personId"];
            dataModal.regionId_ = [subDic objectForKey:@"zw_subscribe_regionid"];
            dataModal.keyword_ = [subDic objectForKey:@"zw_subscribe_keyword"];
            dataModal.tradeId_ = [subDic objectForKey:@"tradeid"];
            dataModal.searchTime_ = [subDic objectForKey:@"zw_subscribe_starttime"];
            dataModal.regionName_ = [subDic objectForKey:@"regionName"];
            dataModal.tradeName_ = [subDic objectForKey:@"tradeName"];
            [dataArr_ addObject:dataModal];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    

    
}

//解析删除职位订阅
-(void)parserDeleteSubscribe:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
    
}

//解析我的关注/粉丝
-(void)parserMyFollower:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Expert_DataModal *dataModal = [self parserMyFollowerInfo:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        
        [dataArr_ addObject:dataModal];
        
        
    }

}

-(Expert_DataModal*)parserMyFollowerInfo:(NSDictionary*)dic
{
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
    
    dataModal.id_ = [dic objectForKey:@"personId"];
    dataModal.followerId_ = [dic objectForKey:@"follow_personId"];
    if (![[dic objectForKey:@"person_iname"] isKindOfClass:[NSString class]]) {
        dataModal.iname_ = @"";
    }else{
         dataModal.iname_ = [dic objectForKey:@"person_iname"];
    }
    dataModal.followerName_ = [dic objectForKey:@"follow_person_iname"];
    dataModal.zw_ = [dic objectForKey:@"person_zw"];
    dataModal.introduce_ = [dic objectForKey:@"intro"];
    
    NSDictionary * personDetail = [dic objectForKey:@"person_detail"];
    dataModal.email_ = [personDetail objectForKey:@"person_email"];
    dataModal.sex_ = [personDetail objectForKey:@"person_sex"];
    dataModal.job_ = [personDetail objectForKey:@"person_job_now"];
    dataModal.gznum_ = [personDetail objectForKey:@"person_gznum"];
    dataModal.company_ = [personDetail objectForKey:@"person_company"];
    dataModal.nickname_ = [personDetail objectForKey:@"person_nickname"];
    dataModal.signature_ = [personDetail objectForKey:@"person_signature"];
    dataModal.trade_ = [personDetail objectForKey:@"trade_job_desc"];
    dataModal.followStatus_ = [[personDetail objectForKey:@"rel"] integerValue];
    dataModal.img_ = [personDetail objectForKey:@"person_pic"];
    if (!dataModal.img_) {
        dataModal.img_ = [dic objectForKey:@"person_pic"];
    }
    
    NSDictionary * expertDetail = [personDetail objectForKey:@"expert_detail"];
    dataModal.goodat_ = [expertDetail objectForKey:@"good_at"];
    if(!dataModal.goodat_||[dataModal.goodat_ isEqualToString:@""])
    {
        dataModal.goodat_ = @"暂无";
    }
    dataModal.expertId_ = [expertDetail objectForKey:@"expert_id"];
    dataModal.isExpert_ = [[expertDetail objectForKey:@"is_expert"] boolValue];
    
    NSDictionary * countlist = [personDetail objectForKey:@"count_list"];
    dataModal.questionCnt_ = [[countlist objectForKey:@"question_count"] integerValue];
    dataModal.answerCnt_ = [[countlist objectForKey:@"answer_count"] integerValue];
    dataModal.followCnt_ = [[countlist objectForKey:@"follow_count"] integerValue];
    dataModal.fansCnt_ = [[countlist objectForKey:@"fans_count"] integerValue];
    dataModal.letterCnt_ = [[countlist objectForKey:@"letter_count"] integerValue];
    dataModal.publishCnt_ = [[countlist objectForKey:@"publish_count"] integerValue];
    dataModal.groupsCnt_ = [[countlist objectForKey:@"groups_mine_count"] integerValue];
    dataModal.groupsCreateCnt_ = [[countlist objectForKey:@"groups_count"] integerValue];
    return dataModal;

}


//解析发表文章
-(void)parserShareArticle:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    [dataArr_ addObject:dataModal];
    
    if([dataModal.status_ isEqualToString:@"OK"])
    {
        [[Manager shareMgr] showSayViewWihtType:1];
    }
}

//解析发表话题
-(void)parserPublishTopic:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];

    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    
    [dataArr_ addObject:dataModal];

    if([dataModal.status_ isEqualToString:@"OK"])
    {
        [[Manager shareMgr] showSayViewWihtType:1];
    }
}


//解析有权发表话题的社群
-(void)parserGroupsCanPublish:(NSDictionary*)dic
{
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Groups_DataModal * dataModal = [[Groups_DataModal alloc] init];
        dataModal.name_ = [subDic objectForKey:@"group_name"];
        dataModal.id_ = [subDic objectForKey:@"group_id"];
        dataModal.createrId_ = [subDic objectForKey:@"group_person_id"];
        dataModal.isCreater_ = [[subDic objectForKey:@"is_grouper"] boolValue];
        dataModal.pic_ = [subDic objectForKey:@"group_pic"];
        [dataArr_ addObject:dataModal];
    }
}

//解析创建社群
-(void)parserCreateGroup:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:dataModal];
    if ([dataModal.status_ isEqualToString:@"OK"]) {
        NSDictionary *subDic = [[dic objectForKey:@"info"]objectForKey:@"group"];
        Groups_DataModal *model = [[Groups_DataModal alloc]init];
        model.code_ = [subDic objectForKey:@"group_show_grcode"];
        model.intro_ = [subDic objectForKey:@"group_intro"];
        model.openstatus_ = [subDic objectForKey:@"group_open_status"];
        model.idatetime_ = [subDic objectForKey:@"idatetime"];
        model.id_ = [subDic objectForKey:@"group_id"];
        model.createrId_ = [subDic objectForKey:@"group_person_id"];
        model.name_ = [subDic objectForKey:@"group_name"];
        model.groupCode_ = [subDic objectForKey:@"group_number"];
        model.isCreater_ = [[subDic objectForKey:@"is_grouper"] boolValue];
        model.tags_ = [subDic objectForKey:@"group_tag_names"];
        model.pic_ = [subDic objectForKey:@"group_pic"];
        model.personCnt_ = [[subDic objectForKey:@"group_person_cnt"]intValue];
        [dataArr_ addObject:model];
    }
}


//解析社群信息
-(void)parserGroupInfo:(NSDictionary*)dic
{
    Groups_DataModal * dataModal = [[Groups_DataModal alloc] init];
    dataModal.id_ = [dic objectForKey:@"group_id"];
    dataModal.name_ = [dic objectForKey:@"group_name"];
    dataModal.intro_ = [dic objectForKey:@"group_intro"];
    dataModal.pic_   = [dic objectForKey:@"group_pic"];
    dataModal.openstatus_ = [dic objectForKey:@"group_open_status"];
    dataModal.groupCode_ = [dic objectForKey:@"group_number"];
    dataModal.personCnt_ = [[dic objectForKey:@"group_person_cnt"] integerValue];
    dataModal.articleCnt_ = [[dic objectForKey:@"group_article_cnt"] integerValue];
    dataModal.auditstatus_ = [dic objectForKey:@"group_audit_status"];
    dataModal.maxMemberCnt_ = [[dic objectForKey:@"group_member_cnt_limit"] integerValue];
    dataModal.tags_ = [dic objectForKey:@"group_tag_names"];
    dataModal.updatetimeLast_ = [dic objectForKey:@"updatetime_act_last"];
    dataModal.idatetime_ = [dic objectForKey:@"idatetime"];
    dataModal.groupCode_ = [dic objectForKey:@"group_number"];
    dataModal.creater_ = [self parserGroupAuthor:[dic objectForKey:@"group_person_detail"]];
    dataModal.publishPerm_ = [[[dic objectForKey:@"group_perm_list"] objectForKey:@"topic_publish"] boolValue];
    dataModal.invitePerm_ = [[[dic objectForKey:@"group_perm_list"] objectForKey:@"member_invite"] boolValue];
    
    
    [dataArr_ addObject:dataModal];
}

//解析社群成员
-(void)parserGroupMember:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for (NSDictionary *subDic in arr ) {
        ELSameTradePeopleFrameModel *dataModel = [[ELSameTradePeopleFrameModel alloc] init];
        dataModel.pageCnt_ = pageInfo.pageCnt_;
        dataModel.totalCnt_ = pageInfo.totalCnt_;
        ELSameTradePeopleModel *model = [[ELSameTradePeopleModel alloc] initWithDictionary:subDic];
        dataModel.peopleModel = model;
        [dataArr_ addObject:dataModel];
    }
}

//解析发送要邀请
-(void)parserInvitePeople:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
//    dataModal.status_ = [dic objectForKey:@"status"];
//    dataModal.code_ = [dic objectForKey:@"code"];
//    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"link_url"];
    
    [dataArr_ addObject:dataModal];
}

//解析听众邀请列表
-(void)parserInviteFansList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [[dic objectForKey:@"data"] objectForKey:@"datalist"];
    for ( NSDictionary *subDic in arr ) {
        Expert_DataModal *dataModal = [[Expert_DataModal alloc] init];
        dataModal.pageCnt_ = 0;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.id_ = [subDic objectForKey:@"person_id"];
        dataModal.iname_ = [subDic objectForKey:@"person_iname"];
        dataModal.img_ = [subDic objectForKey:@"person_pic"];
        dataModal.zw_ = [subDic objectForKey:@"person_zw"];
        dataModal.trade_ = [subDic objectForKey:@"trade_job_desc"];
        dataModal.isInvite_ = [[subDic objectForKey:@"_is_invite"] boolValue];
        
        [dataArr_ addObject:dataModal];
        
    }
}

//解析邀请听众
-(void)parserInviteFans:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    
    [dataArr_ addObject:dataModal];
}

//解析消息设置信息
-(void)parserGetPushSetMessage:(NSDictionary *)dic
{
    for (NSString *key in dic) {
        NSLog(@"key: %@ value: %@", key, dic[key]);
        PushSetDateModel *dataModel = [[PushSetDateModel alloc]init];
        dataModel.type_ = key;
        dataModel.stutas_ = dic[key];
        [dataArr_ addObject:dataModel];
    }
}

//解析更新推送设置
-(void)parserUpdatePushSet:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSDictionary *dicc = [[dic objectForKey:@"info"]objectForKey:@"setting"];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dicc objectForKey:@"yaps_msg_val"];
    dataModal.des_ = [dicc objectForKey:@"yaps_msg_type"];
    [dataArr_ addObject:dataModal];
}



//解析退出社群
-(void)parserQuitGroup:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    
    [dataArr_ addObject:dataModal];
}

//解析社群受邀列表
-(void)parserMyInviteList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray * arr = [dic objectForKey:@"data"];
    
    for (NSDictionary * subDic in arr) {
        
        GroupInvite_DataModal * dataModal = [[GroupInvite_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.id_ = [subDic objectForKey:@"logs_id"];
        dataModal.type_ = [subDic objectForKey:@"logs_request_type"];
        dataModal.idatetime_ = [subDic objectForKey:@"logs_request_idatetime"];
        dataModal.hasDeleted_ = [[subDic objectForKey:@"logs_request_hasdeleted"] boolValue];
        dataModal.resultStatus_ = [subDic objectForKey:@"logs_respone_result_status"];
        dataModal.updatatime_ = [subDic objectForKey:@"logs_updatetime"];
        dataModal.typeName_ = [subDic objectForKey:@"logs_request_type_name"];
        dataModal.statusName_ = [subDic objectForKey:@"logs_respone_result_status_name"];
        
        dataModal.groupInfo_ = [self parserOneGroupInfo:[subDic objectForKey:@"_group_info_"]];
        dataModal.requestInfo_ = [self parserGroupAuthor:[subDic objectForKey:@"_request_person_info_"]];
        dataModal.responeInfo_ = [self parserGroupAuthor:[subDic objectForKey:@"_respone_person_info_"]];
//        if (![dataModal.groupInfo_.openstatus_ isEqualToString:@"100"]) {
//            [dataArr_ addObject:dataModal];
//        }
        [dataArr_ addObject:dataModal];
        
    }
    
}

//解析社群信息
-(Groups_DataModal*)parserOneGroupInfo:(NSDictionary*)dic
{
    Groups_DataModal * dataModal = [[Groups_DataModal alloc] init];
    dataModal.id_ = [dic objectForKey:@"group_id"];
    dataModal.name_ = [dic objectForKey:@"group_name"];
    dataModal.intro_ = [dic objectForKey:@"group_intro"];
    dataModal.openstatus_ = [dic objectForKey:@"group_open_status"];
    dataModal.personCnt_ = [[dic objectForKey:@"group_person_cnt"] integerValue];
    dataModal.articleCnt_ = [[dic objectForKey:@"group_article_cnt"] integerValue];
    dataModal.auditstatus_ = [dic objectForKey:@"group_audit_status"];
    dataModal.maxMemberCnt_ = [[dic objectForKey:@"group_member_cnt_limit"] integerValue];
    dataModal.tags_ = [dic objectForKey:@"group_tag_names"];
    dataModal.updatetimeLast_ = [dic objectForKey:@"updatetime_act_last"];
    dataModal.idatetime_ = [dic objectForKey:@"idatetime"];
    dataModal.creater_ = [self parserGroupAuthor:[dic objectForKey:@"group_person_detail"]];
    dataModal.pic_ = [dic objectForKey:@"group_pic"];
    return dataModal;
}

//解析处理社群申请
-(void)parserHandleGroupApply:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    [dataArr_ addObject:dataModal];
}

//解析处理社群邀请
-(void)parserHandleGroupInvitation:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    
    [dataArr_ addObject:dataModal];
}

//解析批量更新推送设置
-(void)parserUpdatePushSettings:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSDictionary *dicc = [[dic objectForKey:@"info"]objectForKey:@"setting"];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dicc objectForKey:@"yaps_msg_val"];
    dataModal.des_ = [dicc objectForKey:@"yaps_msg_type"];
    [dataArr_ addObject:dataModal];
}

//解析初始化推送设置
-(void)parserInitPushSetting:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    
    [dataArr_ addObject:dataModal];
}


//解析获取社群的权限
-(void)parserGetGroupPermission:(NSDictionary*)dic
{
    GroupPermission_DataModal * dataModal = [[GroupPermission_DataModal alloc ]init];
    dataModal.groupId_ = [dic objectForKey:@"group_id"];
    dataModal.joinStatus_ = [[dic objectForKey:@"group_open_status"] integerValue];
    dataModal.publishStatus_ = [[dic objectForKey:@"gs_topic_publish"] integerValue];
    dataModal.inviteStatus_ = [[dic objectForKey:@"gs_member_invite"] integerValue];
    dataModal.publishArr_ = [[NSMutableArray alloc] init];
    @try {
        NSArray * arr = [dic objectForKey:@"_topic_publish_list"];
        if (arr&& [arr count]>0) {
            for (NSDictionary * subDic in arr) {
                NSString * userId = [subDic objectForKey:@"person_id"];
                [dataModal.publishArr_ addObject:userId];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    
    dataModal.InviteArr_ = [[NSMutableArray alloc] init];
    @try {
        NSArray * arr = [dic objectForKey:@"_member_invite_list"];
        if (arr&& [arr count]>0) {
            for (NSDictionary * subDic in arr) {
                NSString * userId = [subDic objectForKey:@"person_id"];
                [dataModal.InviteArr_ addObject:userId];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    
    [dataArr_ addObject:dataModal];
   
}

//解析设置社群的权限
-(void)parserSetGroupPermission:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}


//解析请求问答点赞
- (void)parserUpdateAnserSupportCount:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];

    [dataArr_ addObject:dataModal];
}


//解析请求增加问答评论
- (void)parserSubmitAnwserComment:(NSDictionary *)dic
{
    
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = dic[@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析获取问答评论
- (void)parserGetAnswerCommentList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Comment_DataModal *dataModal = [self parserAnswerCommentModal:subDic];
        
        
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        [dataArr_ addObject:dataModal];
    }
}

//解析问答评论
-(Comment_DataModal *) parserAnswerCommentModal:(NSDictionary *)dic
{
    Comment_DataModal *dataModal = [[Comment_DataModal alloc] init];
    dataModal.id_ = [dic objectForKey:@"comment_id"];
    dataModal.userId_ = [dic objectForKey:@"uid"];
    dataModal.objectId_ = [dic objectForKey:@"relative_id"];
    dataModal.datetime_ = [dic objectForKey:@"comment_idate"];
    dataModal.content_ = [dic objectForKey:@"comment_content"];
    dataModal.content_ = [MyCommon MyfilterHTML:dataModal.content_];
    dataModal.content_ = [MyCommon removeHTML2:dataModal.content_];
    Author_DataModal *auth = [[Author_DataModal alloc]init];
    auth.iname_ = [dic objectForKey:@"iname"];
    auth.img_ = [dic objectForKey:@"pic"];
    dataModal.author = auth;
    @try {
        NSArray * child = [dic objectForKey:@"reply_list"];
        if (child) {
            for (NSDictionary * subDic in child) {
                Comment_DataModal * subcomment = [self parserAnswerCommentModal:subDic];
                
                [dataModal.childList_ addObject:subcomment];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        dataModal.next_ = nil;
    }
    @finally {
    }
    
    return dataModal;
}

//解析提问
- (void)parserAskQuest:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSDictionary *dicOne = dic[@"data"];
    dataModal.status_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"info"];
    if ([dicOne isKindOfClass:[NSDictionary class]] && dataModal.status_.length <= 0) {
        dataModal.status_ = [dicOne objectForKey:@"status_desc"];
        dataModal.code_ = [dicOne objectForKey:@"code"];
        dataModal.des_ = [dicOne objectForKey:@"info"];
    }
    [dataArr_ addObject:dataModal];
}

//解析找回密码
-(void) parserFindPwd:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"findpwd_id"];
    [dataArr_ addObject:dataModal];
}

//解析核对验证码
-(void) parserCheckCode:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"findpwd_id"];
    
    
    [dataArr_ addObject:dataModal];
}

//解析重置密码
-(void)parserResetNewPwd:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"findpwd_id"];
    
    
    [dataArr_ addObject:dataModal];
}

//解析上传头像
-(void)parserUploadMyImg:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    [dataArr_  addObject:dataModal];
}

//解析创建的社群的数量
-(void)parserCreateGroupCount:(NSDictionary*)dic
{
    NSString * cnt = [dic objectForKey:@"createCnt"];
    
    [dataArr_ addObject:cnt];
}

//解析获取多个城市的薪资百分比
-(void)parserSomeCitySalaryRank:(NSDictionary*)dic
{
    NSDictionary * data = [dic objectForKey:@"data"];
    NSString * bj = [data objectForKey:@"110000"];
    NSString * sh = [data objectForKey:@"310000"];
    NSString * gz = [data objectForKey:@"440100"];
    NSString * sz = [data objectForKey:@"440300"];
    
    NSArray * percentArr = [[NSArray alloc] initWithObjects:bj,sh,gz,sz, nil];
    [dataArr_ addObject:percentArr];
}

//解析薪资段获取的百分比(用于柱状图)
-(void)parserSalaryRankByMoney:(NSDictionary*)dic
{
    NSDictionary * info = [[dic objectForKey:@"data"] objectForKey:@"info"];
    NSString * salary1 = [info objectForKey:Salary_1];
    NSString * salary2 = [info objectForKey:Salary_2];
    NSString * salary3 = [info objectForKey:Salary_3];
    NSString * salary4 = [info objectForKey:Salary_4];
    NSString * salary5 = [info objectForKey:Salary_5];
    NSString * salary6 = [info objectForKey:Salary_6];
    NSString * salary7 = [info objectForKey:Salary_7];
    NSString * salary8 = [info objectForKey:Salary_8];
    NSString * salary9 = [info objectForKey:Salary_9];
    NSString * salary10 = [info objectForKey:Salary_10];
    NSString * salary11 = [info objectForKey:Salary_11];
    
    NSArray * salaryArr = [[NSArray alloc] initWithObjects:salary1,salary2,salary3,salary4,salary5,salary6,salary7,salary8,salary9,salary10,salary11, nil];
    
    [dataArr_  addObject:salaryArr];
    
}

//解析获取社群邀请短信
-(void)parserGroupInviteSMS:(NSDictionary*)dic
{
    NSString * sms = [dic objectForKey:@"sms"];
    
    [dataArr_ addObject:sms];
}

//解析获取申请记录
-(void)parserWorkApply:(NSDictionary *)dic{
    PageInfo * page = [self parserPageInfo:dic];
    NSMutableArray *dataArray = [dic objectForKey:@"data"];
    for (NSMutableDictionary *subDic in dataArray) {
        NewApplyRecordDataModel *applyVO = [NewApplyRecordDataModel new];
        applyVO.pageCnt_ = page.pageCnt_;
        applyVO.totalCnt_ = page.totalCnt_;
        [applyVO setValuesForKeysWithDictionary:subDic];
        applyVO.salary = [NSString stringWithFormat:@"(%@)",applyVO.salary];
        if (applyVO.sendtime != nil) {
            applyVO.sendtime = [applyVO.sendtime substringToIndex:16];
        }
        if (applyVO.readtime != nil) {
            applyVO.readtime = [applyVO.readtime substringToIndex:16];
        }
        if (applyVO.collecttime != nil) {
            applyVO.collecttime = [applyVO.collecttime substringToIndex:16];
        }
        if (applyVO.unqualtime != nil) {
            applyVO.unqualtime = [applyVO.unqualtime substringToIndex:16];
        }
        if (applyVO.mailtime != nil) {
            applyVO.mailtime = [applyVO.mailtime substringToIndex:16];
        }
        if (applyVO.lastviewtime != nil) {
            applyVO.lastviewtime = [applyVO.lastviewtime substringToIndex:16];
        }
        if (applyVO.bsp_id.length > 0) {
            applyVO.showMessageView = YES;
        }
        
        [dataArr_ addObject:applyVO];
    }
}

//解析职位详情
-(void)parserGetPositionDetails:(NSDictionary *)dic
{
    if (![dic objectForKey:@"id"]) {
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [dic objectForKey:@"status"];
        dataModal.code_ = [dic objectForKey:@"code"];
        dataModal.des_ = [dic objectForKey:@"status_desc"];
        
        [dataArr_ addObject:dataModal];
        return;
    }
    
    ZWDetail_DataModal *dataModal       = [[ZWDetail_DataModal alloc] init];
    dataModal.zwID_ = [dic objectForKey:@"id"];
    dataModal.companyID_ = [dic objectForKey:@"uid"];
    dataModal.companyName_ = [dic objectForKey:@"cname"];
    dataModal.zwName_ = [dic objectForKey:@"jtzw"];
    dataModal.updateTime_ = [dic objectForKey:@"updatetime"];
    
    dataModal.regionName_ = [dic objectForKey:@"region"];
    dataModal.companyLogo_ = [dic objectForKey:@"logopath"];
    dataModal.peopleCount_ = [dic objectForKey:@"zpnum"];
    dataModal.yearCount_ = [NSString stringWithFormat:@"%@-%@年",[dic objectForKey:@"gznum1"],[dic objectForKey:@"gznum2"]];
    dataModal.edus_ = [dic objectForKey:@"edus"];
    dataModal.moneyCount_ = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"minsalary"],[dic objectForKey:@"maxsalary"]];
    dataModal.zwJianJie_ = [dic objectForKey:@"zptext"];
    dataModal.zwJianJie_ = [dataModal.zwJianJie_ stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
    dataModal.major_ = [dic objectForKey:@"zyes"];
    
    if ([dataModal.regionName_ isEqualToString:@""]) {
        dataModal.regionName_ = @"暂无";
    }
    if ([dataModal.edus_ isEqualToString:@""]) {
        dataModal.edus_ = @"不限";
    }
    if ([[dic objectForKey:@"minsalary"] isEqualToString:@""] ||[[dic objectForKey:@"minsalary"] isEqualToString:@"0"] || [[dic objectForKey:@"maxsalary"] isEqualToString:@""] ||[[dic objectForKey:@"maxsalary"] isEqualToString:@"0"]) {
        dataModal.moneyCount_ = @"面谈";
    }
    if ([[dic objectForKey:@"gznum1"]isEqualToString:@""]||[[dic objectForKey:@"gznum2"] isEqualToString:@""]||[[dic objectForKey:@"gznum1"]isEqualToString:@"0"]||[[dic objectForKey:@"gznum2"] isEqualToString:@"0"]||[[dic objectForKey:@"gznum1"] intValue] < 0 || [[dic objectForKey:@"gznum2"] intValue] < 0) {
        dataModal.yearCount_ = @"不限";
    }
    if ([[dic objectForKey:@"gznum1"] isEqualToString:[dic objectForKey:@"gznum2"]] && [[dic objectForKey:@"gznum1"]isEqualToString:@""]) {
        dataModal.yearCount_ = [NSString stringWithFormat:@"%@年",[dic objectForKey:@"gznum1"]];
    }
    if ([dataModal.major_ isEqualToString:@""]) {
        dataModal.major_ = @"不限";
    }
    [dataArr_ addObject:dataModal];
}

//请求收藏职位
-(void)parserCollectPosition:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"pf_id"];
    [dataArr_  addObject:dataModal];
}

//请求职位申请记录、收藏记录、面试通知、谁看过我 的数量
-(void)parserGetResumeCenterMessage:(NSDictionary *)dic
{
    CountInfoDataModel *model = [[CountInfoDataModel alloc]init];
    model.applayCount_ = [dic objectForKey:@"cmail_box_count"];
    model.interviewCount_ = [dic objectForKey:@"resume_read_logs_count"];
    model.collectionCount_ = [dic objectForKey:@"pfavorite_count"];
    model.visitCount_ = [dic objectForKey:@"pmailbox_count"];
    [dataArr_ addObject:model];
}

//解析获取搜索的职位列表
-(void)parserSearchPosition:(NSDictionary *)dic{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]])
    {
        if (arr.count > 0){
            for ( NSDictionary *subDic in arr ) {
                NewJobPositionDataModel *positonSearchVo = [NewJobPositionDataModel new];
                positonSearchVo.pageCnt_ = pageInfo.pageCnt_;
                positonSearchVo.totalCnt_ = pageInfo.totalCnt_;
                [positonSearchVo setValuesForKeysWithDictionary:subDic];
                [dataArr_ addObject:positonSearchVo];
            }
        }
    }
}

//解析申请单个职位
-(void)parserApplyOneZW:(NSDictionary*)dic
{
    NSArray *arr = (NSArray *)dic;
    if (!arr) {
        return;
    }
    if(arr.count <= 0){
        return;
    }
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [arr[0] objectForKey:@"status"];
    dataModal.code_ = [arr[0] objectForKey:@"code"];
    dataModal.des_ = [arr[0] objectForKey:@"status_desc"];
    dataModal.exDic_ = arr[0][@"info"];
    [dataArr_ addObject:dataModal];
    if([dataModal.status_ isEqualToString:@"OK"])
    {
        [[Manager shareMgr] showSayViewWihtType:3];
    }
}

//解析申请职位，可批量
-(void)parserApplyZW:(NSDictionary*)dic
{
    NSArray * array = (NSArray*)dic;
    for (NSDictionary * subDic in array) {
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        dataModal.status_ = [subDic objectForKey:@"status"];
        dataModal.code_ = [subDic objectForKey:@"code"];
        dataModal.des_ = [subDic objectForKey:@"status_desc"];
        [dataArr_ addObject:dataModal];
        if([dataModal.status_ isEqualToString:@"OK"])
        {
            [[Manager shareMgr] showSayViewWihtType:3];
        }
    }
    
}

//职位收藏列表
-(void)parserPositionCollection:(NSDictionary *)dic{
    PageInfo * page = [self parserPageInfo:dic];
    NSMutableArray *dataArray = [dic objectForKey:@"data"];
    for (NSMutableDictionary *dataDic in dataArray) {
        NewPositionCollectDataModel *model = [NewPositionCollectDataModel new];
        [model setValuesForKeysWithDictionary:dataDic];
        model.isSeleted_ = NO;
        model.pageCnt_ = page.pageCnt_;
        model.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:model];
    }
    
}

//请求删除收藏职位
-(void)parserDeleteCollectPosition:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.code_ = [dic objectForKey:@"code"];
    model.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:model];
}

//解析请求面试通知详情
-(void)parserGetInterviewMessageDetail:(NSDictionary *)dic
{
    NewResumeNotifyDataModel *model = [[NewResumeNotifyDataModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    [dataArr_ addObject:model];
}

//请求简历访问列表,面试通知
-(void)parserResumeVisited:(NSDictionary *)dic{
    PageInfo * page = [self parserPageInfo:dic];
    NSMutableArray *visitListArray = [dic objectForKey:@"data"];
    for (NSMutableDictionary *dataDic in visitListArray) {
        NewResumeNotifyDataModel *model = [NewResumeNotifyDataModel new];
        model.totalCnt_ = page.totalCnt_;
        model.pageCnt_ = page.pageCnt_;
        [model setValuesForKeysWithDictionary:dataDic];
        [dataArr_ addObject:model];
    }
}

//解析企业HR问答
-(void)parserCompanyHRAnswerList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    
    for (NSDictionary * subDic in arr) {
        CompanyHRAnswer_DataModal * dataModal = [[CompanyHRAnswer_DataModal alloc] init];
        dataModal.totalCnt_ = page.totalCnt_;
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.id_ = [subDic objectForKey:@"chqa_id"];
        dataModal.companyId_ = [subDic objectForKey:@"chqa_company_id"];
        dataModal.cname_ = [subDic objectForKey:@"chqa_company_cname"];
        dataModal.quizzerId_ = [subDic objectForKey:@"chqa_person_id"];
        dataModal.quizzerName_ = [subDic objectForKey:@"chqa_person_iname"];
        dataModal.questionTitle_ = [subDic objectForKey:@"chqa_q_title"];
        dataModal.questionIdate_ = [subDic objectForKey:@"chqa_q_idate"];
        dataModal.questionType_ = [subDic objectForKey:@"chqa_q_type"];
        dataModal.answerContent_ = [subDic objectForKey:@"chqa_a_content"];
        dataModal.answerPerson_ = [subDic objectForKey:@"chqa_a_huidazhe"];
        dataModal.answerIdate_ = [subDic objectForKey:@"chqa_a_idate"];
        dataModal.answerId_ = [subDic objectForKey:@"chqa_a_id"];
        dataModal.isShow_ = [[subDic objectForKey:@"chqa_isshow"] boolValue];
        dataModal.isAnswered_ = [[subDic objectForKey:@"chqa_a_ishuida"] boolValue];
        
        [dataArr_ addObject:dataModal];
    }
}


//解析请求刷新简历
-(void)parserRefreshResume:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:model];
}

//解析请求求职状态
-(void)parserGetResumeStatus:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.exObj_ = [dic objectForKey:@"resume_status"];
    [dataArr_ addObject:model];
}

//解析请求更新求职状态
-(void)parserUpdateResumeStatus:(NSDictionary *)dic;
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//解析企业未来
-(void)parserCompanyDevelopment:(NSDictionary *)dic
{
    NSArray * arr = (NSArray*)dic;
    for (NSDictionary * subDic in arr) {
        CultureContent_DataModal * content = [[CultureContent_DataModal alloc] init];
        content.id_ = [subDic objectForKey:@"id"];
        content.cid_ = [subDic objectForKey:@"company_id"];
        content.mainTitle_ = [subDic objectForKey:@"cont_title_main"];
        content.subTitle_ = [subDic objectForKey:@"cont_title_sub"];
        content.content_ = [subDic objectForKey:@"cont_content"];
//        content.content_ = [MyCommon removeHTML2:content.content_];
//        content.content_ = [MyCommon filterHTML:content.content_];
        content.idatetime_ = [subDic objectForKey:@"idatetime"];
        content.updatetime_ = [subDic objectForKey:@"updatetime"];
        
        [dataArr_ addObject:content];
    }

}

//解析企业用人理念
-(void)parserCompanyEmployee:(NSDictionary*)dic
{
    NSArray * arr = (NSArray*)dic;
    for (NSDictionary * subDic in arr) {
        CultureContent_DataModal * content = [[CultureContent_DataModal alloc] init];
        content.id_ = [subDic objectForKey:@"id"];
        content.cid_ = [subDic objectForKey:@"company_id"];
        content.mainTitle_ = [subDic objectForKey:@"cont_title_main"];
        content.subTitle_ = [subDic objectForKey:@"cont_title_sub"];
        content.content_ = [subDic objectForKey:@"cont_content"];
        content.content_ = [MyCommon removeHTML2:content.content_];
        content.content_ = [MyCommon filterHTML:content.content_];
        content.idatetime_ = [subDic objectForKey:@"idatetime"];
        content.updatetime_ = [subDic objectForKey:@"updatetime"];
        
        [dataArr_ addObject:content];
    }

}

//解析企业团队
-(void)parserCompanyTeam:(NSDictionary*)dic
{
    NSArray * arr = (NSArray*)dic;
    for (NSDictionary * subDic in arr) {
        CultureContent_DataModal * content = [[CultureContent_DataModal alloc] init];
        content.id_ = [subDic objectForKey:@"id"];
        content.cid_ = [subDic objectForKey:@"company_id"];
        content.mainTitle_ = [subDic objectForKey:@"cont_title_main"];
        content.subTitle_ = [subDic objectForKey:@"cont_title_sub"];
        content.content_ = [subDic objectForKey:@"cont_content"];
        
        content.idatetime_ = [subDic objectForKey:@"idatetime"];
        content.updatetime_ = [subDic objectForKey:@"updatetime"];
        content.managerName_ = [subDic objectForKey:@"manager_name"];
        content.managerSex_ = [subDic objectForKey:@"manager_sex"];
        content.managerZW_ = [subDic objectForKey:@"manager_post"];
        content.managerImg_ = [subDic objectForKey:@"manager_logo"];
        content.managerIntro_ = [subDic objectForKey:@"manager_intro"];
        
        
        [dataArr_ addObject:content];
    }

}

//解析企业员工分享
-(void)parserCompanyShare:(NSDictionary *)dic
{
    NSArray * arr = (NSArray*)dic;
    for (NSDictionary * subDic in arr) {
        CultureContent_DataModal * content = [[CultureContent_DataModal alloc] init];
        content.id_ = [subDic objectForKey:@"id"];
        content.cid_ = [subDic objectForKey:@"company_id"];
        content.mainTitle_ = [subDic objectForKey:@"cont_title_main"];
        content.subTitle_ = [subDic objectForKey:@"cont_title_main"];
        content.content_ = [subDic objectForKey:@"cont_content"];
        content.idatetime_ = [subDic objectForKey:@"idatetime"];
        content.updatetime_ = [subDic objectForKey:@"updatetime"];
        content.managerName_ = [subDic objectForKey:@"manager_name"];
        content.managerSex_ = [subDic objectForKey:@"manager_sex"];
        content.managerZW_ = [subDic objectForKey:@"manager_post"];
        content.managerImg_ = [subDic objectForKey:@"manager_logo"];
        content.managerIntro_ = [subDic objectForKey:@"manager_intro"];
        
        
        [dataArr_ addObject:content];
    }

}


//解析请求简历保密设置
-(void)parserUpdateResumeVisible:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//解析公司在招所有职位列表
-(void)parserCompanyAllZWlist:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        JobSearch_DataModal *dataModal = [[JobSearch_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        dataModal.zwID_ = [subDic objectForKey:@"id"];
        dataModal.zwName_ = [subDic objectForKey:@"job"];
        dataModal.companyID_ = [subDic objectForKey:@"uid"];
        dataModal.companyName_ =[subDic objectForKey:@"cname"];
        //dataModal.cnameAll_ = [subDic objectForKey:@"cname_all"];
        //dataModal.regionId_ = [subDic objectForKey:@"regionid"];
        dataModal.regionName_ = [subDic objectForKey:@"regionid"];
        dataModal.updateTime_ = [subDic objectForKey:@"idate"];
        
        [dataArr_ addObject:dataModal];
    }
}

//解析请求简历保密设置状态
-(void)parserGetResumeVisible:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.exObj_ = [dic objectForKey:@"resume_sercet"];
    [dataArr_ addObject:model];
}

//解析相关雇主列表
-(void)parserRelatedCompanyList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        CompanyInfo_DataModal   * dataModal = [[CompanyInfo_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        dataModal.companyID_ = [subDic objectForKey:@"company_id"];
        dataModal.cname_ = [subDic objectForKey:@"company_cname"];
        dataModal.tradeId_ = [subDic objectForKey:@"tradeid"];
        dataModal.totalId_ = [subDic objectForKey:@"totalid"];
        dataModal.regionid_ = [subDic objectForKey:@"regionid"];
        dataModal.logoPath_ = [subDic objectForKey:@"company_logo"];
        
        [dataArr_ addObject:dataModal];
        
    }
}

//请求职同道合列表
-(void)parserGetTheSamePersonList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSMutableArray *dataArray = [dic objectForKey:@"data"];
    for (NSMutableDictionary *dataDic in dataArray) {
        Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.id_ = [dataDic objectForKey:@"personId"];
        dataModal.iname_ = [dataDic objectForKey:@"person_iname"];
        dataModal.introduce_ = [dataDic objectForKey:@"intro"];
        
        NSDictionary * personDetail = [dataDic objectForKey:@"person_detail"];
        dataModal.sex_ = [personDetail objectForKey:@"person_sex"];
        dataModal.zw_ = [personDetail objectForKey:@"person_zw"];
        dataModal.gznum_ = [personDetail objectForKey:@"person_gznum"];
        dataModal.company_ = [personDetail objectForKey:@"person_company"];
        dataModal.nickname_ = [personDetail objectForKey:@"person_nickname"];
        dataModal.signature_ = [personDetail objectForKey:@"person_signature"];
        dataModal.followStatus_ = [[personDetail objectForKey:@"rel"] integerValue];
        dataModal.img_ = [personDetail objectForKey:@"person_pic"];
        
        NSDictionary * expertDetail = [personDetail objectForKey:@"expert_detail"];
        dataModal.goodat_ = [expertDetail objectForKey:@"good_at"];
        if(!dataModal.goodat_||[dataModal.goodat_ isEqualToString:@""])
        {
            dataModal.goodat_ = @"暂无";
        }
        if ([[expertDetail objectForKey:@"is_expert"] isEqualToString:@"1"]) {
            dataModal.isExpert_ = YES;
        }else{
            dataModal.isExpert_ = NO;
        }
        NSDictionary *countlist = [personDetail objectForKey:@"count_list"];
        dataModal.answerCnt_ = [[countlist objectForKey:@"answer_count"] integerValue];
        dataModal.fansCnt_ = [[countlist objectForKey:@"fans_count"] integerValue];
        dataModal.publishCnt_ = [[countlist objectForKey:@"publish_count"] integerValue];
        dataModal.groupsCreateCnt_ = [[countlist objectForKey:@"groups_count"] integerValue];
        
        //relation
        NSDictionary * relationDic = [dataDic objectForKey:@"_relation"];
        
        dataModal.ylPersonFlag_ = [dataDic objectForKey:@"yl_person_flag"];
        dataModal.sendEmailFlag_ = [dataDic objectForKey:@"send_mail_flag"];
        dataModal.sameCity_ = [relationDic objectForKey:@"same_city"];
        dataModal.sameHometown_ = [relationDic objectForKey:@"same_hka"];
        dataModal.sameSchool_ = [relationDic objectForKey:@"same_school"];
        
        dataModal.cityStr_ = [relationDic objectForKey:@"city"];
        dataModal.hkaStr_ = [relationDic objectForKey:@"hka"];
        dataModal.schoolStr_ = [relationDic objectForKey:@"school"];
        
        NSMutableArray *relationArray = [[NSMutableArray alloc]init];
        if ([dataModal.sameCity_ isEqualToString:@"1"]) {
            [relationArray addObject:@"sameCity"];
        }
        if ([dataModal.sameSchool_ isEqualToString:@"1"]) {
            [relationArray addObject:@"sameSchool"];
        }
        if ([dataModal.sameHometown_ isEqualToString:@"1"]) {
            [relationArray addObject:@"sameHometown"];
        }
 
        dataModal.relationArray_ = relationArray;
        [dataArr_ addObject:dataModal];
    }
}

//解析请求简历路径
-(void)parserGetResumePath:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.exObj_ = [dic objectForKey:@"info"];
    [dataArr_ addObject:model];
}

//解析向HR提问
-(void)parserAskHR:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"desc"];
    [dataArr_ addObject:dataModal];
}

//解析请求教育背景
-(void)parserGetEdusInfo:(NSDictionary *)dic
{
    NSMutableArray *dataArray = [dic objectForKey:@"data"];
    for (NSMutableDictionary *dataDic in dataArray) {
        EduResume_DataModal *model = [[EduResume_DataModal alloc]init];
        model.id_ =  [dataDic objectForKey:@"edusId"];
        model.personId_ = [dataDic objectForKey:@"personId"];
        model.school_ = [dataDic objectForKey:@"school"];
        model.startDate_ = [dataDic objectForKey:@"startdate"];
        model.endDate_ = [dataDic objectForKey:@"stopdate"];
        model.eduId_ = [dataDic objectForKey:@"eduId"];
        model.zye_ = [dataDic objectForKey:@"zye"];
        model.zym_ = [dataDic objectForKey:@"zym"];
        model.eduName_ = [dataDic objectForKey:@"eduNmae"];
        [dataArr_ addObject:model];
    }
}

//解析请求更新教育背景
-(void)parserUpdateEdusInfo:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//解析添加教育背景
-(void)parserAddEdusInfo:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//解析留言
-(void)parserLeaveMsg:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = dic[@"status_desc"];
    model.code_ = dic[@"code"];
    model.exObj_ = dic[@"msg_id"];
    [dataArr_ addObject:model];
}

//解析文章收藏
-(void)parserAddArticleFavorite:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = dic[@"desc"];
    model.code_ = dic[@"code"];
    [dataArr_ addObject:model];
}

//解析文章收藏列表
-(void)parserGetArticleFavoriteList:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    if ((NSNull *)arr == [NSNull null]) {
        return;
    }
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    for(NSDictionary *dict in arr){
        NSString *type = dict[@"yf_type"];
        if ([type isEqualToString:@"1"])//收藏文章
        {
            TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            NSString *articleType = dict[@"_source_type"];
            
            if ([articleType isEqualToString:@"hytt"]){//行业头条
                dataModal.articleType_ = Article_Trade_Head;
            }else if ([articleType isEqualToString:@"article_gxs"]){//灌薪水
                dataModal.articleType_ = Article_GXS;
            }else if ([articleType isEqualToString:@"article_group"]){//社群
                dataModal.articleType_ = Article_Group;
            }else if ([articleType isEqualToString:@"question"]) {//问答
                dataModal.articleType_ = Article_Question;
            }else if ([articleType isEqualToString:@"article"]) {//其他文章（同行文章）
                dataModal.articleType_ = Article_Follower;
            }
            ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:dict];
            if ([model.is_recommend isEqualToString:@"1"]) {
                dataModal.isRecommentAnswer = YES;
            }
            if (model._activity_info) {
                dataModal.isActivityArtcle = YES;
                model._activity_info.person_id = model.personId;
                model._activity_info.person_pic = model.person_pic;
                model._activity_info.person_iname = model.person_iname;
            }
            dataModal.sameTradeArticleModel = model;
            if(model.article_id) {
                [dataArr_ addObject:dataModal];
            }           
        }
        else if([type isEqualToString:@"4"])//收藏的附件
        {   
            Article_DataModal *dataModel = [[Article_DataModal alloc]init];
            dataModel.pageCnt_ = pageInfo.pageCnt_;
            dataModel.totalCnt_ = pageInfo.totalCnt_;
            dataModel.collectType = type;
            NSDictionary *articleInfo = dict[@"_media_info"];
            dataModel.collectId = articleInfo[@"id"];
            dataModel.id_ = articleInfo[@"article_id"];
            dataModel.title_ = articleInfo[@"title"];
            dataModel.collectFileSwf = articleInfo[@"file_swf"];
            dataModel.collectFilePage = articleInfo[@"file_pages"];
            dataModel.collectSrc = articleInfo[@"src"];
            [dataArr_ addObject:dataModel];
        }
        
    }
}

//解析发私信
-(void)parserSendPersonalMsg:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//解析扫描二维码
-(void)parserScanQrCode:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.des_ = dic[@"status_desc"];
    model.status_ = dic[@"status"];
    model.code_ = dic[@"code"];
    [dataArr_ addObject:model];
}
//解析登录授权
-(void)parserLoginAuth:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.des_ = dic[@"status_desc"];
    model.code_ = dic[@"code"];
    model.status_ = dic[@"status"];
    [dataArr_ addObject:model];
}

//解析获取服务码
-(void)parserGetServiceNumber:(NSDictionary *)dic
{
    ServiceCode_DataModal *serviceCode = [[ServiceCode_DataModal alloc]init];
    serviceCode.number = dic[@"number"];
    serviceCode.code = dic[@"code"];
    [dataArr_ addObject:serviceCode];
}

//解析无验证码注册
-(void)parserRegistNoCode:(NSDictionary *)dic
{
    User_DataModal * dataModal = [[User_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    NSDictionary * personArr = [dic objectForKey:@"personArr"];
    dataModal.userId_ = [personArr objectForKey:@"personId"];
    dataModal.uname_ = [personArr objectForKey:@"uname"];
    [dataArr_ addObject:dataModal];
}

//解析私信列表 不分页
-(void)parserPersonalMsgList:(id)arr
{
    if ([arr isKindOfClass:[NSDictionary class]]) {
        arr = arr[@"data"];
    }
    for(NSDictionary *dict in arr)
    {
        NSString *type = dict[@"type"];
        if ([type isEqualToString:@"3"])
        {//分享
            LeaveMessage_DataModel *dataModel = [[LeaveMessage_DataModel alloc]initWithShareDictionary:dict];
            [dataArr_ addObject:dataModel];
        }
        else if ([type isEqualToString:@"1"])
        {//纯文本消息
            LeaveMessage_DataModel *dataModel = [[LeaveMessage_DataModel alloc]initWithTextDictionary:dict];
            [dataArr_ addObject:dataModel];
        }
    }
}

//解析留言联系人列表 分页
-(void)parserGetContactList:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    PageInfo *pageInfo = [self parserPageInfo:dic];
    for(NSDictionary *dict in arr){
        MessageContact_DataModel *dataModel = [[MessageContact_DataModel alloc]init];
        dataModel.pageCnt_ = pageInfo.pageCnt_;
        dataModel.totalCnt_ = pageInfo.totalCnt_;
        dataModel.userId = dict[@"person_id"];
        dataModel.lastDateTime = dict[@"last_datetime"];
        dataModel.isExpert = dict[@"is_expert"];
        dataModel.userIname = dict[@"person_iname"];
        dataModel.pic = dict[@"person_pic"];
        dataModel.gzNum = dict[@"person_gznum"];
        dataModel.userZW = dict[@"person_zw"];
        dataModel.sex = dict[@"person_sex"];
        dataModel.age = dict[@"age"];
        dataModel.sameSchool = dict[@"same_school"];
        dataModel.sameCity = dict[@"same_city"];
        dataModel.sameHKA = dict[@"same_hka"];
        dataModel.isNew = dict[@"is_new"];
        dataModel.message = dict[@"new_mag"];
        if ([dict[@"is_hr"] isEqualToString:@"1"]) {
            dataModel.boolHrFlag = YES;
        }
        if ([dict[@"is_zp"] isEqualToString:@"1"]) {
            dataModel.boolGWFlag = YES;
        }
        [dataArr_ addObject:dataModel];
    }
}


#pragma mark--新消息列表
-(void)parserNewNewsList:(NSDictionary *)dic{
    NSArray *typeArr = @[@"sys_msg",@"group_msg",@"comment_msg",@"article_msg",@"follow_msg",@"praise_msg",@"yuetan_msg",@"dashang_msg",@"private_msg",@"oa_msg",@"group_chat_msg",@"spec_private_msg"];
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSMutableArray *allDatas = [NSMutableArray array];
    if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
        NSArray *arr = [dic objectForKey:@"data"];
        for (NSDictionary *subDic in arr) {
            if ([subDic[@"title"] isKindOfClass:[NSString class]] && [subDic[@"content"] isKindOfClass:[NSString class]]) {
                if (!([subDic[@"title"] length] > 0 || [subDic[@"content"] length] > 0)) {
                    continue;
                }
            }
            else{
                continue;
            }
            ELNewNewsListVO *newInfoVO = [ELNewNewsListVO new];
            [newInfoVO setValuesForKeysWithDictionary:subDic];
            ELNewNewsInfoVO *infovo = newInfoVO.info;
            newInfoVO.pageCnt_ = pageInfo.pageCnt_;
            newInfoVO.totalCnt_ = pageInfo.totalCnt_;
            if (infovo.newsInfoId.length > 0) {
                newInfoVO.infoId = infovo.newsInfoId;
            }
            else{
                newInfoVO.infoId = @"";
            }
            if (infovo.action.length > 0) {
                newInfoVO.action = infovo.action;
            }
            else{
                newInfoVO.action = @"";
            }
            if (infovo.qi_id_isdefault.length > 0) {
                newInfoVO.qi_id_isdefault = infovo.qi_id_isdefault;
            }
            else{
                newInfoVO.qi_id_isdefault = @"";
            }
            if (infovo.article_id.length > 0) {
                newInfoVO.article_id = infovo.article_id;
            }
            else{
                newInfoVO.article_id = @"";
            }
            if (infovo.all_cnt) {
                newInfoVO.all_cnt = infovo.all_cnt;
            }
            else{
                newInfoVO.all_cnt = @(10000);
            }
            newInfoVO.personId = [Manager getUserInfo].userId_;
            if ([typeArr containsObject:newInfoVO.type]) {
                [allDatas addObject:newInfoVO];
            }
        }
    }
    
    
    ELNewsListDAO *DAO = [ELNewsListDAO new];
    if (allDatas.count > 0) {
        for (ELNewNewsListVO *vo in allDatas) {
            if ([vo.info isKindOfClass:[NSObject class]]) {
                NSDictionary *dic = [vo.info dictionaryFromModel];
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                vo.jsonStr = jsonStr;
            }
            else{
                vo.jsonStr = @"";
            }
            
        }
        [DAO updateData:allDatas];
    }
    NSLog(@"%@",[DAO showAll:[Manager getUserInfo].userId_]);
    allDatas = [self findAllDealedNews:[DAO showAll:[Manager getUserInfo].userId_]];
    if (allDatas.count>0) {
        NSInteger afterAllNums = 0;
        for (ELNewNewsListVO *vo in allDatas) {
            if (vo.jsonStr.length > 0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[vo.jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                ELNewNewsInfoVO *infovo = [ELNewNewsInfoVO new];
                [infovo setValuesForKeysWithDictionary:dic];
                vo.info = infovo;
            }
            else{
                vo.info = nil;
            }
            
            NSInteger nowCnt = [vo.cnt integerValue];
            afterAllNums += nowCnt;
            [dataArr_ addObject:vo];
        }
        kUserDefaults(@(afterAllNums), kAllNums);
        kUserSynchronize;
    }
}

-(NSMutableArray *)findAllDealedNews:(NSArray *)allDatas{
    if (allDatas.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        ELNewNewsListVO *specVO = nil;
        for (ELNewNewsListVO *newsVO in allDatas) {
            if (!([newsVO.type isEqualToString:@"spec_private_msg"] || [newsVO.type isEqualToString:@"oa_msg"])) {
                [arr addObject:newsVO];
            }
            else if([newsVO.type isEqualToString:@"oa_msg"]){
                if ([newsVO.action isEqualToString:@"upsert"]) {
                    [arr addObject:newsVO];
                }
            }
            else if([newsVO.type isEqualToString:@"spec_private_msg"]){
                if ([newsVO.action isEqualToString:@"upsert"]) {
                    specVO  = newsVO;
                    [arr addObject:newsVO];
                }
            }
        }
        
        if ([arr containsObject:specVO]) {
            for (NSInteger i = arr.count - 1; i>0; i--) {
                ELNewNewsListVO *VO = arr[i];
                if ([VO.type isEqualToString:@"private_msg"]) {
                    [arr removeObject:VO];
                }
            }
        }
        return arr;
    }
    return [NSMutableArray array];
}


#pragma mark--群组
-(void)parserAddGroup:(NSDictionary *)dic{
    [dataArr_ addObject:dic];
}

//解析获取灌薪水列表
-(void)parserGetSalaryArticle:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for (NSDictionary *subDic in arr) {
        ELSalaryModel *model = [[ELSalaryModel alloc] initWithDictionary:subDic];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:model];
    }
}

#pragma mark 薪水入口文章列表
-(void)parserGetSalaryArticleListByES:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"][@"gxsList"];
    for (int i= 0; i<arr.count; i++) {
        if (arr[i] == [NSNull null]) {
            continue;
        }
            NSDictionary *subDic = (NSDictionary *)arr[i];
            NSString *type = [subDic objectForKey:@"_show_type"];
            if ([type isEqualToString:@"gxs_article"]) {//灌薪水
                ELSalaryModel *model = [[ELSalaryModel alloc] initWithDictionary:subDic];
                model.pageCnt_ = pageInfo.pageCnt_;
                model.totalCnt_ = pageInfo.totalCnt_;
                model.articleType_ = Article_GXS;
                if (![model._vote_info isEqual:[NSNull null]]) {
                    model.isRefresh = YES;
                }
                [dataArr_ addObject:model];
            }
            else if ([type isEqualToString:@"salary_compare"])
            {
                ELSalaryResultModel *model = [[ELSalaryResultModel alloc] initWithDictionary:subDic];
                NSString *firstName = [model.userInfo.iname substringToIndex:1];
                NSString *sex;
                if ([model.userInfo.sex isEqualToString:@"男"]) {
                    sex = @"先生";
                }else{
                    sex = @"小姐";
                }
                model.des_ = [NSString stringWithFormat:@"%@%@ %@曝出了自己的工资", firstName, sex, model.sendtime_desc];
                [dataArr_ addObject:model];
            }
    }
    
    if (dic[@"data"][@"salaryCntInfo"]) {
        [dataArr_ addObject:dic[@"data"][@"salaryCntInfo"] ];
    }
    
}

#pragma mark 薪水到航列表
-(void)parserGetSalaryNavList:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"data"];
    [dataArr_ addObject:arr];
}

#pragma mark 职业列表
-(void)parserGetProfessionList:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"data"];
    [dataArr_ addObjectsFromArray:arr];
}

#pragma mark 职业第三级列表
-(void)parserGetProfessionChildList:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"data"];
    [dataArr_ addObjectsFromArray:arr];
}

#pragma mark 获取灌薪水文章和评论的列表
- (void)parserGetSalaryArticleAndCommentList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSDictionary *articleDict = dic[@"data"][@"article"];
    
    if (![dic[@"data"][@"article"] isEqual:[NSNull null]]) {
        ELSalaryModel *model = [[ELSalaryModel alloc] initWithDictionary:articleDict];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:model];
    }
    
    if (![dic[@"data"][@"comment"] isEqual:[NSNull null]]) {
        NSArray *arr = dic[@"data"][@"comment"];
        for (NSDictionary *dict in arr) {
            ELCommentModel *model = [[ELCommentModel alloc] initWithDictionary:dict];
            model.pageCnt_ = pageInfo.pageCnt_;
            model.totalCnt_ = pageInfo.totalCnt_;
            if(dict[@"_parent_comment"]){
                ELCommentModel *parentComment = [[ELCommentModel alloc]init];
                parentComment.content = dict[@"_parent_comment"][@"content"];
                parentComment._floor_num = [dict[@"_parent_comment"][@"_floor_num"] integerValue];
                model.parent_ = parentComment;
            }
            [dataArr_ addObject:model];
        }
    }
}

//解析发表灌薪水文章
-(void)parserShareSalaryArticle:(NSDictionary*)dic
{    
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.exObj_ = [dic objectForKey:@"info"];
    [dataArr_ addObject:dataModal];
    
}

//解析设置昵称
-(void)updateNickName:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:dataModal];
}


//解析某人在社群里地权限
-(void)parserPermissionInGroup:(NSDictionary*)dic
{
    NSString * publishStaus = [dic objectForKey:@"topic_publish"];
    NSString * inviteStatus = [dic objectForKey:@"member_invite"];
    
    NSArray  * array = [[NSArray alloc] initWithObjects:publishStaus,inviteStatus, nil];
    
    [dataArr_ addObject:array];
}

//解析文档信息
-(void)parserFileInfo:(NSDictionary*)dic
{
    Article_DataModal * dataModal = [[Article_DataModal alloc] init];
    dataModal.id_ = [dic objectForKey:@"file_id"];
    dataModal.title_ = [dic objectForKey:@"file_name"];
    dataModal.content_ = [dic objectForKey:@"file_html_desc"];
    dataModal.filePath_ = [dic objectForKey:@"file_path"];
    dataModal.personID_ = [dic objectForKey:@"file_owner_id"];
    dataModal.idatetime_ = [dic objectForKey:@"file_idate"];
    dataModal.updatetime_ = [dic objectForKey:@"file_updatetime"];
    dataModal.fileViewCnt_ = [[dic objectForKey:@"file_view_cnt"] integerValue];
    dataModal.fileDownloadCnt_ = [[dic objectForKey:@"file_download_cnt"] integerValue];
    dataModal.filePages_ = [[dic objectForKey:@"file_pages"] integerValue];
    dataModal.fileImg_ = [dic objectForKey:@"file_img"];
    dataModal.fileSize_ = [dic objectForKey:@"file_size"];
    dataModal.personName_ = [dic objectForKey:@"file_owner_name"];
    dataModal.fileWH_ = [dic objectForKey:@"file_pic_wh"];
    
    [dataArr_ addObject:dataModal];
}

//解析请求关注企业
-(void)parserAddAttentionCompany:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    if ([dataModal.status_ isEqualToString:Success_Status]) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendCompanyNotification" object:nil];
    }
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:dataModal];
    
}

//解析请求取消关注企业
-(void)parserCancelAttentionCompany:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    if ([dataModal.status_ isEqualToString:Success_Status]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendCompanyNotification" object:nil];
    }
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:dataModal];
    
}

//请求企业关注列表
-(void)parserCareCompany:(NSDictionary *)dic{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSMutableArray *dataArray = [dic objectForKey:@"data"];
    if (dataArray.count == 0 || ! dataArray) {
        return;
    }
    for (NSMutableDictionary *dataDic in dataArray) {
        CareCompanyDataModel *dataModal = [CareCompanyDataModel new];
        [dataModal setValuesForKeysWithDictionary:dataDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//解析上传图片
-(void)parserUploadImgData:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.exObj_ = [dic objectForKey:@"result"];
    if (dataModal.exObj_) {
        dataModal.status_ = Success_Status;
    }
    [dataArr_ addObject:dataModal];
}

//请求获取薪酬预测
-(void)parserGetSalaryPrediction:(NSDictionary *)dic
{
    NSString *status = [dic objectForKey:@"status"];
    if ([status isEqualToString:@"OK"]) {
        NSMutableArray *dataArray = [dic objectForKey:@"info"];
        for (NSMutableDictionary *dic in dataArray) {
            SalaryDateModel *model =[[SalaryDateModel alloc]init];
            
            model.min_ = [dic objectForKey:@"min"];
            model.max_ = [dic objectForKey:@"max"];
            model.avg_ = [dic objectForKey:@"avg"];
            model.year_ = [dic objectForKey:@"year"];
            
            [dataArr_ addObject:model];
        }
    }
}

//解析请求职导推荐行家
-(void)parserGetSalaryExpert:(NSDictionary *)dic
{
//    NSMutableArray *dataArray = [dic objectForKey:@"data"];
    for (NSMutableDictionary *dataDic in dic) {
        Expert_DataModal *dataModel = [[Expert_DataModal alloc]init];
        dataModel.id_ = [dataDic objectForKey:@"personid"];
        dataModel.iname_ = [dataDic objectForKey:@"person_iname"];
        dataModel.zw_ = [dataDic objectForKey:@"person_zw"];
        dataModel.goodat_ = [dataDic objectForKey:@"good_at"];
        dataModel.followStatus_ = [[dataDic objectForKey:@"rel"] intValue];
        dataModel.img_ = [dataDic objectForKey:@"person_pic"];
        dataModel.answerCnt_ = [[dataDic objectForKey:@"answer_count"] integerValue];
        dataModel.publishCnt_ = [[dataDic objectForKey:@"publish_count"] integerValue];
        dataModel.groupsCreateCnt_ = [[dataDic objectForKey:@"groups_count"] integerValue];
        dataModel.fansCnt_ = [[dataDic objectForKey:@"fans_count"] integerValue];
        dataModel.gznum_ = [dataDic objectForKey:@"person_gznum"];
        if ([[dataDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
            dataModel.isExpert_ = YES;
        }else{
            dataModel.isExpert_ = NO;
        }
        [dataArr_ addObject:dataModel];
    }
    
}

//解析请求简历对比数据
-(void)parserGetResumeRcomparison:(NSDictionary *)dic
{
    
    
    for (int i=0; i<2; i++) {
        NSMutableDictionary *myDic;
        if (i == 0) {
            myDic = [dic objectForKey:@"my"];
        }else if(i == 1){
            myDic = [dic objectForKey:@"compare"];
        }
        User_DataModal *myDataModel = [[User_DataModal alloc]init];
        myDataModel.img_ = [myDic objectForKey:@"pic"];
        myDataModel.name_ = [myDic objectForKey:@"iname"];
        myDataModel.salary_ = [myDic objectForKey:@"yuex"];
        myDataModel.eduName_ = [myDic objectForKey:@"edu_name"];
        if (![[myDic objectForKey:@"job"] isKindOfClass:[NSString class]]) {
            myDataModel.job_ = @"";
        }else{
            myDataModel.job_ = [myDic objectForKey:@"job"];
        }
        myDataModel.age_ = [myDic objectForKey:@"age"];
        myDataModel.gzNum_ = [myDic objectForKey:@"gznum"];
        myDataModel.languageLevel_ = [myDic objectForKey:@"lanlevel_name"];
        myDataModel.computerLevel_ = [myDic objectForKey:@"computer"];
        myDataModel.regionHka_ = [myDic objectForKey:@"regionid"];
        myDataModel.companyNature_ = [myDic objectForKey:@"workinfo_qyxz"];
        [dataArr_ addObject:myDataModel];
    }
    
    
}

//解析消息列表
-(void)parserMessageList:(NSDictionary*)dic
{
    NSArray * dataArr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in dataArr) {
        Message_DataModal * dataModal = [[Message_DataModal alloc] init];
        dataModal.type_ = [subDic objectForKey:@"yap_msg_type"];
        dataModal.content_ = [subDic objectForKey:@"yap_content"];
        dataModal.status_ = [subDic objectForKey:@"yap_status"];
        dataModal.extraDic_ = [[subDic objectForKey:@"yap_extra"] objectForKey:@"extras"];
        dataModal.time_ = [subDic objectForKey:@"idatetime"];
        dataModal.objectId_ = [dataModal.extraDic_ objectForKey:@"aid"];
        if ([subDic objectForKey:@"is_exists"]) {
            dataModal.group_bExist_ = [[subDic objectForKey:@"is_exists"] boolValue];
        }
        if ([subDic objectForKey:@"_is_member"]) {
            dataModal.group_bMember_ = [[subDic objectForKey:@"_is_member"] boolValue];
        }
        [dataArr_ addObject:dataModal];
    }
}

//解析某种类型的消息列表
-(void)parserOneMessageList:(NSDictionary*)dic
{
    NSArray * dataArr = [dic objectForKey:@"data"];
    //BOOL  aStatus = NO;
    PageInfo *pageInfo = [self parserPageInfo:dic];
    for (NSDictionary * subDic in dataArr) {
        Message_DataModal * dataModal = [[Message_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.type_ = [subDic objectForKey:@"yap_msg_type"];
        dataModal.content_ = [subDic objectForKey:@"yap_content"];
        dataModal.status_ = [subDic objectForKey:@"yap_status"];
        dataModal.extraDic_ = [[subDic objectForKey:@"yap_extra"] objectForKey:@"extras"];
        dataModal.time_ = [subDic objectForKey:@"idatetime"];
        dataModal.objectId_ = [dataModal.extraDic_ objectForKey:@"aid"];
        [dataArr_ addObject:dataModal];
//        if ( [dataModal.type_ isEqualToString:@"210"]) {
//            if (!aStatus) {
//                [dataArr_ addObject:dataModal];
//                aStatus = YES;
//            }
//        }
//        else
//        {
//            [dataArr_ addObject:dataModal];
//        }
        
    }
}

//解析分享成功后的记录
-(void)parserShareLogs:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"des"];
    
    [dataArr_ addObject:dataModal];
}

//解析提交问卷调查
-(void)parserAddQuestionnaire:(NSDictionary *)dic
{
    if ([dic objectForKey:@"result"]) {
        Status_DataModal *model = [[Status_DataModal alloc]init];
        model.status_ = @"OK";
        [dataArr_ addObject:model];
    }
    
}

//解析HI模块列表
-(void)parserYL1001HIList:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    NSArray * dataArray = [dataDic objectForKey:@"data"];
    NSString * type = [dataDic objectForKey:@"type"];
    if ([type isEqualToString:@"dynamic"] ) {
        for (NSDictionary * subDic in dataArray) {
            TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
            ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithFriendDictionary:subDic];
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            if ([model.nf_type isEqualToString:@"yl1001_follower"] || [model.nf_type isEqualToString:@"yl1001_follower_user"]) {
                dataModal.articleType_ = Article_Follower;
            }else if ([model.nf_type isEqualToString:@"yl1001_share_article"]) {
                dataModal.articleType_ = Article_Share;
            }else if ([model.nf_type isEqualToString:@"yl1001_group"]) {
                dataModal.articleType_ = Article_Group;
            }
            dataModal.sameTradeArticleModel = model;
            if (model.article_id) {
                [dataArr_ addObject:dataModal];
            }
        }
    }else if([type isEqualToString:@"expert"]){
        for (NSDictionary * subDic in dataArray) {
            TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
            ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithExpertDictionary:subDic];
            dataModal.articleType_ = Article_Follower;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.sameTradeArticleModel = model;
            if (model.article_id) {
                [dataArr_ addObject:dataModal];
            }
        }

    }
}
//解析hi模块的行家搜索
-(void)parserHISearchExpert:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    if ([Manager shareMgr].haveLogin) {
        for ( NSDictionary *subDic in arr ) {
            Article_DataModal *dataModal = [self parserExpertArticleInfo:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:dataModal];
        }
    }
    else
    {
        for ( NSDictionary *subDic in arr ) {
            Expert_DataModal *dataModal = [self parserExpertInfo:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:dataModal];
        }
    }

}

//解析请求用户详情
-(void)parserGetPersonDetailWithPersonId:(NSDictionary *)dic
{
    NSMutableDictionary *dataDic = [dic objectForKey:@"data"];
    
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
    
    dataModal.id_ = [dataDic objectForKey:@"personId"];
    dataModal.iname_ = [dataDic objectForKey:@"person_iname"];
    dataModal.nickname_ = [dataDic objectForKey:@"person_nickname"];
    dataModal.img_ = [dataDic objectForKey:@"person_pic"];
    dataModal.zw_ = [dataDic objectForKey:@"person_zw"];
    dataModal.gznum_ = [dataDic objectForKey:@"person_gznum"];
    dataModal.followStatus_ = [[dataDic objectForKey:@"rel"] integerValue];
    dataModal.signature_ = [dataDic objectForKey:@"person_signature"];
    NSDictionary * expert_detailDic = [dataDic objectForKey:@"expert_detail"];
    dataModal.goodat_ = [expert_detailDic objectForKey:@"good_at"];
    if ([[expert_detailDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
        dataModal.isExpert_ = YES;
    }else{
        dataModal.isExpert_ = NO;
    }
    
    NSDictionary * count_listDic = [dataDic objectForKey:@"count_list"];
    dataModal.questionCnt_ = [[count_listDic objectForKey:@"question_count"] integerValue];
    dataModal.fansCnt_ = [[count_listDic objectForKey:@"fans_count"] integerValue];
    dataModal.publishCnt_ = [[count_listDic objectForKey:@"publish_count"] integerValue];
    dataModal.groupsCreateCnt_ = [[count_listDic objectForKey:@"groups_count"] integerValue];
    dataModal.answerCnt_ = [[count_listDic objectForKey:@"answer_count"]integerValue];
    
    [dataArr_ addObject:dataModal];
}


//解析公司登录
-(void)parserCompanyLogin:(NSDictionary*)dic
{
    CompanyLogin_DataModal * dataModal = [[CompanyLogin_DataModal alloc] init];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.companyId_ = [dic objectForKey:@"company_id"];
    
    NSDictionary *info = dic[@"info"];
    NSString *companyId = nil;
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *synergyId = info[@"synergy_id"];
        if ([synergyId isKindOfClass:[NSString class]] && ![synergyId isEqualToString:@""]) {
            dataModal.synergy_id = synergyId;
        }
        companyId = info[@"company_id"];
    }
    if (!dataModal.companyId_) {
        if ([companyId isKindOfClass:[NSString class]] && ![companyId isEqualToString:@""]) {
            dataModal.companyId_ = companyId;
        }
    }
    
    if (dataModal.companyId_) {
        dataModal.status_ = Success_Status;
    }
    else{
        dataModal.status_ = Fail_Status;
    }
    dataModal.jumpUrl_ = [dic objectForKey:@"jump_url"];
    
    
    
    [dataArr_ addObject:dataModal];
}

//解析绑定公司的信息
-(void)parserCompanyHRDetail:(NSDictionary*)dic
{
    CompanyInfo_DataModal * dataModal = [[CompanyInfo_DataModal alloc] init];
    dataModal.companyID_ = [dic objectForKey:@"id"];
    dataModal.cname_ = [dic objectForKey:@"cname"];
    dataModal.logoPath_ = [dic objectForKey:@"logopath"];
    dataModal.resumeCnt_ = [[dic objectForKey:@"resume_notread_cnt"] integerValue];
    dataModal.resumeRecommendUnreadCnt = [[dic objectForKey:@"resume_recommend_unreadcnt"] integerValue];
    dataModal.interviewCnt_ = [[dic objectForKey:@"mail_cnt"] integerValue];
    dataModal.questionCnt_ = [[dic objectForKey:@"hr_qa_cnt"] integerValue];
    dataModal.trade_ = [dic objectForKey:@"trade"];
    dataModal.tradeId_ = [dic objectForKey:@"urlId"];
    dataModal.totalId_ = [dic objectForKey:@"totalid"];
    dataModal.email_ = [dic objectForKey:@"email"];
    dataModal.pname_ = [dic objectForKey:@"pname"];
    dataModal.address_ = [dic objectForKey:@"address"];
    dataModal.phone_ = [dic objectForKey:@"phone"];
    dataModal.pnames_ = [dic objectForKey:@"pnames"];
    dataModal.crnd_ = [dic objectForKey:@"Crnd"];
    dataModal.isGroup_ = [dic objectForKey:@"isgroup"];
    dataModal.colResumeCnt_ = [[dic objectForKey:@"resume_temp_cnt"] integerValue];
    dataModal.m_id = [dic objectForKey:@"m_id"];
    dataModal.m_isDown = [dic objectForKey:@"m_isDown"];
    dataModal.m_status = [dic objectForKey:@"m_status"];
    dataModal.m_dept_id = [dic objectForKey:@"m_dept_id"];
    dataModal.m_isAddZp = [dic objectForKey:@"m_isAddZp"];
    
    [dataArr_ addObject:dataModal];
}

//解析绑定公司的已发面试通知
-(void)parserCompanyInterview:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        User_DataModal * dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.isOpen = [[subDic objectForKey:@"kj"] boolValue];
        dataModal.isGWTJ_ = [[subDic objectForKey:@"gwtjflag"] boolValue];
        dataModal.emailId_ = [subDic objectForKey:@"id"];
        dataModal.userId_ = [subDic objectForKey:@"person_id"];
        dataModal.zpId_ = [subDic objectForKey:@"zpId"];
        dataModal.zye_ = [subDic objectForKey:@"zpinfo"];
        dataModal.sendtime_ = [subDic objectForKey:@"sdate"];
        dataModal.name_ = [subDic objectForKey:@"iname"];
        dataModal.sex_ = [subDic objectForKey:@"sex"];
        dataModal.age_ = [subDic objectForKey:@"nianling"];
        dataModal.regionCity_ = [subDic objectForKey:@"region"];
        dataModal.eduName_ = [subDic objectForKey:@"edu"];
        dataModal.gzNum_ = [subDic objectForKey:@"gznum"];
        dataModal.job_ = [subDic objectForKey:@"job"];
        dataModal.img_ = [subDic objectForKey:@"pic"];
        dataModal.mobile_ = [subDic objectForKey:@"shouji"];
        dataModal.haveAudio_ = NO;
        dataModal.havePic_ = NO;
        if ([[[subDic objectForKey:@"resume3D"] objectForKey:@"code"] isEqualToString:@"200"]) {
            NSDictionary * dic1 = [[subDic objectForKey:@"resume3D"] objectForKey:@"info"];
            if ([[dic1 objectForKey:@"photo_cnt"] integerValue] > 0) {
                dataModal.havePic_ = YES;
            }
            if ([[dic1 objectForKey:@"audio_cnt"] integerValue] > 0) {
                dataModal.haveAudio_ = YES;
            }
        }
        dataModal.updateTime = subDic[@"sdate"];
        [dataArr_ addObject:dataModal];
        
    }
}

//解析绑定公司的提问
-(void)parserCompanyQuestion:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        CompanyHRAnswer_DataModal * dataModal = [[CompanyHRAnswer_DataModal alloc] init];
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.id_ = [subDic objectForKey:@"chqa_id"];
        dataModal.companyId_ = [subDic objectForKey:@"chqa_company_id"];
        dataModal.cname_ = [subDic objectForKey:@"chqa_company_cname"];
        dataModal.quizzerId_ = [subDic objectForKey:@"chqa_person_id"];
        dataModal.quizzerName_ = [subDic objectForKey:@"chqa_person_iname"];
        dataModal.quizzerPic_ = [subDic objectForKey:@"pic"];
        dataModal.questionTitle_ = [subDic objectForKey:@"chqa_q_title"];
        dataModal.questionIdate_ = [subDic objectForKey:@"chqa_q_idate"];
        dataModal.questionType_ = [subDic objectForKey:@"chqa_q_type"];
        dataModal.answerContent_ = [subDic objectForKey:@"chqa_a_content"];
        dataModal.answerPerson_ = [subDic objectForKey:@"chqa_a_huidazhe"];
        dataModal.answerIdate_ = [subDic objectForKey:@"chqa_a_idate"];
        dataModal.answerId_ = [subDic objectForKey:@"chqa_a_id"];
        dataModal.isShow_ = [[subDic objectForKey:@"chqa_isshow"] boolValue];
        dataModal.isAnswered_ = [[subDic objectForKey:@"chqa_a_ishuida"] boolValue];
        dataModal.tradeId_ = [subDic objectForKey:@"chqa_company_urlId"];
        dataModal.totalId_ = [subDic objectForKey:@"chqa_company_totalid"];
        dataModal.quizzerSex_ = [subDic objectForKey:@"sex"];
        
        [dataArr_ addObject:dataModal];
    }
}

//解析绑定公司的未读简历
-(void)parserCompanyResume:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary * subDic in arr) {
            User_DataModal * dataModal = [[User_DataModal alloc] init];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            
            if (![[subDic objectForKey:@"personId"] isEqualToString:@""] && [subDic objectForKey:@"personId"] != nil) {
                dataModal.userId_ = [subDic objectForKey:@"personId"];
            }
            
            if (![[subDic objectForKey:@"senduid"] isEqualToString:@""] && [subDic objectForKey:@"senduid"] != nil) {
                dataModal.userId_ = [subDic objectForKey:@"senduid"];
            }
            
            if (![[subDic objectForKey:@"person_id"] isEqualToString:@""] && [subDic objectForKey:@"person_id"] != nil) {
                dataModal.userId_ = [subDic objectForKey:@"person_id"];
            }
            
            dataModal.emailId_ = [subDic objectForKey:@"id"];
            dataModal.name_ = [subDic objectForKey:@"sendname"];
            dataModal.img_ = [subDic objectForKey:@"pic"];
            dataModal.sex_ = [subDic objectForKey:@"sex"];
            dataModal.age_ = [subDic objectForKey:@"nianling"];
            dataModal.regionCity_ = [subDic objectForKey:@"city"];
            dataModal.eduName_ = [subDic objectForKey:@"edus"];
            dataModal.gzNum_ = [subDic objectForKey:@"gznum"];
            dataModal.job_ = [subDic objectForKey:@"job"];
            dataModal.zpId_ = [subDic objectForKey:@"jobid"];
            dataModal.mobile_ = [subDic objectForKey:@"shouji"];
            dataModal.isNewmail_ = [[subDic objectForKey:@"newmail"] boolValue];
            dataModal.isOpen = [[subDic objectForKey:@"kj"] boolValue];
            dataModal.isGWTJ_ = [[subDic objectForKey:@"gwtjflag"] boolValue];
            dataModal.tongguo = [subDic objectForKey:@"tongguo"];
            dataModal.sendtime_ = [subDic objectForKey:@"sendtime"];
            
            NSDictionary  *companyDic = subDic[@"company_person"];
            if ([companyDic isKindOfClass:[NSDictionary class]]) {
                dataModal.companyId = companyDic[@"reid"];
                dataModal.forKey = companyDic[@"forkey"];
                dataModal.forType = companyDic[@"fortype"];
                dataModal.tradeId = [companyDic objectForKey:@"tradeid"];
            }
            
            dataModal.haveAudio_ = NO;
            dataModal.havePic_ = NO;
            
            /*
            if ([[[subDic objectForKey:@"resume3D"] objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary * dic1 = [[subDic objectForKey:@"resume3D"] objectForKey:@"info"];
                if ([[dic1 objectForKey:@"photo_cnt"] integerValue] > 0) {
                    dataModal.havePic_ = YES;
                }
                if ([[dic1 objectForKey:@"audio_cnt"] integerValue] > 0) {
                    dataModal.haveAudio_ = YES;
                }
            }
            */
            
            [dataArr_ addObject:dataModal];
            
        }
    }
}


//解析公司推荐的简历
-(void)parserCompanyRecommendedResume:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    if ([arr isEqual:[NSNull null]] || arr.count <= 0) {
        return;
    }
    for (NSDictionary * subDic in arr) {
        User_DataModal * dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.isNewmail_ = ![[subDic objectForKey:@"newmail"] boolValue];
        dataModal.emailId_ = [subDic objectForKey:@"id"];
        dataModal.zpId_ = [subDic objectForKey:@"jobid"];
        dataModal.sendtime_ = [subDic objectForKey:@"sysupdatetime"];
        dataModal.name_ = [subDic objectForKey:@"sendname"];
        dataModal.uname_ = [subDic objectForKey:@"sendname"];
        dataModal.sex_ = [subDic objectForKey:@"sex"];
        dataModal.age_ = [subDic objectForKey:@"nianling"];
        dataModal.regionCity_ = [subDic objectForKey:@"city"];
        dataModal.eduName_ = [subDic objectForKey:@"edus"];
        dataModal.gzNum_ = [subDic objectForKey:@"gznum"];
        dataModal.job_ = [subDic objectForKey:@"job"];
        dataModal.img_ = [subDic objectForKey:@"pic"];
        dataModal.mobile_ = [subDic objectForKey:@"shouji"];
        dataModal.recommendId = [subDic objectForKey:@"tuijian_id"];
        
        if (![[subDic objectForKey:@"personId"] isEqualToString:@""] && [subDic objectForKey:@"personId"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"personId"];
        }
        
        if (![[subDic objectForKey:@"senduid"] isEqualToString:@""] && [subDic objectForKey:@"senduid"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"senduid"];
        }
        
        if (![[subDic objectForKey:@"person_id"] isEqualToString:@""] && [subDic objectForKey:@"person_id"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"person_id"];
        }
        
        dataModal.notOperating = NO;
        if([subDic[@"work_state"] isEqualToString:@"1"]){
            dataModal.resumeType = OPResumeTypeWorked;
        }
        else if([subDic[@"luyong_state"] isEqualToString:@"1"]){
            dataModal.resumeType = OPResumeTypeSendOffer;
        }
        else if([subDic[@"mianshi_state"] isEqualToString:@"6"]){
            dataModal.resumeType = OPResumeTypeInterviewed;
        }
        else if ([subDic[@"mianshi_state"] isEqualToString:@"7"])
        {
            dataModal.resumeType = OPResumeTypeInterviewUnqualified;
        }
        else if([subDic[@"company_state"] isEqualToString:@"1"]){
            dataModal.resumeType = OPResumeTypeConfirmFit;
        }
        else if ([subDic[@"company_state"] isEqualToString:@"3"])
        {
            dataModal.resumeType = OPResumeTypeWait;
            dataModal.notOperating = YES;
        }
        else if ([subDic[@"company_state"] isEqualToString:@"2"])
        {
            dataModal.resumeType = OPResumeTypeNoConfirFit;
        }
        else if ([subDic[@"company_state"] isEqualToString:@"0"])
        {
            dataModal.notOperating = YES;
        }
       
        dataModal.joinState = subDic[@"join_state"];//到场状态
        dataModal.interviewState = subDic[@"mianshi_state"];//面试状态
        dataModal.leaveState = subDic[@"leave_state"];
        dataModal.wait_mianshi = subDic[@"wait_mianshi"];
        
        dataModal.companyId = subDic[@"reid"];
        dataModal.forKey = subDic[@"forkey"];
        dataModal.forType = subDic[@"fortype"];
        dataModal.fromType = subDic[@"fromtype"];
        dataModal.recommendState = subDic[@"tj_state"];
        dataModal.jobfair_id = subDic[@"jobfair_id"];
        dataModal.resumeId = subDic[@"resume_id"];
        
        dataModal.haveAudio_ = NO;
        dataModal.havePic_ = NO;
        
        /*
        if ([[[subDic objectForKey:@"resume3D"] objectForKey:@"code"] isEqualToString:@"200"]) {
            NSDictionary * dic1 = [[subDic objectForKey:@"resume3D"] objectForKey:@"info"];
            if ([[dic1 objectForKey:@"photo_cnt"] integerValue] > 0) {
                dataModal.havePic_ = YES;
            }
            if ([[dic1 objectForKey:@"audio_cnt"] integerValue] > 0) {
                dataModal.haveAudio_ = YES;
            }
        }
         */
        dataModal.jlType = [subDic objectForKey:@"tjtype"];
        dataModal.report = [subDic objectForKey:@"report"];
        [dataArr_ addObject:dataModal];
        
    }
    
}

//转发给我
-(void)parserCompanyTurnToMeResume:(NSDictionary *)dic{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        User_DataModal * dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        if (![[subDic objectForKey:@"personId"] isEqualToString:@""] && [subDic objectForKey:@"personId"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"personId"];
        }
        
        if (![[subDic objectForKey:@"senduid"] isEqualToString:@""] && [subDic objectForKey:@"senduid"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"senduid"];
        }
        
        if (![[subDic objectForKey:@"person_id"] isEqualToString:@""] && [subDic objectForKey:@"person_id"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"person_id"];
        }
        
        dataModal.emailId_ = [subDic objectForKey:@"resumeTempId"];
        dataModal.sendtime_ = [subDic objectForKey:@"sendtime"];
        dataModal.name_ = [subDic objectForKey:@"person_iname"];
        dataModal.sex_ = [subDic objectForKey:@"sex"];
        dataModal.age_ = [subDic objectForKey:@"nianling"];
        dataModal.regionCity_ = [subDic objectForKey:@"city"];
        dataModal.eduName_ = [subDic objectForKey:@"edus"];
        dataModal.gzNum_ = [subDic objectForKey:@"gznum"];
        dataModal.job_ = [subDic objectForKey:@"jobname"];
        dataModal.img_ = [subDic objectForKey:@"pic"];
        dataModal.mobile_ = [subDic objectForKey:@"shouji"];
        if (![subDic objectForKey:@"shouji"]||[[subDic objectForKey:@"shouji"] isEqualToString:@""]) {
            dataModal.mobile_ = [subDic objectForKey:@"mobile"];
        }
        dataModal.companyId = subDic[@"company_id"];
        dataModal.forKey = subDic[@"cmailbox_id"];
        dataModal.sr_id = subDic[@"sr_id"];
        
        dataModal.haveAudio_ = NO;
        dataModal.havePic_ = NO;
        dataModal.updateTime = [subDic objectForKey:@"sr_idate"];
        [dataArr_ addObject:dataModal];
    }
}


//解析获取企业收藏简历的列表
-(void)parserCompanyCollectionResume:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        User_DataModal * dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.emailId_ = [subDic objectForKey:@"resumeTempId"];
        dataModal.userId_ = [subDic objectForKey:@"personId"];
        dataModal.sendtime_ = [subDic objectForKey:@"sendtime"];
        dataModal.name_ = [subDic objectForKey:@"iname"];
        dataModal.sex_ = [subDic objectForKey:@"sex"];
        dataModal.age_ = [subDic objectForKey:@"nianling"];
        dataModal.regionCity_ = [subDic objectForKey:@"regionidstr"];
        dataModal.eduName_ = [subDic objectForKey:@"edu"];
        dataModal.gzNum_ = [subDic objectForKey:@"gznum"];
        dataModal.job_ = [subDic objectForKey:@"job"];
        dataModal.img_ = [subDic objectForKey:@"pic"];
        dataModal.mobile_ = [subDic objectForKey:@"shouji"];
        if (![subDic objectForKey:@"shouji"]||[[subDic objectForKey:@"shouji"] isEqualToString:@""]) {
            dataModal.mobile_ = [subDic objectForKey:@"mobile"];
        }
        dataModal.companyId = [subDic objectForKey:@"uid"];
        dataModal.blocId = [subDic objectForKey:@"uids"];
        dataModal.forKey = [subDic objectForKey:@"resumeTempId"];

        
        dataModal.haveAudio_ = NO;
        dataModal.havePic_ = NO;
        dataModal.updateTime = [subDic objectForKey:@"idate"];
        [dataArr_ addObject:dataModal];
    }
}

//解析简历下载 企业查看用户的联系方式
-(void)parserDownloadResume:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.leftgjcnt = dic[@"info"][@"leftgjcnt"];
    dataModal.leftptcnt = dic[@"info"][@"leftptcnt"];
    [dataArr_ addObject:dataModal];
}

//解析企业是否能查看用户的联系方式
-(void)parserCompanyIslookPersonContact:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}

//解析企业收藏简历
-(void)parserCollectResume:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析简历预览的URL
-(void)parserResumeUrl:(NSDictionary *)dic
{
    NSString * url = [dic objectForKey:@"url"];
    NSString *fujinaUrl = dic[@"resume_swf"];
    NSString *pages = dic[@"resume_pages"];
    [dataArr_ addObject:url];
    [dataArr_ addObject:fujinaUrl];
    [dataArr_ addObject:pages];
}

//解析职位详情3GURL
- (void)parserPositionDetail3GURL:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.exObj_ = [dic objectForKey:@"result"];
    [dataArr_ addObject:model];
}

//解析回答绑定公司的问题
-(void)parserDoHRAnswer:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析设置简历是否通过
-(void)parserSetResumePass:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析绑定公司的其他HR列表
-(void)parserCompanyOtherHR:(NSDictionary*)dic
{
    NSArray * arr = (NSArray*)dic;
    for (NSDictionary * subDic in arr) {
        CompanyOtherHR_DataModal * dataModal = [[CompanyOtherHR_DataModal alloc] init];
        dataModal.contactId_ = [subDic objectForKey:@"company_contact_id"];
        dataModal.companyId_ = [subDic objectForKey:@"companyId"];
        dataModal.contactPhone_ = [subDic objectForKey:@"company_contact_phone"];
        dataModal.name_ = [subDic objectForKey:@"company_contact_pname"];
        dataModal.sex_ = [subDic objectForKey:@"company_contact_sex"];
        dataModal.contactMobl_ = [subDic objectForKey:@"company_contact_mobl"];
        dataModal.contactZW_ = [subDic objectForKey:@"company_contact_pnames"];
        dataModal.contactAddress_ = [subDic objectForKey:@"company_contact_address"];
        dataModal.contactEmail_ = [subDic objectForKey:@"company_contact_email"];
        dataModal.bChoosed_ = NO;
        [dataArr_ addObject:dataModal];
    }
}

//解析转发简历
-(void)parserTranspondResume:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    
    [dataArr_ addObject:dataModal];
}

//解析公司面试模板
-(void)parserInterviewModel:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        InterviewModel_DataModal * dataModal = [[InterviewModel_DataModal alloc] init];
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.companyId_ = [subDic objectForKey:@"uid"];
        dataModal.cname_ = [subDic objectForKey:@"cname"];
        dataModal.zwid_ = [subDic objectForKey:@"zwid"];
        dataModal.address_ = [subDic objectForKey:@"address"];
        dataModal.desc_ = [subDic objectForKey:@"sdesc"];
        dataModal.pname_ = [subDic objectForKey:@"pname"];
        dataModal.phone_ = [subDic objectForKey:@"phone"];
        dataModal.temlname_ = [subDic objectForKey:@"temlname"];
        dataModal.zwname_ = [subDic objectForKey:@"zwname"];
        
        [dataArr_ addObject:dataModal];
    }
}

//解析公司在招职位
-(void)parserCompanyZWForUsing:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        ZWDetail_DataModal * dataModal = [[ZWDetail_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.zwID_ = [subDic objectForKey:@"id"];
        dataModal.jtzw_ = [subDic objectForKey:@"jtzw"];
        dataModal.updateTime_ = [subDic objectForKey:@"updatetime"];
        dataModal.regionName_ = [subDic objectForKey:@"region"];
        dataModal.resumeNum_ = [subDic objectForKey:@"resume_total"];
        dataModal.resumeNewNum_ = [subDic objectForKey:@"resume_read"];
        
        [dataArr_ addObject:dataModal];
    }
}

//解析发送面试通知
-(void)parserSendInterview:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}

//解析获取服务信息的url
-(void)parserServiceURL:(NSDictionary*)dic
{
    NSString * url = [dic objectForKey:@"result"];
    [dataArr_ addObject:url];
}

//解析文章添加赞
-(void)parserArticleAddLike:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    
    [dataArr_ addObject:dataModal];
}

//解析绑定公司和个人
-(void)parserBindingCompany:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"result"];
    if ([str isEqualToString:@"1"]) {
        dataModal.status_ = Success_Status;
        dataModal.des_ = @"处理成功";
    }
    else{
        dataModal.status_ = Fail_Status;
        dataModal.des_ = @"处理失败，网络连接错误";
    }
    [dataArr_ addObject:dataModal];
}

//解析获取绑定的公司
-(void)parserGetBindingCompany:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.exObj_ = [dic objectForKey:@"company_id"];
    [dataArr_ addObject:dataModal];
}


//解析职位名称
- (void)getPositionName:(NSDictionary *)dic
{
    NSString *positionName = [dic objectForKey:@"jtzw"];
    [dataArr_ addObject:positionName];
}

//解析公司详情URL
- (void)parserCompanyDetailUrl:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.exObj_ = [dic objectForKey:@"result"];
    [dataArr_ addObject:model];
}

//解析设置简历已阅
-(void)parserSetNewMailRead:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}

//解析添加关注学校
- (void)parserAttendCareerSchool:(NSDictionary *)dic
{
    NSString *status  = [dic objectForKey:@"status"];
    if ([status isEqualToString:Success_Status]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendSchoolNotification" object:nil];
    }
    [dataArr_ addObject:status];
}


//解析取消关注学校
- (void)parserChangAttendCareerSchool:(NSDictionary *)dic
{
    NSString *status  = [dic objectForKey:@"status"];
    if ([status isEqualToString:Success_Status]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttendSchoolNotification" object:nil];
    }
    [dataArr_ addObject:status];
}

//解析请求我关注学校列表
- (void)getAttendSchoolList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *subArray = [dic objectForKey:@"data"];
    if (!subArray || subArray.count == 0 || [subArray isKindOfClass:[NSNull class]]) {
        return;
    }
    for (NSDictionary *subDic in subArray) {
        School_DataModal *model = [[School_DataModal alloc]init];
        model.logoPath_ = [subDic objectForKey:@"logopath"];
        model.id_ = [subDic objectForKey:@"id"];
        model.name_ = [subDic objectForKey:@"schoolname"];
        if (![subDic objectForKey:@"fair"] || [subDic objectForKey:@"fair"] == [NSNull null] || [[subDic objectForKey:@"fair"] isEqualToString:@"(null)"]) {
            model.schoolNews_ = @"暂无新动态";
        }
        else
            model.schoolNews_ = [subDic objectForKey:@"fair"];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:model];
    }
}

//请求学校宣讲会列表
- (void)parserGetSchoolXJHList:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        NewCareerTalkDataModal *dataModal = [NewCareerTalkDataModal new];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        [dataModal setValuesForKeysWithDictionary:subDic];
        [dataArr_ addObject:dataModal];
    }
}

//解析薪指排行大比拼结果
-(void)parserSalaryCompareResult:(NSDictionary*)dic
{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    ELSalaryResultDetailModel *dataModel = [[ELSalaryResultDetailModel alloc] initWithDictionary:dataDic];
    [dataArr_ addObject:dataModel];
}


//解析薪指搜索比拼结果
-(void)parserSalarySearchResult:(NSDictionary*)dic
{
    NSDictionary * dataDic = [dic objectForKey:@"data"];
    SalaryResult_DataModal * dataModal = [[SalaryResult_DataModal alloc] init];
    dataModal.percentDic_ = [dataDic objectForKey:@"percent"];
    
    if ([[dataDic objectForKey:@"reco_position"] isKindOfClass:[NSArray class]]) {
        NSArray * zwArr = [dataDic objectForKey:@"reco_position"];
        if (zwArr && zwArr != NULL ) {
            dataModal.recommendJobArr_ = [[NSMutableArray alloc] init];
            for (NSDictionary * zwDic  in zwArr) {
                JobSearch_DataModal *zwModal = [[JobSearch_DataModal alloc] init];
                zwModal.zwID_ = [zwDic objectForKey:@"id"];
                zwModal.jtzw_ = [zwDic objectForKey:@"jtzw"];
                zwModal.companyID_ = [zwDic objectForKey:@"uid"];
                zwModal.companyName_ =[zwDic objectForKey:@"cname"];
                zwModal.cnameAll_ = [zwDic objectForKey:@"cname_all"];
                zwModal.regionName_ = [zwDic objectForKey:@"regionname"];
                zwModal.updateTime_ = [zwDic objectForKey:@"updatetime"];
                zwModal.salary_ = [zwDic objectForKey:@"xzdy"];
                zwModal.welfareArray_ = [zwDic objectForKey:@"fldy"];
                zwModal.companyLogo_ = [zwDic objectForKey:@"logo"];
                
                [dataModal.recommendJobArr_ addObject:zwModal];
            }
        }
        
    }
    
    if ([[dataDic objectForKey:@"reco_adv"] isKindOfClass:[NSArray class]]) {
        NSDictionary * adDic = [[dataDic objectForKey:@"reco_adv"] objectAtIndex:0];
        dataModal.ADImgPath_ = [adDic objectForKey:@"ya_path"] ;
        dataModal.ADUrl_ = [adDic objectForKey:@"ya_url"];
        
    }
    [dataArr_ addObject:dataModal];
}

#pragma mark 解析薪指搜索比拼结果(新)
-(void)parserSalarySearchResult2:(NSDictionary*)dic
{
    NSDictionary * dataDic = [dic objectForKey:@"info"];
    SalaryResult_DataModal *dataModal = [[SalaryResult_DataModal alloc] init];
    dataModal.percentDic_ = [dataDic objectForKey:@"percent"];
    
    if ([[dataDic objectForKey:@"recommend"] isKindOfClass:[NSArray class]]) {
        NSArray * recommendArr = [dataDic objectForKey:@"recommend"];
        if (recommendArr && recommendArr != NULL ) {
            dataModal.recommendUserArr = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in recommendArr) {//不要分页
                User_DataModal *userModal = [self parserPersonSalary:subDic];
                [dataModal.recommendUserArr addObject:userModal];
            }
        }
    }
    [dataArr_ addObject:dataModal];
    [[Manager shareMgr] showSayViewWihtType:5];
}



//解析解除绑定
-(void)parserCancelBindCompany:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"result"];
    if ([str isEqualToString:@"1"]) {
        dataModal.status_ = Success_Status;
        dataModal.des_ = @"处理成功";
    }
    else{
        dataModal.status_ = Fail_Status;
        dataModal.des_ = @"处理失败，网络连接错误";
    }
    [dataArr_ addObject:dataModal];
}


//解析语音上传
-(void)parserUpdateVoiceFile:(NSDictionary *)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"msg"];
    dataModal.exObj_ = [dic objectForKey:@"path"];
    [dataArr_  addObject:dataModal];
}

//解析上传图片
- (void)parserUploadPhoto:(NSDictionary *)dic
{
    Upload_DataModal *dataModal = [[Upload_DataModal alloc] init];
    
    NSDictionary *infoDic = [dic objectForKey:@"info"];
    
    dataModal.exe_ = [infoDic objectForKey:@"exe"];
    dataModal.path_ = [infoDic objectForKey:@"path"];
    dataModal.name_ = [infoDic objectForKey:@"name"];
    dataModal.size_ = [infoDic objectForKey:@"size"];
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    NSDictionary *pathDic = [dic objectForKey:@"path"];
    
    int i = 0;
    while ( 1 ) {
        if (i == 1) {
            ++i;
        }
        NSDictionary *tmpDic = [pathDic objectForKey:[NSString stringWithFormat:@"%d",i]];
        if( !tmpDic || ![tmpDic isKindOfClass:[NSDictionary class]] ){
            break;
        }
        Upload_DataModal *modal = [[Upload_DataModal alloc] init];
        if ([[tmpDic objectForKey:@"deal_size"] isEqualToString:@"670*625"]) {
            modal.size_ = @"670";
            modal.path_ = [tmpDic objectForKey:@"path"];
            [pathArray addObject:modal];
        }else if ([[tmpDic objectForKey:@"deal_size"] isEqualToString:@"220*140"]){
            modal.size_ = @"220";
            modal.path_ = [tmpDic objectForKey:@"path"];
            [pathArray addObject:modal];
        }else if ([[tmpDic objectForKey:@"deal_size"] isEqualToString:@"140*140"]){
            modal.size_ = @"140";
            modal.path_ = [tmpDic objectForKey:@"path"];
            [pathArray addObject:modal];
        }else if ([[tmpDic objectForKey:@"deal_size"] isEqualToString:@"960*600"]){
            modal.size_ = @"960";
            modal.path_ = [tmpDic objectForKey:@"path"];
            [pathArray addObject:modal];
        }else if ([[tmpDic objectForKey:@"deal_size"] isEqualToString:@"80*80"]){
            modal.size_ = @"80";
            modal.path_ = [tmpDic objectForKey:@"path"];
            [pathArray addObject:modal];
        }
        ++i;
    }
    dataModal.pathArr_ = pathArray;
    [dataArr_ addObject:dataModal];
    
}


//解析添加简历图片
- (void)parserAddResumePhoto:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.exObj_ = [[dic objectForKey:@"info"] objectForKey:@"id"];
    [dataArr_ addObject:model];
}

//解析获取简历图片语音
- (void)parserGetResumePhotoAndVoice:(NSDictionary *)dic
{
    NSMutableArray *photoArr = [[NSMutableArray alloc]init];
    NSMutableArray *voiceArr = [[NSMutableArray alloc]init];
    
    NSArray *photoArray = [dic objectForKey:@"photo"];
    if (![photoArray isKindOfClass:[NSNull class]] && [photoArray count] !=0) {
        for (NSDictionary *photoDic in photoArray) {
            PhotoVoiceDataModel *model = [[PhotoVoiceDataModel alloc]init];
            model.photoId_ = [photoDic objectForKey:@"pp_id"];
            model.photoBigPath_ = [photoDic objectForKey:@"pp_path"];
//            model.photoSmallPath_ = [photoDic objectForKey:@"pp_path_220_140"];
            model.photoSmallPath140_ = [photoDic objectForKey:@"pp_path_140_140"];
//            model.photoPmcId_ = [photoDic objectForKey:@"pmc_id"];
            [photoArr addObject:model];
        }
    }
    [dataArr_ addObject:photoArr];
    NSArray *voiceArray = [dic objectForKey:@"audio"];
    if(![voiceArray isKindOfClass:[NSNull class]]){
        for (NSDictionary *voiceDic in voiceArray) {
            PhotoVoiceDataModel *model = [[PhotoVoiceDataModel alloc]init];
            model.voiceId_ = [voiceDic objectForKey:@"pa_id"];
            model.voicePath_ = [voiceDic objectForKey:@"pa_path"];
            model.voiceTime_ = [voiceDic objectForKey:@"pa_time"];
            model.voicePmcId_ = [voiceDic objectForKey:@"pmc_id"];
            [voiceArr addObject:model];
        }
    }
    [dataArr_ addObject:voiceArr];
}

//删除简历图片
- (void)parserDeleteResumeImage:(NSDictionary *)dic
{
    NSString *status = [dic objectForKey:@"status"];
    [dataArr_ addObject:status];
}

//解析添加简历语音
- (void)parserAddResumeVoice:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    if ([model.status_ isEqualToString:@"OK"]) {
        NSMutableDictionary *voiceInfoDic = [dic objectForKey:@"info"];
        NSString *voiceIdStr = [voiceInfoDic objectForKey:@"id"];
        NSString *voiceCateIdStr = [voiceInfoDic objectForKey:@"cate_id"];
        NSArray *voiceArray = [[NSArray alloc]initWithObjects:voiceIdStr,voiceCateIdStr,nil];
        model.exObjArr_ = voiceArray;
    }
    [dataArr_ addObject:model];
    
}

//解析注册时请求添加关注学校
- (void)parserAddAttentionSchool:(NSDictionary *)dic
{
    
}

//获取身边工作
- (void)parserGetNearbyWork:(NSDictionary *)dic
{
    NSArray  *dataArray = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in dataArray) {
        CompanyInfo_DataModal *model = [[CompanyInfo_DataModal alloc]init];
        model.companyID_ = [dataDic objectForKey:@"uid"];
        model.cname_ = [dataDic objectForKey:@"cname"];
        model.zpCount_ = [dataDic objectForKey:@"zpcount"];
        model.lat_ = [dataDic objectForKey:@"latnum"];
        model.lng_ = [dataDic objectForKey:@"Longnum"];
        model.regionid_ = [dataDic objectForKey:@"regionid"];
        model.positionId = [dataDic objectForKey:@"id"];
        model.companyLogo = [dataDic objectForKey:@"logopath"];
        model.cxz_ = [dataDic objectForKey:@"cxz"];
        model.yuangong_ = [dataDic objectForKey:@"yuangong"];
        model.trade_ = [dataDic objectForKey:@"trade"];
        model.gznum = [dataDic objectForKey:@"gznum"];
        if ([model.gznum isEqualToString:@""] || [model.gznum isEqualToString:@"不限"]) {
            model.gznum =@"工作经验不限";
        }
        model.edus = [dataDic objectForKey:@"edus"];
        if ([model.edus isEqualToString:@""]) {
            model.edus = @"学历不限";
        }
        model.salary = [dataDic objectForKey:@"salary"];
        if (model.salary != nil) {
            model.salary = [model.salary stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
            model.salary = [model.salary stringByReplacingOccurrencesOfString:@"月薪" withString:@"元/月"];
            model.salary = [model.salary stringByReplacingOccurrencesOfString:@"年薪" withString:@"元/年"];
        }
        model.positionName = [dataDic objectForKey:@"jtzw"];
        NSArray *array = [dataDic objectForKey:@"com_tag"];
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                [arr addObject: [dic objectForKey:@"tag_name"]];
            }
            model.tagArray = arr;
        }
        [dataArr_ addObject:model];
    }
}

//第三方登录 解析是否绑定
- (void)parserDetectBinding:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.code_ = [dic objectForKey:@"code"];
    model.is_binding = dic[@"is_Bind"];
    if ([model.code_ isEqualToString:@"200"]) {
        NSDictionary  *userDic = [[dic objectForKey:@"info"] objectForKey:@"user"];
        NSMutableArray *userArray = [[NSMutableArray alloc]init];
        [userArray addObject:[userDic objectForKey:@"uname"]];
        [userArray addObject:[userDic objectForKey:@"password"]];
        model.exObjArr_ = userArray;
    }
    [dataArr_ addObject:model];
}

//解析创建并绑定第三方
-(void)parserBuildPerson:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    if ([[dic objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSDictionary  *userDic = [[dic objectForKey:@"info"] objectForKey:@"user"];
        NSMutableArray *userArray = [[NSMutableArray alloc]init];
        [userArray addObject:[userDic objectForKey:@"uname"]];
        [userArray addObject:[userDic objectForKey:@"password"]];
        model.exObjArr_ = userArray;
        model.exObjArr_ = userArray;
    }
    [dataArr_ addObject:model];
}

//解析个人主页访问记录
-(void)parserMyCenterVisitLog:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    NSString * str = [dic objectForKey:@"status"];
    NSString *upperStr = [str uppercaseString];
    dataModal.status_ = upperStr;
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}

//更新社群信息
- (void)parserUpdateGroups:(NSDictionary *)dic
{
    NSString *status = [dic objectForKey:@"status"];
    [dataArr_ addObject:status];
}

//获取校园招聘活动的分享url
-(void)parserSchoolZPShareUrl:(NSDictionary*)dic
{
    NSString * url = [dic objectForKey:@"url"];
    if (url) {
        [dataArr_ addObject:url];
    }
}

//解析获取同行
- (void)parserGetSameTradePerson:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dataDic in dataArray) {
            Expert_DataModal *model = [[Expert_DataModal alloc]init];
            model.is_shiming = dataDic[@"is_shiming"];
            model.id_ = [dataDic objectForKey:@"personId"];
            model.ylPersonFlag_ = [dataDic objectForKey:@"yl_person_flag"];
            model.sendEmailFlag_ = [dataDic objectForKey:@"send_mail_flag"];
            model.iname_ = [dataDic objectForKey:@"person_iname"];
            model.sex_ = [dataDic objectForKey:@"person_sex"];
            model.age_ = [dataDic objectForKey:@"age"];
            model.zw_ = [dataDic objectForKey:@"person_zw"];
            model.gznum_ = [dataDic objectForKey:@"person_gznum"];
            model.img_ = [dataDic objectForKey:@"person_pic"];
            model.followStatus_ = [[dataDic objectForKey:@"rel"] intValue];
            model.sameSchool_ = [dataDic objectForKey:@"same_school"];
            model.sameCity_ = [dataDic objectForKey:@"same_city"];
            model.sameHometown_ = [dataDic objectForKey:@"same_hka"];
            model.job_ = [dataDic objectForKey:@"person_job_now"];
            if ([[dataDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
                model.isExpert_ = YES;
            }else{
                model.isExpert_ = NO;
            }
            model.pageCnt_ = page.pageCnt_;
            model.totalCnt_ = page.totalCnt_;
            model.dynamicType_ = dataDic[@"_dynamic"][@"type"];
            if ([model.dynamicType_ isEqualToString:@"article"]) {
                model.dynamictype_ = Dynamic_Article;
            }
            else if ([model.dynamicType_ isEqualToString:@"audio"]){
                model.dynamictype_ = Dynamic_Audio;
            }
            else if ([model.dynamicType_ isEqualToString:@"photo"]){
                model.dynamictype_ = Dynamic_Photo;
            }
            else if ([model.dynamicType_ isEqualToString:@"tag"]){
                model.dynamictype_ = Dynamic_Tag;
            }
            else if ([model.dynamicType_ isEqualToString:@"group"]){
                model.dynamictype_ = Dynamic_Group;
            }
            else if ([model.dynamicType_ isEqualToString:@"follow"]){
                model.dynamictype_ = Dynamic_Follow;
            }
            else if ([model.dynamicType_ isEqualToString:@"pic"]){
                model.dynamictype_ = Dynamic_Pic;
            }
            else
            {
                model.dynamictype_ = Dynamic_Other;
            }
            model.dynamicDesc_ = dataDic[@"_dynamic"][@"desc"];
            model.dynamicInfo_ = dataDic[@"_dynamic"][@"info"];
            [dataArr_ addObject:model];
        }
    }
    
}

//解析获取同行
- (void)parserGetNewSameTradePerson:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"][@"person"];
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dataDic in dataArray) {
            ELSameTradePeopleFrameModel *dataModel = [[ELSameTradePeopleFrameModel alloc] init];
            dataModel.pageCnt_ = page.pageCnt_;
            dataModel.totalCnt_ = page.totalCnt_;
            ELSameTradePeopleModel *model = [[ELSameTradePeopleModel alloc] initWithDictionary:dataDic];
            dataModel.peopleModel = model;
            [dataArr_ addObject:dataModel];
        }
    }
}

//解析获取听众我的关注
-(void)parserGetFriend:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in dataArray) {
        ELSameTradePeopleFrameModel *dataModel = [[ELSameTradePeopleFrameModel alloc] init];
        dataModel.pageCnt_ = page.pageCnt_;
        dataModel.totalCnt_ = page.totalCnt_;
        ELSameTradePeopleModel *model = [[ELSameTradePeopleModel alloc] initWithDictionary:dataDic];
        dataModel.peopleModel = model;
        [dataArr_ addObject:dataModel];
    }
}

//hehe 社群邀请
-(void)parserGetFriend11:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in dataArray) {
        Expert_DataModal *model = [[Expert_DataModal alloc]init];
        model.id_ = [dataDic objectForKey:@"personId"];
        if ([[dataDic objectForKey:@"person_iname"] isKindOfClass:[NSString class]]) {
            model.iname_ = [dataDic objectForKey:@"person_iname"];
        }else{
            model.iname_ =@"";
        }
        model.sex_ = [dataDic objectForKey:@"person_sex"];
        model.zw_ = [dataDic objectForKey:@"person_zw"];
        model.gznum_ = [dataDic objectForKey:@"person_gznum"];
        model.img_ = [dataDic objectForKey:@"person_pic"];
        model.ctime_ = [dataDic objectForKey:@"addtime"];
        model.followStatus_ = [[dataDic objectForKey:@"is_rel"] intValue];
        if ([[dataDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
            model.isExpert_ = YES;
        }else{
            model.isExpert_ = NO;
        }
        model.isNewFollow_ = [dataDic objectForKey:@"is_new"];
        model.sameCity_ = [dataDic objectForKey:@"same_city"];
        model.sameSchool_ = [dataDic objectForKey:@"same_school"];
        model.age_ = [dataDic objectForKey:@"age"];
        model.pageCnt_ = page.pageCnt_;
        model.totalCnt_ = page.totalCnt_;
        if ([dataDic objectForKey:@"is_group_member"]) {
            if ([[dataDic objectForKey:@"is_group_member"] integerValue] == 1) {
                model.isGroupMember = YES;
            }
            else
            {
                model.isGroupMember = NO;
            }
        }
        else
        {
            model.isGroupMember = NO;
        }
        [dataArr_ addObject:model];
    }
}
//解析获取同行中新朋友和新评论的数量
- (void)parserGetNewFriendAndComment:(NSDictionary *)dic
{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    NSDictionary *followDic = [dataDic objectForKey:@"follow"];
    NSDictionary *adDic = [dataDic objectForKey:@"adv"];
//    NSDictionary *groupDic = [dataDic objectForKey:@"group"];
    
    NSMutableArray *imgArray = [[NSMutableArray alloc]init];
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.exObj_ = [followDic objectForKey:@"cnt"];
    if (![followDic isKindOfClass:[NSNull class]]) {
        NSArray *followDetailArr = [followDic objectForKey:@"data"];
        if (![followDetailArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *followDetailDic in followDetailArr) {
                [imgArray addObject:[followDetailDic objectForKey:@"person_pic"]];
            }
            model.exObjArr_ = [imgArray mutableCopy];
            [dataArr_ addObject:model];
        }
    }
    AD_dataModal * ad = [[AD_dataModal alloc] init];
    if ([[adDic objectForKey:@"status"] isEqualToString:Success_Status]) {
        NSDictionary *aDic = [[adDic objectForKey:@"info"] objectAtIndex:0];
        ad.title_ = [aDic objectForKey:@"title"];
        ad.pic_ = [aDic objectForKey:@"pic"];
        ad.type_ = [aDic objectForKey:@"type"];
        ad.typeId_ = [aDic objectForKey:@"type_id"];
        [dataArr_ addObject:ad];
    }
    
}

//解析获取我的文章评论列表
-(void)parserGetMyArticleCommentList:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in dataArray) {
        NewCommentMsgModel *model = [[NewCommentMsgModel alloc]init];
        model.isVisit_ = [dataDic objectForKey:@"is_visit"];
        model.name_ = [[dataDic objectForKey:@"comment_person"] objectForKey:@"person_iname"];
        model.commentPhoto_ = [[dataDic objectForKey:@"comment_person"] objectForKey:@"person_pic"];
        model.commentcontent_ = [[dataDic objectForKey:@"comment_info"] objectForKey:@"content"];
        model.createTime_ = [[dataDic objectForKey:@"comment_info"] objectForKey:@"ctime"];
        model.articleTitle_ = [[dataDic objectForKey:@"article_info"] objectForKey:@"title"];
        model.articleId_ = [[dataDic objectForKey:@"article_info"] objectForKey:@"article_id"];
        model.pageCnt_ = page.pageCnt_;
        model.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:model];
    }
}

//解析获取主页中心信息
- (void)parserGetPersonCenterData:(NSDictionary *)dic
{
    PersonCenterDataModel *model = [[PersonCenterDataModel alloc]init];
    NSDictionary *personInfoDic = [dic objectForKey:@"person_info"];
    NSArray *audioListArray = [dic objectForKey:@"audio_list"];
    NSArray *photoListArray = [dic objectForKey:@"photo_list"];
    NSArray *articleListArray = [dic objectForKey:@"article_list"];
    NSArray *tagListArray = [dic objectForKey:@"tag_label_list"];
    NSArray *skillListArray = [dic objectForKey:@"tag_skill_list"];
    NSArray *fieldListArray = [dic objectForKey:@"tag_field_list"];
    NSArray *groupListArray = [dic objectForKey:@"group_list"];
    NSArray *visitListArray = [dic objectForKey:@"visit_list"];
    NSArray *interviewArray = [dic objectForKey:@"app_exam_list"];
    NSDictionary    *personDic = [dic objectForKey:@"login_person_info"];
    //个人信息
    if ([[personInfoDic objectForKey:@"person_iname"] isKindOfClass:[NSString class]]) {
            model.userModel_.iname_ = [personInfoDic objectForKey:@"person_iname"];
    }else{
        model.userModel_.iname_ = @"";
    }
    model.userModel_.tradeId = [personInfoDic objectForKey:@"tradeid"];
    model.userModel_.tradeName = [personInfoDic objectForKey:@"trade_name"];
    model.userModel_.img_ = [personInfoDic objectForKey:@"person_pic"];
    model.userModel_.gznum_ = [personInfoDic objectForKey:@"person_gznum"];
    model.userModel_.job_ = [personInfoDic objectForKey:@"person_job_now"];
    model.userModel_.zw_ = [personInfoDic objectForKey:@"person_zw"];
    model.userModel_.age_ = [personInfoDic objectForKey:@"person_age"];
    model.userModel_.cityStr_ = [personInfoDic objectForKey:@"person_region_name"];
    model.userModel_.sex_ = [personInfoDic objectForKey:@"person_sex"];
    model.userModel_.signature_ = [personInfoDic objectForKey:@"person_signature"];
    model.userModel_.fansCnt_ = [[personInfoDic objectForKey:@"fans_count"] intValue];
    model.userModel_.followCnt_ = [[personInfoDic objectForKey:@"follow_count"] intValue];
    model.userModel_.favoriteCnt_ = [[personInfoDic objectForKey:@"favorite_cnt"] intValue];
    model.userModel_.followStatus_ = [[personInfoDic objectForKey:@"rel"] intValue];
    model.userModel_.bday_ = [personInfoDic objectForKey:@"person_bday"];
    if (![personDic isKindOfClass:[NSNull class]]) {
        model.userModel_.isSetAudio = [personDic objectForKey:@"is_set_audio"];
        model.userModel_.isSetPhoto = [personDic objectForKey:@"is_set_photo"];
    }
    if ([[personInfoDic objectForKey:@"group_invite"] isEqualToString:@"0"] || [[personInfoDic objectForKey:@"group_invite"] isEqualToString:@""]) {
        model.userModel_.haveInviteGroup = NO;
    }else{
        model.userModel_.haveInviteGroup = YES;
    }
    
    //语音信息
    if (![audioListArray isKindOfClass:[NSNull class]]) {
        NSDictionary *audioListDic =  [audioListArray objectAtIndex:0];
        model.voiceModel_.voiceId_ = [audioListDic objectForKey:@"pa_id"];
        model.voiceModel_.voiceCateId_ = [audioListDic objectForKey:@"pmc_id"];
        model.voiceModel_.serverFilePath_ = [audioListDic objectForKey:@"pa_path"];
        model.voiceModel_.duration_ = [audioListDic objectForKey:@"pa_time"];
    }
    
    //图片信息
    if (![photoListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *photoListDic in photoListArray) {
            PhotoVoiceDataModel *photoModel = [[PhotoVoiceDataModel alloc] init];
            photoModel.photoId_ = [photoListDic objectForKey:@"pp_id"];
            photoModel.photoBigPath_ = [photoListDic objectForKey:@"pp_path"];
            [model.photoListArray_ addObject:photoModel];
        }
    }
    
    //文章信息
    if (![articleListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *articleListDic in articleListArray) {
            Article_DataModal *newsModel = [[Article_DataModal alloc] init];
            newsModel.id_ = [articleListDic objectForKey:@"article_id"];
            newsModel.title_ = [articleListDic objectForKey:@"title"];
            [model.articleListArray_ addObject:newsModel];
        }
    }
    
    //个性标签
    if (![tagListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *tagListDic in tagListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
            [model.tagListArray_ addObject:tagModel];
        }
    }
    
    //想学技能
    if (![skillListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *tagListDic in skillListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
            [model.skillListArray_ addObject:tagModel];
        }
    }
    
    //擅长领域
    if (![fieldListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *tagListDic in fieldListArray) {
            personTagModel *tagModel = [[personTagModel alloc] init];
            tagModel.tagId_ = [tagListDic objectForKey:@"ylt_id"];
            tagModel.tagName_ = [MyCommon removeSpaceAtSides:[tagListDic objectForKey:@"ylt_name"]];
            [model.fieldListArray_ addObject:tagModel];
        }
    }
    
    //我的小编专访
    if (![interviewArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *interviewDic in interviewArray) {
            InterviewDataModel *interviewModel = [[InterviewDataModel alloc]init];
            interviewModel.id_ = [interviewDic objectForKey:@"shitiid"];
            interviewModel.question_ = [interviewDic objectForKey:@"title"];
            interviewModel.answer_ = [interviewDic objectForKey:@"daan"];
            [model.interviewArray_ addObject:interviewModel];
        }
    }
    
    //我的创建的社群
    if (![groupListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *groupListDic in groupListArray) {
            Groups_DataModal *groupModel = [[Groups_DataModal alloc] init];
            groupModel.id_  = [groupListDic objectForKey:@"group_id"];
            groupModel.pic_ = [groupListDic objectForKey:@"group_pic"];
            groupModel.name_ = [groupListDic objectForKey:@"group_name"];
            groupModel.articleCnt_ = [[groupListDic objectForKey:@"group_article_cnt"] intValue];
            groupModel.personCnt_ = [[groupListDic objectForKey:@"group_person_cnt"] intValue];
            if (![[groupListDic objectForKey:@"_article_list"] isKindOfClass:[NSNull class]]) {
                groupModel.firstArt_.id_ = [[groupListDic objectForKey:@"_article_list"] objectForKey:@"article_id"];
                groupModel.firstArt_.title_ = [[groupListDic objectForKey:@"_article_list"] objectForKey:@"title"];
                groupModel.firstArt_.personName_ = [[[groupListDic objectForKey:@"_article_list"] objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
            }
            if (![[groupListDic objectForKey:@"group_person_rel"] isKindOfClass:[NSNull class]]) {
                @try {
                    groupModel.code_ = [[groupListDic objectForKey:@"group_person_rel"] objectForKey:@"code"];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
            [model.groupListArray_ addObject:groupModel];
        }

    }
        //我的近期访客
    if (![visitListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *visitListDic in visitListArray) {
            Expert_DataModal *visitModel = [[Expert_DataModal alloc] init];
            visitModel.img_ = [visitListDic objectForKey:@"person_pic"];
            visitModel.id_ = [visitListDic objectForKey:@"person_id"];
            [model.visitListArray_ addObject:visitModel];
        }
    }
    
    [dataArr_ addObject:model];
}


//解析最新评论列表(推送)
-(void)parserMyCommentList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        Comment_DataModal * dataModal = [[Comment_DataModal alloc] initWithDictionary:subDic];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        NSDate * date = [MyCommon getDate:dataModal.datetime_];
        dataModal.datetime_ = [MyCommon compareCurrentTime:date];
        [dataArr_ addObject:dataModal];
    }
}

//解析我的系统通知列表（消息）
-(void)parserMySystemNotification:(NSDictionary*)dic
{
    NSArray * arr = [dic objectForKey:@"data"];
    PageInfo * page = [self parserPageInfo:dic];
    for (NSDictionary * subDic in arr)
    {
        NSString *msgType = [subDic objectForKey:@"msg_type"];
        
        if ([msgType isEqualToString:@"201"] || [msgType isEqualToString:@"202"] || [msgType isEqualToString:@"310"])
        {
            GroupInvite_DataModal * dataModal = [[GroupInvite_DataModal alloc] initWithDictionary:subDic];
        }
        else{
            SysNotification_DataModal * dataModal = [[SysNotification_DataModal alloc] initWithDictionary:subDic];
            dataModal.pageCnt_ = page.pageCnt_;
            dataModal.totalCnt_ = page.totalCnt_;
            [dataArr_ addObject:dataModal];
        }
        
    }
}

//解析打招呼列表（消息）
-(void)parserSayHiList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr)
    {
        Expert_DataModal * dataModal = [[Expert_DataModal alloc] initWithDictionary:subDic];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//解析留言列表(消息)
-(void)parserLetterList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr)
    {
        Expert_DataModal *dataModal = [[Expert_DataModal alloc] initWithParserLetterListDictionary:subDic];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//解析社群消息（消息）
-(void)parserGroupsMessageList:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr)
    {
        GroupInvite_DataModal * dataModal = [[GroupInvite_DataModal alloc] init];
//        dataModal.msg_type = @"310";
//        dataModal.group_name = @"十分了解多少了房间了觉得浪费就分手了看法";
//        dataModal.person_iname = @"网络经理介绍的房间卡上来看";
//        dataModal.idatetime = @"2016-09-16";
//        [dataModal activityMessageContent];
        if ([subDic[@"msg_type"] isEqualToString:@"251"]) {
            dataModal = [[GroupInvite_DataModal alloc] initWithGroupMessageDictionary:subDic];
        }
        else if ([subDic[@"msg_type"] isEqualToString:@"200"]) {
            dataModal = [[GroupInvite_DataModal alloc] initWithGroupMessageTwoDictionary:subDic];
        }
        else if ([subDic[@"msg_type"] isEqualToString:@"310"]){
            dataModal = [[GroupInvite_DataModal alloc] initWithGroupMessageOneDictionary:subDic];
        }else{
            dataModal = [[GroupInvite_DataModal alloc] initWithDictionary:subDic];
        }
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//解析获取默认标签
- (void)parserGetTagsList:(id)array
{
    for (NSDictionary *tagDic in (NSArray *)array) {
        personTagModel *tagModel = [[personTagModel alloc]init];
        tagModel.tagId_ = [[tagDic objectForKey:@"tag_info"] objectForKey:@"ylt_id"];
        tagModel.tagName_ = [MyCommon removeSpaceAtSides:[[tagDic objectForKey:@"tag_info"] objectForKey:@"ylt_name"]];
        [dataArr_ addObject:tagModel];
    }
}

//解析获取行业标签
- (void)parserGetTradeTagsList:(NSDictionary *)array
{
    for (NSDictionary *dict in (NSArray *)array) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            personTagModel *tagModel = [[personTagModel alloc]init];
            tagModel.tagId_ = key;
            tagModel.tagName_ = obj;
            [dataArr_ addObject:tagModel];
            *stop = YES;
        }];
        
    }
}

#pragma mark 解析技能的行业标签
- (void)parserGetSkillTradeTagsList:(NSDictionary *)tagList
{
    for (NSDictionary *dic in (NSArray *)tagList) {
        personTagModel *tagModel = [[personTagModel alloc]init];
        tagModel.tagId_ = dic[@"ylt_id"];
        tagModel.queryId_ = dic[@"yltpr_id"];
        tagModel.tagName_ = dic[@"ylt_name"];
        [dataArr_ addObject:tagModel];
    }
}

#pragma mark 解析热门标签和第一个子标签
- (void)GetHotTagAndChildTag:(NSDictionary *)dic
{
    
    NSArray *secondTags = dic[@"2"];
    NSArray *thirdTags = dic[@"3"];
    [dataArr_ removeAllObjects];
    if(dic[@"2"] != [NSNull null])
    {
        NSMutableArray *secondTagArr = [NSMutableArray array];
        for (NSDictionary *dic in secondTags) {
            personTagModel *tagModel = [[personTagModel alloc]init];
            tagModel.tagId_ = dic[@"ylt_id"];
            tagModel.queryId_ = dic[@"yltpr_id"];
            tagModel.tagName_ = dic[@"ylt_name"];
            [secondTagArr addObject:tagModel];
        }
        [dataArr_ addObject:secondTagArr];
    }
    if (dic[@"3"] != [NSNull null]) {
        NSMutableArray *thirdTagArr = [NSMutableArray array];
        for (NSDictionary *dic in thirdTags) {
            personTagModel *tagModel = [[personTagModel alloc]init];
            tagModel.tagId_ = dic[@"ylt_id"];
            tagModel.tagName_ = dic[@"ylt_name"];
            [thirdTagArr addObject:tagModel];
        }
        [dataArr_ addObject:thirdTagArr];
    }
}

//解析获取职业标签
- (void)parserGetJobTagsList:(NSArray *)arr
{
    for (NSDictionary *dic in arr) {
        personTagModel *tagModel = [[personTagModel alloc]init];
        tagModel.tagId_ = dic[@"zwid"];
        tagModel.tagName_ = dic[@"zwname"];
        [dataArr_ addObject:tagModel];
    }
}

//解析修改标签
- (void)parserUpdateTagsList:(NSDictionary *)dic
{
    NSString *status = [dic objectForKey:@"status"];
    [dataArr_ addObject:status];
}

//打招呼 留言
- (void)parserSendMessage:(NSDictionary *)dic;
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:model];
}


//解析我的问答（消息）
-(void)parsermyAQlist:(NSDictionary*)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary * subDic in arr) {
            MyQuestionAndAnswerModal *dataModal = [[MyQuestionAndAnswerModal alloc] initWithdict:subDic];
            dataModal.pageCnt_ = page.pageCnt_;
            dataModal.totalCnt_ = page.totalCnt_;
            
            [dataArr_ addObject:dataModal];
        }
    }
}

//回答专访问题
- (void)parserAnswerInterviewQuestion:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//获取小编专访列表
- (void)parserGetInterviewList:(NSDictionary *)dic
{
    NSArray *interviewArray = [dic objectForKey:@"data"];
    for (NSDictionary *interviewDic in interviewArray) {
        InterviewDataModel *interviewModel = [[InterviewDataModel alloc]init];
        interviewModel.id_ = [interviewDic objectForKey:@"shitiid"];
        interviewModel.question_ = [interviewDic objectForKey:@"title"];
        interviewModel.answer_ = [interviewDic objectForKey:@"daan"];
        [dataArr_ addObject:interviewModel];
    }
}

//解析是否有权限查看更多小编专访
- (void)parserGetShowMoreAnswer:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:model];
}

//解析消息模块各项的新消息数
-(void)parserMessageCnt:(NSDictionary*)dic
{
    Message_DataModal * model = [[Message_DataModal alloc] init];
    NSDictionary * dataDic = [dic objectForKey:@"data"];
    model.toolBarGroupCnt = [[dataDic objectForKey:@"group_dynamic_cnt"] integerValue];
    model.companyCnt = [[dataDic objectForKey:@"resume_read_cnt"] integerValue];
    model.messageCnt = [[dataDic objectForKey:@"message_cnt"] integerValue];
    model.resumeCnt = [[dataDic objectForKey:@"resume_cnt"] integerValue];
    model.questionCnt = [[dataDic objectForKey:@"question_cnt"] integerValue];
    model.myInterViewCnt = [[dataDic objectForKey:@"yuetan_cnt"] integerValue];
    model.oaMsgCount = [[dataDic objectForKey:@"oa_msg_cnt"] integerValue];
    model.sameTradeMessageCnt = 0;
    model.friendMessageCnt = 0;
    [dataArr_ addObject:model];
}

//解析找他搜索
- (void)parserGetTraderPeson:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in dataArray) {
            ELSameTradePeopleFrameModel *dataModel = [[ELSameTradePeopleFrameModel alloc] init];
            ELSameTradePeopleModel *model = [[ELSameTradePeopleModel alloc] initWithDictionary:dic];
            dataModel.pageCnt_ = page.pageCnt_;
            dataModel.totalCnt_ = page.totalCnt_;
            dataModel.peopleModel = model;
            [dataArr_ addObject:dataModel];
        }
    }
    //[self parserGetSameTradePerson:dic];
}

//解析获取社群数量
- (void)parserGetGroupsCnt:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

//查看简历完整度
- (void)parserGetResumeComplete:(NSDictionary *)dic
{
    ResumeCompleteModel *model = [[ResumeCompleteModel alloc]init];
    model.basic_ = [dic objectForKey:@"basic"]; //基本资料 2完善 1不完善
    model.edu_ = [dic objectForKey:@"edus"];   //教育背景 2完善 1不完善
    model.work_ = [dic objectForKey:@"work"];  //工作经历 2完善 1不完善
    [dataArr_ addObject:model];
}

//解析删除文章
- (void)parserDeleteArticle:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    [dataArr_ addObject:model];
}

//解析举报非法文章
-(void)parserToReportIllegalArticle:(NSDictionary*)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:model];
}

//解析获取社群置顶话题列表
- (void)parserSetRecommendArticle:(NSDictionary *)dic
{
    PageInfo * page = [self parserPageInfo:dic];
    NSArray *articleArray = [dic objectForKey:@"data"];
    for (NSDictionary *articlDic in articleArray) {
        Article_DataModal *dataModal = [self parserArticle:articlDic];
        dataModal.pageCnt_ = page.pageCnt_;
        dataModal.totalCnt_ = page.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

//修改置顶话题
- (void)parserSaveRecommendSet:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:model];
}

//解析删除社群文章
- (void)parserDeleteGroupArticle:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.des_ = [dic objectForKey:@"status_desc"];
    [dataArr_ addObject:model];
}

//解析记录用户当前状态
-(void)parserUserStatus:(NSDictionary*)dic
{
    
}

//解析评论列表
-(void) parserCommentListOld:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Comment_DataModal *dataModal = [self parserCommentModal:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
    
}

//解析获取有邀请权限的社群
-(void)parserGetInveteGroupWithUserId:(NSDictionary *)dic
{
    NSArray *dataArray = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in dataArray) {
        Groups_DataModal *model = [[Groups_DataModal alloc] init];
        model.id_ = [dataDic objectForKey:@"group_id"];
        model.name_ = [dataDic objectForKey:@"group_name"];
        model.createrId_ = [dataDic objectForKey:@"group_person_id"];
        model.pic_ = [dataDic objectForKey:@"group_pic"];
        if ([[dataDic objectForKey:@"is_invite"] isEqualToString:@"0"]) {
            model.invitePerm_ = NO;
        }else{
            model.invitePerm_ = YES;
        }
        [dataArr_ addObject:model];
    }
}

//解析请求意向职位
- (void)parserGetPersonInfo:(NSDictionary *)dic
{
    PersonDetailInfo_DataModal *model = [[PersonDetailInfo_DataModal alloc]init];
    model.job_ = [dic objectForKey:@"job"];
    model.jobs_ = [dic objectForKey:@"jobs"];
    model.job1_ = [dic objectForKey:@"job1"];
    model.city_ = [dic objectForKey:@"city"];
    model.gzdd1_ = [dic objectForKey:@"gzdd1"];
    model.gzdd5_ = [dic objectForKey:@"gzdd5"];
    model.updateTime_ = [dic objectForKey:@"updateTime"];
    model.phone_ = [dic objectForKey:@"phone"];
    model.shouji_ = [dic objectForKey:@"shouji"];
    model.emial_ = [dic objectForKey:@"emial"];
    model.qq_ = [dic objectForKey:@"qq"];
    model.http_ = [dic objectForKey:@"http"];
    model.post_ = [dic objectForKey:@"post"];
    model.address_ = [dic objectForKey:@"address"];
    model.pic_ = [dic objectForKey:@"pic"];
    model.iname_ = [dic objectForKey:@"iname"];
    model.gznum_ = [dic objectForKey:@"gznum"];
    model.sex_ = [dic objectForKey:@"sex"];
    model.edu_ = [dic objectForKey:@"edu"];
    model.bday_ = [dic objectForKey:@"bday"];
    model.hka_ = [dic objectForKey:@"hka"];
    model.region_ = [dic objectForKey:@"region"];
    model.zcheng_ = [dic objectForKey:@"zcheng"];
    model.marray_ = [dic objectForKey:@"marray"];
    model.zzmm_ = [dic objectForKey:@"zzmm"];
    model.mzhu_ = [dic objectForKey:@"mzhu"];
    model.jobtype_ = [dic objectForKey:@"jobtype"];
    model.worddate_ = [dic objectForKey:@"workdate"];
    model.yuex_ = [dic objectForKey:@"yuex"];
    model.grzz_ = [dic objectForKey:@"grzz"];
    model.school_ = [dic objectForKey:@"school"];
    model.byday_ = [dic objectForKey:@"byday"];
    model.zye_ = [dic objectForKey:@"zye"];
    model.zym_ = [dic objectForKey:@"zym"];
    model.edus_ = [dic objectForKey:@"edus"];
    model.gzjl_ = [dic objectForKey:@"gzjl"];
        model.othertc_ = [dic objectForKey:@"othertc"];
    if ( [[dic objectForKey:@"resumeStatus"] isEqualToString:@"0"]) {
        model.resumeStatus_ = NO;
    }else{
        model.resumeStatus_ = YES;
    }
    if ([[dic objectForKey:@"bOld"] isEqualToString:@"0"]) {
        model.bOld_ = NO;
    }else{
        model.bOld_ = YES;
    }
    if ([[dic objectForKey:@"bCanLooked"] isEqualToString:@"0"]) {
        model.bCanLooked_ = NO;
    }else{
        model.bCanLooked_ = YES;
    }
    [dataArr_ addObject:model];
}


//关注人中搜索

-(void)searchInviteFans:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        Expert_DataModal *dataModal = [[Expert_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.id_ = [subDic objectForKey:@"personId"];
        dataModal.iname_ = [subDic objectForKey:@"person_iname"];
        dataModal.img_ = subDic[@"person_detail"][@"person_pic"];
        dataModal.zw_ = subDic[@"person_detail"][@"person_zw"];
        
        [dataArr_ addObject:dataModal];
        
    }
}

//解析简历评价标签列表
-(void)parserResumeCommentTagList:(NSDictionary*)dic
{
    NSArray *arr = (NSArray*)dic;
//    for (NSDictionary * subDic in arr) {
//        ResumeCommentTag_DataModal * dataModal = [[ResumeCommentTag_DataModal alloc] init];
//        dataModal.tagId_ = [subDic objectForKey:@"ylt_id"];
//        dataModal.tagName_ = [subDic objectForKey:@"ylt_name"];
        [dataArr_ addObject:arr];
//    }
}

//解析简历下载列表
-(void)parserDownloadResumeList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * arr = [dic objectForKey:@"data"];
    for (NSDictionary * subDic in arr) {
        User_DataModal * dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        
        if (![[subDic objectForKey:@"personId"] isEqualToString:@""] && [subDic objectForKey:@"personId"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"personId"];
        }
        
        if (![[subDic objectForKey:@"senduid"] isEqualToString:@""] && [subDic objectForKey:@"senduid"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"senduid"];
        }
        
        if (![[subDic objectForKey:@"person_id"] isEqualToString:@""] && [subDic objectForKey:@"person_id"] != nil) {
            dataModal.userId_ = [subDic objectForKey:@"person_id"];
        }
        
        dataModal.emailId_ = [subDic objectForKey:@"resumeTempId"];
        dataModal.sendtime_ = [subDic objectForKey:@"sendtime"];
        dataModal.name_ = [subDic objectForKey:@"iname"];
        dataModal.sex_ = [subDic objectForKey:@"sex"];
        dataModal.age_ = [subDic objectForKey:@"nianling"];
        dataModal.regionCity_ = [subDic objectForKey:@"city"];
        dataModal.eduName_ = [subDic objectForKey:@"edus"];
        dataModal.gzNum_ = [subDic objectForKey:@"gznum"];
        dataModal.job_ = [subDic objectForKey:@"job"];
        dataModal.img_ = [subDic objectForKey:@"pic"];
        dataModal.mobile_ = [subDic objectForKey:@"shouji"];
        if (![subDic objectForKey:@"shouji"]||[[subDic objectForKey:@"shouji"] isEqualToString:@""]) {
            dataModal.mobile_ = [subDic objectForKey:@"mobile"];
        }
        
        dataModal.companyId = subDic[@"uid"];
        dataModal.forKey = subDic[@"forkey"];
        dataModal.forType = subDic[@"fortype"];

        dataModal.haveAudio_ = NO;
        dataModal.havePic_ = NO;
        dataModal.updateTime = [subDic objectForKey:@"idate"];
        [dataArr_ addObject:dataModal];
    }
}

//解析简历评论列表
-(void)parserResumeCommentList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        ResumeComment_DataModal *dataModal = [[ResumeComment_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.id_ = [subDic objectForKey:@"company_resume_comment_id"];
        dataModal.companyId_ = [subDic objectForKey:@"company_id"];
        dataModal.labelId_ = [subDic objectForKey:@"company_resume_comment_label_id"];
        dataModal.updatetime_ = subDic[@"company_resume_comment_updatetime"];
        dataModal.companyName_ = subDic[@"company_cname"];
        dataModal.author_ = subDic[@"company_resume_comment_author"];
        dataModal.content_ = subDic[@"company_resume_comment_content"];
        dataModal.personId_ = subDic[@"person_id"];
        dataModal.cmailId_ = subDic[@"cmailbox_id"];
        [dataArr_ addObject:dataModal];
    }

}

//解析其他关联企业的账号列表
-(void)parserOtherCompanyAccountList:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    if ([dataModal.status_ isEqualToString:Success_Status]) {
        dataModal.exObjArr_ = [NSArray arrayWithArray:[dic objectForKey:@"info"]];
    }
    [dataArr_ addObject:dataModal];
}

//解析添加简历评价
-(void)parserAddResumeComment:(NSDictionary*)dic
{
    Status_DataModal * dataModal = [[Status_DataModal alloc] init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"desc"];
    [dataArr_ addObject:dataModal];
}

//分享文章到动态
-(void)parserShareArticleDyanmic:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = [dic objectForKey:@"status"];
    model.code_ = [dic objectForKey:@"code"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//人才简历列表
-(void)parserCompanySearchResume:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *keyWorkArr = dic[@"analyze"];
    NSString *keyWorkString = nil;
    if ([keyWorkArr isKindOfClass:[NSArray class]]) {
        keyWorkString = [keyWorkArr componentsJoinedByString:@","];
    }
    
    NSArray *arr = dic[@"data"][@"datalist"];
    if (arr.count > 0) {
        for (NSDictionary *subDic in arr) {
            //peopleResumeDataModal *dataModal = [[peopleResumeDataModal alloc] init];
            User_DataModal *dataModal = [[User_DataModal alloc] init];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            dataModal.name_ = subDic[@"iname"];
            if (![subDic[@"job"] isEqualToString:@""]) {
                dataModal.job_ = subDic[@"job"];
            }
            else if(![subDic[@"jobs"] isEqualToString:@""])
            {
                dataModal.job_ = subDic[@"jobs"];
            }
            else if(![subDic[@"job1"] isEqualToString:@""])
            {
                dataModal.job_ = subDic[@"job1"];
            }
            dataModal.sex_ = subDic[@"sex"];
            dataModal.age_ = subDic[@"age"];
            dataModal.keyWorkStr = keyWorkString;
            dataModal.sendtime_ = subDic[@"update_endtime"];
            dataModal.eduName_ = subDic[@"edus"];
            dataModal.userId_ = subDic[@"id"];
            dataModal.img_ = subDic[@"pic"];
            dataModal.regionCity_ = subDic[@"city"];
            dataModal.gzNum_ = subDic[@"gznum"];
            dataModal.isDown = subDic[@"cfavorite_flag"];
            dataModal.kj = subDic[@"kj"];
            dataModal.email_ = subDic[@"email"];
            dataModal.mobile_ = subDic[@"shouji"];
            [dataArr_ addObject:dataModal];
        }
    }
    else
    {
        User_DataModal *dataModal = [[User_DataModal alloc] init];
        dataModal.status_ = dic[@"status"];
        dataModal.code_ = dic[@"code"];
        dataModal.des_ = dic[@"status_dsec"];
        [dataArr_ addObject:dataModal];
    }
}


//解析接收到推送消息的回调结果
-(void)parserReceiveMessageCallback:(NSDictionary*)dic
{
    
}

//解析薪资比拼的总次数
-(void)parserSalaryCompareSum:(NSDictionary *)dic
{
    NSString *remainCnt = [dic objectForKey:@"result"];
    [dataArr_ addObject:remainCnt];
}

//解析简历信息
- (void)parserGetResumeInfo:(NSDictionary *)dic
{
    PersonDetailInfo_DataModal *dataModal = [[PersonDetailInfo_DataModal alloc] init];
    NSDictionary *resumeDic = [dic objectForKey:@"resume"];
    NSDictionary *edusDic = [dic objectForKey:@"edus"];
    NSDictionary *workDic = [dic objectForKey:@"work"];
    @try {
        if ([resumeDic isKindOfClass:[NSDictionary class]]) {
            dataModal.iname_ = [resumeDic objectForKey:@"iname"];
            dataModal.sex_ = [resumeDic objectForKey:@"sex"];
            dataModal.rcType_ = [resumeDic objectForKey:@"rctypeId"];
            dataModal.bday_ = [resumeDic objectForKey:@"bday"];
            dataModal.hka_ = [resumeDic objectForKey:@"hka"];
            dataModal.gznum_ = [resumeDic objectForKey:@"gznum"];
            dataModal.shouji_ = [resumeDic objectForKey:@"shouji"];
            dataModal.emial_ = [resumeDic objectForKey:@"email"];
            dataModal.evaluation = [resumeDic objectForKey:@"grzz"];
            dataModal.job_ = [resumeDic objectForKey:@"job"];
            dataModal.person_status = [resumeDic objectForKey:@"person_status"];
        }
        if ([edusDic isKindOfClass:[NSDictionary class]] ) {
            dataModal.school_ = [edusDic objectForKey:@"school"];
            dataModal.edusId = [edusDic objectForKey:@"edusId"];
            dataModal.eduStratTime = [edusDic objectForKey:@"startdate"];
            dataModal.eduEndTime = [edusDic objectForKey:@"stopdate"];
            dataModal.eduId = [edusDic objectForKey:@"eduId"];
            dataModal.personId = [edusDic objectForKey:@"personId"];
            dataModal.studyIsToNow = [edusDic objectForKey:@"istonow"];
        }
        if ([workDic isKindOfClass:[NSDictionary class]]) {
            dataModal.workId = [workDic objectForKey:@"workId"];
            dataModal.workStratTime = [workDic objectForKey:@"startdate"];
            dataModal.workEndTime = [workDic objectForKey:@"stopdate"];
            dataModal.workIsToNow = [workDic objectForKey:@"istonow"];
            dataModal.companyName = [workDic objectForKey:@"company"];
            dataModal.zw = [workDic objectForKey:@"jtzw"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {}
    [dataArr_ addObject:dataModal];
}


//解析简历更新
- (void)parserUpdateResumeInfoWithPersonId:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = [dic objectForKey:@"status"];
    model.code_ = [dic objectForKey:@"code"];
    model.status_desc = [dic objectForKey:@"修改成功"];
    [dataArr_ addObject:model];
}


#pragma mark - 获取屏蔽公司列表
- (void)parserGetSheidCompanyList:(NSDictionary *)dic
{
    NSArray *array = [dic objectForKey:@"data"];
    if ([array isKindOfClass:[NSArray class]]) {
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.exObjArr_ = array;
        [dataArr_ addObject:model];
    }
}

#pragma mark - 解析搜索公司
- (void)parserGetCompany:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *array = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in array) {
        WorkApplyDataModel *model = [[WorkApplyDataModel alloc]init];
        model.companyName_ = [dataDic objectForKey:@"cname"];
        if ([model.companyName_ isEqualToString:@"null"]) {
            continue;
        }
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:model];
    }
}

#pragma mark - 解析设置或取消屏蔽公司
- (void)parserSetSheidCompany:(NSDictionary *)dic
{
    NSArray *array = [dic objectForKey:@"data"];
    if ([array isKindOfClass:[NSArray class]]) {
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.exObjArr_ = array;
        [dataArr_ addObject:model];
    }
}


//徽章列表
-(void)parserMybadgesList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        BadgeModal *dataModal = [[BadgeModal alloc] initWithDictionaryTwo:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}
//用户声望总数
-(void)parserMyPrestige:(NSDictionary *)dic
{
    [dataArr_ addObject:dic[@"total"]];
}

//解析首页顶部广告
-(void)parserTopAD:(NSDictionary*)dic
{
    if ([dic isKindOfClass:[NSArray class]])
    {
        NSArray * array = (NSArray*)dic;
        for (NSDictionary * subDic in array)
        {
            AD_dataModal * dataModal = [[AD_dataModal alloc] init];
            dataModal.pic_ = subDic[@"path"];
            dataModal.target_ = subDic[@"target"];
            dataModal.url_ = subDic[@"url"];
            dataModal.title_ = subDic[@"title"];
            dataModal.type_ = subDic[@"_param"][@"type"];
            
            if ([dataModal.type_ isEqualToString:@"yl_app_expert"])
            {
                dataModal.pid = subDic[@"_param"][@"pid"];
            }
            
            if ([dataModal.type_ isEqualToString:@"yl_app_normal_publish_detail"] || [dataModal.type_ isEqualToString:@"yl_app_guan_detail"])
            {
                dataModal.aid = subDic[@"_param"][@"aid"];
            }
            
            if ([dataModal.type_ isEqualToString:@"yl_app_user_publish_list"])
            {
                dataModal.pid = subDic[@"_param"][@"pid"];
            }
            
            if ([dataModal.type_ isEqualToString:@"yl_app_group"])
            {
                dataModal.gid = subDic[@"_param"][@"gid"];
            }
            
            if ([dataModal.type_ isEqualToString:@"yl_app_group_topic_detail"])
            {
                dataModal.gid = subDic[@"_param"][@"gid"];
                dataModal.aid = subDic[@"_param"][@"aid"];
                dataModal.code = subDic[@"_param"][@"code"];
                dataModal.group_open_status = subDic[@"_param"][@"group_open_status"];
                dataModal.articleTitle = subDic[@"_param"][@"title"];
                dataModal.articleJoinCnt = subDic[@"_param"][@"cnt"];
            }
            
            if ([dataModal.type_ isEqualToString:@"yl_app_job_zw"])
            {
                dataModal.zwid = subDic[@"_param"][@"zwid"];
                dataModal.company_name = subDic[@"_param"][@"company_name"];
                dataModal.company_id = subDic[@"_param"][@"company_id"];
                dataModal.company_logo = subDic[@"_param"][@"company_logo"];
            }
            
            if ([dataModal.type_ isEqualToString:@"yl_app_job_company"])
            {
                dataModal.company_name = subDic[@"_param"][@"company_name"];
                dataModal.company_id = subDic[@"_param"][@"company_id"];
            }
            
            if ([dataModal.type_ isEqualToString:@"zd_question"])
            {
                dataModal.question_id = subDic[@"_param"][@"question_id"];
            }
            
            if ([dataModal.type_ isEqualToString:@"teachins_zph"] || [dataModal.type_ isEqualToString:@"teachins_xjh"])
            {
                dataModal.teachins_id = subDic[@"_param"][@"teachins_id"];
            }
            
            [dataArr_ addObject:dataModal];
        }
    }
    
}

//声望列表
-(void)parserMyPrestigeList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr ) {
        BadgeModal *dataModal = [[BadgeModal alloc] initWithDictionary:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

#pragma mark - 解析个人中心1
- (void)parserGetPersonCenter1:(NSDictionary *)dic
{
    
    PersonCenterDataModel *modal = [[PersonCenterDataModel alloc]init];
    NSDictionary *personInfoDic = [dic objectForKey:@"person_info"];
    NSArray *audioListArray = [dic objectForKey:@"audio_list"];
//    NSArray *photoListArray = [dic objectForKey:@"photo_list"];
//    NSArray *articleListArray = [dic objectForKey:@"article_list"];
//    NSArray *tagListArray = [dic objectForKey:@"tag_label_list"];
//    NSArray *skillListArray = [dic objectForKey:@"tag_skill_list"];
//    NSArray *fieldListArray = [dic objectForKey:@"tag_field_list"];
//    NSArray *badgelistArray = [dic objectForKey:@"badge_list"];
//    NSArray *shareArticleListArray = [dic objectForKey:@"share_list"];
//    NSDictionary    *personDic = [dic objectForKey:@"login_person_info"];
    //个人信息
    if ([[personInfoDic objectForKey:@"person_iname"] isKindOfClass:[NSString class]]) {
        modal.userModel_.iname_ = [personInfoDic objectForKey:@"person_iname"];
    }else{
        modal.userModel_.iname_ = @"";
    }
    modal.userModel_.is_shiming = personInfoDic[@"is_shiming"];
    modal.userModel_.tradeId = [personInfoDic objectForKey:@"tradeid"];
    modal.userModel_.tradeName = [personInfoDic objectForKey:@"trade_name"];
    modal.userModel_.img_ = [personInfoDic objectForKey:@"person_pic"];
    modal.userModel_.gznum_ = [personInfoDic objectForKey:@"person_gznum"];
    modal.userModel_.job_ = [personInfoDic objectForKey:@"person_job_now"];
    modal.userModel_.zw_ = [personInfoDic objectForKey:@"person_zw"];
    modal.userModel_.age_ = [personInfoDic objectForKey:@"person_age"];
    modal.userModel_.cityStr_ = [personInfoDic objectForKey:@"person_region_name"];
    modal.userModel_.sex_ = [personInfoDic objectForKey:@"person_sex"];
    modal.userModel_.signature_ = [personInfoDic objectForKey:@"person_signature"];
    modal.userModel_.fansCnt_ = [[personInfoDic objectForKey:@"fans_count"] intValue];
    modal.userModel_.followCnt_ = [[personInfoDic objectForKey:@"follow_count"] intValue];
    modal.userModel_.followStatus_ = [[personInfoDic objectForKey:@"rel"] intValue];
    modal.userModel_.publishCnt_ = [[personInfoDic objectForKey:@"publish_count"] intValue];
    modal.userModel_.bday_ = [personInfoDic objectForKey:@"person_bday"];
    if ([[personInfoDic objectForKey:@"is_expert"] isEqualToString:@"1"]) {
        modal.userModel_.isExpert_ = YES;
    }else{
        modal.userModel_.isExpert_ = NO;
    }
    modal.userModel_.expertIntroduce_ = [personInfoDic objectForKey:@"person_intro"];
    if ([[personInfoDic objectForKey:@"prestige_cnt"] isEqualToString:@""]) {
        modal.userModel_.prestigeCnt = @"0";
    }else{
        modal.userModel_.prestigeCnt = [personInfoDic objectForKey:@"prestige_cnt"];
    }

    if ([[personInfoDic objectForKey:@"group_invite"] isEqualToString:@"0"] || [[personInfoDic objectForKey:@"group_invite"] isEqualToString:@""]) {
        modal.userModel_.haveInviteGroup = NO;
    }else{
        modal.userModel_.haveInviteGroup = YES;
    }
    
    //语音信息
    if (![audioListArray isKindOfClass:[NSNull class]]) {
        NSDictionary *audioListDic =  [audioListArray objectAtIndex:0];
        modal.voiceModel_.voiceId_ = [audioListDic objectForKey:@"pa_id"];
        modal.voiceModel_.voiceCateId_ = [audioListDic objectForKey:@"pmc_id"];
        modal.voiceModel_.serverFilePath_ = [audioListDic objectForKey:@"pa_path"];
        modal.voiceModel_.duration_ = [audioListDic objectForKey:@"pa_time"];
    }
    
    [dataArr_ addObject:modal];
}

#pragma mark - 解析个人中心2
- (void)parserGetPersonCenter2:(NSDictionary *)dic
{
    PersonCenterDataModel *model = [[PersonCenterDataModel alloc]init];
    NSArray *groupListArray = [dic objectForKey:@"group_list"];
    NSArray *visitListArray = [dic objectForKey:@"visit_list"];
    NSArray *interviewArray = [dic objectForKey:@"app_exam_list"];
    //我的小编专访
    if (![interviewArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *interviewDic in interviewArray) {
            InterviewDataModel *interviewModel = [[InterviewDataModel alloc]init];
            interviewModel.id_ = [interviewDic objectForKey:@"shitiid"];
            interviewModel.question_ = [interviewDic objectForKey:@"title"];
            interviewModel.answer_ = [interviewDic objectForKey:@"daan"];
            [model.interviewArray_ addObject:interviewModel];
        }
    }
    //我的创建的社群
    if (![groupListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *groupListDic in groupListArray) {
            Groups_DataModal *groupModel = [[Groups_DataModal alloc] init];
            groupModel.id_  = [groupListDic objectForKey:@"group_id"];
            groupModel.pic_ = [groupListDic objectForKey:@"group_pic"];
            groupModel.name_ = [groupListDic objectForKey:@"group_name"];
            groupModel.articleCnt_ = [[groupListDic objectForKey:@"group_article_cnt"] intValue];
            groupModel.personCnt_ = [[groupListDic objectForKey:@"group_person_cnt"] intValue];
            if (![[groupListDic objectForKey:@"_article_list"] isKindOfClass:[NSNull class]]) {
                groupModel.firstArt_.id_ = [[groupListDic objectForKey:@"_article_list"] objectForKey:@"article_id"];
                groupModel.firstArt_.title_ = [[groupListDic objectForKey:@"_article_list"] objectForKey:@"title"];
                groupModel.firstArt_.personName_ = [[[groupListDic objectForKey:@"_article_list"] objectForKey:@"_person_detail"] objectForKey:@"person_iname"];
            }
            if (![[groupListDic objectForKey:@"group_person_rel"] isKindOfClass:[NSNull class]]) {
                @try {
                    groupModel.code_ = [[groupListDic objectForKey:@"group_person_rel"] objectForKey:@"code"];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                }
            }
            [model.groupListArray_ addObject:groupModel];
        }
    }
    //我的近期访客
    if (![visitListArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *visitListDic in visitListArray) {
            Expert_DataModal *visitModel = [[Expert_DataModal alloc] init];
            visitModel.img_ = [visitListDic objectForKey:@"person_pic"];
            visitModel.id_ = [visitListDic objectForKey:@"person_id"];
            [model.visitListArray_ addObject:visitModel];
        }
    }
    
    NSString *favcount = [dic objectForKey:@"favorite_cnt"];
    if ([favcount isKindOfClass:[NSString class]]) {
        model.userModel_.favoriteCnt_ = [favcount intValue];
    }
    [dataArr_ addObject:model];
}

//简历订单记录
-(void)parserOrderRecord:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    
    for ( NSDictionary *subDic in arr )
    {
        OrderType_DataModal *dataModal = [[OrderType_DataModal alloc] initWithDictionary:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

#pragma mark 打赏记录
- (void)paserGetRewardRecord:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr )
    {
//        OrderType_DataModal *dataModal = [[OrderType_DataModal alloc] initWithDictionary:subDic];
//        dataModal.ordco_service_name = subDic[@"bill_type_name"];
//        dataModal.ordco_service_detail_name = subDic[@"bill_desc"];
//        dataModal.ordco_gwc_price = subDic[@"money"];
//        dataModal.ordco_gwc_idatetime = subDic[@"idatetime"];
//        dataModal.ordco_gwc_status = subDic[@"bill_status"];
//        dataModal.ordco_gwc_isIncome = subDic[@"is_income"];
//        dataModal.ordco_gwc_type = subDic[@"bill_type"];
//        dataModal.rewardImgId = subDic[@"record_info"][@"service_detail_id"];

        MyTradeRecordModal *dataModal = [[MyTradeRecordModal alloc] init];
        [dataModal setValuesForKeysWithDictionary:subDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:dataModal];
    }
}

#pragma mark 查薪订单记录
-(void)parserSalaryOrderRecord:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    if([arr isKindOfClass:[NSArray class]]){
        for ( NSDictionary *subDic in arr )
        {
            OrderType_DataModal *dataModal = [[OrderType_DataModal alloc] init];
            dataModal.ordco_gwc_id = subDic[@"ordco_gwc_id"];
            dataModal.ordco_service_name = subDic[@"ordco_service_name"];
            dataModal.ordco_service_detail_name = subDic[@"ordco_service_detail_name"];
            dataModal.ordco_gwc_price = subDic[@"ordco_gwc_price"];
            dataModal.ordco_gwc_status = subDic[@"ordco_gwc_status"];
            dataModal.ordco_gwc_idatetime = subDic[@"ordco_gwc_idatetime"];
            dataModal.order_use_status = subDic[@"_ordco_stat"];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:dataModal];
        }

    }
}

//服务信息
-(void)parserOrderServiceInfo:(NSDictionary *)dic
{
    [dataArr_ addObject:dic[@"basic"]];
    NSArray *serviceArr = dic[@"detail"];
    for (NSDictionary *orderService in serviceArr) {
        OrderService_DataModal *serviceModal = [[OrderService_DataModal alloc]initWithDictionary:orderService];
        [dataArr_ addObject:serviceModal];
    }
}

//简历推送服务信息
-(void)parserResumeApplyServiceInfo:(NSDictionary *)dic
{
    NSArray *serviceArr = dic[@"serviceData"];
    for (NSDictionary *orderService in serviceArr) {
        OrderService_DataModal *serviceModal = [[OrderService_DataModal alloc]initWithResumeApplyDictionary:orderService];
        [dataArr_ addObject:serviceModal];
    }
    
    if (dic[@"mobile"]) {
        [dataArr_ addObject:dic[@"mobile"]];
    }
}

//薪指服务信息
-(void)parserSalaryServiceInfo:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDict in arr) {
        OrderService_DataModal *serviceModal = [[OrderService_DataModal alloc]init];
        serviceModal.resumeId = subDict[@"xinzhi_service_id"];
        serviceModal.serviceName = subDict[@"service_detail_name"];
        serviceModal.originPrice = subDict[@"service_price_ori"];
        serviceModal.price = subDict[@"service_price"];
        serviceModal.isShow = subDict[@"service_status"];
        serviceModal.orders = subDict[@"orders"];
        serviceModal.serviceCode = @"P_XINZHI";
        [dataArr_ addObject:serviceModal];
    }
}


//订单生成
-(void)parserGenShoppingCart:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

//解析打赏订单生成
- (void)parserDashangShoppingCart:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

//获取服务状态
-(void)parserGetServiceStatus:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}


#pragma mark - 解析点击通知记录日志
- (void)parserMessageClickLog:(NSDictionary *)dic
{
    
}

//获取职业群与公司群列表
-(void)parserGetGroupJobAndCompany:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for (NSDictionary *subDic in arr) {
        ELGroupListDetailModel *modal = [[ELGroupListDetailModel alloc] initWithDictionary:subDic];
        modal.pageCnt_ = pageInfo.pageCnt_;
        modal.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:modal];
    }
}

#pragma mark 查询薪酬
-(void)parserGetQuerySalaryList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *subDic in arr) {
            User_DataModal *model = [[User_DataModal alloc]init];
            model.userId_ = subDic[@"person_id"];
            model.zym_ = subDic[@"zhiwei"];
            model.salary_ = subDic[@"person_yuex"];
            model.regionId_ = subDic[@"regionid"];
            model.sendtime_ = subDic[@"idatetime"];
            model.regiondetail_ = subDic[@"region_name"];
            model.followCnt_ =  [subDic[@"search_num"] intValue];
            model.pageCnt_ = pageInfo.pageCnt_;
            model.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:model];
        }
    }
}

#pragma mark 获取查询薪指的次数
-(void)parserGetQuerySalaryCount:(NSDictionary *)dic
{
    if ([dic[@"result"] isEqualToString:@""]) {
        [dataArr_ addObject:@{}];
    }
    [dataArr_ addObject:dic];
    
}


#pragma mark 今日看点
-(void)parserTodayFocusList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * dataArray = [dic objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSNull class]]) {
        dataArray = @[];
    }
    for (NSDictionary * subDic in dataArray) {
        TodayFocusFrame_DataModal * dataModal = [[TodayFocusFrame_DataModal alloc] init];
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        NSString *articleType = subDic[@"_source_type"];
        
        if ([articleType isEqualToString:@"hytt"]){//行业头条
            dataModal.articleType_ = Article_Trade_Head;
        }else if ([articleType isEqualToString:@"article_gxs"]){//灌薪水
            dataModal.articleType_ = Article_GXS;
        }else if ([articleType isEqualToString:@"article_group"]){//社群
            dataModal.articleType_ = Article_Group;
        }else if ([articleType isEqualToString:@"question"]) {//问答
            dataModal.articleType_ = Article_Question;
        }else if ([articleType isEqualToString:@"article"]) {//其他文章（同行文章）
            dataModal.articleType_ = Article_Follower;
        }
        ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:subDic];
        if ([model.is_recommend isEqualToString:@"1"]) {
            dataModal.isRecommentAnswer = YES;
        }
        if (model._activity_info) {
            dataModal.isActivityArtcle = YES;
            model._activity_info.person_id = model.personId;
            model._activity_info.person_pic = model.person_pic;
            model._activity_info.person_iname = model.person_iname;
        }
        dataModal.sameTradeArticleModel = model;
        if (model.article_id) {
            [dataArr_ addObject:dataModal];
        }
    }//结束循环
}


#pragma mark 简历比较
-(void)parserResumeCompare:(NSDictionary *)dic
{
//    NSDictionary *data = [dic objectForKey:@"data"];
    for (int i=0; i<2; i++)
    {
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc] init];
        
        if (i == 0) {
            myDic = [dic objectForKey:@"person_info"];
        }else if(i == 1){
            myDic = [dic objectForKey:@"compare_info"];
        }
        
        User_DataModal *myDataModel = [[User_DataModal alloc]init];
        myDataModel.percent = [myDic objectForKey:@"_percent"];
        myDataModel.name_ = [myDic objectForKey:@"iname"];
        myDataModel.eduName_ = [myDic objectForKey:@"edu"];
        myDataModel.img_ = [myDic objectForKey:@"pic"];
        if (![[myDic objectForKey:@"job"] isKindOfClass:[NSString class]]) {
            myDataModel.job_ = @"";
        }else{
            myDataModel.job_ = [myDic objectForKey:@"job"];
        }
        myDataModel.salary_ = [myDic objectForKey:@"yuex"];
        myDataModel.gzNum_ = [myDic objectForKey:@"gznum"];
        myDataModel.languageLevel_ = [myDic objectForKey:@"language"];
        myDataModel.computerLevel_ = [myDic objectForKey:@"computer"];
        //公司性质
        myDataModel.companyNature_ = [myDic objectForKey:@"company_xz"];
        myDataModel.regiondetail_ = [myDic objectForKey:@"region_name"];
        myDataModel.age_ = [myDic objectForKey:@"age"];
        
        myDataModel.school_ = [myDic objectForKey:@"school"];
        myDataModel.zym_ = [myDic objectForKey:@"zym"];
        
        
        if ([[myDic objectForKey:@"_work_list"] isKindOfClass:[NSArray class]])
        {
            NSArray *workList = [myDic objectForKey:@"_work_list"];
            if (workList && workList != NULL)
            {
                myDataModel.jobArr_ = [[NSMutableArray alloc] init];
                for (NSDictionary *zwDic in workList)
                {
                    UserJob_DataModal *zwModal = [[UserJob_DataModal alloc] init];
                    zwModal.stratDate_ = [zwDic objectForKey:@"startdate"];
                    zwModal.endDate_ = [zwDic objectForKey:@"stopdate"];
                    zwModal.zwName_ = [zwDic objectForKey:@"jtzw"];
                    zwModal.gznum_ = [zwDic objectForKey:@"gznum"];
                    
                    [myDataModel.jobArr_ addObject:zwModal];
                }
            }
        }
        
        [dataArr_ addObject:myDataModel];
    }

}

//灌薪水三种类型选择
-(void)parserSalaryTypeChange:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    for (NSDictionary *subDic in arr) {
        ELSalaryModel *model = [[ELSalaryModel alloc] initWithDictionary:subDic];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:model];
    }
}

//解析我的消息
-(void)parsergetMessageWith:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *array = [[dic objectForKey:@"data"] objectForKey:@"msg_list"];
    for (NSDictionary *dic in array) {
        MessageCenterDataModel *model = [[MessageCenterDataModel alloc] init];
        model.type = dic[@"type"];
        model.count = dic[@"cnt"];
        model.title = dic[@"show_title"];
        model.content = dic[@"show_content"];
        if (![model.content isKindOfClass:[NSString class]]) {
            model.content = @"";
        }
        model.content = [MyCommon translateHTML:model.content];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        [dataArr_ addObject:model];
    }
    NSMutableDictionary *countDic = [[NSMutableDictionary alloc] init];
    [countDic setValue:[dic objectForKey:@"data"][@"sums"][@"message"] forKey:@"messageCnt"];
    [countDic setValue:[dic objectForKey:@"data"][@"sums"][@"leave"] forKey:@"leaveCnt"];
    [countDic setValue:[dic objectForKey:@"data"][@"sums"][@"contact_cnt"] forKey:@"phoneCnt"];
    //[countDic setValue:[dic objectForKey:@"data"][@"sums"][@"all"] forKey:@"phoneCnt"];

    [dataArr_ addObject:countDic];
}

#pragma mark - 解析最新发表
-(void)parsergetNewPublicArticle:(NSDictionary*)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray * dataArray = [dic objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSNull class]]) {
        dataArray = @[];
    }
    for (NSDictionary * subDic in dataArray) {
        TodayFocusFrame_DataModal *dataModal = [[TodayFocusFrame_DataModal alloc] init];
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        NSString *articleType = subDic[@"_source_type"];
        
        if ([articleType isEqualToString:@"hytt"]){//行业头条
            dataModal.articleType_ = Article_Trade_Head;
        }else if ([articleType isEqualToString:@"article_gxs"]){//灌薪水
            dataModal.articleType_ = Article_GXS;
        }else if ([articleType isEqualToString:@"article_group"]){//社群
            dataModal.articleType_ = Article_Group;
        }else if ([articleType isEqualToString:@"question"]) {//问答
            dataModal.articleType_ = Article_Question;
        }else if ([articleType isEqualToString:@"article"]) {//其他文章（同行文章）
            dataModal.articleType_ = Article_Follower;
        }else{
            dataModal.articleType_ = Article_Follower;
        }

        ELSameTrameArticleModel *model = [[ELSameTrameArticleModel alloc] initWithDictionary:subDic];
        dataModal.sameTradeArticleModel = model;
        if (model._activity_info) {
            dataModal.isActivityArtcle = YES;
        }
        if ([model.is_recommend isEqualToString:@"1"]) {
            dataModal.isRecommentAnswer = YES;
        }
        if (model.article_id) {
            [dataArr_ addObject:dataModal];
        }
    }   
}

#pragma mark - 解析头部按钮顺序
-(void)parserTableHeadButtonList:(NSDictionary*)dic
{
    NSArray * arr = (NSArray*)dic;
    [dataArr_ addObjectsFromArray:arr];
}


-(void)parserTotalTradeListDic:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    
    for ( NSDictionary *subDic in arr )
    {
        Groups_DataModal *modal = [[Groups_DataModal alloc] init];
        modal.pageCnt_ = pageInfo.pageCnt_;
        modal.totalCnt_ = pageInfo.totalCnt_;
        modal.id_ = [subDic objectForKey:@"totalid"];
        modal.name_ = [subDic objectForKey:@"tName"];
        modal.code_ = [subDic objectForKey:@"shortname"];
        modal.pic_ = [subDic objectForKey:@"t_pic"];
        modal.intro_ = [subDic objectForKey:@"note"];
        modal.tags_ = [subDic objectForKey:@"sort"];
        [dataArr_ addObject:modal];
    }
}

#pragma mark - 解析查工资页面的热门行业列表
-(void)parserSalaryHotJobList:(NSDictionary*)dic
{
    if([dic isKindOfClass:[NSArray class]]){//看前景热门专业
        for (NSString *major in (NSArray *)dic) {
            HotJob_DataModel * modal = [[HotJob_DataModel alloc] init];
            modal.jobName = major;
            [dataArr_ addObject:modal];
        }
        return;
    }
    
    NSArray *arr = [dic objectForKey:@"data"];
    for ( NSDictionary *subDic in arr )
    {
        HotJob_DataModel * modal = [[HotJob_DataModel alloc] init];
        modal.jobName = [subDic objectForKey:@"name"];
        modal.pic = [subDic objectForKey:@"pic"];
        modal.subArray = [[NSMutableArray alloc] init];
        for (NSString  * str  in [subDic objectForKey:@"list"]) {
            HotJob_DataModel * subModal = [[HotJob_DataModel alloc] init];
            subModal.jobName = str;
            [modal.subArray addObject:subModal];
        }
        [dataArr_ addObject:modal];
    }
}

-(void)getMoreHoIndustryListDictionary:(id)dic
{
    for (NSDictionary *subDic in (NSArray *)dic)
    {
        HotJob_DataModel * modal = [[HotJob_DataModel alloc] init];
        modal.jobId = [subDic objectForKey:@"zyid"];
        modal.jobName = [subDic objectForKey:@"zyname"];
        modal.pic = [subDic objectForKey:@"Parent"];
        [dataArr_ addObject:modal];
    }
}

#pragma mark - 解析看前景薪酬预测
- (void)parserGetSalaryForecastWithZyName:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = [dic objectForKey:@"status"];
    if ([model.status_ isEqualToString:@"OK"]) {
        NSArray *dataArray = dic[@"info"][@"predicate"];
        NSMutableArray *subdataArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dataDic in dataArray) {
            SalaryForecastModel *model = [[SalaryForecastModel alloc] init];
            model.year = dataDic[@"_year"];
            model.salaryAvg = dataDic[@"_yuex_avg"];
            model.person_cnt = dataDic[@"_person_cnt"];
            [subdataArr addObject:model];
        }
         model.exObjArr_ = subdataArr;
    }
    [dataArr_ addObject:model];
}

//分享信息给好友
-(void)parserGetShareMessage:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc]init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.exObj_ = dic[@"msg_id"];
    [dataArr_ addObject:dataModal];
}

#pragma mark 解析简历推送的状态
-(void)parserResumeApplyStatus:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc]init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.exDic_ = [dic objectForKey:@"status_info"];
    [dataArr_ addObject:dataModal];
}



-(void)parserDelegateMessage:(NSDictionary *)dic
{
    
}

#pragma mark 曝工资标题
- (void)parserExposureTitle:(NSDictionary *)dic
{
    //CompanyInfo_DataModal *companyInfoModel = [[CompanyInfo_DataModal alloc]init];
    
    [dataArr_ addObject:dic];
}

#pragma mark 保存曝工资
-(void)parserSaveExposureSalary:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc]init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}

//谁赞了我
-(void)getWhoLikeMeDictionary:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = [dic objectForKey:@"data"];
    
    for (NSDictionary *subDic in arr)
    {
        WhoLikeMeDataModal *modal = [[WhoLikeMeDataModal alloc] initWithDictionary:subDic];
        modal.pageCnt_ = pageInfo.pageCnt_;
        modal.totalCnt_ = pageInfo.totalCnt_;
        NSString *content = @"";
        if ([modal.yp_type isEqualToString:@"1"])
        {
            content = [NSString stringWithFormat:@"赞了文章“%@”",modal.infocontent];
        }
        else if ([modal.yp_type isEqualToString:@"2"])
        {
            content = [NSString stringWithFormat:@"赞了评论“%@”",modal.infocontent];
        }
        NSMutableAttributedString *contentAtt = [[Manager shareMgr] getEmojiStringWithString:content withImageSize:CGSizeMake(15,15)];
        [contentAtt addAttributes:@{
                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Light" size:12],
                                    NSForegroundColorAttributeName:UIColorFromRGB(0xAEAEAE)
                                    } 
                            range:NSMakeRange(0,contentAtt.length)];
        modal.contentAttString = contentAtt;
        [dataArr_ addObject:modal];
    }
}

#pragma mark - 解析HR或者人才信息
- (void)parserGetHrMessageWithLoginI:(NSDictionary *)dic
{
    if ([[dic objectForKey:@"status"] isEqualToString:@"OK"]) {
        Expert_DataModal *model = [[Expert_DataModal alloc] init];
        NSDictionary *dataDic = [dic objectForKey:@"info"];
        if ([dataDic[@"show_type"] isEqualToString:@"company"]) {
            model.is_Hr = YES;
        }
        if ([dataDic[@"show_type"] isEqualToString:@"resume"]) {
            model.is_Rc = YES;
        }
        NSDictionary *subDic = dataDic[@"person_info"];
        model.id_ = subDic[@"personId"];
        model.iname_ = subDic[@"person_iname"];
        model.img_ = subDic[@"person_pic"];
        model.job_ = subDic[@"person_job_now"];
        model.gznum_ = subDic[@"person_gznum"];
        model.sex_ = subDic[@"person_sex"];
        model.age_ = subDic[@"age"];
        model.companyId_ = subDic[@"company_info"][@"company_id"];
        model.company_ = subDic[@"company_info"][@"company_name"];
        [dataArr_ addObject:model];
    }
}

//谁赞了我红点消除
-(void)deleteWhoLikeMeMessage:(NSDictionary *)dic
{
    
}

-(void)parserGetArticleApply:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc]init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    [dataArr_ addObject:dataModal];
}


#pragma mark offer派列表、快聘宝、V聘会
-(void)parserGetOfferPartyList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArr = dic[@"data"];
    if ([dataArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dataDic in dataArr) {
            OfferPartyTalentsModel *model = [[OfferPartyTalentsModel alloc] init];
            model.pageCnt_ = pageInfo.pageCnt_;
            model.totalCnt_ = pageInfo.totalCnt_;
            [model setValuesForKeysWithDictionary:dataDic];
            [dataArr_ addObject:model];
        }
    }
}


#pragma mark offer派company列表
-(void)parserUserOfferPartyCompanyList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArr = dic[@"data"][@"company"];
    if ([dataArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dataDic in dataArr) {
            CompanyInfo_DataModal *model = [[CompanyInfo_DataModal alloc]init];
            @try {
                model.pageCnt_ = pageInfo.pageCnt_;
                model.totalCnt_ = pageInfo.totalCnt_;
                model.companyID_ = dataDic[@"uId"];
                model.jobId = dataDic[@"job_id"];
                model.offerPartyId = dataDic[@"jobfair_id"];
                model.logoPath_ = dataDic[@"logopath"];
                model.cname_ = dataDic[@"cname"];
                model.address_ = dataDic[@"address"];
                model.job = dataDic[@"job_name"];
                model.zpType = dataDic[@"__zptype"];
                model.jobStatus = [dataDic[@"tj_state"] integerValue];
                
                User_DataModal *userModal = [[User_DataModal alloc]init];
                userModal.salary_ = dataDic[@"salary"];
                userModal.eduName_ = dataDic[@"edus"];
                userModal.gzNum_ = dataDic[@"gznum"];
                userModal.recommendId = dataDic[@"tuijian_id"];
                userModal.deliverState = dataDic[@"toudi_state"];
                userModal.waiteNum = dataDic[@"paiduihao"];
                userModal.interviewState = dataDic[@"mianshi_state"];
                userModal.joinstate = [dataDic[@"leave_state"] integerValue];
                
                //1 通过初选  2 不通过初选  3 待确定
                userModal.resumeType = [dataDic[@"company_state"] integerValue];
                model.userModal = userModal;
                
            }
            @catch (NSException *exception) {
                
            }
            [dataArr_ addObject:model];
        }
    }
    
    NSDictionary *adviserDic = dic[@"data"][@"guwenUser"];
    if (adviserDic) {
        User_DataModal *userModel = [[User_DataModal alloc]init];
        userModel.userId_ = adviserDic[@"person_id"];
        userModel.name_ = adviserDic[@"u_name"];
        userModel.mobile_ = adviserDic[@"real_tel"];
        userModel.img_ = adviserDic[@"img"];
        userModel.followStatus_ = [adviserDic[@"follow_status"] intValue];
        [dataArr_ addObject:userModel];
    }
    
    NSDictionary *offerPartyDic = dic[@"data"][@"jobfair"];
    if (offerPartyDic) {
        OfferPartyTalentsModel *offerPartyModel = [[OfferPartyTalentsModel alloc]init];
        [offerPartyModel setValuesForKeysWithDictionary:offerPartyDic];
        [dataArr_ addObject:offerPartyModel];
    }
    
}

#pragma mark offerparty 企业列表
- (void)parserOfferPartyCompanyList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArr = dic[@"data"];
    if ([dataArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dataDic in dataArr) {
            CompanyInfo_DataModal *model = [[CompanyInfo_DataModal alloc]init];
            model.pageCnt_ = pageInfo.pageCnt_;
            model.totalCnt_ = pageInfo.totalCnt_;
            model.logoPath_ = dataDic[@"logopath"];
            model.cname_ = dataDic[@"company"];
            model.address_ = dataDic[@"company_region"];
            model.companyID_ = dataDic[@"uId"];
            [dataArr_ addObject:model];
        }
        
    }
}

#pragma mark 企业信息
- (void)parserGetCompanyInfo:(NSDictionary *)dic
{
    CompanyInfo_DataModal *companyModel = [[CompanyInfo_DataModal alloc]init];
    @try {
        companyModel.companyID_ = dic[@"id"];
        companyModel.tradeId_ = dic[@"urlId"];
        companyModel.crnd_ = dic[@"Crnd"];//简历评价用
        companyModel.companyLogo = dic[@"logopath"];
        companyModel.cname_ = dic[@"cname"];
        companyModel.startDate = dic[@"startdate"];
        companyModel.endDate = dic[@"stopdate"];
        companyModel.serviceVersion = dic[@"gjVerName"];
        companyModel.resumeCnt_ = [dic[@"receive_cnt"] integerValue];
        companyModel.adviserRecommendCnt = [dic[@"resume_recommend_cnt"] integerValue];
        companyModel.downloadRecommendCnt = [dic[@"resume_down_cnt"] integerValue];
        companyModel.tempSaveResumeCnt = [dic[@"resume_temp_cnt"] integerValue];
        companyModel.interviewCnt_ = [dic[@"mail_cnt"] integerValue];
        companyModel.questionCnt_ = [dic[@"hr_qa_cnt"] integerValue];
        companyModel.offerPartyCnt = [dic[@"offer_num"] integerValue];
        companyModel.kpbCnt = [dic[@"kpb_num"] integerValue];
        companyModel.vphCnt = [dic[@"vph_num"] integerValue];
        companyModel.resumeUnReadCnt = [dic[@"resume_notread_cnt"] integerValue];
        companyModel.resumeRecommendUnreadCnt = [dic[@"resume_recommend_unreadcnt"] integerValue];
        companyModel.offerPartyRecommendCnt = [dic[@"offer_recomment_cnt"] integerValue];
        companyModel.offerNewMessage = [dic[@"offer_new"]integerValue];
        companyModel.regionName = dic[@"regionName"];
        companyModel.pname_ = dic[@"pname"];
        companyModel.address_ = dic[@"address"];
        companyModel.phone_ = dic[@"phone"];
        companyModel.sendToMeCnt = [dic[@"send_to_me_cnt"] integerValue];
        companyModel.m_isAddZp = dic[@"m_isAddZp"];
        companyModel.m_dept_id = dic[@"m_dept_id"];
        companyModel.m_status = dic[@"m_status"];
        companyModel.m_isDown = dic[@"m_isDown"];
        companyModel.m_id = dic[@"m_id"];
        companyModel.recommand_no_read = [dic[@"recommand_no_read"] integerValue];
        companyModel.forword_no_read = [dic[@"forword_no_read"] integerValue];
    }
    @catch (NSException *exception){
        
    }
    [dataArr_ addObject:companyModel];
    
}

//#pragma mark offer 派简历分类信息列表
//- (void)parserOfferPartyPersonList:(NSDictionary *)dic
//{
//    PageInfo *pageInfo = [self parserPageInfo:dic];
//    NSArray *dataArr = dic[@"data"];
//    if ([dataArr isKindOfClass:[NSArray class]]) {
//        for (NSDictionary *dataDic in dataArr) {
//            User_DataModal *model = [[User_DataModal alloc]init];
//            @try {
//                model.pageCnt_ = pageInfo.pageCnt_;
//                model.totalCnt_ = pageInfo.totalCnt_;
//                model.userId_ = dataDic[@"person_id"];
//                model.jobfair_person_id = dataDic[@"jobfair_person_id"];
//                model.resumeId = dataDic[@"resume_id"];
//                model.recommendId = dataDic[@"tuijian_id"];
//                model.img_ = dataDic[@"pic"];
//                model.uname_ = dataDic[@"person_name"];
//                model.name_ = dataDic[@"person_name"];
//                model.regionCity_ = dataDic[@"region"];
//                model.gzNum_ = dataDic[@"gznum"];
//                model.eduName_ = dataDic[@"eduId"];
//                model.job_ = dataDic[@"job_tj"];
//                model.sendtime_ = dataDic[@"add_time"];
//                model.mobile_ = dataDic[@"shouji"];
//                model.sex_ = dataDic[@"sex"];
//                model.age_ = dataDic[@"nianling"];
//                model.filePath = dataDic[@"evaluate_filepath"];
//                model.pages = dataDic[@"pages"];
//                model.wait_mianshi = dataDic[@"wait_mianshi"];
//                model.report = dataDic[@"report"];
//                model.reportUrl = dataDic[@"reportUrl"];
//                if([dataDic[@"work_state"] isEqualToString:@"1"]){
//                    model.resumeType = ResumeOPTypeWorked;
//                }
//                else if([dataDic[@"luyong_state"] isEqualToString:@"1"]){
//                    model.resumeType = ResumeOPTypeSendOffer;
//                }
//                else if([dataDic[@"mianshi_state"] isEqualToString:@"6"]){
//                    model.resumeType = ResumeOPTypeInterviewed;
//                }
//                else if ([dataDic[@"mianshi_state"] isEqualToString:@"7"])
//                {
//                    model.resumeType = ResumeOPTypeInterviewUnqualified;
//                }
//                else if([dataDic[@"company_state"] isEqualToString:@"1"]){
//                    model.resumeType = ResumeOPTypeConfirmFit;
//                }
//                else if ([dataDic[@"company_state"] isEqualToString:@"3"])
//                {
//                    model.resumeType = ResumeOPTypeWait;
//                    model.notOperating = YES;
//                }
//                else if ([dataDic[@"company_state"] isEqualToString:@"2"])
//                {
//                    model.resumeType = ResumeOPTypeNoConfirFit;
//                }
//                else if ([dataDic[@"company_state"] isEqualToString:@"0"])
//                {
//                    model.notOperating = YES;
//                }
//
//                
//                if ([dataDic[@"read_state"] isEqualToString:@"1"]) {
//                    model.isNewmail_ = NO;
//                }else{
//                    model.isNewmail_ = YES;
//                }
//                model.joinState = dataDic[@"join_state"];//到场状态
//                model.interviewState = dataDic[@"mianshi_state"];//面试状态
//                model.recommendState = dataDic[@"tj_state"];//0未推荐；4人才投递；5顾问推荐
//                model.leaveState = dataDic[@"leave_state"];
//                model.commentContent = dataDic[@"comment_content"];
//                model.jlType = dataDic[@"fromtype"];
//                model.role_id = dataDic[@"uId"];
//                model.isDown = dataDic[@"isdown"];
//                [dataArr_ addObject:model];
//            }
//            @catch (NSException *exception) {
//                
//            }
//            
//        }
//    }
//}

- (void)parserBingdingStatusWith:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ =  dic[@"status"];
    if ([model.status_ isEqualToString:@"OK"]) {
        NSString *type = dic[@"type"];
        NSDictionary *dataDic = dic[@"info"];
        //顾问
        if ([type isEqualToString:@"1"]) {
            ConsultantHRDataModel *model = [[ConsultantHRDataModel alloc] init];
            model.salerId = dataDic[@"id"];
            model.img_ = dataDic[@"img"];
            model.iname_ = dataDic[@"u_name"];
            model.userName = dataDic[@"u_user"];
            model.userType = dataDic[@"usertype"];
            model.candownCount = dataDic[@"candown_x"];
            model.recomdCount = dataDic[@"recomcnt"];
            model.downCount = dataDic[@"downcnt"];
            model.canContact = dataDic[@"canContract"];
            model.visitcnt = dataDic[@"visitcnt"];
            model.jobfaircnt = dataDic[@"jobfairNum"];
            model.all_resume_cnt = [dataDic[@"all_resume_cnt"] isKindOfClass:[NSString class]]?dataDic[@"all_resume_cnt"]:@"";
            [dataArr_ addObject:model];
        //企业HR
        }else if ([type isEqualToString:@"2"]){
            CompanyInfo_DataModal * dataModal = [[CompanyInfo_DataModal alloc] init];
            dataModal.companyID_ = [dic objectForKey:@"company_id"];
            dataModal.synergy_id = [dic objectForKey:@"synergy_id"];
            [dataArr_ addObject:dataModal];
        }
    }
}

//顾问绑定登录
- (void)parserGunwenLoginWith:(NSDictionary *)dic
{
    NSString *status = dic[@"status"];
    if ([status isEqualToString:@"OK"]) {
        NSDictionary *dataDic = dic[@"admininfo"];
        ConsultantHRDataModel *model = [[ConsultantHRDataModel alloc] init];
        model.salerId = dataDic[@"id"];
        model.iname_ = dataDic[@"u_name"];
        model.candownCount = dataDic[@"candown_x"];
        model.recomdCount = dataDic[@"recomcnt"];
        model.downCount = dataDic[@"downcnt"];
        model.userName = dataDic[@"u_user"];
        model.userType = dataDic[@"usertype"];
        model.canContact = dataDic[@"canContract"];
        model.visitcnt = dataDic[@"visitcnt"];
        model.jobfaircnt = dataDic[@"jobfairNum"];
        model.all_resume_cnt = [dataDic[@"all_resume_cnt"] isKindOfClass:[NSString class]]?dataDic[@"all_resume_cnt"]:@"";
        [dataArr_ addObject:model];
    }else{
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.des_ = dic[@"desc"];
        [dataArr_ addObject:model];
    }
}

- (void)paserGunwenJieBang:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"result"];
    [dataArr_ addObject:model];
}

//附近职位
-(void)parserNearPosition:(NSDictionary *)dic{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *dataArray = [dic objectForKey:@"data"];
    for (NSDictionary *dataDic in dataArray){
        NearPositionDataModel *nearVO = [NearPositionDataModel new];
        nearVO.pageCnt_ = pageInfo.pageCnt_;
        nearVO.totalCnt_ = pageInfo.totalCnt_;
        [nearVO setValuesForKeysWithDictionary:dataDic];
        [dataArr_ addObject:nearVO];
    }
    
}
//解析顾问搜索简历
- (void)paserGunwenSearchResume:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDic in arr){
        ELGWSearchModel *model = [[ELGWSearchModel alloc] initWithDic:subDic];
        User_DataModal *dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.name_ = model.iname;
        dataModal.kj = model.kj;
        dataModal.job_ = model.job;
        dataModal.sex_ = model.sex;
        dataModal.mobile_ = model.shouji;
        dataModal.sendtime_ = model.update_time;
        dataModal.eduName_ = model.edus;
        dataModal.userId_ = model.id_;
        dataModal.img_ = model.pic;
//        dataModal.keyWorkStr = keyWorkString;
        dataModal.regionCity_ = model.region_name;
        dataModal.gzNum_ = model.gznum;
        dataModal.age_ = model.age;
        //dataModal.isCanContract = subDic[@"is_contract"];
        //dataModal.isDown = subDic[@"isdown"];
        //dataModal.tradeId = subDic[@"tradeid"];
        [dataArr_ addObject:dataModal];
    }
}

//解析顾问已下载简历列表
- (void)paserGuwenLoadResumeList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDic in arr) {
        User_DataModal *dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.name_ = subDic[@"iname"];
        dataModal.job_ = subDic[@"job"];
        dataModal.sex_ = subDic[@"sex"];
        dataModal.mobile_ = subDic[@"shouji"];
        dataModal.sendtime_ = subDic[@"downtime"];
        dataModal.eduName_ = subDic[@"edu"];
        dataModal.userId_ = subDic[@"id"];
        dataModal.img_ = subDic[@"pic"];
        dataModal.regionCity_ = subDic[@"city"];
        dataModal.gzNum_ = subDic[@"gznum"];
        dataModal.age_ = subDic[@"age"];
        dataModal.isCanContract = subDic[@"is_contract"];
        dataModal.isDown = @"1";
        dataModal.tradeId = subDic[@"tradeid"];
        [dataArr_ addObject:dataModal];
    }
}

//解析顾问已推荐简历列表
- (void)paserGuwenRecomResumeList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDic in arr) {
        ELGWRecommentModel *model = [[ELGWRecommentModel alloc] initWithDic:subDic];
        User_DataModal *dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.name_ = model.person_name;
        dataModal.job_ = model.job_name;
        dataModal.sex_ = model.sex;
        dataModal.sendtime_ = model.add_time;
        dataModal.userId_ = model.person_id;
        dataModal.img_ = model.pic;
        dataModal.gzNum_ = model.gznum;
        dataModal.age_ = model.age;
        dataModal.company_ = model.cname;
        dataModal.recomJob_ = model.job_name;
        dataModal.tradeId = model.job_id;
        dataModal.project_title = model.project_title;
        dataModal.mobile_ = subDic[@"shouji"];
        //dataModal.isCanContract = subDic[@"is_contract"];
        //dataModal.isDown = subDic[@"isdown"];
        //dataModal.tradeId = subDic[@"tradeid"];
        dataModal.newmail = model.read_state;
        [dataArr_ addObject:dataModal];
    }
}

//解析顾问OA打电话
- (void)paserGuwenCallPerson:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.code_ = dic[@"code"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

// 解析顾问下载简历
- (void)paserGunwenLoadResume:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

// 解析下载人才联系
- (void)paserGunwenLoadConstanct:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//解析根据意向职位搜索在招企业
- (void)paserGunwenSearchCompany:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDic in arr) {
        CompanyInfo_DataModal *dataModal = [[CompanyInfo_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.companyID_ = subDic[@"id"];   //职位ID
        dataModal.cname_ = subDic[@"cname_all"];
        if (dataModal.cname_ == nil) {
            dataModal.cname_ = subDic[@"cname"];
        }
        dataModal.job   = subDic[@"jtzw"];
        dataModal.uid = subDic[@"uid"];   //公司ID
        dataModal.seleted = NO;
        dataModal.isRecommend = subDic[@"is_recommend"];  //1 表示推荐过
        [dataArr_ addObject:dataModal];
    }
}

//获取顾问行业
- (void)paserGunwenTrade:(NSDictionary *)dic
{
    if (dic != nil)
    {
        NSDictionary *tradeDic = dic[@"tradeid"];
        NSDictionary *totalDic = dic[@"totalid"];
        
        CondictionList_DataModal *modalOne;
        if (tradeDic.count > 0) {
            for (NSString *keyStr in [tradeDic allKeys])
            {
                CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
                modal.id_ = keyStr;
                modal.str_ = tradeDic[keyStr];
                modal.isTotalTrade = NO;
                if ([keyStr isEqualToString:@"0"])
                {
                    modalOne = modal;
                }
                else
                {
                    [dataArr_ addObject:modal];
                }
            }
            [dataArr_ insertObject:modalOne atIndex:0];
        }
        
        if (totalDic.count > 0) {
            for (NSString *keyStr in [totalDic allKeys])
            {
                CondictionList_DataModal *modal = [[CondictionList_DataModal alloc] init];
                modal.id_ = keyStr;
                modal.str_ = totalDic[keyStr];
                modal.isTotalTrade = YES;
               [dataArr_ addObject:modal];
            }
        }
    }
}

//解析推荐简历
- (void)paserRecommendPerson:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"desc"];
    [dataArr_ addObject:model];
}

//一览通讯录列表
-(void)getAddressBookDictionary:(NSDictionary *)dic
{
    if ([dic[@"status"] isEqualToString:@"OK"])
    {
        PageInfo *pageInfo = [self parserPageInfo:dic];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (![dic[@"data"] isEqual:[NSNull null]]) {
            [arr addObjectsFromArray:dic[@"data"]];
        }
        NSMutableArray *arrList = [[NSMutableArray alloc] init];
        if (![dic[@"yl_list"] isEqual:[NSNull null]]) {
            [arrList addObjectsFromArray:dic[@"yl_list"]];
        }
        
        if (arr.count > 0) {
            for (NSDictionary *subDic in arr) {
                YLAddressBookModal *modal = [[YLAddressBookModal alloc] init];
                modal.pageCnt_ = pageInfo.pageCnt_;
                modal.totalCnt_ = pageInfo.totalCnt_;
                modal.status = dic[@"status"];
                modal.personId = subDic[@"personId"];
                modal.phoneNumber = subDic[@"shouji"];
                modal.follow_rel = subDic[@"follow_rel"];
                modal.name = subDic[@"iname"];
                modal.pic = subDic[@"pic"];
                modal.group_rel = subDic[@"group_rel"];
                modal.arrListPhone = arrList;
                [dataArr_ addObject:modal];
            }
        }
        else
        {
            YLAddressBookModal *modal = [[YLAddressBookModal alloc] init];
            modal.status = dic[@"status"];
            [dataArr_ addObject:modal];
        }
    }
    else
    {
        YLAddressBookModal *modal = [[YLAddressBookModal alloc] init];
        modal.status = dic[@"status"];
        [dataArr_ addObject:modal];
    }

}

//解析获取招聘顾问回访简历列表
- (void)paserGetGuwenVistList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDic in arr) {
        User_DataModal *dataModal = [[User_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.userId_ = subDic[@"person_id"];
        dataModal.name_ = subDic[@"iname"];
        dataModal.job_ = subDic[@"job"];
        dataModal.sex_ = subDic[@"sex"];
        dataModal.sendtime_ = subDic[@"idate"];
        dataModal.eduName_ = subDic[@"edu"];
        dataModal.img_ = subDic[@"pic"];
        dataModal.regionCity_ = subDic[@"city"];
        dataModal.gzNum_ = subDic[@"gznum"];
        dataModal.age_ = subDic[@"age"];
        dataModal.company_ = subDic[@"cname"];
        dataModal.recomJob_ = subDic[@"zwname"];
        dataModal.tradeId = subDic[@"tradeid"];
        dataModal.mobile_ = subDic[@"shouji"];
        dataModal.isCanContract = subDic[@"is_contract"];
        dataModal.isDown = subDic[@"isdown"];
        dataModal.tradeId = subDic[@"tradeid"];
        [dataArr_ addObject:dataModal];
    }
}

//解析获取回访列表
-(void)paserGetReplyList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.numberOfLines = 0;
        
        for (NSDictionary *subDic in arr) {
            Comment_DataModal *model = [[Comment_DataModal alloc] init];
            model.objectId_ = subDic[@"objid"];
            model.researchId = subDic[@"researchid"];
            model.userId_ = subDic[@"userid"];
            model.datetime_ = subDic[@"addtime"];
            model.content_ = subDic[@"content"];
            lable.frame = CGRectMake(0,0,ScreenWidth-30,0);
            lable.text = model.content_;
            [lable sizeToFit];
            
            model.contentHeight = lable.frame.size.height;
            model.pageCnt_ = pageInfo.pageCnt_;
            model.totalCnt_ = pageInfo.totalCnt_;
            [dataArr_ addObject:model];
        }
    }
}

//解析添加回访记录
-(void)paserAddVisit:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//点击互动话题
-(void)sendAddVoteLogs:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}
 
//解析按类型请求offer派人才列表
//-(void)paserGetPersonListByFairId:(NSDictionary *)dic
//{
//    PageInfo *pageInfo = [self parserPageInfo:dic];
//    NSArray *dataArr = dic[@"data"];
//    if ([dataArr isKindOfClass:[NSArray class]]) {
//        for (NSDictionary *dataDic in dataArr) {
//            User_DataModal *model = [[User_DataModal alloc]init];
//            @try {
//                model.pageCnt_ = pageInfo.pageCnt_;
//                model.totalCnt_ = pageInfo.totalCnt_;
//                model.userId_ = dataDic[@"person_id"];
//                model.joinState = dataDic[@"join_state"];
//                model.jobfair_person_id = dataDic[@"jobfair_person_id"];
//                model.resumeId = dataDic[@"resume_id"];
//                model.recommendId = dataDic[@"tuijian_id"]; //
//                model.img_ = dataDic[@"pic"];
//                model.uname_ = dataDic[@"person_name"];
//                model.name_ = dataDic[@"person_name"];
//                model.isCanContract = dataDic[@"is_contract"];
//                model.isDown = dataDic[@"isdown"];
//                model.regionCity_ = dataDic[@"region"]; //
//                model.gzNum_ = dataDic[@"gznum"];
//                model.eduName_ = dataDic[@"eduId"];
//                model.job_ = dataDic[@"job"];
//                model.sendtime_ = dataDic[@"add_time"];
//                model.mobile_ = dataDic[@"shouji"];
//                model.sex_ = dataDic[@"sex"];
//                model.age_ = dataDic[@"nianling"];  //
//                model.filePath = dataDic[@"evaluate_filepath"];
//                model.pages = dataDic[@"pages"];
//                model.resumeType = [dataDic[@"recom_status"] integerValue];
//                model.joinstate = [dataDic[@"join_state"] integerValue];
//                model.isNewmail_ = [[dataDic objectForKey:@"newmail"] boolValue];
//                model.tuijianName = dataDic[@"tuijian_name"];
//                if ([dataDic[@"recom_status"] integerValue ]== 8) {
//                    model.resumeType = ResumeOPTypeToInterview;//等候面试
//                }else if ([dataDic[@"recom_status"] integerValue ]== 6){
//                    model.resumeType = ResumeOPTypeInterviewed;//面试合格
//                }
//                
//                model.leaveState = dataDic[@"leave_state"];
//                if([dataDic[@"leave_state"] isEqualToString:@"1"]){
//                    model.resumeType = ResumeOPTypeLeaved;//已经离场
//                }
//                [dataArr_ addObject:model];
//            }
//            @catch (NSException *exception) {
//                
//            }
//            
//        }
//    }
//}

//offer可推荐企业列表
-(void)paserGetJobFairCompany:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *arr = dic[@"data"];
    for (NSDictionary *subDic in arr) {
        CompanyInfo_DataModal *dataModal = [[CompanyInfo_DataModal alloc] init];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.totalCnt_ = pageInfo.totalCnt_;
        dataModal.jobId = subDic[@"id"];   //职位ID
        dataModal.cname_ = subDic[@"cname_all"];
        if (dataModal.cname_ == nil) {
            dataModal.cname_ = subDic[@"cname"];
        }
        dataModal.job   = subDic[@"jtzw"];
        dataModal.uid = subDic[@"uid"];   //公司ID
        dataModal.seleted = NO;
        dataModal.isRecommend = subDic[@"is_recommend"];  //1 表示推荐过
        [dataArr_ addObject:dataModal];
    }
}

//解析人才可推荐到的企业列表
-(void)paserRecommendPersonToCompany:(NSDictionary *)dic;
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//解析offer人才数量
-(void)paserGetOfferPartyCount:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

//确认人才到场状态
-(void)paserJoinPerson:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc]init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//解析推荐详情
-(void)paserGetRecommentInfo:(NSDictionary *)dic
{
    NSArray *dataArr = dic[@"recomInfo"];
    for (NSDictionary *dataDic in dataArr) {
        User_DataModal *userModel = [[User_DataModal alloc] init];
        userModel.job_ = dataDic[@"job"];
        userModel.company_ = dataDic[@"companyname"];
        userModel.resumeType = [dataDic[@"recom_status"] integerValue];
        [dataArr_ addObject:userModel];
    }
}

//简历预览二维码
-(void)getResumeZbarDictionary:(NSDictionary *)dic
{
    User_DataModal *model = [[User_DataModal alloc] init];
    model.userId_ = dic[@"personInfo"][@"id"];
    model.name_ = dic[@"personInfo"][@"iname"];
    model.isCanContract = dic[@"personInfo"][@"is_contract"];
    model.isDown = dic[@"personInfo"][@"isdown"];
    model.mobile_ = dic[@"personInfo"][@"shouji"];
    model.tradeId = dic[@"personInfo"][@"tradeid"];
    model.job_ = dic[@"personInfo"][@"job"];
    [dataArr_ addObject:model];
}

//获取我的消息全部类型的个数
-(void)getAllMessageCountDictionary:(NSDictionary *)dic
{
    [dataArr_ addObject:dic[@"data"]];
}

//解析已确认适合/已发offer/已上岗企业列表
- (void)paserGetItemCompany:(NSDictionary *)dic
{
    NSArray *dataArray = dic[@"data"];
    PageInfo *pageInfo = [self parserPageInfo:dic];
    for (NSDictionary *dataDic in dataArray) {
        CompanyInfo_DataModal *model = [[CompanyInfo_DataModal alloc] init];
        model.uid = dataDic[@"uId"];
        model.job = dataDic[@"job"];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.totalCnt_ = pageInfo.totalCnt_;
        model.cname_ = dataDic[@"cname"];
        model.time = dataDic[@"add_time"];
        [dataArr_ addObject:model];
    }
}


//未推荐列表
-(void)paserGetUnRecomPersonList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArr = dic[@"data"];
    if ([dataArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dataDic in dataArr) {
            User_DataModal *model = [[User_DataModal alloc]init];
            @try {
                model.pageCnt_ = pageInfo.pageCnt_;
                model.totalCnt_ = pageInfo.totalCnt_;
                model.userId_ = dataDic[@"person_id"];
                model.joinState = dataDic[@"join_state"];
                model.jobfair_person_id = dataDic[@"jobfair_person_id"];
                model.resumeId = dataDic[@"resume_id"];
                model.recommendId = dataDic[@"tuijian_id"]; //
                model.img_ = dataDic[@"pic"];
                model.uname_ = dataDic[@"person_name"];
                model.name_ = dataDic[@"person_name"];
                model.regionCity_ = dataDic[@"region"]; //
                model.gzNum_ = dataDic[@"gznum"];
                model.eduName_ = dataDic[@"eduId"];
                model.isDown = dataDic[@"isdown"];
                model.isCanContract = dataDic[@"is_contract"];
                model.job_ = dataDic[@"job"];
                model.sendtime_ = dataDic[@"add_time"];
                model.mobile_ = dataDic[@"shouji"];
                model.sex_ = dataDic[@"sex"];
                model.age_ = dataDic[@"nianling"];  //
                model.filePath = dataDic[@"evaluate_filepath"];
                model.pages = dataDic[@"pages"];
                model.resumeType = [dataDic[@"recom_status"] integerValue];
                model.joinstate = [dataDic[@"join_state"] integerValue];
                model.isNewmail_ = [[dataDic objectForKey:@"newmail"] boolValue];
                //                model.isPassed_ = [dataDic[@"isPassed_"] boolValue];
                [dataArr_ addObject:model];
            }
            @catch (NSException *exception) {
                
            }
            
        }
    }
}


//解析请求提问标签
- (void)paserAskQuestTags:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

-(void)getClickDomainListDic:(NSDictionary *)dic
{
    [dataArr_ addObject:(NSArray *)dic];
}

-(void)addPersonToOfferDictionary:(NSDictionary *)dic
{
    Status_DataModal *dataModal = [[Status_DataModal alloc]init];
    dataModal.status_ = [dic objectForKey:@"status"];
    dataModal.des_ = [dic objectForKey:@"status_desc"];
    dataModal.code_ = [dic objectForKey:@"code"];
    dataModal.exObj_ = dic[@"jobfair_person_id"];
    [dataArr_ addObject:dataModal];
}

//获取最后通话时间
- (void)paserGetLastTelTime:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.exObj_ = dic[@"lasttime"];
    model.status_ = dic[@"status"];
    [dataArr_ addObject:model];
}

#pragma mark - 解析职导行家列表
- (void)parsergetJobGuideExpertList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArr = dic[@"data"];
    for (NSDictionary *dataDic in dataArr) {
        JobGuideExpertModal *dataModal = [[JobGuideExpertModal alloc] init];
        [dataModal setValuesForKeysWithDictionary:dataDic];
        dataModal.pageCnt_ = pageInfo.pageCnt_;
        dataModal.pageSize_ = pageInfo.pageSize_;
        
        [dataArr_ addObject:dataModal];
    }
}

#pragma mark - 解析职导行家信息
- (void)parserJobGuideExpertInfo:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    pageInfo.currentPage_ = [dic[@"pageparam"][@"page"] integerValue];
    
    NSDictionary *dataDic = dic[@"data"];
    
    Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
    
    if (pageInfo.currentPage_ == 0)
    {
        dataModal.id_ = [dataDic objectForKey:@"person_id"];
        dataModal.iname_ = [dataDic objectForKey:@"person_iname"];
        dataModal.zw_ = dataDic[@"person_zw"];
        dataModal.introduce_ = [dataDic objectForKey:@"person_intro"];
        dataModal.commentCnt_ = dataDic[@"_comment_cnt"];
        dataModal.star = dataDic[@"_comment_star"];
        dataModal.rel = dataDic[@"rel"];
        
        NSDictionary * expertDetail = [dataDic objectForKey:@"expert_detail"];
        dataModal.goodat_ = [expertDetail objectForKey:@"good_at"];
        if(!dataModal.goodat_||[dataModal.goodat_ isEqualToString:@""])
        {
            dataModal.goodat_ = @"暂无";
        }
        
        dataModal.answer_cnt = [dataDic objectForKey:@"answer_cnt"];
        if ([dataModal.answer_cnt isEqualToString:@""]) {
            dataModal.answer_cnt = @"0";
        }
        dataModal.agreePerson_cnt = [dataDic objectForKey:@"agree_person_cnt"];
        if ([dataModal.agreePerson_cnt isEqualToString:@""]) {
            dataModal.agreePerson_cnt = @"0";
        }
        dataModal.img_ = [dataDic objectForKey:@"_photo"];
        
        //文章
        NSArray *articleArray = [dataDic objectForKey:@"_article_list"];
        dataModal.articleListArr = [[NSMutableArray alloc] init];
        if (![articleArray isEqual:[NSNull null]]) {
            for (NSDictionary *articleDic in articleArray) {
                Article_DataModal *articleModal = [[Article_DataModal alloc] init];
                articleModal.id_ = [articleDic objectForKey:@"article_id"];
                articleModal.title_ = [articleDic objectForKey:@"title"];
                [dataModal.articleListArr addObject:articleModal];
            }
        }
        
        //评价
        @try {
            NSDictionary *commentDic = [dataDic objectForKeyedSubscript:@"_comment_list"];
            dataModal.commentList = [[Comment_DataModal alloc] init];
            dataModal.appraiser = [[Author_DataModal alloc] init];
            
            dataModal.commentList.zpcId = commentDic[@"zpc_id"];
            dataModal.commentList.zpcPersonId = commentDic[@"zpc_person_id"];
            dataModal.commentList.zpcExpertId = commentDic[@"zpc_expert_id"];
            dataModal.commentList.content_ = commentDic[@"zpc_content"];
            dataModal.commentList.zpcType = commentDic[@"zpc_type"];
            dataModal.commentList.zpcTypeId = commentDic[@"zpc_type_id"];
            dataModal.commentList.datetime_ = commentDic[@"idatetime"];
            
            dataModal.appraiser.id_ = commentDic[@"_person_detail"][@"personId"];
            dataModal.appraiser.iname_ = commentDic[@"_person_detail"][@"person_iname"];
            dataModal.appraiser.nickname_ = commentDic[@"_person_detail"][@"person_nickname"];
            dataModal.appraiser.img_ = commentDic[@"_person_detail"][@"person_pic"];
            dataModal.appraiser.zw_ = commentDic[@"_person_detail"][@"person_zw"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

        //回答列表
        NSArray *answerArray = [dataDic objectForKey:@"_answer_list"];
        dataModal.answerListArr = [[NSMutableArray alloc] init];
        if (![answerArray isEqual:[NSNull null]]) {
            for (NSDictionary *answerDic in answerArray) {
                Answer_DataModal *answerModal = [[Answer_DataModal alloc] init];
                answerModal.answerId_ = [answerDic objectForKey:@"answer_id"];
                answerModal.content_ = [answerDic objectForKey:@"answer_content"];
                answerModal.anserTime_ = [answerDic objectForKey:@"answer_idate"];
                
                answerModal.questionId_ = [[answerDic objectForKey:@"question_detail"] objectForKey:@"question_id"];
                answerModal.questionTitle_ = [[answerDic objectForKey:@"question_detail"] objectForKey:@"question_title"];
                answerModal.quizzerId_ = [[answerDic objectForKey:@"question_detail"] objectForKey:@"personId"];
                answerModal.question_replys_count = [[answerDic objectForKey:@"question_detail"] objectForKey:@"question_replys_count"];
                answerModal.quizzerName_ = [[[answerDic objectForKey:@"question_detail"] objectForKey:@"person_detail"] objectForKey:@"person_iname"];
                
                [dataModal.answerListArr addObject:answerModal];
            }
        }
        
        //约谈
        NSArray *aspDiscussArray = [dataDic objectForKey:@"_yuetan_course"];
        dataModal.aspDiscussArr = [[NSMutableArray alloc] init];
        if (![aspDiscussArray isEqual:[NSNull null]]) {
            for (NSDictionary *aspDic in aspDiscussArray) {
                ELAspectantDiscuss_Modal *aspModal = [[ELAspectantDiscuss_Modal alloc] init];
                aspModal.course_id = aspDic[@"course_id"];
                aspModal.dis_personId = aspDic[@"person_id"];
                aspModal.course_title = aspDic[@"course_title"];
                aspModal.course_info = aspDic[@"course_intro"];
                aspModal.course_price = aspDic[@"course_price"];
                aspModal.course_long = aspDic[@"course_long"];
                aspModal.course_status = aspDic[@"course_status"];
                aspModal.dataTime = aspDic[@"idatetime"];
                aspModal.personCount = aspDic[@"course_yuetan_cnt"];
                
                [dataModal.aspDiscussArr addObject:aspModal];
            }
        }
        
        //推荐职位
        NSArray *recommendZwArr = [dataDic objectForKey:@"_jobs_list"];
        dataModal.recommendZWArr = [[NSMutableArray alloc] init];
        if (![recommendZwArr isEqual:[NSNull null]]) {
            for (NSDictionary *jobDic in recommendZwArr) {
                ZWDetail_DataModal *jobModal = [[ZWDetail_DataModal alloc] init];
                jobModal.zwID_ = [jobDic objectForKey:@"zwid"];
                jobModal.companyName_ = [jobDic objectForKey:@"cname"];
                jobModal.zwName_ = [jobDic objectForKey:@"job"];
                jobModal.companyID_ = [jobDic objectForKey:@"uid"];
                jobModal.moneyCount_ = [jobDic objectForKey:@"salary"];
                jobModal.city_ = [jobDic objectForKey:@"regionid"];
                jobModal.edus_ = [jobDic objectForKey:@"edus"];
                jobModal.yearCount_ = [jobDic objectForKey:@"gznum"];
                jobModal.companyLogo_ = [jobDic objectForKey:@"copmay_logo"];
                
                [dataModal.recommendZWArr addObject:jobModal];
            }
        }
    }
    else
    {
        //回答列表
        NSArray *answerArray = [dataDic objectForKey:@"_answer_list"];
        dataModal.answerListArr = [[NSMutableArray alloc] init];
        for (NSDictionary *answerDic in answerArray) {
            Answer_DataModal *answerModal = [[Answer_DataModal alloc] init];
            answerModal.answerId_ = [answerDic objectForKey:@"answer_id"];
            answerModal.content_ = [answerDic objectForKey:@"answer_content"];
            answerModal.anserTime_ = [answerDic objectForKey:@"answer_idate"];
            
            answerModal.questionId_ = [[answerDic objectForKey:@"question_detail"] objectForKey:@"question_id"];
            answerModal.questionTitle_ = [[answerDic objectForKey:@"question_detail"] objectForKey:@"question_title"];
            answerModal.quizzerId_ = [[answerDic objectForKey:@"question_detail"] objectForKey:@"personId"];
            answerModal.question_replys_count = [[answerDic objectForKey:@"question_detail"] objectForKey:@"question_replys_count"];
            answerModal.quizzerName_ = [[[answerDic objectForKey:@"question_detail"] objectForKey:@"person_detail"] objectForKey:@"person_iname"];
            [dataModal.answerListArr addObject:answerModal];
        }
    }
    dataModal.pageCnt_ = pageInfo.pageCnt_;
    dataModal.totalCnt_ = pageInfo.totalCnt_;
    [dataArr_ addObject:dataModal];
}

//解析顾问邮箱
-(void)paserGetGuwenEmail:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    model.exObj_ = dic[@"info"];
    [dataArr_ addObject:model];
}

// 发送邮件给顾问
-(void)paserSenderResumeToGuwenEmail:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//解析问答详情回复列表
- (void)parserReplyCommentList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    pageInfo.currentPage_ = [dic[@"pageparam"][@"page"] integerValue];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = THIRTEENFONT_CONTENT;
    
    NSArray *arr = dic[@"data"];
    if ([arr isKindOfClass:[NSArray class]]){
        for (NSDictionary *dataDic in arr) {
            Comment_DataModal *dataModal = [[Comment_DataModal alloc] init];
            dataModal.id_ = dataDic[@"comment_id"];
            dataModal.content_ = dataDic[@"comment_content"];
            dataModal.datetime_ = dataDic[@"comment_idate"];
            dataModal.objectId_ = dataDic[@"relative_id"];
            dataModal.userId_ = dataDic[@"re_uid"];
            
            NSDictionary *personDic = [dataDic objectForKey:@"_person_detail"];
            dataModal.author = [[Author_DataModal alloc] init];
            dataModal.author.id_ = [personDic objectForKey:@"personId"];
            dataModal.author.iname_ = [personDic objectForKey:@"person_iname"];
            dataModal.author.img_ = [personDic objectForKey:@"person_pic"];
            
            NSDictionary *parentDic = [dataDic objectForKey:@"_parent_person_detail"];
            dataModal.parentAuthor = [[Author_DataModal alloc] init];
            dataModal.parentAuthor.id_ = [parentDic objectForKey:@"personId"];
            dataModal.parentAuthor.iname_ = [parentDic objectForKey:@"person_iname"];;
            dataModal.parentAuthor.img_ = [parentDic objectForKey:@"person_pic"];;
            dataModal.content_ = [MyCommon MyfilterHTML:dataModal.content_];
            dataModal.content_ = [MyCommon translateHTML:dataModal.content_];
            
            NSString *detail = dataModal.content_;
            NSMutableAttributedString *string = nil;
            if (dataModal.parentAuthor.iname_ && ![dataModal.parentAuthor.iname_ isEqualToString:@""]) {
                NSString *name = dataModal.parentAuthor.iname_;
                NSString *str = [NSString stringWithFormat:@"回复%@：%@",name,detail];
                string = [[NSMutableAttributedString alloc] initWithString:str];
                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, 2)];
                [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x416CA2) range:NSMakeRange(2, dataModal.parentAuthor.iname_.length + 1)];
            }else{
                string = [[NSMutableAttributedString alloc] initWithString:dataModal.content_ attributes:@{NSFontAttributeName:THIRTEENFONT_CONTENT,NSForegroundColorAttributeName:UIColorFromRGB(0x999999)}];
            }
            string = [[Manager shareMgr] getEmojiStringWithAttString:string withImageSize:CGSizeMake(18,18)];
            label.frame = CGRectMake(0,0,ScreenWidth-65,0);
            [label setAttributedText:string];
            [label sizeToFit];
            dataModal.cellHeight = 70+label.frame.size.height;
            dataModal.contentAttString = string;
            
            [dataArr_ addObject:dataModal];
        }

    }
}

//解析行家评价列表
- (void)parserExpertCommentList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    pageInfo.currentPage_ = [dic[@"pageparam"][@"page"] integerValue];
    
    NSArray *dataArr = dic[@"data"];
    for (NSDictionary *dataDic in dataArr) {
        Expert_DataModal * dataModal = [[Expert_DataModal alloc] init];
        @try {
            dataModal.commentList = [[Comment_DataModal alloc] init];
            dataModal.appraiser = [[Author_DataModal alloc] init];
            
            dataModal.commentList.zpcId = dataDic[@"zpc_id"];
            dataModal.commentList.zpcPersonId = dataDic[@"zpc_person_id"];
            dataModal.commentList.zpcExpertId = dataDic[@"zpc_expert_id"];
            dataModal.commentList.content_ = dataDic[@"zpc_content"];
            dataModal.commentList.zpcType = dataDic[@"zpc_type"];
            dataModal.commentList.zpcTypeId = dataDic[@"zpc_type_id"];
            dataModal.commentList.datetime_ = dataDic[@"idatetime"];
            
            dataModal.appraiser.id_ = dataDic[@"_person_detail"][@"personId"];
            dataModal.appraiser.iname_ = dataDic[@"_person_detail"][@"person_iname"];
            dataModal.appraiser.nickname_ = dataDic[@"_person_detail"][@"person_nickname"];
            dataModal.appraiser.img_ = dataDic[@"_person_detail"][@"person_pic"];
            dataModal.appraiser.zw_ = dataDic[@"_person_detail"][@"person_zw"];
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        [dataArr_ addObject:dataModal];
    }
}

//解析职导对行家评价
- (void)parserAddExpertComment:(NSDictionary *)dic
{
    Status_DataModal *model = [[Status_DataModal alloc] init];
    model.status_ = dic[@"status"];
    model.code_ = dic[@"code"];
    model.des_ = dic[@"status_desc"];
    [dataArr_ addObject:model];
}

//解析更多应用列表
- (void)parserApplicationList:(NSDictionary *)dic
{
    NSArray *dicArr = (NSArray *)dic;
    for (NSDictionary *dataDic in dicArr) {
        AD_dataModal *dataModal = [[AD_dataModal alloc] init];
        @try {
            dataModal.title_ = dataDic[@"app_title"];
            dataModal.pic_ = dataDic[@"app_logo"];
            dataModal.url_ = dataDic[@"app_url"];
            dataModal.type_ = dataDic[@"app_type"];
            dataModal.OANewsCount = dataDic[@"noread_cnt"];
        }
        @catch (NSException *exception) {
            dataModal.pic_ = @"";
            dataModal.url_ = @"";
        }
        @finally {
            
        }
        [dataArr_ addObject:dataModal];
    }
}

////解析行家约谈订单
//- (void)parserExpertOrder:(NSDictionary *)dic
//{
//    [dataArr_ addObject:dic];
//}

//解析余额支付
- (void)parserPayWithyuer:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

- (void)parserAspectantDisList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *dataArray = dic[@"data"];
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dataDic in dataArray) {
            ELAspectantDiscuss_Modal *AspDiscussModal = [[ELAspectantDiscuss_Modal alloc] init];
            
            AspDiscussModal.pageCnt_ = pageInfo.pageCnt_;
            AspDiscussModal.pageSize_ = pageInfo.pageSize_;
            
            AspDiscussModal.recordId = dataDic[@"record_id"];
            AspDiscussModal.YTZ_id = dataDic[@"person_id"];
            AspDiscussModal.BYTZ_Id = dataDic[@"yuetan_person_id"];
            AspDiscussModal.status = dataDic[@"yuetan_status"];
            AspDiscussModal.dataTime = dataDic[@"idatetime"];
            AspDiscussModal.user_confirm = dataDic[@"confirm_person"];
            AspDiscussModal.isComment = dataDic[@"_is_comment"];
            AspDiscussModal.yuetan_status_desc = dataDic[@"_yuetan_status_desc"];
            AspDiscussModal.payStatus = dataDic[@"yuetan_pay_status"];
            
            if ([AspDiscussModal.user_confirm isEqualToString:@""]) {
                AspDiscussModal.user_confirm = @"0";
            }
            AspDiscussModal.dis_confirm = dataDic[@"confirm_yuetan_person"];
            if ([AspDiscussModal.dis_confirm isEqualToString:@""]) {
                AspDiscussModal.dis_confirm = @"0";
            }
            
            if ([[Manager getUserInfo].userId_ isEqualToString:AspDiscussModal.YTZ_id]) {
                AspDiscussModal.user_personId = [Manager getUserInfo].userId_;
                AspDiscussModal.user_name = [Manager getUserInfo].name_;
                AspDiscussModal.user_nickName = [Manager getUserInfo].nickname_;
                AspDiscussModal.user_pic = dataDic[@"_person_detail"][@"person_pic"];
                AspDiscussModal.user_zw = dataDic[@"_person_detail"][@"person_zw"];
                
                
                AspDiscussModal.dis_personId = dataDic[@"_yuetan_person_detail"][@"personId"];
                AspDiscussModal.dis_personName = dataDic[@"_yuetan_person_detail"][@"person_iname"];
                AspDiscussModal.dis_nickname = dataDic[@"_yuetan_person_detail"][@"person_nickname"];
                AspDiscussModal.dis_pic = dataDic[@"_yuetan_person_detail"][@"person_pic"];
                AspDiscussModal.dis_zw = dataDic[@"_yuetan_person_detail"][@"person_zw"];
                AspDiscussModal.isInCome = dataDic[@"is_income"];
            }
            else
            {
                AspDiscussModal.user_personId = dataDic[@"_person_detail"][@"personId"];
                AspDiscussModal.user_name = dataDic[@"_person_detail"][@"person_iname"];
                AspDiscussModal.user_nickName = dataDic[@"_person_detail"][@"person_nickname"];
                AspDiscussModal.user_pic = dataDic[@"_person_detail"][@"person_pic"];
                AspDiscussModal.user_zw = dataDic[@"_person_detail"][@"person_zw"];
                AspDiscussModal.isInCome = dataDic[@"is_income"];
                
                
                AspDiscussModal.dis_personId = [Manager getUserInfo].userId_;
                AspDiscussModal.dis_personName = [Manager getUserInfo].name_;
                AspDiscussModal.dis_nickname = [Manager getUserInfo].nickname_;
                AspDiscussModal.dis_pic = dataDic[@"_yuetan_person_detail"][@"person_pic"];
                AspDiscussModal.dis_zw = dataDic[@"_yuetan_person_detail"][@"person_zw"];
            }
            
            AspDiscussModal.course_id = dataDic[@"course_info"][@"course_id"];
            AspDiscussModal.course_title = dataDic[@"course_info"][@"course_title"];
            AspDiscussModal.course_price = dataDic[@"course_info"][@"course_price"];

            @try {
                AspDiscussModal.refund_id = dataDic[@"_refund_info"][@"refund_id"];
                AspDiscussModal.ordco_id = dataDic[@"_refund_info"][@"ordco_id"];
                AspDiscussModal.refund_reason = dataDic[@"_refund_info"][@"refund_reason"];
                AspDiscussModal.refuse_reason = dataDic[@"_refund_info"][@"refuse_reason"];
                AspDiscussModal.refund_status = dataDic[@"_refund_info"][@"status"];
                AspDiscussModal.refund_idatetime = dataDic[@"_refund_info"][@"idatetime"];
                AspDiscussModal.refuse_idatetime = dataDic[@"_refund_info"][@"refuse_idatetime"];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            [dataArr_ addObject:AspDiscussModal];
        }
    }
}


-(void)parserActivityList:(NSDictionary *)dic widthType:(NSInteger)type
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    for (NSDictionary *dicOne in dic[@"data"])
    {
        ELActivityModel *modal = [[ELActivityModel alloc] initWithDictionary:dicOne];
        modal.pageCnt_ = pageInfo.pageCnt_;
        modal.pageSize_ = pageInfo.pageSize_;
        if(modal.regionid.length > 0)
        {
            modal.regionid = [CondictionListCtl getRegionId:modal.regionid];
        }
        if (type == Request_ActivityJoinList)
        {
            modal.cnt = dicOne[@"_enroll_info"][@"cnt"];
            modal.joinTime = dicOne[@"_enroll_info"][@"idatetime"];
        }
        [dataArr_ addObject:modal];
    }
}

-(void)parserActivityPeopleListDictionary:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    for (NSDictionary *dicOne in dic[@"data"])
    {
        ELActivityPeopleFrameModel *modal = [[ELActivityPeopleFrameModel alloc] init];
        modal.pageCnt_ = pageInfo.pageCnt_;
        modal.pageSize_ = pageInfo.pageSize_;
        ELActivityPeopleModel *dataModal = [[ELActivityPeopleModel alloc] initWithDictionary:dicOne];
        modal.peopleModel = dataModal;
        [dataArr_ addObject:modal];
    }
}

//解析约谈选择课程列表
- (void)parserInterviewCourseList:(NSDictionary *)dic
{
    for (NSDictionary *dicOne in dic[@"data"])
    {
        ELAspectantDiscuss_Modal *modal = [[ELAspectantDiscuss_Modal alloc] init];
        modal.course_id = dicOne[@"course_id"];
        modal.course_title = dicOne[@"course_title"];
        modal.course_price = dicOne[@"course_price"];
        [dataArr_ addObject:modal];
    }
}

//在招职位列表
-(void)parserGetZpListWithCompanyId:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArray = dic[@"data"];
    for (NSDictionary *dic in dataArray) {
        ZWDetail_DataModal *model = [[ZWDetail_DataModal alloc] init];
        model.zwName_ = dic[@"jtzw"];
        model.count_ = dic[@"ypNumber"];   //应聘人数
        model.salary_ = dic[@"salary"];
        model.regionName_ = dic[@"regionid"];
        model.companyID_ = dic[@"uid"];
        model.zwID_ = dic[@"id"];
        model.updateTime_ = dic[@"updatetime"];
        model.zprenshu = dic[@"zprenshu"];
        model.companyName_ = dic[@"cname"];
        model.pageCnt_ = pageInfo.pageCnt_;
        model.pageSize_ = pageInfo.pageSize_;
        [dataArr_ addObject:model];
    }
}

//解析获取发布网站信息
-(void)parserGetZWFBInfoWithCompanyId:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

//解析发布戒指
- (void)parserAddPositionWithCompanyId:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

//解析文章打赏
- (void)parserArticleRewardImg:(NSDictionary *)dic
{
    [dataArr_ addObject:dic];
}

#pragma mark - 我的打赏列表
- (void)parserMyRewardList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in dataArray) {
            Reward_DataModal *dataModal = [[Reward_DataModal alloc] init];
            
            dataModal.ordcoId = dic[@"dashang_ordco_id"];
            dataModal.targetPersonId = dic[@"target_person_id"];
            dataModal.money = dic[@"money"];
            dataModal.serviceId = dic[@"service_detail_id"];
            dataModal.buyNums = dic[@"service_buynums"];
            dataModal.idatetime = dic[@"idatetime"];
            dataModal.serviceTitle = dic[@"_service_title"];
            dataModal.serviceUnit = dic[@"_service_unit"];
            
            dataModal.personId = dic[@"_person_detail"][@"personId"];
            dataModal.name_ = dic[@"_person_detail"][@"person_iname"];
            dataModal.nickname_ = dic[@"_person_detail"][@"person_nickname"];
            dataModal.img_ = dic[@"_person_detail"][@"person_pic"];
            dataModal.job_ = dic[@"_person_detail"][@"person_zw"];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.pageSize_ = pageInfo.pageSize_;
            
            [dataArr_ addObject:dataModal];
        }
    }
}

-(void)getMyGroupArticleListDic:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArray = [dic objectForKey:@"data"];
    if (![dataArray isKindOfClass:[NSNull class]])
    {
        for (NSDictionary *dic in dataArray)
        {
            NSString *type = dic[@"info_type"];
            TodayFocusFrame_DataModal *cellFrame = [[TodayFocusFrame_DataModal alloc]init];
            cellFrame.pageCnt_ = pageInfo.pageCnt_;
            cellFrame.pageSize_ = pageInfo.pageSize_;
            cellFrame.articleType_ = Article_Group;
            if ([type isEqualToString:@"join_person"]){
                ELGroupListTwoModel *dataModal = [[ELGroupListTwoModel alloc]initWithDictionary:dic];
                cellFrame.joinGroupPeopleModel = dataModal;
            }else if([type isEqualToString:@"group_article"]){
                ELSameTrameArticleModel *dataModal = [[ELSameTrameArticleModel alloc] initWithDictionary:dic];
                cellFrame.sameTradeArticleModel = dataModal;
            }
            [dataArr_ addObject:cellFrame];
        }
    }
}

#pragma mark - 行家常用地址
- (void)parserExpertRegionList:(id)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArray = dic;
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *dic in dataArray) {
            ELAspectantDiscuss_Modal *dataModal = [[ELAspectantDiscuss_Modal alloc] init];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.pageSize_ = pageInfo.pageSize_;
                
            dataModal.region = dic[@"ydr_region"];
            dataModal.ydrId = dic[@"ydr_id"];
            dataModal.recordId = dic[@"ydr_regionid"];
            dataModal.personId = dic[@"person_id"];
            [dataArr_ addObject:dataModal];
        }
    }
}

#pragma mark - 解析更多话题
-(void)parserMoreArticleList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArray = dic[@"data"];
    
    if (![dataArray isKindOfClass:[NSNull class]]) {
        for (NSDictionary *subDic in dataArray) {
            ELTodaySearchModal *dataModal = [[ELTodaySearchModal alloc] initArticleModalWithDictionary:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.pageSize_ = pageInfo.pageSize_;
            [dataArr_ addObject:dataModal];
        }
    }
}

#pragma mark - 综合搜索之更多社群搜索
-(void)parserMoreGoupListDictionary:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    NSArray *dataArray = dic[@"data"];
    
    if ([dataArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *subDic in dataArray) {
            ELTodaySearchModal *dataModal = [[ELTodaySearchModal alloc] initGroupModalWithDictionary:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.pageSize_ = pageInfo.pageSize_;
            [dataArr_ addObject:dataModal];
        }
    }
}

//解析评论列表
-(void) parserGroupChatList:(NSDictionary *)dic
{
    PageInfo *pageInfo = [self parserPageInfo:dic];
    
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for ( NSDictionary *subDic in arr ) {
            ELGroupCommentModel *dataModal = [[ELGroupCommentModel alloc] initWithDictionaryOne:subDic];
            dataModal.pageCnt_ = pageInfo.pageCnt_;
            dataModal.totalCnt_ = pageInfo.totalCnt_;
            [dataModal changeCellHeight];
            dataModal.isLiked = [Manager getIsLikeStatus:dataModal.id_];
            [dataArr_ addObject:dataModal];
        }
    }
}

@end
@implementation ExJSONParser
@end
