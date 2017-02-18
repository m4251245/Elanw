//
//  PreBaseUIViewController.h
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
		
		Ctl Base Class
 
 ***************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "BaseUINavigationController.h"
#import "PreRequestCon.h"
#import "NoDataErrorCtl.h"
#import "InReloadDataCtl.h"
#import "PreMyDataBase.h"
#import "RequestCon.h"
#import "ExRequetCon.h"

//性别类型
typedef enum
{
    Boy,
    Girl,
}SexState;

////load state
//typedef enum{
//	FinishLoad,
//	ErrorLoad,
//	InReload,
//	InLoadMore,
//}LoadStats;

//choose alert type
typedef enum{
	AlertNullType,
    
    ChooseLogin,                //登录
    ChooseOff,                  //注销
    Choose_GivePoint,           //评分
    Choose_ShowMapRount,        //显示线路
    Choose_ReTest,              //进行测试
    Choose_AddCompanySubscribe, //订阅企业
    Choose_AddSchoolSubscribe,  //订阅学校
    Choose_DelPersonImage,      //删除个人图像
    Choose_DelSingleCtl,        //删除某项
    Choose_DoneResume,          //完善简历
    Choose_School,              //选择学校
    Choose_AttentionSchool,     //关注某学校
    Choose_UnAttentionSchool,   //取消关注某学校
    Choose_ReSetSchool,         //重设自己的学校
}ChooseAlertViewType;

//中断类型
typedef enum
{
    NullInterrupt,
    LoginInterrupt,
}InterruptType;

//新评论类型
typedef enum
{
    CommonReplyType,    //通用类型
    ProfessPowerType,   //职业的力量类型
    CompanyReplyType,   //企评回复
}MyCommentType;

//分享时需要实现的协议
@protocol ShareProtol <NSObject>

@required
-(NSString *) bodyMsgAtMFMessage;               //获取自己的消息

-(NSString *) webContentMsg;                    //徽博内容

@end

@interface PreBaseUIViewController : UIViewController<PreLoadDataDelegate,NoDataErrorDelegate,UISearchBarDelegate,UINavigationControllerDelegate,ShareProtol,LoadDataDelegate> {
    IBOutlet    UISearchBar         *searchBar_;
    IBOutlet    UIButton            *searchBtn_;
    IBOutlet    UIView              *cancelSearchView_;
    BOOL                            bShowCancelView_;
    
    //nav
//    BaseUINavigationController      *navCtl_;
    PreBaseUIViewController            *pushedCtl_;                //被自己pushed的ctl
    
    UIImageView                     *bgView_;
    
    //show com flag
    BOOL                            bNeedUpdateComInfo_;
    
    //delete falg
    BOOL                            bDelete_;
    
    //UIBarButtonItem/btn
    NSString                        *leftBarItemStr_;           //左按扭str
    NSString                        *rightBarItemStr_;          //右按扭str
    UIBarButtonItem                 *leftBarItem_;              //导航的左按扭
    UIBarButtonItem                 *rightBarItem_;             //导航的右按扭
    UIBarButtonItem                 *backBarItem_;              //导航的返回按扭
    UIButton                        *leftBarBtn_;               //左按扭
    UIButton                        *rightBarBtn_;              //右按扭
    UIButton                        *backBarBtn_;               //返回按扭
    
    //load data
	LoadStats						loadStats_;                 //load stats
	id								myParam_;
	id								exParam_;
    NoDataErrorCtl					*noDataErrorCtl_;           //no data error ctl
    InReloadDataCtl                 *inReloadDataCtl_;          //in reload data ctl
	PreRequestCon						*PreRequestCon_;               //request con
    BOOL                            bPreRequestCon_;               //request con flag
    ErrorCode                       errorCode_;                 //error code
	NSDate							*lasterLoadDate_;           //laster load date
	int								validateSeconds_;           //validate seconds
	BOOL                            bFresh_;    
    
    PreRequestCon                      *initOpCon_;
    PreRequestCon                      *prePreRequestCon_;            //上次请求的PreRequestCon
    NSString                        *preSoapMsg_;               //上次请求的soapMsg
    NSString                        *preTableName_;             //上次请求的tableName
    
    RequestCon                      *requestCon_;
    
//    //Interrupt Operation
//    id                              interruptId_;               //interrupt id
//    int                             interruptIndex_;            //interrupt index
//    SEL                             interruptSel_;              //interrupt id
}

@property(nonatomic,retain) UISearchBar                     *searchBar_;
@property(nonatomic,retain) UIButton                        *searchBtn_;
@property(nonatomic,retain) UIView                          *cancelSearchView_;
//@property(nonatomic,retain) BaseUINavigationController      *navCtl_;
@property(nonatomic,retain) PreRequestCon                      *PreRequestCon_;
@property(nonatomic,retain) NSString                        *leftBarItemStr_;
@property(nonatomic,retain) NSString                        *rightBarItemStr_;
@property(nonatomic,assign) LoadStats                       loadStats_;
@property(nonatomic,assign) id                              interruptId_;
@property(nonatomic,assign) int                             interruptIndex_;
@property(nonatomic,assign) SEL                             interruptSel_;

