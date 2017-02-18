//
//  JobAttentionNoDataView.m
//  jobClient
//
//  Created by 一览ios on 14/12/2.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "JobAttentionNoDataView.h"
#import "MyJobSearchCtl.h"
#import "PropagandaCtl.h"

@implementation JobAttentionNoDataView


- (IBAction)attentionBtnClick:(id)sender {
    if(_type == Organization_School){
        NSLog(@"关注学校");
        PropagandaCtl * proCtl = [[PropagandaCtl alloc] init];
        [[self viewController].navigationController pushViewController:proCtl animated:YES];
        [proCtl beginLoad:nil exParam:nil];
        
    }else{
        NSLog(@"关注公司");
//        [[Manager shareMgr].tabView_ changeModel:Tab_Fourth];
//        [[Manager shareMgr].salaryCtl_ removeSegmentView];
        if( ![Manager shareMgr].findJobCtl_ ){
            [Manager shareMgr].findJobCtl_ = [[MyJobSearchCtl alloc] init];
        }
        
        [[self viewController].navigationController popToRootViewControllerAnimated:NO];
        [[self viewController].navigationController pushViewController:[Manager shareMgr].findJobCtl_ animated:NO];
        [[Manager shareMgr].findJobCtl_ beginLoad:nil exParam:nil];
        [Manager shareMgr].registeType_ = FromQZ;
        [Manager shareMgr].tabType_ = 3;
        
    }
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)setType:(OrganizationType)type
{
    _type = type;
    if (_type == Organization_School) {
        _attentionLb.text = @"搜索并关注感兴趣的学校";
    }
}
@end
