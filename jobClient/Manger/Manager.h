//
//  Manager.h
//  MBA
//
//  Created by sysweal on 13-11-9.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

/******************************
 
 所有的ctl管理类
 Manager
 
 ******************************/

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "User_DataModal.h"
#import "MyJobSearchCtl.h"
#import "AskDefaultCtl.h"
#import "Common.h"
#import "LoginCtl.h"
#import "ConsultantHRDataModel.h"
#import "LeaveMessage_DataModel.h"
#import "RegCtl.h"
#import "NoLoginCtl.h"
#import "ExpertAnswerCtl.h"
#import "AnswerDetailCtl.h"
#import "RegionCtl.h"
#import "OfferPartyDetailIndexCtl.h"
#import "ArticleDetailCtl.h"
#import "CondictionPlaceCtl.h"
#import "CondictionPlaceSchoolCtl.h"
#import "CondictionZWCtl.h"
#import "CondictionTradeCtl.h"
#import "PushUrlCtl.h"
#import "CreaterGroupCtl.h"
#import "ModalViewController.h"
#import "SubscribedJobsCtl.h"
#import "MyAQListCtl.h"
#import "CommentMessageListCtl.h"
#import "InviteListCtl.h"
#import "SystemNotificationCtl.h"
#import "MyAudienceListCtl.h"
#import "WorkApplyRecordListCtl.h"
#import "LeaveMessageListCtl.h"
#import "JobFairDetailCtl.h"
#import "AFNetworking.h"
#import "MessageCenterList.h"
//#import "SalaryCtl2.h"
#import "CondictionTradeCtlOld.h"
#import "MyManagermentCenterCtl.h"
#import "MessageRefreshCtl.h"
#import "ELMyGroupCenterCtl.h"
#import "OfferPartyInterviewTipsCtl.h"
#import "NSString+Size.h"
#import "RecommendGroupsCtl.h"
#import "NoLoginPromptCtl.h"
#import "ConsultantCenterCtl.h"
#import "MessageContact_DataModel.h"
#import "MessageDailogListCtl.h"
#import "AD_dataModal.h"
#import "SameTradeListCtl.h"
#import "TodayFocusListCtl.h"
#import "ExpertPublishCtl.h"
#import "PhotoListCtl.h"
#import "SalaryCompeteCtl.h"
//#import "SalaryIrrigationCtl.h"
#import "SalaryIrrigationDetailCtl.h"
@class ELJobSearchCondictionChangeCtl;
@class RootTabBarViewController;
//#define BG_Center_Nav                   @"bg_title.png"//@"bg_nav.png"
//#define BG_Right_Nav                    @"bg_nav_right.png"
//
//#define BaseURLForAF                    @"http://120.132.146.117/webservice/index.php?gtype=http"

@class RootTabBarViewController;

typedef enum{
    APPEnterAPPCon,   //APP前台
    APPEnterForMessage,  //APP在后台
}  APPState;

typedef enum{
    LoginFromOther,  //来自其他页面登录
    LoginFromMycenter, //来自我的
}LoginFromCtl;

typedef void(^GetAccessStatusBlock)();

