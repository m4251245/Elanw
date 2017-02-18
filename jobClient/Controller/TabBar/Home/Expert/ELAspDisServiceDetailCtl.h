//
//  ELAspDisServiceDetailCtl.h
//  jobClient
//
//  Created by YL1001 on 15/9/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface ELAspDisServiceDetailCtl : BaseEditInfoCtl
{
    IBOutlet UIImageView *expertImg;     /**<头像 */
    IBOutlet UILabel *expertName;        /**<姓名 */
    IBOutlet UILabel *expertJob;         /**<职位 */
    IBOutlet UILabel *viewCount;         /**<浏览人数 */
    IBOutlet UILabel *serviceTitle;      /**<话题标题 */
    
    
    IBOutlet UILabel *coursePriceLb;     /**<话题价格 */
    IBOutlet UILabel *courseLongLb;      /**<话题时长 */
    IBOutlet UILabel *countLb;           /**<约谈人数 */
    IBOutlet UILabel *serviceConTV;
    
    IBOutlet UIButton *discussBtn;       /**<约谈按钮 */
    IBOutlet UIView *btnBgView;
}

@property(nonatomic, assign) BOOL isShowBtn;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic,assign) NSInteger backIndex;

@end
