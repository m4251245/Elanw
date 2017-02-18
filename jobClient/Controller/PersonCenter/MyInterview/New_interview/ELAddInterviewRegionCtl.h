//
//  ELAddInterviewRegionCtl.h
//  jobClient
//
//  Created by YL1001 on 15/11/4.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELInterViewAdressCtl.h"

@protocol AddInterviewRegionCtlDelegate <NSObject>

- (void)addInterviewRegionSuccess;
@end

@interface ELAddInterviewRegionCtl : BaseEditInfoCtl<chooseAddressDelegate>
{
    IBOutlet UIButton *commitBtn;  /**<提交 */
    IBOutlet UIButton *addTimeAndPlaceBtn; /**<添加时间地点 */
  
    IBOutlet UIView *confirmView;   /**<提交View */
    IBOutlet UIButton *confirmBtn;
    IBOutlet UIButton *cancelBtn;
    
    ELAspectantDiscuss_Modal *aspDataModal;
}

@property (nonatomic, weak) id<AddInterviewRegionCtlDelegate> delegate;

@end
