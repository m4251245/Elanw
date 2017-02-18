//
//  ELOfferMianView.h
//  jobClient
//
//  Created by YL1001 on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELOfferMianView : UIView

- (instancetype)initWithFrame:(CGRect)frame TitleArr:(NSArray *)titleArr Controllers:(NSArray *)controllers ParentController:(UIViewController *)parenController;

@property (nonatomic, assign) BOOL isFromHome;

@end
