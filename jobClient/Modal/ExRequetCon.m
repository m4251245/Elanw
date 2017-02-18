//
//  ExRequetCon.m
//  MBA
//
//  Created by sysweal on 13-11-11.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "ExRequetCon.h"
#import "NSString+URLEncoding.h"

#import "ELSameTradePeopleFrameModel.h"
#import "ELSameTradePeopleModel.h"


@implementation RequestCon (Op)



//根据请求类型获取请求时的字符串,如果有,ctl会根据其实弹出阻断视图的效果
+(NSString *) getRequestStr:(RequestType)type
{
    NSString *str = nil;
    
    switch ( type ) {
        case Request_Login:
            str = @"正在登录";
            break;
        case Request_Register:
            str = @"正在注册";
            break;
        case Request_AddComment:
            str = @"正在提交";
            break;
        case Request_Follow:
            str = @"正在关注";
            break;
        case gunwenLoginWith:
        case Request_ValidUserName:
            str = @"正在登录...";
            break;
        case Request_CancelFollow:
            str = @"正在取消";
            break;
        case Request_SaveInfo:
            str = @"正在保存";
            break;
        case Request_JoinGroup:
            str = @"正在申请";
            break;
        case Request_SalaryRank:
            str = @"正在加载";
            break;
        case Request_ResetPwd:
            str = @"正在提交";
            break;
        case Request_GetAddtExpertComment:
            str = @"正在提交";
            break;
        case Request_RecommandJob:
            str = @"正在发送";
            break;
        case Request_FindPassword:
            str = @"正在提交";
            break;
        case Request_SetArticleLiked:
            str = @"正在提交";
            break;
        case Request_RegestPhone:
            str = @"正在发送请求";
            break;
        case Request_AskExpert:
            str = @"正在提交";
            break;
        case Request_joinPerson:
            str = @"";
            break;
        case Request_QuitGroup:
            str = @"正在请求";
            break;
        case Request_CheckVersion:
            str = @"正在检查更新";
            break;
        case Request_DeleteJobSubscribed:
            str = @"正在删除订阅";
            break;
        case Request_ResumeZbar:
            str = @"";
            break;
        case Request_CreateGroup:
            str = @"正在提交";
            break;
        case Request_GetGroupInfo:
            str = @"正在加载";
            break;
        case Request_InvitePeople:
            str = @"提交发送邀请";
            break;
        case Request_ApplyOneZw:
            str = @"正在申请";
            break;
        case Request_SetGroupPermission:
            str = @"正在保存";
            break;
        case Request_AskQuest:
            str = @"正在提交";
            break;
        case Request_FindPhonePwd:
            str = @"正在获取验证码";
            break;
        case Request_CheckCode:
            str = @"正在校验验证码";
            break;
        case Request_ResetPhonePwd:
            str = @"正在重置密码";
            break;
        case Request_UploadMyImg:
            str = @"正在上传";
            break;
        case Request_CollectPosition:
            str = @"正在收藏";
            break;
        case Request_RefreshResume:
            str = @"正在刷新";
            break;
        case Request_DeleteArticle:
            str = @"正在删除";
            break;
        case Request_GetResumePath:
            str = @"正在加载";
            break;
        case Request_GetTheSamePersonList:
            str = @"正在加载";
            break;
        case Request_AskCompanyHR:
            str = @"正在提交";
            break;
        case Request_AddEdusInfo:
            str = @"正在添加教育信息";
            break;
        case Request_GetEdusInfo:
            str = @"加载教育信息";
            break;
        case Request_UpdateEdusInfo:
            str = @"更新教育信息";
            break;
        case Request_UpdateNickName:
            str = @"正在提交";
            break;
        case Request_SubmitAnswerComment:
            str = @"正在提交";
            break;
        case Request_AddAttentionCompany:
            str = @"正在请求";
            break;
        case Request_UpdatePushSettings:
            str = @"";
            break;
        case Request_UpdatePushSet:
            str = @"";
            break;
        case Request_shareArticleDyanmic:
            str = @"";
            break;
        case Request_FeedBack:
            str = @"正在提交";
            break;
        case Request_addQuestionnaire:
            str = @"正在提交";
            break;
        case Request_CompanyLogin:
            str = @"正在登录";
            break;
        case Request_DoHRAnswer:
            str = @"正在提交";
            break;
        case Request_TranspondResume:
            str = @"正在转发简历";
            break;
        case Request_SendInterview:
            str = @"正在发送";
            break;
        case Request_AttendCareerSchool:
            str = @"正在请求";
            break;
        case Request_CancelBindCompany:
            str = @"正在请求";
            break;
        case Request_UploadVoiceFile:
            str = @"正在上传";
            break;
        case Request_AddResumeVoice:
            str = @"正在上传";
            break;
        case Request_AddResumePhoto:
            str = @"正在上传";
            break;
        case Request_UploadPhotoFile:
            str = @"正在上传";
            break;
        case Request_DeleteResumeImage:
            str = @"正在删除";
            break;
        case Request_SendMessage:
            str = @"正在发送";
            break;
        case Request_AnswerInterview:
            str = @"正在提交";
            break;
        case Request_AddGxsComment:
            str = @"正在提交";
            break;
        case Request_UpdateGroups:
            str = @"正在提交";
            break;
        case Request_SaveRecommendSet:
            str = @"正在设置";
            break;
        case Request_DeleteGroupArticle:
            str = @"正在删除";
            break;
        case Request_ToReport:
            str = @"正在提交";
            break;
        case Request_DownloadResume:
            str = @"正在下载";
            break;
        case Request_GetWXPrepayId:
            str = @"正在请求";
            break;
        case Request_GenShoppingCart:
            str = @"正在请求";
            break;
        case Request_getShareMessageOther:
            str = @"";
            break;
        case Request_GetArticleApply:
            str = @"";
            break;
        case gunwenJieBang:
            str = @"";
            break;
        case Request_GunwenLoadConstanct:
            str = @"正在下载";
            break;
        case Request_RecommendPerson:
            str = @"";
            break;
        case requestBingdingStatusWith:
            str = @"正在加载...";
            break;
        case Request_GetMyAccount:
            str = @"正在加载...";
            break;
        case Request_ADDJob:
            str = @"正在发布...";
            break;
        case Request_getLastTelTime:
            str = @"";
            break;
        case Request_GuwenCallPerson:
            str = @"拨打电话中";
            break;
        case Request_GunwenLoadResume:
            str = @"下载简历中";
            break;
//        case Request_DashangShoppingCart:
//            str = @"";
//            break;
            
        default:
            break;
    }
    
    return str;
}

//获取图片
-(void) loadImage:(NSString *)path
{
    //设置请求类型
    requestType_ = Request_Image;
    
    [self startConn:path bodyMsg:nil method:@"GET"];
}

//获取接口token
-(void) getAccessToken:(NSString *)user pwd:(NSString *)pwd time:(long)time
{
    //设置请求类型
    requestType_ = Request_GetAccessToken;
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"user=%@&pwd=%@&time=%lu&vflag=1",user,pwd,time];
    NSString *function = [CommonConfig getValueByKey:@"Init_Op" category:@"Op"];
    
    //发送请求
    NSString *op = [CommonConfig getValueByKey:@"Init_Table" category:@"Op"];
    [self startConn:[NSString stringWithFormat:@"%@&op=%@&func=%@",[RequestCon getBaseURL],op,function] bodyMsg:bodyMsg method:nil];
}

#pragma makr 验证用户名
- (void)doValidUserName:(NSString *)userName
{
    //设置请求类型
    requestType_ = Request_ValidUserName;
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"uname=%@",userName];
    NSString *function = @"checkUnameExists";
    NSString *op = @"person_info_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//登录
