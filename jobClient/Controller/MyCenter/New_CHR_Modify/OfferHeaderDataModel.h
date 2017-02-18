//
//  OfferHeaderDataModel.h
//  jobClient
//
//  Created by 一览ios on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OfferPartyTalentsModel;
@interface OfferHeaderDataModel : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *status_desc;
@property (nonatomic, retain) OfferPartyTalentsModel *jobfairInfo;

@end
