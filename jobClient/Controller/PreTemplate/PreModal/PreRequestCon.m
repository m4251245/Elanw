//
//  PreRequestCon.m
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PreRequestCon.h"
#import "CondictionList_DataModal.h"
#import "GTMBase64.h"
#import "DataManger.h"
#import "Op_DataModal.h"
#import "PreMyDataBase.h"
#import "PreBaseUIViewController.h"
#import "CondictionZWCtl.h"
#import "CondictionPlaceCtl.h"
#import "ExRequetCon.h"

Op_DataModal     *opDataModal;
Login_DataModal  *loginDataModal;

@implementation PreRequestCon

@synthesize requestStr_,parserType_,delegate_;

-(id) init
{
    if (self = [super init]) {
        receivedData_ = [[NSMutableData alloc] init];

        xmlParser_ = [[XMLParser alloc] init];
        xmlParser_.delegate_ = self;
    }
	return self;
}

//获取请求类型
+(NSString *) getRequestStr:(XMLParserType)type
{
    NSString *str = nil;
    
    switch ( type ) {
        case InitOp_XMLParser:
            str = @"加载";
            break;
        case DoLogin_XMLParser:
            str = @"登录";
            break;
        case FindSercet_XMLParser:
            str = @"找回密码";
            break;
        case Regest_XMLParser:
            str = @"注册";
            break;
        case AddAdvice_XMLParser:
            str = @"提交意见";
            break;
        case GetVersion_XMLParser:
            str = @"检查更新";
            break;
        case ZW_Apply_XMLParser:
            str = @"申请职位";
            break;
        case ZW_Fav_XMLParser:
            str = @"收藏职位";
            break;
        case Update_PersonImage_XMLParser:
            str = @"上传图像";
            break;
        case Delete_PersonImage_XMLParser:
            str = @"删除图像";
            break;
        case SetSubscribe_XMLParser:
            str = @"设置推送信息";
            break;
        case DelSubscribe_XMLParser:
            str = @"删除";
            break;
        case AddSubscribe_XMLParser:
            str = @"添加订阅";
            break;
        case ReSetSercet_XMLParser:
            str = @"重设密码";
            break;
        case DelFavZW_XMLParser:
            str = @"删除";
            break;
        case RefreshResume_XMLParser:
            str = @"刷新简历";
            break;
        case UpdateResumeStatus_XMLParser:
            str = @"更新求职状态";
            break;
        case UpdateResumeSercet_XMLParser:
            str = @"更新保密设置";
            break;
        case UpdateResume_BaseInfo_XMLParser:
            str = @"保存基本资料";
            break;
        case UpdateResume_WantJob_XMLParser:
            str = @"保存求职意向";
            break;
        case UpdateResume_OldEdu_XMLParser:
            str = @"保存教育背景";
            break;
        case UpdateResume_OldWorks_XMLParser:
            str = @"保存工作经历";
            break;
        case UpdateResume_SkillInfo_XMLParser:
            str = @"保存工作技能";
            break;
        case UpdateResume_PersonCer_XMLParser:
            str = @"保存证书信息";
            break;
        case AddResume_PersonCer_XMLParser:
            str = @"保存证书信息";
            break;
        case DelResume_PersonCer_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_Edu_XMLParser:
            str = @"保存教育背景";
            break;
        case AddResume_Edu_XMLParser:
            str = @"保存教育背景";
            break;
        case DelResume_Edu_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_Work_XMLParser:
            str = @"保存工作经历";
            break;
        case AddResume_Work_XMLParser:
            str = @"保存工作经历";
            break;
        case DelResume_Work_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_PersonAward_XMLParser:
            str = @"保存个人奖项信息";
            break;
        case AddResume_PersonAward_XMLParser:
            str = @"添加个人奖项信息";
            break;
        case DelResume_PersonAward_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_PersonLeader_XMLParser:
            str = @"更新学生干部经历";
            break;
        case AddResume_PersonLeader_XMLParser:
            str = @"学生干部经历";
            break;
        case DelResume_PersonLeader_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_PersonProject_XMLParser:
            str = @"更新项目活动经历";
            break;
        case AddResume_PersonProject_XMLParser:
            str = @"添加项目活动经历";
            break;
        case DelResume_PersonProject_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_StudentLeader_XMLParser:
            str = @"保存干部经历";
            break;
        case AddResume_StudentLeader_XMLParser:
            str = @"添加干部经历";
            break;
        case DelResume_StudentLeader_XMLParser:
            str = @"删除";
            break;
        case UpdateResume_Project_XMLParser:
            str = @"保存项目活动经历";
            break;
        case AddResume_Project_XMLParser:
            str = @"保存项目活动经历";
            break;
        case DelResume_Project_XMLParser:
            str = @"删除";
            break;
        case AddBBS_XMLParser:
            str = @"提交";
            break;
        case AddAgree_XMLParser:
            str = @"添加支持";
            break;
        case AddCompanyComment_XMLParser:
            str = @"提交";
            break;
        case AddCompanyReply_XMLParser:
            str = @"提交";
            break;
        case CancelAttention_School_XMLParser:
            str = @"取消关注";
            break;
        case AddAttention_School_XMLParser:
            str = @"添加关注";
            break;
        case SetMySchool_XMLParser:
            str = @"设置学校";
            break;
        default:
            break;
    }
    
    return str;
}

//检查是否需要放入缓存
+(BOOL) checkDataNeedSave:(XMLParserType)type
{
//    if(type ==  Image_XMLParser                     ||          /*图片*/
//       //type ==  GetSchoolList_XMLParser             ||          /*某地区学校列表*/
//       type ==  GetCompanyDes_XMLParser             ||          /*企业描述*/
//       type ==  GetCompanyDetail_XMLParser          ||          /*企业详情*/
//       type ==  ResumeNotifiDetail_XMLParser        ||          /*面试通知详情*/
//       type ==  GetSalary_XMLParser                 ||          /*薪酬查询*/
//       1    ==  2                                               //没有意义，此条件不会成立，为了以后更改方便,美观
//       )
//    {
//        return YES;
//    }
    
    return NO;
}

//检查是否需要缓存到本地
+(BOOL) checkLocalDBSave:(XMLParserType)type
{
    if(
       type ==  GetXjhDetail_XMLParser              ||          /*宣讲会简介*/
       type ==  GetZphDetail_XMLParser              ||          /*招聘会简介*/
       type ==  ProfessionPower_Detail_XMLParser    ||          /*职位力量(新闻)详情*/
       type ==  PreProfessionPower_Detail_XMLParser ||          /*职业的力量详情上一篇*/
       type ==  NextProfessionPower_Detail_XMLParser||          /*职业的力量详情下一篇*/
       type ==  GetArticleDetail_XMLParser          ||          /*职场风雨，简历制作等的详情*/
       type ==  GetPreProfessDetailInfo_XMLParser   ||          /*职场风雨上一篇*/
       type ==  GetNextProfessDetailInfo_XMLParser  ||          /*职场风雨下一篇*/
       type ==  GetTalentMarket_XMLParser           ||          /*人才market*/
       1    ==  2                                               //没有意义，此条件不会成立，为了以后更改方便,美观
       )
    {
        return YES;
    }
    
    return NO;
}

//设置登录的dataModal
+(void) setLoginDataModal:(Login_DataModal *)dataModal
{
    //loginDataModal = [[Login_DataModal alloc] init];
    [loginDataModal release];
    loginDataModal = [dataModal retain];
}

//send soap msg
-(void) connectBySoapMsg:(NSString *)soapMsg tableName:(NSString *)op
{
    //start get data
    [delegate_ loadDataBegin:self parserType:parserType_];
    
    self.requestStr_ = soapMsg;
    
//    if( accessTokenModal ){
//        [opDataModal release];
//        opDataModal = [[Op_DataModal alloc] init];
//        opDataModal.access_token_ = accessTokenModal.accessToken_;
//        opDataModal.sercet_ = accessTokenModal.sercet_;
//    }
    
    //如果存在,则代表需要网上去请求数据
    if( soapMsg || op ){
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
        
        NSString *action;
        if( op ){
            //action = [NSString stringWithFormat:@"%@&op=%@",serviceAddress_,op];
            
            //如果是初始化接口
            if( parserType_ == InitOp_XMLParser )
            {
                action = [[[NSString alloc] initWithFormat:@"%@&op=%@&%@%@",[PreCommonConfig getServiceDefaultAddress],op,WebService_Param_DebugMode,WebService_DebugMode] autorelease];
            }
            //如果初始化接口的数据不存在,则需要重新请求
            else if( !opDataModal )
            {
                //此时需要让代理再去初始化一次接口，并且请求中断,若代理在初始化成功接口后,会再次发起此次请求
                [delegate_ initOp:self soapMsg:soapMsg tableName:op];
                
                return;
            }
            //使用加密接口
            else
            {
                NSString *serviceAddr = nil;
                
                //使用接口返回来的服务器指向,达到负载均衡的目的
                if( opDataModal.serviceAddress_ && ![opDataModal.serviceAddress_ isEqualToString:@""] ){
                    serviceAddr = opDataModal.serviceAddress_;
                }else{
                    serviceAddr = [PreCommonConfig getServiceDefaultAddress];
                }
                
                action = [[[NSString alloc] initWithFormat:@"%@&op=%@&%@%@&%@%@&%@%@",serviceAddr,op,WebService_Param_Secret,opDataModal.sercet_,WebService_Param_AccessToken,opDataModal.access_token_,WebService_Param_DebugMode,WebService_DebugMode] autorelease];
            }
            
        }else
            action = soapMsg;
        
        NSURL *url = [NSURL URLWithString:action];
        
        //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url
                                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                 timeoutInterval:[PreCommonConfig getRequestTimeOutSeconds]] autorelease];
        
        if( op ){
            [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            //[request addValue: @"http://www.pingpingfen.com" forHTTPHeaderField:@"SOAPAction"];
            [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *mac = [PreCommon getDeviceID];
            [request addValue:mac forHTTPHeaderField:@"MAC"];
        }
        
        NSLog(@"[Soap Action] : %@",action);
        NSLog(@"[Soap Msg] : %@",soapMsg);
        
        xmlParser_.soapMsg_ = [NSString stringWithFormat:@"%@+%@",op,soapMsg];
        
        //检测是否有本地数据
        if( [PreRequestCon checkLocalDBSave:parserType_] ){
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*LocalRAM_Max_Day];
            NSString *dateStr = [PreCommon getDateStr:date];
            
            sqlite3_stmt *result = [myDB selectSQL:nil fileds:@"data,update_date" whereStr:[NSString stringWithFormat:@"url='%@' and update_date >= '%@'",xmlParser_.soapMsg_,dateStr] limit:1 tableName:DB_TableName_CacheData];
            
            NSData *data = nil;
            while ( sqlite3_step(result) == SQLITE_ROW )
            {
                //data
                char *rowData_0 = (char *)sqlite3_column_text(result, 0);
                
                data = [[NSData dataWithBytes:rowData_0   length:strlen(rowData_0)] retain];
                
            }
            
            sqlite3_finalize(result);
            
            //直接去解析
            if( data && [data length] > 0 )
            {
                xmlParser_.bFromDB_ = YES;
                NSLog(@"[Local DB] : Find Data!");
                
                //开始解析
                [xmlParser_ parserXML:data strData:nil parserType:parserType_];
                [data release];
                
                xmlParser_.bFromDB_ = NO;
                
                return;
            }
        }
        //是否需要查看缓存
        else if( [PreRequestCon checkDataNeedSave:parserType_] ){
//            Return_Data *returnData = [DataManger checkExistData:xmlParser_.soapMsg_];
//            if( returnData.bExist_ )
//            {
//                [delegate_ loadDataComplete:self code:Success dataArr:returnData.data_ parserType:parserType_];
//                
//                return;
//            }
        }
        
        //请求
        [receivedData_ setLength:0];
        [conn_ cancel];
        [conn_ release];
        conn_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if( conn_ )
        {
            
        }
        else
        {
            [delegate_ loadDataComplete:self code:Init_Internet_Error dataArr:nil parserType:parserType_];
        }
    }
    //不需要网上请求数据
    else
    {
        NSArray *arr = [self getLocalData:parserType_];
        
        [delegate_ loadDataComplete:self code:Success dataArr:arr parserType:parserType_];
    }
}

//stop conn
-(void) stopConn
{
	//release receive data
	[receivedData_ setLength:0];
	
	//release con
	[conn_ cancel];
	[conn_ release];
	conn_ = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//release receive data
	[receivedData_ setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData_ appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"[Request Connect] : Error");
	
	[delegate_ loadDataComplete:self code:No_Internet_Error dataArr:nil parserType:parserType_];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //调试模式
#ifndef __OPTIMIZE__
	NSString *tempStr = [[[NSString alloc] initWithData:receivedData_ encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"[Receive Data] : %@",tempStr);
#endif
    
    //release con
	[conn_ cancel];
	[conn_ release];
	conn_ = nil;
    
	//parser it
	[xmlParser_ parserXML:receivedData_ strData:nil parserType:parserType_];
	
	//release receive data
	[receivedData_ setLength:0];
}

#pragma mark XMLParserDelegate
-(void) parserFinish:(XMLParser *)parser code:(ErrorCode)code dateArr:(NSArray *)dataArr parserType:(XMLParserType)type
{
	@try {        
		//call back
		[delegate_ loadDataComplete:self code:code dataArr:dataArr parserType:type];
	}
	@catch (NSException * e) {
		NSLog(@"[Request Call Back Error] : %d",code);
	}
	@finally {
		
	}
}

//初始化接口(请求secret和access_token)(接口用户名,密码)
-(void) initOp:(NSString *)user pwd:(NSString *)pwd
{
    parserType_ = InitOp_XMLParser;
    
    //获取当前时间
    long long unsigned int seconds = [[NSDate date] timeIntervalSince1970];
    
    //获取密码＋seconds的md5值
    NSString *pwd_md5 = [MD5 getMD5:[NSString stringWithFormat:@"%@",pwd]];
    
    NSString *mode = @"release";
    
#ifdef DEBUG
    mode = @"debug";
#endif
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getAccessToken xmlns=\"http://api.job1001.com\">\n"
                             "<user>%@</user>"
                             "<md5>%@</md5>"
                             "<seconds>%llu</seconds>"
                             "<type>1</type>"
                             "<mode>%@</mode>"
                             "</getAccessToken>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",user,pwd_md5,seconds,mode];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Init_Op];
}

//加载图片
-(void) loadImage:(NSString *)imagePath
{
    parserType_ = Image_XMLParser;
    
    [self connectBySoapMsg:imagePath tableName:nil];
}