@class Manager,TabBarView;
@class RootNavigationController;
//TabViewDelegate
@interface Manager : BaseUIViewController<UINavigationControllerDelegate,EAIntroDelegate,UIAlertViewDelegate>{
//    LoginCtl                *loginCtl_;             //登录
//    TabView                 *tabView_;              //tab view
    UINavigationController  *centerNav_;             //中间切换导航控制
    ModalViewController     *modalCtl_;
    
}
@property(nonatomic,assign)BOOL isNeedRefresh;
@property(nonatomic,assign)BOOL isFirstLoading;
@property(nonatomic,strong) RootTabBarViewController *tabVC;
//需要用到的标记
@property(nonatomic,strong) NSString            *apnsType;   //推送Type
@property(nonatomic,strong) NSString            *apnsTypeId;   //推送id
@property(nonatomic,assign) BOOL                 pushViewFlag;   //是否需跳转
@property(nonatomic,assign) BOOL                isLaunch; //是否通过通知栏启动
@property(nonatomic,strong) NSString            *version_;
@property(nonatomic,strong) NSString            *wxCode;
@property(nonatomic,assign) BOOL                bLRegion_;
//@property(nonatomic,assign) APPState           appState;
@property(nonatomic,assign) int                 messageCnt_;
@property(nonatomic,assign) BOOL                noVisit_;     //随便看看标记
@property(nonatomic,assign) BOOL                haveLogin;    //是否已经登录标记
@property(nonatomic,assign) BOOL                showModal_;   //显示发现页面的功能引导标记
@property(nonatomic,assign) BOOL                showModal2_;  //显示薪指页面的功能引导标记
@property(nonatomic,assign) int                 tabType_;
@property(nonatomic,assign) BOOL                bAccountChanged_;  //账号是否更改了
@property(nonatomic,assign) BOOL     showTipsViewFlag;    //是否显示提示消失的view;
@property(nonatomic,strong) NSString            *totalCount;     //小红点数量
@property(nonatomic,strong) Message_DataModal      *messageCountDataModal;     //消息数量model
@property(nonatomic,assign) RegisteType         registeType_; //注册来源
@property(nonatomic,strong) NSString            *regionName_;
@property(nonatomic,strong) NSString            *groupCount_; //还可以创建的社群数量
@property(nonatomic,strong) MessageRefreshCtl   *messageRefreshCtl;
//一些公用的ctl
//@property (nonatomic,strong) RootTabBarViewController *tabVC;
@property (nonatomic,strong) LoginCtl                 *loginCtl_;//登录页面的ctl
@property (nonatomic,strong) UINavigationController   *centerNav_;     //中间视图的navCtl
//tabbar框架下的五个Ctl
@property (nonatomic,strong) MessageCenterList      *messageCenterListCtl; //消息页面
@property (nonatomic,strong) MyJobSearchCtl         *findJobCtl_;    //求职页面的ctl
@property (nonatomic,strong) TodayFocusListCtl      *todayFocusListCtl;  //同行页面的ctl
@property (nonatomic,strong) MyManagermentCenterCtl *myCenterCtl;   //我的管理中心
@property (nonatomic,strong) ELMyGroupCenterCtl     *myGroupCtl_;
@property (nonatomic,assign) BOOL                   isBackstage;

//main模块下的消息
@property (nonatomic,strong) MyAQListCtl              *myAQListCtl_;            //问答页面的ctl
@property (nonatomic,strong) CommentMessageListCtl    *commentMessageListCtl_;  //最新评论消息的ctl
@property (nonatomic,strong) InviteListCtl            *inviteListCtl_;          //社群消息的ctl
@property (nonatomic,strong) SystemNotificationCtl    *sysNotificationCtl_;     //系统通知页面的ctl
@property (nonatomic,strong) MyAQListCtl              *notiCtl_;                //新通知页面的ctl
@property (nonatomic,strong) LeaveMessageListCtl      *leaveMessageListCtl_;    //留言页面的ctl
@property  (nonatomic,strong) RecommendGroupsCtl      *recGroupsCtl_;           //推荐社群页面的ctl

@property (nonatomic,strong) NoLoginCtl               *noLoginCtl_;//未登录页面的ctl,在社群专家动态页面显示
@property (nonatomic,strong) NoLoginCtl               *nologinCtl_;//未登录页面的ctl，在个人中心页面显示
@property (nonatomic,strong) SalaryCompeteCtl         *salaryCommpeteCtl_;//薪资比拼页面的ctl
@property (nonatomic,strong) AnswerDetailCtl          *answerDetailCtl_;//问答详情页面的ctl
@property (nonatomic,strong) RegionCtl                *regionListCtl_;//选择地区页面的ctl
@property (nonatomic,strong) ModalViewController      *modalCtl_;
@property (nonatomic,strong) ArticleDetailCtl         *articleDetailCtl_;//发表文章详情页面的ctl
@property (nonatomic,strong) SubscribedJobsCtl        *subscribedJobsCtl_;