//show alert view(just one btn)
+(void) showAlertView:(NSString *)title msg:(NSString *)msg btnTitle:(NSString *)btnTitle;

//让提示框自动消失
+(void) showAutoLoadingView:(NSString *)title msg:(NSString *)msg seconds:(float)seconds;

//时间到了让提示框消失
+(void) dimissAlertView:(UIAlertView *)alertView;

//show/hide loading view
+(void) showLoadingView:(BOOL)flag title:(NSString *)title;

//获取一个请求类(validateSeconds数据有效期)
-(RequestCon *) getNewRequestCon:(BOOL)bDefault;

//显示
-(void) show;

//隐藏
-(void) hide;

//打电话
-(void) giveCall:(NSString *)number;

//获取显示loading时的text
-(NSString *) getLoadingText:(PreRequestCon *)con type:(XMLParserType)type;

//更改背景
-(void) changeBG:(NSString *)imageName;

//获取背景图片的name
-(NSString *) getBGName;

//设置背景
-(UIImageView *) setBG:(NSString *)imageName;

//设置searchBar BG
-(UIImageView *) setSearchBarBG:(NSString *)imageName;

//show choose alert view
-(void) showChooseAlertView:(ChooseAlertViewType)type title:(NSString *)title msg:(NSString *)msg okBtnTitle:(NSString *)okBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle;

//show/hide cancel searchBarView
-(void) showCancelSearchBarView:(BOOL)flag animated:(BOOL)animated;

//UIAlertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

//alert view choosed
-(void) alertViewChoosed:(UIAlertView *)alertView index:(NSInteger)index type:(ChooseAlertViewType)type;

//alert view choosed cancel
-(void) alertViewCancel:(UIAlertView *)alertView index:(NSInteger)index type:(ChooseAlertViewType)type;

////outlet view release
//-(void) viewRelase;

//get No Data Error View's super view
-(UIView *) getNoDataErrorSuperView;

//get in load view's super view
-(UIView *) getInReloadSuperView;

//get in reload text
-(NSString *) getInReloadText;

//show/hide no data error view
-(void) showNoDataErrorView:(BOOL)flag;

//show/hide in reload data view
-(void) showInReloadDataView:(BOOL)flag;

//begin load data
-(void) beginLoad:(id)dataModal exParam:(id)exParam;

//refresh data(it will load the data)
-(void) refreshData:(id)dataModal exParam:(id)exParam;

//清除有效期,让自己可以重新载入数据
-(void) clearLoadDataDate;

//searchBar's search
-(void) beginSearch;

//can get data
-(BOOL) canGetData;

//weill Load data
-(void) willLoadData;

//get data fun
-(void) getDataFunction;

//need process error
-(BOOL) needProcessError:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type;

//error get data
-(void) errorGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type;

//finish get data
-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr;

//start push(ctl is the will push ctl)
-(void) startPush:(UIViewController *)ctl;

//be pushed(ctl is the super ctl)
-(void) bePushed:(UIViewController *)ctl;

//start pop
-(void) startPop;

//pop done
-(void) donePop;

//be poped(ctl is the super ctl)
-(void) bePoped:(UIViewController *)ctl;

//init res
-(void) initResources;

//release res
-(void) releaseResources;

//update com info
-(void) updateComInfo:(PreRequestCon *)con;

//IBAction
-(IBAction) buttonClick:(id)sender;

//button real response fun
-(void) buttonResponse:(id)sender;

//back bar btn
-(void) backBarBtnResponse:(id)sender;

//left bar btn
-(void) leftBarBtnResponse:(id)sender;

//right bar btn
-(void) rightBarBtnResponse:(id)sender;

//set left bar btn title
-(void) setLeftBarBtnTitle:(NSString *)str;

//set left bar btn title
-(void) setRightBarBtnTitle:(NSString *)str;
//check the interrupt
-(InterruptType) checkInterrupt:(id)sender;

//make interrupt
-(void) makeInterrupt:(InterruptType)type sender:(id)sender backFun:(SEL)sel;

//return to interrupt
-(void) returnInterrupt;

//back to interrupt
-(void) backInterrupt;

//cancel interrupt
-(void) cancelInterrupt;

//check myView whether contain checkView
-(BOOL) checkSubView:(UIView *)myView checkView:(UIView *)checkView;

//get checkView
-(UIView *) getSubView:(UIView *)myView checkIndex:(int)index;

//提示用户是否开始完善简历
-(void) showFinishResumeAlertView:(NSString *)title msg:(NSString *)msg;

//显示登录
-(void) showLoginCtl;
//设置标题
- (void)setNavTitle:(NSString *)title;

@end

//DB
extern PreMyDataBase *myDB;
