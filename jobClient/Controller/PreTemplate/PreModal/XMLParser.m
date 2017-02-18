//
//  XMLParser.m
//  HelpMe
//
//  Created by wang yong on 11/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"
#import "PreBaseUIViewController.h"
#import "PreRequestCon.h"
#import "DataManger.h"
#import "Op_DataModal.h"
#import "Event_DataModal.h"
#import "Login_DataModal.h"
#import "VersionInfo_DataModal.h"
#import "ProfessionPower_DataModal.h"
#import "ZWDetail_DataModal.h"
#import "CompanyInfo_DataModal.h"
#import "MapSearchResult_DataModal.h"
#import "CompanyDescript_DataModal.h"
#import "ProgramQuestion_DataModal.h"
#import "TestResult_DataModal.h"
#import "TestProgram_DataModal.h"
#import "RiceMoney_DataModal.h"
#import "Salary_DataModal.h"
#import "CondictionList_DataModal.h"
#import "TalentMarket_DataModal.h"
#import "Event_Detail_DataModal.h"
#import "MyComment_DataModal.h"
#import "ApplyDetail_DataModal.h"
#import "ResumeNotifiDetail_DataModal.h"
#import "ResumeNotifi_DataModal.h"
#import "Subscribe_DataModal.h"
#import "CountInfo_DataModal.h"
#import "EduResume_DataModal.h"
#import "WorkResume_DataModal.h"
#import "CerResume_DataModal.h"
#import "AwardResume_DataModal.h"
#import "LeaderResume_DataModal.h"
#import "ProjectResume_DataModal.h"
#import "ResumePath_DataModal.h"
#import "PersonDetailInfo_DataModal.h"
#import "Logo_DataModal.h"
#import "School_DataModal.h"
#import "SchoolInfo_DataModal.h"
#import "MsgDetail_DataModal.h"
#import "MyCntInfo_DataModal.h"
#import "GDataXMLNode.h"

@implementation XMLParser

@synthesize soapMsg_,bFromDB_,delegate_;

-(id) init
{
	//[self initData];
	
	return self;
}

//init data
-(void) initData
{
	if( !dataArr_ ){
		dataArr_ = [[NSMutableArray alloc] init];
	}
	[dataArr_ removeAllObjects];
	
	code_ = Fail;
}

//release data
-(void) releaseData
{
	[dataArr_ removeAllObjects];
	[dataArr_ release];
	dataArr_ = nil;
}

-(void) dealloc
{
	[self releaseData];
	
	//[doc_ release];
    
    [soapMsg_ release];
	
	[super dealloc];
}

