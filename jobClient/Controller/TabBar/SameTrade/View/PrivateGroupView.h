//
//  PrivateGroupView.h
//  jobClient
//
//  Created by 一览ios on 16/6/25.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateGroupView : UIView

@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

- (void)showPrivateGroupEntrance:(NSString *)rel;

@end
