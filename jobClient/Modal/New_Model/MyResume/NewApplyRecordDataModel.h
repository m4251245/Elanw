//
//  NewApplyRecordDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/6/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface NewApplyRecordDataModel : PageInfo
@property (nonatomic, copy) NSString *bsp_iname;
@property (nonatomic, copy) NSString *sendname;
@property (nonatomic, copy) NSString *zptype;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *jobid;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *senduid;
@property (nonatomic, copy) NSString *bsp_id;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *newmail;
@property (nonatomic, copy) NSString *viewId;
@property (nonatomic, copy) NSString *readnum;
@property (nonatomic, copy) NSString *sdate;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *tradeid;
@property (nonatomic, copy) NSString *bsp_pic;
@property (nonatomic, copy) NSString *pstatus;
@property (nonatomic, copy) NSString *jtzw;
@property (nonatomic, copy) NSString *reid;

@property (nonatomic, copy) NSString *lastviewtime;
@property (nonatomic, copy) NSString *readtime;
@property (nonatomic, copy) NSString *sendtime;
@property (nonatomic, copy) NSString *collecttime;
@property (nonatomic, copy) NSString *unqualtime;
@property (nonatomic, copy) NSString *mailtime;

@property (nonatomic, assign) BOOL showMessageView;
@end