//开始解数据，总接口
-(void) parserXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
	[self initData];
	
	NSError *err = nil;
    
    if( parserType != Image_XMLParser ){
        if( xmlData )
        {
            doc_ = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&err];
        }else if( strData )
        {
            doc_ = [[GDataXMLDocument alloc] initWithXMLString:strData options:0 error:&err];
        }
    }
    
	@try {
        if( err ){
            code_ = Fail;
        }
        else
        {
            code_ = Success;
            
            switch ( parserType ) {
                case Null_XMLParser:
                    
                    break;
                    //加载图片
                case Image_XMLParser:
                {
                    NSData *newData = [NSData dataWithData:xmlData];
                    [dataArr_ addObject:newData];
                }
                    break;
                    //Op初始化
                case InitOp_XMLParser:
                    [self parserInitOpXML:xmlData strData:strData parserType:parserType];
                    break;
                    //登录
                case DoLogin_XMLParser:
                    [self parserDoLoginXML:xmlData strData:strData parserType:parserType];
                    break;
                    //找回密码
                case FindSercet_XMLParser:
                    [self parserFindPwdXML:xmlData strData:strData parserType:parserType];
                    break;
                    //注册
                case Regest_XMLParser:
                    [self parserRegestXML:xmlData strData:strData parserType:parserType];
                    break;
                    //意见反馈
                case AddAdvice_XMLParser:
                    [self parserAddAdviceXML:xmlData strData:strData parserType:parserType];
                    break;
                    //推送设置
                case SetSubscribe_XMLParser:
                    [self parserSetSubscribeXML:xmlData strData:strData parserType:parserType];
                    break;
                    //更新使用次数
                case UpdateUseCount_XMLParser:
                    [self parserGetVersionXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取版本
                case GetVersion_XMLParser:
                    [self parserGetVersionXML:xmlData strData:strData parserType:parserType];
                    break;
                    //解析宣讲会
                case GetXjh_XMLParser:
                    [self parserXjhXML:xmlData strData:strData parserType:parserType];
                    break;
                    //解析招聘会
                case GetZph_XMLParser:
                    [self parserZphXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //职业的力量
                case ProfessionPower_XMLParser:
                    [self parserProfessionPowerXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职业的力量详情
                case ProfessionPower_Detail_XMLParser:
                    [self parserProfessionPowerDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职业的力量上一篇
                case PreProfessionPower_Detail_XMLParser:
                    [self parserGetPreProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职业的力量下一篇
                case NextProfessionPower_Detail_XMLParser:
                    [self parserGetNextProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职场风雨/...(列表与详情)
                case GetProfessInfo_ZhiDao_XMLParser:
                    [self parserGetProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                case GetProfessInfo_FengYu_XMLParser:
                    [self parserGetProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                case GetProfessInfo_JinRan_XMLParser:
                    [self parserGetProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                case GetProfessInfo_ZhiZuo_XMLParser:
                    [self parserGetProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                case GetProfessInfo_ZhiNan_XMLParser:
                    [self parserGetProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                case GetProfessDetailInfo_XMLParser:
                    [self parserGetProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职场风雨/...上一篇
                case GetPreProfessDetailInfo_XMLParser:
                    [self parserGetPreProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职场风雨/...下一篇
                case GetNextProfessDetailInfo_XMLParser:
                    [self parserGetNextProfessInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    //文章列表
                case GetArticleList_XMLParser:
                    [self parserArticleListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //文章详情
                case GetArticleDetail_XMLParser:
                    [self parserArticleDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //职位详情
                case SearchZW_Detail_XMLParser:
                    [self parserZWDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职位申请
                case ZW_Apply_XMLParser:
                    [self parserApplyZWXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职位收藏
                case ZW_Fav_XMLParser:
                    [self parserFavZWXML:xmlData strData:strData parserType:parserType];
                    break;
                    //企业详情
                case GetCompanyDetail_XMLParser:
                    [self parserCompanyDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职位搜索
                case SearchResult_XMLParser:
                    [self parserSearchResultXML:xmlData strData:strData parserType:parserType];
                    break;
                    //身边招聘企业
                case GetMapCompany_XMLParser:
                    [self parserMapSearchResultXML:xmlData strData:strData parserType:parserType];
                    break;
                    //身边招聘的职位
                case GetMapCompanhyZW_XMLParser:
                    [self parserGetMapCompanyZWXML:xmlData strData:strData parserType:parserType];
                    break;
                    //企业其它职位
                case CompanyOther_ZW_XMLParser:
                    [self parserCompanyOtherZWXML:xmlData strData:strData parserType:parserType];
                    break;
                    //企业描述
                case GetCompanyDes_XMLParser:
                    [self parserCompanyDesXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //获取测试题
                case ProgramQuestion_XMLParser:
                    [self parserTestQuestionXML:xmlData strData:strData parserType:parserType];
                    break;
                    //测试答案
                case TestResult_XMLParser:
                    [self parserTestResultXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职业测试
                case TestProgram_XMLParser:
                    [self parserTestProgramXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //换大米
                case RiceMoney_XMLParser:
                    [self parserRiceMoneyXML:xmlData strData:strData parserType:parserType];
                    break;
                    //薪酬查询
                case GetSalary_XMLParser:
                    [self parserGetSalaryXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //学校列表
                case GetSchoolList_XMLParser:
                    [self parserSchoolListXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //人才市场
                case GetTalentMarket_XMLParser:
                    [self parserTalentMarketXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //新增订阅
                case AddSubscribe_XMLParser:
                    [self parserAddSubscribeXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取宣讲会详情
                case GetXjhDetail_XMLParser:
                    [self parserXjhDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //参与
                case AddParticipate_XMLParser:
                    [self parserAddParticipateXML:xmlData strData:strData parserType:parserType];
                    break;
                    //刷新参与
                case RefreshAddCnt_XMLParser:
                    [self parserRefreshAddParticipateXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取招聘会详情
                case GetZphDetail_XMLParser:
                    [self parserZphDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //新增评论
                case AddBBS_XMLParser:
                    [self parserAddMyCommentXML:xmlData strData:strData parserType:parserType];
                    break;
                    //新增企评
                case AddCompanyReply_XMLParser:
                    [self parserAddCompanyReplyXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取评论列表
                case GetMyCommmentList_XMLParser:
                    [self parserGetMyCommentListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //添加支持
                case AddAgree_XMLParser:
                    [self parserAddAgreeXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取企业评论回复
                case GetCompanyReplyList_XMLParser:
                    [self parserCompanyReplyListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //增加企业评论
                case AddCompanyComment_XMLParser:
                    [self parserAddCompanyCommentXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取企业评论列表
                case GetCompanyCommentList_XMLParser:
                    [self parserCompanyCommentListXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //设置订阅已阅标识
                case SetSubscribeReadFlag_XMLParser:
                    [self parserSetSubscribeReadFlagXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //重设密码
                case ReSetSercet_XMLParser:
                    [self parserResetPwdXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取求职状态
                case GetResumeStatus_XMLParser:
                    [self parserGetResumeStatusXML:xmlData strData:strData parserType:parserType];
                    break;
                    //更新求职状态
                case UpdateResumeStatus_XMLParser:
                    [self parserUpdateResumeStatusXML:xmlData strData:strData parserType:parserType];
                    break;
                    //获取保密设置
                case GetResumeSercet_XMLParser:
                    [self parserGetResumeSercetXML:xmlData strData:strData parserType:parserType];
                    break;
                    //更新保密设置
                case UpdateResumeSercet_XMLParser:
                    [self parserUpdateResumeSercetStatusXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //职位申请详情
                case ApplyCountDetail_XMLParser:
                    [self parserApplyDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职位收藏详情
                case FavCountDetail_XMLParser:
                    [self parserFavDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //删除收藏职位
                case DelFavZW_XMLParser:
                    [self parserDelFavZWXML:xmlData strData:strData parserType:parserType];
                    break;
                    //面试通知详情
                case ResumeNotifiDetail_XMLParser:
                    [self parserResumeNotifiDetailXML:xmlData strData:strData parserType:parserType];
                    break;
                    //更新面试通知状态
                case UpdateNotifiStatus_XMLParser:
                    [self parserUpdateResumeNotifiStatusXML:xmlData strData:strData parserType:parserType];
                    break;
                    //面试通知列表
                case ResumeNotifiCtl_XMLParser:
                    [self parserResumeNotifiXML:xmlData strData:strData parserType:parserType];
                    break;
                    //订阅列表
                case GetSubscribe_XMLParser:
                    [self parserSubscribeListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //删除某订阅
                case DelSubscribe_XMLParser:
                    [self parserDelSubscribeXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职位申请数
                case ApplyCount_XMLParser:
                    [self parserApplyCountXML:xmlData strData:strData parserType:parserType];
                    break;
                    //职位收藏数
                case FavCount_XMLParser:
                    [self parserFavCountXML:xmlData strData:strData parserType:parserType];
                    break;
                    //面试通知数
                case ResumeNotifiCount_XMLParser:
                    [self parserResumeNotifiCountXML:xmlData strData:strData parserType:parserType];
                    break;
                    //简历被阅数
                case CompanyLookedCount_XMLParser:
                    [self parserBeCompanyLookedCountXML:xmlData strData:strData parserType:parserType];
                    break;
                    //刷新简历
                case RefreshResume_XMLParser:
                    [self parserRefreshResumeXML:xmlData strData:strData parserType:parserType];
                    break;
                    //上传个人图像
                case Update_PersonImage_XMLParser:
                    [self parserUpdatePersonImageXML:xmlData strData:strData parserType:parserType];
                    break;
                    //删除个人图像
                case Delete_PersonImage_XMLParser:
                    [self parserDeletePersonImageXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //更新基本资料
                case UpdateResume_BaseInfo_XMLParser:
                    [self parserUpdateContactXML:xmlData strData:strData parserType:parserType];
                    break;
                    //更新求职意向
                case UpdateResume_WantJob_XMLParser:
                    [self parserUpdateContactXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_OldEdu_XMLParser:
                    [self parserUpdateContactXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_OldWorks_XMLParser:
                    [self parserUpdateContactXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //工作技能
                case UpdateResume_SkillInfo_XMLParser:
                    [self parserUpdateContactXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //教育背景
                case GetResume_Edu_XMLParser:
                    [self parserGetResumeEduXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_Edu_XMLParser:
                    [self parserUpdateResumeEduXML:xmlData strData:strData parserType:parserType];
                    break;
                case AddResume_Edu_XMLParser:
                    [self parserAddResumeEduXML:xmlData strData:strData parserType:parserType];
                    break;
                case DelResume_Edu_XMLParser:
                    [self parserDelResumeEduXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //工作经历
                case GetResume_Work_XMLParser:
                    [self parserGetResumeWorkXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_Work_XMLParser:
                    [self parserUpdateResumeWorkXML:xmlData strData:strData parserType:parserType];
                    break;
                case AddResume_Work_XMLParser:
                    [self parserAddResumeWorkXML:xmlData strData:strData parserType:parserType];
                    break;
                case DelResume_Work_XMLParser:
                    [self parserDelResumeWorkXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //个人证书
                case GetResume_PersonCer_XMLParser:
                    [self parserGetResumeCerXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_PersonCer_XMLParser:
                    [self parserAddResumeCerXML:xmlData strData:strData parserType:parserType];
                    break;
                case AddResume_PersonCer_XMLParser:
                    [self parserAddAdviceXML:xmlData strData:strData parserType:parserType];
                    break;
                case DelResume_PersonCer_XMLParser:
                    [self parserDelResumeCerXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //个人奖项
                case GetResume_PersonAward_XMLParser:
                    [self parserGetResumeAwardXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_PersonAward_XMLParser:
                    [self parserUpdateResumeAwardXML:xmlData strData:strData parserType:parserType];
                    break;
                case AddResume_PersonAward_XMLParser:
                    [self parserAddResumeAwardXML:xmlData strData:strData parserType:parserType];
                    break;
                case DelResume_PersonAward_XMLParser:
                    [self parserDelResumeAwardXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //学生干部经历
                case GetResume_StudentLeader_XMLParser:
                    [self parserGetStudentLeaderXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_StudentLeader_XMLParser:
                    [self parserUpdateStudentLeaderXML:xmlData strData:strData parserType:parserType];
                    break;
                case AddResume_StudentLeader_XMLParser:
                    [self parserAddStudentLeaderXML:xmlData strData:strData parserType:parserType];
                    break;
                case DelResume_StudentLeader_XMLParser:
                    [self parserDelStudentLeaderXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //项目活动经历
                case GetResume_Project_XMLParser:
                    [self parserGetProjectXML:xmlData strData:strData parserType:parserType];
                    break;
                case UpdateResume_Project_XMLParser:
                    [self parserUpdateProjectXML:xmlData strData:strData parserType:parserType];
                    break;
                case AddResume_Project_XMLParser:
                    [self parserAddProjectXML:xmlData strData:strData parserType:parserType];
                    break;
                case DelResume_Project_XMLParser:
                    [self parserDelProjectXML:xmlData strData:strData parserType:parserType];
                    break;

                    //获取简历路径
                case GetResumePath_XMLParser:
                    [self parserResumePathXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //加载个人信息
                case PersonInfo_XMLParser:
                    [self parserGetPersonInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    
                    //logo列表
                case App_LogoList_XMLParser:
                    [self parserLogoListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //附近的学校列表
                case Near_SchoolList_XMLParser:
                    [self parserNearSchoolListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //关注的学校列表
                case Attention_SchoolList_XMLParser:
                    [self parserAttentionSchoolListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //取消关注学校
                case CancelAttention_School_XMLParser:
                    [self parserCancelAttentionSchoolXML:xmlData strData:strData parserType:parserType];
                    break;
                    //添加关注学校
                case AddAttention_School_XMLParser:
                    [self parserAddAttentionSchoolXML:xmlData strData:strData parserType:parserType];
                    break;
                    //我的学校相关信息
                case GetMySchoolInfoList_XMLParser:
                    [self parserSchoolInfoListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //我的消息
                case MyMsgList_XMLParser:
                    [self parserMyMsgListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //发布者的消息列表
                case PublisherMsgList_XMLParser:
                    [self parserPublisherMsgListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //消息内容
                case MsgContent_XMLParser:
                    [self parserMsgContentXML:xmlData strData:strData parserType:parserType];
                    break;
                    //某学校的相关信息
                case SchoolInfo_XMLParser:
                    [self parserSchoolInfoListXML:xmlData strData:strData parserType:parserType];
                    break;
                    //我的相关数量信息
                case MyCntInfo_XMLParser:
                    [self parserMyCntInfoXML:xmlData strData:strData parserType:parserType];
                    break;
                    //设置我的学校
                case SetMySchool_XMLParser:
                    //与parserSetSubscribeXML相同
                    [self parserSetSubscribeXML:xmlData strData:strData parserType:parserType];
                    break;
                default:
                    code_ = Fail;
                    break;
            }
        }
	}
	@catch (NSException * e) {
		//release data
		[self releaseData];
		
		code_ = Fail;
	}
	@finally {
        //need save to Local DB
        if( !bFromDB_ && [PreRequestCon checkLocalDBSave:parserType] && code_ < Fail && [dataArr_ count] > 0  ){
            BOOL bStatusOK = YES;
            @try {
                //获取上一篇与下一篇的数据时需要特殊处理
                id dataModal = [dataArr_ objectAtIndex:0];
                if( [dataModal isKindOfClass:[ProfessionPower_DataModal class]] )
                {
                    bStatusOK = NO;
                    ProfessionPower_DataModal *tempDataModal = dataModal;
                    
                    //加载成功且者有内容时才存放本地数据库
                    if( tempDataModal.newsContent_ && ![tempDataModal.newsContent_ isEqualToString:@""] )
                    {
                        bStatusOK = YES;
                    }

                }
            }
            @catch (NSException *exception) {
                bStatusOK = YES;
            }
            @finally {
                
            }

            NSString *results = nil;
            
            if( bStatusOK ){
                results = [[[NSString alloc]
                            initWithBytes:[xmlData bytes]
                            length:[xmlData length]
                            encoding:NSUTF8StringEncoding] autorelease];
            }
            
            if( results )
            {
                //先将以前的删除
                [myDB deleteSQL:[NSString stringWithFormat:@"url='%@'",self.soapMsg_] tableName:DB_TableName_CacheData];
                
                //插入新数据
                NSString *dateStr = [PreCommon getCurrentDateTime];
                NSString *columnsName = [[[NSString alloc] initWithFormat:@"url,data,create_date,update_date"] autorelease];
                NSString *columnsValue = [[[NSString alloc] initWithFormat:@"'%@','%@','%@','%@'",self.soapMsg_,results,dateStr,dateStr] autorelease];
                
                //如果插入数据不成功
                [myDB insertSQL:columnsName columnsValue:columnsValue tableName:DB_TableName_CacheData];
            }
        }
        //need save to RAM
        else if( [PreRequestCon checkDataNeedSave:parserType] && code_ < Fail && [dataArr_ count] > 0  ){
//            //去更新数据
//            if( [DataManger updateData:soapMsg_ Data:dataArr_] )
//            {
//                
//            }
        }
        
		//call back
		[delegate_ parserFinish:self code:code_ dateArr:dataArr_ parserType:parserType];
		
		//release data
		[self releaseData];
		
		[doc_ release];
		doc_ = nil;
	}
}

//初始化接口
-(void) parserInitOpXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getAccessTokenResponse/return/item" error:&err];
    
    Op_DataModal *dataModal = [[[Op_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        NSString *key   = [[[element elementsForName:@"key"] objectAtIndex:0] stringValue];
        NSString *value = [[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
        
        if( [key isEqualToString:@"secret"] )
        {
            dataModal.sercet_ = value;
        }else if( [key isEqualToString:@"access_token"] )
        {
            dataModal.access_token_ = value;
        }else if( [key isEqualToString:@"service_address"] ){
            dataModal.serviceAddress_ = value;
        }
    }
    
    //只有当两个值同时都存在时,才能说明初始化接口成功
    if( dataModal.access_token_ && dataModal.sercet_ && ![dataModal.access_token_ isEqualToString:@""] && ![dataModal.sercet_ isEqualToString:@""] )
    {
        [dataArr_ addObject:dataModal];
    }
}

//解析登录
-(void) parserDoLoginXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:doLoginResponse/return/item" error:&err];

    Login_DataModal *dataModal = [[[Login_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements ) 
	{        
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"errorno"] )
        {
            if( valueStr && [valueStr isEqualToString:@"100"] )
            {
                dataModal.loginState_ = LoginOK;
                dataModal.status_ = @"OK";
            }else
                dataModal.status_ = @"ERROR";
        }
        
        if( [keyStr isEqualToString:@"errortips"] )
        {
            dataModal.msg_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"PreErrorInfo"] )
        {
            NSArray *subEles = [element nodesForXPath:@"value/item" error:&err];
            for ( GDataXMLElement *element in subEles ) {
                GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                
                NSString *keyStr = [key stringValue];
                NSString *valueStr = [value stringValue];
                
                if( [keyStr isEqualToString:@"id"] )
                {
                    dataModal.personId_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"Prnd"] )
                {
                    dataModal.prnd_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"iname"] )
                {
                    dataModal.iname_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"uname"] )
                {
                    dataModal.uname_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"password"] )
                {
                    dataModal.pwd_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"tradeid"] )
                {
                    dataModal.tradeId_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"totalid"] )
                {
                    dataModal.totalId_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"pic"] )
                {
                    dataModal.pic_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"school"] )
                {
                    dataModal.school_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"zye"] )
                {
                    dataModal.majorCatId_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"zym"] )
                {
                    dataModal.majorStr_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"sex"] )
                {
                    dataModal.sex_ = valueStr;
                }
                else if( [keyStr isEqualToString:@"updatetime"] )
                {
                    dataModal.updateTime_ = valueStr;
                }
            }
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析找回密码
-(void) parserFindPwdXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
   
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPassActionResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析注册
-(void) parserRegestXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:userRegisterNewResponse/return/item" error:&err];

    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析提交意见反馈
-(void) parserAddAdviceXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:insertObjectResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        NSString *bOK               = [element stringValue];
        
        if( [bOK intValue] > 0 )
        {
            dataModal.status_ = Request_OK;
            dataModal.id_ = bOK;
        }
        
        [dataArr_ addObject:dataModal];
    }
}

//解析设置订阅信息
-(void) parserSetSubscribeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:setSubscribeConfigResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析版本信息
-(void) parserGetVersionXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getClientVersionInfoResponse/return/item" error:&err];
    
    VersionInfo_DataModal   *dataModal = [[[VersionInfo_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"version"] )
        {
            dataModal.version_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"url"] )
        {
            dataModal.url_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"level"] )
        {
            dataModal.level_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"msg"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}


//解析宣讲会
-(void) parserXjhXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCurrentXjhResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements ) 
	{        
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements ) 
	{ 
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr ) 
        {
            //key = data
            Event_DataModal *dataModal = [[[Event_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            dataModal.eventType_ = Event_Seminar;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"regionid"] )
                    {
                        dataModal.regionId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"title"] )
                    {
                        
                        dataModal.title_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"sname"] )
                    {
                        dataModal.sname_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"sid"] )
                    {
                        dataModal.sid_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"cname"] )
                    {
                        dataModal.cname_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"cid"] )
                    {
                        dataModal.cid_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"sdate"] )
                    {
                        dataModal.sdate_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"addr"] )
                    {
                        dataModal.addr_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"have_add"] ){
                        dataModal.bHaveAdd_ = [valueStr intValue];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//解析招聘会
-(void) parserZphXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCurrentZphResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements ) 
	{        
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements ) 
	{ 
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr ) 
        {
            //key = data
            Event_DataModal *dataModal = [[[Event_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            dataModal.eventType_ = Event_Recruitment;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"regionid"] )
                    {
                        dataModal.regionId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"title"] )
                    {
                        dataModal.title_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"sname"] )
                    {
                        dataModal.sname_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"sid"] )
                    {
                        dataModal.sid_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"sdate"] )
                    {
                        dataModal.sdate_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"addr"] )
                    {
                        dataModal.addr_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"have_add"] ){
                        dataModal.bHaveAdd_ = [valueStr intValue];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//职业的力量列表
-(void) parserProfessionPowerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getListContainNextInfoResponse/return/item" error:&err];

    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"qikanId"] )
                    {
                        dataModal.newsID_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"title"] )
                    {
                        dataModal.newsTitle_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"qikan"] )
                    {
                        dataModal.newsCount_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"thum"] )
                    {
                        dataModal.imagePath_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"idate"] )
                    {
                        dataModal.newsDate_ = [valueStr substringToIndex:10];
                    }
                    else if( [[key stringValue] isEqualToString:@"nextTitle"] )
                    {
                        dataModal.nextTitle_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"nextId"] )
                    {
                        dataModal.nextId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"nextQikan"] )
                    {
                        dataModal.nextQikan_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"preId"] )
                    {
                        dataModal.preId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"preTitle"] )
                    {
                        dataModal.preTitle_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"preQikan"] )
                    {
                        dataModal.preQikan_ = valueStr;
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//职业的力量详情
-(void) parserProfessionPowerDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getArticleDetailResponse/return/item" error:&err];
    
    ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements ) {
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        NSString                                *valueStr = [value stringValue];
        
        if( [[key stringValue] isEqualToString:@"qikanId"] )
        {
            dataModal.newsID_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"title"] )
        {
            dataModal.newsTitle_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"qikan"] )
        {
            dataModal.newsCount_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"content"] )
        {
            dataModal.newsContent_ = [NSMutableString stringWithString:valueStr];
        }
        else if( [[key stringValue] isEqualToString:@"nextTitle"] )
        {
            dataModal.nextTitle_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"nextId"] )
        {
            dataModal.nextId_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"nextQikan"] )
        {
            dataModal.nextQikan_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"preId"] )
        {
            dataModal.preId_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"preTitle"] )
        {
            dataModal.preTitle_ = valueStr;
        }
        else if( [[key stringValue] isEqualToString:@"preQikan"] )
        {
            dataModal.preQikan_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//职业指导/职场风雨...
-(void) parserGetProfessInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.newsID_ = [value stringValue];
                    }
                    
                    if( [[key stringValue] isEqualToString:@"Title"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.newsTitle_ = [value stringValue];
                    }
                    
                    if( [[key stringValue] isEqualToString:@"Addtime"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        NSString *date = [[value stringValue] substringToIndex:10];
                        dataModal.newsDate_ = date;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"Content"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.newsContent_				= [NSMutableString stringWithString:[value stringValue]];
                    }
                    
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
    
}

//职业指导/...上一篇
-(void) parserGetPreProfessInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPreArticleInfoResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        //key = data
        ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
        dataModal.totalCnt_ = sumCount;
        dataModal.pageCnt_ = pageCount;
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            GDataXMLElement *keyEle             = [[element elementsForName:@"key"] objectAtIndex:0];
            GDataXMLElement *valueEle           = [[element elementsForName:@"value"] objectAtIndex:0];
            
            NSString *key = [keyEle stringValue];
            NSString *value = [valueEle stringValue];
            
            if( [key isEqualToString:@"status"] )
            {
                dataModal.status_ = value;
            }
            
            if( [key isEqualToString:@"code"] )
            {
                dataModal.code_ = value;
            }
            
            if( [key isEqualToString:@"status_desc"] )
            {
                dataModal.msg_ = value;
            }
            
            if( [key isEqualToString:@"id"] )
            {
                dataModal.newsID_ = value;
            }
            
            if( [key isEqualToString:@"title"] )
            {
                dataModal.newsTitle_ = value;
            }
            
            if( [key isEqualToString:@"content"] )
            {
                dataModal.newsContent_  = [NSMutableString stringWithString:value];
            }
            
            if( [key isEqualToString:@"qikan"] )
            {
                dataModal.newsCount_ = [NSString stringWithFormat:@"第%@期",value];
            }
        }
        
        if( [subElements count] == 0 )
        {
            
        }else
            [dataArr_ addObject:dataModal];
        
    }
}

//职业指导/...下一篇
-(void) parserGetNextProfessInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getNextArticleInfoResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        //key = data
        ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
        dataModal.totalCnt_ = sumCount;
        dataModal.pageCnt_ = pageCount;
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            GDataXMLElement *keyEle             = [[element elementsForName:@"key"] objectAtIndex:0];
            GDataXMLElement *valueEle           = [[element elementsForName:@"value"] objectAtIndex:0];
            
            NSString *key = [keyEle stringValue];
            NSString *value = [valueEle stringValue];
            
            if( [key isEqualToString:@"status"] )
            {
                dataModal.status_ = value;
            }
            else if( [key isEqualToString:@"code"] )
            {
                dataModal.code_ = value;
            }
            else if( [key isEqualToString:@"status_desc"] )
            {
                dataModal.msg_ = value;
            }
            else if( [key isEqualToString:@"id"] )
            {
                dataModal.newsID_ = value;
            }
            else if( [key isEqualToString:@"title"] )
            {
                dataModal.newsTitle_ = value;
            }
            else if( [key isEqualToString:@"content"] )
            {
                dataModal.newsContent_  = [NSMutableString stringWithString:value];
            }
            else if( [key isEqualToString:@"qikan"] )
            {
                dataModal.newsCount_ = [NSString stringWithFormat:@"第%@期",value];
            }
            else if( [key isEqualToString:@"nextId"] )
            {
                dataModal.nextId_ = value;
            }
            else if( [key isEqualToString:@"nextTitle"] )
            {
                dataModal.nextTitle_ = value;
            }
        }
        
        if( [subElements count] == 0 )
        {
            
        }else
            [dataArr_ addObject:dataModal];
        
    }
}

//解析文章列表
-(void) parserArticleListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getListContainNextInfoResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        dataModal.newsID_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"Title"] )
                    {
                        dataModal.newsTitle_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"Addtime"] )
                    {
                        dataModal.newsDate_ = [valueStr substringToIndex:10];
                    }
                    else if( [[key stringValue] isEqualToString:@"nextTitle"] )
                    {
                        dataModal.nextTitle_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"nextId"] )
                    {
                        dataModal.nextId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"preId"] )
                    {
                        dataModal.preId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"preTitle"] )
                    {
                        dataModal.preTitle_ = valueStr;
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//解析文章详情
-(void) parserArticleDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getArticleDetailResponse/return/item" error:&err];
    
    ProfessionPower_DataModal *dataModal = [[[ProfessionPower_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements ) {
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        NSString                                *valueStr = [value stringValue];
        
        if( [[key stringValue] isEqualToString:@"id"] )
        {
            dataModal.newsID_ = valueStr;
        }else if( [[key stringValue] isEqualToString:@"Content"] )
        {
            dataModal.newsContent_ = [NSMutableString stringWithString:valueStr];
        }else if( [[key stringValue] isEqualToString:@"Title"] )
        {
            dataModal.newsTitle_ = valueStr;
        }else if( [[key stringValue] isEqualToString:@"nextTitle"] )
        {
            dataModal.nextTitle_ = valueStr;
        }else if( [[key stringValue] isEqualToString:@"nextId"] )
        {
            dataModal.nextId_ = valueStr;
        }else if( [[key stringValue] isEqualToString:@"preTitle"] )
        {
            dataModal.preTitle_ = valueStr;
        }else if( [[key stringValue] isEqualToString:@"preId"] )
        {
            dataModal.preId_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析职位详情
-(void) parserZWDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
		ZWDetail_DataModal *dataModal       = [[[ZWDetail_DataModal alloc] init] autorelease];
		GDataXMLElement *companyName		= [[element elementsForName:@"cname"] objectAtIndex:0];
		GDataXMLElement *jobName			= [[element elementsForName:@"jtzw"] objectAtIndex:0];
		GDataXMLElement *dateValue			= [[element elementsForName:@"updatetime"] objectAtIndex:0];
		GDataXMLElement *region				= [[element elementsForName:@"region"] objectAtIndex:0];
		GDataXMLElement *peopleCount		= [[element elementsForName:@"zpnum"] objectAtIndex:0];
		GDataXMLElement *edus				= [[element elementsForName:@"edus"] objectAtIndex:0];
		GDataXMLElement *moneyCount			= [[element elementsForName:@"minsalary"] objectAtIndex:0];
		GDataXMLElement *yearCount			= [[element elementsForName:@"gznum1"] objectAtIndex:0];
		GDataXMLElement *jobJianJie			= [[element elementsForName:@"zptxt"] objectAtIndex:0];
		GDataXMLElement *cAddress			= [[element elementsForName:@"cAddr"] objectAtIndex:0];
        GDataXMLElement *major              = [[element elementsForName:@"major"] objectAtIndex:0];
        
		dataModal.companyName_              = [companyName stringValue];
		dataModal.zwName_                   = [jobName stringValue];
		dataModal.updateTime_               = [dateValue stringValue];
		dataModal.regionName_               = [region stringValue];
		dataModal.peopleCount_              = [peopleCount stringValue];
		dataModal.edus_                     = [edus stringValue];
		dataModal.moneyCount_               = [moneyCount stringValue];
		dataModal.yearCount_                = [yearCount stringValue];
		dataModal.zwJianJie_                = [jobJianJie stringValue];
		dataModal.companyAddr_              = [cAddress stringValue];
        dataModal.major_                    = [major stringValue];
        
		[dataArr_ addObject:dataModal];
	}
}

//申请职位
-(void) parserApplyZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{        
        PreStatus_DataModal *dataModal         = [[[PreStatus_DataModal alloc] init] autorelease];
		GDataXMLElement *ele_status			= [[element elementsForName:@"status"] objectAtIndex:0];
		
		dataModal.status_					= [ele_status stringValue];
		
		@try {
			GDataXMLElement *ele_msg		= [[element elementsForName:@"message"] objectAtIndex:0];
			dataModal.msg_					= [ele_msg stringValue];
		}
		@catch (NSException * e) {
			dataModal.msg_ = nil;
		}
        
		[dataArr_ addObject:dataModal];
    }
}

//职位收藏
-(void) parserFavZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    [self parserApplyZWXML:xmlData strData:strData parserType:parserType];
}

//解析公司详情
-(void) parserCompanyDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:selectResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        CompanyInfo_DataModal *dataModal = [[[CompanyInfo_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"id"] )
                {
                    dataModal.companyID_                    = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.companyID_                    = nil;
            }
            
            @try {
                
                dataModal.email_                        = @"未公开";
            }
            @catch (NSException *exception) {
                dataModal.email_                        = nil;
            }
            
            @try {
                if( [key isEqualToString:@"cname"] )
                {
                    dataModal.cname_                        = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.cname_                        = nil;
            }
            
            @try {
                if( [key isEqualToString:@"cxz"] )
                {
                    dataModal.cxz_                      = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.cxz_                          = nil;
            }
            
            @try {
                if( [key isEqualToString:@"yuangong"] )
                {
                    dataModal.yuangong_                 = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.yuangong_                     = nil;
            }
            
            @try {
                dataModal.phone_                        = @"未公开";
            }
            @catch (NSException *exception) {
                dataModal.phone_                        = nil;
            }
            
            @try {                
                dataModal.fax_                          = @"未公开";
            }
            @catch (NSException *exception) {
                dataModal.fax_                          = nil;
            }
            
            
            @try {
                if( [key isEqualToString:@"address"] )
                {
                    dataModal.address_                    = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.address_                      = nil;
            }
            
            
            @try {
                if( [key isEqualToString:@"regionid"] )
                {
                    dataModal.regionid_                    = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.regionid_                     = nil;
            }
            
            @try {
                if( [key isEqualToString:@"classid"] )
                {
                    dataModal.classid_                    = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.classid_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"trade"] )
                {
                    dataModal.trade_                    = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.trade_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"jianj"] )
                {
                    dataModal.des_                    = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.des_                      = nil;
            }
            
        }
        
        [dataArr_ addObject:dataModal];
    }
}

//解析搜索返回来的数据
-(void) parserSearchResultXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    int tempPages = 0;
	int tempSums  = 0;
    
	int currentIndex = 0;
	for ( GDataXMLElement *element in docElements )
	{
		if( currentIndex == 0)
		{
			GDataXMLElement *pages		= [[element elementsForName:@"pages"] objectAtIndex:0];
			GDataXMLElement *sums		= [[element elementsForName:@"sums"] objectAtIndex:0];
			
			tempPages	= [[pages stringValue] intValue];
			tempSums	= [[sums stringValue] intValue];
			
			if( tempSums == 0 )
			{
				return;
			}
			
		}else
		{
			JobSearch_DataModal *dataModal      = [[[JobSearch_DataModal alloc] init] autorelease];
            
            dataModal.totalCnt_                 = tempSums;
            dataModal.pageCnt_                = tempPages;
            
			GDataXMLElement *ele_companyID		= [[element elementsForName:@"companyid"] objectAtIndex:0];
			GDataXMLElement *ele_zwID			= [[element elementsForName:@"zwid"] objectAtIndex:0];
			GDataXMLElement *ele_zwName			= [[element elementsForName:@"zwname"] objectAtIndex:0];
			GDataXMLElement *ele_companyName	= [[element elementsForName:@"cname"] objectAtIndex:0];
			GDataXMLElement *ele_regionName		= [[element elementsForName:@"region"] objectAtIndex:0];
			GDataXMLElement *ele_updateTime		= [[element elementsForName:@"updatetime"] objectAtIndex:0];
            GDataXMLElement *ele_favKeyId		= [[element elementsForName:@"id"] objectAtIndex:0];
            
            //			GDataXMLElement *ele_applyTime		= [[element elementsForName:JobSearch_ApplyTime_XML_Name] objectAtIndex:0];
			
			dataModal.companyID_			= [ele_companyID stringValue];
			dataModal.zwID_					= [ele_zwID stringValue];
			dataModal.zwName_				= [ele_zwName stringValue];
			dataModal.companyName_			= [ele_companyName stringValue];
			dataModal.regionName_			= [ele_regionName stringValue];
            
            @try {
                dataModal.zwFavKeyId_       = [ele_favKeyId stringValue];
            }
            @catch (NSException *exception) {
                dataModal.zwFavKeyId_       = nil;
            }
            @finally {
                
            }
			
			@try {
				dataModal.updateTime_		= [ele_updateTime stringValue];
			} @catch ( NSException *e ) {
				dataModal.updateTime_		=  nil;
			}
            
			
			[dataArr_ addObject:dataModal];
		}
		
		++currentIndex;
	}
}

//解析身边招聘结果
-(void) parserMapSearchResultXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:searchMapCompanyResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            MapSearchResult_DataModal *dataModal = [[[MapSearchResult_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"cname"] )
                    {
                        dataModal.cname_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"latnum"] )
                    {
                        dataModal.latnum_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"Longnum"] )
                    {
                        
                        dataModal.longnum_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"uid"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
        }
    }
}


//身边招聘公司的职位
-(void) parserGetMapCompanyZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCompanyZWResponse/return/item" error:&err];

    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            JobSearch_DataModal *dataModal = [[[JobSearch_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.zwID_ = [value stringValue];
                    }
                    
                    if( [[key stringValue] isEqualToString:@"uid"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.companyID_ = [value stringValue];
                    }
                    
                    if( [[key stringValue] isEqualToString:@"cname"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.companyName_ = [value stringValue];
                    }
                    
                    if( [[key stringValue] isEqualToString:@"jtzw"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        dataModal.zwName_ = [value stringValue];
                    }
                    
                    if( [[key stringValue] isEqualToString:@"updatetime"] )
                    {
                        GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                        //将其时间的前10位
                        dataModal.updateTime_ = [[value stringValue] substringToIndex:10];
                    }
                    
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
    }
}

//解析公司其它职位
-(void) parserCompanyOtherZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
		JobSearch_DataModal *dataModal      = [[[JobSearch_DataModal alloc] init] autorelease];
		GDataXMLElement *ele_companyID		= [[element elementsForName:@"jobdetail_CompanyDetail"] objectAtIndex:0];
		GDataXMLElement *ele_zwID			= [[element elementsForName:@"jobdetail_zwid"] objectAtIndex:0];
		GDataXMLElement *ele_zwName			= [[element elementsForName:@"jobdetail_jtzw"] objectAtIndex:0];
		GDataXMLElement *ele_regionName		= [[element elementsForName:@"jobdetail_region"] objectAtIndex:0];
		GDataXMLElement *ele_updateTime		= [[element elementsForName:@"jobdetail_update"] objectAtIndex:0];
		
		dataModal.companyID_			= [ele_companyID stringValue];
		dataModal.zwID_					= [ele_zwID stringValue];
		dataModal.zwName_				= [ele_zwName stringValue];
		dataModal.regionName_			= [ele_regionName stringValue];
		dataModal.updateTime_			= [ele_updateTime stringValue];
        
		[dataArr_ addObject:dataModal];
	}
}

//解析企业描述
-(void) parserCompanyDesXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{		
		CompanyDescript_DataModal *dataModal	= [[[CompanyDescript_DataModal alloc] init] autorelease];
		GDataXMLElement *companyName		= [[element elementsForName:@"companyname"] objectAtIndex:0];
		GDataXMLElement *companyJianJie		= [[element elementsForName:@"jianjie"] objectAtIndex:0];
        
		dataModal.companyName_			= [companyName stringValue];
		dataModal.companyDescript_		= [companyJianJie stringValue];
        
		[dataArr_ addObject:dataModal];
	}
}

//解析测试题目
-(void) parserTestQuestionXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
//    NSError *err = nil;
//	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getAndAddAnswerResponse/return/item" error:&err];    
//    
//    ProgramQuestion_DataModal *dataModal = [[[ProgramQuestion_DataModal alloc] init] autorelease];
//    
//    //已做题目信息
//    for ( GDataXMLElement *element in docElements )
//	{
//        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
//        if( [[key stringValue] isEqualToString:@"info"] )
//        {
//            NSArray	*subElements = [element elementsForName:@"value"];
//            GDataXMLElement *valueElement = [subElements objectAtIndex:0];
//            NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
//            
//            for ( GDataXMLElement *element in valueElementArr )
//            {
//                @try {
//                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
//                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
//                    NSString                                *valueStr = [value stringValue];
//                    
//                    if( [[key stringValue] isEqualToString:@"sums"] )
//                    {
//                        dataModal.totalCnt_ = [valueStr intValue];
//                    }
//                    
//                    if( [[key stringValue] isEqualToString:@"cnt"] )
//                    {
//                        dataModal.testCnt_ = [valueStr intValue];
//                    }
//                    
//                    if( [[key stringValue] isEqualToString:@"cnt1"] )
//                    {
//                        dataModal.lessCnt_ = [valueStr intValue];
//                    }
//                }
//                @catch (NSException *exception) {
//                    
//                }
//            }
//        }
//    }
//    
//    //data
//    for ( GDataXMLElement *element in docElements )
//	{
//        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
//        
//        if( ![[key stringValue] isEqualToString:@"data"] )
//        {
//            continue;
//        }
//        
//        NSArray	*subElements = [element elementsForName:@"value"];
//        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
//        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
//        
//        for ( GDataXMLElement *element in valueElementArr )
//        {
//            NSArray *items = [element elementsForName:@"item"];
//            if( !items )
//            {
//                items = [[[element elementsForName:@"value"] objectAtIndex:0] elementsForName:@"item"];
//            }
//            for ( GDataXMLElement *element in items ) {
//                @try {
//                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
//                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
//                    NSString                                *valueStr = [value stringValue];
//                    
//                    if( [[key stringValue] isEqualToString:@"id"] )
//                    {
//                        dataModal.id_ = valueStr;
//                    }
//                    else if( [[key stringValue] isEqualToString:@"question"] )
//                    {
//                        dataModal.question_ = valueStr;
//                    }
//                    else if( [[key stringValue] isEqualToString:@"type"] )
//                    {
//                        dataModal.type_ = valueStr;
//                    }
//                    else if( [[key stringValue] isEqualToString:@"classflag"] )
//                    {
//                        dataModal.classFlag_ = valueStr;
//                    }
//                    else if( [[key stringValue] isEqualToString:@"otherflag"] )
//                    {
//                        dataModal.otherFlag_ = valueStr;
//                    }
//                    else if( [[key stringValue] isEqualToString:@"classtype"] )
//                    {
//                        dataModal.classType_ = valueStr;
//                    }
//                    else if( [[key stringValue] isEqualToString:@"answerchlid"] )
//                    {
//                        dataModal.answerArr_ = [[NSMutableArray alloc] init];
//                        
//                        NSArray	*subElements = [element elementsForName:@"value"];
//                        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
//                        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
//                        
//                        for ( GDataXMLElement *element in valueElementArr ) {
//                            Answer_DataModal *answer = [[[Answer_DataModal alloc] init] autorelease];
//                            
//                            NSArray	*subArr = [element elementsForName:@"item"];
//                            for ( GDataXMLElement *subElement in subArr ) {
//                                GDataXMLElement *key                    = [[subElement elementsForName:@"key"] objectAtIndex:0];
//                                GDataXMLElement *value                  = [[subElement elementsForName:@"value"] objectAtIndex:0];
//                                NSString                                *keyStr = [key stringValue];
//                                NSString                                *valueStr = [value stringValue];
//                                
//                                if( [keyStr isEqualToString:@"flag"] )
//                                {
//                                    answer.flag_ = valueStr;
//                                }
//                                if( [keyStr isEqualToString:@"text"] )
//                                {
//                                    answer.text_ = valueStr;
//                                }
//                                if( [keyStr isEqualToString:@"socre"] )
//                                {
//                                    answer.score_ = valueStr;
//                                }
//                            }
//                            
//                            [dataModal.answerArr_ addObject:answer];
//                        }
//                    }
//                    
//                }
//                @catch (NSException *exception) {
//                    
//                }
//                
//            }
//            
//        }
//        
//        [dataArr_ addObject:dataModal];
//    }
//    
}

//解析测试结果
-(void) parserTestResultXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCpResultAllResponse/return/item/item" error:&err];
    
    TestResult_DataModal *dataModal = [[[TestResult_DataModal alloc] init] autorelease];
    
    //已做题目信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( [[key stringValue] isEqualToString:@"resdesc"] )
        {
            NSArray	*subElements = [element elementsForName:@"value"];
            GDataXMLElement *valueElement = [subElements objectAtIndex:0];
            NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
            
            for ( GDataXMLElement *element in valueElementArr )
            {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"summary"] )
                    {
                        dataModal.summary_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"contents"] )
                    {
                        dataModal.contents_ = valueStr;
                    }
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析测试项目
-(void) parserTestProgramXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getMobProgramResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            TestProgram_DataModal *dataModal = [[[TestProgram_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                NSString *key;
                NSString *value;
                @try {
                    GDataXMLElement *item = element;
                    key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                    value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
                }
                @catch (NSException *exception) {
                    continue;
                }
                @finally {
                    //NSLog(@"key:%@ value:%@\n",key,value);
                }
                
                @try {
                    if( [key isEqualToString:@"id"] )
                    {
                        dataModal.id_                  = value;
                    }
                }
                @catch (NSException *exception) {
                    dataModal.id_                      = nil;
                }
                
                @try {
                    if( [key isEqualToString:@"title"] )
                    {
                        dataModal.title_                   = value;
                    }
                }
                @catch (NSException *exception) {
                    dataModal.title_                       = nil;
                }
                
                @try {
                    if( [key isEqualToString:@"img"] )
                    {
                        dataModal.img_                  = value;
                    }
                }
                @catch (NSException *exception) {
                    dataModal.img_                      = nil;
                }
                
                @try {
                    if( [key isEqualToString:@"cnt"] )
                    {
                        dataModal.cnt_                  = [value intValue];
                    }
                }
                @catch (NSException *exception) {
                }
                
                @try {
                    if( [key isEqualToString:@"desc"] )
                    {
                        dataModal.desc_                  = value;
                    }
                }
                @catch (NSException *exception) {
                    dataModal.desc_                  = nil;
                }
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//解析换大米
-(void) parserRiceMoneyXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getChangeObjectResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        RiceMoney_DataModal *dataModal = [[[RiceMoney_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"name"] )
                {
                    dataModal.name_ = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.name_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"max"] )
                {
                    dataModal.max_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.max_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"min"] )
                {
                    dataModal.min_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.min_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"money"] )
                {
                    dataModal.money_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.money_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"percentage"] )
                {
                    dataModal.per_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.per_                  = nil;
            }
            
            @try {
                if( [key isEqualToString:@"dangwei"] )
                {
                    dataModal.dangwei_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.dangwei_                  = nil;
            }
            
            if( [key isEqualToString:@"mimg"] )
            {
                NSArray *subItems = [[[obj elementsForName:@"value"] objectAtIndex:0] elementsForName:@"item"];
                
                for ( id obj in subItems )
                {
                    NSString *key;
                    NSString *value;
                    key     = [[[obj elementsForName:@"key"] objectAtIndex:0] stringValue];
                    value   = [[[obj elementsForName:@"value"] objectAtIndex:0] stringValue];
                    
                    if( [key isEqualToString:@"m"] )
                    {
                        dataModal.imageOnPic_ = value;
                    }
                    
                    if( [key isEqualToString:@"n"] )
                    {
                        dataModal.imageOffPic_ = value;
                    }
                }
            }
        }
        
        [dataArr_ addObject:dataModal];
        
    }
}

//解析薪酬查询的结果
-(void) parserGetSalaryXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//salary" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        if( ![element stringValue] || [[element stringValue] isEqualToString:@""] )
        {
            continue;
        }
        
        Salary_DataModal *dataModal         = [[[Salary_DataModal alloc] init] autorelease];
        
        GDataXMLElement *ele_min			= [[element elementsForName:@"minsalary"] objectAtIndex:0];
		GDataXMLElement *ele_minmid			= [[element elementsForName:@"minmidsalary"] objectAtIndex:0];
		GDataXMLElement *ele_mid            = [[element elementsForName:@"midsalary"] objectAtIndex:0];
		GDataXMLElement *ele_midmax			= [[element elementsForName:@"midmaxsalary"] objectAtIndex:0];
		GDataXMLElement *ele_max			= [[element elementsForName:@"maxsalary"] objectAtIndex:0];
        
        dataModal.min_						= [ele_min stringValue];
        dataModal.minmid_                   = [ele_minmid stringValue];
        dataModal.mid_						= [ele_mid stringValue];
        dataModal.midmax_                   = [ele_midmax stringValue];
        dataModal.max_                      = [ele_max stringValue];

        [dataArr_ addObject:dataModal];
    }
}

//解析学校列表
-(void) parserSchoolListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getListByRegionIdResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
        
        NSArray *subArr = [element nodesForXPath:@"item" error:&err];
        
        for ( GDataXMLElement *element in subArr ) {
            NSString *key   = [[[element elementsForName:@"key"] objectAtIndex:0] stringValue];
            NSString *value = [[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
            
            if( [key isEqualToString:@"id"] )
            {
                dataModal.id_ = value;
            }
            else if( [key isEqualToString:@"schoolname"] )
            {
                dataModal.str_ = value;
            }
            else if( [key isEqualToString:@"logopath"] ){
                dataModal.pic_ = value;
            }
            else if( [key isEqualToString:@"attention_flag"] ){
                dataModal.bAttention_ = [value boolValue];
            }
        }
        
        if( dataModal.str_ && ![dataModal.str_ isEqualToString:@"orjmpkj"] )
        {
            [dataArr_ addObject:dataModal];
        }
    }
    
}

//人才market
-(void) parserTalentMarketXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getQueryResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements ) {
        GDataXMLElement *ele_key = [[element nodesForXPath:@"key" error:&err] objectAtIndex:0];
        GDataXMLElement *ele_value = [[element nodesForXPath:@"value" error:&err] objectAtIndex:0];
        if( [[ele_key stringValue] isEqualToString:@"status"] )
        {
            if( ![[ele_value stringValue] isEqualToString:@"OK"] )
            {
                break;
            }
        }else if( [[ele_key stringValue] isEqualToString:@"results"] )
        {
            NSArray *resultArr = [ele_value nodesForXPath:@"item" error:&err];
            
            for ( GDataXMLElement *element in resultArr ) {
                
                NSArray *subArr = [element nodesForXPath:@"item" error:&err];
                TalentMarket_DataModal *dataModal = [[[TalentMarket_DataModal alloc] init] autorelease];
                for ( GDataXMLElement *element in subArr ) {
                    
                    GDataXMLElement *ele_key = [[element nodesForXPath:@"key" error:&err] objectAtIndex:0];
                    GDataXMLElement *ele_value = [[element nodesForXPath:@"value" error:&err] objectAtIndex:0];
                    
                    if( [[ele_key stringValue] isEqualToString:@"name"] )
                    {
                        dataModal.name_ = [ele_value stringValue];
                    }
                    else if( [[ele_key stringValue] isEqualToString:@"address"] )
                    {
                        dataModal.address_ = [ele_value stringValue];
                    }
                    else if( [[ele_key stringValue] isEqualToString:@"telephone"] )
                    {
                        dataModal.phone_ = [ele_value stringValue];
                    }
                    else if( [[ele_key stringValue] isEqualToString:@"location"] )
                    {
                        NSArray *arr = [ele_value nodesForXPath:@"item" error:&err];
                        for ( GDataXMLElement *element in arr ) {
                            GDataXMLElement *ele_key = [[element nodesForXPath:@"key" error:&err] objectAtIndex:0];
                            GDataXMLElement *ele_value = [[element nodesForXPath:@"value" error:&err] objectAtIndex:0];
                            
                            if( [[ele_key stringValue] isEqualToString:@"lat"] )
                            {
                                dataModal.lat_ = [ele_value stringValue];
                            }else if( [[ele_key stringValue] isEqualToString:@"lng"] )
                            {
                                dataModal.lng_ = [ele_value stringValue];
                            }
                        }
                    }
                }
                
                [dataArr_ addObject:dataModal];
            }
        }
    }
}

//解析新增订阅
-(void) parserAddSubscribeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addSubscribeResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }else if( [keyStr isEqualToString:@"pre_delete_id"] )
        {
            dataModal.preId_ = valueStr;
        }else if( [keyStr isEqualToString:@"have_new_msg"] )
        {
            dataModal.bHaveNewMsg_ = [valueStr intValue];
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析宣讲会详情
-(void) parserXjhDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getXjhDetailResponse/return/item" error:&err];
    
    Event_Detail_DataModal *dataModal = [[[Event_Detail_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"title"] )
        {
            dataModal.title_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"sname"] )
        {
            dataModal.sname_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"addr"] )
        {
            dataModal.addr_ = valueStr;
        }else if( [keyStr isEqualToString:@"cname"] )
        {
            dataModal.cname_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"contents"] )
        {
            dataModal.content_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"sdate"] )
        {
            dataModal.sdate_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析参与
-(void) parserAddParticipateXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addParticipateResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"cnt"] )
        {
            dataModal.id_ = valueStr;
            
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析刷新参与
-(void) parserRefreshAddParticipateXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCntResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"cnt"] )
        {
            dataModal.id_ = valueStr;
            
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析招聘会详情
-(void) parserZphDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getZphDetailResponse/return/item" error:&err];
    
    Event_Detail_DataModal *dataModal = [[[Event_Detail_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"title"] )
        {
            dataModal.title_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"sname"] )
        {
            dataModal.sname_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"addr"] )
        {
            dataModal.addr_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"content"] )
        {
            dataModal.content_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"sdate"] )
        {
            dataModal.sdate_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析添加评论
-(void) parserAddMyCommentXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addBbsResponse/return/item" error:&err];
    
    if( !docElements || [docElements count] == 0  ){
        docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:insertConmmentResponse/return/item" error:&err];
    }
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"key_id"] )
        {
            dataModal.id_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"date"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析新增企业回复
-(void) parserAddCompanyReplyXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addReplyResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"key_id"] )
        {
            dataModal.id_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"date"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析获取评论列表
-(void) parserGetMyCommentListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCommListResponse/return/item" error:&err];
    
    if( !docElements || [docElements count] == 0  ){
        docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCommentAllResponse/return/item" error:&err];
    }
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            MyComment_DataModal *dataModal = [[[MyComment_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"bbs_id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bbs_content"] )
                    {
                        dataModal.content_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bbs_idate"] )
                    {
                        dataModal.updateTime_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bbs_own_id"] )
                    {
                        dataModal.personId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bbs_own_iname"] )
                    {
                        dataModal.name_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bbs_source"] )
                    {
                        dataModal.clientName_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bbs_param1"] )
                    {
                        dataModal.agreetCnt_ = [valueStr intValue];
                    }
                    else if( [[key stringValue] isEqualToString:@"hfCount"] )
                    {
                        dataModal.replyCnt_ = [valueStr intValue];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//解析支持评论
-(void) parserAddAgreeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updateZanResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析企业回复列表
-(void) parserCompanyReplyListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getReplyListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            MyComment_DataModal *dataModal = [[[MyComment_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"person_id"] )
                    {
                        dataModal.personId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"person_name"] )
                    {
                        dataModal.name_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"update_datetime"] )
                    {
                        dataModal.updateTime_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"content"] )
                    {
                        dataModal.content_ = valueStr;
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
    }
}

//解析新增企业评论
-(void) parserAddCompanyCommentXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addCommentResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"key_id"] )
        {
            dataModal.id_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"date"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析企业评论列表
-(void) parserCompanyCommentListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCommentListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            MyComment_DataModal *dataModal = [[[MyComment_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"person_id"] )
                    {
                        dataModal.personId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"is_hide"] )
                    {
                        dataModal.bHide_ = [valueStr intValue];
                    }
                    else if( [[key stringValue] isEqualToString:@"person_name"] )
                    {
                        dataModal.name_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"update_datetime"] )
                    {
                        dataModal.updateTime_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"score"] )
                    {
                        dataModal.score_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"title"] )
                    {
                        dataModal.title_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"good"] )
                    {
                        if( !valueStr || [valueStr isEqualToString:@""] ){
                            valueStr = @"-";
                        }
                        dataModal.good_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"bad"] )
                    {
                        if( !valueStr || [valueStr isEqualToString:@""] ){
                            valueStr = @"-";
                        }
                        dataModal.bad_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"reply_cnt"] )
                    {
                        dataModal.replyCnt_ = [valueStr intValue];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//解析设置订阅状态
-(void) parserSetSubscribeReadFlagXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:setSubscribeReadFlagResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"update_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析修改密码
-(void) parserResetPwdXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    //新的解析方法
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePasswordResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;           
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//获取求职状态
-(void) parserGetResumeStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getResumeStatusResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"resume_status"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//更新求职状态
-(void) parserUpdateResumeStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updateResumeStatusResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//获取保密状态
-(void) parserGetResumeSercetXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getResumeSercetResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"resume_sercet"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//更新保密设置
-(void) parserUpdateResumeSercetStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePersonDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{        
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        GDataXMLElement *bOK                = [[element attributes] objectAtIndex:0];
        
        if( [[bOK stringValue] isEqualToString:@"true"])
        {
            dataModal.status_ = Request_OK;
        }else
            dataModal.status_ = nil;
        
        [dataArr_ addObject:dataModal];
    }
}

