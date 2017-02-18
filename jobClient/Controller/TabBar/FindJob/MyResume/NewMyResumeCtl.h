//
//  NewMyResumeCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-4.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseResumeCtl.h"
#import "PersonInfo_ResumeCtl.h"
#import "WantJob_ResumeCtl.h"
#import "Edu_ResumeCtl.h"
#import "Works_ResumeCtl.h"
#import "Skill_ResumeCtl.h"
#import "Cer_ResumeCtl.h"
#import "ResumePreviewCtl.h"
#import "Award_ResumeCtl.h"
#import "Leader_ResumeCtl.h"
#import "Project_ResumeCtl.h"

@interface NewMyResumeCtl : BaseResumeCtl<BaseResumeDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PersonInfo_ResumeCtl                *personInfoCtl_;        //基本资料
    WantJob_ResumeCtl                   *wantJobCtl_;           //求职意向
    Edu_ResumeCtl                       *eduCtl_;               //教育背景
    Works_ResumeCtl                     *worksCtl_;             //工作经历
    Skill_ResumeCtl                     *skillCtl_;             //工作技能
    Cer_ResumeCtl                       *cerCtl_;               //证书管理
    Award_ResumeCtl                     *awardCtl_;             //个人奖项
    Leader_ResumeCtl                    *leaderCtl_;            //干部经历
    Project_ResumeCtl                   *projectCtl_;           //项目活动经历
    
    ResumePreviewCtl                    *resumePreviewCtl_;     //预览简历
    IBOutlet    UITableView             *tableView_;
    IBOutlet    UILabel                 *nameLb_;
    IBOutlet    UIButton                *nameBtn_;
    PersonDetailInfo_DataModal          *dataModel_;
}
@property(nonatomic,strong)PersonDetailInfo_DataModal          *dataModel_;
@end