//登录
-(void) doLogin:(NSString *)userName pwd:(NSString *)pwd
{
	parserType_ = DoLogin_XMLParser;
    
    userName    = [PreCommon converStringToXMLSoapString:userName];
    pwd         = [PreCommon converStringToXMLSoapString:[MD5 getMD5:pwd]];
    
    if( !userName )
    {
        userName = @"";
    }
    
    if( !pwd )
    {
        pwd = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<doLogin xmlns=\"http://api.job1001.com\">\n"
                             
                             "<username>%@</username>"
                             "<password></password>"
                             "<pwd>%@</pwd>"
                             "<loginflag>person_self</loginflag>"
                             "</doLogin>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userName,pwd];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Person];
}

//注册
-(void) regest:(NSString *)email userName:(NSString *)userName pwd:(NSString *)pwd realName:(NSString *)realName phoneNumber:(NSString *)phoneNumber statusCode:(NSInteger)code typeStr:(NSString *)typeStr
{
    parserType_ = Regest_XMLParser;
    
    userName = [PreCommon converStringToXMLSoapString:userName];
    pwd = [PreCommon converStringToXMLSoapString:pwd];
    email = [PreCommon converStringToXMLSoapString:email];
    realName = [PreCommon converStringToXMLSoapString:realName];
    phoneNumber = [PreCommon converStringToXMLSoapString:phoneNumber];
    
    if( !userName || userName == nil ){
        userName = @"";
    }
    if( !pwd || pwd == nil ){
        pwd = @"";
    }
    if( !email || email == nil ){
        email = @"";
    }
    if( !realName || realName == nil ){
        realName = @"";
    }
    if( !phoneNumber || phoneNumber == nil ){
        phoneNumber = @"";
    }
    if( !typeStr || typeStr == nil ){
        typeStr = @"mobile";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<userRegisterNew xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">regtype</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">userInfo</key>"
                             "<value xsi:type=\"ns2:Map\">"
                             //"<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">uname</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">email</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">mobile</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">iname</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">password</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">person_status</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">tradeid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">tradeTotalid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             //"</item>"
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">conditionArr</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"1\" xsi:type=\"enc:Array\">"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">RegSource</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             "</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</userRegisterNew>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",typeStr,userName,email,phoneNumber,realName,pwd,(long)code,TradeId,TotalId,Client_Type];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Person];
}

//找回密码新接口
-(void) findSercet:(NSString *)email
{
    parserType_ = FindSercet_XMLParser;
    
    if( !email || email == nil )
    {
        email = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPassAction xmlns=\"http://www.job1001.com\">\n"
                             
                             "<email>%@</email>"
                             
                             "</getPassAction>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             email
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonDeal];
}

//提交意见
-(void) giveAdvice:(NSString *)msg contact:(NSString *)contact
{
    parserType_ = AddAdvice_XMLParser;
    
    NSString *locationTimeString = [PreCommon getCurrentDateTime];
    NSString *personId;
    NSString *uname;
    
    if( !contact || contact == nil )
    {
        contact = @"意见反馈";
    }else
    {
        contact = [PreCommon converStringToXMLSoapString:contact];
    }
    
    msg = [PreCommon converStringToXMLSoapString:msg];
    
    //如果用户没有登录，则给一个默认值
    if( !loginDataModal || loginDataModal.loginState_ != LoginOK )
    {
        personId    = [[[NSString alloc] initWithFormat:@"100000"] autorelease];
        uname       = [[[NSString alloc] initWithFormat:@"Non Login iPhone User"] autorelease];
    }else
    {
        personId    = loginDataModal.personId_;
        uname       = [PreCommon converStringToXMLSoapString:loginDataModal.uname_];
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<insertObject xmlns=\"http://www.job1001.com\">\n"
                             
                             "<soap-enc:array>"
                             "<typeId>%@</typeId>"
                             "<typeName>%@</typeName>"
                             "<title>%@</title>"
                             "<userid>%@</userid>"
                             "<uname>%@</uname>"
                             "<content>%@</content>"
                             "<addtime>%@</addtime>"
                             "</soap-enc:array>"
                             
                             "</insertObject>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             TableName_TypeId,
                             Client_Type,
                             contact,
                             personId,
                             uname,
                             msg,
                             locationTimeString
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_LogAdvice];
}

-(void) setSubscribeConfig:(NSString *)clientName clientVersion:(NSString *)clientVersion deviceId:(NSString *)deviceId deviceToken:(NSString *)deviceToken flagStr:(NSString *)flagStr startHour:(NSString *)startHour endHour:(NSString *)endHour betweenHour:(NSString *)betweenHour schoolId:(NSString *)schoolId schoolName:(NSString *)schoolName
{
    parserType_ = SetSubscribe_XMLParser;
    
    if( !clientName || clientName == nil )
    {
        clientName = @"";
    }
    
    if( !clientVersion || clientVersion == nil )
    {
        clientVersion = @"";
    }
    
    if( !flagStr || flagStr == nil )
    {
        flagStr = @"";
    }
    
    if( !deviceId || deviceId == nil )
    {
        deviceId = @"";
    }
    
    if( !deviceToken || deviceToken == nil )
    {
        deviceToken = @"";
    }
    
    if( !startHour || startHour == nil )
    {
        startHour = @"";
    }
    
    if( !endHour || endHour == nil )
    {
        endHour = @"";
    }
    
    if( !betweenHour || betweenHour == nil )
    {
        betweenHour = @"";
    }
    
    if( !schoolName || schoolName == nil ){
        schoolName = @"";
    }
    
    if( !schoolId || schoolId == nil ){
        schoolId = @"";
    }
    
    NSString *personId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK )
    {
        personId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<setSubscribeConfig xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">deviceId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bOn</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">startHour</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">endHour</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">betweenHour</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">deviceToken</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">userId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">schoolId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">schoolName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</setSubscribeConfig>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",clientName,clientVersion,deviceId,flagStr,startHour,endHour,betweenHour,deviceToken,personId,schoolId,schoolName];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_AppSubscribe_Config];
}

//检查更新
-(void) getVersion
{
    parserType_ = GetVersion_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getClientVersionInfo xmlns=\"http://www.job1001.com\">\n"
                             
                             "<clientName>%@</clientName>"
                             
                             "</getClientVersionInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             Client_Type
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:TableNaem_API_Log];
}

//更新使用数量
-(void) updateUseCount
{
    parserType_ = UpdateUseCount_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getClientVersionInfo xmlns=\"http://www.job1001.com\">\n"
                             
                             "<clientName>%@</clientName>"
                             
                             "</getClientVersionInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             Client_Type
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:TableNaem_API_Log];
}

//获取宣讲会信息
-(void) getXjh:(NSString *)keywords sId:(NSString *)sId sname:(NSString *)sname cId:(NSString *)cId cname:(NSString *)cname regionId:(NSString *)regionId regionType:(NSInteger)type dateStr:(NSString *)dateStr dateType:(NSInteger)dateType pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    parserType_ = GetXjh_XMLParser;
    
    if( !keywords || [keywords isEqualToString:@""] )
    {
        keywords = [NSString stringWithFormat:@""];
    }
    
    if( !sId || sId == nil )
    {
        sId = @"";
    }
    
    if( !sname || sname == nil )
    {
        sname = @"";
    }
    
    if( !cId || cId == nil )
    {
        cId = @"";
    }
    
    if( !cname || cname == nil )
    {
        cname = @"";
    }
    
    if( !regionId || [regionId isEqualToString:@""] )
    {
        regionId = [NSString stringWithFormat:@""];
    }
    
    if( !dateStr || dateStr == nil )
    {
        dateStr = @"";
    }
    
    keywords = [PreCommon converStringToXMLSoapString:keywords];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCurrentXjh xmlns=\"http://api.job1001.com\">\n"
                             "<keywords>%@</keywords>"
                             "<sId>%@</sId>"
                             "<sname>%@</sname>"
                             "<cId>%@</cId>"
                             "<cname>%@</cname>"
                             "<regionId>%@</regionId>"
                             "<regionType>%ld</regionType>"
                             "<pageIndex>%ld</pageIndex>"
                             "<pageSize>%ld</pageSize>"
                             "<deviceId>%@</deviceId>"
                             "<date>%@</date>"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">searchDateType</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             "</getCurrentXjh>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keywords,sId,sname,cId,cname,regionId,(long)type,(long)pageIndex,(long)pageSize,[PreCommon getDeviceID],dateStr,(long)dateType];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Xjh];
}

//获取招聘会信息
-(void) getZph:(NSString *)keywords sId:(NSString *)sId sname:(NSString *)sname regionId:(NSString *)regionId regionType:(NSInteger)type dateStr:(NSString *)dateStr dateType:(NSInteger)dateType pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    parserType_ = GetZph_XMLParser;
    
    if( !keywords || [keywords isEqualToString:@""] )
    {
        keywords = [NSString stringWithFormat:@""];
    }
    
    if( !regionId || [regionId isEqualToString:@""] )
    {
        regionId = [NSString stringWithFormat:@""];
    }
    
    if( !sId || sId == nil )
    {
        sId = @"";
    }
    
    if( !sname || sname == nil )
    {
        sname = @"";
    }
    
    if( !dateStr || dateStr == nil )
    {
        dateStr = @"";
    }
    
    keywords = [PreCommon converStringToXMLSoapString:keywords];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCurrentZph xmlns=\"http://api.job1001.com\">\n"
                             "<keywords>%@</keywords>"
                             "<sId>%@</sId>"
                             "<sname>%@</sname>"
                             "<regionId>%@</regionId>"
                             "<regionType>%ld</regionType>"
                             "<pageIndex>%ld</pageIndex>"
                             "<pageSize>%ld</pageSize>"
                             "<deviceId>%@</deviceId>"
                             "<date>%@</date>"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">searchDateType</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             "</getCurrentZph>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keywords,sId,sname,regionId,(long)type,(long)pageIndex,(long)pageSize,[PreCommon getDeviceID],dateStr,(long)dateType];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Zph];
}

//获取职业的力量列表(新接口)
-(void) loadProfessPowerList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = ProfessionPower_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getListContainNextInfo xmlns=\"http://www.job1001.com\">\n"
                             
                             "<pageSize>%ld</pageSize>"
                             "<pageIndex>%ld</pageIndex>"
                             
                             "</getListContainNextInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_WorkStart_QiKan];
}

//加载职业指导/职场风雨/面试指南...
-(void) loadProfessInfo:(NSInteger)infoType pageIndex:(NSInteger)pageIndex
{
    switch ( infoType ) {
        case ProfessInfo_ZhiDao:
            parserType_ = GetProfessInfo_ZhiDao_XMLParser;
            break;
        case ProfessInfo_FengYu:
            parserType_ = GetProfessInfo_FengYu_XMLParser;
            break;
        case ProfessInfo_JinRang:
            parserType_ = GetProfessInfo_JinRan_XMLParser;
            break;
        case ProfessInfo_ZhiZuo:
            parserType_ = GetProfessInfo_ZhiZuo_XMLParser;
            break;
        case ProfessInfo_ZhiNan:
            parserType_ = GetProfessInfo_ZhiNan_XMLParser;
            break;
        default:
            break;
    }
    
    
    NSString *whereStr = [[[NSString alloc] initWithFormat:@" and boardId='%ld' and ifshow=1 and isShowIndex=1",(long)infoType] autorelease];
    NSString *orderbyStr = [[[NSString alloc] initWithFormat:@" order by Addtime desc"] autorelease];
    NSString *groupbyStr = [[[NSString alloc] initWithFormat:@""] autorelease];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getList xmlns=\"http://www.job1001.com\">\n"
                             "<action>%@</action>"
                             "<where>%@</where>"
                             "<page_size>%d</page_size>"
                             "<orderbystr>%@</orderbystr>"
                             "<groupby>%@</groupby>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">fields</key>"
                             "<value xsi:type=\"xsd:string\">id,Title,Addtime</value>"
                             "</item>"
                             "</item>"
                             
                             "<page>%ld</page>"
                             
                             "</getList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",@"pageList",whereStr,Article_PageSize,orderbyStr,groupbyStr,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Article];
}

//获取文章列表(2职业指导,3职场风雨 ,4简历制作,5求职锦囊,6面试指南)
-(void) getArticleList:(NSInteger)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetArticleList_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getListContainNextInfo xmlns=\"http://www.job1001.com\">\n"
                             
                             "<type>%ld</type>"
                             "<pageSize>%ld</pageSize>"
                             "<pageIndex>%ld</pageIndex>"
                             
                             "</getListContainNextInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",(long)type,(long)pageSize,(long)pageIndex];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Article];
}


//获取文章详情
-(void) getArticleDetail:(NSString *)keyId
{
    parserType_ = GetArticleDetail_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getArticleDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<keyId>%@</keyId>"
                             
                             "</getArticleDetail>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Article];
}

//加载职业的力量详情
-(void) loadProfessPowerDetail:(NSString *)newsId
{
    parserType_ = ProfessionPower_Detail_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getArticleDetail xmlns=\"http://www.job1001.com\">\n"
                             "<keyId>%@</keyId>"
                             "</getArticleDetail>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",newsId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_WorkStart_QiKan];
}

//加载职业的力量详情上一篇
-(void) loadPreProfessPowerDetail:(NSString *)keyId
{
    parserType_ = PreProfessionPower_Detail_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getPreArticleInfo xmlns=\"http://www.job1001.com\">\n"
                             "<keyId>%@</keyId>"
                             "</getPreArticleInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_WorkStart_QiKan];
}

//加载职业的力量详情上一篇
-(void) loadNextProfessPowerDetail:(NSString *)keyId
{
    parserType_ = NextProfessionPower_Detail_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getNextArticleInfo xmlns=\"http://www.job1001.com\">\n"
                             "<keyId>%@</keyId>"
                             "</getNextArticleInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_WorkStart_QiKan];
}

//加载职业指导/职场风雨/面试指南...详情
-(void) loadProfessDetailInfo:(NSInteger)infoType newId:(NSString *)newId
{
    parserType_ = GetProfessDetailInfo_XMLParser;
    
    NSString *whereStr = [[[NSString alloc] initWithFormat:@" and boardId=%ld and id=%@",(long)infoType,newId] autorelease];
    NSString *orderbyStr = [[[NSString alloc] initWithFormat:@" order by Addtime desc"] autorelease];
    NSString *groupbyStr = [[[NSString alloc] initWithFormat:@""] autorelease];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getList xmlns=\"http://www.job1001.com\">\n"
                             "<action>%@</action>"
                             "<where>%@</where>"
                             "<page_size>%d</page_size>"
                             "<orderbystr>%@</orderbystr>"
                             "<groupby>%@</groupby>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">fields</key>"
                             "<value xsi:type=\"xsd:string\">Content</value>"
                             "</item>"
                             "</item>"
                             
                             "<page>%d</page>"
                             
                             "</getList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",@"pageList",whereStr,1,orderbyStr,groupbyStr,0];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Article];
    
}

//加载上一篇
-(void) loadPreProfessDetailInfo:(NSString *)keyId
{
    parserType_ = GetPreProfessDetailInfo_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getPreArticleInfo xmlns=\"http://www.job1001.com\">\n"
                             "<keyId>%@</keyId>"
                             "</getPreArticleInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Article];
}

//加载下一篇
-(void) loadNextProfessDetailInfo:(NSString *)keyId
{
    parserType_ = GetNextProfessDetailInfo_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getNextArticleInfo xmlns=\"http://www.job1001.com\">\n"
                             "<keyId>%@</keyId>"
                             "</getNextArticleInfo>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Article];
}

//加载职位详情
-(void) getZWDetail:(NSString *)zwId companyId:(NSString *)companyId
{
    parserType_ = SearchZW_Detail_XMLParser;
    
	NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@=%@&%@=%@",JobSearch_JobDetailURL,JobSearch_ComapnyDetailURL_CompanyParam,companyId,JobSearch_JobDetailURL_JobParam,zwId] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//申请职位
-(void) applyZW:(NSString *)zwId companyId:(NSString *)companyId
{
    parserType_ = ZW_Apply_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@&%@%@&%@%@",JobSearch_ApplyJob_URL,
                             JobSearch_ApplyJob_CompanyDetail_Param,companyId,
                             JobSearch_ApplyJob_ZhaoPinDetail_Param,zwId,
                             //JobSearch_ApplyJob_JobName_Param,[PreCommon convertStringToURLString:zwName],
                             JobSearch_ApplyJob_MyID_Param,personID,
                             JobSearch_ApplyJob_Enkey_Param,newMD5,
                             JobSearch_ApplyJob_Prnd_Param,prnd
                             ] autorelease];

    [self connectBySoapMsg:connectURL tableName:nil];
}

//收藏职位
-(void) favZW:(NSString *)zwId companyId:(NSString *)companyId
{
    parserType_ = ZW_Fav_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@&%@%@&%@%@",JobSearch_FavJob_URL,
                             JobSearch_ApplyJob_CompanyDetail_Param,companyId,
                             JobSearch_FavJob_ZhaoPinDetail_Param,zwId,
                             JobSearch_FavJob_MyID_Param,personID,
                             JobSearch_FavJob_Enkey_Param,newMD5,
                             JobSearch_FavJob_Prnd_Param,prnd
                             ] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//加载企业详情
-(void) getCompanyDetail:(NSString *)companyId
{
    parserType_ = GetCompanyDetail_XMLParser;
    
    if( !companyId || companyId == nil )
    {
        companyId = @"";
    }
    
    NSString *whereStr = [[[NSString alloc] initWithFormat:@" id='%@'",companyId] autorelease];
    NSString *filedStr = [[[NSString alloc] initWithFormat:@" id,email,cname,cxz,yuangong,phone,fax,address,regionid,classid,trade,jianj"] autorelease];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<select xmlns=\"http://www.job1001.com\">\n"
                             "<where>%@</where>"
                             "<selectStr>%@</selectStr>"
                             "</select>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",whereStr,filedStr];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Company];
}