//职位申请记录
-(void) parserApplyDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    int tempPages = 0;
	int tempSums  = 0;
    int currentIndex = 0;
	for ( GDataXMLElement *element in docElements )
	{		
		if( currentIndex == 0)
		{
			GDataXMLElement *pages		= [[element elementsForName:@"pages"] objectAtIndex:0];
			GDataXMLElement *sums		= [[element elementsForName:@"sums"] objectAtIndex:0];
			
			tempPages       = [[pages stringValue] intValue];
			tempSums        = [[sums stringValue] intValue];
			
			if( tempSums == 0 )
			{
				return;
			}
			
		}else
		{
			ApplyDetail_DataModal *dataModal      = [[[ApplyDetail_DataModal alloc] init] autorelease];
            
            dataModal.totalCnt_                 = tempSums;
            dataModal.pageCnt_                  = tempPages;
            
			GDataXMLElement *ele_companyID		= [[element elementsForName:@"companyid"] objectAtIndex:0];
			GDataXMLElement *ele_zwID			= [[element elementsForName:@"zwid"] objectAtIndex:0];
			GDataXMLElement *ele_zwName			= [[element elementsForName:@"zwname"] objectAtIndex:0];
			GDataXMLElement *ele_companyName	= [[element elementsForName:@"cname"] objectAtIndex:0];
			GDataXMLElement *ele_regionName		= [[element elementsForName:@"region"] objectAtIndex:0];
			GDataXMLElement *ele_applyTime		= [[element elementsForName:@"applaytime"] objectAtIndex:0];
			
			dataModal.companyID_                = [ele_companyID stringValue];
			dataModal.zwID_                     = [ele_zwID stringValue];
			dataModal.zwName_                   = [ele_zwName stringValue];
			dataModal.companyName_              = [ele_companyName stringValue];
			dataModal.regionName_               = [ele_regionName stringValue];
			
			@try {
				dataModal.applyTime_		= [ele_applyTime stringValue];
			} @catch ( NSException *e ) {
				dataModal.applyTime_		=  nil;
			}
			
			[dataArr_ addObject:dataModal];
		}
		
		++currentIndex;
    }
}

