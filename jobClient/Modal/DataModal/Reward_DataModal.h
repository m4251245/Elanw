//
//  Reward_DataModal.h
//  jobClient
//
//  Created by YL1001 on 15/11/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "User_DataModal.h"

@interface Reward_DataModal : User_DataModal

@property(nonatomic,copy) NSString *ordcoId;         /**<打赏Id */
@property(nonatomic,copy) NSString *personId;        /**<谁打赏 */
@property(nonatomic,copy) NSString *targetPersonId;  /**<打赏给谁 */
@property(nonatomic,copy) NSString *money;           /**<金额 */
@property(nonatomic,copy) NSString *serviceId;       /**<打赏的类型（鲜花、红包等） */
@property(nonatomic,copy) NSString *buyNums;         /**<打赏的数量 */
@property(nonatomic,copy) NSString *idatetime;       /**<时间 */
@property(nonatomic,copy) NSString *serviceTitle;    /**<礼物名字 */
@property(nonatomic,copy) NSString *serviceUnit;     /**<单位 */

@end
