//
//  SelectTypeViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/29.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PositionType,//职位
    DeliverStatusType,//投递应聘状态
    ExperenceType,//经验
    DeliverMoreType,//更多
    ELTimesType,//一览精选场次
    DownStatusType,//主动下载状态
    AgeType,//年龄
    SelectType,//筛选
    EduType,//学历
    WorkAgeAll, //工作年限
    Turn_Status, //转发给我状态
    read_Status,//阅读状态
    
} SelectionType;

@class CondictionList_DataModal;

@protocol SelDelegate <NSObject>

-(void)moreSelBtnClick:(NSIndexPath *)indexPath;

@end

@interface SelectTypeViewController : UIViewController

@property(nonatomic,copy)NSString *companyId;

@property(nonatomic,assign)SelectionType selecType;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,copy) void (^selectBolck)(id data);

@property(nonatomic,retain)UIView *bgView;

@property(nonatomic,assign)id<SelDelegate>delegate;

@property(nonatomic,assign)BOOL isGuwen;

@property(nonatomic,assign)NSInteger deliverType;//0 投递应聘    2 一览精选

-(void)loadData;

@property (nonatomic, strong) CondictionList_DataModal *condictionList_DataModal;
@end