//职位收藏记录
-(void) parserFavDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    [self parserSearchResultXML:xmlData strData:strData parserType:parserType];
}

//删除收藏职位
-(void) parserDelFavZWXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deletePfavoriteResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//面试通知详情
-(void) parserResumeNotifiDetailXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{		
		ResumeNotifiDetail_DataModal *dataModal	= [[[ResumeNotifiDetail_DataModal alloc] init] autorelease];
		GDataXMLElement *ele_reid               = [[element elementsForName:@"reid"] objectAtIndex:0];
		GDataXMLElement *ele_companyid          = [[element elementsForName:@"senduid"] objectAtIndex:0];
		GDataXMLElement *ele_companyName        = [[element elementsForName:@"sendname"] objectAtIndex:0];
		GDataXMLElement *ele_date               = [[element elementsForName:@"sdate"] objectAtIndex:0];
		GDataXMLElement *ele_text               = [[element elementsForName:@"mailtext"] objectAtIndex:0];
		
		dataModal.regionID_                     = [ele_reid stringValue];
		dataModal.sendUID_                      = [ele_companyid stringValue];
		dataModal.sendName_                     = [ele_companyName stringValue];
		dataModal.sendDate_                     = [ele_date stringValue];
		dataModal.mailText_                     = [ele_text stringValue];
		
		[dataArr_ addObject:dataModal];
	}
    
}