@property (nonatomic,strong) CreaterGroupCtl          *groupCreateCtl_;
@property (nonatomic,strong) WorkApplyRecordListCtl   *workApplyRecordListCtl_;   //申请记录
@property (nonatomic,strong) NSDictionary *noLoginDic;

//推送中接收到的需要公用的datamodal
@property (nonatomic,strong) News_DataModal           * pushNewsData_;//记录推送中的薪闻信息
@property (nonatomic,strong) Answer_DataModal         * pushAnsweredData_;//记录推送中的被回答的问题信息
@property (nonatomic,strong) Answer_DataModal         * pushQuestionData_;//记录推送中的新的提问的消息
@property (nonatomic,strong) Article_DataModal        * pushExpertArticleData_;//记录推送中的行家发表文章信息
@property (nonatomic,strong) Article_DataModal        * pushAssArticleData_;//记录推送中的社群发表文章信息
@property (nonatomic,strong) Groups_DataModal          * pushGroupsData_;//记录推送中的社群信息

@property(nonatomic,assign) BOOL                        isThridLogin_;   //判断是否为第三方登录
@property(nonatomic,assign) BOOL                        isFromMessage_;

@property(nonatomic,assign) int                        payType;//支付种类，0默认简历购买，1查薪指购买, 2简历直推

@property(nonatomic,assign) NSInteger dashangBackCtlIndex;
@property(nonatomic,assign) BOOL isShowRewardAnimat;
@property(nonatomic,strong) id yuetanBackCtl;
@property(nonatomic,strong) id yuetanListBackCtl;

@property(nonatomic,assign) NSInteger creatGroupStartIndex;

@property(nonatomic,assign) BOOL                       showLoginBackBtn;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *adView;

@property(nonatomic,strong) NSString *offerPartyInterviewTuiSContent;
@property (nonatomic,strong) OfferPartyInterviewTipsCtl *offerTipsCtl;

extern PreCondictionListCtl        *preCondictionListCtl;
extern CondictionPlaceCtl       *condictionPlaceCtl;
extern CondictionPlaceSchoolCtl *condictionPlaceSchoolCtl;
extern CondictionZWCtl          *condictionZWCtl;
//extern CondictionTradeCtlOld    *condictionTradeCtl;
extern CondictionTradeCtl       *hrCondictionTradeCtl;

@property(nonatomic,strong) PersonCenterDataModel *userCenterModel;


@property(nonatomic,assign) LoginFromCtl loginFromCtl;
@property(nonatomic,assign) BOOL isPublishReginfoCtl;

@property(nonatomic,strong)TabBarView *tabBarView;

@property(nonatomic,copy) NSString *openAppArticleId;//标识通过网页打开app，文章编号
@property(nonatomic,strong) ZWDetail_DataModal *openAppZwModel;//标识通过网页打开app，职位模型
@property(nonatomic,strong) NSString *openAppPersonId;//标识通过网页打开app，用户编号
@property(nonatomic,strong) NSString *openAppGroupId;//标识通过网页打开app，社群编号
@property (nonatomic, strong) Article_DataModal *openAppArticleModal;//标识通过网页打开app,社群话题模型
@property (nonatomic, strong) NSString *openAppQuestionId;//标识通过网页打开app，问题编号
@property (nonatomic, strong) NewCareerTalkDataModal *openAppTeachinsModel;//标识通过网页打开app，宣讲会、招聘会模型
@property (nonatomic, strong) ELSalaryModel *openAppSalaryModel;//标识通过网页打开app，灌薪水模型
@property (nonatomic, strong) NSString *openAppType;//跳转类型 根据这个字段跳转


