//
//  ELActivitySuccessAlertView.h
//  jobClient
//
//  Created by 一览iOS on 16/5/17.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article_DataModal.h"

@interface ELActivitySuccessAlertView : UIView

-(void)showWithPublishSuccessArticleModal:(Article_DataModal *)modal;
-(void)showWithJoinSuccessArticleModal:(Article_DataModal *)modal;
-(void)showWithGroupJoinSuccessArticleModal:(Article_DataModal *)modal;
+(ELActivitySuccessAlertView *)activitySuccessView;

@end