//搜索职位
//搜索职位(uid:即companyId)
-(NSString *) searchJob:(NSString *)keywords regionId:(NSString *)regionId zwId:(NSString*)zwId zwStr:(NSString *)zwStr tradeId:(NSString *)tradeId bParent:(BOOL)bParent dateId:(NSString *)dateId majorId:(NSString *)majorId jobtypeId:(NSString *)jobTypeId keyType:(NSInteger)keyType bCampusSearch:(BOOL)flag uid:(NSString *)uid showMode:(NSString *)showMode pageIndex:(NSInteger)pageIndex
{
    parserType_ = SearchResult_XMLParser;
    
    if( !keywords || keywords == nil )
    {
        keywords = @"";
    }
    if( !regionId || regionId == nil || [regionId isEqualToString:@"0"] )
    {
        regionId = @"";
    }
    if( !zwId || zwId == nil || [zwId isEqualToString:@"0"] )
    {
        zwId = @"";
    }
    if( !tradeId || tradeId == nil || [tradeId isEqualToString:@""] )
    {
        tradeId = @"";
    }
    if( !dateId || dateId == nil )
    {
        dateId = @"";
    }
    if( !uid || uid == nil )
    {
        uid = @"";
    }
    if( !jobTypeId || jobTypeId == nil )
    {
        jobTypeId = @"";
    }
    if( !majorId || majorId == nil )
    {
        majorId = @"";
    }
    if( !showMode || showMode == nil )
    {
        showMode = @"showwap";
    }
    
    //如果存在uid，即搜索公司相关职位
    if( uid && uid != nil && ![uid isEqualToString:@""] )
    {        
        [self getMapCompanyZW:flag uid:uid keywords:keywords keyType:keyType majorId:majorId totalId:nil tradeId:tradeId pageSize:25 pageIndex:pageIndex];
        
        return nil;
    }
    
    //判断职位id是不是parentId
    BOOL bParentZW = [CondictionZWCtl checkIsParentZW:zwId];
    
    NSString *zwParamStr;
    if( !bParentZW )
    {
        zwParamStr = @"czwid";
    }else
        zwParamStr = @"zwid";
    
    //对输入的关键字还要进行转码
    NSString *tempKeywords = [PreCommon convertStringToURLString:keywords];
    jobTypeId = [PreCommon convertStringToURLString:jobTypeId];
    
    //返回不包含分页的url,用于存放在历史记录中
    NSString *returnURL;
    NSString *strUrl;
    
    //如果是校招
    if( flag )
    {
        if( tradeId && ![tradeId isEqualToString:@""] && bParent )
        {
            strUrl = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&rctypes=0&udata=%@&totalid=%@&tradeid=%@&level=1&page=%ld&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,tradeId,tradeId,(long)pageIndex,jobTypeId] autorelease];
            
            returnURL = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&rctypes=0&udata=%@&totalid=%@&tradeid=%@&level=1&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,tradeId,tradeId,jobTypeId] autorelease];
        }else if( tradeId && ![tradeId isEqualToString:@""] && !bParent )
        {
            strUrl = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&rctypes=0&udata=%@&totalid=%@&tradeid=%@&level=2&page=%ld&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,[CondictionTradeCtl getTradePId:tradeId],tradeId,(long)pageIndex,jobTypeId] autorelease];
            
            returnURL = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&rctypes=0&udata=%@&totalid=%@&tradeid=%@&level=2&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,[CondictionTradeCtl getTradePId:tradeId],tradeId,jobTypeId] autorelease];
        }else
        {
            strUrl = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&rctypes=0&udata=%@&page=%ld&jobtypes11=%@&zyid=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,(long)pageIndex,jobTypeId,majorId] autorelease];
            
            returnURL = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&rctypes=0&udata=%@&jobtypes11=%@&zyid=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,jobTypeId,majorId] autorelease];
        }
        
        
    }else
    {
        if( tradeId && ![tradeId isEqualToString:@""] && bParent )
        {
            strUrl = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&udata=%@&totalid=%@&tradeid=%@&level=1&page=%ld&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,tradeId,tradeId,(long)pageIndex,jobTypeId] autorelease];
            
            returnURL = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&udata=%@&totalid=%@&tradeid=%@&level=1&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,tradeId,tradeId,jobTypeId] autorelease];
        }else if( tradeId && ![tradeId isEqualToString:@""] && !bParent )
        {
            strUrl = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&udata=%@&totalid=%@&tradeid=%@&level=2&page=%ld&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,[CondictionTradeCtl getTradePId:tradeId],tradeId,(long)pageIndex,jobTypeId] autorelease];
            
            returnURL = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&udata=%@&totalid=%@&tradeid=%@&level=2&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,[CondictionTradeCtl getTradePId:tradeId],tradeId,jobTypeId] autorelease];
        }else
        {
            strUrl = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&uid=%@&%@=%@&udata=%@&page=%ld&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,uid,zwParamStr,zwId,dateId,(long)pageIndex,jobTypeId] autorelease];
            
            returnURL = [[[NSString alloc] initWithFormat:@"%@%@&regionid=%@&keytypes=%ld&seakeywords=%@&%@=%@&udata=%@&jobtypes11=%@",JobSearchBaseURL,showMode,regionId,(long)keyType,tempKeywords,zwParamStr,zwId,dateId,jobTypeId] autorelease];
        }
    }
    
    [self connectBySoapMsg:strUrl tableName:nil];
    
    return returnURL;
}

//由url来搜索(从历史搜索条件来搜索)
-(void) searchByHitory:(NSString *)url pageIndex:(NSInteger)pageIndex
{
    parserType_ = SearchResult_XMLParser;
    
    NSString *searchURL = [NSString stringWithFormat:@"%@&page=%ld",url,(long)pageIndex];
    
    [self connectBySoapMsg:searchURL tableName:nil];
}

//搜索身边招聘企业
-(NSString *) searchMapCompany:(NSInteger)bCampusSearch keywords:(NSString *)keywords keyType:(NSInteger)keyType majorId:(NSString *)majorId totalId:(NSString *)totalId tradeId:(NSString *)tradeId lng:(double)lng lat:(double)lat rang:(NSString *)rang  pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetMapCompany_XMLParser;
    
    if( !keywords || keywords == nil )
    {
        keywords = @"";
    }
    if( !majorId || majorId == nil )
    {
        majorId = @"";
    }
    if( !totalId || totalId == nil )
    {
        totalId = @"";
    }
    if( !tradeId || tradeId == nil )
    {
        tradeId = @"";
    }
    if( !rang || rang == nil )
    {
        rang = @"";
    }
    
    keywords = [PreCommon converStringToXMLSoapString:keywords];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<searchMapCompany xmlns=\"http://www.job1001.com\">\n"
                             
                             "<searchType>%ld</searchType>"
                             "<keywords>%@</keywords>"
                             "<keyType>%ld</keyType>"
                             "<majorId>%@</majorId>"
                             "<totalId>%@</totalId>"
                             "<tradeId>%@</tradeId>"
                             "<lng>%f</lng>"
                             "<lat>%f</lat>"
                             "<rang>%@</rang>"
                             "<pageIndex>%ld</pageIndex>"
                             "<pageSize>%ld</pageSize>"
                             
                             "</searchMapCompany>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",(long)bCampusSearch,keywords,(long)keyType,majorId,totalId,tradeId,lng,lat,rang,(long)pageIndex,(long)pageSize];
    
    //不包含pageIndex与pageSize
    NSString *returnMsg = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                           "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                           "<soap:Body>\n"
                           "<searchMapCompany xmlns=\"http://www.job1001.com\">\n"
                           
                           "<searchType>%ld</searchType>"
                           "<keywords>%@</keywords>"
                           "<keyType>%ld</keyType>"
                           "<majorId>%@</majorId>"
                           "<totalId>%@</totalId>"
                           "<tradeId>%@</tradeId>"
                           "rang=%@"
                           ,(long)bCampusSearch,keywords,(long)keyType,majorId,totalId,tradeId,rang];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_MapCompany];
    
    return returnMsg;
}

//从历史记录中搜索身边招聘企业
-(void) searchMapCompanyByHis:(NSString *)partSoapMsg lng:(double)lng lat:(double)lat pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetMapCompany_XMLParser;
    
    //通过partSoapMsg找到rang
    NSMutableString *tempMsg = [NSMutableString stringWithString:partSoapMsg];
    NSArray *arr = [tempMsg componentsSeparatedByString:@"rang="];
    
    NSString *partMsg;
    NSString *rang;
    
    @try {
        partMsg = [arr objectAtIndex:0];
    }
    @catch (NSException *exception) {
        partMsg = @"";
    }
    @finally {
        
    }
    
    @try {
        rang = [arr objectAtIndex:1];
    }
    @catch (NSException *exception) {
        rang = @"";
    }
    @finally {
        
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<lng>%f</lng>"
                             "<lat>%f</lat>"
                             "<rang>%@</rang>"
                             "<pageIndex>%ld</pageIndex>"
                             "<pageSize>%ld</pageSize>"
                             
                             "</searchMapCompany>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,partMsg,lng,lat,rang,(long)pageIndex,(long)pageSize];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_MapCompany];
}

//身边招聘企业职位(新接口)
-(void) getMapCompanyZW:(NSInteger)bCampusSearch uid:(NSString *)uid keywords:(NSString *)keywords keyType:(NSInteger)keyType majorId:(NSString *)majorId totalId:(NSString *)totalId tradeId:(NSString *)tradeId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetMapCompanhyZW_XMLParser;
    
    NSString *searchType = @"";
    if( bCampusSearch ){
        searchType = @"1";
    }
    
    keywords = [PreCommon converStringToXMLSoapString:keywords];
    
    if( !keywords || keywords == nil ){
        keywords = @"";
    }
    if( !uid || uid == nil ){
        uid = @"";
    }
    if( !majorId || majorId == nil ){
        majorId = @"";
    }
    if( !totalId || totalId == nil ){
        totalId = @"";
    }
    if( !tradeId || tradeId == nil ){
        tradeId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCompanyZW xmlns=\"http://www.job1001.com\">\n"
                             "<uid>%@</uid>"
                             "<searchType>%@</searchType>"
                             "<keywords>%@</keywords>"
                             "<keyType>%ld</keyType>"
                             "<majorId>%@</majorId>"
                             "<totalId>%@</totalId>"
                             "<tradeId>%@</tradeId>"
                             "<pageIndex>%ld</pageIndex>"
                             "<pageSize>%ld</pageSize>"
                             "</getCompanyZW>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",uid,searchType,keywords,(long)keyType,majorId,totalId,tradeId,(long)pageIndex,(long)pageSize];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_MapCompany];
}

//加载企业简介
-(void) getCompanyDes:(NSString *)companyId
{
    parserType_ = GetCompanyDes_XMLParser;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@=%@",JobSearch_CompanyDetailURL,JobSearch_ComapnyDetailURL_CompanyParam,companyId] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//加载企业其它职位
-(void) getCompanyOtherZW:(NSString *)companyId
{
    parserType_ = CompanyOther_ZW_XMLParser;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@=%@",JobSearch_CompanyJobDetailURL,JobSearch_CompanyJobDetailUR_JobParam,companyId] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//获取测试项目题
-(void) getProgramQuestion:(NSString *)userId paramId:(NSString *)programId questionId:(NSString *)questionId answer:(NSString *)answer bReset:(BOOL)bReset
{
    parserType_ = ProgramQuestion_XMLParser;
    
    if( !userId || userId == nil )
    {
        userId = @"";
    }
    
    if( !programId || programId == nil )
    {
        programId = @"";
    }
    
    if( !questionId || questionId == nil )
    {
        questionId = @"";
    }
    
    if( !answer || answer == nil )
    {
        answer = @"";
    }
    
    NSString *reset = @"false";
    if( bReset )
    {
        reset = @"true";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getAndAddAnswer xmlns=\"http://www.job1001.com\">\n"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">tid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">uid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">qid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">detail</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">reset</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             "</getAndAddAnswer>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",programId,userId,questionId,programId,answer,reset];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_ProgramQuestion];
}

//获取测试答案
-(void) getTestResult:(NSString *)userId paramId:(NSString *)programId
{
    parserType_ = TestResult_XMLParser;
    
    if( !userId || userId == nil )
    {
        userId = @"";
    }
    
    if( !programId || programId == nil )
    {
        programId = @"";
    }
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCpResultAll xmlns=\"http://www.job1001.com\">\n"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">tid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">uid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             "</getCpResultAll>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",programId,userId];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_ProgramQuestion];
}

//获取测试项目
-(void) getTestProgram:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = TestProgram_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getMobProgram xmlns=\"http://www.job1001.com\">\n"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             "</getMobProgram>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",(long)pageIndex,(long)pageSize];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_TestProgram];
}

//换大米
-(void) getMoneyRice:(NSString *)regionId money:(NSString *)money
{
    parserType_ = RiceMoney_XMLParser;
    
    if( !regionId || regionId == nil )
    {
        regionId = @"";
    }
    
    if( !money || money == nil )
    {
        money = @"";
    }
    
    money = [PreCommon converStringToXMLSoapString:money];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getChangeObject xmlns=\"http://www.job1001.com\">\n"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">regionid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">money</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             "</item>"
                             "</getChangeObject>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",regionId,[money intValue]];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_RiceMoney];
}

//薪酬查询
-(void) loadSalary:(NSString *)zwParentId zwParentStr:(NSString *)zwParentStr zwSubId:(NSString *)zwSubId zwSubStr:(NSString *)zwSubStr regionParentId:(NSString *)regionParentId regionSubId:(NSString *)regionSubId eduId:(NSString *)eduId gzNum:(NSString *)gzNum currentSalary:(NSString *)currentSalary
{
    parserType_ = GetSalary_XMLParser;
    
    if( zwParentId == nil || !zwParentId )
    {
        zwParentId      = @"";
    }
    if( zwParentStr == nil || !zwParentStr )
    {
        zwParentStr     = @"";
    }
    if( zwSubId == nil || !zwSubId )
    {
        zwSubId         = @"";
    }
    if( zwSubStr == nil || !zwSubStr )
    {
        zwSubStr     = @"";
    }
    if( regionParentId == nil || !regionParentId )
    {
        regionParentId  = @"";
    }
    if( regionSubId == nil || !regionSubId )
    {
        regionSubId     = @"";
    }
    if( eduId == nil || !eduId )
    {
        eduId           = @"";
    }
    if( gzNum == nil || !gzNum )
    {
        gzNum           = @"";
    }
    if( currentSalary == nil || !currentSalary )
    {
        currentSalary   = @"";
    }
    
    zwParentStr = [PreCommon convertStringToURLString:zwParentStr];
    zwSubStr    = [PreCommon convertStringToURLString:zwSubStr];
    
    NSString *url = [[[NSString alloc] initWithFormat:@"%@&%@%@--%@&%@%@--%@&%@%@&%@%@&%@%@&%@%@",SalaryQuary_URL,SalaryQuary_Param_ZW_ParentId,zwParentId,zwParentStr,SalaryQuary_Param_ZW_SubId,zwSubId,zwSubStr,SalaryQuary_Param_ShengId,regionParentId,SalaryQuary_Param_ShiId,regionSubId,SalaryQuary_Param_EduId,eduId,SalaryQuary_Param_YearId,gzNum/*,SalaryQuary_Param_CurrentSalary,@"1000"*/] autorelease];
    
    [self connectBySoapMsg:url tableName:nil];
}

//获取某地区的学校
-(void) getSchoolList:(NSString *)regionId regionType:(NSInteger)regionType bAttentionAtt:(BOOL)flag
{
    parserType_ = GetSchoolList_XMLParser;
    
    if( !regionId || [regionId isEqualToString:@""] )
    {
        regionId = [NSString stringWithFormat:@""];
    }
    
    NSString *userId = @"";
    if( flag ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getListByRegionId xmlns=\"http://api.job1001.com\">\n"
                             "<regionId>%@</regionId>"
                             "<regionType>%ld</regionType>"
                             "<userId>%@</userId>"
                             "</getListByRegionId>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",regionId,(long)regionType,userId];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_School];
}

//加载人才市场
-(void) loadTalentMarket:(NSString *)regionStr key:(NSString *)key
{
    parserType_ = GetTalentMarket_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getQuery xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">query</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">region</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getQuery>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",@"人才市场",regionStr];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_MapApi];
}

