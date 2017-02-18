//
//  MyButton.h
//  CampusClient
//
//  Created by job1001 job1001 on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


/******************************
 
 自定义按扭,主要是为了体现是否需要登录
 
 ******************************/


#import <UIKit/UIKit.h>

@interface MyButton : UIButton {
    NSInteger                 index_;            //索引
}

@property(nonatomic,assign) NSInteger                     index_;

@end
