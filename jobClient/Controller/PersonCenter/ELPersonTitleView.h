//
//  ELPersonTitleView.h
//  jobClient
//
//  Created by 一览iOS on 16/10/11.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonCenterDataModel;
@class ELPersonCenterCtl;

@protocol PersonInfoViewDelegate <NSObject>

-(void)sendInterviewRequest;
-(void)updateLoadImageWithString:(NSString *)string;
-(void)refreshFollewView;
-(void)edtorBaseSuccess;
-(void)refreshData;

@end

@interface ELPersonTitleView : UIView

@property (nonatomic,weak) PersonCenterDataModel *personCenterModel_;
@property (nonatomic,copy) NSString *userId_;
@property (nonatomic,assign) BOOL isMyCenter_;
@property (nonatomic,weak) id <PersonInfoViewDelegate> personDelegate;
@property (nonatomic,assign) CGFloat headMinY;

-(void)refreshFollowLable:(NSInteger)count;
-(void)stopVoice;
-(void)setPersonImageWithUrl:(NSString *)url;

@end
