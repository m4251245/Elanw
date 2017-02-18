//
//  PhotoVoiceDataModel.h
//  jobClient
//
//  Created by 一览iOS on 14-9-26.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoVoiceDataModel : NSObject

@property(nonatomic,strong) NSString *photoId_;
@property(nonatomic,strong) NSString *photoSmallPath_;
@property(nonatomic,strong) NSString *photoSmallPath140_;
@property(nonatomic,strong) NSString *photoBigPath_;
@property(nonatomic,strong) NSString *photoPmcId_;
@property(nonatomic,strong) NSString *voiceId_;
@property(nonatomic,strong) NSString *voicePath_;
@property(nonatomic,strong) NSString *voiceTime_;
@property(nonatomic,strong) NSString *voicePmcId_;
@property(nonatomic,strong) UIImage  *image_;
@end
