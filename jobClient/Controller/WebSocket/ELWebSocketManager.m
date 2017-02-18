//
//  ELWebSocketManager.m
//  jobClient
//
//  Created by YL1001 on 16/12/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELWebSocketManager.h"
#import "SRWebSocket.h"
#import "ELGroupDetailModal.h"

//@"ws://192.168.60.212:7272" 本地测试
//@"ws://imws.job1001.com:7272"   正式服务器
#define SRWEBSOCKET_URL                 @"ws://imws.job1001.com:7272"
#define SRWEBSOCKET_PONGTIMERINTERVAL   20.0  // 服务器心跳时间间隔
#define SRWEBSOCKET_TIMEOUTMAXCOUNT     10    // 最大允许超时次数

// *app_tun   debug测试   product线上
const NSString *app_tun= @"product";

static NSInteger secconds = 0;
static NSInteger timeoutCount = 0;

@interface ELWebSocketManager ()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
    NSTimer *_countTimer;
    NSInteger msgCount;
    BOOL isMsgSend;
}
@end

@implementation ELWebSocketManager

- (void)dealloc
{
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _status = ELWebSocketStatusClose;
        [self AFNReachabilityMonitoring];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openServer) name:@"openWebSocket" object:nil];
    }
    
    return self;
}

+ (instancetype)defaultManager
{
    static ELWebSocketManager *manager = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[ELWebSocketManager alloc] init];
        }
    });
    
    return manager;
}

//建立连接
- (void)openServer
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:SRWEBSOCKET_URL]];
        _webSocket.delegate = self;
        [_webSocket open];
    });
}

//关闭连接
- (void)closeServer
{
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

/*
 *登录服务器
 *app_tun   debug测试   product线上
 */
- (void)loginChatServer:(NSArray *)groupIdArr
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"connect" forKey:@"type"];
    [dict setObject:app_tun forKey:@"app_run"];
    [dict setObject:[Manager getUserInfo].userId_ forKey:@"account_login_id"];
//    [dict setObject:groupIdArr forKey:@"groups"];
    
    NSString *checkId = [MD5 getMD5:[Manager getUserInfo].userId_];
    NSString *checkStr = [MD5 getMD5:[NSString stringWithFormat:@"%@YL_WEBSOCKET", checkId]];
    [dict setObject:checkStr forKey:@"checksum"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *dictStr = [jsonWrite stringWithObject:dict];
    
    [_webSocket sendString:dictStr error:NULL];
}

- (void)stopTimer
{
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
        secconds = 0;
    }
}

- (void)heardBeatBack{
    NSDictionary *checkInfo = @{@"type":@"pong"};
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *jsonStr = [jsonWrite stringWithObject:checkInfo];
    if (_status == ELWebSocketStatusOpen) {
        [_webSocket sendString:jsonStr error:NULL];
    }
    NSLog(@"heardBeatBack:%@",jsonStr);
}

- (void)updateTimerCount
{
    if ([Manager shareMgr].haveLogin) {
        if (secconds > SRWEBSOCKET_PONGTIMERINTERVAL) {
            // 根据服务器设置的超时时间定
            // SRWEBSOCKET_PONGTIMERINTERVAL时间间隔未收到心跳，则认定服务器端无响应.
            NSLog(@"心跳超时");
            secconds = 0;
//            if (timeoutCount > SRWEBSOCKET_TIMEOUTMAXCOUNT) {
//                //超时次数大于SRWEBSOCKET_TIMEOUTMAXCOUNT表示连接失败
//                timeoutCount = 0;
//                [self closeServer];
//                [self stopTimer];
//                [self heardBeatBack];
//                NSLog(@"断开与服务器的连接");
//            }
//            else{
                //尝试重连
                NSLog(@"正在连接....time(%ld)", (long)timeoutCount);
                if (_status == ELWebSocketStatusLogOffByUser) {
                    timeoutCount = 0;
                    [self closeServer];
                    [self stopTimer];
                    [self heardBeatBack];
                    NSLog(@"断开与服务器的连接");
                }
                else
                {
                    [self openServer];
                }
//            }
        }
        else{
            ++secconds;
        }
    }
    else
    {
        secconds = 0;
        timeoutCount = 0;
        [self closeServer];
        [self stopTimer];
    }
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"建立连接成功");
    _status = ELWebSocketStatusOpen;
    if ([Manager shareMgr].haveLogin) {
        [self loginChatServer:nil];
    }
    else {
        [self closeServer];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReceiceWSStatuChange:)]) {
        [self.delegate chatManager:self didReceiceWSStatuChange:_status];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"rev Error:%@", error);
    if (error) {
        [self closeServer];
        _status = ELWebSocketStatusClose;
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReceiceWSStatuChange:)]) {
            [self.delegate chatManager:self didReceiceWSStatuChange:_status];
        }
    }
    
    [self stopTimer];
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerCount) userInfo:nil repeats:YES];
        [_countTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"rev message: %@", message);
    
    NSString *str = message;
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"json解析失败");
        return;
    }
    
    NSString *type = [dic objectForKey:@"emit"];
    if ([type isEqualToString:@"chatMessage"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReceiceMessage:)]) {
            [self.delegate chatManager:self didReceiceMessage:dic];
        }
        
        
        if (!isMsgSend) {
            isMsgSend = YES;
            [self performSelector:@selector(notify) withObject:self afterDelay:3];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveSocketMsg" object:nil userInfo:dic];
        });
    }
        
    NSString *heardType = [dic objectForKey:@"type"];
    if (heardType!=nil) {
        [self stopTimer];
        [self heardBeatBack];
        if (!_countTimer) {
            _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerCount) userInfo:nil repeats:YES];
            [_countTimer setFireDate:[NSDate distantPast]];
        }
    }
}