//面试通知状态更改
-(void) parserUpdateResumeNotifiStatusXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updateMyBoxStatusResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements ) {
        NSString *keyStr    = [[[element elementsForName:@"key"] objectAtIndex:0] stringValue];
        NSString *valueStr  = [[[element elementsForName:@"value"] objectAtIndex:0] stringValue];
        
        if( [keyStr isEqualToString:@"newmail"] )
        {
            if( valueStr && [valueStr isEqualToString:@"1"] )
            {
                dataModal.status_ = @"OK";
            }
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//面试通知
-(void) parserResumeNotifiXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getMyBoxListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            ResumeNotifi_DataModal *dataModal = [[[ResumeNotifi_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    
                    NSString *keyStr = [key stringValue];
                    NSString *valueStr = [value stringValue];
                    
                    if( [keyStr isEqualToString:@"uid"] )
                    {
                        dataModal.companyID_ = valueStr;
                    }
                    
                    if( [keyStr isEqualToString:@"cname"] )
                    {
                        dataModal.companyName_ = valueStr;
                    }
                    
                    if( [keyStr isEqualToString:@"sdate"] )
                    {
                        dataModal.updateTime_ = valueStr;
                    }
                    
                    if( [keyStr isEqualToString:@"newmail"] )
                    {
                        dataModal.mailFlag_ = valueStr;
                    }
                    
                    if( [keyStr isEqualToString:@"id"] )
                    {
                        dataModal.boxID_ = valueStr;
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
        }
    }
}

//解析订阅列表
-(void) parserSubscribeListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getSubscribeListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            Subscribe_DataModal *dataModal = [[[Subscribe_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"subscribe_id"] )
                    {
                        dataModal.subscribeId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"person_id"] )
                    {
                        dataModal.personId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"school_id"] )
                    {
                        
                        dataModal.sId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"school_name"] )
                    {
                        dataModal.sname_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"campany_id"] )
                    {
                        dataModal.cId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"campany_name"] )
                    {
                        dataModal.cname_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"region_id"] )
                    {
                        dataModal.regionId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"subscribe_type"] )
                    {
                        dataModal.subscribeType_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"have_new_msg_flag"] )
                    {
                        dataModal.bHaveNewMsg_ = atoi([valueStr UTF8String]);
                    }
                    
                    if( [[key stringValue] isEqualToString:@"total_cnt"] )
                    {
                        dataModal.msgCnt_ = valueStr;
                    }
                    
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//解析删除某订阅
-(void) parserDelSubscribeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:delSubscribeResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//面试通知数
-(void) parserResumeNotifiCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//data" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{        
        CountInfo_DataModal *dataModal		= [[[CountInfo_DataModal alloc] init] autorelease];
		GDataXMLElement *ele_count			= [[element elementsForName:@"cnt"] objectAtIndex:0];
		GDataXMLElement *ele_type			= [[element elementsForName:@"type"] objectAtIndex:0];
		
		dataModal.count_                    = [ele_count stringValue];
		dataModal.type_						= [ele_type stringValue];
		
		[dataArr_ addObject:dataModal];
    }
}