//新增一条订阅
-(void) addSubscribe:(NSString *)sId sname:(NSString *)sname cId:(NSString *)cId cname:(NSString *)cname regionId:(NSString *)regionId subscribeType:(NSInteger)subscribeType
{
    parserType_ = AddSubscribe_XMLParser;
    
    sname = [PreCommon converStringToXMLSoapString:sname];
    cname = [PreCommon converStringToXMLSoapString:cname];
    
    if( !sId || sId == nil )
    {
        sId = @"";
    }
    
    if( !sname || sname == nil )
    {
        sname = @"";
    }
    
    if( !cId || cId == nil )
    {
        cId = @"";
    }
    
    if( !cname || cname == nil )
    {
        cname = @"";
    }
    
    NSString *regionStr = @"";
    if( !regionId || regionId == nil )
    {
        regionId = @"";
    }else{
        regionStr = [CondictionPlaceCtl getRegionStr:regionId];
        
        if( !regionStr ){
            regionStr = @"";
        }
    }
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<addSubscribe xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<sId>%@</sId>"
                             "<sname>%@</sname>"
                             "<cId>%@</cId>"
                             "<cname>%@</cname>"
                             "<regionId>%@</regionId>"
                             "<regionStr>%@</regionStr>"
                             "<subscribeType>%ld</subscribeType>"
                             
                             "</addSubscribe>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             loginDataModal.personId_,
                             sId,
                             sname,
                             cId,
                             cname,
                             regionId,
                             regionStr,
                             (long)subscribeType
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Xjh];
}

//获取宣讲会详情
-(void) getXjhDetail:(NSString *)xjhId
{
    parserType_ = GetXjhDetail_XMLParser;
    
    if( !xjhId || xjhId == nil )
    {
        xjhId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getXjhDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getXjhDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             xjhId
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Xjh];
}

//参与宣讲会/招聘会
-(void) addParticipate:(NSString *)deviceId xjhId:(NSString *)xjhId zphId:(NSString *)zphId clientName:(NSString *)clientName
{
    parserType_ = AddParticipate_XMLParser;
    
    if( !deviceId || deviceId == nil ){
        deviceId = @"";
    }
    if( !xjhId || xjhId == nil ){
        xjhId = @"";
    }
    if( !zphId || zphId == nil ){
        zphId = @"";
    }
    if( !clientName || clientName == nil ){
        clientName = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<addParticipate xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">deviceId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">xjhId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">zphId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</addParticipate>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",deviceId,xjhId,zphId,clientName];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Participate];
}

//刷新参与人数
-(void) refreshAddCnt:(NSString *)deviceId xjhId:(NSString *)xjhId zphId:(NSString *)zphId
{
    parserType_ = RefreshAddCnt_XMLParser;
    
    if( !deviceId || deviceId == nil ){
        deviceId = @"";
    }
    if( !xjhId || xjhId == nil ){
        xjhId = @"";
    }
    if( !zphId || zphId == nil ){
        zphId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCnt xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">xjhId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">zphId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</getCnt>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",xjhId,zphId];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Participate];
}

//获取招聘会详情
-(void) getZphDetail:(NSString *)zphId
{
    
    parserType_ = GetZphDetail_XMLParser;
    
    if( !zphId || zphId == nil )
    {
        zphId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getZphDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getZphDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             zphId
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Zph];
}

//增加评论/回复
-(void) addMyComment:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName content:(NSString *)content pId:(NSString *)pId
{
    parserType_ = AddBBS_XMLParser;
    
    if( !projectIndity || projectIndity == nil ){
        projectIndity = @"";
    }
    if( !objId || objId == nil ){
        objId = @"";
    }
    if( !objName || objName == nil ){
        objName = @"";
    }
    if( !content || content == nil ){
        content = @"";
    }
    if( !pId || pId == nil ){
        pId = @"";
    }
    
    objName = [PreCommon converStringToXMLSoapString:objName];
    content = [PreCommon converStringToXMLSoapString:content];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<addBbs xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">project_flag</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_name</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">own_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">own_name</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">content</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">hf_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">source</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</addBbs>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",projectIndity,objId,objName,loginDataModal.personId_,loginDataModal.uname_,content,pId,Client_Name];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Comment_New];
}

//增加评论/回复(职业的力量)
-(void) addProfessComment:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName content:(NSString *)content pId:(NSString *)pId
{
    parserType_ = AddBBS_XMLParser;
    
    if( !projectIndity || projectIndity == nil ){
        projectIndity = @"";
    }
    if( !objId || objId == nil ){
        objId = @"";
    }
    if( !objName || objName == nil ){
        objName = @"";
    }
    if( !content || content == nil ){
        content = @"";
    }
    if( !pId || pId == nil ){
        pId = @"";
    }
    
    objName = [PreCommon converStringToXMLSoapString:objName];
    content = [PreCommon converStringToXMLSoapString:content];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<insertConmment xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">project_flag</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_name</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">own_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">own_name</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">content</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">hf_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">source</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</insertConmment>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",projectIndity,objId,objName,loginDataModal.personId_,loginDataModal.uname_,content,pId,Client_Name];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_ProfessComment];
}

//增加企业回复
-(void) addCompanyReply:(NSString *)commentId personId:(NSString *)personId desc:(NSString *)desc
{
    parserType_ = AddCompanyReply_XMLParser;
    
    if( !commentId || commentId == nil ){
        commentId = @"";
    }
    if( !personId || personId == nil ){
        personId = @"";
    }
    if( !desc || desc == nil ){
        desc = @"";
    }
    
    desc = [PreCommon converStringToXMLSoapString:desc];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<addReply xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">commentId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">source</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">desc</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</addReply>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",commentId,Client_Name,personId,desc];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_CompanyComment];
}

//获取评论列表
-(void) getMyCommentList:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName pId:(NSString *)pId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetMyCommmentList_XMLParser;
    
    if( !projectIndity || projectIndity == nil ){
        projectIndity = @"";
    }
    if( !objId || objId == nil ){
        objId = @"";
    }
    if( !objName || objName == nil ){
        objName = @"";
    }
    if( !pId || pId == nil ){
        pId = @"";
    }
    
    objName = [PreCommon converStringToXMLSoapString:objName];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCommList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">project_flag</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_name</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bMobile</key>"
                             "<value xsi:type=\"xsd:string\">1</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_hf_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">action</key>"
                             "<value xsi:type=\"xsd:string\">pageList</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">page_size</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">page_index</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</getCommList>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",projectIndity,objId,objName,pId,(long)pageSize,(long)pageIndex];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Comment_New];
}

//获取评论/回复列表(职业的力量)
-(void) getProfessCommentList:(NSString *)projectIndity objId:(NSString *)objId objName:(NSString *)objName pId:(NSString *)pId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetMyCommmentList_XMLParser;
    
    if( !projectIndity || projectIndity == nil ){
        projectIndity = @"";
    }
    if( !objId || objId == nil ){
        objId = @"";
    }
    if( !objName || objName == nil ){
        objName = @"";
    }
    if( !pId || pId == nil ){
        pId = @"";
    }
    
    objName = [PreCommon converStringToXMLSoapString:objName];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCommentAll xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">project_flag</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_object_name</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bMobile</key>"
                             "<value xsi:type=\"xsd:string\">1</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">bbs_hf_id</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">action</key>"
                             "<value xsi:type=\"xsd:string\">pageList</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">page_size</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">page_index</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</getCommentAll>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",projectIndity,objId,objName,pId,(long)pageSize,(long)pageIndex];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_ProfessComment];
}

//顶一下评论
-(void) addCommentAgree:(NSString *)projectIndity keyId:(NSString *)keyId
{
    parserType_ = AddAgree_XMLParser;
    
    if( !projectIndity || projectIndity == nil ){
        projectIndity = @"";
    }
    if( !keyId || keyId == nil ){
        keyId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<updateZan xmlns=\"http://www.job1001.com\">\n"
                             
                             "<bbs_id>%@</bbs_id>"
                             "<project_flag>%@</project_flag>"
                             
                             "</updateZan>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId,projectIndity];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Comment_New];
}

//顶一下评论(职业的力量)
-(void) addProfessCommentAgree:(NSString *)projectIndity keyId:(NSString *)keyId
{
    parserType_ = AddAgree_XMLParser;
    
    if( !projectIndity || projectIndity == nil ){
        projectIndity = @"";
    }
    if( !keyId || keyId == nil ){
        keyId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<updateZan xmlns=\"http://www.job1001.com\">\n"
                             
                             "<bbs_id>%@</bbs_id>"
                             "<project_flag>%@</project_flag>"
                             
                             "</updateZan>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",keyId,projectIndity];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_ProfessComment];
}

//获取企业回复列表
-(void) getCompanyReplyList:(NSString *)commentId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetCompanyReplyList_XMLParser;
    
    if( !commentId || commentId == nil ){
        commentId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getReplyList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">commentId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</getReplyList>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",commentId,(long)pageSize,(long)pageIndex];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_CompanyComment];
}

//给企业评论
-(void) addCompanyComment:(NSString *)companyId point:(NSInteger)point title:(NSString *)title good:(NSString *)good bad:(NSString *)bad
{
    parserType_ = AddCompanyComment_XMLParser;
    
    if( !companyId || companyId == nil ){
        companyId = @"";
    }
    if( !title || title == nil ){
        title = @"";
    }
    if( !good || good == nil ){
        good = @"";
    }
    if( !bad || bad == nil ){
        bad = @"";
    }
    
    title = [PreCommon converStringToXMLSoapString:title];
    good = [PreCommon converStringToXMLSoapString:good];
    bad = [PreCommon converStringToXMLSoapString:bad];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<addComment xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">companyId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">title</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">advantageDesc</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">defectDesc</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">point</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</addComment>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",companyId,title,good,bad,(long)point,loginDataModal.personId_];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_CompanyComment];
}

//获取企业评论列表
-(void) getCompanyCommentList:(NSString *)companyId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetCompanyCommentList_XMLParser;
    
    if( !companyId || companyId == nil ){
        companyId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getCommentList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">companyId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</getCommentList>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",companyId,(long)pageSize,(long)pageIndex];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_CompanyComment];
}

//获取最近浏览历史
-(void) getHistoryList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
//    parserType_ = GetLookHistory_XMLParser;
//    
//    //直接从本地数据库中读取即可
//    if( loginDataModal.loginState_ == LoginOK )
//    {
//        NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
//        int sums    = 0;
//        int pages   = 0;
//        //1.先获取分页信息
//        {
//            NSString *whereStr = [NSString stringWithFormat:@"person_id='%@'",loginDataModal.personId_];
//            
//            //从数据库中去读
//            sqlite3_stmt *result = [db selectSQL:nil fileds:@"COUNT(person_id) as cnt" whereStr:whereStr limit:-1 tableName:DB_LookHistory_TableName];
//            
//            
//            while ( sqlite3_step(result) == SQLITE_ROW ) {
//                char *rowData_0 = (char *)sqlite3_column_text(result, 0);
//                
//                sums = atoi(rowData_0);
//                pages = sums / pageSize - ( sums % pageSize == 0 ? 1 : 0);
//            }
//            
//            sqlite3_finalize(result);
//        }
//        
//        //2.获取具体信息
//        {
//            NSString *whereStr = [NSString stringWithFormat:@"person_id='%@'",loginDataModal.personId_];
//            
//            //从数据库中去读
//            sqlite3_stmt *result = [db selectSQL:@"update_datetime desc" fileds:@"*" whereStr:whereStr pageIndex:pageIndex pageSize:pageSize tableName:DB_LookHistory_TableName];
//            
//            
//            while ( sqlite3_step(result) == SQLITE_ROW ) {
//                Event_DataModal *dataModal = [[[Event_DataModal alloc] init] autorelease];
//                dataModal.totalCnt_ = sums;
//                dataModal.pageCnt_ = pages;
//                
//                char *rowData_2 = (char *)sqlite3_column_text(result, 2);
//                char *rowData_3 = (char *)sqlite3_column_text(result, 3);
//                char *rowData_4 = (char *)sqlite3_column_text(result, 4);
//                char *rowData_5 = (char *)sqlite3_column_text(result, 5);
//                char *rowData_6 = (char *)sqlite3_column_text(result, 6);
//                char *rowData_7 = (char *)sqlite3_column_text(result, 7);
//                char *rowData_8 = (char *)sqlite3_column_text(result, 8);
//                char *rowData_9 = (char *)sqlite3_column_text(result, 9);
//                char *rowData_10 = (char *)sqlite3_column_text(result, 10);
//                char *rowData_11 = (char *)sqlite3_column_text(result, 11);
//                
//                dataModal.id_           = [[[NSString alloc] initWithCString:rowData_2 encoding:(NSUTF8StringEncoding)] autorelease];
//                dataModal.eventType_    = atoi(rowData_3);
//                if( rowData_4 && strcmp(rowData_4,"(null)") != 0 )
//                {
//                    dataModal.title_    = [[[NSString alloc] initWithCString:rowData_4 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_5 && strcmp(rowData_5,"(null)") != 0 )
//                {
//                    dataModal.sdate_    = [[[NSString alloc] initWithCString:rowData_5 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_6 && strcmp(rowData_6,"(null)") != 0 )
//                {
//                    dataModal.sname_    = [[[NSString alloc] initWithCString:rowData_6 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_7 && strcmp(rowData_7,"(null)") != 0 )
//                {
//                    dataModal.sid_      = [[[NSString alloc] initWithCString:rowData_7 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_8 && strcmp(rowData_8,"(null)") != 0 )
//                {
//                    dataModal.cname_    = [[[NSString alloc] initWithCString:rowData_8 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_9 && strcmp(rowData_9,"(null)") != 0 )
//                {
//                    dataModal.cid_      = [[[NSString alloc] initWithCString:rowData_9 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_10 && strcmp(rowData_10,"(null)") != 0 )
//                {
//                    dataModal.regionId_ = [[[NSString alloc] initWithCString:rowData_10 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                if( rowData_11 && strcmp(rowData_11,"(null)") != 0 )
//                {
//                    dataModal.addr_     = [[[NSString alloc] initWithCString:rowData_11 encoding:(NSUTF8StringEncoding)] autorelease];
//                }
//                
//                [arr addObject:dataModal];
//            }
//            
//            sqlite3_finalize(result);
//        }
//        
//        [delegate_ loadDataComplete:self code:Success dataArr:arr parserType:parserType_];
//    }
}