@property(nonatomic,copy) NSString *openAppUrl;
@property(nonatomic,strong) NSArray *url3gArr;

@property(nonatomic,strong) AccessToken_DataModal *accessTokenModal;
@property(nonatomic,strong) AccessToken_DataModal *accessTokenNewModal;
@property(nonatomic,strong) AccessToken_DataModal *accessTokenThreeModal;
@property(nonatomic,strong) AccessToken_DataModal *accessTokenFourModal;

@property(nonatomic,weak) ELJobSearchCondictionChangeCtl *searchChangeCtl;


//获取公用的管理类
+(Manager*) shareMgr;

//开始
-(void) begin:(UIWindow *)window;

//是否已经显示提示页
//+(BOOL) haveShowLogo;

//请求token
-(void)requestToken;

//注册推送
-(void)registNotificeCon:(NSString *)deviceToken  user:(NSString*)userId clientName:(NSString*)clientName startHour:(int)startHour  endHour:(int)endHour clientVersion:(NSString*)clientVersion betweenHour:(int)betweenHour;

//是否已经登录
+(BOOL) checkLogin;

//设置登录信息
+(void) setUserInfo:(User_DataModal *)dataModal;

//获取登录信息
+(User_DataModal *) getUserInfo;

////发现了新版本
//-(void) findNewVersion;

//是否已经显示提示页
+(BOOL) haveShowLogo :(BOOL)flag;

//设置登录信息
+(void) setHrInfo:(ConsultantHRDataModel *)dataModal;

//获取登录信息
+(ConsultantHRDataModel *) getHrInfo;

//显示导航页
-(void) showLogo:(BOOL)animated;

//显示登录
-(void) showLogin:(BOOL)animated;

//注销了
-(void) loginOut;

//重新登录了
-(void) haveReLogin:(int)status;

//随便看看
-(void)visitNoLogin;

//接收到推送消息后
-(void) receiveRemoteNotification:(NSDictionary *)userInfo;

-(void)getCity;

-(NSString *)getVersion;

-(void)markUserStatus:(int)status;

//显示广告
-(void)showADView;

//显示评价引导页
-(void)showSayViewWihtType:(NSInteger)type;

//点赞数量统计方法
+(BOOL)getIsLikeStatus:(NSString *)articleId;
+(void)clearLikeData;
+(void)saveAddLikeWithAticleId:(NSString *)articleId;
+(void)deleteLikeDate:(NSString *)articleId;
//无法获取跳转视图时的跳转方法
-(void)pushWithCtl:(id)ctl;
-(void)selectdVCWithIndex:(NSInteger)index;
//转换字符串中的表情字符
-(NSMutableAttributedString *)getEmojiStringWithString:(NSString *)str withImageSize:(CGSize)imageSize;
-(NSMutableAttributedString *)getEmojiStringWithAttString:(NSMutableAttributedString *)str withImageSize:(CGSize)imageSize;

+(void)getRequestCanCreatGroupCountWith:(NSString *)userId;

-(void)openApp3GPushCtl;

#pragma mark - 修改webview的UserAgent
+(void)changeWebViewUserAgent;

#pragma mark - 获取相机权限
-(BOOL)getTheCameraAccessWithCancel:(GetAccessStatusBlock)cancel;
-(BOOL)getAddressBookAccessStatusWithCancel:(GetAccessStatusBlock)cancel;
-(BOOL)getPhotoAccessStatusWithCancel:(GetAccessStatusBlock)cancel;
#pragma mark - 获取可访问3g域名
-(void)requestAdUrl3GArr;
-(NSArray *)getUrlArr;

//请求token
-(void)configToken:(AccessTokenType)tokenType userName:(NSString *)user pwd:(NSString *)pwd modelType:(AccessToken_DataModal *)model baseUrl:(NSString *)baseUrl;

@end