//职位申请数
-(void) parserApplyCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    [self parserResumeNotifiCountXML:xmlData strData:strData parserType:parserType];
}

//简历被公司查看数
-(void) parserBeCompanyLookedCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    [self parserResumeNotifiCountXML:xmlData strData:strData parserType:parserType];
}

//职位收藏数
-(void) parserFavCountXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    [self parserResumeNotifiCountXML:xmlData strData:strData parserType:parserType];
}

//刷新简历
-(void) parserRefreshResumeXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{    
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:refreshResumeResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析更新个人图像
-(void) parserUpdatePersonImageXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:uploadimgCodeResponse/return/item" error:&err];

    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"info"] )
        {
            if( [dataModal.status_ isEqualToString:@"OK"] )
            {
                dataModal.id_ = valueStr;
            }else
            {
                dataModal.msg_ = valueStr;
            }
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//解析删除个人图像
-(void) parserDeletePersonImageXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:delteleMypicResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        if( [keyStr isEqualToString:@"info"] )
        {
            if( [dataModal.status_ isEqualToString:@"OK"] )
            {
                dataModal.id_ = valueStr;
            }else
            {
                dataModal.msg_ = valueStr;
            }
            
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//更新联系方式
-(void) parserUpdateContactXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    [self parserUpdateResumeSercetStatusXML:xmlData strData:strData parserType:parserType];
}

//获取教育背景
-(void) parserGetResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPersonEduDetailResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        EduResume_DataModal *dataModal = [[[EduResume_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"edusId"] )
                {
                    dataModal.id_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.id_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"personId"] )
                {
                    dataModal.personId_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.personId_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"startdate"] )
                {
                    dataModal.startDate_                  = [value substringToIndex:7];
                }
            }
            @catch (NSException *exception) {
                dataModal.startDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"stopdate"] )
                {
                    dataModal.endDate_                  = [value substringToIndex:7];
                }
            }
            @catch (NSException *exception) {
                dataModal.endDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"school"] )
                {
                    dataModal.school_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.school_                  = nil;
            }
            
            @try {
                if( [key isEqualToString:@"eduId"] )
                {
                    dataModal.eduId_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.eduId_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"zye"] )
                {
                    dataModal.zye_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.zye_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"zym"] )
                {
                    dataModal.zym_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.zym_                      = nil;
            }
            
            
            @try {
                if( [key isEqualToString:@"edus"] )
                {
                    dataModal.des_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.des_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"istonow"] )
                {
                    dataModal.bToNow_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bToNow_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"isshow"] )
                {
                    dataModal.bShow_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bShow_                      = nil;
            }
        }
        
        [dataArr_ addObject:dataModal];
    }
}


-(void) parserUpdateResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePersonEduDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        NSString *bOK               = [element stringValue];
        
        if( [bOK intValue] >= 0 )
        {
            dataModal.status_ = Request_OK;
        }
        
        [dataArr_ addObject:dataModal];
    }
}


-(void) parserAddResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:insertPersonEduDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        NSString *bOK               = [element stringValue];
        
        if( [bOK intValue] > 0 )
        {
            dataModal.status_ = Request_OK;
            dataModal.id_ = bOK;
        }
        
        [dataArr_ addObject:dataModal];
    }
}


-(void) parserDelResumeEduXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deletePersonEduDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{        
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        GDataXMLElement *bOK                = [[element attributes] objectAtIndex:0];
        
        if( [[bOK stringValue] isEqualToString:@"true"])
        {
            dataModal.status_ = Request_OK;
        }else
            dataModal.status_ = nil;
        
        [dataArr_ addObject:dataModal];
    }
}

