//
//  ELMyAspectantDiscussCtl.h
//  jobClient
//
//  Created by YL1001 on 15/9/6.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "PageInfo.h"
#import "ELAspectantDiscuss_Modal.h"
#import "UIImageView+WebCache.h"
#import "ELRequest.h"

@interface ELMyAspectantDiscussCtl : BaseListCtl
{
    ELRequest *appraiseCon;
    
    IBOutlet UIView *btnBgView;    /** <按钮导航 */
    
    UIImageView *redLine; /** <小红条 */
    IBOutlet UIButton *proceedBtn; /** <进行中 */
    IBOutlet UIButton *endBtn;     /** <已结束 */
    
    IBOutlet UIView *noDataView;
    IBOutlet UIButton *goToLookBtn;
    
    NSInteger productType;
}
//@property (nonatomic, strong)PageInfo *pageInfo;

@end