//获取我的关注
-(void) getMyAttentionList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
//    parserType_ = GetAttention_XMLParser;
//    //直接从本地数据库中读取即可
//    if( loginDataModal.loginState_ == LoginOK )
//    {
//        NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
//        NSMutableArray *eventIdArr = [[[NSMutableArray alloc] init] autorelease];
//        NSMutableArray *campusIdArr = [[[NSMutableArray alloc] init] autorelease];
//        NSMutableArray *eventTypeArr = [[[NSMutableArray alloc] init] autorelease];
//        
//        int sums    = 0;
//        int pages   = 0;
//        //1.先获取分页信息
//        {
//            //从数据库中去读
//            NSString *whereStr = [NSString stringWithFormat:@"person_id = '%@' and campus_id is not null and campus_id != ''",loginDataModal.personId_];
//            sqlite3_stmt *result = [db selectSQL:@"update_datetime desc" fileds:@"*" whereStr:whereStr limit:500 tableName:DB_Campus_Event];
//            
//            //查看事件是否存在
//            EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
//            
//            while ( sqlite3_step(result) == SQLITE_ROW ) {
//                char *rowData_0 = (char *)sqlite3_column_text(result, 0);
//                char *rowData_1 = (char *)sqlite3_column_text(result, 1);
//                char *rowData_3 = (char *)sqlite3_column_text(result, 3);
//                
//                NSString *eventId = [[[NSString alloc] initWithCString:rowData_0 encoding:(NSUTF8StringEncoding)] autorelease];
//                
//                EKEvent *eve = NULL;
//                eve = [eventStore eventWithIdentifier:eventId];
//                
//                //事件存在,即在日程中
//                if( eve )
//                {
//                    ++sums;
//                    
//                    
//                    NSString *campusId = [[[NSString alloc] initWithCString:rowData_1 encoding:(NSUTF8StringEncoding)] autorelease];
//                    NSString *eventType = [[[NSString alloc] initWithCString:rowData_3 encoding:(NSUTF8StringEncoding)] autorelease];
//                    [eventIdArr addObject:eventId];
//                    [campusIdArr addObject:campusId];
//                    [eventTypeArr addObject:eventType];
//                }
//            }
//            
//            pages = sums / pageSize - ( sums % pageSize == 0 ? 1 : 0);
//            sqlite3_finalize(result);
//        }
//        
//        //2.获取具体信息
//        {
//            @try {
//                for ( int i = pageIndex * pageSize ; i < pageSize + pageIndex * pageSize; ++i ) {
//                    NSString *whereStr = [NSString stringWithFormat:@"person_id='%@' and campus_id='%@' and event_type='%@'",loginDataModal.personId_,[campusIdArr objectAtIndex:i],[eventTypeArr objectAtIndex:i]];
//                    
//                    //从数据库中去读
//                    sqlite3_stmt *result = [db selectSQL:nil fileds:@"*" whereStr:whereStr limit:1 tableName:DB_LookHistory_TableName];
//                    
//                    while ( sqlite3_step(result) == SQLITE_ROW ) {
//                        Event_DataModal *dataModal = [[[Event_DataModal alloc] init] autorelease];
//                        dataModal.eventId_ = [eventIdArr objectAtIndex:i];
//                        dataModal.totalCnt_ = sums;
//                        dataModal.pageCnt_ = pages;
//                        
//                        char *rowData_2 = (char *)sqlite3_column_text(result, 2);
//                        char *rowData_3 = (char *)sqlite3_column_text(result, 3);
//                        char *rowData_4 = (char *)sqlite3_column_text(result, 4);
//                        char *rowData_5 = (char *)sqlite3_column_text(result, 5);
//                        char *rowData_6 = (char *)sqlite3_column_text(result, 6);
//                        char *rowData_7 = (char *)sqlite3_column_text(result, 7);
//                        char *rowData_8 = (char *)sqlite3_column_text(result, 8);
//                        char *rowData_9 = (char *)sqlite3_column_text(result, 9);
//                        char *rowData_10 = (char *)sqlite3_column_text(result, 10);
//                        char *rowData_11 = (char *)sqlite3_column_text(result, 11);
//                        
//                        dataModal.id_           = [[[NSString alloc] initWithCString:rowData_2 encoding:(NSUTF8StringEncoding)] autorelease];
//                        dataModal.eventType_    = atoi(rowData_3);
//                        if( rowData_4 && strcmp(rowData_4,"(null)") != 0 )
//                        {
//                            dataModal.title_    = [[[NSString alloc] initWithCString:rowData_4 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_5 && strcmp(rowData_5,"(null)") != 0 )
//                        {
//                            dataModal.sdate_    = [[[NSString alloc] initWithCString:rowData_5 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_6 && strcmp(rowData_6,"(null)") != 0 )
//                        {
//                            dataModal.sname_    = [[[NSString alloc] initWithCString:rowData_6 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_7 && strcmp(rowData_7,"(null)") != 0 )
//                        {
//                            dataModal.sid_      = [[[NSString alloc] initWithCString:rowData_7 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_8 && strcmp(rowData_8,"(null)") != 0 )
//                        {
//                            dataModal.cname_    = [[[NSString alloc] initWithCString:rowData_8 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_9 && strcmp(rowData_9,"(null)") != 0 )
//                        {
//                            dataModal.cid_      = [[[NSString alloc] initWithCString:rowData_9 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_10 && strcmp(rowData_10,"(null)") != 0 )
//                        {
//                            dataModal.regionId_ = [[[NSString alloc] initWithCString:rowData_10 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        if( rowData_11 && strcmp(rowData_11,"(null)") != 0 )
//                        {
//                            dataModal.addr_     = [[[NSString alloc] initWithCString:rowData_11 encoding:(NSUTF8StringEncoding)] autorelease];
//                        }
//                        
//                        [arr addObject:dataModal];
//                    }
//                    
//                    sqlite3_finalize(result);
//                }
//            }
//            @catch (NSException *exception) {
//                
//            }
//            @finally {
//                
//            }
//            
//        }
//        
//        [delegate_ loadDataComplete:self code:Success dataArr:arr parserType:parserType_];
//    }
}

//设置某条订阅已被看过
-(void) setSubscribeReadFlag:(NSString *)subscribeId
{
    parserType_ = SetSubscribeReadFlag_XMLParser;
    
    if( !subscribeId || subscribeId == nil ){
        subscribeId = @"";
    }
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<setSubscribeReadFlag xmlns=\"http://www.job1001.com\">\n"
                             
                             "<subscribeId>%@</subscribeId>"
                             
                             "</setSubscribeReadFlag>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             subscribeId
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Xjh];
}

//修改密码
-(void) resetPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd
{
    parserType_ = ReSetSercet_XMLParser;

    //调用新的修改密码接口
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<updatePassword xmlns=\"http://www.job1001.com\">\n"
                             "<person_id>%@</person_id>"
                             "<oldpassword>%@</oldpassword>"
                             "<newpassword>%@</newpassword>"
                             "</updatePassword>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             loginDataModal.personId_,oldPwd,newPwd
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonDeal];
}

//加载求职状态
-(void) loadResumeStatus
{
    parserType_ = GetResumeStatus_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getResumeStatus xmlns=\"http://www.job1001.com\">\n"
                             "<personId>%@</personId>"
                             "</getResumeStatus>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
        
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonSlave];
}

//更新求职状态
-(void) updateResumeGetJobStatus:(NSInteger)code
{
    parserType_ = UpdateResumeStatus_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<updateResumeStatus xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<status>%ld</status>"
                             
                             "</updateResumeStatus>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,(long)code];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonSlave];
}