//获取工作经历
-(void) parserGetResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPersonWorkDetailResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        WorkResume_DataModal *dataModal = [[[WorkResume_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"workId"] )
                {
                    dataModal.workId_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.workId_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"personId"] )
                {
                    dataModal.personId_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.personId_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"startdate"] )
                {
                    dataModal.startDate_                  = [value substringToIndex:7];
                }
            }
            @catch (NSException *exception) {
                dataModal.startDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"stopdate"] )
                {
                    dataModal.endDate_                  = [value substringToIndex:7];
                }
            }
            @catch (NSException *exception) {
                dataModal.endDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"company"] )
                {
                    dataModal.companyName_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.companyName_                  = nil;
            }
            
            @try {
                if( [key isEqualToString:@"companykj"] )
                {
                    dataModal.bCompanySercet_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bCompanySercet_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"yuangong"] )
                {
                    dataModal.yuangong_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.yuangong_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"cxz"] )
                {
                    dataModal.cxz_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.cxz_                      = nil;
            }
            
            
            @try {
                if( [key isEqualToString:@"jtzw"] )
                {
                    dataModal.zwName_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.zwName_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"jtzwtype"] )
                {
                    dataModal.zw_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.zw_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"workdesc"] )
                {
                    dataModal.des_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.des_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"salaryyear"] )
                {
                    dataModal.yearSalary_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.yearSalary_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"salarymonth"] )
                {
                    dataModal.monthSalary_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.monthSalary_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"yearbonus"] )
                {
                    dataModal.yearBouns_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.yearBouns_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"salaryKj"] )
                {
                    dataModal.bSalarySercet_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bSalarySercet_                      = nil;
            }
            
            
            @try {
                if( [key isEqualToString:@"isforeign"] )
                {
                    dataModal.bOversea_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bOversea_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"istonow"] )
                {
                    dataModal.bToNow_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bToNow_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"isshow"] )
                {
                    dataModal.bShow_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bShow_                      = nil;
            }
        }
        
        if( dataModal.bShow_ && [dataModal.bShow_ isEqualToString:@"1"] )
        {
            [dataArr_ addObject:dataModal];
        }else
        {
            
        }
    }
}

-(void) parserUpdateResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePersonWorkDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        NSString *bOK               = [element stringValue];
        
        if( [bOK intValue] >= 0 )
        {
            dataModal.status_ = Request_OK;
            //dataModal.id_ = [[NSString alloc] initWithString:bOK];
        }
        
        [dataArr_ addObject:dataModal];
    }
}


-(void) parserAddResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;    
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:insertPersonWorkDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        NSString *bOK               = [element stringValue];
        
        if( [bOK intValue] > 0 )
        {
            dataModal.status_ = Request_OK;
            dataModal.id_ = bOK;
        }
        
        [dataArr_ addObject:dataModal];
    }
}

//删除工作经历
-(void) parserDelResumeWorkXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deletePersonWorkDetailResponse/return" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        
        GDataXMLElement *bOK                = [[element attributes] objectAtIndex:0];
        
        if( [[bOK stringValue] isEqualToString:@"true"])
        {
            dataModal.status_ = Request_OK;
        }else
            dataModal.status_ = nil;
        
        [dataArr_ addObject:dataModal];
    }
}

//获取证书
-(void) parserGetResumeCerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getObjectListResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        CerResume_DataModal *dataModal = [[[CerResume_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"id"] )
                {
                    dataModal.id_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.id_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"uid"] )
                {
                    dataModal.uid_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.uid_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"Years"] )
                {
                    dataModal.year_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.year_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"Months"] )
                {
                    dataModal.month_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.month_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"CertName"] )
                {
                    dataModal.cerName_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.cerName_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"Scores"] )
                {
                    dataModal.scores_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.scores_                      = nil;
            }
        }
        
        
        [dataArr_ addObject:dataModal];
    }
}

-(void) parserAddResumeCerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updateResponse/return" error:&err];
    
    for (GDataXMLElement *element in docElements)
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];

        dataModal.status_ = Request_OK;

        [dataArr_ addObject:dataModal];
    }
}

-(void) parserDelResumeCerXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;	
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deleteObjResponse/return" error:&err];

    
    for ( GDataXMLElement *element in docElements )
	{
        PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
        NSString *bOK                = [element stringValue];
        
        if( [bOK intValue] > 0 )
        {
            dataModal.status_ = Request_OK;
        }
        
        [dataArr_ addObject:dataModal];
    }
}

//奖项列表
-(void) parserGetResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPersonAwardListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            AwardResume_DataModal *dataModal = [[[AwardResume_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"person_awardId"] )
                    {
                        dataModal.awardId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"personId"] )
                    {
                        dataModal.personId_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"person_awardate"] )
                    {
                        
                        dataModal.awardDate_ = valueStr;
                    }
                    
                    if( [[key stringValue] isEqualToString:@"person_awardesc"] )
                    {
                        dataModal.awardDesc_ = valueStr;
                    }
                    
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}


//新增奖项
-(void) parserAddResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addPersonAwardResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

-(void) parserUpdateResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePersonAwardResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

-(void) parserDelResumeAwardXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deletePersonAwardResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//学生干部经历
-(void) parserGetStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPersonStudentLeaderDetailResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        LeaderResume_DataModal *dataModal = [[[LeaderResume_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"person_studengLeaderId"] )
                {
                    dataModal.id_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.id_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"personId"] )
                {
                    dataModal.personId_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.personId_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_studentLeaderstartdate"] )
                {
                    dataModal.startDate_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.startDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_studentLeaderstopdate"] )
                {
                    dataModal.endDate_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.endDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_studentLeaderistonow"] )
                {
                    dataModal.bToNow_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bToNow_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_studentLeaderjob"] )
                {
                    dataModal.name_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.name_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_studentLeaderjobdesc"] )
                {
                    dataModal.des_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.des_                      = nil;
            }
        }
        
        
        [dataArr_ addObject:dataModal];
    }
}

-(void) parserAddStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addPersonStudentLeaderResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];

    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

-(void) parserUpdateStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePersonStudentLeaderResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

-(void) parserDelStudentLeaderXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deletePersonStudentLeaderDetailResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//项目活动经历
-(void) parserGetProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPersonProjectDetailResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        ProjectResume_DataModal *dataModal = [[[ProjectResume_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"person_projectId"] )
                {
                    dataModal.id_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.id_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"personId"] )
                {
                    dataModal.personId_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.personId_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_projectstartdate"] )
                {
                    dataModal.startDate_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.startDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_projectstopdate"] )
                {
                    dataModal.endDate_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.endDate_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_projectistonow"] )
                {
                    dataModal.bToNow_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.bToNow_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_projectName"] )
                {
                    dataModal.name_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.name_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_projectDesc"] )
                {
                    dataModal.des_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.des_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"person_projectGain"] )
                {
                    dataModal.gainDes_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.gainDes_                      = nil;
            }
        }
        
        
        [dataArr_ addObject:dataModal];
    }
}

-(void) parserAddProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addPersonProjectResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

-(void) parserUpdateProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:updatePersonProjectResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

-(void) parserDelProjectXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:deletePersonProjectDetailResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr                        = [key stringValue];
        NSString *valueStr                      = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }else if( [keyStr isEqualToString:@"insert_id"] )
        {
            dataModal.id_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//获取简历路径
-(void) parserResumePathXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    
    NSArray * docElements = [NSArray arrayWithArray:[doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getResumePathByMobileResponse/return" error:&err]];
    
    for ( GDataXMLElement *element in docElements )
	{        
        ResumePath_DataModal *dataModal = [[[ResumePath_DataModal alloc] init] autorelease];
        
        @try {
            dataModal.path_ = [element stringValue];
        }
        @catch (NSException *exception) {
            dataModal.path_ = nil;
        }
        @finally {
            
        }
        
        [dataArr_ addObject:dataModal];
    }
}

//获取个人信息
-(void) parserGetPersonInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
    NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPersonDetailResponse/return/item" error:&err];
    
    PersonDetailInfo_DataModal *dataModal = [[[PersonDetailInfo_DataModal alloc] init] autorelease];
    
    for ( GDataXMLElement *element in docElements )
	{
        @try {
            GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
            
            if( [[key stringValue] isEqualToString:PersonDetailInfo_UpdateTime] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.updateTime_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_phone] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.phone_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_qq] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.qq_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_http] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.http_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_posts] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.post_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_shouji] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.shouji_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_email] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.emial_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_address] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.address_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_pic] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.pic_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_kj] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.bCanLooked_ = [[value stringValue] intValue];
            }
            //date:2012-2-7 bruce
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_iname] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.iname_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_gznum] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.gznum_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_sex] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.sex_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_edu] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.edu_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:personDetailInfo_hka] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.hka_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_bday] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.bday_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_Region] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.region_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_zcheng] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.zcheng_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_marry] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.marray_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_zzmm] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.zzmm_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_mzhu] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.mzhu_ = [value stringValue];
            }
            //求职意向信息
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_jobtype] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.jobtype_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_job] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.job_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_jobs] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.jobs_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_job1] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.job1_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_city] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.city_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_gzdd1] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.gzdd1_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_gzdd5] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.gzdd5_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_workdate] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.worddate_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_yuex] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.yuex_ = [value stringValue];
            }
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_grzz] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.grzz_ = [value stringValue];
            }
            //教育背景
            //毕业院校
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_school] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.school_ = [value stringValue];
            }
            //毕业日期
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_byday] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.byday_ = [value stringValue];
            }
            //专业类别
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_zye] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.zye_ = [value stringValue];
            }
            //专业名称
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_zym] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.zym_ = [value stringValue];
            }
            //教育情况描述
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_edus] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.edus_ = [value stringValue];
            }
            //工作经验
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_gzjl] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.gzjl_ = [value stringValue];
            }
            //工作技能描述
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_othertc] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.othertc_ = [value stringValue];
            }
            //新旧简历标识
            else if( [[key stringValue] isEqualToString:PersonDetailInfo_isOld] )
            {
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.bOld_     = [[value stringValue] boolValue];
            }
            //求职状态
            else if( [[key stringValue] isEqualToString:@"resume_status"] ){
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.resumeStatus_     = [[value stringValue] intValue];
            }
            else if ([[key stringValue] isEqualToString:@"rctype"]){
                GDataXMLElement *value                    = [[element elementsForName:@"value"] objectAtIndex:0];
                dataModal.rcType_     = [value stringValue];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        
        
    }
    
    if( [docElements count] == 0 )
    {
        
    }else
        [dataArr_ addObject:dataModal];
}

//logo列表
-(void) parserLogoListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getAppLogoListResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        Logo_DataModal *dataModal = [[[Logo_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            @try {
                if( [key isEqualToString:@"id"] )
                {
                    dataModal.id_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.id_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"app_model_key"] )
                {
                    dataModal.modelKey_                   = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.modelKey_                       = nil;
            }
            
            @try {
                if( [key isEqualToString:@"logo_link_url"] )
                {
                    dataModal.url_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.url_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"logo_name"] )
                {
                    dataModal.name_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.name_                      = nil;
            }
            
            @try {
                if( [key isEqualToString:@"logo_path"] )
                {
                    dataModal.path_                  = value;
                }
            }
            @catch (NSException *exception) {
                dataModal.path_                      = nil;
            }
        }
        
        
        [dataArr_ addObject:dataModal];
    }
}

