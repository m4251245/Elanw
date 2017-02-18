//
//  ELGroupLikePersonModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/2.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"

@interface ELGroupLikePersonModel : PageInfo

@property (nonatomic, copy) NSString *person_zw;
@property (nonatomic, copy) NSString *person_nickname;
@property (nonatomic, copy) NSString *person_iname;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *person_pic;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
