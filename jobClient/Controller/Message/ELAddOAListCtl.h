//
//  ELAddOAListCtl.h
//  jobClient
//
//  Created by YL1001 on 16/4/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddOADelegate <NSObject>

- (void)hideOABtnView:(BOOL)hide;

- (void)btnResponeWithIndex:(NSInteger)index;

@end

@interface ELAddOAListCtl : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *vacateBtn;
@property (strong, nonatomic) IBOutlet UIButton *officialBtn;

@property (nonatomic, weak) id<AddOADelegate> addOADelegate;
- (void)showViewCtl;

@end
