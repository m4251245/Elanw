//
//  CountMsgDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/5/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountMsgDataModel : NSObject

@property (nonatomic, copy) NSString *regtime;                //更新时间
@property (nonatomic, copy) NSString *cmail_box_count;        //申请记录
@property (nonatomic, copy) NSString *resume_read_logs_count; //面试通知
@property (nonatomic, copy) NSString *pfavorite_count;        //收藏记录
@property (nonatomic, copy) NSString *pmailbox_count;         //谁看过我

@end