//加载保密状态
-(void) loadResumeSercet
{
    parserType_ = GetResumeSercet_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getResumeSercet xmlns=\"http://www.job1001.com\">\n"
                             "<personId>%@</personId>"
                             "</getResumeSercet>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//更新保密设置
-(void) updateResumeSercetStatus:(NSInteger)code
{
    parserType_ = UpdateResumeSercet_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">update</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"1\" xsi:type=\"enc:Array\">"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">kj</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">where</key>"
                             "<value xsi:type=\"xsd:string\">id=%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</updatePersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,(long)code,loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//获取职位申请数详情
-(void) loadApplyHistoryCountDetail:(NSInteger)pageIndex
{
    parserType_ = ApplyCountDetail_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@&%@%ld",PersonResume_Apply_Detail_URL,PersonResume_Param_UID,personID,PersonResume_Param_Key,newMD5,PersonResume_Param_Prnd,prnd,PersonResume_Param_Page,(long)pageIndex] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//获取职位收藏数详情
-(void) loadFavHistoryCountDetail:(NSInteger)pageIndex
{
    parserType_ = FavCountDetail_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@&%@%ld",PersonResume_Fav_Detail_URL,PersonResume_Param_UID,personID,PersonResume_Param_Key,newMD5,PersonResume_Param_Prnd,prnd,PersonResume_Param_Page,(long)pageIndex] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//删除收藏职位
-(void) delFavZW:(NSString *)keyId
{
    parserType_ = DelFavZW_XMLParser;
    
    if( !keyId || keyId == nil )
    {
        keyId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<deletePfavorite xmlns=\"http://www.job1001.com\">\n"
                             "<personId>%@</personId>"
                             "<id>%@</id>"
                             "</deletePfavorite>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,keyId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Favorite];
}

//获取面试通知详情
-(void) loadResumeNotiDetail:(NSString *)boxId
{
    parserType_ = ResumeNotifiDetail_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@&%@%@",ResumeNotifi_Detail_URL,
                             ResumeNotifi_Detail_UID_Param,personID,
                             ResumeNotifi_Detail_Enkey_Param,newMD5,
                             ResumeNotifi_Detail_Prnd_Param,prnd,
                             ResumeNotifi_Detail_BoxID_Param,boxId
                             ] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//更新面试通知的状态
-(void) updateMailBoxStatus:(NSString *)boxId
{
    parserType_ = UpdateNotifiStatus_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<updateMyBoxStatus xmlns=\"http://www.job1001.com\">\n"
                             "<person_id>%@</person_id>"
                             "<person_iname>%@</person_iname>"
                             
                             "<mail_id>%@</mail_id>"
                             
                             "</updateMyBoxStatus>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,loginDataModal.uname_,boxId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Mailbox];
}

//获取面试通知列表(以前为http请求,现在改为webservice请求)
-(void) getMailBoxList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = ResumeNotifiCtl_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getMyBoxList xmlns=\"http://www.job1001.com\">\n"
                             "<person_id>%@</person_id>"
                             "<person_iname>%@</person_iname>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">page_size</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">page_index</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             
                             "<searchArr></searchArr>"
                             
                             "</getMyBoxList>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,loginDataModal.uname_,(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Mailbox];
}

//获取订阅列表
-(void) getSubscribeList:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    parserType_ = GetSubscribe_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getSubscribeList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<pageIndex>%ld</pageIndex>"
                             "<pageSize>%ld</pageSize>"
                             
                             "</getSubscribeList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             loginDataModal.personId_,
                             (long)pageIndex,
                             (long)pageSize
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Xjh];
}

//删除某订阅
-(void) delSubscribe:(NSString *)subscribeId
{
    parserType_ = DelSubscribe_XMLParser;
    
    if( !subscribeId || subscribeId == nil )
    {
        subscribeId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<delSubscribe xmlns=\"http://www.job1001.com\">\n"
                             
                             "<subscribeId>%@</subscribeId>"
                             
                             "</delSubscribe>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             subscribeId
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_Xjh];
}

//获取职位申请数
-(void) loadApplyHistoryCount
{
    parserType_ = ApplyCount_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@",PersonResume_Apply_Count_URL,PersonResume_Param_UID,personID,PersonResume_Param_Key,newMD5,PersonResume_Param_Prnd,prnd] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//获取职位收藏数
-(void) loadFavHistoryCount
{
    parserType_ = FavCount_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@",PersonResume_Fav_Count_URL,PersonResume_Param_UID,personID,PersonResume_Param_Key,newMD5,PersonResume_Param_Prnd,prnd] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//获取面试通知数
-(void) loadResumtNotiCount
{
    parserType_ = ResumeNotifiCount_XMLParser;
    
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@",PersonResume_Notifi_Count_URL,PersonResume_Param_UID,personID,PersonResume_Param_Key,newMD5,PersonResume_Param_Prnd,prnd] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//获取谁看过的简历数
-(void) loadResumeBeLookedCount
{
    parserType_ = CompanyLookedCount_XMLParser;
    
    NSString *personID = loginDataModal.personId_;
    NSString *needConvert = [[[NSString alloc] initWithFormat:@"%@%@",loginDataModal.personId_,PersonResume_Add_MD5] autorelease];
    NSString *newMD5 = [MD5 getMD5:needConvert];
    NSString *prnd   = loginDataModal.prnd_;
    
    NSString *connectURL = [[[NSString alloc] initWithFormat:@"%@&%@%@&%@%@&%@%@",PersonResume_CompanyLooked_Count_URL,PersonResume_Param_UID,personID,PersonResume_Param_Key,newMD5,PersonResume_Param_Prnd,prnd] autorelease];
    
    [self connectBySoapMsg:connectURL tableName:nil];
}

//刷新简历
-(void) refreshResume
{
    parserType_ = RefreshResume_XMLParser;

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<refreshResume xmlns=\"http://www.job1001.com\">\n"
                             
                             "<person_id>%@</person_id>"
                             
                             "</refreshResume>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonDeal];
}

//更新个人图片
-(void) updatePersonImage:(UIImage *)image
{
    parserType_ = Update_PersonImage_XMLParser;
    
    NSData *data = UIImageJPEGRepresentation(image,1);
    
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<uploadimgCode xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<preson_uname>%@</preson_uname>"
                             "<data>%@</data>"
                             "<type>jpg</type>"
                             
                             "</uploadimgCode>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,[PreCommon converStringToXMLSoapString:loginDataModal.uname_],base64String];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//删除个人图片
-(void) deletePersonImage
{
    parserType_ = Delete_PersonImage_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<delteleMypic xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<preson_uname>%@</preson_uname>"
                             
                             "</delteleMypic>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,[PreCommon converStringToXMLSoapString:loginDataModal.uname_]];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//更新简历->基本资料
-(void) updateResumeBaseInfo:(NSString *)name gznum:(NSString *)gznum sex:(NSInteger)sexStatus edu:(NSString *)edu hka:(NSString *)hka birthday:(NSString *)birthday nowRegion:(NSString *)nowRegion phoneNum:(NSString *)phoneNum email:(NSString *)email zcheng:(NSString *)zcheng marray:(NSString *)marray zzmm:(NSString *)zzmm mzhu:(NSString *)mzhu
{
    parserType_ = UpdateResume_BaseInfo_XMLParser;
    
    NSString *sexStr;
    //以下信息必有,但为了保证正确性,还是判断一下
    if( !name || name == nil )
    {
        name = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !gznum || gznum == nil )
    {
        gznum = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( sexStatus == Girl )
    {
        sexStr = [[[NSString alloc] initWithString:@"女"] autorelease];
    }else
    {
        sexStr = [[[NSString alloc] initWithString:@"男"] autorelease];
    }
    if( !edu || edu == nil )
    {
        edu = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !hka || hka == nil )
    {
        hka = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !birthday || birthday == nil )
    {
        birthday = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !nowRegion || nowRegion == nil )
    {
        nowRegion = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !phoneNum || phoneNum == nil )
    {
        phoneNum = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !email || email == nil )
    {
        email = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    //以下信息不是必填项
    if( !zcheng || zcheng == nil )
    {
        zcheng = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !marray || marray == nil )
    {
        marray = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zzmm || zzmm == nil )
    {
        zzmm = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !mzhu || mzhu == nil )
    {
        mzhu = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    
    name        = [PreCommon converStringToXMLSoapString:name];
    gznum       = [PreCommon converStringToXMLSoapString:gznum];
    sexStr      = [PreCommon converStringToXMLSoapString:sexStr];
    edu         = [PreCommon converStringToXMLSoapString:edu];
    hka         = [PreCommon converStringToXMLSoapString:hka];
    birthday    = [PreCommon converStringToXMLSoapString:birthday];
    nowRegion   = [PreCommon converStringToXMLSoapString:nowRegion];
    phoneNum    = [PreCommon converStringToXMLSoapString:phoneNum];
    email       = [PreCommon converStringToXMLSoapString:email];
    zcheng      = [PreCommon converStringToXMLSoapString:zcheng];
    marray      = [PreCommon converStringToXMLSoapString:marray];
    zzmm        = [PreCommon converStringToXMLSoapString:zzmm];
    mzhu        = [PreCommon converStringToXMLSoapString:mzhu];
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">update</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"7\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //2
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //3
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //4
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //5
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //6
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //7
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //8
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //9
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //10
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //11
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //12
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //13
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">where</key>"
                             "<value xsi:type=\"xsd:string\">id=%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</updatePersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,
                             PersonDetailInfo_iname,name,
                             PersonDetailInfo_gznum,gznum,
                             PersonDetailInfo_sex,sexStr,
                             PersonDetailInfo_edu,edu,
                             personDetailInfo_hka,hka,
                             PersonDetailInfo_bday,birthday,
                             PersonDetailInfo_Region,nowRegion,
                             PersonDetailInfo_shouji,phoneNum,
                             PersonDetailInfo_email,email,
                             PersonDetailInfo_zcheng,zcheng,
                             PersonDetailInfo_marry,marray,
                             PersonDetailInfo_zzmm,zzmm,
                             PersonDetailInfo_mzhu,mzhu,
                             loginDataModal.personId_];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//更新简历->求职意向
-(void) updateResumeWantJob:(NSString *)jobtype zw1:(NSString *)zw1 zw2:(NSString *)zw2 zw3:(NSString *)zw3 region1:(NSString *)region1 region2:(NSString *)region2 region3:(NSString *)region3 workdate:(NSString *)workdate yuex:(NSString *)yuex grzz:(NSString *)grzz
{
    parserType_ = UpdateResume_WantJob_XMLParser;
    
    //判断一下有效性
    if( !jobtype|| jobtype == nil )
    {
        jobtype = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zw1 || zw1 == nil )
    {
        zw1 = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zw2 || zw2 == nil )
    {
        zw2 = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zw3 || zw3 == nil )
    {
        zw3 = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !region1 || region1 == nil )
    {
        region1 = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !region2 || region2 == nil )
    {
        region2 = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !region3 || region3 == nil )
    {
        region3 = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !workdate || workdate == nil )
    {
        workdate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !yuex || yuex == nil )
    {
        yuex = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !grzz || grzz == nil )
    {
        grzz = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    //jobtype = [PreCommon converStringToXMLSoapString:jobtype];
    yuex    = [PreCommon converStringToXMLSoapString:yuex];
    grzz    = [PreCommon converStringToXMLSoapString:grzz];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">update</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"7\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //2
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //3
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //4
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //5
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //6
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //7
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //8
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //9
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //10
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">where</key>"
                             "<value xsi:type=\"xsd:string\">id=%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</updatePersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,
                             PersonDetailInfo_jobtype,jobtype,
                             PersonDetailInfo_job,zw1,
                             PersonDetailInfo_jobs,zw2,
                             PersonDetailInfo_job1,zw3,
                             PersonDetailInfo_city,region1,
                             PersonDetailInfo_gzdd1,region2,
                             PersonDetailInfo_gzdd5,region3,
                             PersonDetailInfo_workdate,workdate,
                             PersonDetailInfo_yuex,yuex,
                             PersonDetailInfo_grzz,grzz,
                             loginDataModal.personId_];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//加载教育背景(新版)
-(void) loadResumeEdu
{
    parserType_ = GetResume_Edu_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPersonEduDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getPersonEduDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonEdu];
}

//更新教育背景
-(void) updateResumeEdu:(NSString *)myId school:(NSString *)school startDate:(NSString *)startDate endDate:(NSString *)endDate edu:(NSString *)edu eduId:(NSString *)eduId zye:(NSString *)zye zym:(NSString *)zym des:(NSString *)des bToNow:(BOOL)bToNow
{
    parserType_ = UpdateResume_Edu_XMLParser;
    
    if( !myId || myId == nil )
    {
        myId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !school || school == nil )
    {
        school = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !startDate || startDate == nil )
    {
        startDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !endDate || endDate == nil )
    {
        endDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !edu || edu == nil )
    {
        edu = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !eduId || eduId == nil )
    {
        eduId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zye || zye == nil )
    {
        zye = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zym || zym == nil )
    {
        zym = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !des || des == nil )
    {
        des = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    school  = [PreCommon converStringToXMLSoapString:school];
    zym     = [PreCommon converStringToXMLSoapString:zym];
    des     = [PreCommon converStringToXMLSoapString:des];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonEduDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             //"<updateArr enc:itemType=\"ns2:Map\" enc:arraySize=\"3\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<updateArr xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">edusId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">school</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">startdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">stopdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">edu</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">eduId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">zye</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">zym</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">edus</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">istonow</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             
                             "</updateArr>"
                             
                             "</updatePersonEduDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             myId,
                             loginDataModal.personId_,
                             school,
                             startDate,
                             endDate,
                             edu,
                             eduId,
                             zye,
                             zym,
                             des,
                             bToNow
                             ];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonEdu];
}

//新增教育背景
-(void) addResumeEdu:(NSString *)school startDate:(NSString *)startDate endDate:(NSString *)endDate edu:(NSString *)edu eduId:(NSString *)eduId zye:(NSString *)zye zym:(NSString *)zym des:(NSString *)des bToNow:(BOOL)bToNow
{
    parserType_ = AddResume_Edu_XMLParser;
    
    NSString *totalId = loginDataModal.totalId_;
    NSString *tradeId = loginDataModal.tradeId_;
    
    if( !totalId || totalId == nil )
    {
        totalId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    if( !tradeId || tradeId == nil )
    {
        tradeId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    if( !school || school == nil )
    {
        school = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !startDate || startDate == nil )
    {
        startDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !endDate || endDate == nil )
    {
        endDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !edu || edu == nil )
    {
        edu = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !eduId || eduId == nil )
    {
        eduId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zye || zye == nil )
    {
        zye = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zym || zym == nil )
    {
        zym = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !des || des == nil )
    {
        des = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    school  = [PreCommon converStringToXMLSoapString:school];
    zym     = [PreCommon converStringToXMLSoapString:zym];
    des     = [PreCommon converStringToXMLSoapString:des];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<insertPersonEduDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             //"<updateArr enc:itemType=\"ns2:Map\" enc:arraySize=\"3\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<updateArr xsi:type=\"ns2:Map\">"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">tradeid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">totalid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">school</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">startdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">stopdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">edu</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">eduId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">zye</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">zym</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">edus</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">istonow</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             
                             "</updateArr>"
                             
                             "</insertPersonEduDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             loginDataModal.personId_,
                             tradeId,
                             totalId,
                             school,
                             startDate,
                             endDate,
                             edu,
                             eduId,
                             zye,
                             zym,
                             des,
                             bToNow
                             ];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonEdu];
}

//删除教育背景
-(void) delResumeEdu:(NSString *)myId
{
    parserType_ = DelResume_Edu_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<deletePersonEduDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">edusId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</deletePersonEduDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",myId,loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonEdu];
}

//加载工作经历(新版)
-(void) loadResumeWork
{
    parserType_ = GetResume_Work_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPersonWorkDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getPersonWorkDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonWork];
}

//更新工作经历
-(void) updateResumeWork:(NSString *)workId cname:(NSString *)cname bCompanySercet:(BOOL)bCompanySercet startDate:(NSString *)startDate endDate:(NSString *)endDate yuangong:(NSString *)yuangong cxz:(NSString *)cxz zwType:(NSString *)zwType zwName:(NSString *)zwName bSalarySercet:(BOOL)bSalarySercet monthSalary:(NSString *)monthSalary yearSalary:(NSString *)yearSalary yearBouns:(NSString *)yearBouns des:(NSString *)des bOversea:(BOOL)bOversea bToNow:(BOOL)bToNow
{
    parserType_ = UpdateResume_Work_XMLParser;
    
    if( !workId || workId == nil )
    {
        workId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !cname || cname == nil )
    {
        cname = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !startDate || startDate == nil )
    {
        startDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !endDate || endDate == nil )
    {
        endDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !yuangong || yuangong == nil )
    {
        yuangong = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !cxz || cxz == nil )
    {
        cxz = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zwType || zwType == nil )
    {
        zwType = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zwName || zwName == nil )
    {
        zwName = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !monthSalary || monthSalary == nil )
    {
        monthSalary = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !yearSalary || yearSalary == nil )
    {
        yearSalary = [[[NSString alloc] initWithString:@" "] autorelease];
    }
    if( !yearBouns || yearBouns == nil )
    {
        yearBouns = [[[NSString alloc] initWithString:@" "] autorelease];
    }
    if( !des || des == nil )
    {
        des = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    cname       = [PreCommon converStringToXMLSoapString:cname];
    zwName      = [PreCommon converStringToXMLSoapString:zwName];
    monthSalary = [PreCommon converStringToXMLSoapString:monthSalary];
    des         = [PreCommon converStringToXMLSoapString:des];
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonWorkDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             //"<updateArr enc:itemType=\"ns2:Map\" enc:arraySize=\"3\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<updateArr xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">workId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">startdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">stopdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">company</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">companykj</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">yuangong</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">cxz</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">jtzw</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">jtzwtype</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">workdesc</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">salaryyear</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">salarymonth</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">yearbonus</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">salaryKj</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">isforeign</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">istonow</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             
                             
                             
                             "</updateArr>"
                             
                             "</updatePersonWorkDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             workId,
                             loginDataModal.personId_,
                             startDate,
                             endDate,
                             cname,
                             bCompanySercet,
                             yuangong,
                             cxz,
                             zwName,
                             zwType,
                             des,
                             yearSalary,
                             monthSalary,
                             yearBouns,
                             bSalarySercet,
                             bOversea,
                             bToNow
                             ];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonWork];
    
}

//新增工作经历
-(void) addResumeWork:(NSString *)cname bCompanySercet:(BOOL)bCompanySercet startDate:(NSString *)startDate endDate:(NSString *)endDate yuangong:(NSString *)yuangong cxz:(NSString *)cxz zwType:(NSString *)zwType zwName:(NSString *)zwName bSalarySercet:(BOOL)bSalarySercet monthSalary:(NSString *)monthSalary yearSalary:(NSString *)yearSalary yearBouns:(NSString *)yearBouns des:(NSString *)des bOversea:(BOOL)bOversea bToNow:(BOOL)bToNow
{
    parserType_ = AddResume_Work_XMLParser;
    
    NSString *totalId = loginDataModal.totalId_;
    NSString *tradeId = loginDataModal.tradeId_;
    
    if( !totalId || totalId == nil )
    {
        totalId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    if( !tradeId || tradeId == nil )
    {
        tradeId = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    if( !cname || cname == nil )
    {
        cname = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !startDate || startDate == nil )
    {
        startDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !endDate || endDate == nil )
    {
        endDate = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !yuangong || yuangong == nil )
    {
        yuangong = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !cxz || cxz == nil )
    {
        cxz = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zwType || zwType == nil )
    {
        zwType = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !zwName || zwName == nil )
    {
        zwName = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !monthSalary || monthSalary == nil )
    {
        monthSalary = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !yearSalary || yearSalary == nil )
    {
        yearSalary = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !yearBouns || yearBouns == nil )
    {
        yearBouns = [[[NSString alloc] initWithString:@""] autorelease];
    }
    if( !des || des == nil )
    {
        des = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    cname       = [PreCommon converStringToXMLSoapString:cname];
    zwName      = [PreCommon converStringToXMLSoapString:zwName];
    monthSalary = [PreCommon converStringToXMLSoapString:monthSalary];
    des         = [PreCommon converStringToXMLSoapString:des];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<insertPersonWorkDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             //"<updateArr enc:itemType=\"ns2:Map\" enc:arraySize=\"3\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<updateArr xsi:type=\"ns2:Map\">"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">totalid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">tradeid</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">startdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">stopdate</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">company</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">companykj</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">yuangong</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">cxz</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">jtzw</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">jtzwtype</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">workdesc</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">salaryyear</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">salarymonth</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">yearbonus</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">salaryKj</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">isforeign</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">istonow</key>"
                             "<value xsi:type=\"xsd:string\">%d</value>"
                             "</item>"
                             
                             
                             
                             
                             "</updateArr>"
                             
                             "</insertPersonWorkDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             loginDataModal.personId_,
                             totalId,
                             tradeId,
                             startDate,
                             endDate,
                             cname,
                             bCompanySercet,
                             yuangong,
                             cxz,
                             zwName,
                             zwType,
                             des,
                             yearSalary,
                             monthSalary,
                             yearBouns,
                             bSalarySercet,
                             bOversea,
                             bToNow
                             ];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonWork];
}

//删除工作经历
-(void) delResumeWork:(NSString *)workId
{
    parserType_ = DelResume_Work_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<deletePersonWorkDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">workId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</deletePersonWorkDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",workId,loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonWork];
}

//加载个人证书
-(void) loadPersonCer
{
    parserType_ = GetResume_PersonCer_XMLParser;
    
    NSString *sql;
    sql = [[[NSString alloc] initWithFormat:@"select a.id,a.uid,a.Years,a.Months,a.CertName,a.Scores from %@ a where uid='%@' order by a.Years desc,a.Months desc",TableName_PersonCer,loginDataModal.personId_] autorelease];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getObjectList xmlns=\"http://api.job1001.com\">\n"
                             "<sql>%@</sql>"
                             "</getObjectList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",sql];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonCer];
}

//更新证书
-(void) updatePersonCer:(NSString *)cerId cerName:(NSString *)cerName cerType:(NSString *)type scores:(NSString *)scores yearStr:(NSString *)year monthStr:(NSString *)month
{
    parserType_ = UpdateResume_PersonCer_XMLParser;
    
    cerName = [PreCommon converStringToXMLSoapString:cerName];
    scores  = [PreCommon converStringToXMLSoapString:scores];
    
    NSString *whereStr = [[[NSString alloc] initWithFormat:@"id=%@",cerId] autorelease];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<update xmlns=\"http://www.job1001.com\">\n"
                             
                             "<updateArr enc:itemType=\"ns2:Map\" enc:arraySize=\"5\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">CertName</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //2
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">Scores</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //3
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">CerList</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //4
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">Years</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //5
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">Months</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</updateArr>"
                             
                             "<where>%@</where>"
                             
                             "<conditionArray>''</conditionArray>"
                             
                             "</update>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",cerName,scores,type,year,month,whereStr];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonCer];
}

//新增证书
-(void) addPersonCer:(NSString *)cerName cerType:(NSString *)type scores:(NSString *)scores yearStr:(NSString *)year monthStr:(NSString *)month
{
    parserType_ = AddResume_PersonCer_XMLParser;
    
    cerName = [PreCommon converStringToXMLSoapString:cerName];
    scores  = [PreCommon converStringToXMLSoapString:scores];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<insertObject xmlns=\"http://www.job1001.com\">\n"
                             
                             "<soap-enc:array>"
                             "<uid>%@</uid>"
                             "<Years>%@</Years>"
                             "<Months>%@</Months>"
                             "<CerList>%@</CerList>"
                             "<CertName>%@</CertName>"
                             "<Scores>%@</Scores>"
                             "</soap-enc:array>"
                             
                             "</insertObject>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",
                             loginDataModal.personId_,
                             year,
                             month,
                             type,
                             cerName,
                             scores
                             ];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonCer];
}

//删除证书
-(void) delPersonCer:(NSString *)cerId
{
    parserType_ = DelResume_PersonCer_XMLParser;
    
    NSString *whereStr = [[[NSString alloc] initWithFormat:@" id=%@",cerId] autorelease];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<deleteObj xmlns=\"http://www.job1001.com\">\n"
                             "<whereStr>%@</whereStr>"
                             "</deleteObj>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",whereStr];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonCer];
}

//加载个人奖项
-(void) loadPersonAward
{
    parserType_ = GetResume_PersonAward_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<getPersonAwardList xmlns=\"http://www.job1001.com\">\n"
                             "<personId>%@</personId>"
                             "</getPersonAwardList>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonAward];
}

//新增个人奖项
-(void) addPersonAward:(NSString *)awardDesc date:(NSString *)awardDate
{
    parserType_ = AddResume_PersonAward_XMLParser;
    
    if( !awardDesc || awardDesc == nil )
    {
        awardDesc = @"";
    }
    if( !awardDate || awardDate == nil )
    {
        awardDate = @"";
    }
    
    awardDesc = [PreCommon converStringToXMLSoapString:awardDesc];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<addPersonAward xmlns=\"http://www.job1001.com\">\n"
                             "<personId>%@</personId>"
                             "<awardDesc>%@</awardDesc>"
                             "<awardDate>%@</awardDate>"
                             "</addPersonAward>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,awardDesc,awardDate];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonAward];
    
}

//更新个人奖项
-(void) updatePersonAward:(NSString *)awardId awardDesc:(NSString *)awardDesc date:(NSString *)awardDate
{
    parserType_ = UpdateResume_PersonAward_XMLParser;
    
    if( !awardId || awardId == nil )
    {
        awardId = @"";
    }
    if( !awardDesc || awardDesc == nil )
    {
        awardDesc = @"";
    }
    if( !awardDate || awardDate == nil )
    {
        awardDate = @"";
    }
    
    awardDesc = [PreCommon converStringToXMLSoapString:awardDesc];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<updatePersonAward xmlns=\"http://www.job1001.com\">\n"
                             "<awardId>%@</awardId>"
                             "<personId>%@</personId>"
                             "<awardDesc>%@</awardDesc>"
                             "<awardDate>%@</awardDate>"
                             "</updatePersonAward>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",awardId,loginDataModal.personId_,awardDesc,awardDate];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonAward];
}

//删除个人奖项
-(void) delPersonAward:(NSString *)awardId
{
    parserType_ = DelResume_PersonAward_XMLParser;
    
    if( !awardId || awardId == nil )
    {
        awardId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             
                             "<deletePersonAward xmlns=\"http://www.job1001.com\">\n"
                             "<awardId>%@</awardId>"
                             "<personId>%@</personId>"
                             "</deletePersonAward>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",awardId,loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonAward];
}

//加载学生干部经历
-(void) loadPersonStudentLeader
{
    parserType_ = GetResume_StudentLeader_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPersonStudentLeaderDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getPersonStudentLeaderDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonStudentLeader];
}

//新增学生干部经历
-(void) addPersonStudentLeader:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des
{
    parserType_ = AddResume_StudentLeader_XMLParser;
    
    if( !startDate || startDate == nil )
    {
        startDate = @"";
    }
    
    if( !endDate || endDate == nil )
    {
        endDate = @"";
    }
    
    if( !name || name == nil )
    {
        name = @"";
    }
    
    if( !des || des == nil )
    {
        des = @"";
    }
    
    name = [PreCommon converStringToXMLSoapString:name];
    des = [PreCommon converStringToXMLSoapString:des];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<addPersonStudentLeader xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<startDate>%@</startDate>"
                             "<endDate>%@</endDate>"
                             "<bToNow>%d</bToNow>"
                             "<leaderName>%@</leaderName>"
                             "<des>%@</des>"
                             
                             "</addPersonStudentLeader>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,startDate,endDate,bToNow,name,des];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonStudentLeader];
}