//附近的学校列表
-(void) parserNearSchoolListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getNearSchoolListResponse/return/item" error:&err];
    
    for ( GDataXMLElement *element in docElements )
	{
        School_DataModal *dataModal = [[[School_DataModal alloc] init] autorelease];
        
        NSArray *items = [element elementsForName:@"item"];
        
        for ( id obj in items )
        {
            NSString *key;
            NSString *value;
            @try {
                GDataXMLElement *item = obj;
                key = [[[item elementsForName:@"key"] objectAtIndex:0] stringValue];
                value = [[[item elementsForName:@"value"] objectAtIndex:0] stringValue];
            }
            @catch (NSException *exception) {
                continue;
            }
            @finally {
                //NSLog(@"key:%@ value:%@\n",key,value);
            }
            
            if( [key isEqualToString:@"id"] )
            {
                dataModal.id_           = value;
            }
            else if( [key isEqualToString:@"regionid"] )
            {
                dataModal.regionId_     = value;
            }
            else if( [key isEqualToString:@"schoolname"] )
            {
                dataModal.name_         = value;
            }
            else if( [key isEqualToString:@"logopath"] )
            {
                dataModal.logoPath_     = value;
            }
            else if( [key isEqualToString:@"empweb"] )
            {
                dataModal.empWeb_       = value;
            }
            else if( [key isEqualToString:@"latnum"] )
            {
                dataModal.lat_       = [value floatValue];
            }
            else if( [key isEqualToString:@"longnum"] )
            {
                dataModal.lng_       = [value floatValue];
            }
            else if( [key isEqualToString:@"attention_flag"] ){
                dataModal.bAttention_ = [value boolValue];
            }
        }
        
        
        [dataArr_ addObject:dataModal];
    }
}

//关注的学校
-(void) parserAttentionSchoolListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getMyAttentionSchoolListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            School_DataModal *dataModal = [[[School_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"id"] )
                    {
                        dataModal.beAttentionId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"school_id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"school_name"] )
                    {
                        dataModal.name_ = valueStr;
                    }                    
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
            
        }
        
        
    }
}

//取消关注
-(void) parserCancelAttentionSchoolXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:cancelSchoolAttentionResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//添加关注
-(void) parserAddAttentionSchoolXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:addSchoolAttentionResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//学校相关信息
-(void) parserSchoolInfoListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getMyInfoListResponse/return/item" error:&err];
    
    if( !docElements || [docElements count] == 0 ){
        docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getSchoolInfoListResponse/return/item" error:&err];
    }
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        NSArray *valueArr = [element elementsForName:@"value"];
        GDataXMLElement *itemEle = [valueArr objectAtIndex:0];
        NSArray	*itemArr = [itemEle elementsForName:@"item"];
        for ( GDataXMLElement *element in itemArr )
        {
            GDataXMLElement *keyEle = [[element elementsForName:@"key"] objectAtIndex:0];
            
            if( [[keyEle stringValue] isEqualToString:@"NewMsgInfo"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                GDataXMLElement *valueElement = [subElements objectAtIndex:0];
                NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
                
                for ( GDataXMLElement *element in valueElementArr )
                {
                    //key = data
                    SchoolInfo_DataModal *dataModal = [[[SchoolInfo_DataModal alloc] init] autorelease];
                    dataModal.totalCnt_ = sumCount;
                    dataModal.pageCnt_ = pageCount;
                    dataModal.type_ = Info_PublisherType;
                    Publisher_DataModal *publisherDataModal = [[[Publisher_DataModal alloc] init] autorelease];
                    dataModal.publisherDataModal_ = publisherDataModal;
                    
                    NSArray *items = [element elementsForName:@"item"];
                    for ( GDataXMLElement *element in items ) {
                        @try {
                            GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                            GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                            NSString                                *valueStr = [value stringValue];
                            
                            if( [[key stringValue] isEqualToString:@"publisher_id"] )
                            {
                                publisherDataModal.id_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"publisher_id_type"] )
                            {
                                publisherDataModal.publisherIdType_ = [valueStr intValue];
                            }
                            else if( [[key stringValue] isEqualToString:@"new_cnt"] )
                            {
                                publisherDataModal.newMsgCnt_ = [valueStr intValue];
                            }
                            else if( [[key stringValue] isEqualToString:@"name"] )
                            {
                                publisherDataModal.name_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"pic"] )
                            {
                                publisherDataModal.pic_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"title"] )
                            {
                                publisherDataModal.title_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"date_des"] )
                            {
                                publisherDataModal.dateDes_ = valueStr;
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        
                    }
                    
                    [dataArr_ addObject:dataModal];
                    
                }
            }
            else if( [[keyEle stringValue] isEqualToString:@"SchoolInfo"] ){
                
                NSArray	*subElements = [element elementsForName:@"value"];
                GDataXMLElement *valueElement = [subElements objectAtIndex:0];
                NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
                
                for ( GDataXMLElement *element in valueElementArr )
                {
                    //key = data
                    SchoolInfo_DataModal *dataModal = [[[SchoolInfo_DataModal alloc] init] autorelease];
                    dataModal.type_ = Info_EventType;
                    dataModal.totalCnt_ = sumCount;
                    dataModal.pageCnt_ = pageCount;
                    
                    //key = data
                    Event_DataModal *eventDataModal = [[[Event_DataModal alloc] init] autorelease];
                    dataModal.eventDataModal_ = eventDataModal;
                    
                    NSArray *items = [element elementsForName:@"item"];
                    for ( GDataXMLElement *element in items ) {
                        @try {
                            GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                            GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                            NSString                                *valueStr = [value stringValue];
                            
                            if( [[key stringValue] isEqualToString:@"id"] )
                            {
                                eventDataModal.id_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"regionid"] )
                            {
                                eventDataModal.regionId_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"title"] )
                            {
                                eventDataModal.title_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"sname"] )
                            {
                                eventDataModal.sname_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"sid"] )
                            {
                                eventDataModal.sid_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"cname"] )
                            {
                                eventDataModal.cname_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"cid"] )
                            {
                                eventDataModal.cid_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"sdate"] )
                            {
                                eventDataModal.sdate_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"addr"] )
                            {
                                eventDataModal.addr_ = valueStr;
                            }
                            else if( [[key stringValue] isEqualToString:@"have_add"] ){
                                eventDataModal.bHaveAdd_ = [valueStr intValue];
                            }
                            else if( [[key stringValue] isEqualToString:@"school_attention_cnt"] ){
                                eventDataModal.attentionCnt_ = [valueStr intValue];
                            }
                            else if( [[key stringValue] isEqualToString:@"type"] ){
                                int type = [valueStr intValue];
                                if( type == 10 ){
                                    eventDataModal.eventType_ = Event_Seminar;
                                }else if( type == 20 ){
                                    eventDataModal.eventType_ = Event_Recruitment;
                                }
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        
                    }
                    
                    [dataArr_ addObject:dataModal];
                }
            }
        }
    }
}

//我的消息
-(void) parserMyMsgListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getMyMsgListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            Publisher_DataModal *dataModal = [[[Publisher_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"publisher_id"] )
                    {
                        dataModal.id_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"publisher_id_type"] )
                    {
                        dataModal.publisherIdType_ = [valueStr intValue];
                    }
                    else if( [[key stringValue] isEqualToString:@"name"] )
                    {
                        dataModal.name_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"pic"] )
                    {
                        dataModal.pic_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"title"] )
                    {
                        dataModal.title_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"date_des"] )
                    {
                        dataModal.dateDes_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"new_cnt"] )
                    {
                        dataModal.newMsgCnt_ = [valueStr intValue];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
        }
    }
}

//发布者下的消息列表
-(void) parserPublisherMsgListXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getPublisherMsgListResponse/return/item" error:&err];
    
    int sumCount = 0;
    int pageCount = 0;
    
    //分页信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            
            if( [[key stringValue] isEqualToString:@"pageparam"] )
            {
                NSArray	*subElements = [element elementsForName:@"value"];
                for ( GDataXMLElement *element in subElements ) {
                    
                    NSArray *items = [element elementsForName:@"item"];
                    
                    for ( GDataXMLElement *child in items ) {
                        GDataXMLElement *key = [[child elementsForName:@"key"] objectAtIndex:0];
                        
                        @try {
                            //总数
                            if( [[key stringValue] isEqualToString:@"sums"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                sumCount = [[value stringValue] intValue];
                            }
                            
                            //分页数
                            if( [[key stringValue] isEqualToString:@"pages"] )
                            {
                                GDataXMLElement *value = [[child elementsForName:@"value"] objectAtIndex:0];
                                pageCount = [[value stringValue] intValue];
                            }
                        }
                        @catch (NSException *exception) {
                            
                        }
                        @finally {
                            
                        }
                        
                    }
                }
            }
            
            continue;
        }
    }
    
    //data
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        
        if( ![[key stringValue] isEqualToString:@"data"] )
        {
            continue;
        }
        
        
        NSArray	*subElements = [element elementsForName:@"value"];
        GDataXMLElement *valueElement = [subElements objectAtIndex:0];
        NSArray	*valueElementArr = [valueElement elementsForName:@"item"];
        
        for ( GDataXMLElement *element in valueElementArr )
        {
            //key = data
            MsgDetail_DataModal *dataModal = [[[MsgDetail_DataModal alloc] init] autorelease];
            dataModal.totalCnt_ = sumCount;
            dataModal.pageCnt_ = pageCount;
            
            NSArray *items = [element elementsForName:@"item"];
            for ( GDataXMLElement *element in items ) {
                @try {
                    GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
                    GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
                    NSString                                *valueStr = [value stringValue];
                    
                    if( [[key stringValue] isEqualToString:@"msg_id"] )
                    {
                        dataModal.msgId_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"update_datetime"] )
                    {
                        dataModal.dateTimeDes_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"title"] )
                    {
                        dataModal.title_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"pic"] )
                    {
                        dataModal.pic_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"summary"] )
                    {
                        dataModal.summary_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"link_url"] )
                    {
                        dataModal.linkUrl_ = valueStr;
                    }
                    else if( [[key stringValue] isEqualToString:@"link_type"] )
                    {
                        dataModal.type_ = [valueStr intValue];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }
            
            if( [subElements count] == 0 )
            {
                
            }else
                [dataArr_ addObject:dataModal];
        }
    }
}

//消息内容
-(void) parserMsgContentXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getMsgContentResponse/return/item" error:&err];
    
    PreStatus_DataModal *dataModal = [[[PreStatus_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"status"] )
        {
            dataModal.status_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"code"] )
        {
            dataModal.code_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"status_desc"] )
        {
            dataModal.msg_ = valueStr;
        }
        else if( [keyStr isEqualToString:@"content"] )
        {
            dataModal.detail_ = valueStr;
        }
    }
    
    [dataArr_ addObject:dataModal];
}

//我的数量信息
-(void) parserMyCntInfoXML:(NSData *)xmlData strData:(NSString *)strData parserType:(XMLParserType)parserType
{
    NSError *err = nil;
	NSArray	*docElements = [doc_.rootElement nodesForXPath:@"//SOAP-ENV:Body/ns1:getCntInfoResponse/return/item" error:&err];
    
    MyCntInfo_DataModal *dataModal = [[[MyCntInfo_DataModal alloc] init] autorelease];
    
    //成功与否信息
    for ( GDataXMLElement *element in docElements )
	{
        GDataXMLElement *key                    = [[element elementsForName:@"key"] objectAtIndex:0];
        GDataXMLElement *value                  = [[element elementsForName:@"value"] objectAtIndex:0];
        
        NSString *keyStr = [key stringValue];
        NSString *valueStr = [value stringValue];
        
        if( [keyStr isEqualToString:@"xjh_cnt"] )
        {
            dataModal.xjhCnt_ = [valueStr intValue];
        }
        else if( [keyStr isEqualToString:@"zph_cnt"] )
        {
            dataModal.zphCnt_ = [valueStr intValue];
        }
        else if( [keyStr isEqualToString:@"msg_cnt"] )
        {
            dataModal.msgCnt_ = [valueStr intValue];
        }
    }
    
    [dataArr_ addObject:dataModal];
}

@end
