//
//  ELJobSearchCondictionChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 15/11/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "Constant.h"

typedef enum
{
    HideViewType,
    RegionChange,
    TradeChange,
    SalaryMonthChange,
    MoreChange,
    XJHRegionChange,
    XJHSchoolChange,
    XJHTimeChange,
    ExperienceChange,
    OfferPaiRegionChange,
    OfferPaiJobChange,
    AgeChange,
    EducationChange,
    Range_ChooseChange,
    GWexperienceChooseChange,
    GWTradeChooseChange,
    GWMyresumeListPositionChange,
}CondictionChangeType;

@protocol changeJobSearchCondictionDelegate <NSObject>

-(void)changeCondiction:(CondictionChangeType)changeType dataModel:(id)dataModel;
@optional
-(void)cancelChangeDelegate;
-(void)hideSuccessDelegate;

@end

@interface ELJobSearchCondictionChangeCtl : UIViewController

@property (nonatomic,strong) NSMutableArray *gwPositionArr;

@property(nonatomic,weak) id <changeJobSearchCondictionDelegate> delegate_;
@property(nonatomic,assign) CondictionChangeType currentType;

-(void)creatViewWithType:(CondictionChangeType)condictionType selectModal:(id)selectKeyWord;
-(void)hideView;
-(void)showView;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)setBackViewBlackColor;

@end
