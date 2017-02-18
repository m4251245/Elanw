//
//  ELRecommendReportDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/11/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

@protocol ELRecommentSuccessRefreshDelegate <NSObject>
    
-(void)recommentSuccessRefresh;

@end

@interface ELRecommendReportDetailCtl : UIViewController

@property (nonatomic,strong) NSMutableArray *selectArr;
@property (nonatomic,copy) NSString *salerId; 
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,weak) id<ELRecommentSuccessRefreshDelegate> refreshDelegate;

@end
