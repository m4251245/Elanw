//
//  ExpertDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-18.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Expert_DataModal.h"
#import "ExRequetCon.h"
#import "ExpertDetailAnswerCtl.h"
#import "ExpertPublishCtl.h"
#import "ExpertGroupsCtl.h"
#import "UserInfoCtl.h"
#import "VoiceFileDataModel.h"
#import "ASINetworkQueue.h"


@class ExpertDetailCtl;
@protocol FollowExpertOkDelegate <NSObject>

@optional
-(void)followOk:(ExpertDetailCtl*)ctl ;
- (void)photoChang;

@end


typedef enum
{
    List_Publish,       //发表列表
    List_Answer,        //回答列表
    List_Association,   //社群列表
}ListType;

@interface ExpertDetailCtl : BaseListCtl<UserInfoCtlDelegate>
{
    RequestCon              *imageCon_;  //用于加载图片
    
    
    RequestCon              *followCon_;
    
    RequestCon              *shareLogsCon_;
    
    RequestCon              *visitLogsCon_;
    
    Expert_DataModal        *inDataModal_;
    Expert_DataModal        *myDataModal_;
    //6.20重构
    ExpertDetailAnswerCtl * expertDetailAnswerCtl_;
    ExpertPublishCtl      * expertPublishCtl_;
    ExpertGroupsCtl       * expertGroupsCtl_;
    
    IBOutlet      UIButton      *expertMsgBtn_;
    IBOutlet      UIButton      *expertFansBtn_;
    IBOutlet      UIView        *topView_;
    IBOutlet      UIView        *lineView_;
    IBOutlet      UIButton      *shareBtn_;
    
    
    IBOutlet    UIView                  *playView_;
    IBOutlet    UIView                  *playBgView_;
    IBOutlet    UIButton                *playBtn_;
    IBOutlet    UILabel                 *timeLb_;
    RequestCon                          *infoCon_;
    VoiceFileDataModel                  *fileModel_;
    ASINetworkQueue                     *queue;
    int                                 index_;
    BOOL                                isplay_;
}

@property(nonatomic,weak) IBOutlet UIButton     *segButtonLeft_;
@property(nonatomic,weak) IBOutlet UIButton     *segButtonMiddle_;
@property(nonatomic,weak) IBOutlet UIButton     *segButtonRight_;
@property(nonatomic,weak) IBOutlet UILabel      *leftLb_;
@property(nonatomic,weak) IBOutlet UILabel      *middleLb_;
@property(nonatomic,weak) IBOutlet UILabel      *rightLb_;
@property(nonatomic,weak) IBOutlet UIImageView     *photoImgv_;
@property(nonatomic,weak) IBOutlet UIView       *imgBgView_;
@property(nonatomic,weak) IBOutlet UILabel      *nameLb_;
@property(nonatomic,weak) IBOutlet UILabel      *tradeLb_;
@property(nonatomic,weak) IBOutlet UILabel      *jobLb_;
@property(nonatomic,weak) IBOutlet UILabel      *mottoLb_;
@property(nonatomic,weak) IBOutlet UIButton     *sendLetterBtn_;
@property(nonatomic,weak) IBOutlet UIButton     *followBtn_;
//@property(nonatomic,weak) IBOutlet UISegmentedControl  * segmentedCtl_;
@property(nonatomic,weak) IBOutlet UIButton     *askBtn_;
@property(nonatomic,weak) IBOutlet UIImageView  *isExpertImg_;
@property(nonatomic,weak) IBOutlet UIScrollView *scrollView_;
@property(nonatomic,weak) IBOutlet UIButton     *backBtn_;
@property(nonatomic,assign) id<FollowExpertOkDelegate> delegate_;
@property(nonatomic,assign) ListType            type_;
@property(nonatomic,weak) IBOutlet UILabel      *tradeJobLb_;
@property(nonatomic,assign) BOOL                isMine_;

//change model
-(void) changeModel:(int)index;

//change btn status
-(void) changeBtnStatus:(int)index;


@property(nonatomic,assign) NSString            *inType_;    //入口



@end
