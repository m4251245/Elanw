//
//  ELLoadDataView.h
//  jobClient
//
//  Created by 一览iOS on 16/11/4.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELLoadDataView : UIView

-(void) errorGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type;
-(void) finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr;
-(RequestCon *)getNewRequestCon;

@end
