//
//  PreCommonRequest.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-5.
//
//

#ifndef ClientTemplate_PreCommonRequest_h
#define ClientTemplate_PreCommonRequest_h

//请求的操时时间
#define Request_TimeOut_Seconds                     20

//职位搜索
#define JobSearchBaseURL							@"http://www.job1001.com/3g/index.php?mode=index&doaction=SearchResult&detail="
//#define JobSearchBaseURL							@"http://192.168.60.201/3g/index.php?mode=index&doaction=SearchResult&detail="

//--------------------Job URL Detail--------------------//
#define JobSearch_CompanyDetailURL					@"http://www.job1001.com/3g/index.php?mode=index&doaction=Company_Detail_xml"
#define JobSearch_ComapnyDetailURL_CompanyParam		@"CompanyDetail"

#define	JobSearch_JobDetailURL						@"http://www.job1001.com/3g/index.php?mode=index&doaction=Job_Detail_xml"
//#define	JobSearch_JobDetailURL						@"http://192.168.60.201/3g/index.php?mode=index&doaction=Job_Detail_xml"
#define JobSearch_JobDetailURL_JobParam				@"zwid"

#define	JobSearch_CompanyJobDetailURL				@"http://www.job1001.com/3g/index.php?mode=index&doaction=Job_Detail_List_xml"
#define JobSearch_CompanyJobDetailUR_JobParam		@"CompanyDetail"
//--------------------Job URL Detail--------------------//

//申请职位
#define JobSearch_ApplyJob_URL						@"http://www.job1001.com/myNew/main_3g.php?mode=index&doaction=sendResumeWeebox&detail=normal&regsource=iphone"
#define JobSearch_ApplyJob_CompanyDetail_Param		@"CompanyDetail="
#define JobSearch_ApplyJob_ZhaoPinDetail_Param		@"ZhoaPinDetail="
#define JobSearch_ApplyJob_JobName_Param			@"jobname="
#define JobSearch_ApplyJob_MyID_Param				@"uid="
#define JobSearch_ApplyJob_Enkey_Param				@"enkey="
#define JobSearch_ApplyJob_Prnd_Param				@"prnd="

//收藏职位
#define JobSearch_FavJob_URL						@"http://www.job1001.com/myNew/main_3g.php?mode=index&doaction=favoriteZw_3g"
#define JobSearch_FavJob_ZhaoPinDetail_Param		@"ZhoaPinDetail="
#define JobSearch_FavJob_MyID_Param					@"uid="
#define JobSearch_FavJob_Enkey_Param				@"enkey="
#define JobSearch_FavJob_Prnd_Param					@"prnd="


//获取版本信息
#ifndef __OPTIMIZE__
//调试模试
#define Version_URL                                 @"http://192.168.60.201/3g/index.php?mode=index&doaction=version"
#else
//Release模试
#define Version_URL                                 @"http://www.job1001.com/3g/index.php?mode=index&doaction=version"
#endif

#define Version_Type                                @"type="
#define Version_Phone_Numbe                         @"phone="
#define Version_Phone_Vserial                       @"serial="

//企业描述
#define JobSearch_CompanyDetailURL					@"http://www.job1001.com/3g/index.php?mode=index&doaction=Company_Detail_xml"
#define JobSearch_ComapnyDetailURL_CompanyParam		@"CompanyDetail"

//PersonResume URL(数量信息，比如申请数...)
#define PersonResume_Apply_Count_URL				@"http://www.job1001.com/myNew/main_3g.php?mode=index&doaction=personStatistics_xml&detail=personStatistics&location=applycount"
#define PersonResume_Fav_Count_URL					@"http://www.job1001.com/myNew/main_3g.php?mode=index&doaction=personStatistics_xml&detail=personStatistics&location=favoritecount"
#define PersonResume_Notifi_Count_URL				@"http://www.job1001.com/myNew/main_3g.php?mode=index&doaction=personStatistics_xml&detail=personStatistics&location=myboxcount"
#define PersonResume_CompanyLooked_Count_URL		@"http://www.job1001.com/myNew/main_3g.php?mode=index&doaction=personStatistics_xml&detail=personStatistics&location=companylookcount"

//申请记录
#define PersonResume_Apply_Detail_URL				@"http://www.job1001.com/myNew/main_3g.php?mode=jobs&doaction=myapply_xml&detail=list"

//收藏记录
#define PersonResume_Fav_Detail_URL					@"http://www.job1001.com/myNew/main_3g.php?mode=jobs&doaction=favoriteZw_xml&detail=list"

//面试通知
#define PersonResume_Notifi_Detail_URL				@"http://www.job1001.com/myNew/main_3g.php?mode=message&doaction=mybox_xml&detail=list"

//简历被公司查看
#define PersonResume_CompanyLooked_Detail_URL		@"http://www.job1001.com/myNew/main_3g.php?mode=message&doaction=companyLookResume_xml&detail=list"

//刷新简历
#define PersonResume_UpdateResume_URL				@"http://www.job1001.com/myNew/main_3g.php?mode=message&doaction=personRefresh_xml&column=updatetime"

//面试通知详情
#define ResumeNotifi_Detail_URL						@"http://www.job1001.com/myNew/main_3g.php?mode=message&doaction=myboxdetail_xml"
//#define ResumeNotifi_Detail_URL						@"http://192.168.60.201/myNew/main_3g.php?mode=message&doaction=myboxdetail_xml"
#define ResumeNotifi_Detail_UID_Param				@"uid="
#define ResumeNotifi_Detail_Enkey_Param				@"enkey="
#define ResumeNotifi_Detail_Prnd_Param				@"prnd="
#define ResumeNotifi_Detail_BoxID_Param				@"boxid="

//需要增加一些参数,比如请求申请记录，收藏记录等
#define PersonResume_Param_UID						@"uid="
#define PersonResume_Param_Key						@"enkey="
#define PersonResume_Param_Prnd						@"prnd="
#define PersonResume_Param_Page                     @"page="

//薪酬查询
#define SalaryQuary_URL                             @"http://www.job1001.com/app/baidu/salarysearch/showv2.php?fromwap=1"
#define SalaryQuary_Param_ZW_ParentId               @"searInfo[zw1]="
#define SalaryQuary_Param_ZW_SubId                  @"searInfo[zw2]="
#define SalaryQuary_Param_ShengId                   @"searInfo[sheng]="
#define SalaryQuary_Param_ShiId                     @"searInfo[shi]="
#define SalaryQuary_Param_EduId                     @"searInfo[eduId]="
#define SalaryQuary_Param_YearId                    @"searInfo[gznum]="
#define SalaryQuary_Param_CurrentSalary             @"searInfo[salary]="

#endif
