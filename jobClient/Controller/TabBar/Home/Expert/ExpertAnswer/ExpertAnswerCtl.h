//
//  ExpertAnswerCtl.h
//  Association
//
//  Created by 一览iOS on 14-3-6.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "Expert_DataModal.h"


@interface ExpertAnswerCtl : BaseListCtl
{
    IBOutlet UIView  * headView_;
    IBOutlet UIImageView * imgView_;
    IBOutlet UILabel * nameLb_;
    IBOutlet UILabel * answerCntLb_;
    IBOutlet UILabel * goodatLb_;
    IBOutlet UILabel * jobLb_;
    IBOutlet UILabel * companyLb_;
    IBOutlet UILabel * introLb_;
    IBOutlet UILabel * gznumLb_;
    IBOutlet UIButton * askBtn_;
    IBOutlet UIButton * detailBtn_;
    IBOutlet UIView   * lineView_;
    Expert_DataModal * inModal_;
    BOOL               showDetail_;
    
}

@end
