//
//  MyCenterCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-11.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "MyCenterCtl_Cell.h"
#import "UserInfoCtl.h"
#import "AssociationCtl.h"
#import "MyPubilshCtl.h"
#import "NoLoginCtl.h"
#import "MyQuestionCtl.h"
//#import "MyAnswerCtl.h"
#import "ResumeCenterCtl.h"
#import "MyFollowerCtl.h"
#import "ShareArticleCtl.h"
#import "MyGroupsCtl.h"
#import "PublishTopicCtl.h"
#import "MyAskQuestionCtl.h"
#import "HRLoginCtl.h"
#import "VoiceFileDataModel.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface MyCenterCtl : BaseListCtl<ShowLoginDelegate,MyFollowerCtlDelegate,FollowExpertOkDelegate,AVAudioPlayerDelegate>
{
    RequestCon      * imageCon_;
    RequestCon      * userInfoCon_;
    RequestCon      * isExpertCon_;
    RequestCon      * shareLogsCon_;
    
    UserInfoCtl     * userInfoCtl_;
    AssociationCtl  * associationCtl_;
    MyPubilshCtl    * myPublishCtl_;
    MyQuestionCtl   * myQuestionCtl_;
    //MyAnswerCtl     * myAnswerCtl_;
    ResumeCenterCtl * resumeCenterCtl_;
    MyFollowerCtl   * myFollowerCtl_;
    ShareArticleCtl * shareArticleCtl_;
    MyGroupsCtl     * myGroupsCtl_;
    MyAskQuestionCtl    *myAskQuestionCtl_;
    
    User_DataModal  *  myDataModal_;
    
    IBOutlet    UIView                  *playView_;
    IBOutlet    UIView                  *playBgView_;
    IBOutlet    UIButton                *playBtn_;
    IBOutlet    UILabel                 *timeLb_;
    RequestCon                          *infoCon_;
    VoiceFileDataModel                  *fileModel_;
    ASINetworkQueue                     *queue;
    int                                 index_;
    AVAudioPlayer                       *player;
    NSString                            *isplay_;  //1 播放  0 未播放
    
    IBOutlet    UIImageView                         *meImageview_;
}



@property(nonatomic,weak) IBOutlet UIImageView  * imgBtn_;
@property(nonatomic,weak) IBOutlet UILabel   * nameLb_;
@property(nonatomic,weak) IBOutlet UILabel   * tradeLb_;
@property(nonatomic,weak) IBOutlet UILabel   * jobLb_;
@property(nonatomic,weak) IBOutlet UIImageView * identifyImg_;
@property(nonatomic,weak) IBOutlet UIButton  * followBtn_;
@property(nonatomic,weak) IBOutlet UIButton  * fansBtn_;
@property(nonatomic,weak) IBOutlet UIButton  * publishBtn_;
@property(nonatomic,weak) IBOutlet UIButton  * asscBtn_;
@property(nonatomic,weak) IBOutlet UIButton  * detailBtn_;
@property(nonatomic,weak) IBOutlet UILabel   * follCntLb_;
@property(nonatomic,weak) IBOutlet UILabel   * fansCntLb_;
@property(nonatomic,weak) IBOutlet UILabel   * asscCntLb_;

@property(nonatomic,weak) IBOutlet UILabel   * follTitleLb_;
@property(nonatomic,weak) IBOutlet UILabel   * fansTitleLb_;
@property(nonatomic,weak) IBOutlet UILabel   * asscTitleLb_;

-(void)pushToMyPublish;

-(void)pushToMyGroups;

-(void)checkLogin;

-(void)pushToMyFans;
@end
