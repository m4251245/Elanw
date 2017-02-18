//
//  DDLocate.h
//  DDMates
//
//  Created by ShawnMa on 12/27/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

@interface TSLocation : NSObject

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *id_;

@end
