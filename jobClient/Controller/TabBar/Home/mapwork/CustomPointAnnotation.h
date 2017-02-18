//
//  CustomPointAnnotation.h
//  jobClient
//
//  Created by 一览iOS on 14-10-10.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomPointAnnotation : MKPointAnnotation

@property(nonatomic,strong) NSString    *companyId_;
@property(nonatomic,strong) NSString    *companyName_;
@property(nonatomic,strong) NSString    *positionId;
@property(nonatomic,strong) NSString    *companyLogo;
@property(nonatomic,assign) int    markTag;
@end
