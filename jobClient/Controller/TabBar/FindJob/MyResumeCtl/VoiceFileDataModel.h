//
//  VoiceFileDataModel.h
//  MBA
//
//  Created by 一览iOS on 14-6-10.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceFileDataModel : NSObject


@property(nonatomic,strong) NSString    *amrPath_;
@property(nonatomic,strong) NSString    *wavPath_;
@property(nonatomic,strong) NSString    *amrName_;
@property(nonatomic,strong) NSString    *wavName_;
@property(nonatomic,strong) NSString    *serverFilePath_;
@property(nonatomic,strong) NSString    *playFilePath_;
@property(nonatomic,strong) NSString    *amrFilePath_;
@property(nonatomic,strong) NSString    *duration_;

@property(nonatomic,strong) NSString    *voiceId_;
@property(nonatomic,strong) NSString    *voiceCateId_;

@end
