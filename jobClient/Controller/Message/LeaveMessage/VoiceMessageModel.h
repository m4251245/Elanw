//
//  VoiceMessageModel.h
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceMessageModel : NSObject

@property(nonatomic,strong)NSString *localVoiceName;
@property(nonatomic,strong)NSString *localVoicePath;
@property(nonatomic,strong)NSString *duration;
@property(nonatomic,strong)NSString *servicePathUrl;


@end
