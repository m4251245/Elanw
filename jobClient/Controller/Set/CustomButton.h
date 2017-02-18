//
//  CustomButton.h
//  jobClient
//
//  Created by 一览iOS on 14-8-20.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ChangeColor = 1,
    delectdButton = 2
}ClickState;

@interface CustomButton : UIButton

@property(nonatomic,strong)NSString *value_;

@property(nonatomic, assign)ClickState clickState;

@end
