//
//  MyDelegateCtl.h
//  jobClient
//
//  Created by 一览ios on 15/11/18.
//  Copyright © 2015年 YL1001. All rights reserved.
//

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeAgent=1,  //职业经纪人
    UserTypeCommon
};

#import "ELBaseListCtl.h"

@interface MyDelegateCtl : ELBaseListCtl

@property(nonatomic, copy) NSString *userId;
//@property (nonatomic, assign) BOOL isOthercenterFlag;
@property (strong, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *line1Lb;
@property (weak, nonatomic) IBOutlet UILabel *line2Lb;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (nonatomic, assign) UserType userType;

@end