-(void)notify{
    isMsgSend = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNewsMsg" object:nil];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"连接已关闭,reason: %@, clean: %d", reason, wasClean);
    [self closeServer];
    _status = ELWebSocketStatusLogOffByServer;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didReceiceWSStatuChange:)]) {
        [self.delegate chatManager:self didReceiceWSStatuChange:_status];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongData
{
    NSLog(@"rev pong data: %@", pongData);
}

/**
 * @brief   发送文本消息 群聊
 *
 * @param
 * message        文本消息
 * groupModel     社群信息
 * topicId        话题Id
 * tagId          简历评价标签（招聘社群才有）
 * qiId           是否 是招聘文章还是普通文章
 * parentId       话题回复别人评论时才用到
 * CommentType    信息类型 1表示纯文本 3表示富文本
 * contentType    当CommentType=1时，该值为1，表示纯文本； 当CommentType=1时，4表示图片，5表示语音，10表示社群，11表示文章，20表示职位，25表示简历
 * @return
 */
- (void)sendMessage:(NSString *)message GroupModel:(ELGroupDetailModal *)groupModel TopicId:(NSString *)topicId TagId:(NSString *)tagId QiId:(NSString *)qiId ParentId:(NSString *)parentId CommentType:(NSString *)commentType ContentType:(NSString *)contentType share:(NSString *)share
{
    //mine
    NSMutableDictionary *mineDic = [[NSMutableDictionary alloc] init];
    [mineDic setObject:[Manager getUserInfo].name_ forKey:@"username"];
    [mineDic setObject:[Manager getUserInfo].img_ forKey:@"avatar"];
    [mineDic setObject:[Manager getUserInfo].userId_ forKey:@"id"];
    [mineDic setObject:@"true" forKey:@"mine"];
    [mineDic setObject:message forKey:@"content"];
    if (tagId == nil) {
        tagId = @"";
    }
    [mineDic setObject:tagId forKey:@"contentTag"];
    [mineDic setObject:qiId forKey:@"qi_id_isdefault"];
    
    [mineDic setObject:@"APPS_IOS_IPHONE" forKey:@"SYS_SOURCE"];
    [mineDic setObject:@"YL1001_GROUP" forKey:@"SYS_PRODUCT"];
    [mineDic setObject:[NSString stringWithFormat:@"APPS_v%@",ClientVersion] forKey:@"SYS_SOURCE_VERSION"];
    [mineDic setObject:commentType forKey:@"comment_type"];
    [mineDic setObject:contentType forKey:@"comment_content_type"];
    if (share == nil) {
        share = @"";
    }
    [mineDic setObject:share forKey:@"share"];
    
    //to
    NSMutableDictionary *toDic = [[NSMutableDictionary alloc] init];
    [toDic setObject:groupModel.group_name forKey:@"name"];
    [toDic setObject:groupModel.group_name forKey:@"groupname"];
    [toDic setObject:groupModel.group_pic forKey:@"avatar"];
    [toDic setObject:groupModel.group_id forKey:@"id"];
    [toDic setObject:groupModel.group_number forKey:@"group_number"];
    [toDic setObject:topicId forKey:@"topic_id"];
    [toDic setObject:@"group" forKey:@"type"];
    if (parentId == nil) {
        parentId = @"";
    }
    [toDic setObject:parentId forKey:@"parent_id"];
    
    //data
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:mineDic forKey:@"mine"];
    [dataDic setObject:toDic forKey:@"to"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"chatMessage" forKey:@"type"];
    [dic setObject:[Manager getUserInfo].userId_ forKey:@"account_login_id"];
    [dic setObject:app_tun forKey:@"app_run"];
    [dic setObject:dataDic forKey:@"data"];
    
    
    SBJsonWriter *json = [[SBJsonWriter alloc] init];
    NSString *dataStr = [json stringWithObject:dic];
    
    [_webSocket sendString:dataStr error:NULL];
    NSLog(@"sendMessage:%@", dataStr);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatManager:didSendMessage:)]) {
        [self.delegate chatManager:self didSendMessage:mineDic];
    }
}

- (void)requestGroupInfo
{
    NSString *op = @"groups_busi";
    NSString *func = @"getallgroupchar";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@&condition_Arr=", [Manager getUserInfo].userId_];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        NSDictionary *dict = result;
        Status_DataModal *model = [[Status_DataModal alloc] init];
        model.status_ = [dict objectForKey:@"status"];
        model.code_ = [dict objectForKey:@"code"];
        model.des_ = [dict objectForKey:@"status_desc"];
        
        NSArray *groupIdArr = [dict objectForKey:@"data"];
        [self loginChatServer:groupIdArr];
     
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)AFNReachabilityMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"无线网络");
                NSLog(@"WiFi网络");
                if (_status == ELWebSocketStatusClose && _webSocket == nil) {
                    [self openServer];
                    secconds = 0;
                }
                break;
            }
            default:
                break;
        }
    }];
}


@end
