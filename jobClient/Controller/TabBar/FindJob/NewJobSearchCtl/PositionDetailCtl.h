//
//  PositionDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-6-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseListCtl.h"
#import "WorkApplyDataModel.h"
#import "ZWDetail_DataModal.h"
#import "WebViewJavascriptBridge.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "CareerTailDetailCtl.h"
#import "ShareMessageModal.h"
#import "ELJobSuccessShowCtl.h"

typedef void(^refreshBlock)(NSString *stringId);

@interface PositionDetailCtl : BaseUIViewController<UIWebViewDelegate,MJPhotoBrowserDelegate>
{
    WorkApplyDataModel      *workApplyModel;
    ZWDetail_DataModal      *zwDetailModel_;
    float cellHeight_;
    IBOutlet        UIView *bottomView_;   //底部视图
    RequestCon      *applayCon_;      //用于申请职位
    RequestCon      *collectionCon_;  //用于收藏职位
    RequestCon      *shareLogsCon_;
    BOOL            bReloadBySelf_;
    
//    IBOutlet            UIWebView       *webView_;
    IBOutlet            UIButton        *backBtn_;
    IBOutlet            UIButton        *closeBtn_;
    NSString       *positionId_;
    NSString       *companyId_;
    NSString       *position3GUrl_;
    NSString       *positionName_;
    WebViewJavascriptBridge     *bridge;
    NSString        *imageItemString_;
    NSString        *imageListString_;
    NSArray         *imageArray_;
    MJPhotoBrowser          *photoBrowser_;
    RequestCon              *positionUrlCon_;
    UIActivityIndicatorView   *activityView_;
    RequestCon              *positionNameCon_;
    
    RequestCon              *schoolZPShareUrlCon_;
    
    BOOL                    canapplay;
    BOOL                    cancollection;
    ShareMessageModal *shareModal;
    ELJobSuccessShowCtl *jobSuccessCtl;
}

@property (nonatomic,assign) NSInteger   type_;
@property (assign, nonatomic) BOOL offerPartyFlag;
@property (assign, nonatomic) BOOL jobManager;
@property (nonatomic,weak) IBOutlet UIButton *applyBtn_;
@property (nonatomic,assign) BOOL showJobSuccessView;

@property (nonatomic,copy) refreshBlock freshBlock;
@property (nonatomic,strong) CareerTailDetailCtl *careerCtl;
@property (nonatomic,assign) BOOL isXjh;
@property (nonatomic,assign) BOOL isConsultantFlag;

@property (nonatomic,assign) BOOL isPop;

@property (nonatomic,assign) BOOL backTwoTier;

@end
