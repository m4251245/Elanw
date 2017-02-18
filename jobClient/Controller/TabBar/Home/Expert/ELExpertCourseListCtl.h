//
//  ELExpertCourseListCtl.h
//  jobClient
//
//  Created by YL1001 on 15/10/9.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"
#import "Expert_DataModal.h"

@interface ELExpertCourseListCtl : ELBaseListCtl
{
    
    IBOutlet UIImageView *bgImg;         /**< 背景图片 */
    IBOutlet UIImageView *expertImg;     /**< 头像 */
    IBOutlet UIButton *nameBtn;          /**< 名字 */
    IBOutlet UIView *expertIntroBgView;  /**< 简介背景 */
    IBOutlet UILabel *expertIntroLb;     /**< 简介 */
    IBOutlet UIButton *editBtn;          /**< 编辑资料 */
    IBOutlet UILabel *position;          /**< 职位 */
    IBOutlet UIButton *addCourseBtn;     /**< 添加话题 */
    IBOutlet UIButton *ExplainBtn;       /**< 话题服务说明 */
    
}

@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) Expert_DataModal *expertModal;

@end
