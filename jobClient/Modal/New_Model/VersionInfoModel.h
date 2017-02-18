//
//  VersionInfoModel.h
//  jobClient
//
//  Created by YL1001 on 16/7/6.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface VersionInfoModel : PageInfo

@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *itime;


@end
