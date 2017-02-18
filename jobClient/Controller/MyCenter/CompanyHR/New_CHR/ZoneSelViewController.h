//
//  ZoneSelViewController.h
//  jobClient
//
//  Created by 一览ios on 16/8/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHRIndexCtl.h"

typedef enum : NSUInteger {
    ZoneType,//地区
    More_EduType,//学历
    More_AgeType,//年龄
    More_ReadStatusType,//阅读状态
    Other_Type,
} MoreEnumTypeSel;

@protocol ZoneSelDelegate <NSObject>

@optional
-(void)backBtnClicked:(UIButton *)btn;

-(void)rightCellSelected;

@end

@interface ZoneSelViewController : UIViewController

@property(nonatomic,assign)id<ZoneSelDelegate>delegate;

@property(nonatomic,assign)MoreEnumTypeSel moreSelType;

@property(nonatomic,assign)BOOL isZone;

@property (assign, nonatomic) ResumeType resumeType;

-(void)loadData;

@end
