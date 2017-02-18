//
//  ELSameTradePeopleFrameModel.h
//  jobClient
//
//  Created by 一览iOS on 16/6/8.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "PageInfo.h"
#import "ELSameTradePeopleModel.h"

@interface ELSameTradePeopleFrameModel : PageInfo

@property (nonatomic,strong) ELSameTradePeopleModel *peopleModel;

@property (nonatomic,strong) NSMutableAttributedString *workAgeAttString;
@property (nonatomic,strong) NSMutableAttributedString *nameAttString;

@property (nonatomic,copy) NSString *dynamicImageName;
@property (nonatomic,assign) BOOL dynamicBtnEnable;

@property(nonatomic,assign) BOOL isSearch;
@property(nonatomic,assign) BOOL isHaveInvite;
@property(nonatomic,assign) BOOL isInvite_;

//搜索关键字变红
-(void)changeSearchKeyWord;

@end
