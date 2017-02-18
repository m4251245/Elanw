//
//  ELRootViewController.h
//  jobClient
//
//  Created by 一览ios on 16/5/3.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "TabView.h"

@interface ELRootViewController : UINavigationController
//@property(nonatomic, assign) NSInteger tabType;
- (void) setTabType:(TabType)tabType;
- (void) tabViewModalChanged:(TabView *)tab type:(TabType)type;
@end