-(void) doLogin:(NSString *)user pwd:(NSString *)pwd
{
    //设置请求类型
    requestType_ = Request_Login;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"appflag"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"uname=%@&password=%@&loginflag=&person_self=&conditionArr=%@&",user,pwd,conditionStr];
    NSString *function = [CommonConfig getValueByKey:@"Login_Op" category:@"Op"];
    
    //发送请求
    NSString *op = [CommonConfig getValueByKey:@"User_Table" category:@"Op"];
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//注册手机号
-(void) regestPhone:(NSString *)phone
{
    //设置请求类型
    requestType_ = Request_RegestPhone;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"yl1001" forKey:@"type"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"mobile=%@&conditionArr=%@",phone,conditionStr];
    NSString *function = Table_Func_RegistPhone;
    NSString *op = Table_Op_RegistPhone;
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//注册
-(void) doRegister:(NSString*)uname  pwd:(NSString*)pwd  regSource:(NSString*)regSource verifyCode:(NSString*)verifyCode
{
    //设置请求类型
    requestType_ = Request_Register;
    
    //组装参数
    NSMutableDictionary * userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setObject:[NSString stringWithFormat:@"%@",uname] forKey:@"uname"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%@",pwd] forKey:@"password"];
    [userInfoDic setObject:[NSString stringWithFormat:@"%@",uname] forKey:@"mobile"];
    [userInfoDic setObject:@"0" forKey:@"tradeTotalid"];
    [userInfoDic setObject:@"1001" forKey:@"tradeid"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *userInfoStr = [jsonWriter stringWithObject:userInfoDic];
    
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",regSource] forKey:@"RegSource"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"mobile_code=%@&regtype=mobile&userInfo=%@&conditionArr=%@",verifyCode,userInfoStr,conditionStr];
    NSString *function = Table_Func_Regist;
    NSString *op = Table_Op_RegistPhone;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//设置推送
-(void) setSubscribeConfig:(NSString *)clientName clientVersion:(NSString *)clientVersion deviceId:(NSString *)deviceId deviceToken:(NSString *)deviceToken flagStr:(NSString *)flagStr startHour:(NSString *)startHour endHour:(NSString *)endHour betweenHour:(NSString *)betweenHour userId:(NSString *)userId
{
    requestType_ = Request_SetSubscribeConfig;
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:clientName forKey:@"clientName"];
    [paramDic setObject:clientVersion forKey:@"clientVersion"];
    [paramDic setObject:deviceId forKey:@"deviceId"];
    if (!deviceToken) {
        deviceToken = @"";
    }
    [paramDic setObject:deviceToken forKey:@"deviceToken"];
    [paramDic setObject:flagStr forKey:@"bOn"];
    [paramDic setObject:startHour forKey:@"startHour"];
    [paramDic setObject:endHour forKey:@"endHour"];
    [paramDic setObject:betweenHour forKey:@"betweenHour"];
    [paramDic setObject:userId forKey:@"userId"];
    [paramDic setObject:@"10" forKey:@"userIdType"];
    [paramDic setObject:@"10" forKey:@"processType"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWriter stringWithObject:paramDic];
    
    //设置请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"param=%@",paramStr];
    NSString *function = @"setSubscribeConfig";
    NSString *op = @"app_subscribe_config";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}


//保存个人信息
-(void)saveUserInfo:(NSString *)personId job:(NSString *)zw sex:(NSString *)sex pic:(NSString *)pic name:(NSString *)name trade:(NSString *)trade company:(NSString *)company nickname:(NSString *)nickname signature:(NSString *)signature personIntro:(NSString *)personIntro expertIntro:(NSString *)expertIntro hkaId:(NSString *)hkaId school:(NSString *)school zym:(NSString *)zym rctypeId:(NSString *)rctypeId regionStr:(NSString *)regionStr workAge:(NSString *)workage brithday:(NSString *)brithday
{
    requestType_ = Request_SaveInfo;
    
    //新接口
    NSString * bodyMsg = nil;
    @try {
        NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
        [updateDic setObject:personId forKey:@"person_id"];
        if (pic !=nil && ![pic isEqualToString:@""]) {
            [updateDic setObject:pic forKey:@"person_pic_personality"];
        }
        if (name !=nil && ![name isEqualToString:@""]) {
            [updateDic setObject:name forKey:@"person_iname"];
        }
        if (nickname !=nil && ![nickname isEqualToString:@""]) {
            [updateDic setObject:nickname forKey:@"person_nickname"];
        }
        if (sex !=nil && ![sex isEqualToString:@""]) {
            [updateDic setObject:sex forKey:@"person_sex"];
        }
        if (hkaId !=nil && ![hkaId isEqualToString:@""]) {
            [updateDic setObject:hkaId forKey:@"person_hka"];
        }
        if (zw !=nil && ![zw isEqualToString:@""]) {
            [updateDic setObject:zw forKey:@"person_zw"];
        }
        if (trade !=nil && ![trade isEqualToString:@""]) {
            [updateDic setObject:trade forKey:@"person_job_now"];
            
        }
        if (signature !=nil && ![signature isEqualToString:@""]) {
            [updateDic setObject:signature forKey:@"person_signature"];
        }
        if (company !=nil && ![company isEqualToString:@""]) {
            [updateDic setObject:company forKey:@"person_company"];
        }
        if (school !=nil && ![school isEqualToString:@""]) {
            [updateDic setObject:school forKey:@"school"];
            
        }
        if (zym !=nil && ![zym isEqualToString:@""]) {
            [updateDic setObject:zym forKey:@"zym"];
        }
        if (rctypeId !=nil && ![rctypeId isEqualToString:@""]) {
            [updateDic setObject:rctypeId forKey:@"rctypeId"];
        }
        if (regionStr !=nil && ![regionStr isEqualToString:@""]) {
            [updateDic setObject:regionStr forKey:@"regionid"];
        }
        if (workage !=nil && ![workage isEqualToString:@""]) {
            [updateDic setObject:workage forKey:@"person_gznum"];
        }
        if (brithday !=nil && ![brithday isEqualToString:@""]) {
            [updateDic setObject:brithday forKey:@"bday"];
        }
        if (personIntro !=nil && ![personIntro isEqualToString:@""]) {
            [updateDic setObject:personIntro forKey:@"grzz"];
        }
        if (expertIntro !=nil && ![expertIntro isEqualToString:@""]) {
            [updateDic setObject:expertIntro forKey:@"intro"];
        }
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        NSString *updateStr = [jsonWriter2 stringWithObject:updateDic];
        bodyMsg = [NSString stringWithFormat:@"data=%@",updateStr];
    }
    @catch (NSException *exception) {
        NSLog(@"error %@",exception);
    }
    @finally {
        
    }
    
    NSString * function = @"edit_card";
    NSString * op = @"person_info_api";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//保存个人信息 新接口
-(void)saveUserInfo:(NSString *)personId job:(NSString *)zw sex:(NSString *)sex pic:(NSString *)pic name:(NSString *)name trade:(NSString *)trade company:(NSString *)company nickname:(NSString *)nickname signature:(NSString *)signature hkaId:(NSString *)hkaId school:(NSString *)school zym:(NSString *)zym rctypeId:(NSString *)rctypeId regionStr:(NSString *)regionStr workAge:(NSString *)workage brithday:(NSString *)brithday tradeId:(NSString *)tradeId tradeName:(NSString *)tradeName;
{
    requestType_ = Request_SaveInfo;
    //新接口
    NSString * bodyMsg = nil;
    @try {
        NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
        if (!personId) {
            personId = @"";
        }
        [updateDic setObject:personId forKey:@"person_id"];
        if (pic !=nil && ![pic isEqualToString:@""]) {
            [updateDic setObject:pic forKey:@"pic"];
        }
        if (name !=nil && ![name isEqualToString:@""]) {
            [updateDic setObject:name forKey:@"person_iname"];
        }
        if (nickname !=nil && ![nickname isEqualToString:@""]) {
            [updateDic setObject:nickname forKey:@"person_nickname"];
        }
        if (sex !=nil && ![sex isEqualToString:@""]) {
            [updateDic setObject:sex forKey:@"person_sex"];
        }
        if (hkaId !=nil && ![hkaId isEqualToString:@""]) {
            [updateDic setObject:hkaId forKey:@"person_hka"];
        }
        if (zw !=nil && ![zw isEqualToString:@""]) {
            [updateDic setObject:zw forKey:@"person_zw"];
        }
        if (trade !=nil && ![trade isEqualToString:@""]) {
            [updateDic setObject:trade forKey:@"person_job_now"];
            
        }
        if (signature !=nil && ![signature isEqualToString:@""]) {
            [updateDic setObject:signature forKey:@"person_signature"];
        }
        if (company !=nil && ![company isEqualToString:@""]) {
            [updateDic setObject:company forKey:@"person_company"];
        }
        if (school !=nil && ![school isEqualToString:@""]) {
            [updateDic setObject:school forKey:@"school"];
            
        }
        if (zym !=nil && ![zym isEqualToString:@""]) {
            [updateDic setObject:zym forKey:@"zym"];
        }
        if (rctypeId !=nil && ![rctypeId isEqualToString:@""]) {
            [updateDic setObject:rctypeId forKey:@"rctypeId"];
        }
        if (regionStr !=nil && ![regionStr isEqualToString:@""]) {
            [updateDic setObject:regionStr forKey:@"regionid"];
        }
        if (workage !=nil && ![workage isEqualToString:@""]) {
            [updateDic setObject:workage forKey:@"person_gznum"];
        }
        if (brithday !=nil && ![brithday isEqualToString:@""]) {
            [updateDic setObject:brithday forKey:@"bday"];
        }
        
        //新增行业编号
        if (tradeId !=nil && ![tradeId isEqualToString:@""]) {
            [updateDic setObject:tradeId forKey:@"tradeid"];
            //校验码 $data['cks'] 校验码,产生方法：md5($person_id . 'ChooseTrade' . $tradeid)
            NSString *md5str = [MD5 getMD5:[NSString stringWithFormat:@"%@ChooseTrade%@", personId, tradeId]];
            [updateDic setObject:md5str forKey:@"cks"];
            if (tradeName !=nil && ![tradeName isEqualToString:@""]){//自定义
                [updateDic setObject:tradeName forKey:@"tradeName"];
            }
        }else{
            if (tradeName !=nil && ![tradeName isEqualToString:@""]){//自定义
                [updateDic setObject:tradeName forKey:@"tradeName"];
            }
        }
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        NSString *updateStr = [jsonWriter2 stringWithObject:updateDic];
        bodyMsg = [NSString stringWithFormat:@"data=%@",updateStr];
    }
    @catch (NSException *exception) {
        NSLog(@"error %@",exception);
    }
    @finally {
        
    }
    
    NSString * function = @"edit_card";
    NSString * op = @"person_info_api";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//获取薪闻信息
-(void) getNewsList:(NSInteger)pageIndex  pagesize:(NSInteger)pageSize  catagory:(NSString*)catId
{
    requestType_ = Request_GetNews;
    
    //组装参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%d",30] forKey:@"clen"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = Table_Func_GetNewsList;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//获取文章详情
-(void) getArticleDetail:(NSString*)articleId
{
    requestType_ = Request_GetArticleDetail;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"1"] forKey:@"change_v_cnt"];
    [conditionDic setObject:@"1" forKey:@"strip_tags"];
    [conditionDic setObject:@"1" forKey:@"filter_field"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:@"1" forKey:@"get_favorite_flag"];
    if ([Manager getUserInfo].userId_) {
        [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&conditionArr=%@",articleId,conditionStr];
    NSString * function = Table_Func_GetArticleDetail;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取薪闻详情内的推荐行家
-(void)getRecommendExpertInNews
{
    requestType_ = Request_NewsRecommendExpert;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@" "];
    NSString * function = Table_Func_GetNewsRecommendExpert;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取群聊记录列表
-(void)getGroupChatList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize article:(NSString*)articleId parentId:(NSString *)parentId userId:(NSString *)userId
{
    requestType_ = Request_GroupChatList;
    
    if (!userId) {
        userId = @"";
    }
    //组装参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"all" forKey:@"mode"];
    [conditionDic setObject:@1 forKey:@"get_person_flag"];
    [conditionDic setObject:@1 forKey:@"get_parent_comment"];
    [conditionDic setObject:@1 forKey:@"get_parent_comment_person"];
    [conditionDic setObject:articleId forKey:@"article_id"];
    [conditionDic setObject:userId forKey:@"handle_permission"];
    [conditionDic setObject:@1 forKey:@"get_content_img_flag"];//返回评论的图片
    
    if( parentId && ![parentId isEqualToString:@""] ){
        [conditionDic setObject:[NSString stringWithFormat:@"%@",parentId] forKey:@"parent_id"];
    }
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition=%@",conditionStr];
    NSString * function = Table_Func_GetCommentList;
    NSString * op = @"comm_comment_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//获取文章评论列表
-(void)getCommentList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize article:(NSString*)articleId parentId:(NSString *)parentId userId:(NSString *)userId
{
    requestType_ = Request_CommentList;
    
    
    if (!userId) {
        userId = @"";
    }
    //组装参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"all" forKey:@"mode"];
    [conditionDic setObject:@1 forKey:@"get_person_flag"];
    [conditionDic setObject:@1 forKey:@"get_parent_comment"];
    [conditionDic setObject:@1 forKey:@"get_parent_comment_person"];
    [conditionDic setObject:articleId forKey:@"article_id"];
    [conditionDic setObject:userId forKey:@"handle_permission"];
    [conditionDic setObject:@1 forKey:@"get_content_img_flag"];//返回评论的图片
    
    if( parentId && ![parentId isEqualToString:@""] ){
        [conditionDic setObject:[NSString stringWithFormat:@"%@",parentId] forKey:@"parent_id"];
    }
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition=%@",conditionStr];
    NSString * function = Table_Func_GetCommentList;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//获取评论列表old
-(void)getCommentList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize  article:(NSString*)articleId parentId:(NSString *)parentId
{
    requestType_ = Request_CommentListOld;
    
    //组装参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"1" forKey:@"re_author"];
    [conditionDic setObject:@"false" forKey:@"re_child_comment"];
    [conditionDic setObject:articleId forKey:@"article_id"];
    if( parentId && ![parentId isEqualToString:@""] )
        [conditionDic setObject:[NSString stringWithFormat:@"%@",parentId] forKey:@"parent_id"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition=%@",conditionStr];
    NSString * function = Table_Func_GetCommentList;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//添加评论
-(void) addComment:(NSString *)objectId parentId:(NSString *)parentId userId:(NSString *)userId content:(NSString *)content  proID:(NSString*)proid
{
    //设置请求类型
    requestType_ = Request_AddComment;
    
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    content = [MyCommon utf8ToUnicode:content];
    //组装分页参数
    NSMutableDictionary *insertDic = [[NSMutableDictionary alloc] init];
    [insertDic setObject:[NSString stringWithFormat:@"%@",objectId] forKey:@"article_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"user_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    if( parentId && ![parentId isEqualToString:@""] )
        [insertDic setObject:[NSString stringWithFormat:@"%@",parentId] forKey:@"parent_id"];
    if (proid && ![proid isEqualToString:@""]) {
        [insertDic setObject:proid forKey:@"pro_id"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:insertDic];
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"insertArr=%@",insertStr];
    NSString *op = @"comm_comment";
    NSString *function = @"addArticleComment";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//公司群添加评论
-(void) addComment:(NSString *)objectId parentId:(NSString *)parentId userId:(NSString *)userId content:(NSString *)content  proID:(NSString*)proid insider:(NSString *)insider
{
    //设置请求类型
    requestType_ = Request_AddComment;
    
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    content = [MyCommon utf8ToUnicode:content];
    //组装分页参数
    NSMutableDictionary *insertDic = [[NSMutableDictionary alloc] init];
    [insertDic setObject:[NSString stringWithFormat:@"%@",objectId] forKey:@"article_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"user_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    [insertDic setObject:insider forKey:@"insider"];
    if( parentId && ![parentId isEqualToString:@""] )
        [insertDic setObject:[NSString stringWithFormat:@"%@",parentId] forKey:@"parent_id"];
    if (proid && ![proid isEqualToString:@""]) {
        [insertDic setObject:proid forKey:@"pro_id"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:insertDic];
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"insertArr=%@",insertStr];
    NSString *op = @"comm_comment_busi";
    NSString *function = @"addArticleComment";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 匿名发表灌薪水评论
-(void) addComment:(NSString *)objectId parentId:(NSString *)parentId userId:(NSString *)userId content:(NSString *)content  proID:(NSString*)proid clientId:(NSString *)clientId
{
    //设置请求类型
    requestType_ = Request_AddGxsComment;
    
    //组装分页参数
    NSMutableDictionary *insertDic = [[NSMutableDictionary alloc] init];
    [insertDic setObject:[NSString stringWithFormat:@"%@",objectId] forKey:@"article_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"user_id"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    [insertDic setObject:[NSString stringWithFormat:@"%@",clientId] forKey:@"client_id"];
    if( parentId && ![parentId isEqualToString:@""] )
        [insertDic setObject:[NSString stringWithFormat:@"%@",parentId] forKey:@"parent_id"];
    if (proid && ![proid isEqualToString:@""]) {
        [insertDic setObject:proid forKey:@"pro_id"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:insertDic];
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"insertArr=%@",insertStr];
    NSString *function = Table_Func_addGxsComment;
    NSString *op = Table_Op_addGxsComment;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//获取个人信息
-(void) getUserInfo:(NSString*)userId
{
    requestType_ = Request_UserInfo;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    [conditionDic setObject:@"0" forKey:@"get_count_publish_all"];
    [conditionDic setObject:@"1" forKey:@"get_all_count"];
    [conditionDic setObject:@"1" forKey:@"get_person_place"];
    [conditionDic setObject:@"1" forKey:@"get_is_expert"];
    [conditionDic setObject:@"1" forKey:@"get_count_answer"];
    [conditionDic setObject:@"1" forKey:@"get_rctypeId"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",insertStr];
    NSString * function = Table_Func_GetUserInfo;
    NSString * op = Table_Op_GetUserInfo;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//获取我的社群列表
-(void) getMyGroups:(NSString*)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchArr:(NSString *)searchText type:(NSString *)type
{
    requestType_ = Request_MyGroups;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    if (!searchText) {
        searchText = @"";
    }
    [searchDic setObject:searchText forKey:@"login_person_id"];
    
    //组装分页参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:Request_Version forKey:@"version"];
    if ([type isEqualToString:@"1"]) {
        [conditionDic setObject:type forKey:@"get_group_flag"];
    }else{
        [conditionDic setObject:@"0" forKey:@"get_group_flag"];
    }

    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *insertStr = [jsonWriter2 stringWithObject:conditionDic];
    NSString *searchStr = [jsonWriter2 stringWithObject:searchDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"user_id=%@&searchArr=%@&conditionArr=%@",userId,searchStr,insertStr];
    NSString * function = Table_Func_GetMyGroup;
    NSString * op = Table_Op_GetMygroup;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取社群话题列表
-(void) getGroupsArticleList:(NSString*)groupId  user:(NSString *)userId keyWord:(NSString *)keyWord page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize topArticle:(NSString *)topArticle;
{
    requestType_ = Request_GroupsArticle;
    
    //组装分页参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    if ([topArticle isEqualToString:@"1"]) {
        [conditionDic setObject:@"1" forKey:@"get_top_article"];
    }
    [conditionDic setObject:@"1" forKey:@"get_summary_flag"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"ture" forKey:@"re_comment"];
    [searchDic setObject:@"1" forKey:@"re_person_detail"];
    [searchDic setObject:userId forKey:@"login_person_id"];
    if (keyWord !=nil) {
        [searchDic setObject:keyWord forKey:@"kw"];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@&searchArr=%@",groupId,conditionStr,searchStr];
//    NSString * function = @"getGroupsArticleTrend";
    NSString * function = @"getGroupsArticle_list";
    NSString * op = @"groups_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//搜索社群话题列表
-(void) searchGroupsArticleList:(NSString*)groupId  user:(NSString *)userId keyWord:(NSString *)keyWord page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize topArticle:(NSString *)topArticle;
{
    requestType_ = Request_SearchGroupsArticle;
    
    //组装分页参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    if ([topArticle isEqualToString:@"1"]) {
        [conditionDic setObject:@"1" forKey:@"get_top_article"];
    }
    [conditionDic setObject:@"1" forKey:@"get_summary_flag"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"ture" forKey:@"re_comment"];
    [searchDic setObject:@"1" forKey:@"re_person_detail"];
    [searchDic setObject:userId forKey:@"login_person_id"];
    if (keyWord !=nil) {
        [searchDic setObject:keyWord forKey:@"kw"];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@&searchArr=%@",groupId,conditionStr,searchStr];
    NSString * function = @"getGroupArticle";
    NSString * op = @"groups";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取我的发表列表
-(void) getMyPublishList:(NSString*)userID page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize status:(NSString*)status
{
    requestType_ = Request_MyPubilsh;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    
    NSString *userId = @"";
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    [searchDic setObject:userId forKey:@"login_person_id"];
    [searchDic setObject:userID forKey:@"own_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    NSString * function = @"getMyArticleList";
    NSString * op = @"comm_article_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//我的分享文章列表
-(void) getMyShareArticleList:(NSString*)userID page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize status:(NSString*)status
{
    requestType_ = Request_MyPubilsh;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    
    NSString *userId = @"";
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    [searchDic setObject:userId forKey:@"login_person_id"];
    [searchDic setObject:userID forKey:@"own_id"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    NSString * function = @"getMyShareList";
    NSString * op = @"comm_article_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}
//获取我的社群的话题详情
-(void) getGroupsArticleDetail:(NSString*)articleId
{
    requestType_ = Request_GroupsArticleDetail;
    User_DataModal *model = [Manager getUserInfo];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"change_v_cnt"];
    if (model == nil) {
        [conditionDic setObject:@"" forKey:@"person_id"];
    }else{
        [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    }
    [conditionDic setObject:@"1" forKey:@"get_zhiwei_flag"];
    [conditionDic setObject:@"1" forKey:@"get_other_article"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:@"1" forKey:@"get_favorite_flag"];
    [conditionDic setObject:@"1" forKey:@"get_media_flag"];
    [conditionDic setObject:@"1" forKey:@"get_group_flag"];
    NSString *userId = @"";
    if ([Manager shareMgr].haveLogin) {
        userId = [Manager getUserInfo].userId_;
    }
    [conditionDic setObject:userId forKey:@"login_person_id"];
    [conditionDic setObject:@"1" forKey:@"activity_article_type"];
    
    if ([Manager getUserInfo].userId_) {
        [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"art_id=%@&conditionArr=%@",articleId,conditionStr];
    NSString * function = Table_Func_GetGroupArticlDetail;
    NSString * op = @"comm_article_busi";//Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//意见反馈
-(void) giveAdvice:(NSString *)msg contact:(NSString *)contact
{
    //设置请求类型
    requestType_ = Request_FeedBack;
    
    //组装分页参数
    NSMutableDictionary *conDic = [[NSMutableDictionary alloc] init];
    [conDic setObject:@"100110011002" forKey:@"typeId"];
    [conDic setObject:MyClientName forKey:@"typeName"];
    [conDic setObject:contact forKey:@"title"];
    //[conDic setObject:[Manager getUserInfo].userId_ forKey:@"userid"];
    //[conDic setObject:[Manager getUserInfo].name_ forKey:@"uname"];
    [conDic setObject:msg forKey:@"content"];
    [conDic setObject:[Common getCurrentDateTime] forKey:@"addtime"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conStr = [jsonWriter2 stringWithObject:conDic];
    
    //组装请求参数     array改为insertArr  2013-12-25 余嘉豪
    NSString *bodyMsg = [NSString stringWithFormat:@"insertArr=%@",conStr];
    
    NSString *function = @"insertObject";
    //发送请求
    NSString *op = @"feedbackcenter";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//版本检查
-(void) checkClientVersion:(NSString *)clientName
{
    //设置请求类型
    requestType_ = Request_CheckVersion;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"clientName=%@",clientName];
    NSString *function = Table_Op_Version;
    
    //发送请求
    NSString *op = Table_Version;
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//版本检查(隐式)
-(void) checkClientVersionByHide:(NSString *)clientName
{
    //设置请求类型
    requestType_ = Request_CheckVersionByHide;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"clientName=%@",clientName];
    NSString *function = Table_Op_Version;
    
    //发送请求
    NSString *op = Table_Version;
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求一览大厅列表
-(void) getHomeList:(NSString *)userId searchType:(NSString *)type page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_Home;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:type forKey:@"searchtype"];
    [searchDic setObject:@"1" forKey:@"re_person_detail"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"0" forKey:@"get_content_flag"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"user_id=%@&searchArr=%@&conditionArr=%@",userId,searchStr,conditionStr];
    NSString * function = Table_Func_Home;
    NSString * op = Table_Op_Home;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求专家列表
-(void) getExpertList:(NSString*)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize expertName:(NSString*)expertName
{
    requestType_ = Request_ExpertList;
    
    if(!expertName)
        expertName = @"";
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:expertName forKey:@"iname"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    if (!expertName||[expertName isEqualToString:@""]) {
        [conditionDic setObject:@"1" forKey:@"filter_field"];
    }
    else{
        
        [conditionDic setObject:expertName forKey:@"keywords"];
        [conditionDic setObject:userId forKey:@"person_id"];
    }
    
    //[conditionDic setObject:@"1" forKey:@"get_good_at"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg ;
    NSString * function;
    NSString * op;
    if (!expertName||[expertName isEqualToString:@""]) {
        function = @"busi_getYl1001RecommendExpert2";
        op = Table_Op_GetMyGroups;
        bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
        
    }
    else{
        function = Table_Func_SearchExpert;
        op = Table_Op_GetNewsList;
        bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    }
    
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求hi模块的行家搜索
-(void)getHISearchExpertList:(NSString*)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize expertName:(NSString*)expertName
{
    requestType_ = Request_HISearchExpert;
    
    if(!expertName)
        expertName = @"";
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:expertName forKey:@"iname"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    if (!expertName||[expertName isEqualToString:@""]) {
        [conditionDic setObject:@"1" forKey:@"filter_field"];
    }
    else{
        
        [conditionDic setObject:expertName forKey:@"keywords"];
        [conditionDic setObject:userId forKey:@"person_id"];
    }
    
    //[conditionDic setObject:@"1" forKey:@"get_good_at"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg ;
    NSString * function;
    NSString * op;
    if (!expertName||[expertName isEqualToString:@""]) {
        function = @"busi_getYl1001RecommendExpert2";
        op = Table_Op_GetMyGroups;
        bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
        
    }
    else{
        function = Table_Func_SearchExpert;
        op = Table_Op_GetNewsList;
        bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    }
    
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//文章分享到动态
-(void)shareArticleDynamicArticleId:(NSString *)article_id andPersonId:(NSString *)person_id
{
    requestType_ = Request_shareArticleDyanmic;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@",article_id,person_id];
    NSString * function = @"shareArticle";
    NSString * op = @"groups_newsfeed_busi";
    NSLog(@"--------------%@",bodyMsg);
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求关注行家
-(void) followExpert:(NSString *)userId  expert:(NSString *)expertId
{
    requestType_ = Request_Follow;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@",userId,expertId];
    NSString * function = Table_Func_Follow;
    NSString * op = Table_Op_Follow;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求取消关注行家
-(void) cancelFollowExpert:(NSString *)userId  expert:(NSString*)expertId
{
    requestType_ = Request_CancelFollow;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@",userId,expertId];
    NSString * function = Table_Func_CancelFollow;
    NSString * op = Table_Op_Follow;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求推荐社群
-(void)getRecommendGroups:(NSString*)userId  page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_RecommendGroup;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"1" forKey:@"get_article_stat"];
    [conditionDic setObject:@"3.96" forKey:@"version"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",userId,conditionStr];
    NSString * function = Table_Func_RecommendGroups;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求搜索社群
-(void)getGroupsBySearch:(NSString*) userId   keyword:(NSString*)keyword  page:(NSInteger) pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_SearchGroup;
    
    if (keyword == nil || [keyword isEqualToString:@""]||[keyword isEqualToString:@" "]) {
        [self getRecommendGroups:userId page:pageIndex pageSize:pageSize];
        return;
    }
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"1" forKey:@"get_article_stat"];
    [conditionDic setObject:@"3.96" forKey:@"version"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"kw=%@&user_id=%@&conditionArr=%@",keyword,userId,conditionStr];
    NSString * function = Table_Func_SearchGroups;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 综合搜索之社群搜索
-(void)getTodayMoreGroupSearchWithKeyword:(NSString*)keyword  page:(NSInteger)page  pageSize:(NSInteger)pageSize searchFrom:(NSString *)searchFrom useId:(NSString *)useId
{
    requestType_ = Request_SearchMoreGroupList;
    if (keyword.length > 0) {
        
    }
    else
    {
        keyword = @"";
    }
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:keyword forKey:@"keywords"];
    if (useId.length <= 0 || !useId) {
        useId = [Manager shareMgr].haveLogin?[Manager getUserInfo].userId_:@"";
    }
    [searchDic setObject:useId forKey:@"person_id"];
    [searchDic setObject:searchFrom forKey:@"seachfrom"];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionStr];
    NSString * function = @"searchGroupList";
    NSString * op = @"yl_search_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}


//请求职业群、公司群列表
-(void)getMyGroupsJobWithCompanyList:(NSString *)userId group_source:(NSInteger)source pageIndex:(NSInteger)page pageSize:(NSInteger)pageSize tradeId:(NSString *)tradeId totalId:(NSString *)totalId code:(NSString *)code
{
    requestType_ = Request_GetMyGroupsJobAndCompany;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    
    if (totalId.length > 0)
    {
        [searchDic setObject:totalId forKey:@"totalid"];
    }
    if (source == 100)
    {
        [searchDic setObject:code forKey:@"list_code"];
    }
    else
    {
        if (source == 2) {
            [conditionDic setObject:@"1" forKey:@"get_recommend_flag"];
        }
        else
        {
            [conditionDic setObject:@"0" forKey:@"get_recommend_flag"];
            [searchDic setObject:[NSString stringWithFormat:@"%ld",(long)source] forKey:@"group_source"];
        }
    }
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionStr];
    NSString * function = @"searchGroup";
    NSString * op = @"groups_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求加入社群
-(void)joinGroup:(NSString*)userId  group:(NSString*)groupId content:(NSString *)content
{
    requestType_ = Request_JoinGroup;
    NSString * bodyMsg = nil;
    //非私密社群
    if ([content isEqualToString:@""]) {
        bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@",groupId,userId];
    }else{
        NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
        [insertDic setObject:content forKey:@"reason"];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *insertStr = [jsonWriter stringWithObject:insertDic];
        bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&insertArr=%@",groupId,userId,insertStr];
    }
    //组装请求参数
    
    NSString * function = Table_Func_JoinGroup;
    NSString * op = Table_Op_JoinGroup;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}
//请求加入社群无提示
-(void)joinGroupTwo:(NSString *)userId group:(NSString *)groupId content:(NSString *)content
{
    requestType_ = Request_JoinGroupTwo;
    NSString * bodyMsg = nil;
    //非私密社群
    if ([content isEqualToString:@""]) {
        bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@",groupId,userId];
    }else{
        NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
        [insertDic setObject:content forKey:@"reason"];
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *insertStr = [jsonWriter stringWithObject:insertDic];
        bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&insertArr=%@",groupId,userId,insertStr];
    }
    //组装请求参数
    
    NSString * function = Table_Func_JoinGroup;
    NSString * op = Table_Op_JoinGroup;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求专题列表
-(void)getSubjectList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_SubjectList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    //[conditionDic setObject:@"pageList" forKey:@"listtype"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:@"50" forKey:@"clen "];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = Table_Func_GetSubjectList;
    NSString * op = Table_Op_GetSubjectList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求专题详情
-(void)getSubjectDetail:(NSString*)subjectId
{
    requestType_ = Request_SubjectDetail;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:subjectId forKey:@"zas_id"];
    [conditionDic setObject:@"1" forKey:@"get_all_pic"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = Table_Func_GetSubjectDetail;
    NSString * op = Table_Op_GetSubjectDetail;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求薪指列表
-(void)getSalaryList:(NSString*)keyword keywordFlag:(NSString *)keywordFlag region:(NSString*)regionid  page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString *)userId
{
    requestType_ = Request_SalaryList;
    if (!userId) {
        userId = @"";
    }
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:keyword forKey:@"kw"];
    [searchDic setObject:regionid forKey:@"zw_regionid"];
    [searchDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    //0表示搜索自定义（自己手动输入）的关键字，1.表示搜索大的类别，2.表示搜索职位小的类别
    NSString *flag = @"";
    if (keywordFlag) {
        flag = keywordFlag;
    }
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"quchong"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",flag] forKey:@"kw_flag"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&search_way=es&conditionArr=%@",searchStr,conditionStr];
    NSString * function = @"salarySearch";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//获取薪资比拼的总数
-(void)getSalaryCompeteSum
{
    requestType_ = Request_GetSalaryCompeteSum;
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"where=%@&slaveInfo=%@",@"1=1",@"1"];
    NSString * function = @"get_compare_salary_sum";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取曝薪资总数
-(void)getExposureSalaryNum
{
    requestType_ = Request_GetExposureSalaryNum;
    //组装请求参数
    NSString * bodyMsg = @" ";
    NSString * function = @"getSalaryCntInfo";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 保存曝工资的信息
- (void)saveExposureSalaryInfo:(NSString *)companyName job:(NSString *)job salary:(NSString *)salary regionId:(NSString *)regionId userId:(NSString *)userId article:(NSString *)articleId comment:(NSString *)comment clientId:(NSString *)clientId{
    requestType_ = Request_SaveExposureSalary;
    //组装请求参数
    
    NSString * function = @"addBaogz";
    NSString * op = @"resume_salary_busi";
    NSMutableDictionary *exposureDic = [NSMutableDictionary dictionaryWithCapacity:5];
    exposureDic[@"cname"] = companyName;
    exposureDic[@"jtzw"] = job;
    exposureDic[@"person_yuex"] = salary;
    exposureDic[@"zw_regionid"] = regionId;
    exposureDic[@"person_id"] = userId;
    
    NSMutableDictionary *commentDic = [NSMutableDictionary dictionaryWithCapacity:4];
    commentDic[@"content"] = comment;
    commentDic[@"user_id"] = userId;
    commentDic[@"article_id"] = articleId;
    commentDic[@"client_id"] = clientId;
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc]init];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"baogzInfo=%@&gxsInfo=%@", [jsonWrite stringWithObject:exposureDic], [jsonWrite stringWithObject:commentDic]];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//请求精品观点列表
-(void)getViewPoint:(NSString * )zasId
{
    requestType_ = Request_ViewPoint;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"zas_id=%@",zasId];
    NSString * function = Table_Func_GetViewPointList;
    NSString * op = Table_Op_GetViewPointList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求精品评论内容
-(void)getCommentContent:(NSString*)commentId
{
    requestType_= Request_CommentContent;
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"id=%@",commentId];
    NSString * function = Table_Func_GetCommentContent;
    NSString * op = Table_Op_GetCommentContent;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求是否为专家
-(void)getIsExpert:(NSString*)personId
{
    requestType_ = Request_isExpert;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = Table_Func_IsExpert;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求职导列表
-(void)getJobGuideList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_JobGuide;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"pageSize=%@&pageIndex=%@",pageParams,[NSString stringWithFormat:@"%ld",(long)pageIndex]];
    NSString * function = Table_Func_GetJobGuide;
    NSString * op = Table_Op_GetJobGuide;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求职导详情
-(void)getJobGuideDetail:(NSString*)keyId
{
    requestType_ = Request_JobGuideDetail;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"keyId=%@",keyId];
    NSString * function = Table_Func_GetJobGuideDetail;
    NSString * op = Table_Op_GetJobGuide;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求修改密码
-(void)resetPassword:(NSString*)userId  oldPwd:(NSString*)oldPwd   newPwd:(NSString *)newPwd
{
    requestType_ = Request_ResetPwd;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&oldpassword=%@&newpassword=%@",userId,oldPwd,newPwd];
    NSString * function = Table_Func_ResetPwd;
    NSString * op = Table_Op_SaveUserInfo;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}



//请求薪酬百分比
//-(void)getSalaryPercent:(NSString*)place  zw:(NSString*)zw  salary:(NSString*)salary haveKW:(BOOL)haveKW
//{
//    requestType_ = Request_SalaryPercent;
//    
//    //组装搜索参数
//    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
//    [searchDic setObject:place forKey:@"zw_regionid"];
//    [searchDic setObject:zw forKey:@"kw"];
//    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
//    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
//    
//    NSString * flag = @"1";
//    if (haveKW) {
//        flag = @"0";
//    }
//    
//    //组装条件参数
//    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"1" forKey:@"quchong"];
//    [conditionDic setObject:flag forKey:@"kw_flag"];
//    
//    [conditionDic setObject:@"5000" forKey:@"page_size"];
//    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
//    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
//    
//    //组装请求参数
//    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&compareSalary=%@&type=%@&conditionArr=%@",searchStr,salary,@"average",conditionStr];
//    NSString * function = Table_Func_GetSalaryPercent;
//    NSString * op = Table_Op_GetNewsList;
//    
//    //发送请求
//    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
//    
//}

//请求薪资排行榜
-(void)getSalaryRank:(NSString*)regionId  zw:(NSString*)zw  salary:(NSString*)salary
{
    requestType_ = Request_SalaryRank;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:regionId forKey:@"zw_regionid"];
    [searchDic setObject:zw forKey:@"kw"];
    [searchDic setObject:salary forKey:@"person_yuex"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"quchong"];
    [conditionDic setObject:@"0" forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    NSString * function = Table_Func_GetSalaryRank;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//注册推送
-(void)setSubscribeConfig:(NSString *)deviceToken  user:(NSString*)userId clientName:(NSString*)clientName startHour:(NSInteger)startHour  endHour:(NSInteger)endHour clientVersion:(NSString*)clientVersion betweenHour:(NSInteger)betweenHour
{
    requestType_ = Request_SetSubscribeConfig;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"20" forKey:@"processType"];
    [conditionDic setObject:@"10" forKey:@"userIdType"];
    [conditionDic setObject:deviceToken forKey:@"deviceToken"];
    [conditionDic setObject:userId forKey:@"userId"];
    [conditionDic setObject:clientName forKey:@"clientName"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)startHour] forKey:@"startHour"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)endHour] forKey:@"endHour"];
    [conditionDic setObject:@"1" forKey:@"bOn"];
    [conditionDic setObject:clientVersion forKey:@"clientVersion"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)betweenHour] forKey:@"betweenHour"];
    [conditionDic setObject:[MyCommon getUUID] forKey:@"deviceId"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@",conditionStr];
    NSString * function = Table_Func_SetSubscribrConfig;
    NSString * op = Table_Op_SetSubscribrConfig;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求推荐职位
-(void)getRecommendJobList:(NSString*)job  regionid:(NSString*)regionid  salary:(NSString*)salary isEmail:(NSString*)isemail  email:(NSString*)email username:(NSString*)username sex:(NSString *)sex
{
    requestType_ = Request_RecommandJob;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:job forKey:@"jtzw"];
    [searchDic setObject:regionid forKey:@"regionid"];
    [searchDic setObject:salary forKey:@"salary"];
    
    
    //组装用户参数
    NSMutableDictionary * userDic = [[NSMutableDictionary alloc] init];
    [userDic setObject:email forKey:@"email"];
    [userDic setObject:username forKey:@"iname"];
    [userDic setObject:sex forKey:@"sex"];
    
    //组装上传参数
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:searchDic forKey:@"search"];
    [paramDic setObject:isemail forKey:@"is_send_email"];
    [paramDic setObject:userDic forKey:@"person_info"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *paramStr = [jsonWriter stringWithObject:paramDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@",paramStr];
    NSString * function = Table_Func_GetRecommendJob;
    NSString * op = Table_Op_GetRecommendJob;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求找回密码
-(void)findPassword:(NSString*)email
{
    requestType_ = Request_FindPassword;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"email=%@&person_user_type=1001",email];
    NSString * function = Table_Func_FindPassword;
    NSString * op = Table_Op_SaveUserInfo;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求给文章添加赞
-(void)addArticleLiked:(NSString*)artixleId
{
    requestType_ = Request_SetArticleLiked;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@",artixleId];
    NSString * function = Table_Func_AddArticleLiked;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 评论点赞@param $comment_id  integer 评论ID* @param $type   string agree支持/oppose反对，默认为支持
- (void)addCommentLike:(NSString *)commentId type:(NSString *)type
{
    requestType_ = Request_SetCommentLiked;
    
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&comment_id=%@&type=%@",personId,commentId,@"add"];
    NSString * function = @"addCommentPraise";      //Table_Func_AddCommentLiked;
    NSString * op = @"yl_praise_busi";              //Table_Op_AddCommentLiked;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求应届生薪指列表 薪水预测
-(void)getFreshSalaryList:(NSString*)zym  minWorkAge:(NSString*)minWorkAge  maxWorkAge:(NSString*)maxWorkAge regionId:(NSString*)regionId page:(NSInteger)page  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_FreshSalaryList;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    //    [searchDic setObject:zym  forKey:@"zym"];
    //    [searchDic setObject:regionId forKey:@"regionid"];
    if (!minWorkAge||[minWorkAge isEqualToString:@""]) {
        minWorkAge = @"0";
    }
    if (!maxWorkAge||[maxWorkAge isEqualToString:@""]) {
        maxWorkAge = @"";
    }
    [searchDic setObject:minWorkAge forKey:@"gznum_min"];
    [searchDic setObject:maxWorkAge forKey:@"gznum_max"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"zym=%@&searchArr=%@&conditionArr=%@&",zym, searchStr,conditionStr];
    NSString * function = @"getPersonListByZy";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求专家问答列表
-(void)getExpertAnswerList:(NSString*)expertId  page:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_ExpertAnswerList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"initSize"];
    [conditionDic setObject:pageParams forKey:@"pageSize"];
    //[conditionDic setObject:@"0" forKey:@"tradeid"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&conditionArr=%@",expertId,conditionStr];
    NSString * function = Table_Func_ExpertAnswerList;
    NSString * op = Table_Op_ExpertAnswerList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求问答详情（新）
-(void)getAnswerDetailNew:(NSString *)questionId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex personId:(NSString *)personId
{
    requestType_ = Request_AnswerDetailNew;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"need_page_answer"];
    [conditionDic setObject:questionId forKey:@"question_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:personId forKey:@"personId"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = @"getQuestionInfo";
    NSString * op = @"zd_ask_question_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求向专家提问
-(void)askExpert:(NSString*)uid  question:(NSString*)content  expert:(NSString*)expertId
{
    requestType_ = Request_AskExpert;
    
    //组装问题参数
    NSMutableDictionary * questionDic = [[NSMutableDictionary alloc] init];
    [questionDic setObject:@"" forKey:@"category_id"];
    [questionDic setObject:@"0" forKey:@"type"];
    [questionDic setObject:@"5" forKey:@"question_targ"];
    [questionDic setObject:content forKey:@"question_title"];
    [questionDic setObject:content forKey:@"question_content"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *questionArr = [jsonWriter2 stringWithObject:questionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&querstionArr=%@&expert_id=%@",uid,questionArr,expertId];
    NSString * function = Table_Func_AskExpert;
    NSString * op = Table_Op_AskExpert;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//$condition_arr['is_solve']//是否解决 0所有 1已解决 2未解决
//$condition_arr['visitor_pid']//访问的用户
//请求职导问答列表
-(void)getJobGuideQuesList:(NSString*)type keywords:(NSString*)kw pagesize:(NSInteger)pagesize pageindex:(NSInteger)pageindex isSolved:(NSInteger)isSholved userId:(NSString*)userId belongs:(NSString*)belongs
{
    requestType_ = Request_JobGuideQuesList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",type] forKey:@"question_targ"];
    [conditionDic setObject:kw forKey:@"question_title"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"pageindex"];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%@",belongs] forKey:@"belongs"];
    [conditionDic setObject:@"1" forKey:@"answer_zj_detail"];
    if (isSholved == 2) {
        [conditionDic setObject:@"1" forKey:@"ask_zj_detail"];
    }
    
    [conditionDic setObject:@"1" forKey:@"get_all_count"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)isSholved] forKey:@"is_solve"];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    
    [conditionDic setObject:@"1" forKey:@"need_question_tag"];
    [conditionDic setObject:@"order by recommend desc,question_lastupdate desc" forKey:@"orderby"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = Table_Func_JobGuideQuesList;
    NSString * op = Table_Op_AskExpert;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

-(void)myJobGroudeCtlList:(NSString *)searchText typeId:(NSString *)typeId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex tradeId:(NSString *)tradeId totalId:(NSString *)totalId
{
    requestType_ = Request_JobGuideQuesList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:searchText forKey:@"question_title"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    if (tradeId && ![tradeId isEqualToString:@""]) {
        [conditionDic setObject:tradeId forKey:@"tradeid"];
    }else{
        [conditionDic setObject:[NSString stringWithFormat:@"%@",typeId] forKey:@"question_targ"];
    }
//    if (totalId && ![totalId isEqualToString:@""]) {
//        [conditionDic setObject:totalId forKey:@"totalid"];
//    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = @"getQuestionList";
    NSString * op = @"zd_ask_question_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求分类的职导问答列表
-(void)getJobGuideQuesListByTag:(NSString*)typeId  pagesize:(NSInteger)pagesize pageindex:(NSInteger)pageindex
{
    requestType_ = Request_GetJobGuideByTag;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",typeId] forKey:@"ylt_id"];
    [conditionDic setObject:@"1" forKey:@"need_answer"];
    [conditionDic setObject:@"1" forKey:@"need_answer_person"];
    [conditionDic setObject:@"1" forKey:@"is_solve"];
    [conditionDic setObject:@"ZD_QUESTION" forKey:@"yltr_product_code"];
    [conditionDic setObject:@"order by y.yltr_order desc,q.question_lastupdate desc" forKey:@"order"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"pageindex"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = @"busi_get_question_by_tag";
    NSString * op = @"yl_tag_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求招聘会列表
-(void)getZphList:(NSString*)regionId  pagesize:(NSInteger)pagesize  pageindex:(NSInteger)pageindex  kw:(NSString*)kw timeType:(NSString *)timeType dateType:(NSString *)searchDateType
{
    requestType_ = Request_ZphList;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    [conditionDic setObject:searchDateType forKey:@"searchDateType"];
    [conditionDic setObject:timeType forKey:@"days"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"regionId=%@&keywords=%@&pageIndex=%@&pageSize=%@&conArr=%@",regionId,kw,[NSString stringWithFormat:@"%ld",(long)pageindex],pageParams,conditionStr];
    
    NSString * function = Table_Func_ZphList;
    NSString * op = Table_Op_ZphList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求宣讲会列表
-(void)getXjhList:(NSString*)regionId pagesize:(NSInteger)pagesize pageindex:(NSInteger)pageinde  kw:(NSString*)kw userId:(NSString *)userId schoolId:(NSString *)schoolId schoolName:(NSString *)schoolName timeType:(NSString *)timeType
   searchDateType:(NSString *)searchDateType
{
    requestType_ = Request_XjhList;
    
    //组装请求参数
    NSString * bodyMsg;
    if (userId != nil) {
        bodyMsg = [NSString stringWithFormat:@"regionId=%@&keywords=%@&pageIndex=%@&pageSize=%@&person_id=%@",regionId,kw,[NSString stringWithFormat:@"%ld",(long)pageinde],pageParams,userId];
        
    }else{
        bodyMsg = [NSString stringWithFormat:@"regionId=%@&keywords=%@&pageIndex=%@&pageSize=%@",regionId,kw,[NSString stringWithFormat:@"%ld",(long)pageinde],pageParams];
    }
    
    if([schoolId isEqualToString:@""])
    {
        if (![schoolName isEqualToString:@""]) {
            bodyMsg = [NSString stringWithFormat:@"%@&sname=%@",bodyMsg,schoolName];
        }
    }
    else
    {
        bodyMsg = [NSString stringWithFormat:@"%@&sid=%@",bodyMsg,schoolId];
    }
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    [conditionDic setObject:searchDateType forKey:@"searchDateType"];
    [conditionDic setObject:timeType forKey:@"days"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    bodyMsg = [NSString stringWithFormat:@"%@&conArr=%@",bodyMsg,conditionStr];
    
    NSString * function = @"getCurrentXjhNew";
    NSString * op = @"cps_xjh";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求宣讲会详情
-(void)getXjhDetail:(NSString*)xjhId personId:(NSString *)personId
{
    requestType_ = Request_XjhDetail;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:xjhId forKey:@"id"];
    [dic setObject:personId forKey:@"person_id"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *arr = [jsonWriter2 stringWithObject:dic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"arr=%@",arr];
    NSString * function = Table_Func_XjhDetail;
    NSString * op = Table_Op_XjhList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求招聘会详情
-(void)getZphDetail:(NSString*)zphId
{
    requestType_ = Request_ZphDetail;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:zphId forKey:@"id"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *arr = [jsonWriter2 stringWithObject:dic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"arr=%@",arr];
    NSString * function = Table_Func_ZphDetail;
    NSString * op = Table_Op_ZphList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求创建的社群
-(void)getAssociationCreatedBySomeone:(NSString*)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize person:(NSString*)personId
{
    requestType_ = Request_CreatedAssociation;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"open" forKey:@"privacy"];
    [conditionDic setObject:@"pageList" forKey:@"listtype"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:personId forKey:@"person_id"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"user_id=%@&conditionArr=%@",userId,conditionStr];
    NSString * function = Table_Func_CreatedAssociation;
    NSString * op = Table_Op_CreatedAssociation;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求我的回答
-(void)getMyAnswerList:(NSString *)userId  pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_MyAnswerList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_person_detail"];
    [conditionDic setObject:@"1" forKey:@"get_question_detail"];
    [conditionDic setObject:@"1" forKey:@"get_q_person"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = Table_Func_MyAnswerList;
    NSString * op = Table_Op_ExpertAnswerList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求我的待回答列表
-(void)getMyNotAnswerList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_MyNotAnswerList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"2" forKey:@"is_solve"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:userId forKey:@"answer_expert"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = Table_Func_MyNotAnswerList;
    NSString * op = Table_Op_AskExpert;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求回答问题
-(void)answerQuestion:(NSString*)userId questionId:(NSString*)questionId content:(NSString*)content
{
    requestType_ = Request_AnswerQuestion;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&question_id=%@&content=%@",userId,questionId,content];
    NSString * function = Table_Func_SubmitAnswer;
    NSString * op = Table_Op_ExpertAnswerList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求订阅职位
-(void)subscribeJob:(NSString*)personId regionId:(NSString*)regionId keyword:(NSString*)kewword tradeId:(NSString*)tradeId
{
    requestType_ = Request_SubscibeJob;
    
    //组装条件参数
    NSMutableDictionary * condictionDic = [[NSMutableDictionary alloc] init];
    if (!regionId || regionId == nil) {
        regionId = @"";
    }
    if (!kewword||kewword == nil) {
        kewword = @"";
    }
    if (!tradeId || tradeId == nil) {
        tradeId = @"";
    }
    [condictionDic setObject:regionId forKey:@"regionid"];
    [condictionDic setObject:kewword forKey:@"keyword"];
    [condictionDic setObject:tradeId forKey:@"tradeid"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:condictionDic];
    
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&subscribe=%@",personId,conditionStr];
    NSString * function = Table_Func_SubscribeJob;
    NSString * op = Table_Op_SubscribeJob;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求职位订阅列表
-(void)getJobSubscribedList:(NSString*)personId
{
    requestType_ = Request_GetJobSubscribedList;
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = Table_Func_GetSubscribeJobList;
    NSString * op = Table_Op_SubscribeJob;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求删除职位订阅
-(void)deleteJobSubscribed:(NSString *)personId  jobId:(NSString*)jobId
{
    requestType_ = Request_DeleteJobSubscribed;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&zw_subscribe_id=%@",personId,jobId];
    NSString * function = Table_Func_DeleteSubscribedJOb;
    NSString * op = Table_Op_SubscribeJob;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求我的关注
-(void)getMyFollower:(NSString*)userId personId:(NSString *)personId type:(NSInteger)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex kw:(NSString*)kw
{
    requestType_ = Request_MyFollower;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    if (type == 3) {
        [conditionDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"follow_type"];
        [conditionDic setObject:personId forKey:@"personId"];
        
    }else{
        [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"follow_type"];
        [conditionDic setObject:personId forKey:@"personId"];
    }
    [conditionDic setObject:@"1" forKey:@"get_rel"];
    [conditionDic setObject:@"1" forKey:@"get_all_count"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:@"1" forKey:@"get_is_expert"];
    [conditionDic setObject:@"1" forKey:@"get_good_at"];
    [conditionDic setObject:@"1" forKey:@"get_expert_detail"];
    
    if (type == 1 || type == 3) {
        [conditionDic setObject:kw forKey:@"follow_person_iname"];
    }
    
    if (type == 2) {
        [conditionDic setObject:kw forKey:@"person_iname"];
    }
    
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = Table_Func_MyFollower;
    NSString * op = Table_Op_MyFollower;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求发表文章
-(void)shareArticle:(NSString*)userId userName:(NSString*)userName type:(NSInteger)type title:(NSString*)title showContent:(NSInteger)showContent addComment:(NSInteger)addComment showComment:(NSInteger)showComment  content:(NSString*)content thumb:(NSString *)thumb kw:(NSString *)kw cateName:(NSString *)cateName
{
    requestType_ = Request_ShareArticle;
    
    NSMutableDictionary * basicDic = [[NSMutableDictionary alloc] init];
    [basicDic setObject:userId forKey:@"own_id"];
    [basicDic setObject:userName forKey:@"own_name"];
    [basicDic setObject:title forKey:@"title"];
    [basicDic setObject:@"1" forKey:@"own_name_type"];
    [basicDic setObject:thumb forKey:@"thumb"];
    
    NSMutableDictionary * contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:content forKey:@"content"];
    
    NSMutableDictionary * permissionDic = [[NSMutableDictionary alloc] init];
    [permissionDic setObject:[NSString stringWithFormat:@"%ld",(long)showContent] forKey:@"cap_show_contents"];  //谁可看正文 1所有人 3仅听众
    [permissionDic setObject:[NSString stringWithFormat:@"%ld",(long)showComment] forKey:@"cap_show_comment"];   //谁可看评论  1所有人 3仅听众 5仅自己
    [permissionDic setObject:[NSString stringWithFormat:@"%ld",(long)addComment] forKey:@"cap_topic_comment"];  //谁可发表评论  1所有人 3仅听众 5禁止评论
    
    
    NSMutableDictionary * insertDic = [[NSMutableDictionary alloc] init];
    [insertDic setObject:basicDic       forKey:@"base"];
    [insertDic setObject:contentDic     forKey:@"content"];
    [insertDic setObject:permissionDic  forKey:@"permission"];
    [insertDic setObject:kw             forKey:@"kw"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:insertDic];
    
    NSDictionary *conditionDic = @{@"get_add_info":@true};
    NSString *conditionArr = [jsonWriter2 stringWithObject:conditionDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"insertArr=%@&project_type=%ld&cate_name=%@&conditionArr=%@",conditionStr,(long)type,cateName,conditionArr];
    NSString * function = Table_Func_ShareArticle;
    NSString * op = Table_Op_GetNewsList;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//发表话题
-(void)publishTopic:(NSString*)userId  groupId:(NSString*)groupId ownId:(NSString*)ownId title:(NSString*)title content:(NSString*)content thumb:(NSString *)thumb kw:(NSString *)kw isCompany:(BOOL)isCompany Type:(NSString *)type
{
    requestType_ = Request_PublishTopic;
    
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"0" forKey:@"checkflag"];
    
    if (isCompany) {
        [conditionDic setObject:type forKey:@"open_majia_flag"];
    }
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter stringWithObject:conditionDic];
    
    NSMutableDictionary * baseDic = [[NSMutableDictionary alloc] init];
    [baseDic setObject:title forKey:@"title"];
    [baseDic setObject:ownId forKey:@"own_id"];
    [baseDic setObject:thumb forKey:@"thumb"];
    
    NSMutableDictionary * contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:content forKey:@"content"];
    
    
    
    NSMutableDictionary * insertDic = [[NSMutableDictionary alloc] init];
    [insertDic setObject:baseDic    forKey:@"base"];
    [insertDic setObject:contentDic forKey:@"content"];
    [insertDic setObject:kw         forKey:@"kw"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:insertDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&group_id=%@&insertArr=%@&conditionArr=%@",userId,groupId,conditionStr,condition];
    NSString * function = Table_Func_PublishTopic;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求可以发表话题的社群
-(void)getGroupsCanPublish:(NSString*)userId
{
    requestType_ = Request_GroupsCanPublish;
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = Table_Func_GroupsCanPublish;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//创建社群
-(void)createGroup:(NSString*)userId name:(NSString*)name intro:(NSString*)intro tags:(NSString*)tags openStatus:(NSInteger)status photo:(NSString *)photo
{
    requestType_ = Request_CreateGroup;
    if (tags == nil) {
        tags = @"";
    }
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:name forKey:@"group_name"];
    if (!intro) {
        intro = @"";
    }
    [infoDic setObject:intro forKey:@"group_intro"];
    [infoDic setObject:tags forKey:@"tag_names"];
    if (photo !=nil) {
        [infoDic setObject:photo forKey:@"group_pic"];
    }
    [infoDic setObject:[NSString stringWithFormat:@"%ld",(long)status] forKey:@"open_status"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *infoStr = [jsonWriter stringWithObject:infoDic];
    
    NSMutableDictionary *inDic = [[NSMutableDictionary alloc]init];
    [inDic setObject:@"100" forKey:@"topic_publish"];
    [inDic setObject:@"100" forKey:@"member_invite"];
    
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:inDic forKey:@"group_seting"];
    [condictionDic setObject:@"0" forKey:@"checkflag"];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"user_id=%@&groupInfoArr=%@&conditionArr=%@",userId,infoStr,condictionStr];
    NSString * function = Table_Func_CreateGroup;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取社群信息
-(void)getGroupInfo:(NSString*)groupId userId:(NSString*)userId
{
    requestType_ = Request_GetGroupInfo;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_group_perm"];
    [conditionDic setObject:userId forKey:@"login_person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@",groupId,conditionStr];
    NSString * function = Table_Func_GetGroupInfo;
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取社群成员
-(void)getGroupMember:(NSString*)groupId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString *)userId userRole:(NSString *)userRole
{
    if ([userRole isEqualToString:@"all"]) {
        requestType_ = Request_GetGroupMember;
    }
    if ([userRole isEqualToString:@"creater"]) {
        requestType_ = Request_GetGroupCreater;
    }
    
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"1" forKey:@"re_person_detail"];
    [conditionDic setObject:userId forKey:@"re_person_rel"];
    [conditionDic setObject:@"1" forKey:@"re_permission"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userRole forKey:@"user_role"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&conditionArr=%@&searchArr=%@",groupId,conditionStr,searchStr];
    NSString * function = Table_Func_GetGroupMember;
    NSString * op = Table_Op_GetGroupMember;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//通讯录邀请新成员
-(void)invitePeople:(NSString*)personId  groupId:(NSString*)groupId
{
    requestType_ = Request_InvitePeople;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&person_id=%@",groupId,personId];
    NSString * function = @"busi_getGroupShareLink";
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取听众邀请列表
-(void)getInviteFansList:(NSString *)userId  groupId:(NSString*)groupId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_InviteFansList;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"pagelist" forKey:@"listtype"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&person_id=%@&conditionArr=%@",groupId,userId,conditionStr];
    NSString * function = @"busi_getFollowList2";
    NSString * op = Table_Op_GetMyGroups;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求批量邀请听众
-(void)inviteFans:(NSString*)groupId  userId:(NSString*)userId fansId:(NSString*)fansId
{
    requestType_ = Request_InviteFans;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&person_id=%@&invite_id=%@",groupId,userId,fansId];
    NSString * function = @"doRequestInvite";
    NSString * op = @"groups_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//听众中搜索
-(void)inviteSearch:(NSString *)searchString userId:(NSString *)userId personId:(NSString *)personId pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_inviteSearchFans;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    [conditionDic setObject:searchString forKey:@"person_iname"];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    [conditionDic setObject:@"2" forKey:@"follow_type"];
    [conditionDic setObject:@"1" forKey:@"get_rel"];
    [conditionDic setObject:userId forKey:@"personId"];
    [conditionDic setObject:@"1" forKey:@"get_all_count"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:@"1" forKey:@"get_is_expert"];
    [conditionDic setObject:@"1" forKey:@"get_good_at"];
    [conditionDic setObject:@"1" forKey:@"get_expert_detail"];
    
    
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    NSString *function = @"new_get_follow_list";
    NSString *op = @"zd_person_follow_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求消息设置信息
-(void)getPushSetMessage:(NSString *)userId
{
    requestType_ = Request_GetPushSetMessage;
    
    //组装请求参数person_id=7823070&conditionArr=&
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = @"getPushSettingByPerson";
    NSString * op = @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求更新消息设置
-(void)updatePushSet:(NSString *)userId type:(NSString *)type status:(NSString *)status
{
    requestType_ = Request_UpdatePushSet;
    
    //组装请求参数person_id=7823070&conditionArr=&
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&msg_type=%@&msg_val=%@",userId, type, status];
    NSString * function = @"addOrUpdatePushSetting";
    NSString * op = @"yl_app_push_setting";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求批量更新消息设置
-(void)updatePushSettings:(NSString *)userId settingArr:(NSMutableDictionary *)setingDic
{
    requestType_ = Request_UpdatePushSettings;
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:setingDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&settingArr=%@",userId, conditionStr];
    NSString * function = @"addOrUpdatePushSettings";
    NSString * op = @"yl_app_push_setting";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求退出社群
-(void)quitGroups:(NSString *)groupId  userId:(NSString*)userId
{
    requestType_ = Request_QuitGroup;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@",groupId,userId];
    NSString * function = @"doRequestQuit";
    NSString * op = @"groups_person";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求我的受邀列表
-(void)getMyInviteList:(NSString*)userId type:(NSString *)type page:(NSInteger)page pageSize:(NSInteger)pageSize
{
    requestType_ = Request_MyInviteList;
    
    //组装条件数组
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:type forKey:@"logs_request_type"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",[MyCommon getdateStrBeforeSomeDay:59]] forKey:@"logs_request_idatetime"];  //设置一个月内的消息
    if ([type isEqualToString:@"10"]) {
        [conditionDic setObject:@"0" forKey:@"search_person_group"];
    }
    else if([type isEqualToString:@"60"])
    {
        [conditionDic setObject:@"1" forKey:@"search_person_group"];
    }
    [conditionDic setObject:[NSString stringWithFormat:@"%@",ClientVersion] forKey:@"verson"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&user_id=%@&type=me&conditionArr=%@",@"",userId,conditionStr];
    NSString * function = @"busi_getGroupsPersonLogs";
    NSString * op = @"groups";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求处理社群申请
-(void)handleGroupApply:(NSString *)groupId reqUserId:(NSString *)reqUserId resUserId:(NSString *)resUserId dealType:(NSString *)dealType losgId:(NSString *)losgId
{
    requestType_ = Request_HandleGroupApply;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&respone_person_id=%@&dealtype=%@&logs_id=%@",groupId, reqUserId, resUserId, dealType, losgId];
    NSString * function = @"doResponeJoin";
    NSString * op = @"groups_person";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求处理社群邀请
-(void)handleGroupInvitation:(NSString *)groupId reqUserId:(NSString *)reqUserId resUserId:(NSString *)resUserId dealType:(NSString *)dealType losgId:(NSString *)losgId
{
    requestType_ = Request_HandleGroupInvitation; //请求处理社群邀请;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&request_person_id=%@&respone_person_id=%@&dealtype=%@&logs_id=%@",groupId, reqUserId, resUserId, dealType, losgId];
    NSString * function = @"doResponeInvite";
    
    NSString * op = @"groups_person";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求初始化推送设置
-(void)initPushSettings:(NSString*)userId
{
    requestType_ = Request_InitPushSettings;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = @"initPersonSetting";
    NSString * op = @"yl_app_push_setting";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求获取社群的权限
-(void)getGroupPermission:(NSString*)groupId
{
    requestType_ = Request_GetGroupPermission;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@",groupId];
    NSString * function = @"busi_getGroupPermission";
    NSString * op = @"groups";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求设置社群的权限
-(void)setGroupPermission:(NSString*)groupId userId:(NSString*)userId joinStatus:(NSInteger)joinStatus publishStatus:(NSInteger)publishStatus inviteStatus:(NSInteger)inviteStatus publishArray:(NSArray*)publishArray inviteArray:(NSArray*)inviteArray
{
    requestType_ = Request_SetGroupPermission;
    
    //组装设置参数
    NSMutableDictionary * setDic = [[NSMutableDictionary alloc] init];
    [setDic setObject:[NSString stringWithFormat:@"%ld",(long)joinStatus] forKey:@"group_open_status"];
    [setDic setObject:[NSString stringWithFormat:@"%ld",(long)publishStatus] forKey:@"gs_topic_publish"];
    [setDic setObject:[NSString stringWithFormat:@"%ld",(long)inviteStatus] forKey:@"gs_member_invite"];
    [setDic setObject:publishArray forKey:@"topic_publish"];
    [setDic setObject:inviteArray forKey:@"member_invite"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:setDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&person_id=%@&settingArr=%@",groupId,userId,conditionStr];
    NSString * function = @"busi_settingGroupStatusAndPermission";
    NSString * op = @"groups";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}



//请求问答点赞
- (void)updateAnserSupportCount:(NSString *) userId anserId:(NSString *)anserId type:(NSString *)type updateType:(NSString *)updateType updateNum:(NSString *)num
{
    requestType_ = Request_UpdateAnserSupportCount;
    
    //组装请求参数
    NSMutableDictionary * setDic = [[NSMutableDictionary alloc] init];
    [setDic  setObject:userId forKey:@"uid"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:setDic];
    
    
    NSString * bodyMsg = [NSString stringWithFormat:@"answer_id=%@&type=%@&update_type=%@&update_num=%@&conditionArr=%@",anserId,type,updateType,num,conditionStr];
    NSString * function = @"updateStatisticsCount";
    NSString * op = @"zd_ask_answer";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求问答评论
- (void)submitAnwserComment:(NSString *)userId answerId:(NSString *)answerId content:(NSString *)content parentid:(NSString *)parentid reUserId:(NSString *)reUserId
{
    //设置请求类型
    requestType_ = Request_SubmitAnswerComment;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"uid=%@&relative_id=%@&content=%@&type=%@&parentid=%@&re_uid=%@&",userId,answerId,content,@"30",parentid,reUserId];
    NSString *function = @"submitComment";
    NSString *op = @"zd_ask_comment";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

-(void)getAnswerCommentList:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize  answerId:(NSString*)answerId parentId:(NSString *)parentId
{
    requestType_ = Request_GetAnswerCommentList;
    
    //组装参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:answerId forKey:@"relative_id"];
    [conditionDic setObject:@"30" forKey:@"type"];
    [conditionDic setObject:@"1" forKey:@"get_person_detail"];
    [conditionDic setObject:@" order by comment_idate asc" forKey:@"orderby"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = @"get_comment_list";
    NSString * op = @"zd_ask_comment";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求提问
-(void)askQuest:(NSString*)uid expertId:(NSString*)expertId question:(NSString*)content type:(NSString *)type questionTag:(NSString *)questionTag tradeId:(NSString *)tradeId
{
    requestType_ = Request_AskQuest;
    //组装问题参数
    NSMutableDictionary * questionDic = [[NSMutableDictionary alloc] init];
    [questionDic setObject:@"" forKey:@"category_id"];
    [questionDic setObject:type forKey:@"type"];
    [questionDic setObject:content forKey:@"question_title"];
    [questionDic setObject:content forKey:@"question_content"];
    [questionDic setObject:questionTag forKey:@"question_targ"];
    [questionDic setObject:tradeId forKey:@"tradeid"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *questionArr = [jsonWriter2 stringWithObject:questionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&querstionArr=%@&topic_id=%@&expert_id=%@&conditionArr=%@&tag_flag=%@&",uid,questionArr,@"",expertId,@"",@"tag_name"];
    NSString * function = @"submitZhiyeQuestion";
    NSString * op = @"zd_ask_question";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//找回密码
-(void) findPwd:(NSString *)mobile
{
    //设置请求类型
    requestType_ = Request_FindPhonePwd;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"mobile=%@",mobile];
    NSString *function = @"sendPasswordCode";
    
    //发送请求
    NSString *op = @"Job1001user_findpassword";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//校验找回密码中的验证码
-(void)checkCode:(NSString*)findpwdId  code:(NSString*)code
{
    requestType_ = Request_CheckCode;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"findpwd_id=%@&authcode=%@",findpwdId,code];
    
    NSString *function = @"checkAuthcodeMobile";
    
    //发送请求
    NSString *op = @"Job1001user_findpassword";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//重置密码
-(void)resetPwd:(NSString*)uname findId:(NSString*)findId  newPWD:(NSString*)pwd
{
    requestType_ = Request_ResetPhonePwd;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"findpwd_id=%@&person_uname=%@&password_new=%@",findId,uname,pwd];
    
    NSString *function = @"resetpassword";
    
    //发送请求
    NSString *op = @"Job1001user_findpassword";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//上传头像
-(void)uploadMyImg:(NSString*)userId  uname:(NSString*)uname imgStr:(NSString *)imgStr
{
    requestType_ = Request_UploadMyImg;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&person_uname=%@&imgcode=%@&imgType=%@&is_ios_upload=1",userId,uname,imgStr,@"jpg"];
    
    NSString *function = @"uploadimgCode";
    
    //发送请求
    NSString *op = @"person";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//获取创建的社群数量
-(void)getCreateGroupCount:(NSString*)userId
{
    requestType_ = Request_GetCreateGroupCnt;
    
    //组装请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    NSString *function = @"busi_getGroupCnt";
    
    //发送请求
    NSString *op = @"groups";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取多个城市的薪资百分比
//-(void)getSomeCitySalaryRank:(NSString*)regionIds zw:(NSString *)zw salary:(NSString *)salary haveKW:(BOOL)haveKW
//{
//    requestType_ = Request_SomeCitySalaryRank;
//    
//    //组装搜索参数
//    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
//    [searchDic setObject:regionIds forKey:@"zw_regionid"];
//    [searchDic setObject:zw forKey:@"kw"];
//    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
//    NSString *searchArr = [jsonWriter2 stringWithObject:searchDic];
//    
//    
//    NSString * flag = @"1";
//    if (haveKW) {
//        flag = @"0";
//    }
//    
//    //组装条件参数
//    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:@"1" forKey:@"quchong"];
//    [conditionDic setObject:flag forKey:@"kw_flag"];
//    [conditionDic setObject:@"10000" forKey:@"page_size"];
//    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
//    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
//    
//    //组装请求参数
//    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&compareSalary=%@&type=%@&conditionArr=%@",searchArr,salary,@"average",conditionStr];
//    
//    NSString *function = @"calcSalaryRankSet";
//    
//    //发送请求
//    NSString *op = @"salarycheck_all";
//    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
//}

//根据薪资段获取百分比
-(void)getSalaryRankByMoney:(NSString*)money regionId:(NSString*)regionId zw:(NSString*)zw
{
    requestType_ = Request_SalaryRankByMoney;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:regionId forKey:@"zw_regionid"];
    [searchDic setObject:zw forKey:@"kw"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *searchArr = [jsonWriter2 stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"quchong"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&salaryArr=%@&type=%@&conditionArr=%@",searchArr,money,@"average",conditionStr];
    
    NSString *function = @"calcSalaryRankStat";
    
    //发送请求
    NSString *op = @"salarycheck_all";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取邀请短信
-(void)getInviteSMS:(NSString*)groupId  name:(NSString*)groupName number:(NSString*)groupNumber
{
    requestType_ = Request_InviteSMS;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&group_name=%@&group_number=%@",groupId,groupName,groupNumber];
    
    NSString *function = @"busi_getGroupInviteSms";
    
    //发送请求
    NSString *op = @"groups";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//获取工作申请记录列表
-(void)getWorkApplyList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetWorkApplyList;
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"1" forKey:@"saler_info"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *searchArr = [jsonWriter2 stringWithObject:searchDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&search_arr=%@&condition_arr=%@",userId,searchArr,conditionStr];
    NSString * function = @"getMyCmailboxList";
    NSString * op = @"person_info_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取职位详情
-(void)getPositionDetails:(NSString *)positionId
{
    requestType_ = Request_GetPositionDetails;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"job_id=%@",positionId];
    NSString * function = @"get_by_zp";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求收藏职位
-(void)collectPosition:(NSString *)userId positionId:(NSString *)positionId
{
    requestType_ = Request_CollectPosition;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&job_id=%@",userId,positionId];
    NSString * function = @"pfavorite";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求职位申请记录、收藏记录、面试通知、谁看过我 的数量
-(void)getResumeCenterMessage:(NSString *)userId
{
    requestType_ = Request_GetResumeCenterMessage;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = @"get_by_person";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//搜索工作列表
-(void)getFindJobList:(NSString *)tradeId regionId:(NSString *)reginId kw:(NSString *)kw time:(NSString *)timeNum eduId:(NSString *)eduId workAge:(NSString *)workAge workAge1:(NSString *)workAge1 payMent:(NSString *)payMent workType:(NSString *)workType page:(NSInteger)page pageSize:(NSInteger)pageSize highlight:(NSString *)highlight{
    requestType_ = Request_FindJobList;
    if (!tradeId || [tradeId isEqualToString:@""] || [tradeId isEqualToString:@"(null)"]) {

        tradeId = @"1000";
    }
    if (!reginId) {
        reginId = @"";
    }
    if (!timeNum) {
        timeNum = @"";
    }
    if (!eduId) {
        eduId = @"";
    }
    if (!payMent) {
        payMent = @"";
    }
    
    if (!workType) {
        workType = @"";
    }
    
    NSMutableDictionary * queryDic = [[NSMutableDictionary alloc] init];
    
    [queryDic setObject:kw forKey:@"jtzw"];
    [queryDic setObject:reginId forKey:@"regionid"];
    
    if (timeNum.length > 0) {
        [queryDic setObject:timeNum forKey:@"itime_num"];
    }
    if (eduId.length > 0) {
        [queryDic setObject:eduId forKey:@"eduId"];
    }
    
    // if (workAge && ![workAge isEqualToString:@""] && ![workAge isKindOfClass:[NSNull class]]){
    if ([workAge isEqualToString:@"0"])
    {
        [queryDic setObject:workAge forKey:@"rctypes"];
    }
    else
    {
        if (workAge.length > 0 && workAge1.length > 0)
        {
            [queryDic setObject:workAge forKey:@"gznum1"];
            [queryDic setObject:workAge1 forKey:@"gznum2"];
        }
    }
    //}
    if (payMent.length > 0) {
        [queryDic setObject:payMent forKey:@"salary"];
    }
    if (workType.length > 0) {
        [queryDic setObject:workType forKey:@"jobtypes"]; //工作类型
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *queryArr = [jsonWriter stringWithObject:queryDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:@"1" forKey:@"check_isky"];
    if ([Manager shareMgr].haveLogin) {
        [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
    }else{
        [conditionDic setObject:@"" forKey:@"personId"];
    }
    [conditionDic setObject:[MyCommon getUUID] forKey:@"deviceId"];
    [conditionDic setObject:[Manager getUserInfo].tradeId.length > 0 ? [Manager getUserInfo].tradeId:@"1000"  forKey:@"person_tradeid"];
    if (kw.length > 0 && [highlight isEqualToString:@"1"])
    {
        [conditionDic setObject:highlight forKey:@"highlight"];
    }
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"tradeid=%@&queryItemArr=%@&conditionArr=%@",tradeId,queryArr,conditionStr];
    
    NSString *function = @"searchZp";
    NSString *op = @"zp_info_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//申请单个职位
-(void)applyOneZW:(NSString*)userId zwid:(NSString*)zwid cid:(NSString*)cid jobName:(NSString*)jobName
{
    requestType_ = Request_ApplyOneZw;
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:cid forKey:@"company"];
    [dic setObject:[jobName URLEncodedForString] forKey:@"job"];
    [dic setObject:userId forKey:@"user"];
    [dic setObject:zwid forKey:@"position"];
    [dic setObject:[[NSString stringWithFormat:@"求职信"] URLEncodedForString] forKey:@"title"];
    [dic setObject:[[NSString stringWithFormat:@"贵公司，您好，我基本符合以上职位的条件，应聘该职，谢谢！"] URLEncodedForString] forKey:@"content"];
    [dic setObject:@"0" forKey:@"wage"];
    [arr addObject:dic];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:arr];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",conditionStr];
    
    NSString *function = @"send_person";
    NSString *op = @"person_info_api";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}


//申请职位，可批量
-(void)applyZWWithList:(NSArray *)zwArray userId:(NSString *)userId
{
    requestType_ = Request_ApplyZW;
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    
    for (JobSearch_DataModal * dataModal in zwArray) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setObject:dataModal.companyID_ forKey:@"company"];
        [dic setObject:[dataModal.jtzw_ URLEncodedForString] forKey:@"job"];
        [dic setObject:userId forKey:@"user"];
        [dic setObject:dataModal.zwID_ forKey:@"position"];
        [dic setObject:[[NSString stringWithFormat:@"求职信"] URLEncodedForString] forKey:@"title"];
        [dic setObject:[[NSString stringWithFormat:@"贵公司，您好，我基本符合以上职位的条件，应聘该职，谢谢！"] URLEncodedForString] forKey:@"content"];
        [dic setObject:@"0" forKey:@"wage"];
        
        
        [arr addObject:dic];
        
    }
    NSString *conditionStr = [jsonWriter2 stringWithObject:arr];
    
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",conditionStr];
    
    NSString *function = @"send_person";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求职位收藏列表
-(void)getPositionApplyCollectList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetPositionApplyCollectList;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&page_index=%@&page_size=%@",userId, [NSString stringWithFormat:@"%ld",(long)pageIndex],pageParams];
    NSString * function = @"get_by_pfavorite";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求删除收藏职位
-(void)deleteCollectPosition:(NSString *)userId positionId:(NSString *)positionId
{
    requestType_ = Request_DeleteCollectPosition;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&pf_id=%@",userId,positionId];
    NSString * function = @"delete_pfavorite";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求面试通知列表
-(void)getInterviewMessageList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetInterviewMessageList;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&page_index=%@&page_size=%@",userId,[NSString stringWithFormat:@"%ld",(long)pageIndex],pageParams];
    NSString * function = @"get_by_pmailbox";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求面试通知详情
-(void)getInterviewMessageDetail:(NSString *)interviewId readStatus:(NSString *)status
{
    requestType_ = Request_getInterviewMessageDetail;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"detail=%@&status=%@",interviewId,status];
    NSString * function = @"get_by_cmailbox_detail";
    NSString * op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求简历访问列表
-(void)getResumeVisitList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetResumeVisitList;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&page_index=%@&page_size=%@",userId, [NSString stringWithFormat:@"%ld",(long)pageIndex], pageParams];
    
    NSString *function = @"get_by_look";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求刷新简历
-(void)refreshResume:(NSString *)userId
{
    requestType_ = Request_RefreshResume;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    
    NSString *function = @"refreshResume";
    NSString *op = @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//获取求职状态
-(void)getResumeStatus:(NSString *)userId
{
    requestType_ = Request_GetResumeStatus;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@",userId];
    
    NSString *function = @"getResumeStatus";
    NSString *op = @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求更新求职状态
-(void)updateResumeStatus:(NSString *)userId statusKey:(NSString *)statusKey
{
    requestType_ = Request_UpdateResumeStatus;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@&status=%@",userId,statusKey];
    
    NSString *function = @"updateResumeStatus";
    NSString *op = @"person_slave";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求企业HR问答列表
-(void)getCompanyHRAnswerList:(NSString*)cid pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_CompanyHRAnswer;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:@"1" forKey:@"ishuida"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&condition=%@",cid,conditionStr];
    
    NSString *function = @"getHrList_3G";
    NSString *op = @"company_cache";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求企业办公环境
-(void)getCompanyEnvironment:(NSString*)cid
{
    
}

//请求企业用人理念
-(void)getCompanyEmployee:(NSString*)cid
{
    requestType_ = Request_CompanyEmployee;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",cid];
    
    NSString *function = @"getEmployeeInfo";
    NSString *op = @"company_guzhu";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求企业员工分享
-(void)getCompanyShare:(NSString*)cid
{
    requestType_ = Request_CompanyShare;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",cid];
    
    NSString *function = @"getShareInfo";
    NSString *op = @"company_guzhu";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求企业团队
-(void)getCompanyTeam:(NSString*)cid
{
    requestType_ = Request_CompanyTeam;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",cid];
    
    NSString *function = @"getTeamInfo";
    NSString *op = @"company_guzhu";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求企业未来
-(void)getCompanyDevelopment:(NSString*)cid
{
    requestType_ = Request_CompanyDevelopment;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&cont_type=%@",cid,@"2"];
    
    NSString *function = @"getGuzhuContentInfo";
    NSString *op = @"company_guzhu";
    
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求简历保密设置
-(void)updateResumeVisible:(NSString *)userId limitsKey:(NSString *)limitsKey
{
    requestType_ = Request_UpdateResumeVisible;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&status=%@",userId,limitsKey];
    
    NSString *function = @"secrecy_setting";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求简历保密设置状态
-(void)getResumeVisible:(NSString *)userId
{
    requestType_ = Request_GetResumeVisible;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@",userId];
    
    NSString *function = @"getResumeSercet";
    NSString *op = @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求公司所有职位
-(void)getCompanyAllZWList:(NSString*)cid  pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_CompanyAllZW;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&page_index=%@&page_size=%@",cid,[NSString stringWithFormat:@"%ld",(long)pageIndex],pageParams];
    
    NSString *function = @"jobzp";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求简历路径
-(void)getResumePath:(NSString *)userId contactType:(NSString *)contactType tradeid:(NSString *)tradeid templateName:(NSString *)templateName
{
    requestType_ = Request_GetResumePath;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&person_contact_type=%@&tradeid=%@&templateName=%@",userId,contactType,tradeid,templateName];
    
    NSString *function = @"get_resume_path";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求职同道合列表
-(void)getTheSamePersonList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetTheSamePersonList;
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    //参数1
    NSMutableDictionary *searchArrDic = [[NSMutableDictionary alloc] init];
    [searchArrDic setObject:userId forKey:@"person_id"];
    NSString *searchStr = [jsonWriter stringWithObject:searchArrDic];
    //参数2
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    //    NSString * function = @"searchZTDHByEs";
    NSString * function = @"get_searchZTDHByEs";
    NSString * op = @"salarycheck_all";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求相关雇主列表
-(void)getRelatedCompanyList:(NSString*)totalId  pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_RelatedCompanyList;
    
    NSString * str = [NSString stringWithFormat:@"company_gz_isadd=1 and company_gz_status=1 and totalid='%@'",totalId];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"action=pageList&where=%@&pageindex=%@&page_size=%@",str,[NSString stringWithFormat:@"%ld",(long)pageIndex],pageParams];
    
    NSString *function = @"getList";
    NSString *op = @"company_guzhu";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//向雇主HR提问题
-(void)askCompanyHR:(NSString*)userId  content:(NSString*)content type:(NSString*)type companyId:(NSString *)companyId
{
    requestType_ = Request_AskCompanyHR;
    
    //组装内容参数
    NSMutableDictionary * contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:content forKey:@"q_title"];
    [contentDic setObject:type forKey:@"q_type"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:contentDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&addInfo=%@",companyId,userId,conditionStr];
    
    NSString *function = @"do_hr_save";
    NSString *op = @"company_guzhu";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求教育背景
-(void)getEdusInfo:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetEdusInfo;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&page_index=%@&page_size=%@",userId,[NSString stringWithFormat:@"%ld",(long)pageIndex],pageParams];
    
    NSString *function = @"get_by_edus";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求更新教育背景
-(void)updateEdusInfo:(NSString *)userId startTime:(NSString *)startTime endTime:(NSString *)endTime schoolName:(NSString *)schoolName majorType:(NSString *)majorType majorName:(NSString *)majorName eduId:(NSString *)eduId edusId:(NSString *)edusId
{
    requestType_ = Request_UpdateEdusInfo;
    
    //组装请求参数
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:startTime forKey:@"start_date"];
    [contentDic setObject:endTime forKey:@"stop_date"];
    [contentDic setObject:schoolName forKey:@"school"];
    [contentDic setObject:majorType forKey:@"zye"];
    [contentDic setObject:majorName forKey:@"zym"];
    [contentDic setObject:@"" forKey:@"edus"];
    [contentDic  setObject:eduId forKey:@"edu_id"];
    [contentDic setObject:edusId forKey:@"edus_id"];
    [contentDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:contentDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",conditionStr];
    
    NSString *function = @"update_edus";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求添加教育背景
-(void)addEdusInfo:(NSString *)userId startTime:(NSString *)startTime endTime:(NSString *)endTime schoolName:(NSString *)schoolName majorType:(NSString *)majorType majorName:(NSString *)majorName eduId:(NSString *)eduId
{
    requestType_ = Request_AddEdusInfo;
    
    //组装请求参数
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:startTime forKey:@"start_date"];
    [contentDic setObject:endTime forKey:@"stop_date"];
    [contentDic setObject:schoolName forKey:@"school"];
    [contentDic setObject:majorType forKey:@"zye"];
    [contentDic setObject:majorName forKey:@"zym"];
    [contentDic setObject:@"" forKey:@"edus"];
    [contentDic setObject:eduId forKey:@"edu_id"];
    [contentDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:contentDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",conditionStr];
    
    NSString *function = @"adds_edus";
    NSString *op = @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求灌薪水文章列表
-(void)getSalaryArticle:(NSString*)job pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString *)userId
{
    requestType_ = Request_SalaryArticleList;
    
    //组装条件参数
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"login_person_id"];
    [searchDic setObject:[MyCommon getAddressBookUUID] forKey:@"client_id"];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    NSString *function = @"getGxsArticleList";
    NSString *op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//发表灌薪水文章
-(void)shareSalaryArticle:(NSString*)userId  job:(NSString*)job  title:(NSString*)title content:(NSString*)content sourceId:(NSString *)articleId
{
    requestType_ = Request_ShareSalaryArticle;
    
    if (!userId) {
        userId = @"";
    }
    //组装条件参数
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary * baseDic = [[NSMutableDictionary alloc] init];
    [baseDic setObject:userId forKey:@"own_id"];
    [baseDic setObject:title forKey:@"title"];
    [baseDic setObject:[Common idfvString] forKey:@"client_id"];
    [baseDic setObject:articleId forKey:@"source"];
    
    //组装内容参数
    NSMutableDictionary * contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:content forKey:@"content"];
    
    NSMutableDictionary *inserDiC = [[NSMutableDictionary alloc]init];
    [inserDiC setObject:baseDic forKey:@"base"];
    [inserDiC setObject:@"5711368758336654" forKey:@"cat"];
    [inserDiC setObject:contentDic forKey:@"content"];
    
    NSString *contentStr = [jsonWriter2 stringWithObject:inserDiC];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"true" forKey:@"get_add_info"];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"insertArr=%@&conditionArr=%@",contentStr,conditionStr];
    
    NSString *op = @"salarycheck_all";
    NSString *function = @"addArticle";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark 灌薪水和评论的列表
- (void)getSalaryArticleAndCommentList:(NSString *)articleId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString *)userId
{
    requestType_ = Request_SalaryArticleAndCommentList;
    NSMutableDictionary * pageDict = [[NSMutableDictionary alloc] init];
    [pageDict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [pageDict setObject:pageParams forKey:@"page_size"];
    [pageDict setObject:userId forKey:@"person_id"];
    [pageDict setObject:[MyCommon getAddressBookUUID] forKey:@"client_id"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *pageStr = [jsonWriter stringWithObject:pageDict];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&conditionArr=%@",articleId, pageStr];
    NSString * function = @"getGxsArticleAndComment";
    NSString * op = @"salarycheck_all_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//请求设置昵称
-(void)updateNickName:(NSString *)userId nickName:(NSString *)nickName
{
    requestType_ = Request_UpdateNickName;
    
    NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
    [updateDic setObject:userId forKey:@"person_id"];
    [updateDic setObject:nickName forKey:@"person_nickname"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *updateStr = [jsonWriter2 stringWithObject:updateDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"data=%@",updateStr];
    NSString * function = @"edit_card";
    NSString * op = @"person_info_api";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取某人在社群内的权限
-(void)getPermissionInGroup:(NSString*)groupId  userId:(NSString*)userId
{
    requestType_ = Request_PermissionInGroup;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&member_id=%@",groupId,userId];
    NSString * function = @"getGroupMemberPermission";
    NSString * op = @"groups";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取文档信息
-(void)getArticleFileInfo:(NSString*)articleId
{
    requestType_ = Request_GetArticleFileInfo;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@",articleId];
    NSString * function = @"getArticleFileInfo";
    NSString * op = @"file";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求关注企业
-(void)addAttentionCompany:(NSString *)userId companyId:(NSString *)companyId
{
    requestType_ = Request_AddAttentionCompany;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@&get_tips=%@&user_role=%@",userId,companyId,@"0",@"20"];
    NSString * function = @"addPersonFollow";
    NSString * op = @"zd_person_follow_rel";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求取消关注企业
-(void)cancelAttentionCompany:(NSString *)userId companyId:(NSString *)companyId
{
    requestType_ = Request_CancelAttentionCompany;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@&user_role=%@",userId,companyId,@"20"];
    NSString * function = @"delPersonFollow";
    NSString * op = @"zd_person_follow_rel";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求企业关注列表
-(void)getAttentionCompanyList:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
{
    requestType_ = Request_GetAttentionCompanyList;
    
    NSMutableDictionary * dateDic = [[NSMutableDictionary alloc] init];
    [dateDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [dateDic setObject:pageParams forKey:@"pagesize"];
    [dateDic setObject:userId forKey:@"visitor_pid"];
    [dateDic setObject:@"20" forKey:@"user_role"];
    [dateDic setObject:@"1" forKey:@"follow_type"];
    [dateDic setObject:userId forKey:@"uid"];
    [dateDic setObject:@"1" forKey:@"get_zw_update"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *dateStr = [jsonWriter stringWithObject:dateDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",dateStr];
    NSString * function = @"new_get_follow_list";
    NSString * op = @"zd_person_follow_rel";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求嘻嘻嘻嘻嘻嘻数据
-(void)uploadImgData:(NSString*)imgCode
{
    requestType_ = Request_UploadImgData;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"imgcode=%@&is_ios_upload=%@",imgCode,@"1"];
    NSString * function = @"addimg";
    NSString * op = @"upload";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}


//分享成功后调用
-(void)shareSuccessLogs:(NSString*)type url:(NSString*)url  userId:(NSString*)userId role:(NSString*)role shareType:(NSString *)shareType
{
    requestType_ = Request_ShareLogs;
    if (!userId || [userId isEqual:[NSNull null]]) {
        userId = @"";
    }
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"" forKey:@"logs_ip"];
    [conditionDic setObject:userId forKey:@"user_id"];
    [conditionDic setObject:role forKey:@"role"];
    // shareType 1好友 2朋友圈 3腾讯微博 4邮箱
    [conditionDic setObject:shareType forKey:@"share_type"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"type=%@&url=%@&conditionArr=%@",type,url,conditionStr];
    NSString * function = @"insert_logs";
    NSString * op = @"weixin_share_logs";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求获取薪酬预测
-(void)getSalaryPrediction:(NSString *)keyWord
{
    requestType_ = Request_GetSalaryPrediction;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"kw=%@&regionid=%@&conditionArr=%@",keyWord,@"",@""];
    NSString * function = @"doSalaryPredicate";
    NSString * op = @"resume_salary_cnt_basic";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求职导列表推荐行家
-(void)getSalaryExpert:(NSString *)userId
{
    requestType_ = Request_GetSalaryExpert;
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"personId"];
    [conditionDic setObject:@"2" forKey:@"belongs"];
    [conditionDic setObject:@"1" forKey:@"get_recommend"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = @"busi_get_expert_list_person";
    NSString * op = @"zd_category_expert_rel";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求简历对比数据
-(void)getResumeRcomparison:(NSString *)userId personId:(NSString *)personId personSalary:(NSString *)personSalary;
{
    requestType_ = Request_GetResumeRcomparison;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_my_id=%@&person_compare_id=%@&person_compare_yuex=%@",userId,personId,personSalary];
    NSString * function = @"compare_xzdb";
    NSString * op = @"salarycheck_all";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求所有消息类型的列表
-(void)getMessageList:(NSInteger)pushType msgType:(NSString*)msgType status:(NSInteger)status userId:(NSString*)userId
{
    requestType_ = Request_MessageList;
    
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@",conditionStr];
    NSString * function = @"busi_getLatestMessageList";
    NSString * op = @"yl_app_push";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求一种消息类型的列表
-(void)getOneMessageList:(NSInteger)pushType msgType:(NSString*)msgType status:(NSInteger)status userId:(NSString*)userId pageSize:(NSInteger)pageSize page:(NSInteger)pageIndex
{
    requestType_ = Request_OneMessageList;
    
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"1" forKey:@"product"];  // 1为一览，2为墨缘
    [searchDic setObject:[NSString stringWithFormat:@"%ld",(long)pushType] forKey:@"push_type"]; //0为消息，1为通知
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:[NSString stringWithFormat:@"%@",msgType] forKey:@"msg_type"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:@"1" forKey:@"filter_field"];
    [conditionDic setObject:@"1" forKey:@"get_info_flag"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter2 stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,condition];
    NSString * function = @"getDataList";
    NSString * op = @"yl_app_push";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求提交问卷调查
-(void)addQuestionnaireWithItemId:(NSString *)itemId userId:(NSString *)userId userInfoDic:(NSMutableDictionary *)userInfoDic conditionDic:(NSMutableDictionary *)conditionDic
{
    requestType_ = Request_addQuestionnaire;
    
    //组件搜索参数
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *personInfoArrStr = [jsonWriter stringWithObject:userInfoDic];
    NSString *conditionArrStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"wenjuanid=%@&person_id=%@&personInfoArr=%@&conditionArr=%@",itemId,userId,personInfoArrStr,conditionArrStr];
    NSString * function = @"appinsert";
    NSString * op = @"co_research_user_dati";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求Hi模块的数据列表
-(void)getYL1001HIList:(NSString*)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetYl1001HIList;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"user_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_group_dynamic"];
    [conditionDic setObject:@"1" forKey:@"get_summary_flag"];
    [conditionDic setObject:@"1" forKey:@"get_content_img_flag"];
    [conditionDic setObject:@"0" forKey:@"get_person_other"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    NSString * function = @"getMyDynamic";
    NSString * op = @"groups_newsfeed_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求用户详情
-(void)getPersonDetailWithPersonId:(NSString *)personId userId:(NSString *)userId
{
    requestType_ = Request_GetPersonDetail;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&visitor_pid=%@",userId,personId];
    NSString * function = @"busi_getPersonDetail";
    NSString * op = @"zd_person";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//请求公司登录
-(void)companyLogin:(NSString*)userName pwd:(NSString*)pwd safeCode:(NSString*)safeCode
{
    requestType_ = Request_CompanyLogin;
    //设置请求参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:safeCode forKey:@"safe_code"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * str = [jsonWriter stringWithObject:dic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"skiptradecheck=0&uname=%@&pwd=%@&carr=%@",userName,pwd,str];
    NSString * function = @"doLogin";
    NSString * op   =   @"company";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求绑定公司的信息
-(void)companyHRDetail:(NSString*)companyId
{
    requestType_ = Request_CompanyHRDetail;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",companyId];
    NSString * function = @"getCompanyCntInfo";
    NSString * op   =   @"company_cache";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//搜简历
-(void)companySearchResumeCompanyId:(NSString *)companyId regionId:(NSString *)regionId eduId:(NSString *)eduId workeAge:(NSString *)gznum workeAge1:(NSString *)gznum1 keyWord:(NSString *)keyword pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchType:(NSString *)searchType
{
    requestType_ = Request_CompanySearchResume;
    
    //组装搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:searchType forKey:@"searchType"];
    [searchDic setObject:regionId forKey:@"regionid"];
    [searchDic setObject:eduId forKey:@"eduId"];
    
    if ([gznum isEqualToString:@"0"] && [gznum1 isEqualToString:@""]) {//应届毕业生
        [searchDic setObject:@"0" forKey:@"rctypes"];
    }else{
        [searchDic setObject:gznum forKey:@"gznum1"];
        [searchDic setObject:gznum1 forKey:@"gznum2"];
        
    }
    
    [searchDic setObject:keyword forKey:@"keywords"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&searchArr=%@&conditionArr=%@",companyId,searchStr,conditionStr];
    NSString * function = @"personSearch";
    NSString * op = @"resume_search_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
    
}

//请求绑定公司的面试确认通知
-(void)companyInterviewEmail:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_CompanyInterviewEmail;
    
    NSMutableDictionary * companyDic = [[NSMutableDictionary alloc] init];
    [companyDic setObject:companyId forKey:@"company_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * companyInfo = [jsonWriter stringWithObject:companyDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    //[conditionDic setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"companyInfo=%@&conditionArr=%@&pageindex=%@",companyInfo,conditionStr,[NSString stringWithFormat:@"%ld",(long)pageIndex]];
    NSString * function = @"getEmailRecordList";
    NSString *     op   = @"pmailbox";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求绑定公司的人才提问
-(void)companyQuestion:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_CompanyQuestion;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"2"] forKey:@"order_answer"];
    [conditionDic setObject:@"1" forKey:@"show_type"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@&pageindex=%@",companyId,conditionStr,[NSString stringWithFormat:@"%ld",(long)pageIndex]];
    NSString * function = @"getRequestList";
    NSString * op   =   @"company_hr_qa";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求绑定公司的未读简历
-(void)companyResume:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize jobid:(NSString *)jobid searchModal:(SearchParam_DataModal *)searchModal
{
    requestType_ = Request_CompanyResume;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_id"];
    }
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    if (jobid.length > 0) {
        [searchDic setObject:jobid forKey:@"company_person_jobid"];
    }
    if (searchModal.regionId_.length > 0 && ![searchModal.regionId_ isEqualToString:@"100000"]) {
        [searchDic setObject:searchModal.regionId_ forKey:@"regionid"];
    }
    if (searchModal.workAgeValue_)
    {
        [searchDic setObject:searchModal.workAgeValue_ forKey:@"age1"];
    }
    if (searchModal.workAgeValue_1) {
        [searchDic setObject:searchModal.workAgeValue_1 forKey:@"age2"];
    }
    if([searchModal.experienceValue1 isEqualToString:@"0"]){
        [searchDic setObject:searchModal.experienceValue1 forKey:@"rctypeId"];
    }
    else{
        if (searchModal.experienceValue1) {
            [searchDic setObject:searchModal.experienceValue1 forKey:@"gznum1"];
        }
        if (searchModal.experienceValue2) {
            [searchDic setObject:searchModal.experienceValue2 forKey:@"gznum2"];
        }
    }
    
    if (searchModal.eduId_.length > 0) {
        [searchDic setObject:searchModal.eduId_ forKey:@"eduId"];
    }
    if (searchModal.timeStr_.length > 0) {
        [searchDic setObject:searchModal.timeStr_ forKey:@"repeat"];
    }
    if (searchModal.workTypeValue_.length > 0) {
        [searchDic setObject:searchModal.workTypeValue_ forKey:@"isNews"];
    }
    if (searchModal.process_state.length > 0) {
        [searchDic setObject:searchModal.process_state forKey:@"process_state"];
    }
    if (searchModal.searchName.length > 0) {
        [searchDic setObject:searchModal.searchName forKey:@"iname"];
    }

    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    SBJsonWriter *jsonWriter1 = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter1 stringWithObject:searchDic];
    if (searchDic.count <= 0) {
        searchStr = @"";
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@&searchArr=%@",companyId,conditionStr,searchStr];
    NSString * function = @"get_send_job_resume";//@"getCmailbox";mUnReadResumeList
    NSString * op   =   @"company_person_busi";//@"cmailbox_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取公司推荐的简历
- (void)getCompanyRecommendedResume:(NSString *)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize jobid:(NSString *)jobid searchModal:(SearchParam_DataModal *)searchModal
{
    requestType_ = Request_CompanyRecommendedResume;
   
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_id"];
    }
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    
//    if (fortype.length > 0) {
//        [searchDic setObject:fortype forKey:@"company_person_fortype"];
//    }
    if (jobid.length > 0) {
        [searchDic setObject:jobid forKey:@"company_person_jobid"];
    }
    if (searchModal.regionId_.length > 0 && ![searchModal.regionId_ isEqualToString:@"100000"]) {
        [searchDic setObject:searchModal.regionId_ forKey:@"regionid"];
    }
    if (searchModal.workAgeValue_)
    {
        [searchDic setObject:searchModal.workAgeValue_ forKey:@"age1"];
    }
    if (searchModal.workAgeValue_1) {
        [searchDic setObject:searchModal.workAgeValue_1 forKey:@"age2"];
    }
    if (searchModal.eduId_.length > 0) {
        [searchDic setObject:searchModal.eduId_ forKey:@"eduId"];
    }
    if (searchModal.timeStr_.length > 0) {
        [searchDic setObject:searchModal.timeStr_ forKey:@"repeat"];
    }
    if (searchModal.workTypeValue_.length > 0) {
        [searchDic setObject:searchModal.workTypeValue_ forKey:@"isNews"];
    }
    if (searchModal.process_state.length > 0) {
        [searchDic setObject:searchModal.process_state forKey:@"process_state"];
    }
    if (searchModal.searchName.length > 0) {
        [searchDic setObject:searchModal.searchName forKey:@"iname"];
    }
    if(searchModal.dicTime.length > 0){
        [searchDic setObject:searchModal.dicTime forKey:@"changci"];
    }

    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];

    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    if (searchDic.count <= 0) {
        searchStr = @"";
    }
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&searchArr=%@&conditionArr=%@&",companyId, searchStr, conditionStr];
    NSString * function = @"getTjPerson3000And3001";
    NSString * op   =   @"company_person_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 企业是否能够查看人才联系方式(用于预览推荐简历时是下载，还是发送面试通知)
- (void)companyIslookPersonContact:(NSString *)companyId userId:(NSString *)userId
{
    requestType_ = Request_CompanyIslookPersonContact;
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@",companyId, userId];
    NSString * function = @"companyIslookPersonContact";
    NSString * op   =   @"company_info_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 设置推荐的简历已经阅读
- (void)setRecommendResumeReaded:(NSString *)recommendId
{
    requestType_ = Request_SetRecommendResumeReaded;
    NSString * bodyMsg = [NSString stringWithFormat:@"recomid=%@", recommendId];
    NSString * function = @"setRecommendView";
    NSString * op   =   @"tjPerson_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark 公司查看用户的简历的联系信息
- (void)downloadResume:(NSString *)companyId userId:(NSString *)userId
{
    requestType_ = Request_DownloadResume;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    
    NSString * conditionStr;
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        conditionStr = [jsonWriter stringWithObject:conditionDic];
    }

    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&conditionArr=%@",companyId, userId,conditionStr];
    NSString * function = @"resumeDownload";
    NSString * op   =   @"company";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求简历预览的url
-(void)getResumeURL:(NSString*)userId roletype:(NSString*)roletype companyId:(NSString*)companyId analyze:(NSString *)analyze
{
    requestType_ = Request_ResumeURL;
    NSString * bodyMsg = nil;
    if (analyze == nil) {
        bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&role_id=%@",userId,roletype,companyId];
    }else{
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:analyze forKey:@"analyze"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
        bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&role_id=%@&conditionArray=%@",userId,roletype,companyId,conditionStr];
    }
    NSString * function = @"getPreivewResumeUrl_offerpai";
    NSString * op   =   @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//推荐报告
-(void)getRecReportURL:(NSString*)userId roletype:(NSString*)roletype companyId:(NSString*)companyId tjtype:(NSString *)tjtype tjid:(NSString *)tjid{
    requestType_ = Request_ResumeURL;
    NSString * bodyMsg = nil;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:tjtype forKey:@"tjtype"];
    [conditionDic setObject:tjid forKey:@"tjid"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&role_id=%@&conditionArray=%@",userId,roletype,companyId,conditionStr];
  
    NSString * function = @"getPreivewResumeUrl_offerpai";
    NSString * op   =   @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//简历预览二维码请求
-(void)getResumeZbar:(NSString *)personId roletype:(NSString *)roletype companyId:(NSString *)companyId
{
    requestType_ = Request_ResumeZbar;
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&roletype=%@&role_id=%@",personId,roletype,companyId];
    NSString * function = @"getPreivew3gUrl";
    NSString * op   =   @"person_info_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

/**
 *  请求职位详情3GURL
 *
 *  @param userId     用户ID
 *  @param positionId 职位ID
 */
- (void)getPositionDetail3GURLWithUserId:(NSString *)userId positionId:(NSString *)positionId location:(NSString *)location
{
    requestType_ = Request_PositionDetail3GURL_;
    
    //设置请求参数
    NSString * bodyMsg;
    if (userId == nil) {
        bodyMsg= [NSString stringWithFormat:@"job_id=%@&location=%@",positionId,location];
    }else{
        bodyMsg= [NSString stringWithFormat:@"job_id=%@&person_id=%@&location=%@",positionId, userId,location];
    }
    
    NSString * function = @"getzw3gurl";
    NSString * op   =   @"zp_info";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//回答绑定公司中的问题
-(void)doHRAnswer:(NSString*)companyId  questionId:(NSString*)qId answererId:(NSString*)answererId content:(NSString*)content
{
    requestType_ = Request_DoHRAnswer;
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:answererId forKey:@"answerer_id"];
    [infoDic setObject:content forKey:@"a_content"];
    [infoDic setObject:@"1" forKey:@"isshow"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * infoStr = [jsonWriter stringWithObject:infoDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&qa_id=%@&answerInfoArr=%@",companyId, qId,infoStr];
    NSString * function = @"doAnswer";
    NSString * op   =   @"company_hr_qa";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//设置简历是否合适
-(void)setResumePass:(NSString*)resumeId isPass:(NSString *)isPass crnd:(NSString *)crnd
{
    requestType_ = Request_SetResumePass;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:isPass forKey:@"pass"];
    
    [conditionDic setObject:crnd forKey:@"Crnd"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"zpid=%@&conditionArr=%@",resumeId,conditionStr];
    NSString * function = @"setResumePass";
    NSString * op   =   @"cmailbox";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取绑定公司的其他HR列表
-(void)getCompanyOtherHR:(NSString*)companyId
{
    requestType_ = Request_GetCompanyOtherHR;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"allList" forKey:@"listtype"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",companyId,conditionStr];
    NSString * function = @"search";
    NSString * op   =   @"company_contact";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}


//转发简历(企业)
-(void)transpondResume:(NSString*)companyId personId:(NSString*)personId flag:(NSString*)flag title:(NSString*)title email:(NSString *)email conditionArr:(NSDictionary *)condictionDic
{
    requestType_ = Request_TranspondResume;
    NSString *condictionStr = @" ";
    if (condictionDic) {
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        condictionStr = [jsonWriter stringWithObject:condictionDic];
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&person_source=%@&email=%@&title=%@&conditionArr=%@",companyId, personId, flag, email, title, condictionStr];
    NSString * function = @"resumeTransfer";
    NSString * op   =   @"company";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//转发简历(顾问)
-(void)transpondResume:(NSString *)owerId personId:(NSString *)personId email:(NSString *)email title:(NSString *)title conditionArr:(NSDictionary *)condictionDic
{
    requestType_ = Request_TranspondGuwenResume;
    NSString *condictionStr = nil;
    if (condictionDic) {
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        condictionStr = [jsonWriter stringWithObject:condictionDic];
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"ower_id=%@&person_id=%@&email=%@&title=%@&conditionArr=%@",owerId,personId,email,title, condictionStr];
    NSString * function = @"resumeTransftoguwei";
    NSString * op   =   @"Companydeal";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//获取公司面试模板
-(void)getInterviewModel:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetInterviewModel;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"pageList" forKey:@"type"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",companyId,conditionStr];
    NSString * function = @"getCompanySmsTpl";
    NSString * op   =   @"sms_interview_template";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取公司在招职位
-(void)getCompanyZWForUsing:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetCompanyZWForUsing;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"type"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&searArr=%@&page_index=%@",companyId,conditionStr,[NSString stringWithFormat:@"%ld",(long)pageIndex]];
    NSString * function = @"getZpInfoAll";
    NSString * op   =   @"zp";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//发送面试通知
-(void)sendInterview:(NSString*)type  jianliId:(NSString*)jianliId  tradeId:(NSString*)tradeId companyId:(NSString*)companyId personId:(NSString*)personId zpId:(NSString*)zpId mailtext:(NSString*)mailtext year:(NSString*)year month:(NSString*)month day:(NSString*)day hour:(NSString*)hour min:(NSString*)min address:(NSString*)address pname:(NSString*)pname phone:(NSString*)phone offerId:(NSString *)offerId templname:(NSString*)templname isOfferPartyInvite:(BOOL)isOfferParty loginId:(NSString *)loginId recommndId:(NSString *)recommndId interviewType:(NSString *)interviewType
{
    requestType_ = Request_SendInterview;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:mailtext forKey:@"mailtext"];
    [conditionDic setObject:year forKey:@"year"];
    [conditionDic setObject:month forKey:@"month"];
    [conditionDic setObject:day forKey:@"day"];
    [conditionDic setObject:hour forKey:@"hours"];
    [conditionDic setObject:min forKey:@"min"];
    [conditionDic setObject:address forKey:@"address"];
    [conditionDic setObject:pname forKey:@"pname"];
    [conditionDic setObject:phone forKey:@"phone"];
    [conditionDic setObject:templname forKey:@"sdesc"];
    [conditionDic setObject:@"1" forKey:@"isMobile"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    
    NSMutableDictionary *mobileDic = [[NSMutableDictionary alloc] init];
    if (isOfferParty) {
        [conditionDic setObject:@"1" forKey:@"offer"];
        [conditionDic setObject:offerId forKey:@"offer_id"];
        [conditionDic setObject:recommndId forKey:@"tuijian_id"];
        [conditionDic setObject:loginId forKey:@"person_id"];
        
        if (interviewType != nil) {
            //msgType  100通知面试  200面试准备
            [mobileDic setObject:interviewType forKey:@"msgtype"];
        }
        
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    NSString *mobileStr = [jsonWriter stringWithObject:mobileDic];
    
    //设置请求参数
    NSString * bodyMsg;
    if (interviewType != nil) {//offer面试通知
        bodyMsg = [NSString stringWithFormat:@"apptype=%@&appid=%@&interview_type=%@&tradeid=%@&company_id=%@&person_id=%@&zp_id=%@&conditionArr=%@&mobileArr=%@", @"cmailbox", jianliId, type, tradeId, companyId, personId, zpId,conditionStr, mobileStr];
    }
    else
    {//其他面试通知
        bodyMsg = [NSString stringWithFormat:@"apptype=%@&appid=%@&interview_type=%@&tradeid=%@&company_id=%@&person_id=%@&zp_id=%@&conditionArr=%@",[NSString stringWithFormat:@"cmailbox"],jianliId,[NSString stringWithFormat:@"%@",type],tradeId,[NSString stringWithFormat:@"%@",companyId],personId,zpId,conditionStr];
    }
    
    NSString * function = @"doInterviewNotify";
    NSString * op   =   @"company";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取服务信息的url
-(void)getServiceUrl:(NSString*)companyId
{
    requestType_ = Request_GetServiceUrl;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@",companyId];
    NSString * function = @"getCompanyServiceInfoUrlToapp";
    NSString * op   =   @"company_info";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//文章添加点赞
-(void)addArticleLike:(NSString*)articleId
{
    requestType_ = Request_ArticleAddLike;
    
    NSString *personId = @"";
    if ([Manager shareMgr].haveLogin) {
        personId = [Manager getUserInfo].userId_;
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&type=%@",articleId,personId,@"add"];
    NSString * function = @"addArticlePraise";
    NSString * op   =   @"yl_praise_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//绑定企业和个人
-(void)bindingCompany:(NSString*)companyId personId:(NSString*)personId synergyId:(NSString *)synergyId
{
    requestType_ = Request_BindingCompany;
    
    NSString * conditionStr = nil;
    
    if ([synergyId isKindOfClass:[NSString class]] && ![synergyId isEqualToString:@""]) {
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        [conditionDic setObject:synergyId forKey:@"bingding_synergy_id"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        conditionStr = [jsonWriter stringWithObject:conditionDic];
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@",companyId,personId];
    if (conditionStr) {
        bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&conditionArr=%@",companyId,personId,conditionStr];
    }
    NSString * function = @"bindingCompanyPerson";
    NSString * op   =   @"company_info";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取绑定的企业账号
-(void)getBindingCompany:(NSString*)personId
{
    requestType_ = Request_GetBindingCompany;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = @"bingDingInfo";
    NSString * op   =   @"company_info";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//获取职位名称
- (void)getPositionNameWith:(NSString *)positionId
{
    requestType_ = Request_GetPositionNameWith;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"zp_id=%@",positionId];
    NSString * function = @"getzp_jtzw";
    NSString * op   =   @"zp_info";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求公司详情3GURL
- (void)getCompanyDetail3GURLWithUserId:(NSString *)userId companyId:(NSString *)companyId
{
    requestType_ = Request_GetCompanyPositionDetailUrl;
    
    //设置请求参数
    NSString * bodyMsg;
    
    if (userId == nil) {
        bodyMsg= [NSString stringWithFormat:@"company_id=%@",companyId];
    }else{
        bodyMsg= [NSString stringWithFormat:@"company_id=%@&person_id=%@",companyId, userId];
    }
    
    NSString * function = @"getcompany3gurl";
    NSString * op   =   @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//设置简历已阅
-(void)setNewMailRead:(NSString*)companyId personId:(NSString*)personId cmailId:(NSString*)cmailId
{
    requestType_ = Request_SetNewMailRead;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&cmail_id=%@",companyId, personId,cmailId];
    NSString * function = @"updateCmailboxNew";
    NSString * op   =   @"cmailbox";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//添加关注学校
- (void)attendCareerSchoolWithSchollId:(NSString *)schoolId_ userId:(NSString *)userId
{
    requestType_ = Request_AttendCareerSchool;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@&get_tips=%@&user_role=%@",userId, schoolId_,@"0",@"30"];
    NSString * function = @"addPersonFollow";
    NSString * op   =   @"zd_person_follow_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//取消关注学校
- (void)changAttendCareerSchoolWithSchoolId:(NSString *)schoolId_ userId:(NSString *)userId
{
    requestType_ = Request_ChangAttendCareerSchool;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&follow_uid=%@&&user_role=%@",userId, schoolId_,@"30"];
    NSString * function = @"delPersonFollow";
    NSString * op   =   @"zd_person_follow_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求我关注学校列表
- (void)getAttendSchoolListWithUserId:(NSString *)userId pageSize:(NSInteger)pageSize_ pageIndex:(NSInteger)pageIndex_
{
    requestType_ = Request_GetAttendSchoolList;
    
    //设置请求参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    [conditionDic setObject:@"1" forKey:@"follow_type"];
    [conditionDic setObject:@"30" forKey:@"user_role"];
    [conditionDic setObject:@"1" forKey:@"get_fair"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"pageindex"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionStr];
    NSString * function = @"new_get_follow_list";
    NSString * op   =   @"zd_person_follow_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//请求学校宣讲会列表
- (void)getSchoolXJHListWithSchoolId:(NSString *)schoolId_ pageSize:(NSInteger)pageSize_ pageIndex:(NSInteger)pageIndex_
{
    requestType_ = Request_GetSchoolXJHList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"page_index"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"sid=%@&conditionArr=%@",schoolId_,conditionStr];
    NSString * function = @"getXjhListBySchid";
    NSString * op   =   @"cps_xjh";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求薪资大比拼结果（新）
-(void)getSalaryCompareResult:(NSString*)userId zw:(NSString*)zw kwflag:(NSString*)kwflag salary:(NSString*)salary regionId:(NSString *)regionId bg:(NSString*)bg
{
    requestType_ = Request_SalaryCompareResult;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"person_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",zw] forKey:@"kw"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",kwflag] forKey:@"kw_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",salary] forKey:@"salary"];
    [conditionDic setObject:bg forKey:@"bg"];
    if (regionId && ![regionId isEqualToString:@""]) {
       [conditionDic setObject:regionId forKey:@"zw_regionid"]; 
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
//        NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
//        [dic2 setObject:@"1" forKey:@"get_course_flag"];
//        NSString * str = [jsonWriter stringWithObject:dic2];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@",conditionStr];
    NSString * function = @"getSalaryCompareResult";
    NSString * op   =   @"resume_salary_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//上传语音文件
- (void)upLoadVoiceFile:(NSData *)data fileName:(NSString *)name
{
    self.bUploadFile_ = YES;
    self.fileName_ = name;
    
    //设置请求类型
    requestType_ = Request_UploadVoiceFile;
    
    NSString *path = @"http://img105.job1001.com";
    [self startConn:[NSString stringWithFormat:@"%@/save_audio.php?file_path_pre=%@",path,path] bodyMsg:(NSString *)data method:nil];
}

//上传图片
-(void)uploadPhotoData:(NSData *)data name:(NSString *)name
{
    self.bUploadFile_ = YES;
    self.fileName_ = name;
    
    //设置请求类型
    requestType_ = Request_UploadPhotoFile;
    NSLog(@"%d",requestType_);
    
    NSString * path = @"http://img105.job1001.com";
    [self startConn:[NSString stringWithFormat:@"%@/albumSave.php?file_path_pre=%@",path,path] bodyMsg:(NSString *)data method:nil];
}

//简历添加图片
-(void)addResumePhoto:(NSString *)userId oldPhotoId:(NSString *)oldPhotoId photoModel:(Upload_DataModal *)model requestType:(NSString *)requestType;
{
    requestType_ = Request_AddResumePhoto;
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    //photo_info
    NSMutableDictionary * photoInfoDic = [[NSMutableDictionary alloc] init];
    [photoInfoDic setObject:model.name_ forKey:@"name"];
    [photoInfoDic setObject:model.size_ forKey:@"size"];
    [photoInfoDic setObject:model.exe_ forKey:@"exe"];
    [photoInfoDic setObject:model.path_ forKey:@"path"];
    for (Upload_DataModal *dataModel in model.pathArr_) {
        if ([dataModel.size_ isEqualToString:@"960"]) {
            [photoInfoDic setObject:dataModel.path_ forKey:@"path_960"];
        }else if ([dataModel.size_ isEqualToString:@"670"]){
            [photoInfoDic setObject:dataModel.path_ forKey:@"path_670"];
        }else if ([dataModel.size_ isEqualToString:@"220"]){
            [photoInfoDic setObject:dataModel.path_ forKey:@"path_220"];
        }else if ([dataModel.size_ isEqualToString:@"140"]){
            [photoInfoDic setObject:dataModel.path_ forKey:@"path_140"];
        }else if ([dataModel.size_ isEqualToString:@"80"]){
            [photoInfoDic setObject:dataModel.path_ forKey:@"path_80"];
        }
    }
    NSString * photoInfoStr = [jsonWriter stringWithObject:photoInfoDic];
    
    NSMutableDictionary * conditionArr = [[NSMutableDictionary alloc] init];
    if (oldPhotoId != nil) {
        [conditionArr setObject:oldPhotoId forKey:@"photo_id"];
    }
    [conditionArr setObject:@"1" forKey:@"scene"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionArr];
    
    //设置请求参数
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&photo_info=%@&condition_arr=%@",userId,photoInfoStr,conditionStr];
    
    NSString * function = @"addPersonPhoto";
    NSString * op   =   @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取简历图片语音
- (void)getResumePhotoAndVoice:(NSString *)userId
{
    requestType_ = Request_GetResumePhotoAndVoice;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    [conditionDic setObject:@"pp_id,pp_path,pp_path_140_140" forKey:@"fields"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&photo_conditionArr=%@",userId,conditionStr];
    NSString * function = @"getDefaultPhotoAudio";
    NSString * op   =   @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//删除简历图片
- (void)deleteResumeImage:(NSString *)userId photoId:(NSString *)photoId
{
    requestType_ = Request_DeleteResumeImage;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&photo_id=%@",userId,photoId];
    NSString * function = @"delPersonPhoto";
    NSString * op   =   @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//添加简历语音
- (void)addResumeVoice:(NSString *)userId voiceName:(NSString *)voiceName voiceDesc:(NSString *)voiceDesc voicePath:(NSString *)voicePath voiceTime:(NSString *)voiceTime voiceId:(NSString *)voiceId voiceCateId:(NSString *)voiceCateId type:(NSString *)type;
{
    requestType_ = Request_AddResumeVoice;
    voicePath = [@"http://img105.job1001.com/" stringByAppendingString:voicePath];
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:voiceName forKey:@"name"];
    [infoDic setObject:voiceDesc forKey:@"desc"];
    [infoDic setObject:voicePath forKey:@"path"];
    [infoDic setObject:voiceTime forKey:@"time"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * infoDicStr = [jsonWriter stringWithObject:infoDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    if (voiceId !=nil) {
        [conditionDic setObject:voiceId forKey:@"audio_id"];
    }
    if (voiceCateId != nil) {
        [conditionDic setObject: voiceCateId forKey:@"cate_id"];
    }
    
    [conditionDic setObject:@"1" forKey:@"scene"];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&audio_info=%@&condition_arr=%@",userId,infoDicStr,conditionStr];
    NSString * function = @"addPersonAudio";
    NSString * op = @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求薪资搜索比拼结果
-(void)getSalarySearchResult:(NSString*)zw kwflag:(NSString*)kwflag salary:(NSString*)salary regionId:(NSString*)regionId userId:(NSString *)userId tradeId:(NSString *)tradeId tradeName:(NSString *)tradeName
{
    requestType_ = Request_SalarySearchResult;
    if (!tradeId) {
        tradeId = @"";
    }
    if (!tradeName) {
        tradeName = @"";
    }
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"person_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",zw] forKey:@"kw"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",kwflag] forKey:@"kw_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",salary] forKey:@"salary"];
    [conditionDic setObject:regionId forKey:@"zw_regionid"];
    [conditionDic setObject:tradeId forKey:@"tradeid"];
    [conditionDic setObject:tradeName forKey:@"trade_name"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"1" forKey:@"get_course_flag"];
    NSString * str = [jsonWriter stringWithObject:dic2];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,str];
    NSString * function = @"busi_getSalarySearchResult";
    NSString * op   =   @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
    
}

#pragma mark 请求薪资搜索比拼结果（新）
-(void)getSalarySearchResult2:(NSString*)zw kwflag:(NSString*)kwflag salary:(NSString*)salary regionId:(NSString*)regionId userId:(NSString *)userId tradeId:(NSString *)tradeId tradeName:(NSString *)tradeName orderId:(NSString *)orderId
{
    requestType_ = Request_SalarySearchResult2;
    if (!tradeId) {
        tradeId = @"";
    }
    if (!tradeName) {
        tradeName = @"";
    }
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"person_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",zw] forKey:@"kw"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",kwflag] forKey:@"kw_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%@",salary] forKey:@"salary"];
    [conditionDic setObject:regionId forKey:@"zw_regionid"];
    [conditionDic setObject:tradeId forKey:@"tradeid"];
    [conditionDic setObject:tradeName forKey:@"trade_name"];
    if (orderId && ![orderId isEqualToString:@""]) {
        [conditionDic setObject:orderId forKey:@"ordco_id"];
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"1" forKey:@"get_course_flag"];
    NSString * str = [jsonWriter stringWithObject:dic2];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,str];
    NSLog(@"searchArr=%@",conditionStr);
    NSLog(@"conditionArr=%@",str);
    
    NSString * function = @"getSalarySearchResult";
    NSString * op   =   @"resume_salary_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//请求解除绑定
-(void)cancelBindCompany:(NSString*)companyId  personId:(NSString*)personId
{
    requestType_ = Request_CancelBindCompany;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@",companyId,personId];
    NSString * function = @"cancelBingDing";
    NSString * op   =   @"company_info";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//注册时请求添加关注学校
- (void)addAttentionSchoolWithUserId:(NSString *)userId schoolName:(NSString *)schoolName
{
    requestType_ = Request_AddAttentionSchoolWithUserId;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"sname=%@&person_id=%@",schoolName,userId];
    NSString * function = @"schoolCare";
    NSString * op   =   @"cps_xjh";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取身边工作
- (void)getNearbyWork:(NSString *)searchType_ keyWords:(NSString *)keyWords_ keyType:(NSString *)keyType_ majorId:(NSString *)majorId_ totalId:(NSString *)totalId_ tradeId:(NSString *)tradeId_ lng:(NSString *)lng_ lat:(NSString *)lat_ range:(NSString *)range_ pageSize:(NSString *)pageSize_ pageIndx:(NSString *)pageIndex_
{
    requestType_ = Request_NearbyWork;
    
    //设置请求参数
    if (keyWords_ == nil) {
        keyWords_ = @"";
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"searchType=%@&keywords=%@&keyType=%@&majorId=%@&totalId=%@&tradeId=%@&lng=%@&lat=%@&rang=%@&pageIndex=%@&pageSize=%@",searchType_,keyWords_,keyType_,majorId_,totalId_,tradeId_,lng_,lat_,range_,pageIndex_,pageParams];
    
    NSString * function = @"searchMapCompany";
    NSString * op   =   @"map_company";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//个人主页访问统计
-(void)myCenterVisitLog:(NSString*)userId visitorId:(NSString*)visitorId
{
    requestType_ = Request_MyCenterVisit;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&visit_uid=%@",visitorId,userId];
    NSString * function = @"addVisit";
    NSString * op   =   @"zd_person_visit";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//第三方登录 判断是否绑定
- (void)detectBindingWithConnectSource:(NSString *)connectSource_ openId:(NSString *)openId_
{
    requestType_ = Request_DetectBinding;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"connect_source=%@&open_id=%@",connectSource_,openId_];
    
    NSString * function = @"detectBind";
    NSString * op   =   @"Job1001user_connect";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//创建账号并绑定第三方账号
- (void)bulidPersonWithConnectSource:(NSString *)connectSource_ openId:(NSString *)openId_ userName:(NSString *)userName_ nickName:(NSString *)nickName_ sex:(NSString *)sex_ picSmall:(NSString *)picSmall_ picMiddle:(NSString *)picMiddle_ picOriginal:(NSString *)picOriginal_
{
    requestType_ = Request_BuildPerson;
    
    NSMutableDictionary * personDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * connectInfoDic = [[NSMutableDictionary alloc] init];
    [connectInfoDic setObject:nickName_ forKey:@"name"];
    [connectInfoDic setObject:nickName_ forKey:@"nick_name"];
    [connectInfoDic setObject:sex_ forKey:@"sex"];
    [connectInfoDic setObject:picSmall_ forKey:@"pic_small"];
    [connectInfoDic setObject:picMiddle_ forKey:@"pic_middle"];
    [connectInfoDic setObject:picOriginal_ forKey:@"pic_original"];
    [connectInfoDic setObject:@"0" forKey:@"totalid"];
    [connectInfoDic setObject:@"1001" forKey:@"tradeid"];
    [connectInfoDic setObject:@"" forKey:@"person_job"];
    [connectInfoDic setObject:@"yl1001" forKey:@"file_name"];
    [personDic setObject:connectInfoDic forKey:@"connect_info"];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * personDicStr = [jsonWriter stringWithObject:personDic];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"reg_platform=%@&connect_source=%@&open_id=%@&connect_person_type=%@&personArr=%@&conditionArr=%@",@"7",connectSource_,openId_,@"1",personDicStr,conditionStr];
    
    NSString * function = @"bindPerson";
    NSString * op   =   @"Job1001user_connect";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//更新社群信息
- (void)updateGroups:(NSString *)userId_ groupId:(NSString *)groupId_ groupName:(NSString *)groupName_ groupIntro:(NSString *)groupIntro_ groupTag:(NSString *)groupTag_ openStatus:(NSString *)openStatus_ groupPic:(NSString *)groupPIC_
{
    requestType_ = Request_UpdateGroups;
    
    NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
    if (groupName_ != nil) {
        [updateDic setObject:groupName_ forKey:@"group_name"];
    }
    if (groupIntro_ !=nil) {
        [updateDic setObject:groupIntro_ forKey:@"group_intro"];
    }
    if (openStatus_ !=nil) {
        [updateDic setObject:openStatus_ forKey:@"open_status"];
    }
    if (groupTag_ !=nil) {
        [updateDic setObject:groupTag_ forKey:@"tag_names"];
    }
    if (groupPIC_ !=nil) {
        [updateDic setObject:groupPIC_ forKey:@"group_pic"];
    }
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"0" forKey:@"checkflag"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * updateDicStr = [jsonWriter stringWithObject:updateDic];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    if ([updateDicStr isEqualToString:@"{}"]) {
        updateDicStr = @"";
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"user_id=%@&group_id=%@&updateArr=%@&conditionArr=%@",userId_,groupId_,updateDicStr,conditionStr];
    
    NSString * function = @"updateGroup";
    NSString * op   =   @"groups";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取校园招聘活动分享的url
-(void)getSchoolZPShareUrl:(NSString*)userId zwId:(NSString *)zwid
{
    requestType_ = Request_GetSchoolZPShareUrl;
    
    if (!userId) {
        userId = @"";
    }
    if (!zwid) {
        zwid = @"";
    }
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:zwid forKey:@"zwid"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",userId,conditionStr];
    
    NSString * function = @"getcampushareurl";
    NSString * op   =   @"person_info_api";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//获取同行
- (void)getSameTradePerson:(NSString *)userId_ pageIndex:(NSInteger)pageIndex_
{
    requestType_ = Request_getSameTradePerson;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId_ forKey:@"person_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"page"];
    [conditionDic setObject:@"0" forKey:@"same_hka"];
    [conditionDic setObject:@"1" forKey:@"get_dynamic_flag"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = @"get_res_same";
    NSString * op   =   @"yl_es_person";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取新的同行
- (void)getNewSameTradePerson:(NSString *)userId_ expertFlag:(NSString *)expertFlag pageIndex:(NSInteger)pageIndex_
{
    requestType_ = Request_getNewSameTradePerson;
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId_ forKey:@"person_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"page"];
    [conditionDic setObject:@"0" forKey:@"same_hka"];
    [conditionDic setObject:@"1" forKey:@"get_dynamic_flag"];
    [conditionDic setObject:expertFlag forKey:@"get_expert_flag"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionStr];
    NSString * function = @"getTonghangList";
    NSString * op   =   @"yl_es_person_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}


//获取听众和我的关注
-(void)getFriendWithUserId:(NSString *)userId_ followType:(NSString *)type_ visitorPid:(NSString *)visitorPid_ isnew:(NSString *)isnew_ loginLastTime:(NSString *)lastTime_ pageIndex:(NSInteger)pageIndex_ pageSize:(NSInteger)pageSize_
{
    requestType_ = Request_GetFriend;
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId_ forKey:@"person_id"];
    [searchDic  setObject:@"10" forKey:@"user_role"];
    [searchDic setObject:type_ forKey:@"follow_type"];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_city_flag"];
    [conditionDic setObject:@"1" forKey:@"get_dynamic_flag"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    NSString *function = @"getFollowList";
    NSString *op = @"zd_person_follow_rel_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取听众邀请列表
-(void)getFriendWithUserId:(NSString *)userId_ pageIndex:(NSInteger)pageIndex_ pageSize:(NSInteger)pageSize_ groupId:(NSString *)groupId personIname:(NSString *)personIname
{
    requestType_ = Request_GetFriend;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:personIname forKey:@"person_iname"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:groupId forKey:@"get_group_info"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@&searchArr=%@",userId_,conditionStr,searchDicStr];
    NSString * function = @"getMyfocusAndFollow";
    NSString * op = @"zd_person_follow_rel_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark--新建群聊
-(void)newGroupUserId:(NSString *)userId members:(NSArray *)member{
    //requestType_ = Request_CreateNewGroup;
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    for(int i = 0;i < member.count;i++){
        SBJsonWriter * json = [[SBJsonWriter alloc] init];
        ELSameTradePeopleFrameModel * vo = member[i];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:vo.peopleModel.person_id forKey:@"id"];
        [dic setObject:vo.peopleModel.person_iname forKey:@"name"];
        NSString *jsonDicStr = [json stringWithObject:dic];
        
        [conditionDic setObject:jsonDicStr forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
  
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&members=%@&option=%@",userId,conditionStr,@""];
    NSString * function = @"launchGroupChat";
    NSString * op = @"groups_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//获取同行中新朋友和新评论的数量
- (void)getNewFriendAndComment:(NSString *)userId homeTime:(NSString *)time
{
    requestType_ = Request_getNewFriendAndComment;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&datetime=%@",userId,time];
    NSString * function = @"busi_getTonghStat";
    NSString * op = @"salarycheck_all";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取我的文章评论列表
-(void)getMyArticleCommentList:(NSString *)userId_ homeTime:(NSString *)time pageIndex:(NSInteger)pageIndex_ pageSize:(NSInteger)pageSize_
{
    requestType_ = Request_GetMyArticleCommentList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId_ forKey:@"user_id"];
    [searchDic setObject:time forKey:@"idatetime"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function = @"getMyArticleCommentList";
    NSString * op = @"comm_comment";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取主页中心信息
- (void)getPersonCenterData:(NSString *)userId loginPersonId:(NSString *)loginPersonId;
{
    requestType_ = Request_GetPersonCenterData;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"user_id"];
    [searchDic setObject:loginPersonId forKey:@"login_person_id"];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_invite_group"];
    [conditionDic setObject:@"1" forKey:@"get_audio_photo_flag"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function = @"busi_getPersonUserzoneInfo";
    NSString * op = @"salarycheck_all";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取最新评论列表（消息模块）
-(void)getMyCommentList:(NSString*)userId pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex
{
    requestType_ = Request_GetMyCommentList;
    //组件搜索参数
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"page"];
    
    NSString *condition = [jsonWriter stringWithObject:conditionDic];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,condition];
    NSString * function = @"getCommentListByRelated";
    NSString * op = @"comm_comment_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取关于我的系统通知（消息模块）
-(void)getMySystemNotificationList:(NSString*)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageindex
{
    requestType_ = Request_SystemNotificationList;
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"page"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter2 stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,condition];
    NSString * function = @"getSysNoticeList";
    NSString * op = @"yl_app_push_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//获取打招呼列表（消息模块）
-(void)getSayHiList:(NSString*)userId type:(NSInteger)type pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex showtime:(NSString *)showtime
{
    requestType_ = Request_SayHiList;
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"1" forKey:@"product"];  // 1为一览，2为墨缘
    [searchDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"push_type"]; //0为消息，1为通知
    if (type == 1) {
        //招呼我的
        [searchDic setObject:userId forKey:@"person_id"];
    }
    if (type == 2) {
        //我招呼的
        [searchDic setObject:userId forKey:@"trigger_person_id"];
    }
    
    [searchDic setObject:[NSString stringWithFormat:@"504"] forKey:@"msg_type"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"page"];
    [conditionDic setObject:@"2" forKey:@"get_info_flag2"];
    [conditionDic setObject:showtime forKey:@"show_time"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter2 stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,condition];
    NSString * function = @"getDataList";
    NSString * op = @"yl_app_push";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//获取留言列表(消息模块)
-(void)getLetterList:(NSString*)userId pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex
{
    requestType_ = Request_LetterList;
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:@"1" forKey:@"product"];  // 1为一览，2为墨缘
    [searchDic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"push_type"]; //0为消息，1为通知
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:[NSString stringWithFormat:@"507"] forKey:@"msg_type"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"page"];
    [conditionDic setObject:@"1" forKey:@"get_info_flag2"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter2 stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,condition];
    NSString * function = @"getDataList";
    NSString * op = @"yl_app_push";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//获取社群消息列表（消息模块）
-(void)getGroupMessageList:(NSString*)userId pageSize:(NSInteger)pagesize pageIndex:(NSInteger)pageindex showtime:(NSString *)showtime
{
    requestType_ = Request_GroupsMessageList;
    //组件搜索参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:searchDic];
    
    //组件条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageindex] forKey:@"page"];
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *condition = [jsonWriter2 stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",conditionStr,condition];
    NSString * function = @"getGroupNoticeList";
    NSString * op = @"yl_app_push_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//留言模块－－
#pragma mark 发私信
- (void)sendMsgContent:(NSString *)content from:(NSString *)fromUserId to:(NSString *)toUserId
{
    //设置请求类型 发私信
    requestType_ = Request_sendAMessage;
    //组装参数
    NSMutableDictionary *contentArr = [[NSMutableDictionary alloc] init];
    [contentArr setObject:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *contentStr = [jsonWriter stringWithObject:contentArr];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"contentArr=%@&send_uid=%@&receive_uid=%@",contentStr,fromUserId, toUserId];
    NSString *op = Table_Op_sendAMessage;
    NSString *function = Table_Func_sendAMessage;
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 留言
- (void)leaveMsgContent:(NSString *)content from:(NSString *)fromUserId to:(NSString *)toUserId hrFlag:(BOOL)hrFlag shareType:(NSString *)shareType productType:(NSString *)productType recordId:(NSString *)recordId
{
    //设置请求类型 留言
    requestType_ = Request_LeaveMessage;
    //组装请求参数, 不需要传递字典的形式
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    if (hrFlag) {
        User_DataModal *model = [Manager getUserInfo];
        if (model.companyModal_.companyID_ != nil && ![model.companyModal_.companyID_ isEqualToString:@""]) {
            [conditionDic setObject:@"1"forKey:@"hr"];
        }else{
            [conditionDic setObject:@"1"forKey:@"zp"];
        }
    }
    
    if ([productType isEqualToString:@"1"]) {
        [conditionDic setObject:productType forKey:@"rel_product_type"];
        [conditionDic setObject:recordId forKey:@"rel_product_id"];
    }
    
    //语音消息
    NSString * bodyMsg;
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
    if ([shareType isEqualToString:@"5"]) {
        [shareDic setObject:@"5" forKey:@"type"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:content forKey:@"path"];
        [shareDic setObject:dic forKey:@"slave"];
        NSString *voicecontent = @"[语音]";
        NSString *shareStr = [jsonWriter stringWithObject:shareDic];
        if (hrFlag) {
            bodyMsg = [NSString stringWithFormat:@"content=%@&send_uid=%@&receive_uid=%@&share=%@&conditionArr=%@",voicecontent,fromUserId, toUserId,shareStr,conditionStr];
        }else{
            bodyMsg = [NSString stringWithFormat:@"content=%@&send_uid=%@&receive_uid=%@&share=%@&conditionArr=%@",voicecontent,fromUserId, toUserId,shareStr,@""];
        }
    }else{
        if (hrFlag) {
            bodyMsg = [NSString stringWithFormat:@"content=%@&send_uid=%@&receive_uid=%@&share=%@&conditionArr=%@",content,fromUserId, toUserId,shareType,conditionStr];
        }else{
            bodyMsg = [NSString stringWithFormat:@"content=%@&send_uid=%@&receive_uid=%@&share=%@&conditionArr=%@",content,fromUserId, toUserId,shareType,conditionStr];
        }
    }
    NSString *op = Table_Op_LeaveMessage;
    NSString *function = Table_Func_LeaveMessage;
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 私信列表
- (void)getPersonalMsgListWithFrom:(NSString *)fromUserId to:(NSString *)toUserId productType:(NSString *)productType recordId:(NSString *)recordId
{
    //设置请求类型 留言
    requestType_ = Request_GetPersonalMsgList;
    //组装请求参数, 不需要传递字典的形式
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:toUserId forKey:@"send_uid"];
    [conditionDic setObject:fromUserId forKey:@"receive_uid"];
    if ([productType isEqualToString:@"1"]) {
        [conditionDic setObject:productType forKey:@"rel_product_type"];
        [conditionDic setObject:recordId forKey:@"rel_product_id"];
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    NSString *op = Table_Op_GetPersonalMsgList;
    NSString *function = Table_Func_GetPersonalMsgList;
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 删除单条私信
- (void)deletePersonMsg:(NSString *)userId msgId:(NSString *)msgId
{
    //设置请求类型
    requestType_ = Request_deleteMsgById;
    NSString * bodyMsg = [NSString stringWithFormat:@"msg_id=%@&person_id=%@&", msgId, userId];
    NSString *op = @"zd_person_msg_busi";
    NSString *function = @"deleteMsg";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma makr 获取留言联系人列表
- (void)getContactListWithUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    //设置请求类型 留言
    requestType_ = Request_GetContactList;
    //组装请求参数, 不需要传递字典的形式
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    NSString *op = Table_Op_GetContactList;
    NSString *function = Table_Func_GetContactList;
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark----------
#pragma mark--新消息列表
-(void)getNewNewsListWithUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize{
    requestType_ = Request_GetNewNewsList;
    //组装请求参数, 不需要传递字典的形式
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:userId forKey:@"personId"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:@"pageList" forKey:@"listtype"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@&conditionArr=%@",userId,conditionDicStr];
    NSString *op = @"message_app_busi";
    NSString *function = @"getMessageList";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",NewSeviceURL,[self getFourAccessModel].sercet_,[self getFourAccessModel].accessToken_,op,function,New_Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 删除某个联系人的信息
- (void)deletePersonAllMsg:(NSString *)myId fromId:(NSString *)fromId
{
    //设置请求类型
    requestType_ = Request_DeletePersonAllMsg;
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&receive_id=%@&", myId, fromId];
    NSString *op = @"zd_person_msg_busi";
    NSString *function = @"deleteMsgByPerson";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 文章收藏 增加$type = 'cancel'; // add添加收藏、cancel取消收藏
- (void)addArticleFavorite:(NSString *)articleId userId:(NSString *)userId type:(NSString *)type
{
    //设置请求类型 留言
    requestType_ = Request_AddArticleFavorite;
    //组装请求参数, 不需要传递字典的形式
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&article_id=%@&type=%@",userId, articleId, type];
    NSString *op = @"yl_favorite_busi";
    NSString *function = @"addArticleFavorite";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 附件收藏
- (void)addArticleMediaFavorite:(NSString *)articleId userId:(NSString *)userId type:(NSString *)type
{
    //设置请求类型 留言
    requestType_ = Request_AddArticleFavorite;
    //组装请求参数, 不需要传递字典的形式
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&media_id=%@&type=%@",userId, articleId, type];
    NSString *op = @"yl_favorite_busi";
    NSString *function = @"addMediaFavorite";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取文章收藏的列表
- (void)getArticleFavoriteList:(NSString *)userId type:(NSString *)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    //设置请求类型 留言
    requestType_ = Request_GetArticleFavoriteList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:type forKey:@"type"];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    conditionDic[@"page"] = [NSString stringWithFormat:@"%ld",(long)pageIndex];
    conditionDic[@"page_size"] = pageParams;
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString *searchDicStr = [jsonWriter stringWithObject:searchDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", searchDicStr, conditionDicStr];
    NSString *op = @"yl_favorite_busi";
    NSString *function = @"getFavoriteList";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark pc扫描二维码登录
- (void)scanQrcodeWithCompanyId:(NSString *)companyId userId:(NSString *)userId url:(NSString *)url
{
    //设置请求类型
    requestType_ = Request_ScanQrCode;
    NSString *op = Table_Op_ScanQrCode;
    NSString *function = Table_Func_ScanQrCode;
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&url=%@",companyId, userId, url];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 授权登录
- (void)authorizedLoginWithCompanyId:(NSString *)companyId userId:(NSString *)userId url:(NSString *)url
{
    //设置请求类型
    requestType_ = Request_LoginAuth;
    NSString *op = Table_Op_ScanQrCode;
    NSString *function = Table_Func_LoginAuth ;
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&url=%@",companyId, userId, url];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 无法获取验证码时 第一步操作
- (void)getServiceNumberWithPhone:(NSString *)phone
{
    //设置请求类型
    requestType_ = Request_GetServiceNumber;
    NSString *op = @"sms_msg";
    NSString *function = @"getServiceNumber" ;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"phone"] = phone;
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * paramStr = [jsonWriter stringWithObject:param];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@", paramStr];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 无法获取验证码注册
- (void)registNoCodeWithPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code snumber:(NSString *)snumber
{
    //设置请求类型
    requestType_ = Request_RegistNoCode;
    NSString *op = @"sms_msg";
    NSString *function = @"checkReNumber" ;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"phone"] = phone;
    param[@"code"] = code;
    param[@"snumber"] = snumber;
    param[@"password"] = pwd;
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * paramStr = [jsonWriter stringWithObject:param];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@", paramStr];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取默认标签
- (void)getTagsList:(NSString *)tagsType
{
    requestType_ = Request_GetTagsList;
    
    if ([tagsType isEqualToString:@"PERSON_SKILL"]) {
        tagsType = @"PERSON_FIELD";
    }
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:tagsType forKey:@"yltpr_belongs"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    NSString * function = @"get_platform_tag_list";
    NSString * op = @"yl_tag_platform_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取行业标签
- (void)getTradeTagsList
{
    requestType_ = Request_GetTradeTagsList;
    NSString * op = @"salarycheck_all";
    NSString * function = @"getChooseTrade";
    NSString * bodyMsg = @"reverse=1";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取想学技能行业标签
- (void)getSkillTradeTagsList
{
    requestType_ = Request_GetSkillTradeTagsList;
    NSString * op = @"yl_tag_busi";
    NSString * function = @"get_platform_tag_list";
    NSString * bodyMsg = @"condition_arr={\"yltpr_belongs\":\"PERSON_FIELD\",\"yltpr_level_flag\":\"1\"}";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取热门标签和第一个标签的子标签
- (void)getHotTagAndChildTag:(NSString *)tradeId
{
    requestType_ = Request_GetHotTagAndChildTag;
    NSString * op = @"yl_tag_busi";
    NSString * function = @"getHotTagAndChildTag";
    NSString * bodyMsg =[NSString stringWithFormat:@"hot_tag_id=%@", tradeId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark 根据二级标签获取第三级标签
- (void)getTagsBySecondTag:(NSString *)secondTagId
{
    requestType_ = Request_GetTagsBySecondTag;
    NSString * op = @"yl_tag_busi";
    NSString * function = @"get_platform_tag_list";
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"PERSON_FIELD" forKey:@"yltpr_belongs"];
    [conditionDic setObject:@"3" forKey:@"yltpr_level_flag"];
    [conditionDic setObject:secondTagId forKey:@"parent_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取职业标签
- (void)getJobTagsListWithTradeId:(NSString *)tradeId
{
    requestType_ = Request_GetJobTagsList;
    NSString * op = @"trade_zw";
    NSString * function = @"getTradeZwParent";
    NSString *bodyMsg = [NSString stringWithFormat:@"TradeIdzw=%@", tradeId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//修改标签
- (void)updateTagsList:(NSString *)userId tagListString:(NSString *)tagListString tagType:(NSString *)tagType
{
    requestType_ = Request_UpdateTagsList;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"yltr_product_code=%@&product_id=%@&tag_str=%@",tagType,userId ,tagListString];
    NSString * function = @"update_tag_rel";
    NSString * op = @"yl_tag_rel";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//打招呼
- (void)sendMessage:(NSString *)userId_ type:(NSString *)type_ inviteId:(NSString *)inviteId_
{
    requestType_ = Request_SendMessage;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&type=%@&invite_id=%@&conditionArr=%@",userId_, type_, inviteId_, conditionDicStr];
    NSString * function = @"busi_pushInviteOperate";
    NSString * op = @"yl_app_push";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求我的问答列表（消息）
-(void)getMyAQList:(NSString*)userId type:(NSInteger)type pageInde:(NSInteger)pageIndex pageSize:(NSInteger)pageSize showtime:(NSString*)showtime
{
    requestType_ = Request_MyAQlist;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"visitor_pid"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"type"]; //1为我的提问，2为我的回答
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageindex"];
    [conditionDic setObject:pageParams forKey:@"pagesize"];
//    [conditionDic setObject:showtime forKey:@"show_time"];
    if (type == 1) {
       [conditionDic setObject:@"1" forKey:@"can_get_jingrong_info"]; 
    }
    if ([Manager shareMgr].haveLogin) {
        [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"login_person_id"];
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    NSString * function = @"new_get_my_question";
    NSString * op = @"zd_ask_question_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//回答专访问题
- (void)answerInterviewQuestion:(NSString *)userId_ questId:(NSString *)questId_ answerContent:(NSString *)answerContent
{
    requestType_ = Request_AnswerInterview;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&shitiid=%@&answer_content=%@",userId_, questId_, answerContent];
    NSString * function = @"submit_answer";
    NSString * op = @"co_research_wenjuan_shiti";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
    
}

//获取小编专访列表
- (void)getInterviewList:(NSString *)userId pageSize:(NSInteger)pageSize_ pageIndex:(NSInteger)pageIndex_
{
    requestType_ = Request_InterviewList;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"user_id"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex_] forKey:@"page_index"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"condition_arr=%@",conditionDicStr];
    NSString * function = @"get_app_exam_list";
    NSString * op = @"co_research_wenjuan_shiti";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//是否有权限查看更多小编专访
- (void)getShowMoreAnswer:(NSString *)userId
{
    requestType_ = Request_GetShowMoreAnswer;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = @"show_more_answer";
    NSString * op = @"co_research_wenjuan_shiti";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//获取消息模块的各项新消息数
-(void)getMessageCnt:(NSString*)userId
{
    requestType_ = Request_GetMessageCtn;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = @"getMessageSidebarCnt";
    NSString * op = @"yl_app_push_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//找他搜索
- (void)getTraderPeson:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex keyWord:(NSString *)keyWord isExpert:(NSString *)expert withJobType:(NSInteger)type
{
    requestType_ = Request_GetTraderPeson;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:userId forKey:@"person_id"];
    [conditionDic setObject:keyWord forKey:@"keywords"];
    [conditionDic setObject:@"1" forKey:@"get_dynamic_flag"];
    [conditionDic setObject:expert forKey:@"is_expert"];
    if (type == 1) {
        [conditionDic setObject:@"1" forKey:@"is_broker"];
    }
    else if(type == 2)
    {
        [conditionDic setObject:@"1" forKey:@"is_career_planner"];
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conditionDicStr];
    NSString * function = @"searchPersonList";//@"busi_yl_person_search";
    NSString * op = @"yl_es_person_busi";//@"yl_es_person";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取社群数量
- (void)getGroupsCount:(NSString *)userId
{
    requestType_ = Request_GetGroupsCount;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",userId,conditionDicStr];
    NSString * function = @"busi_getGroupCnt";
    NSString * op = @"groups";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//转发给我
-(void)getTurnToMeResume:(NSString *)companyId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex searchModel:(SearchParam_DataModal *)searchModel{
    requestType_ = Request_GetCompanyTurnTomeResume;
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:pageParams forKey:@"page_size"];
    [conditionDic setValue:[NSString  stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_id"];
    }
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    if (searchModel.searchName.length > 0) {
        [searchDic setObject:searchModel.searchName forKey:@"name"];
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    if (searchDic.count <= 0) {
        searchStr = @"";
    }
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&searchArr=%@&conditionArr=%@",companyId,searchStr,conditionStr];
    NSString * function = @"get_send_to_me_resume";
    NSString * op = @"company_person_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取企业收藏简历的列表
-(void)getCompanyCollectionResume:(NSString *)companyId isGroup:(NSString *)isgroup pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex searchModel:(SearchParam_DataModal *)searchModel
{
    requestType_ = Request_GetCompanyCollectionResume;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:pageParams forKey:@"page_size"];
    [conditionDic setValue:[NSString  stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    if (searchModel.regionId_.length > 0 && ![searchModel.regionId_ isEqualToString:@"100000"]) {
        [searchDic setObject:searchModel.regionId_ forKey:@"regionid"];
    }
    if (searchModel.workAgeValue_)
    {
        [searchDic setObject:searchModel.workAgeValue_ forKey:@"age1"];
    }
    if (searchModel.workAgeValue_1) {
        [searchDic setObject:searchModel.workAgeValue_1 forKey:@"age2"];
    }
    if([searchModel.experienceValue1 isEqualToString:@"0"]){
        [searchDic setObject:searchModel.experienceValue1 forKey:@"rctypeId"];
    }
    else{
        if (searchModel.experienceValue1) {
            [searchDic setObject:searchModel.experienceValue1 forKey:@"gznum1"];
        }
        if (searchModel.experienceValue2) {
            [searchDic setObject:searchModel.experienceValue2 forKey:@"gznum2"];
        }
    }
    if (searchModel.eduId_.length > 0) {
        [searchDic setObject:searchModel.eduId_ forKey:@"eduId"];
    }
    if (searchModel.searchName.length > 0) {
        [searchDic setObject:searchModel.searchName forKey:@"iname"];
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    if (searchDic.count <= 0) {
        searchStr = @"";
    }
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&company_uids=%@&company_isgroup=%@&searchArr=%@&conditionArr=%@", companyId,companyId, isgroup, searchStr, conditionStr];
    NSString * function = @"getMyTempResumeNew";
    NSString * op = @"company_resume_temp";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//企业收藏简历
-(void)collectResume:(NSString*)companyId personId:(NSString*)personId
{
    requestType_ = Request_CollectResume;
    //设置请求参数
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    
    NSString * conditionStr;
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        conditionStr = [jsonWriter stringWithObject:conditionDic];
    }

    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&company_id=%@&conditionArr=%@",personId,companyId,conditionStr];
    NSString * function = @"resumeTempSave";
    NSString * op = @"company";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//搜索灌薪水文章
-(void)getSalaryArticleByES:(NSString*)kw pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize personId:(NSString *)personId
{
    requestType_ = Request_GetSalaryArticleByES;
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:kw forKey:@"kw"];
    [searchDic setObject:personId forKey:@"login_person_id"];
    [searchDic setObject:[MyCommon getAddressBookUUID] forKey:@"client_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionDicStr];
    NSString *function = @"getGxsArticleListByEs";
    NSString *op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 薪水入口列表
-(void)getSalaryArticleListWithUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetSalaryArticleListByES;
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    if (!userId) {
        userId = @"";
    }
    [searchDic setObject:userId forKey:@"login_person_id"];
    [searchDic setObject:[MyCommon getAddressBookUUID] forKey:@"client_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionDicStr];
    NSString *function = @"getGxsCombineList";
    NSString *op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 薪水导航的列表
-(void)getSalaryNavList
{
    requestType_ = Request_GetSalaryNavList;
    
}

//查看简历完整度
- (void)getResumeComplete:(NSString *)userId
{
    requestType_ = Request_GetResumeComplete;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString * function = @"getResumeCompleteInfo";
    NSString * op = @"person_info_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//删除文章
- (void)deleteArticle:(NSString *)userId articleId:(NSString *)articleId
{
    requestType_ = Request_DeleteArticle;
    
    //设置请求参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&article_id=%@&conditionArr=%@",userId,articleId,conditionDicStr];
    NSString * function = @"new_deleteArticle";//@"deleteArticle";
    NSString * op = @"comm_article_busi";//@"salarycheck_all";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//举报非法文章
-(void)toReportIllegalArticle:(NSString *)title  content:(NSString*)content personId:(NSString*)personId productCode:(NSString *)code productId:(NSString *)productId
{
    requestType_ = Request_ToReport;
    if(!personId)
        personId = @"";
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:title forKey:@"title"];
    [conditionDic setObject:content forKey:@"content"];
    [conditionDic setObject:personId forKey:@"person_id"];
    [conditionDic setObject:productId forKey:@"product_id"];
    [conditionDic setObject:code forKey:@"product_code"];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"insertArr=%@",conditionDicStr];
    NSString * function = @"feedback";
    NSString * op = @"salarycheck_all";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//社群话题置顶列表
- (void)setRecommendArticle:(NSString *)groupId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_SetRecommendArticle;
    
    //设置请求参数
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&searchArr=%@&conditionArr=%@",groupId,searchStr,conditionDicStr];
    NSString * function = @"getGroupArticleList";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//修改置顶话题
- (void)saveRecommendSet:(NSString *)groupId userId:(NSString *)userId articleId:(NSString *)articleId type:(NSString *)type
{
    requestType_ = Request_SaveRecommendSet;
    
    //设置请求参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"group_id=%@&person_id=%@&article_id=%@&type=%@&conditionArr=%@",groupId,userId,articleId,type,conditionDicStr];
    NSString * function = @"setTopArticle";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//删除社群文章
- (void)deleteGroupArticle:(NSString *)userId groupId:(NSString *)groupId articleId:(NSString *)articleId
{
    requestType_ = Request_DeleteGroupArticle;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&group_id=%@&article_id=%@",userId,groupId,articleId];
    NSString * function = @"new_deleteArticle";
    NSString * op = @"comm_article_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取有社群邀请权限的社群
- (void)getInveteGroupWithUserId:(NSString *)userId vistorId:(NSString *)vistorId
{
    requestType_ = Request_GetInveteGroupWithUserId;
    //设置请求参数
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:vistorId forKey:@"visiter_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",userId,condictionStr];
    NSString * function = @"busi_getCanInviteGroup";
    NSString * op = @"groups";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//请求个人信息
- (void)getPersonInfoWithPersonId:(NSString *)personId
{
    requestType_ = Request_GetPersonInfoWithPersonId;
    //设置请求参数
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:personId forKey:@"personId"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@&where=%@&slaveInfo=%@",condictionStr,@"1=1",@"1"];
    NSString * function = @"getPersonDetail";
    NSString * op = @"person_sub_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//简历评价标签
-(void)getResumeCommentTagList:(NSString *)type
{
    requestType_ = Request_ResumeCommentTag;
    NSString * bodyMsg = [NSString stringWithFormat:@"where=%@&slaveInfo=%@",@"1=1",@"1"];
    NSString * function = @"getCommentTag";
    NSString * op = @"company_resume_comment_busi";

    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//获取下载简历列表
-(void)getDownloadResumeList:(NSString*)companyId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize search:(SearchParam_DataModal *)searchModel
{
    requestType_ = Request_DownloadResumeList;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:pageParams forKey:@"page_size"];
    [conditionDic setValue:[NSString  stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_id"];
    }
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];

    if (searchModel.workAgeValue_)
    {
        [searchDic setObject:searchModel.workAgeValue_ forKey:@"age1"];
    }
    if (searchModel.workAgeValue_1) {
        [searchDic setObject:searchModel.workAgeValue_1 forKey:@"age2"];
    }
    if([searchModel.experienceValue1 isEqualToString:@"0"]){
        [searchDic setObject:searchModel.experienceValue1 forKey:@"rctypeId"];
    }
    else{
        if (searchModel.experienceValue1) {
            [searchDic setObject:searchModel.experienceValue1 forKey:@"gznum1"];
        }
        if (searchModel.experienceValue2) {
            [searchDic setObject:searchModel.experienceValue2 forKey:@"gznum2"];
        }
    }
    if (searchModel.eduId_.length > 0) {
        [searchDic setObject:searchModel.eduId_ forKey:@"eduId"];
    }
    if (searchModel.process_state.length > 0) {
        [searchDic setObject:searchModel.process_state forKey:@"process_state"];
    }
    if (searchModel.searchName.length > 0) {
        [searchDic setObject:searchModel.searchName forKey:@"iname"];
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    if (searchDic.count <= 0) {
        searchStr = @"";
    }
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&searchArr=%@&conditionArr=%@",companyId, searchStr,conditionStr];
    NSString * function = @"get_download_resume";
    NSString * op = @"company_person_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//获取简历评价列表
-(void)getResumeCommentList:(NSString*)companyId personId:(NSString*)personId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_ResumeCommentList;
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&person_id=%@&page_size=%@&page_index=%@",companyId,personId,pageParams,[NSString stringWithFormat:@"%ld",(long)pageIndex]];
    NSString * function = @"getResumeCommentList";
    NSString * op = @"company_resume_comment_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//其他关联企业账号
-(void)getOtherCompanyAccountList:(NSString*)companyId jobId:(NSString*)jobId
{
    requestType_ = Request_OtherCompanyAccountList;
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&jobid=%@",companyId,jobId];
    NSString * function = @"getShareInfo";
    NSString * op = @"synergy_member_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//添加简历评价
-(void)addResumeComment:(NSString*)companyId cmailId:(NSString*)cmailId personId:(NSString*)personId author:(NSString*)author content:(NSString*)content type:(NSString*)type mid:(NSString *)mid jobId:(NSString *)jobId
{
    if(!jobId)
    {
        jobId = @"";
    }
    requestType_ = Request_AddResumeComment;
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    if (author.length > 0) {
        [condictionDic setObject:author forKey:@"author"];
    }
    [condictionDic setObject:content forKey:@"content"];
    [condictionDic setObject:mid forKey:@"m_id"];
    [condictionDic setObject:jobId forKey:@"job_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&cmailbox_id=%@&person_id=%@&param=%@&type=%@",companyId,cmailId,personId,condictionStr,type];
    NSString * function = @"mobileResumeComment";
    NSString * op = @"company_resume_comment_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//接收到推送消息后的回调
-(void)receiveMessageType:(NSString*)type messageId:(NSString*)messageId
{
    requestType_ = Request_ReceiveMessage;
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:@"10" forKey:@"role"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"push_type=%@receiver_info=%@",type,condictionStr];
    NSString * function = @"pushReceived";
    NSString * op = @"yl_app_push_callback_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

- (void)getResumeInfoWithPersonId:(NSString *)personId
{
    requestType_ = Request_ResumeInfo;
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = @"getResumeInfo";
    NSString * op = @"person_info_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

//更新简历信息
- (void)updateResumeInfoWithPersonId:(NSString *)personId personDetailModel:(PersonDetailInfo_DataModal *)model
{
    requestType_ = Request_updateResumeInfo;
    NSMutableDictionary *resumeDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *eduDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *workDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [resumeDic setObject:model.iname_ forKey:@"iname"];
    [resumeDic setObject:model.sex_ forKey:@"sex"];
    [resumeDic setObject:model.rcType_ forKey:@"rctypeId"];
    [resumeDic setObject:model.bday_ forKey:@"bday"];
    [resumeDic setObject:model.hka_ forKey:@"hka"];
    [resumeDic setObject:model.gznum_ forKey:@"gznum"];
    [resumeDic setObject:model.shouji_ forKey:@"shouji"];
    [resumeDic setObject:model.emial_ forKey:@"email"];
    [resumeDic setObject:model.evaluation forKey:@"grzz"];
    if(model.job_ != nil){
        [resumeDic setObject:model.job_ forKey:@"job"];
    }
    [eduDic setObject:model.eduStratTime forKey:@"startdate"];
    [eduDic setObject:model.eduEndTime forKey:@"stopdate"];
    if (model.studyIsToNow != nil) {
        [eduDic setObject:model.studyIsToNow forKey:@"istonow"];
    }
    [eduDic setObject:model.school_ forKey:@"school"];
    if (model.eduId != nil) {
        [eduDic setObject:model.eduId forKey:@"eduId"];
    }
    if (model.personId !=nil) {
        [eduDic setObject:model.personId forKey:@"personId"];
    }
    if (model.edusId != nil) {
        [eduDic setObject:model.edusId forKey:@"edusId"];
    }
    if (model.workId != nil) {
        [workDic setObject:model.workId forKey:@"workId"];
    }
    if (([model.companyName isEqualToString:@""] || model.companyName == nil) && model.workId != nil) {
        [condictionDic setObject:model.workId forKey:@"delwork"];
    }
    if (model.workStratTime != nil) {
        [workDic setObject:model.workStratTime forKey:@"startdate"];
    }
    if (model.workEndTime !=nil) {
        [workDic setObject:model.workEndTime forKey:@"stopdate"];
    }
    if (model.workIsToNow != nil) {
        [workDic setObject:model.workIsToNow forKey:@"istonow"];
    }
    if (model.companyName !=nil) {
        [workDic setObject:model.companyName forKey:@"company"];
    }
    if (model.zw !=nil) {
        [workDic setObject:model.zw forKey:@"jtzw"];
    }
    if (model.personId !=nil) {
        [workDic setObject:model.personId forKey:@"personId"];
    }
    [condictionDic setObject:resumeDic forKey:@"resume"];
    [condictionDic setObject:eduDic forKey:@"edus"];
    [condictionDic setObject:workDic forKey:@"work"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@",personId,condictionStr];
    NSString * function = @"updateResumeInfo";
    NSString * op = @"person_info_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取屏蔽公司列表
- (void)getSheidCompanyList:(NSString *)personId
{
    requestType_ = Request_SheidCompany;
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString * function = @"getMyScreenCompanyList";
    NSString * op = @"screen_company_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=v4.3.0",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 搜索公司
- (void)getCompanyWithCompanyName:(NSString *)name pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetCompany;
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [condictionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"company_name=%@&search_arr=%@&condition_arr=%@",name,@"",condictionStr];
    NSString * function = @"getCompanyList";
    NSString * op = @"screen_company_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=v4.3.0",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 设置或取消屏蔽公司
- (void)setSheidCompanyWithPersonId:(NSString *)personId companyList:(NSMutableArray *)companyArray
{
    requestType_ = Request_setSheidCompany;
    
    NSString *tempString = @"";
    for (int i=0; i<[companyArray count]; i++) {
        if (i!=0) {
            tempString = [NSString stringWithFormat:@"%@,%@",tempString,[companyArray objectAtIndex:i]];
        }else{
            tempString = [tempString stringByAppendingString:[companyArray objectAtIndex:i]];
        }
    }
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&company_list=%@",personId,tempString];
    NSString * function = @"setScreenCompany";
    NSString * op = @"screen_company_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=v4.3.0",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}


//徽章列表
-(void)getMyBadgesListWithPageIndex:(NSInteger)page pageSize:(NSInteger)page_size personId:(NSString *)personId
{
    requestType_ = Request_MyBadgesList;
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:personId forKey:@"person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionDicStr];
    NSString *function = @"getBadgeList";
    NSString *op = @"yl_badge_busi";
    
    //发送请求
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//用户声望
-(void)getMyPrestige:(NSString *)presonId
{
    requestType_ = Request_MyPrestige;
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&",presonId];
    NSString *function = @"getMyPrestigeTotal";
    NSString *op = @"yl_badge_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


//获取首页顶部广告
-(void)getTopAD:(NSString*)userId Type:(NSString *)type
{
    requestType_ = Request_TopAD;
    
    NSString * function = @"getTonghangAdv";
    NSString * op = @"yl_adv_busi";
    
    
    NSString *str = [Manager shareMgr].regionName_;
    
    if (!str || [str isEqual:[NSNull null]] || str == nil)
    {
        str = @"";
    }
    NSString * idstr = [CondictionListCtl getRegionId:str];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:idstr forKey:@"regionid"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&type=%@&conditionArr=%@",userId,type,conditionDicStr];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@&",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//声望列表
-(void)getMyPrestigeList:(NSString *)personId pageIndex:(NSInteger)page pageSize:(NSInteger)pageSize
{
    requestType_ = Request_MyPrestigeList;
    
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:personId forKey:@"belong_person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter2 stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionDicStr];
    NSString *function = @"getPrestigeLogsList";
    NSString *op = @"yl_badge_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark - 个人中心接口1
- (void)getPersonCenter1:(NSString *)userId loginPersonId:(NSString *)loginPersonId;
{
    requestType_ = Request_GetPersonCenter1;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"user_id"];
    [searchDic setObject:loginPersonId forKey:@"login_person_id"];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_invite_group"];
    [conditionDic setObject:@"1" forKey:@"get_audio_photo_flag"];
    [conditionDic setObject:@"1" forKey:@"prestige_cnt"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function = @"getPersonUserzoneInfo1";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 个人中心接口2
- (void)getPersonCenter2:(NSString *)userId loginPersonId:(NSString *)loginPersonId
{
    requestType_ = Request_GetPersonCenter2;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"user_id"];
    [searchDic setObject:loginPersonId forKey:@"login_person_id"];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:@"1" forKey:@"get_invite_group"];
    [conditionDic setObject:@"1" forKey:@"get_audio_photo_flag"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function = @"getPersonUserzoneInfo2";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=v4.3.0",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//订单记录列表
-(void)getOrderRecord:(NSString *)rodcoId pageSize:(NSInteger)pagesize serviceCode:(NSString *)code gwcFor:(NSString *)gwcFor pageIndex:(NSInteger)page
{
    requestType_ = Request_GetOrderReocrd;
    
    NSMutableDictionary *searchArr = [[NSMutableDictionary alloc] init];
    [searchArr setObject:code forKey:@"ordco_service_code"];
    
    NSMutableDictionary *pageArr = [[NSMutableDictionary alloc] init];
    [pageArr setObject:pageParams forKey:@"page_size"];
    [pageArr setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchArr];
    NSString * conditionDicStr = [jsonWriter stringWithObject:pageArr];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"ordco_gwc_for=%@&ordco_gwc_owner_id=%@&pageArr=%@&searchArr=%@",gwcFor,rodcoId,conditionDicStr,searchDicStr];
    NSString * function = @"getMygwcList";
    NSString * op = @"person_sub_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 查薪订单列表
-(void)getSalaryOrderRecord:(NSString *)personId pageSize:(NSInteger)pagesize  pageIndex:(NSInteger)page
{
    requestType_ = Request_GetSalaryOrderRecord;
    
    NSMutableDictionary *searchArr = [[NSMutableDictionary alloc] init];
    [searchArr setObject:personId forKey:@"person_id"];
    
    NSMutableDictionary *pageArr = [[NSMutableDictionary alloc] init];
    [pageArr setObject:pageParams forKey:@"page_size"];
    [pageArr setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchArr];
    NSString * conditionDicStr = [jsonWriter stringWithObject:pageArr];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, conditionDicStr];
    NSString * function = @"getOrderList";
    NSString * op = @"resume_salary_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取服务的信息 serviceCode 服务类型
- (void)getOrderServiceInfo:(NSString *)serviceCode
{
    requestType_ = Request_GetOrderServiceInfo;
    NSString *function = @"getServiceInfo";
    NSString *op = @"person_sub_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"ordco_service_code=%@&conditionArr=&", serviceCode];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 简历推荐服务信息
- (void)getResumeApplyServiceInfo:(NSString *)userId
{
    requestType_ = Request_GetResumeApplyServiceInfo;
    NSString *function = @"getServiceInfo";
    NSString *op = @"zhitui_service_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&", userId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 购物车订单生成
- (void)genShoppingCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId expertId:(NSString *)expertId
{
    [self genShoppingCartWithServiceCode:serviceCode serviceId:serviceId userId:userId number:1 expertId:expertId];
}

#pragma mark 简历直推申请
- (void)applyResumeRecommend:(NSString *)userId serviceDetailId:(NSString *)serviceDetailId
{
    requestType_ = Request_ApplyResumeRecommend;
    NSString *function = @"addApply";
    NSString *op = @"zhitui_apply_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&service_detail_id=%@&", userId, serviceDetailId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 购物车订单生成
- (void)genShoppingCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId number:(NSInteger)num expertId:(NSString *)expertId
{
    requestType_ = Request_GenShoppingCart;
    NSString *function = @"addgwc";
    NSString *op = @"person_sub_busi";
    NSMutableDictionary *conditionArr = [[NSMutableDictionary alloc] init];
    conditionArr[@"ordco_service_code"] = serviceCode;
    conditionArr[@"service_detail_id"] = serviceId;
    conditionArr[@"personid"] = userId;
    conditionArr[@"buynums"] =  @(num);
    conditionArr[@"target_person_id"] = expertId;
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@", [jsonWriter stringWithObject:conditionArr]];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 打赏订单生成
- (void)genShoppingDaShangCartWithServiceCode:(NSString *)serviceCode serviceId:(NSString *)serviceId userId:(NSString *)userId tagetUserId:(NSString *)tagetUserId number:(NSString *)num productType:(NSString *)productType productId:(NSString *)productId
{
    requestType_ = Request_DashangShoppingCart;
    NSString *function = @"addgwc";
    NSString *op = @"person_sub_busi";
    
    NSMutableDictionary *conditionArr = [[NSMutableDictionary alloc] init];
    conditionArr[@"ordco_service_code"] = serviceCode;
    conditionArr[@"service_detail_id"] = serviceId;
    conditionArr[@"personid"] = userId;
    conditionArr[@"buynums"] =  num;
    
    NSMutableDictionary *tagetDic = [[NSMutableDictionary alloc] init];
    [tagetDic setObject:tagetUserId forKey:@"target_person_id"];
    [tagetDic setObject:productType forKey:@"product_type"];
    [tagetDic setObject:productId forKey:@"product_id"];
    [conditionArr setObject:tagetDic forKey:@"condition"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionArr];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@", conditionStr];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取用户是否购买过服务* @param $ordco_gwc_for    当前用户的角色10企业、20人才 * @param $ordco_gwc_owner_id   当前用户的编号 * @param $ordco_service_code    服务代号
- (void)getServiceStatus:(NSString *)ownerType userId:(NSString *)userId serviceCode:(NSString *)serviceCode
{
    requestType_ = Request_GetServiceStatus;
    NSString *function = @"getServiceStatus";
    NSString *op = @"person_sub_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"ordco_gwc_for=%@&ordco_gwc_owner_id=%@&ordco_service_code=%@&conditionArr=&", ownerType, userId, serviceCode];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 简历推送的状态
- (void)getResumeApplyStatus:(NSString *)userId
{
    requestType_ = Request_ResumeApplyStatus;
    NSString *function = @"getStatInfo";
    NSString *op = @"zhitui_apply_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&", userId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 根据订单ID获取微信支付的prepay ID
- (void)getWXPrepayId:(NSString *)orderId
{
    requestType_ = Request_GetWXPrepayId;
    NSString *function = @"getWxPayPre";
    NSString *op = @"ordco_service_comm";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"gwc_id=%@&", orderId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark 查询薪酬纪录的列表
- (void)getQuerySalaryList:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_GetQuerySalaryList;
    NSString *function = @"getSearchList";
    NSString *op = @"resume_salary_busi";
    //设置请求参数
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSMutableDictionary * condictionDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    condictionDict[@"page"] = @(pageIndex);
    condictionDict[@"page_size"] = pageParams;
    NSString *conditionStr = [jsonWriter stringWithObject:condictionDict];
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", searchStr, conditionStr];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 简历比较
- (void)resumeCompareWithUserId:(NSString *)myId anotherId:(NSString *)anotherId
{
    requestType_ = Request_ResumeCompare;
    NSString *function = @"getResumeInfo";
    NSString *op = @"resume_salary_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&compare_id=%@&", myId, anotherId];
    //发送请求
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取薪职服务的信息
- (void)getSalaryServiceType
{
    requestType_ = Request_GetSalaryServiceInfo;
    NSString *function = @"getServiceList";
    NSString *op = @"resume_salary_busi";
    //设置请求参数
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:@"aa=1" method:nil];
}

#pragma mark 获取查薪指的次数
- (void)getSalaryQueryCountWithUserId:(NSString *)userId
{
    requestType_ = Request_GetQuerySalaryCount;
    NSString *function = @"getPersonOrderStat";
    NSString *op = @"resume_salary_busi";
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&", userId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 记录点击通知时的日志
-(void)postMessageClickLog:(NSString*)userId messageId:(NSString*)messageId title:(NSString*)title type:(NSString*)type time:(NSString*)time
{
    requestType_ = Request_MessageClickLog;
    userId = [MyCommon getEmtyStrFromNil:userId];
    messageId = [MyCommon getEmtyStrFromNil:messageId];
    title = [MyCommon getEmtyStrFromNil:title];
    type = [MyCommon getEmtyStrFromNil:type];
    time = [MyCommon getEmtyStrFromNil:time];
    NSString *function = @"doEvent";
    NSString *op = @"api_call_log";
    NSMutableDictionary *conditionArr = [[NSMutableDictionary alloc] init];
    conditionArr[@"person_id"] = userId;
    conditionArr[@"msg_id"] = messageId;
    conditionArr[@"msg_name"] = title;
    conditionArr[@"msg_type"] = type;
    conditionArr[@"click_time"] = time;
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * bodyMsg = [NSString stringWithFormat:@"param=%@", [jsonWriter stringWithObject:conditionArr]];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

//灌薪水三种类型选择
-(void)getSalaryTypeWithOwn_id:(NSString *)own_id getJingFlag:(NSString *)get_jing_flag getSysFlag:(NSString *)get_sys_flag page:(NSInteger)page pageSize:(NSInteger)page_size type:(NSInteger)type
{
    requestType_ = request_SalaryTypeChange;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    
    switch (type) {
        case 1:
            [conditionDic setObject:get_jing_flag forKey:@"get_jing_flag"];
            break;
        case 2:
            [conditionDic setObject:get_sys_flag forKey:@"get_sys_flag"];
            break;
        case 3:
            [searchDic setObject:own_id forKey:@"own_id"];
            break;
        default:
            break;
    }
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function = @"getGxsArticleList2";
    NSString * op = @"salarycheck_all_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 今日看点列表
- (void)getTodayFoucsListByUserId:(NSString *)userId currentPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    requestType_ = request_TodayFocusList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = @"";
    [searchDic setObject:[MyCommon getAddressBookUUID] forKey:@"client_id"];
    if (userId && ![userId isEqualToString:@""]) {
        [searchDic setObject:userId forKey:@"person_id"];
        searchDicStr = [jsonWriter stringWithObject:searchDic];
    }
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, conditionDicStr];
    NSString * function = @"getJrkdList";
    NSString * op = @"yl_es_person_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 纪录广告点击量
- (void)addAdClickCount:(NSString *)adId userId:(NSString *)userId clientId:(NSString *)clientId
{
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"rel_id=%@&statInfo={\"person_id\":\"%@\", \"client_id\":\"%@\"}&", adId, userId, clientId];
    NSString * function = @"addAdvStat";
    NSString * op = @"yl_adv_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 我的消息
-(void)getMessageWith:(NSString *)userId
{
    requestType_ = getMessageWithId;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@", userId];
    NSString * function = @"getMessageStatInfo";
    NSString * op = @"yl_app_push_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 我的消息所有个数
-(void)getAllMessageWith:(NSString *)userId
{
    requestType_ = getAllMessageWithId;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@", userId];
    NSString * function = @"getMessageStatCnt";
    NSString * op = @"yl_app_push_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 最新发表
- (void)getNewPublicArticle:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = request_NewPublicArticle;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    NSString *searchDicStr = [jsonWriter stringWithObject:searchDic];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", searchDicStr, conditionDicStr];
    NSString * function = @"getArtListByRelated";
    NSString * op = @"comm_article_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}



#pragma mark 列表头部按钮顺序(职位列表，社群列表，薪指列表)
-(void)getTableViewHeadButtonList:(NSInteger)type
{
    requestType_ = Request_HeadButtonList;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"where=%@&slaveInfo=%@",@"1=1",@"1"];
    NSString * function = @"";
    NSString * op = @"control_position_busi";
    if (type == 0) {
        //社群
        function = @"getGroupSearchSort";
    }
    else if (type == 1){
        //薪指
        function = @"getXinshuiModuleSort";
    }
    else if (type == 2){
        //职位
        function = @"getZhiweiSearchSort";
    }else if (type == 3){
        //同行
        function = @"getTonghModuleSort";
    }
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark 职业列表
- (void)getProfessionList
{
    requestType_ = Request_GetProfessionList;
    NSString * function = @"getJobTypeList";
    NSString * op = @"salarycheck_all_busi";
    NSString *bodyMsg = @"level=1&parent_levelname =''";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 第三级职业列表
- (void)getProfessionChildListWithParentName:(NSString *)pName
{
    requestType_ = Request_GetProfessionChildList;
    NSString * function = @"getJobTypeList";
    NSString * op = @"salarycheck_all_busi";
    NSString *bodyMsg =[NSString stringWithFormat:@"level=2&parent_levelname=%@", pName] ;
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

//热门行业列表
-(void)getTradeType:(NSInteger)page page_size:(NSInteger)pageSize
{
    requestType_ = request_TotalTradeList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];;
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"page_size"];
    
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function = @"getTotalTrade";
    NSString * op = @"groups_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 查工资页面的热门专业列表
-(void)getSalaryHotJobList:(NSInteger) type
{
    requestType_ = Request_SalaryHotJobList;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"where=%@&slaveInfo=%@",@"1=1",@"1"];
    NSString *function;
    NSString * op = @"salarycheck_all_busi";
    if (type == 0) {
        function = @"getHotJobTypeList";
    }else if (type == 1) {
        function = @"getHotZhuanyeList";
    }
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 薪指预测图表
- (void)getSalaryMap:(NSString *)regionId position:(NSString *)position
{
    requestType_ = request_SalaryMap;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    if (regionId) {
        searchDic[@"zw_regionid"] = regionId;
    }
    if (position) {
        searchDic[@"kw"] = position;
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@",searchDicStr];
    NSString * function = @"getSalaryDistMap";
    NSString * op = @"salarycheck_all_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 更多热门专业列表
-(void)getMoreHotIndustry
{
    requestType_ = Request_getMoreHotIndustry;
    NSString *op = @"salarycheck_all_busi";
    NSString *function = @"getZhuanyeList";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:@"11" method:nil];
}

#pragma mark - 看前景薪酬预测
- (void)getSalaryForecastWithZyName:(NSString*)zyName minWorkAge:(NSString *)minWorkAge maxWorkAge:(NSString *)maxWorkAge matchModel:(NSString *)matchModel;
{
    requestType_ = request_getSalaryForecast;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    searchDic[@"gznum_min"] = minWorkAge;
    searchDic[@"gznum_max"] = maxWorkAge;
    searchDic[@"zym_match_model"] = matchModel;
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"zym=%@&search=%@&",zyName,searchDicStr];
    NSString * function = @"doZySalaryPredicate";
    NSString * op = @"salarycheck_all_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 分享信息给好友
-(void)getShareMessageWithSend_uid:(NSString *)sendUid receiveId:(NSString *)receiveId receiveName:(NSString *)receiveName content:(NSString *)centent dataModal:(ShareMessageModal *)shareDataModal
{
    requestType_ = Request_getShareMessageOther;
    
    NSMutableDictionary *shareDic = [[NSMutableDictionary alloc] init];
    
    switch ([shareDataModal.shareType integerValue]) {
        case 1:
        {
            [shareDic setObject:shareDataModal.shareType forKey:@"type"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareDataModal.personId forKey:@"person_id"];
            [dic setObject:shareDataModal.personName forKey:@"person_iname"];
            [dic setObject:shareDataModal.person_pic forKey:@"person_pic"];
            [dic setObject:shareDataModal.person_zw forKey:@"person_zw"];
            [shareDic setObject:dic forKey:@"slave"];
            centent = [NSString stringWithFormat:@"%@的一览主页",shareDataModal.personName];
            
        }
            break;
        case 20:
        {
            [shareDic setObject:shareDataModal.shareType forKey:@"type"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareDataModal.position_id forKey:@"position_id"];
            [dic setObject:shareDataModal.position_name forKey:@"position_name"];
            [dic setObject:shareDataModal.position_logo forKey:@"position_logo"];
            [dic setObject:shareDataModal.position_salary forKey:@"position_salary"];
            [dic setObject:shareDataModal.position_company forKey:@"position_company"];
            [dic setObject:shareDataModal.position_company_id forKey:@"position_company_id"];
            [shareDic setObject:dic forKey:@"slave"];
            centent = @"分享了一个职位";
            
        }
            break;
        case 11:
        case 2:
        {
            [shareDic setObject:shareDataModal.shareType forKey:@"type"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareDataModal.article_id forKey:@"article_id"];
            [dic setObject:shareDataModal.article_title forKey:@"article_title"];
            [dic setObject:shareDataModal.article_summary forKey:@"article_summary"];
            [dic setObject:shareDataModal.article_thumb forKey:@"article_thumb"];
            [shareDic setObject:dic forKey:@"slave"];
            centent = @"分享了一篇文章";
            
        }
            break;
        case 10:
        {
            [shareDic setObject:shareDataModal.shareType forKey:@"type"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareDataModal.groupId forKey:@"group_id"];
            [dic setObject:shareDataModal.groupName forKey:@"group_name"];
            [dic setObject:shareDataModal.groupPic forKey:@"group_pic"];
            [dic setObject:shareDataModal.groupPersonCnt forKey:@"group_person_cnt"];
            [dic setObject:shareDataModal.groupArticleCnt forKey:@"group_article_cnt"];
            [shareDic setObject:dic forKey:@"slave"];
            centent = @"分享了一个社群";
            
        }
            break;
        case 4:
        {
            [shareDic setObject:shareDataModal.shareType forKey:@"type"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareDataModal.imageUrl forKey:@"path"];
            [shareDic setObject:dic forKey:@"slave"];
            centent = @"分享了一张图片";
        }
            break;
        case 25:
        {
            [shareDic setObject:shareDataModal.shareType forKey:@"type"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:shareDataModal.personId.length>0 ? shareDataModal.personId:@"" forKey:@"person_id"];
            [dic setObject:shareDataModal.personName>0 ? shareDataModal.personName:@"" forKey:@"person_iname"];
            [dic setObject:shareDataModal.person_pic>0 ? shareDataModal.person_pic:@"" forKey:@"person_pic"];
            [dic setObject:shareDataModal.person_zw>0 ? shareDataModal.person_zw:@"" forKey:@"person_zw"];
            [dic setObject:shareDataModal.person_gznum>0 ? shareDataModal.person_gznum:@"" forKey:@"person_gznum"];
            [dic setObject:shareDataModal.person_edu>0 ? shareDataModal.person_edu:@"" forKey:@"person_edu"];
            [shareDic setObject:dic forKey:@"slave"];
            centent = [NSString stringWithFormat:@"%@的简历",shareDataModal.personName];
            
        }
            break;  
        default:
            break;
    }
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * shareStr = [jsonWriter stringWithObject:shareDic];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"send_uid=%@&receive_uid=%@&content=%@&share=%@",sendUid,receiveId,centent,shareStr];
    NSString * function = @"busi_add_msg";
    NSString * op = @"zd_person_msg_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark - 红点消除

-(void)delegateMessageShow:(NSString *)userId
{
    requestType_ = Request_delegateMessage;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@", userId];
    NSString * function = @"setMsgSelectTime";
    NSString * op = @"zd_person_msg_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取曝工资评论的标题
- (void)getExposureTitle
{
    requestType_ = Request_ExposureTitle;
    //设置请求参数
    NSString * function = @"getBaogzGxs";
    NSString * op = @"resume_salary_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:@" " method:nil];
}

#pragma mark - 谁赞了我列表
-(void)getWhoLikeMeListPersonId:(NSString *)person_id page:(NSInteger)page pageSize:(NSInteger)pageSize
{
    requestType_ = Request_getWhoLikeMeList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:person_id forKey:@"product_person_id"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriter stringWithObject:searchDic];;
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"conditionArr=%@&searchArr=%@",conditionDicStr,searchDicStr];
    NSString * function = @"getPraiseList";
    NSString * op = @"yl_praise_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

- (void)getHrMessageWithLoginId:(NSString *)userId visitorId:(NSString *)visitorId
{
    requestType_ = getHrMessageWithLoginId;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"login_person_id=%@&visitor_pid=%@",userId,visitorId];
    NSString * function = @"getHrOrPersonInfo";
    NSString * op = @"zd_person_msg_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 谁赞了我列表红点消除
-(void)deleteWhoLikeMeMessagePersonId:(NSString *)person_id praiseId:(NSString *)praise_id
{
    requestType_ = Request_deleteWhoLikeMeMessage;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&praise_id=%@",person_id,praise_id];
    NSString * function = @"setPraiseSelectTime";
    NSString * op = @"yl_praise_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 活动提交报名
-(void)getApplyWithArticleId:(NSString *)article_id personId:(NSString *)person_id personIname:(NSString *)person_iname personPhone:(NSString *)person_phone personRemark:(NSString *)person_remark personCompany:(NSString *)person_company personGroup:(NSString *)person_group person_jobs:(NSString *)person_jobs person_email:(NSString *)person_email
{
    requestType_ = Request_GetArticleApply;
    NSMutableDictionary *conDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"article_id=%@&person_id=%@&person_iname=%@&person_phone=%@&person_remark=%@&person_company=%@&person_group%@&person_jobs=%@&person_email=%@&conditionArr=%@",article_id,person_id,person_iname,person_phone,person_remark,person_company,person_group,person_jobs,person_email,conDicStr];
    NSString * function = @"addActivityEnroll";
    NSString * op = @"salarycheck_all_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark offer派列表
- (void)getOfferPartyListByCompanyId:(NSString *)companyId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetOfferPartyList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"uId=%@&conditionArr=%@&",companyId,conDicStr];
    NSString * function = @"getJobfairListByuId";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark user offer派列表
- (void)getUserOfferPartyListByUserId:(NSString *)userId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize fromeType:(NSString *)type
{
    requestType_ = Request_GetUserOfferPartyList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:type forKey:@"offer"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"personid=%@&conditionArr=%@&", userId, conDicStr];
    NSString * function = @"getJobfairListByPersonId";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark user offer派公司列表 推荐职位的公司
- (void)getUserOfferPartyCompanyList:(NSString *)userId offerPartyId:(NSString *)offerPartyId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetUserOfferPartyCompanyList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"personid=%@&jobfair_id=%@&conditionArr=%@&", userId, offerPartyId, conDicStr];
    NSString * function = @"getTjCompanyList";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark offer派投递简历
- (void)deliverResumeToOfferParty:(NSString *)offerPartyId userId:(NSString *)userId companyId:(NSString *)companyId jobId:(NSString *)jobId
{
    requestType_ = Request_DeliverOfferPartyResume;
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&person_id=%@&uId=%@&job_id=%@&", offerPartyId, userId,companyId, jobId];
    NSString * function = @"tjPersonToJob";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}



#pragma mark  offer派所有公司列表 职位的公司
- (void)getOfferPartyCompanyList:(NSString *)offerPartyId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetOfferPartyCompanyList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&conditionArr=%@&", offerPartyId, conDicStr];
    NSString * function = @"getJobfairCompanyList";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark offer派 人数统计
- (void)getOfferPartyPersonCnt:(NSString *)offerPartyId companyId:(NSString *)companyId withFromType:(NSString *)fromType 
{
    requestType_ = Request_GetOfferPartyPersonCnt;
    
    NSString *conDicStr = @"";
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    if (fromType && ![fromType isEqualToString:@""]) {
        [conditionDic setObject:fromType forKey:@"fromtype"];
    }
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [conditionDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    if (conditionDic.count > 0) {
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        conDicStr = [jsonWriter stringWithObject:conditionDic];
    }
    
    NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&jobfair_id=%@&conditionArr=%@",companyId,offerPartyId,conDicStr];
    NSString * function = @"getJjrChangCiCount";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 获取企业的信息
- (void)getCompanyInfoById:(NSString *)companyId
{
    requestType_ = Request_GetCompanyInfo;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
       [conditionDic setObject:synergy_id forKey:@"synergy_id"];
    }
    
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
   
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@", companyId,conDicStr];
    
    NSString * function = @"getCompanyCntInfo";
    NSString * op = @"company_info_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

//-(void)getHeaderOfferPaiById:(NSString *)companyId{
//    requestType_ = Request_GetHeaderOfferPai;
//    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@", companyId];
//    NSString *function = @"getJobfairNearByuId";
//    NSString *op = @"offerpai_busi";
//    //发送请求
//    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
//}

#pragma mark offer派分类简历列表
//- (void)getOfferPersonList:(NSString *)offerPartyId companyId:(NSString *)companyId personType:(NSString *)personType keywords:(NSString *)keywords searchDic:(NSDictionary *)searchDic pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize salerName:(NSString *)salerName
//{
//    requestType_ = Request_GetOfferPartyPersonList;
//    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
//    if (searchDic) {
//        [conditionDic setDictionary:searchDic];
//    }
//    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
//    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"page_size"];
//    [conditionDic setObject:keywords forKey:@"search_name"];
//    if (salerName)
//    {
//        [conditionDic setObject:salerName forKey:@"u_user"];
//    }
//    
//    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
//    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
//    
//    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&uId=%@&person_type=%@&conditionArr=%@&", offerPartyId, companyId, personType, conDicStr];
//    NSString * function = @"getPersonList";
//    NSString * op = @"offerpai_busi";
//    //发送请求
//    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
//}

#pragma mark 批量处理简历的状态
- (void)dealResumeStates:(NSArray *)resumeIdArray state:(NSString *)state type:(NSString *)type role:(NSString *)role roleId:(NSString *)roleId
{
    requestType_ = Request_DealResumeStates;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:role forKey:@"role"];
    [conditionDic setObject:roleId forKey:@"role_id"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *idArrayStr = [jsonWriter stringWithObject:resumeIdArray];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tuijian_id={ \"id\":%@}&filetype=%@&state=%@&conditionArr=%@", idArrayStr, state, type, conditionStr];
    NSString * function = @"updateTjState";
    NSString * op = @"offerpai_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
    
////    NSString *_companyId = [CommonConfig getDBValueByKey:@"companyId"];
//    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
//    [tjresumeDic setObject:userModal.companyId forKey:@"reid"];
//    [tjresumeDic setObject:userModal.recommendId forKey:@"id"];
//    [tjresumeDic setObject:userModal.companyId forKey:@"company_id"];
//    [tjresumeDic setObject:type forKey:@"type"];
//    [tjresumeDic setObject:state forKey:@"state"];
//    
//    
//    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
//    [commentDic setObject:userModal.zpId_ forKey:@"jobid"];
//    [commentDic setObject:@"" forKey:@"commentContent"];
//    [commentDic setObject:@"申请面试" forKey:@"comment_type"];
//    [commentDic setObject:roleId forKey:@"person_id"];
//    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
//    if (synergy_id && synergy_id.length > 1) {
//        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
//    }
//    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
//    [commentDic setObject:@"5" forKey:@"person_type"];
//    
//    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:role forKey:@"role"];
//    [conditionDic setObject:roleId forKey:@"role_id"];
//    
//    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
//    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
//    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
//    NSString *conditionStr = [jsonWrite stringWithObject:conditionDic];
//    
//    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=%@", tjresumeStr, commentStr, conditionStr];
//    
//    NSString * function = @"updateTjStateNew";
//    NSString * op = @"offerpai_busi";

    
    //发送请求
//    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

- (void)bingdingStatusWith:(NSString *)userId
{
    requestType_ = requestBingdingStatusWith;
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString *function = @"isBindingPerson";
    NSString *op = @"binding_salerperson_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}


- (void)refreshbingdingStatusWith:(NSString *)userId
{
    requestType_ = refreshbingdingStatusWith;
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",userId];
    NSString *function = @"isBindingPerson";
    NSString *op = @"binding_salerperson_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}


- (void)gunwenLoginWith:(NSString *)oaUserName pswd:(NSString *)oaPswd userId:(NSString *)userId
{
    requestType_ = gunwenLoginWith;
    NSString *bodyMsg = [NSString stringWithFormat:@"username=%@&password=%@&person_id=%@",oaUserName,oaPswd,userId];
    NSString *function = @"authorize_login";
    NSString *op = @"shop_admin_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

- (void)gunwenJieBang:(NSString *)salerid personId:(NSString *)personId
{
    requestType_ = gunwenJieBang;
    NSString *bodyMsg = [NSString stringWithFormat:@"saler_id=%@&person_id=%@",salerid,personId];
    NSString *function = @"cancelBinDing";
    NSString *op = @"binding_salerperson_busi";
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

//附近职位
- (void)nearWorksWithLng:(NSString *)lng Lat:(NSString *)lat Range:(NSInteger)range keWord:(NSString *)keyWords tradeId:(NSString *)tradeId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize geo_diff:(NSInteger)geo_diff
{
    requestType_ = Request_nearWords;
    
    //组装设置参数
    NSMutableDictionary * setDic = [[NSMutableDictionary alloc] init];
    [setDic setObject:keyWords forKey:@"keywords"];
    [setDic setObject:tradeId forKey:@"tradeId"];
    [setDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [setDic setObject:pageParams forKey:@"page_size"];
    [setDic setObject:[NSString stringWithFormat:@"%ld",(long)geo_diff] forKey:@"geo_diff"];
    
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:setDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"lng=%@&lat=%@&rang=%ld&conditionArr=%@&", lng,lat,(long)range,conditionStr];
    
    NSString *op = @"shop_admin_busi";
    NSString *function = @"searchMapCompanyNew";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - //顾问搜索简历新
-(void)guwenSearchConWithKeyword:(NSString *)keyword salarid:(NSString *)salarId  pageSize:(NSInteger)pageSize page:(NSInteger)page model:(SearchParam_DataModal *)model searchType:(NSString *)searchType{
    requestType_ = Request_ConsultantSearchResume;
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    if (keyword && ![keyword isEqualToString:@""]) {
        if ([searchType isEqualToString:@"job"]) {
            [searchDic setObject:keyword forKey:@"jtzw"];
        }else if ([searchType isEqualToString:@"company"]) {
            [searchDic setObject:keyword forKey:@"company"];
        }else{
            [searchDic setObject:keyword forKey:@"keywords"];
        }
    }
    
    if (model) {
        if (model.eduId_ && ![model.eduId_ isEqualToString:@""]) {
            [searchDic setObject:model.eduId_ forKey:@"eduId"];
        }
        if (model.experienceValue1 && model.experienceValue2){
            if ([model.experienceValue1 isEqualToString:@"0"] && [model.experienceValue2 isEqualToString:@"0"]) {
                [searchDic setObject:@"0" forKey:@"rctypes"];
            }else{
                [searchDic setObject:model.experienceValue1 forKey:@"gznum_begin"];
                [searchDic setObject:model.experienceValue2 forKey:@"gznum_end"];  
            }
        }
        if (model.workAgeValue_ && model.workAgeValue_1) {
            [searchDic setObject:model.workAgeValue_ forKey:@"age_begin"];
            [searchDic setObject:model.workAgeValue_1 forKey:@"age_end"];
        }
        if (model.regionId_ && ![model.regionId_ isEqualToString:@""]) {
            [searchDic setObject:model.regionId_ forKey:@"regionid"];
        }
        //意向地区为字段gzdd，暂未用到
    }
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = @"";
    if (searchDic.count > 0) {
        searchStr = [jsonWriter stringWithObject:searchDic];
    }
    NSString *condictionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"sa_user_id=%@&search_arr=%@&condition_arr=%@",salarId,searchStr,condictionStr];
    NSString * function = @"myFindPersonList";
    NSString * op = @"app_jjr_api_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",NewSeviceURL,[self getTwoAccessModel].sercet_,[self getTwoAccessModel].accessToken_,op,function,New_Request_Version] bodyMsg:bodyMsg method:nil];
    
}

//顾问搜索简历
- (void)gunwenSearchResume:(NSString *)keyWords tradeId:(NSString *)tradeId regionId:(NSString *)regionId gznum:(NSString *)gznum gznum1:(NSString *)gznum1 rctypes:(NSString *)rctypes personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex withIsTotal:(BOOL)isTotal searchType:(NSString *)searchType salerName:(NSString *)salerName
{
    requestType_ = Request_ConsultantSearchResume;
    NSMutableDictionary * searchDic = [[NSMutableDictionary alloc] init];
    if (keyWords ==nil) {
        keyWords = @"";
    }
    if (tradeId == nil) {
        tradeId = @"";
    }
    if (regionId == nil ||[regionId isEqualToString:@"100000"]) {
        regionId = @"";
    }
    if (gznum == nil) {
        gznum = @"";
    }
    if ([rctypes isEqualToString:@"0"]) {
        [searchDic setObject:rctypes forKey:@"rctypes"];
    }
    [searchDic setObject:tradeId forKey:@"tradeId"];
    [searchDic setObject:regionId forKey:@"regionid"];
    if ([gznum isEqualToString:@"0"] && [gznum1 isEqualToString:@"0"]) {//应届毕业生
        [searchDic setObject:@"0" forKey:@"rctypes"];
    }else{
        [searchDic setObject:gznum forKey:@"gznum1"];
        [searchDic setObject:gznum1 forKey:@"gznum2"];
    }
    if (isTotal) {
        [searchDic setObject:@"1" forKey:@"trade"];
    }
    else
    {
        [searchDic setObject:@"0" forKey:@"trade"];
    }
    
    [searchDic setObject:keyWords forKey:@"keywords"];
    [searchDic setObject:searchType forKey:@"searchType"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:personId forKey:@"person_id"];
    [conditionDic setObject:salerName forKey:@"u_user"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString *searDicStr = [jsonWriter stringWithObject:searchDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", searDicStr,conDicStr];
    NSString * function = @"searchPerson";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问已下载简历列表
- (void)guwenLoadResumeList:(NSString *)salerId keywords:(NSString *)keywords pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_GuwenLoadResumeList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = @"";
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    if (keywords.length > 0) {
        [searchDic setObject:keywords forKey:@"keywords"];
        searchStr = [jsonWriter stringWithObject:searchDic];
    }

    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@&searchArr=%@", salerId, conDicStr, searchStr];
    NSString * function = @"getDownPersonList";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问已推荐简历列表
- (void)guwenRecomResumeList:(NSString *)personId keywords:(NSString *)keywords pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_GuwenRecomResumeList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    [searchDic setObject:keywords forKey:@"person_name"];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"sa_user_id=%@&conditionArr=%@&searchArr=%@", personId,conDicStr, searchStr];
    NSString * function = @"getProjectPersonListByUserid";
    NSString * op = @"app_jjr_api_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",NewSeviceURL,[self getTwoAccessModel].sercet_,[self getTwoAccessModel].accessToken_,op,function,New_Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问打电话OA
- (void)guwenCallPerson:(NSString *)saler_uname personId:(NSString *)personId personMmobile:(NSString *)personMobile
{
    requestType_ = Request_GuwenCallPerson;
    NSString * bodyMsg = [NSString stringWithFormat:@"saler_uname=%@&person_id=%@&person_mobile=%@", saler_uname,personId,personMobile];
    NSString * function = @"callPerson";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问下载简历
- (void)gunwenLoadResume:(NSString *)salerName rencaiId:(NSString *)rencaiId
{
    requestType_ = Request_GunwenLoadResume;
    NSString * bodyMsg = [NSString stringWithFormat:@"saler_name=%@&person_id=%@", salerName,rencaiId];
    NSString * function = @"downloadResume";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 下载人才联系
- (void)gunwenLoadConstanct:(NSString *)salerName rencaiId:(NSString *)rencaiId
{
    requestType_ = Request_GunwenLoadConstanct;
    NSString * bodyMsg = [NSString stringWithFormat:@"saler_uname=%@&person_id=%@", salerName,rencaiId];
    NSString * function = @"showContract";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 根据意向职位搜索在招企业
- (void)gunwenSearchCompany:(NSString *)job tradeid:(NSString *)tradeid personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex regionId:(NSString *)regionId gznum:(NSString *)gznum rctypes:(NSString *)rctypes;
{
    requestType_ = Request_GunwenSearchCompany;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    
    if (regionId == nil ||[regionId isEqualToString:@"100000"]) {
        regionId = @"";
    }
    if (gznum == nil) {
        gznum = @"";
    }
    if ([rctypes isEqualToString:@"0"]) {
        [conditionDic setObject:rctypes forKey:@"rctypes"];
    }
    [conditionDic setObject:regionId forKey:@"regionid"];
    [conditionDic setObject:gznum forKey:@"gznum"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:personId forKey:@"person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"job=%@&tradeid=%@&conditionArr=%@", job,tradeid,conDicStr];
    NSString * function = @"getCompanyByJob";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问获取行业
- (void)gunwenTrade:(NSString *)personId
{
    requestType_ = Request_GunwenTrade;
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@", personId];
    NSString * function = @"getSearchTrade";
    NSString * op = @"shop_admin_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 推荐简历
- (void)recommendPerson:(NSString *)rcPersonId salerUname:(NSDictionary *)salerUname companyStr:(NSArray *)companyArr zwName:(NSString *)zwName
{
    requestType_ = Request_RecommendPerson;
    NSMutableDictionary *jobIdDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<companyArr.count; i++) {
        CompanyInfo_DataModal *model = companyArr[i];
        NSDictionary *dic = @{@"uid":model.uid,
                              @"zwid":model.companyID_};
        [jobIdDic setObject:dic forKey:[NSString stringWithFormat:@"%d",i]];
    }
    NSDictionary *conditionArr = @{@"contentforcompany":zwName,
                                   @"contentforperson":@""};
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jobIdArrStr = [jsonWriter stringWithObject:jobIdDic];
    NSString *salerUnameStr = [jsonWriter stringWithObject:salerUname];
    NSString *conditionArrStr = [jsonWriter stringWithObject:conditionArr];
    NSString * bodyMsg = [NSString stringWithFormat:@"jobidArr=%@&tjperson_id=%@&sa_user_info=%@&conditionArr=%@&sendforperson=@0",jobIdArrStr,rcPersonId, salerUnameStr, conditionArrStr];

    NSString * function = @"recommendPerson";
    NSString * op = @"shop_admin_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 上传通讯录判断
-(void)getIsUpdateAddressBook:(NSString *)personId
{
    requestType_ = Request_IsUpdateAddressBook;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personid=%@",personId];
    NSString * function = @"isExistsContactInfo";
    NSString * op = @"app_contact_list_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 上传手机通讯录
-(void)updateAddressBook:(NSDictionary *)dic IsFirst:(BOOL)isFirst personId:(NSString *)personId ylPerson:(BOOL)ylPerson groupId:(NSString *)groupId
{
    requestType_ = Request_UpdateAddressBook;
    
    NSMutableDictionary *otherDic = [[NSMutableDictionary alloc] init];
    if (isFirst) {
        [otherDic setObject:@"1" forKey:@"is_first"];
    }
    if (ylPerson) {
        [otherDic setObject:@"1" forKey:@"yl_list"];
    }
    [otherDic setObject:groupId forKey:@"group_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString *conDicStr = [jsonWriter stringWithObject:dic];
    NSString *otherStr = [jsonWriter stringWithObject:otherDic];
    
    NSString *uuid = [MyCommon getAddressBookUUID];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@&device_tag=%@&contact_list=%@&other_info=%@",personId,uuid,conDicStr,otherStr];
    NSString * function = @"uploadContactList";
    NSString * op = @"app_contact_list_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 一览通讯录好友列表
-(void)addressBookListPage:(NSInteger)page pageSize:(NSInteger)pageSize personId:(NSString *)personId ylPerson:(BOOL)ylPerson groupId:(NSString *)groupId
{
    requestType_ = Request_AddressBookList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    if (ylPerson) {
        [conditionDic setObject:@"1" forKey:@"yl_list"];
    }
    [conditionDic setObject:groupId forKey:@"group_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString *searchStr = @"";
    if (searchDic.count > 0) {
        searchStr = [jsonWriter stringWithObject:searchDic];
    }
    
    NSString *uuid = [MyCommon getAddressBookUUID];
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@&device_tag=%@&search_arr=%@&condition_arr=%@",personId,uuid,searchStr,conDicStr];
    NSString * function = @"getPersonContactList";
    NSString * op = @"app_contact_list_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取顾问联系记录数量
- (void)consultantVisitNum:(NSString *)selaName
{
    requestType_ = Request_consultantVisitNum;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"%@",selaName];
    NSString * function = @"getPersonContactList";
    NSString * op = @"app_contact_list_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取招聘顾问回访简历列表
- (void)getGuwenVistList:(NSString *)salerUsername type:(NSString *)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = request_GetGuwenVistList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"saler_uname=%@&type=%@&conditionArr=%@",salerUsername,type,conDicStr];
    NSString * function = @"getReturnVisitList";
    NSString * op = @"research_record_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark - 获取回访列表
-(void)getReplyList:(NSString *)personId type:(NSString *)messageType pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = request_GetReplyList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&type=%@&conditionArr=%@",personId,messageType,conDicStr];
    NSString * function = @"getPersonVisitList";
    NSString * op = @"research_record_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 添加回访记录
-(void)addVisit:(NSString *)saler_id recodeId:(NSString *)recodeId personid:(NSString *)personId content:(NSString *)content type:(NSString *)type
{
    requestType_ = request_addVisit;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setValue:content forKey:@"content"];
    [conditionDic setValue:saler_id forKey:@"saler_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&type=%@&conditionArr=%@",personId,type,conDicStr];
    NSString * function = @"addPersonVisit";
    NSString * op = @"research_record_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 个人参与offerparty的数量
- (void)getPersonOfferPartyCount:(NSString *)userId
{
    requestType_ = Request_GetPersonOfferPartyCount;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personid=%@&",userId];
    NSString * function = @"getPersonJobfairCount";
    NSString * op = @"offerpai_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 点击通讯录好友发送请求
-(void)sendAddressBookFriend:(NSString *)personId contactId:(NSString *)contactId
{
    requestType_ = Request_SendAddressBookFriend;
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"personId=%@&contactId=%@",personId,contactId];
    NSString * function = @"syncContactListPersonInfo";
    NSString * op = @"app_contact_list_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 点击互动请求
-(void)sendAddVoteLogsGaapId:(NSString *)gaapId personId:(NSString *)personId clientId:(NSString *)clientId
{
    requestType_ = Request_AddVoteLogs;
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = @"";
    if (conditionDic.count > 0) {
        conDicStr = [jsonWriter stringWithObject:conditionDic];
    }
    NSString *uid = @"";
    if (personId) {
        uid = personId;
    }
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"gaap_id=%@&person_id=%@&client_id=%@&conditionArr=%@",gaapId,uid,clientId,conDicStr];
    NSString * function = @"add_vote_logs";
    NSString * op = @"comm_article_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 按类型请求offer派人才列表
//-(void)getPersonListByFairId:(NSString *)jobfair_id personType:(NSString *)person_type status:(NSString *)status salerId:(NSString *)saler_id keywords:(NSString *)keywords pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
//{
//    requestType_ = Request_GetPersonListByFairId;
//    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
//    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
//    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"page_size"];
//    [conditionDic setObject:keywords forKey:@"search_name"];
//    if (status) {//状态
//        [conditionDic setObject:status forKey:@"ztai"];
//    }
//    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
//    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
//    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&saler_id=%@&person_type=%@&conditionArr=%@",jobfair_id,saler_id,person_type,conDicStr];
//    NSString * function = @"getPersonListBysalerId";
//    NSString * op = @"offerpai_busi";
//    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
//}

#pragma mark - offer可推荐企业列表
-(void)getJobFairCompany:(NSString *)jobfair_id personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_GetJobFairCompany;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&person_id=%@&conditionArr=%@",jobfair_id,personId,conDicStr];
    NSString * function = @"getJobfairCompany";
    NSString * op = @"jobfair_person_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark = offer批量推荐人才给企业
-(void)recommendPersonToCompany:(NSString *)jobfairid companyID:(NSArray *)companyArray personID:(NSString *)personID salerId:(NSString *)salerId isLineUPFlag:(BOOL)lineUp
{
    requestType_ = Request_RecommendPersonToCompany;
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    if (salerId != nil) {
        [conditionDic setObject:salerId forKey:@"add_user"];
    }
    if (lineUp) {
        [conditionDic setObject:@"1" forKey:@"tuijian_paidui"];
    }
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSMutableArray *companyIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *jobIdArray = [[NSMutableArray alloc] init];
    for (int i=0; i < [companyArray count]; i ++) {
        CompanyInfo_DataModal *model = companyArray[i];
        [companyIdArray addObject:model.uid];
        [jobIdArray addObject:model.jobId];
    }
    NSString *companyIdStr = [jsonWriter stringWithObject:companyIdArray];
    NSString *jobIdStr = [jsonWriter stringWithObject:jobIdArray];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&company_idArr=%@&job_idArr=%@&person_id=%@&conditionArr=%@", jobfairid, companyIdStr, jobIdStr,personID,conditionStr];
    NSString * function = @"recommendPerson";
    NSString * op = @"jobfair_person_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问offer派中心
-(void)getOfferPartyCount:(NSString *)jobfairId
{
    requestType_ = Request_GetOfferPartyCount;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@",jobfairId];
    NSString * function = @"getJobfairDetail";
    NSString * op = @"jobfair_person_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 确认人才到场
/**
 $conditionArr['role']  30顾问20企业10人才40其他
 $conditionArr['roleid'] 顾问编号 企业编号 人才编号等
 $conditionArr['e_desc'] 动作描述
 */
- (void)joinPerson:(NSString *)jobfairpersonId jonstate:(NSString *)state roleId:(NSString *)roleId role:(NSString *)role editDesc:(NSString *)editDesc
{
    requestType_ = Request_joinPerson;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:role forKey:@"role"];
    [conditionDic setObject:roleId forKey:@"roleid"];
    if (editDesc) {
        [conditionDic setObject:editDesc forKey:@"e_desc"];
    }
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_person_id=%@&join_state=%@",jobfairpersonId,state];
    NSString * function = @"joinPerson";
    NSString * op = @"jobfair_person_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 扫描二维码签到
- (void)signInOfferPartyId:(NSString *)offerPartyId userId:(NSString *)userId roleId:(NSString *)roleId role:(NSString *)role
{
    requestType_ = Request_SignInOfferParty;
    
    NSMutableDictionary *condictionDic = [[NSMutableDictionary alloc] init];
    [condictionDic setObject:role forKey:@"role"];
    [condictionDic setObject:roleId forKey:@"roleid"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:condictionDic];
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&person_id=%@&conditionArr=%@", offerPartyId, userId,condictionStr];
    NSString * function = @"joinPerson_code";
    NSString * op = @"offerpai_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark- 推荐详情列表
- (void)getRecommentInfo:(NSString *)jobfairpersonId
{
    requestType_ = Request_GetRecommentInfo;
    
    //设置请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_person_id=%@",jobfairpersonId];
    NSString * function = @"getRecommendInfo";
    NSString * op = @"offerpai_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark - 已确认适合/已发offer/已上岗企业列表
- (void)getItemCompany:(NSString *)item jobfair_id:(NSString *)jobfairid personId:(NSString *)personId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_GetItemCompany;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:jobfairid forKey:@"jobfair_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"item=%@&person_id=%@&conditionArr=%@",item,personId,conDicStr];
    NSString * function = @"getItemCompany";
    NSString * op = @"jobfair_person_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 顾问未推荐人才列表
- (void)getUnRecomPersonList:(NSString *)jobfair_id pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_GetUnRecomPersonList;
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    NSString * bodyMsg = [NSString stringWithFormat:@"jobfair_id=%@&conditionArr=%@",jobfair_id,conDicStr];
    NSString * function = @"getNorecommendList";
    NSString * op = @"offerpai_busi";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 请求提问标签
- (void)getAskQuestTags
{
    requestType_ = Request_AskQuestTags;
    
    //组装请求参数
    NSString * bodyMsg = @" ";
    NSString * function = @"getQuestionTagList";
    NSString * op = @"zd_ask_question_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark - 文章可点击域名
-(void)getClickDomainList
{
    requestType_ = Request_GetClickDomainList;
    
    //设置请求参数
    NSString * function = @"getClickDomainList";
    NSString * op = @"comm_article_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:@"bodymsg" method:nil];
}

#pragma mark - 未阅简历处理
-(void)readMarkWithTuijianId:(NSString *)tuijianId
{
    requestType_ = RequestReadMarkWithTuijianId;
    
    //设置请求参数
    NSString * function = @"updateCompanyReadState";
    NSString * op = @"offerpai_busi";
    NSString *bodyMsg = [NSString stringWithFormat:@"tuijian_id=%@",tuijianId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取未举办offer派列表
-(void)getLatelyJobfairList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex personId:(NSString *)personId regionId:(NSString *)regionId keyWord:(NSString *)keyWord fromType:(NSString *)fromType jobId:(NSString *)jobId
{
    requestType_ = Request_GetLatelyJobfairList;
    
    //设置请求参数
    NSString * function = @"getLatelyJobfairList";
    NSString * op = @"offerpai_busi";
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page_index"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:personId forKey:@"person_id"];
    [conditionDic setObject:regionId forKey:@"region"];
    [conditionDic setObject:keyWord forKey:@"keyword"];
    [conditionDic setObject:jobId forKey:@"classifyid"];//岗位
    [conditionDic setObject:fromType forKey:@"fromType"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"conditionArr=%@",conDicStr];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - offer派报名
-(void)addPersonToOfferPersonId:(NSString *)personid jobFairId:(NSString *)jobDairId
{
    requestType_ = Request_AddPersonToOffer;
    
    //设置请求参数
    NSString * function = @"addPersonToOffer";
    NSString * op = @"offerpai_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&jobfair_id=%@",personid,jobDairId];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

- (void)getLastTelTime:(NSString *)personId
{
    requestType_ = Request_getLastTelTime;
    
    //设置请求参数
    NSString * function = @"getLastTelTime";
    NSString * op = @"research_record_busi";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"personid=%@",personId];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}


#pragma mark - 职导行家列表
- (void)getJobGuideExpertList:(NSString *)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize productType:(NSInteger)productType regionId:(NSString *)regionId regionName:(NSString *)regionName
{
    requestType_ = Request_getJobGuideExpertList;
    
    NSString *op = @"zd_ask_question_busi";
    NSString *function = @"getExpertList";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    if (productType > 0)
    {
        [searchDic setObject:[NSString stringWithFormat:@"%ld",(long)productType] forKey:@"product_type"];
    }
    if (![regionId isEqualToString:@""])
    {
        [searchDic setObject:regionId forKey:@"regionid"];
        [searchDic setObject:regionName forKey:@"region_name"];
    }
    
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString *seaDicStr = [jsonWriter stringWithObject:searchDic];
    NSString *conDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", seaDicStr, conDicStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 职导行家信息
- (void)getExpertInfo:(NSString *)expertId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize userId:(NSString *)userId
{
    requestType_ = Request_getExpertInfo;
    
    NSString *op = @"zd_ask_question_busi";
    NSString *function = @"getExpertInfo";
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:userId forKey:@"login_person_id"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"expert_id=%@&conditionArr=%@", expertId, conDicStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取顾问邮箱
-(void)getGuwenEmail:(NSString *)role_id
{
    requestType_ = Request_GetGuwenEmail;
    //设置请求参数
    NSString * function = @"getRecruitmentConsultantEmail";
    NSString * op = @"person_info_busi";
    NSString *bodyMsg = [NSString stringWithFormat:@"role_id=%@",role_id];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 发送邮件给顾问
-(void)senderResumeToGuwenEmail:(NSString *)role_id personId:(NSString *)person_id email:(NSString *)email
{
    requestType_ = Request_SenderResumeToGuwenEmail;
    //设置请求参数
    NSString * function = @"sendResumeByRecruitmentConsultant";
    NSString * op = @"person_info_busi";
    NSString *bodyMsg = [NSString stringWithFormat:@"role_id=%@&personId=%@&target_email=%@",role_id,person_id,email];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取问答详情回复列表
-(void)getReplyCommentList:(NSString*)answerId pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetReplyCommentList;
    //设置请求参数
    NSString * function = @"getAnswerCommentList";
    NSString * op = @"zd_ask_question_busi";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:answerId forKey:@"relative_id"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *seaDicStr = [jsonWrite stringWithObject:searchDic];
    NSString *conDicStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", seaDicStr,conDicStr];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark - 行家评论列表
-(void)getExpertCommentWithExpertId:(NSString *)expertId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetExpertCommentList;
    //设置请求参数
    NSString * function = @"getPersonCommentList";
    NSString * op = @"zd_ask_question_busi";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:expertId forKey:@"expert_id"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *seaDicStr = [jsonWrite stringWithObject:searchDic];
    NSString *conDicStr = [jsonWrite stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@", seaDicStr,conDicStr];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 职导对行家评论
-(void)getAddExpertComment:(NSString *)userId expertId:(NSString *)expertId content:(NSString *)content type:(NSString *)type typeId:(NSString *)typeId star:(NSString *)star
{
    requestType_ = Request_GetAddtExpertComment;
    //设置请求参数
    NSString * function = @"addPersonComment";
    NSString * op = @"zd_ask_question_busi";
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:content forKey:@"content"];
    [commentDic setObject:type forKey:@"type"];
    [commentDic setObject:typeId forKey:@"type_id"];
    [commentDic setObject:star forKey:@"star"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *conDicStr = [jsonWrite stringWithObject:commentDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&expert_id=%@&commentInfo=%@", userId,expertId,conDicStr];
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark - 更多应用
- (void)getApplicationList:(NSString *)userId page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize phoneType:(NSInteger)type
{
    requestType_ = Request_GetApplicationList;
    
    NSString *function =@"getApplicationList";
    NSString *op = @"application_busi";
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"iphone_type"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *condictionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&conditionArr=%@", userId, condictionStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark 我的账户
- (void)getMyAccount:(NSString *)userId
{
    requestType_ = Request_GetMyAccount;
    NSString *function =@"getMyAccountInfo";
    NSString *op = @"yl_bill_record_busi";
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&", userId];
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 打赏记录
- (void)getRewardList:(NSString *)userId type:(NSString *)type page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetRewardList;
    
    NSString *function =@"getMyBillList";
    NSString *op = @"yl_bill_record_busi";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:type forKey:@"bill_type"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString *condictionStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&searchArr=%@&conditionArr=%@&", userId, searchStr, condictionStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 提现申请
- (void)cashApply:(NSString *)userId money:(NSString *)money summary:(NSString *)summary  account:(NSString *)account accName:(NSString *)accName
{
    requestType_ = Request_ApplyCash;
    NSString *function =@"addCashApply";
    NSString *op = @"yl_bill_record_busi";
    NSMutableDictionary *applyInfo = [[NSMutableDictionary alloc] init];
    applyInfo[@"cash_money"] = money;
    if (!summary) {
        summary = @"";
    }
    applyInfo[@"cash_remark"] = summary;
    applyInfo[@"account"] = account;
    applyInfo[@"account_name"] = accName;
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *applyStr = [jsonWriter stringWithObject:applyInfo];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"user_id=%@&applyInfo=%@", userId, applyStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

//余额支付
- (void)payWithyuer:(NSString *)gwc_id
{
    requestType_ = request_PayWithyuer;
    
    NSString *function = @"balanceBuy";
    NSString *op = @"ordco_service_comm";
    NSString *bodyMsg = [NSString stringWithFormat:@"gwc_id=%@",gwc_id];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function] bodyMsg:bodyMsg method:nil];
}

#pragma mark offer派详情URL
- (void)getOfferPartyDetailUrl:(NSString *)offerPartyId
{
    requestType_ = Request_OfferPartyDetailUrl;
    NSString *function = @"getoffer_url_3G";
    NSString *op = @"offerpai_busi";
    NSString *bodyMsg = [NSString stringWithFormat:@"zpid=%@&", offerPartyId];
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_, op, function, Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark 我的约谈
- (void)getAspectantDisListWithUserId:(NSString *)userId status:(NSInteger)status page:(NSInteger)pageIndex pageSize:(NSInteger)pageSize otherCond:(NSString *)otherCond
{
    requestType_ = Request_AspectantDisList;
    NSString * function = @"getRecordList";
    NSString * op = @"yuetan_record_busi";
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:userId forKey:@"person_id"];
    [searchDic setObject:[NSString stringWithFormat:@"%ld",(long)status] forKey:@"status"];
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex]  forKey:@"page"];
    [conditionDic setObject:pageParams  forKey:@"page_size"];
    [conditionDic setObject:otherCond forKey:@"othercond"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionDicStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

#pragma mark - 活动列表
-(void)getActivityListWithPersonId:(NSString *)personId page:(NSString *)page pageSize:(NSString *)pageSize type:(NSInteger)type
{
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:page forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:personId forKey:@"person_id"];
    SBJsonWriter *jsonWriterOne = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriterOne stringWithObject:searchDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionDicStr];
    NSString * function;
    if (type == 1)
    {
        requestType_ = Request_ActivityPublishList;
        function = @"get_my_activity_list";
    }
    else
    {
        requestType_ = Request_ActivityJoinList;
        function = @"get_join_activity_info";
    }
    
    NSString * op = @"salarycheck_all_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 活动成员列表
-(void)getActivityPeopleListWithPersonId:(NSString *)personId articleId:(NSString *)articleId page:(NSString *)page pageSize:(NSString *)pageSize
{
    requestType_ = Request_ActivityPeopleList;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:page forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter *jsonWriterOne = [[SBJsonWriter alloc] init];
    NSString * searchDicStr = [jsonWriterOne stringWithObject:searchDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"login_person_id=%@&article_id=%@&searchArr=%@&conditionArr=%@",personId,articleId,searchDicStr,conditionDicStr];
    NSString *function = @"getActivityEnrollList";
    
    NSString * op = @"salarycheck_all_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 约谈选择课程列表
-(void)getInterViewCourseListWithPersonId:(NSString *)personId
{
    requestType_ = Request_getCourseList;
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",personId];
    NSString *op = @"yuetan_record_busi";
    NSString *function = @"getPersonAllCourse";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 在招职位列表
-(void)getZpListWithCompanyId:(NSString *)companyId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_getZpListWithCompanyId;
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&page_size=%@&pageIndex=%@&conditionArr=%@",companyId,pageParams,[NSString stringWithFormat:@"%ld",(long)pageIndex],@""];
    NSString *op = @"zp_busi";
    NSString *function = @"getZplist";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 获取发布网站信息
-(void)getZWFBInfoWithCompanyId:(NSString *)companyId
{
    requestType_ = Request_getZWFBInfoWithCompanyId;
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@",companyId];
    NSString *op = @"zp_busi";
    NSString *function = @"getZpInfo";
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 发布职位
- (void)addPositionWithCompanyId:(NSString *)companyId dataModel:(ZWModel *)model
{
    requestType_ = Request_ADDJob;
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:model.regionid forKey:@"region"];
    [conditionDic setObject:model.gznumId forKey:@"gznum1"];
    [conditionDic setObject:model.gznumId1 forKey:@"gznum2"];
    [conditionDic setObject:model.jtzw forKey:@"jtzw"];
    if (model.job.length > 0) {
        [conditionDic setObject:model.job forKey:@"job"];
    }
    
    if (model.job_child.length > 0) {
        [conditionDic setObject:model.job_child forKey:@"job_child"];
    }
    
    if (model.deptId != nil) {
        [conditionDic setObject:model.deptId forKey:@"deptId"];
    }
    [conditionDic setObject:model.zpnum forKey:@"zpnum"];
    [conditionDic setObject:[model.salary isEqualToString:@"50000以上"]?@"50000-0":model.salary forKey:@"salary"];
    [conditionDic setObject:model.zptext forKey:@"zptext"];
    [conditionDic setObject:model.email forKey:@"email"];
    [conditionDic setObject:model.zp_urlId forKey:@"zp_urlId"];
    if (model.eduId != nil) {
        [conditionDic setObject:model.eduId forKey:@"eduId"];
    }
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",companyId,conditionDicStr];
    NSString *function = @"addJob";
    NSString * op = @"zp_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 文章打赏
- (void)getArticleRewardImg:(NSString *)articleId
{
    requestType_ = Request_getArticleRewardImg;
    
    NSString *bodyMsg = [NSString stringWithFormat:@"article_id=%@",articleId];
    NSString *function = @"getArticleLatestDs";
    NSString * op = @"dashang_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 我的打赏列表
- (void)getMyRewardList:(NSString *)personId userId:(NSString *)userId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    requestType_ = Request_getMyRewardList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:personId forKey:@"target_person_id"];
    [searchDic setObject:userId forKey:@"login_person_id"];
    
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    NSString *conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchStr,conditionStr];
    
    NSString *function = @"getDashangList";
    NSString *op = @"dashang_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - App综合搜索
-(void)getTodaySearchListKeyWord:(NSString *)keyWord
{
    requestType_ = Request_TodaySearchList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:keyWord forKey:@"keywords"];
    [searchDic setObject:[Manager shareMgr].haveLogin ? [Manager getUserInfo].userId_:@"" forKey:@"person_id"];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *searchStr = [jsonWriter stringWithObject:searchDic];
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@",searchStr];
    
    NSString *function = @"getSearchListByType";
    NSString *op = @"yl_search_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 社群文章列表
-(void)getGroupArticleListPersonId:(NSString *)personId loginPersonId:(NSString *)loginPersonId page:(NSInteger)page pageSize:(NSInteger)pageSize
{
    requestType_ = Request_MyGroupArticleList;
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    
    [searchDic setObject:personId forKey:@"person_id"];
    [searchDic setObject:loginPersonId forKey:@"login_person_id"];
    NSString *searchDicStr = [jsonWriter stringWithObject:searchDic];
    
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@&", searchDicStr, conditionDicStr];
    NSString * function = @"getMyGroupArticleList";
    NSString * op = @"groups_busi";
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 行家常用地址
-(void)getExpertRegionList:(NSString *)expertId page:(NSInteger)page pageSize:(NSInteger)pageSize
{
    requestType_ = Request_GetExpertRegionList;
    
    NSString *op = @"yl_daoshi_region_busi";
    NSString *function= @"getMyRegionList";
    
    NSMutableDictionary *conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionDicStr = [jsonWriter stringWithObject:conditionDic];
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&searchArr=&conditionArr=%@", expertId,conditionDicStr];
    
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@", [RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
}

#pragma mark - 请求搜索更多文章
-(void)getArticleBySearchKeyword:(NSString*)keyword  page:(NSInteger) pageIndex  pageSize:(NSInteger)pageSize
{
    requestType_ = Request_SearchMoreArticleList;
    //组装条件参数
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    [conditionDic setObject:pageParams forKey:@"page_size"];
    
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
    [searchDic setObject:keyword forKey:@"keywords"];
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
    NSString *searchDicStr = [jsonWriter2 stringWithObject:searchDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"searchArr=%@&conditionArr=%@",searchDicStr,conditionStr];
    NSString * function = @"searchArticleList";
    NSString * op = @"yl_search_busi";
    
    //发送请求
    [self startConn:[NSString stringWithFormat:@"%@&secret=%@&access_token=%@&op=%@&func=%@&version=%@",[RequestCon getBaseURL],[self getAccessModel].sercet_,[self getAccessModel].accessToken_,op,function,Request_Version] bodyMsg:bodyMsg method:nil];
    
}

-(AccessToken_DataModal *)getAccessModel{
    if ([Manager shareMgr].accessTokenModal) {
        return [Manager shareMgr].accessTokenModal;
    }else{
        [[Manager shareMgr] configToken:AccessTokenTypeOne userName:WebService_User pwd:WebService_Pwd modelType:[Manager shareMgr].accessTokenModal baseUrl:SeviceURL];
    }
    return [AccessToken_DataModal new];
}

-(AccessToken_DataModal *)getTwoAccessModel{
    if ([Manager shareMgr].accessTokenNewModal) {
        return [Manager shareMgr].accessTokenNewModal;
    }else{
        [[Manager shareMgr] configToken:AccessTokenTypeTwo userName:@"jjr" pwd:@"jjr889900" modelType:[Manager shareMgr].accessTokenNewModal baseUrl:NewSeviceURL];
    }
    return [AccessToken_DataModal new];
}

-(AccessToken_DataModal *)getThreeAccessModel{
    if ([Manager shareMgr].accessTokenFourModal) {
        return [Manager shareMgr].accessTokenFourModal;
    }else{
        [[Manager shareMgr] configToken:AccessTokenTypeThree userName:@"recommend" pwd:@"recommend123" modelType:[Manager shareMgr].accessTokenThreeModal baseUrl:NewSeviceURL];
    }
    return [AccessToken_DataModal new];
}

-(AccessToken_DataModal *)getFourAccessModel{
    if ([Manager shareMgr].accessTokenFourModal) {
        return [Manager shareMgr].accessTokenFourModal;
    }else{
        [[Manager shareMgr] configToken:AccessTokenTypeFour userName:@"message" pwd:@"message889900" modelType:[Manager shareMgr].accessTokenFourModal baseUrl:NewSeviceURL];
    }
    return [AccessToken_DataModal new];
}

@end

@implementation ExRequetCon

@end