//更新学生干部经历
-(void) updatePersonStudentLeader:(NSString *)leaderId startDate:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des
{
    parserType_ = UpdateResume_StudentLeader_XMLParser;
    
    if( !leaderId || leaderId == nil )
    {
        leaderId = @"";
    }
    
    if( !startDate || startDate == nil )
    {
        startDate = @"";
    }
    
    if( !endDate || endDate == nil )
    {
        endDate = @"";
    }
    
    if( !name || name == nil )
    {
        name = @"";
    }
    
    if( !des || des == nil )
    {
        des = @"";
    }
    
    name = [PreCommon converStringToXMLSoapString:name];
    des = [PreCommon converStringToXMLSoapString:des];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonStudentLeader xmlns=\"http://www.job1001.com\">\n"
                             
                             "<leaderId>%@</leaderId>"
                             "<personId>%@</personId>"
                             "<startDate>%@</startDate>"
                             "<endDate>%@</endDate>"
                             "<bToNow>%d</bToNow>"
                             "<leaderName>%@</leaderName>"
                             "<des>%@</des>"
                             
                             "</updatePersonStudentLeader>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",leaderId,loginDataModal.personId_,startDate,endDate,bToNow,name,des];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonStudentLeader];
}

//删除学生干部经历
-(void) delPersonStudentLeader:(NSString *)leaderId
{
    parserType_ = DelResume_StudentLeader_XMLParser;
    
    if( !leaderId || leaderId == nil )
    {
        leaderId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<deletePersonStudentLeaderDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">person_studengLeaderId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</deletePersonStudentLeaderDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",leaderId,loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonStudentLeader];
}

//加载项目活动经历
-(void) loadPersonProject
{
    parserType_ = GetResume_Project_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPersonProjectDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getPersonProjectDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonProject];
}

//新增项目活动经历
-(void) addPersonProject:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des gainDes:(NSString *)gainDes
{
    parserType_ = AddResume_Project_XMLParser;
    
    if( !startDate || startDate == nil )
    {
        startDate = @"";
    }
    
    if( !endDate || endDate == nil )
    {
        endDate = @"";
    }
    
    if( !name || name == nil )
    {
        name = @"";
    }
    
    if( !des || des == nil )
    {
        des = @"";
    }
    
    if( !gainDes || gainDes == nil )
    {
        gainDes = @"";
    }
    
    name = [PreCommon converStringToXMLSoapString:name];
    des = [PreCommon converStringToXMLSoapString:des];
    gainDes = [PreCommon converStringToXMLSoapString:gainDes];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<addPersonProject xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<startDate>%@</startDate>"
                             "<endDate>%@</endDate>"
                             "<bToNow>%d</bToNow>"
                             "<leaderName>%@</leaderName>"
                             "<des>%@</des>"
                             "<gainDes>%@</gainDes>"
                             
                             "</addPersonProject>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,startDate,endDate,bToNow,name,des,gainDes];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonProject];
}

//更新项目活动经历
-(void) updatePersonPorject:(NSString *)projectId startDate:(NSString *)startDate endDate:(NSString *)endDate bToNow:(BOOL)bToNow name:(NSString *)name des:(NSString *)des gainDes:(NSString *)gainDes
{
    parserType_ = UpdateResume_Project_XMLParser;
    
    if( !projectId || projectId == nil )
    {
        projectId = @"";
    }
    
    if( !startDate || startDate == nil )
    {
        startDate = @"";
    }
    
    if( !endDate || endDate == nil )
    {
        endDate = @"";
    }
    
    if( !name || name == nil )
    {
        name = @"";
    }
    
    if( !des || des == nil )
    {
        des = @"";
    }
    
    if( !gainDes || gainDes == nil )
    {
        gainDes = @"";
    }
    
    name = [PreCommon converStringToXMLSoapString:name];
    des = [PreCommon converStringToXMLSoapString:des];
    gainDes = [PreCommon converStringToXMLSoapString:gainDes];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonProject xmlns=\"http://www.job1001.com\">\n"
                             
                             "<leaderId>%@</leaderId>"
                             "<personId>%@</personId>"
                             "<startDate>%@</startDate>"
                             "<endDate>%@</endDate>"
                             "<bToNow>%d</bToNow>"
                             "<leaderName>%@</leaderName>"
                             "<des>%@</des>"
                             "<gainDes>%@</gainDes>"
                             
                             "</updatePersonProject>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",projectId,loginDataModal.personId_,startDate,endDate,bToNow,name,des,gainDes];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonProject];
}

//删除项目活动经历
-(void) delPersonProject:(NSString *)projectId
{
    parserType_ = DelResume_Project_XMLParser;
    
    if( !projectId || projectId == nil )
    {
        projectId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<deletePersonProjectDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">person_studengLeaderId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</deletePersonProjectDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",projectId,loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PersonProject];
}

//更新教育背景(旧版的更新)
-(void) updateResumeOldEduInfo:(NSString *)name school:(NSString *)school bydate:(NSString *)bydate zye:(NSString *)zye zym:(NSString *)zym des:(NSString *)des
{
    parserType_ = UpdateResume_OldEdu_XMLParser;
    
    //判断一下有效性
    if( !name || name == nil )
    {
        name = @"";
    }
    if( !school|| school == nil )
    {
        school = @"";
    }
    if( !bydate || bydate == nil )
    {
        bydate = @"";
    }
    if( !zye || zye == nil )
    {
        zye = @"";
    }
    if( !zym || zym == nil )
    {
        zym = @"";
    }
    if( !des || des == nil )
    {
        des = @"";
    }
    
    name    = [PreCommon converStringToXMLSoapString:name];
    school  = [PreCommon converStringToXMLSoapString:school];
    bydate  = [PreCommon converStringToXMLSoapString:bydate];
    zye     = [PreCommon converStringToXMLSoapString:zye];
    zym     = [PreCommon converStringToXMLSoapString:zym];
    des     = [PreCommon converStringToXMLSoapString:des];
    
    NSString *namePart = @"";
    if( name && ![name isEqualToString:@""] )
    {
        namePart = [NSString stringWithFormat:@"<item xsi:type=\"ns2:Map\">"
                    "<item>"
                    "<key xsi:type=\"xsd:string\">columnName</key>"
                    "<value xsi:type=\"xsd:string\">%@</value>"
                    "</item>"
                    "<item>"
                    "<key xsi:type=\"xsd:string\">columnValue</key>"
                    "<value xsi:type=\"xsd:string\">%@</value>"
                    "</item>"
                    "</item>",PersonDetailInfo_iname,name];
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">update</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"7\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //2
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //3
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //4
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             //5
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "%@"
                             
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">where</key>"
                             "<value xsi:type=\"xsd:string\">id=%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</updatePersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,
                             PersonDetailInfo_school,school,
                             PersonDetailInfo_byday,bydate,
                             PersonDetailInfo_zye,zye,
                             PersonDetailInfo_zym,zym,
                             PersonDetailInfo_edus,des,
                             namePart,
                             loginDataModal.personId_];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//更新简历->工作经验(旧版的更新)
-(void) updateResumeOldWorksInfo:(NSString *)text
{
    parserType_ = UpdateResume_OldWorks_XMLParser;
    
    //判断一下有效性
    if( !text|| text == nil )
    {
        text = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    text = [PreCommon converStringToXMLSoapString:text];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">update</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"7\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">where</key>"
                             "<value xsi:type=\"xsd:string\">id=%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</updatePersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,
                             PersonDetailInfo_gzjl,text,
                             loginDataModal.personId_];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//更新简历->工作技能
-(void) updateResumeSkill:(NSString *)text
{
    parserType_ = UpdateResume_SkillInfo_XMLParser;
    
    //判断一下有效性
    if( !text|| text == nil )
    {
        text = [[[NSString alloc] initWithString:@""] autorelease];
    }
    
    text = [PreCommon converStringToXMLSoapString:text];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<updatePersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">update</key>"
                             "<value enc:itemType=\"ns2:Map\" enc:arraySize=\"7\" xsi:type=\"enc:Array\">"
                             
                             //1
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">columnValue</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">where</key>"
                             "<value xsi:type=\"xsd:string\">id=%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</updatePersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,
                             PersonDetailInfo_othertc,text,
                             loginDataModal.personId_];
    
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//获取简历路径
-(void) loadResumePath:(NSString *)showResumeType;
{
    parserType_ = GetResumePath_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getResumePathByMobile xmlns=\"http://www.job1001.com\">\n"
                             
                             "<personId>%@</personId>"
                             "<type>%@</type>"
                             
                             "</getResumePathByMobile>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,showResumeType];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//获取个人信息
-(void) loadPersonInfo
{
    parserType_ = PersonInfo_XMLParser;
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPersonDetail xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">personId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "<where>\"1=1\"</where>"
                             "<slaveInfo>1</slaveInfo>"
                             
                             "</getPersonDetail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Person];
}

//获取logoList
-(void) getLogoList:(NSString *)appName modelKey:(NSString *)modelKey
{
    parserType_ = App_LogoList_XMLParser;
    
    if( !appName ){
        appName = @"";
    }
    if( !modelKey ){
        modelKey = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getAppLogoList xmlns=\"http://www.job1001.com\">\n"
                             
                                                          
                             "<appName>%@</appName>"
                             "<modelKey>%@</modelKey>"
                             
                             "</getAppLogoList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",appName,modelKey];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_AppLogo];
}

//获取附近的院校
-(void) getNearSchoolList:(float)lat lng:(float)lng
{
    parserType_ = Near_SchoolList_XMLParser;
    
    NSString *userId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getNearSchoolList xmlns=\"http://www.job1001.com\">\n"
                             
                             
                             "<lat>%f</lat>"
                             "<lng>%f</lng>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">userId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getNearSchoolList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",lat,lng,userId];
    
    [self connectBySoapMsg:soapMessage tableName:Request_TableName_School];
}

//获取关注的学校
-(void) getAttentionSchoolList:(NSString *)schoolId pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = Attention_SchoolList_XMLParser;
    
    if( !schoolId ){
        schoolId = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getMyAttentionSchoolList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<userId>%@</userId>"
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">schoolId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             
                             "</getMyAttentionSchoolList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",loginDataModal.personId_,schoolId,(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_School_Attention];
}

//关注某些学校
-(void) addAttentionSchool:(NSArray *)schoolNameArr clientName:(NSString *)clientName clientVersion:(NSString *)clientVersion
{
//    parserType_ = AddAttention_School_XMLParser;
//    
//    if( !clientName ){
//        clientName = @"";
//    }
//    if( !clientVersion ){
//        clientVersion = @"";
//    }
//    
//    NSMutableString *idStr = [[[NSMutableString alloc] init] autorelease];
//    NSMutableString *nameStr = [[[NSMutableString alloc] init] autorelease];
//    for ( int i = 0 ; i < [schoolNameArr count] ; ++i ) {
//        School_DataModal *dataModal = [schoolNameArr objectAtIndex:i];
//        
//        [idStr appendFormat:
//         @""
//         "<item>"
//         "<key xsi:type=\"xsd:string\">%d</key>"
//         "<value xsi:type=\"xsd:string\">%@</value>"
//         "</item>"
//         "",i,dataModal.id_
//         ];
//        
//        [nameStr appendFormat:
//         @""
//         "<item>"
//         "<key xsi:type=\"xsd:string\">%d</key>"
//         "<value xsi:type=\"xsd:string\">%@</value>"
//         "</item>"
//         "",i,dataModal.name_
//         ];
//    }
//    
//    NSString *soapMessage = [NSString stringWithFormat:
//                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//                             "<soap:Body>\n"
//                             "<addSchoolAttention xmlns=\"http://www.job1001.com\">\n"
//                             
//                             "<userId>%@</userId>"
//                             
//                             "<item xsi:type=\"ns2:Map\">"
//                             "%@"
//                             "</item>"
//                             
//                             "<item xsi:type=\"ns2:Map\">"
//                             "%@"
//                             "</item>"
//                             
//                             "<item xsi:type=\"ns2:Map\">"
//                             "<item>"
//                             "<key xsi:type=\"xsd:string\">clientName</key>"
//                             "<value xsi:type=\"xsd:string\">%@</value>"
//                             "</item>"
//                             "<item>"
//                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
//                             "<value xsi:type=\"xsd:string\">%@</value>"
//                             "</item>"
//                             "</item>"
//                             
//                             "</addSchoolAttention>\n"
//                             "</soap:Body>\n"
//                             "</soap:Envelope>\n",loginDataModal.personId_,idStr,nameStr,clientName,clientVersion];
//    
//    [self connectBySoapMsg:soapMessage tableName:TableName_School_Attention];
}

//取消关注
-(void) cancelAttentioinSchool:(NSArray *)schoolNameArr
{
//    parserType_ = CancelAttention_School_XMLParser;
//    
//    NSMutableString *nameStr = [[[NSMutableString alloc] init] autorelease];
//    for ( int i = 0 ; i < [schoolNameArr count] ; ++i ) {
//        School_DataModal *dataModal = [schoolNameArr objectAtIndex:i];
//        
//        [nameStr appendFormat:
//         @""
//         "<item>"
//         "<key xsi:type=\"xsd:string\">%d</key>"
//         "<value xsi:type=\"xsd:string\">%@</value>"
//         "</item>"
//         "",i,dataModal.name_
//         ];
//    }
//    
//    NSString *soapMessage = [NSString stringWithFormat:
//                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//                             "<soap:Body>\n"
//                             "<cancelSchoolAttention xmlns=\"http://www.job1001.com\">\n"
//                             
//                             "<userId>%@</userId>"
//                             
//                             "<idArr></idArr>"
//                             
//                             "<item xsi:type=\"ns2:Map\">"
//                             "%@"
//                             "</item>"
//                             
//                             "</cancelSchoolAttention>\n"
//                             "</soap:Body>\n"
//                             "</soap:Envelope>\n",loginDataModal.personId_,nameStr];
//    
//    [self connectBySoapMsg:soapMessage tableName:TableName_School_Attention];
}

//获取我的学校信息
-(void) getMySchoolInfoList:(NSString *)schoolId schoolName:(NSString *)schoolName pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = GetMySchoolInfoList_XMLParser;
    
    if( !schoolId ){
        schoolId = @"";
    }
    if( !schoolName ){
        schoolName = @"";
    }
    
    NSString *userId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getMyInfoList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<userId>%@</userId>"
                             
                             "<schoolId>%@</schoolId>"
                             "<schoolName>%@</schoolName>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">deviceId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             
                             "</getMyInfoList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userId,schoolId,schoolName,Client_Type,Client_Current_Version,[PreCommon getDeviceID],(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_School_Attention];
}

//获取我的消息
-(void) getMyMsgList:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = MyMsgList_XMLParser;
    
    NSString *userId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getMyMsgList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<userId>%@</userId>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             
                             "</getMyMsgList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userId,Client_Type,Client_Current_Version,(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PublishMsg];
}

//获取发布者的消息列表
-(void) getPublisherMsgList:(NSString *)publisherId publisherIdType:(NSInteger)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = PublisherMsgList_XMLParser;
    
    if( !publisherId ){
        publisherId = @"";
    }
    
    NSString *userId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getPublisherMsgList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<userId>%@</userId>"
                             "<publisherId>%@</publisherId>"
                             "<publisherIdType>%ld</publisherIdType>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             
                             "</getPublisherMsgList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userId,publisherId,(long)type,Client_Type,Client_Current_Version,(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_PublishMsg];
}

//获取消息内容
-(void) getMsgContent:(NSString *)msgId
{
    parserType_ = MsgContent_XMLParser;
    
    if( !msgId ){
        msgId = @"";
    }
        
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getMsgContent xmlns=\"http://www.job1001.com\">\n"
                             
                             "<msgId>%@</msgId>"
                                                          
                             "</getMsgContent>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",msgId];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_Msg];
}

