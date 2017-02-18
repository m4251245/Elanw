//
//  ZWModel.h
//  jobClient
//
//  Created by 一览ios on 15/10/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWModel : NSObject

@property (copy,nonatomic)   NSString *jwId;
@property (strong,nonatomic)   NSString *region;    /**<地区 */
@property (strong,nonatomic)   NSString *regionid;    /**<地区 */

@property (strong,nonatomic)   NSString *gznum;    /**<工作经验 */
@property (strong,nonatomic)   NSString *gznumId;    /**<工作经验 */
@property (strong,nonatomic)   NSString *gznumId1;

@property (strong,nonatomic)   NSString *jtzw;    /**<职位名称
 */
@property (strong,nonatomic)   NSString *job;    /**<职位大类 */
@property (strong,nonatomic)   NSString *jobid;    /**<职位大类id */
@property (strong,nonatomic)   NSString *job_child;    /**<职位小类  */
@property (strong,nonatomic)   NSString *job_childid;    /**<职位小类  */
@property (strong,nonatomic)   NSString *deptId;    /**< 部门*/
@property (strong,nonatomic)   NSString *deptName;    /**< 部门*/
@property (strong,nonatomic)   NSString *zpnum;    /**<招聘人数 */
@property (strong,nonatomic)   NSString *salary;    /**<月薪 */
@property (strong,nonatomic)   NSString *zptext;    /**< 职位要求*/
@property (strong,nonatomic)   NSString *email;    /**<接收邮箱 */
@property (strong,nonatomic)   NSString *zp_urlId;    /**<发布网站 开通一览通 */
@property (strong,nonatomic)   NSString *zp_urlName;    /**<发布网站 开通一览通 */
@property (strong,nonatomic)   NSString *eduId;    /**<学历ID */
@property (strong,nonatomic)   NSString *edu;    /**<学历 */


-(ZWModel *)initWithDictionary:(NSDictionary *)dic;

@end
