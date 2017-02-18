//
//  CompanyHRCtl.h
//  jobClient
//
//  Created by YL1001 on 14-9-5.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "CompanyInfo_DataModal.h"
#import "CompanyResumeCtl.h"
#import "CompanyQuestionCtl.h"
#import "ServiceInfoCtl.h"
#import "ChosseInterviewModelCtl.h"
#import "PushUrlCtl.h"
#import "ComColllectResumeCtl.h"
#import "DownloadResumeListCtl.h"


@interface CompanyHRCtl : BaseUIViewController<ChooseInterviewModelDelegate,CompanyResumeReadDelegate>
{
    IBOutlet  UILabel      *  resumeCntLb_;
    IBOutlet  UILabel      *  collectionCntLb_;
    IBOutlet  UIButton     *  resumeBtn_;
    IBOutlet  UIButton     *  collectionBtn_;
    IBOutlet  UIScrollView *  scrollView_;
    IBOutlet  UIButton     *  chooseZwBtn_;
    IBOutlet  UIButton     *  moreBtn_;
    IBOutlet  UIButton     *  recommendBtn_;
    IBOutlet  UILabel      *  recommendCntLb_;

    CompanyInfo_DataModal  *  myModal_;
    
    ChosseInterviewModelCtl * chooseZWCtl_;
    
    CompanyQuestionCtl     * companyQuestionCtl_;
    ComColllectResumeCtl   * comCollectResumeCtl_;
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
}
@property(nonatomic,assign) int        modelIndex_;

@property (nonatomic,strong) CompanyResumeCtl       * companyResumeCtl_;
@property (nonatomic,strong) CompanyResumeCtl       * companyRecommendedResumeCtl_;//推荐给企业的建立
@property (nonatomic,strong) DownloadResumeListCtl  * downloadResumeListCtl_;
//change model
-(void) changeModel:(int)index;

//change btn status
-(void) changeBtnStatus:(int)index;

-(void)updateCount:(CompanyInfo_DataModal*)dataModal;

@end