//获取某学校的相关信息
-(void) getSchoolInfoList:(NSString *)schoolId schoolName:(NSString *)schoolName pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex
{
    parserType_ = SchoolInfo_XMLParser;
    
    if( !schoolId ){
        schoolId = @"";
    }
    if( !schoolName ){
        schoolName = @"";
    }
    
    NSString *userId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getSchoolInfoList xmlns=\"http://www.job1001.com\">\n"
                             
                             "<userId>%@</userId>"
                             
                             "<schoolId>%@</schoolId>"
                             "<schoolName>%@</schoolName>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">deviceId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageSize</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">pageIndex</key>"
                             "<value xsi:type=\"xsd:string\">%ld</value>"
                             "</item>"
                             "</item>"
                             
                             "</getSchoolInfoList>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userId,schoolId,schoolName,Client_Type,Client_Current_Version,[PreCommon getDeviceID],(long)pageSize,(long)pageIndex];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_School_Attention];
}

//获取相关数量信息
-(void) getMyCntInfo:(NSString *)schoolId schoolName:(NSString *)schoolName
{
    parserType_ = MyCntInfo_XMLParser;
    
    if( !schoolId ){
        schoolId = @"";
    }
    if( !schoolName ){
        schoolName = @"";
    }
    
    NSString *userId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK ){
        userId = loginDataModal.personId_;
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getCntInfo xmlns=\"http://www.job1001.com\">\n"
                             
                             "<userId>%@</userId>"
                             
                             "<schoolId>%@</schoolId>"
                             "<schoolName>%@</schoolName>"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             "</item>"
                             
                             "</getCntInfo>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",userId,schoolId,schoolName,Client_Type,Client_Current_Version];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_School_Attention];
}

//设置我的学校
-(void) setMySchool:(NSString *)schoolId schoolName:(NSString *)schoolName
{
    parserType_ = SetMySchool_XMLParser;
    
    NSString *personId = @"";
    if( loginDataModal && loginDataModal.loginState_ == LoginOK )
    {
        personId = loginDataModal.personId_;
    }
    
    if( !schoolId ){
        schoolId = @"";
    }
    
    if( !schoolName ){
        schoolName = @"";
    }
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns2=\"http://xml.apache.org/xml-soap\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<setSubscribeConfig xmlns=\"http://www.job1001.com\">\n"
                             
                             "<item xsi:type=\"ns2:Map\">"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">clientVersion</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">deviceId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">userId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">schoolId</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "<item>"
                             "<key xsi:type=\"xsd:string\">schoolName</key>"
                             "<value xsi:type=\"xsd:string\">%@</value>"
                             "</item>"
                             
                             "</item>"
                             
                             "</setSubscribeConfig>\n"
                             
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",Client_Type,Client_Current_Version,[PreCommon getDeviceID],personId,schoolId,schoolName];
    
    [self connectBySoapMsg:soapMessage tableName:TableName_AppSubscribe_Config];
}

//获取职位的时间类型
-(void) getZWDateType
{
    parserType_ = ZWDateType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//获取学历类型
-(void) getEduType
{
    parserType_ = EduType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//获取工作经验
-(void) getYearType
{
    parserType_ = YearType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//获取现有职称
-(void) getPostionLevelType
{
    parserType_ = PostionLevel_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//获取婚姻类型
-(void) getMarryType
{
    parserType_ = MarryType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//政治面貌
-(void) getPoliticsType
{
    parserType_ = PoliticsType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//民族
-(void) getNationType
{
    parserType_ = NationType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//求职类型
-(void) getJobType
{
    parserType_ = JobType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//可到职日期选择
-(void) getWorkDateType
{
    parserType_ = WorkDateType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//专业类别
-(void) getZyeType
{
    parserType_ = ZyeType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//所有专业类别
-(void) getZyeAllType
{
    parserType_ = ZyeTypeAll_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//专业名称
-(void) getMajorNameType:(CondictionList_DataModal *)dataModal
{
    parserType_ = MajorName_XMLParser;
    
    exParam_ = dataModal;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//公司规模
-(void) getCompanyEmployType
{
    parserType_ = CompanyEmployesType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//公司性质
-(void) getCompanyAttType
{
    parserType_ = CompanyAttType_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//年薪
-(void) getYearSalaryType
{
    parserType_ = YearSalary_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//年终奖选择
-(void) getYearBounsType
{
    parserType_ = YearBouns_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//定位范围
-(void) getMapRangType
{
    parserType_ = MapRang_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//职位类型
-(void) GetPartJobType
{
    parserType_ = PartJob_XMLParser;
    
    [self connectBySoapMsg:nil tableName:nil];
}

//获取数据
-(NSArray *) getLocalData:(XMLParserType)type
{
    NSLog(@"[Get Local Data] : %d",type);
    
    NSMutableArray *tempArr = [[[NSMutableArray alloc] init] autorelease];
    
    switch ( type ) {
            //职位的发布时间
        case ZWDateType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"不限",@"一个星期",@"两个星期",@"一个月",@"三个月",nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"",@"7",@"14",@"30",@"90",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //学历类型
        case EduType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"初中",@"高中",@"中技",@"中专",@"大专",@"本科",@"硕士",@"MBA",@"博士",@"博士后", nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"75",@"80",@"90",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //工作经验
        case YearType_XMLParser:
        {
//            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"无经验",@"1-3年",@"4-5年",@"6-8年",@"9-10年",@"11-15",@"15年以上", nil] autorelease];
//            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"0",@"1",@"4",@"6",@"9",@"11",@"15",nil] autorelease];
            
            NSArray *strValue = [[NSArray alloc]initWithObjects:@"不限",@"应届毕业生",@"1年以下",@"1-3年",@"3-5年",@"5-10年",@"10年及以上", nil];
            NSArray *idValue = [[NSArray alloc]initWithObjects:@"",@"0",@"0-1",@"1-3",@"3-5",@"5-10",@"10-0", nil];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //现有职称
        case PostionLevel_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"高级",@"中级",@"初级",@"暂无",@"其它", nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"高级",@"中级",@"初级",@"暂无",@"其它",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //婚姻状况
        case MarryType_XMLParser:
        {
            //,@"离异"
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"未婚",@"已婚", nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"未婚",@"已婚",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //政治面貌
        case PoliticsType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"党员",@"团员",@"群众",@"民主党派",@"其它", nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"党员",@"团员",@"群众",@"民主党派",@"其它",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //民族
        case NationType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:
                                 @"汉族",@"壮族",@"满族",@"回族",@"苗族",@"维吾尔族",@"土家族",@"彝族",@"蒙古族",@"藏族",
                                 @"布依族",@"侗族",@"瑶族",@"朝鲜族",@"白族",@"哈尼族",@"哈萨克族",@"黎族",@"傣族",@"畲族",@"僳僳族",
                                 @"仡佬族",@"东乡族",@"拉祜族",@"水族",@"佤族",@"纳西族",@"羌族",@"土族",@"仫佬族",@"锡伯族",
                                 @"柯尔克孜族",@"达斡尔族",@"景颇族",@"毛南族",@"撒拉族",@"布朗族",@"塔吉克族",@"阿昌族",@"普米族",@"鄂温克族",
                                 @"怒族",@"京族",@"基诺族",@"德昂族",@"保安族",@"俄罗斯族",@"裕固族",@"乌孜别克族",@"门巴族",@"鄂伦春族",
                                 @"独龙族",@"塔塔尔族",@"赫哲族",@"高山族",@"珞巴族",@"国外人士",
                                 nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:
                                @"汉族",@"壮族",@"满族",@"回族",@"苗族",@"维吾尔族",@"土家族",@"彝族",@"蒙古族",@"藏族",
                                @"布依族",@"侗族",@"瑶族",@"朝鲜族",@"白族",@"哈尼族",@"哈萨克族",@"黎族",@"傣族",@"畲族",@"僳僳族",
                                @"仡佬族",@"东乡族",@"拉祜族",@"水族",@"佤族",@"纳西族",@"羌族",@"土族",@"仫佬族",@"锡伯族",
                                @"柯尔克孜族",@"达斡尔族",@"景颇族",@"毛南族",@"撒拉族",@"布朗族",@"塔吉克族",@"阿昌族",@"普米族",@"鄂温克族",
                                @"怒族",@"京族",@"基诺族",@"德昂族",@"保安族",@"俄罗斯族",@"裕固族",@"乌孜别克族",@"门巴族",@"鄂伦春族",
                                @"独龙族",@"塔塔尔族",@"赫哲族",@"高山族",@"珞巴族",@"国外人士",
                                nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }

        }
            break;
            //求职类型
        case JobType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"全职",@"兼职",@"两者兼可", nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"全职",@"兼职",@"两者兼可",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //可到职日期
        case WorkDateType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"随时",@"一个星期",@"两个星期",@"一个月",@"三个月",@"三个月以后",nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"随时",@"一个星期",@"两个星期",@"一个月",@"三个月",@"三个月以后",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
            
        }
            break;
            //专业类别
        case ZyeType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:
                                 @"经济类",@"财政、金融、保险类",@"市场营销、经营管理类",@"公共管理类",@"财务会计类",@"计算机科学与技术类",@"电子科学与技术类",@"电子信息与通信工程类",@"建筑设计类",@"土木工程类",
                                 @"水利工程类",@"测绘科学与技术类",@"矿业及冶金工程类",@"仪器科学与技术类",@"材料与能源类",@"地质资源、地质工程、勘探类",@"轻工纺织食品类",@"陆地运输、运输管理类",@"船舶水运类",@"航空航天类",@"石油与天然气工程类",
                                 @"电力与电气工程类",@"机械工程类",@"动力工程及工程热物理类",@"控制科学与工程类",@"光学工程类",@"化学、日化、化工类",@"环保气象与安全类",@"农林牧渔类",@"医学类",@"师范、基础教育类",
                                 @"职业技术教育类",@"新闻传播学类",@"外国语言文学类",@"中国语言文学类",@"数学类",@"历史学类",@"政治学类",@"心理学类",@"社会学类",@"哲学类",
                                 @"军事与公安类",@"文学艺术类",@"自然科学类",@"力学类",@"物理学类",@"法学法律类",@"不限",
                                 nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:
                                @"234",@"103",@"190",@"277",@"7081311410146700",@"3561316171568624",@"2411316171436663",@"1241319689752202",@"3331316171603977",@"8391316171650715",
                                @"4041316171683722",@"8571316171746655",@"1721311324162712",@"2581316171212190",@"102",@"4831316171818457",@"184",@"7401319700160659",@"4331319701013646",@"254",@"5231305599725656",
                                @"5041316171400371",@"154",@"7091305601881443",@"8561316171536808",@"9801320985413184",@"3241305599555369",@"146",@"9281316171955606",@"5911316172014230",@"236",
                                @"282",@"280",@"279",@"229",@"193",@"176",@"288",@"247",@"287",@"224",
                                @"8651316171995406",@"7931316170616545",@"9911316170873636",@"175",@"207",@"235",@"不限",
                                nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //所有专业类别
        case ZyeTypeAll_XMLParser:    
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:
                                  @"所有专业",@"经济类",@"财政、金融、保险类",@"市场营销、经营管理类",@"公共管理类",@"财务会计类",@"计算机科学与技术类",@"电子科学与技术类",@"电子信息与通信工程类",@"建筑设计类",@"土木工程类",
                                  @"水利工程类",@"测绘科学与技术类",@"矿业及冶金工程类",@"仪器科学与技术类",@"材料与能源类",@"地质资源、地质工程、勘探类",@"轻工纺织食品类",@"陆地运输、运输管理类",@"船舶水运类",@"航空航天类",@"石油与天然气工程类",
                                  @"电力与电气工程类",@"机械工程类",@"动力工程及工程热物理类",@"控制科学与工程类",@"光学工程类",@"化学、日化、化工类",@"环保气象与安全类",@"农林牧渔类",@"医学类",@"师范、基础教育类",
                                  @"职业技术教育类",@"新闻传播学类",@"外国语言文学类",@"中国语言文学类",@"数学类",@"历史学类",@"政治学类",@"心理学类",@"社会学类",@"哲学类",
                                  @"军事与公安类",@"文学艺术类",@"自然科学类",@"力学类",@"物理学类",@"法学法律类",
                                  nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:
                                 @"",@"234",@"103",@"190",@"277",@"7081311410146700",@"3561316171568624",@"2411316171436663",@"1241319689752202",@"3331316171603977",@"8391316171650715",
                                 @"4041316171683722",@"8571316171746655",@"1721311324162712",@"2581316171212190",@"102",@"4831316171818457",@"184",@"7401319700160659",@"4331319701013646",@"254",@"5231305599725656",
                                 @"5041316171400371",@"154",@"7091305601881443",@"8561316171536808",@"9801320985413184",@"3241305599555369",@"146",@"9281316171955606",@"5911316172014230",@"236",
                                 @"282",@"280",@"279",@"229",@"193",@"176",@"288",@"247",@"287",@"224",
                                 @"8651316171995406",@"7931316170616545",@"9911316170873636",@"175",@"207",@"235",
                                 nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //专业名称
        case MajorName_XMLParser:
        {            
            //动态从本地数据库中读取专业分类
            //从数据库中去读取数据
            sqlite3_stmt *result = [myDB selectSQL:nil fileds:@"id,str" whereStr:[NSString stringWithFormat:@"parentStr='%@'",exParam_] limit:0 tableName:DB_Major];
            
            while ( sqlite3_step(result) == SQLITE_ROW )
            {
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                
                //id
                char *rowData_0 = (char *)sqlite3_column_text(result, 0);
                //str
                char *rowData_1 = (char *)sqlite3_column_text(result, 1);
                
                dataModal.id_   = [[[NSString alloc] initWithCString:rowData_0 encoding:(NSUTF8StringEncoding)] autorelease];
                dataModal.str_  = [[[NSString alloc] initWithCString:rowData_1 encoding:(NSUTF8StringEncoding)] autorelease];
                
                [tempArr addObject:dataModal];
            }
            
            sqlite3_finalize(result);
            
            CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
            dataModal.str_ = @"自定义";
            [tempArr addObject:dataModal];
        }
            break;
            //公司规模
        case CompanyEmployesType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"1 - 49人",@"50 - 99人",@"100 - 499人",@"500 - 999人",@"1000人以上",nil] autorelease];
            //NSArray *idValue = [[NSArray alloc] initWithObjects:@"1 - 49人",@"50 - 99人",@"100 - 499人",@"500 - 999人",@"1000人以上",nil];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                //dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //公司性质
        case CompanyAttType_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"私营企业",@"国有企业",@"股份公司",@"集体企业",@"行政机关",@"事业单位",@"社会团体",@"外商独资",@"中外合资",@"中外合作",@"其他",nil] autorelease];
            //NSArray *idValue = [[NSArray alloc] initWithObjects:@"私营企业",@"国有企业",@"股份公司",@"集体企业",@"行政机关",@"事业单位",@"社会团体",@"外商独资",@"中外合资",@"中外合作",@"其他",nil];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                //dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
            
        }
            break;
            //年薪
        case YearSalary_XMLParser:
        {
            CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
            dataModal.bParent_ = NO;
            dataModal.str_ = @"暂无";
            [tempArr addObject:dataModal];
            
            for( int i = 1 ; i <= 100 ; ++i )
            {
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = [[[NSString alloc] initWithFormat:@"%d 万",i] autorelease];
                //dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //年终奖
        case YearBouns_XMLParser:
        {
            CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
            dataModal.bParent_ = NO;
            dataModal.str_ = @"暂无";
            [tempArr addObject:dataModal];
            
            for( int i = 1 ; i <= 100 ; ++i )
            {
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = [[[NSString alloc] initWithFormat:@"%d 万",i] autorelease];
                //dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //定位范围
        case MapRang_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"3公里内",@"5公里内",@"10公里内",@"20公里内",@"30公里内", nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"3",@"5",@"10",@"20",@"30",nil] autorelease];
            
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
            //职位类型
        case PartJob_XMLParser:
        {
            NSArray *strValue = [[[NSArray alloc] initWithObjects:@"实习",@"兼职",@"实习/兼职",nil] autorelease];
            NSArray *idValue = [[[NSArray alloc] initWithObjects:@"实习",@"兼职",@"",nil] autorelease];
        
            for( int i = 0 ; i < [strValue count] ; ++i )
            {
                NSString *obj = [strValue objectAtIndex:i];
                CondictionList_DataModal *dataModal = [[[CondictionList_DataModal alloc] init] autorelease];
                dataModal.bParent_ = NO;
                dataModal.str_ = obj;
                dataModal.id_ = [idValue objectAtIndex:i];
                
                [tempArr addObject:dataModal];
            }
        }
            break;
        default:
            break;
    }
    
    return tempArr;
}



@end

