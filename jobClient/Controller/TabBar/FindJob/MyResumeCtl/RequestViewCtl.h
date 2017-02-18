//
//  RequestViewCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-9-25.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"

@protocol RequestViewCtlDelegate <NSObject>

@optional
- (void)getResumePhotoAndVoiceSuccess:(NSArray *)dataArray;

#pragma mark - 上传图片成功
- (void)upLoadImageSuccess:(NSString *)photoId;
- (void)upLoadImageSuccess:(NSString *)photoId withImage:(UIImage *)image;
- (void)upLoadImageSuccess:(NSString *)photoId withImagePath:(NSString *)imagePathStr Image:(UIImage *)image;
#pragma mark - 删除图片回调
- (void)delegatePhotoSuccess;

@end

@interface RequestViewCtl : BaseUIViewController
{
    NSData      *imgData_;
    NSString    *inPhoto_;
    RequestCon      *upResumePhotoCon_;
    RequestCon      *infoCon_;
    RequestCon      *deleteCon_;
    NSMutableArray *tempArr;
}

@property(nonatomic,assign) id<RequestViewCtlDelegate> delegate_;
@property(nonatomic,strong) NSString    *replacePhotoId_;
@property(nonatomic,strong) NSString    *type_;   //1上传图片 2获取图片和语音 3 删除图片

@property(nonatomic,assign) int logotype;

@property(nonatomic,assign) NSString *companyId;

@property(nonatomic,copy)NSString *logoPath;

- (void)upLoadPhotoToService;
- (void)upLoadResumePhoto;

@property(nonatomic,strong) NSString    *requestType;
@end
