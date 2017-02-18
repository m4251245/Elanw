//
//  ELRecommendView.m
//  jobClient
//
//  Created by 一览iOS on 16/6/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELRecommendView.h"
#import "MyOfferPartyIndexCtl.h"
#import "NearWorksCtl.h"
#import "ServiceInfo.h"
#import "RRServiceInfo.h"
#import "ELEmployerViewCtl.h"
#import "PushUrlCtl.h"
#import "YLExpertListCtl.h"

@implementation ELRecommendView

- (void)setRecommendArr:(NSArray *)recommendArr
{
    _recommendArr = recommendArr;
    CGFloat itemH = 60;
    CGFloat itemW = (ScreenWidth-15)/2;
    CGFloat rowNum = (recommendArr.count -1)/2 +1;
    _height = rowNum*itemH + 5*rowNum;
    self.frame = CGRectMake(0,0,ScreenWidth,_height);
    self.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.f];

    for (int i=0; i<recommendArr.count; i++) {
        RecommendView *view = [[RecommendView alloc] init];
        view.type = recommendArr[i];
        int line = i/2;
        int column = i%2;
        view.frame = CGRectMake((column * itemW)+(5*(column+1)),(line*itemH)+(5*line), itemW, itemH);
        [self addSubview:view];
        view.btnBlick = ^(NSString *type){
            [self recommendBtnResponeString:type];
        };
    }
}

#pragma mark 小编推荐点击事件
- (void)recommendBtnResponeString:(NSString *)type
{
    NSString *dictStr;
    if ([type isEqualToString:@"offer"]) {
        //offer派
        dictStr = [NSString stringWithFormat:@"%@_%@", @"offer派", [self class]];
        
        MyOfferPartyIndexCtl *ctl = [[MyOfferPartyIndexCtl alloc] init];
        ctl.isFromHome = YES;
        [ctl beginLoad:nil exParam:nil];
        ctl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:ctl animated:YES];
    }
    else if ([type isEqualToString:@"fujzw"]) {
        //附近的职位
        dictStr = [NSString stringWithFormat:@"%@_%@", @"附近职位", [self class]];
        
        NearWorksCtl *nearWorks = [[NearWorksCtl alloc] init];
        [nearWorks beginLoad:nil exParam:nil];
        nearWorks.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:nearWorks animated:YES];
    }
    else if ([type isEqualToString:@"jianlzz"]) {
        //简历制作
        dictStr = [NSString stringWithFormat:@"%@_%@", @"简历制作", [self class]];
        
        ServiceInfo *searviceCtl = [[ServiceInfo alloc] init];
        searviceCtl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:searviceCtl animated:YES];
    }
    else if ([type isEqualToString:@"gongsbg"]) {
        //公司八卦
        dictStr = [NSString stringWithFormat:@"%@_%@", @"公司八卦", [self class]];
        
        GroupsChangeTypeCtl *ctl = [[GroupsChangeTypeCtl alloc] init];
        ctl.isHaveTradeChange = YES;
        ctl.groupType = 3;
        [ctl beginLoad:nil exParam:nil];
        ctl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:ctl animated:YES];
    }
    else if ([type isEqualToString:@"yilzt"]) {//一览直推
        dictStr = [NSString stringWithFormat:@"%@_%@", @"一览直推", [self class]];
        
        RRServiceInfo *serviceInfo = [[RRServiceInfo alloc]init];
        serviceInfo.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:serviceInfo animated:YES];
    }
    else if ([type isEqualToString:@"hangjzz"]) {//行家支招
        dictStr = [NSString stringWithFormat:@"%@_%@", @"行家支招", [self class]];
        YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
        expertList.hidesBottomBarWhenPushed = YES;
        expertList.selectedTab = @"职业发展导师";
        [[Manager shareMgr].centerNav_ pushViewController:expertList animated:YES];
    }
    else if ([type isEqualToString:@"jingjr"]) {//职业经纪人
        dictStr = [NSString stringWithFormat:@"%@_%@", @"职业经纪人", [self class]];
        YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
        expertList.hidesBottomBarWhenPushed = YES;
        expertList.selectedTab = @"职业经纪人";
        [[Manager shareMgr].centerNav_ pushViewController:expertList animated:YES];
    }
    else if ([type isEqualToString:@"wgz"]) {//微雇主
        dictStr = [NSString stringWithFormat:@"%@_%@", @"微雇主", [self class]];
        
        ELEmployerViewCtl *ctl = [[ELEmployerViewCtl alloc] init];
        ctl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:ctl animated:YES];
    }
    else if ([type isEqualToString:@"zhiyeghs"]) {//职业发展导师
        dictStr = [NSString stringWithFormat:@"%@_%@", @"职业发展导师", [self class]];
        YLExpertListCtl *expertList = [[YLExpertListCtl alloc] init];
        expertList.hidesBottomBarWhenPushed = YES;
        expertList.selectedTab = @"职业发展导师";
        [[Manager shareMgr].centerNav_ pushViewController:expertList animated:YES];
    }
    else if ([type isEqualToString:@"shyg"]) {//三好一改
        dictStr = [NSString stringWithFormat:@"%@_%@", @"三好一改", [self class]];
        
        NSString *url = @"http://m.yl1001.com/zhuanti/shyg/";
        PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
        
        if ([url containsString:@"?"]) {
            url = [url stringByAppendingString:@"&appflag=1002"];
        }else{
            url = [url stringByAppendingString:@"?appflag=1002"];
        }
        pushurlCtl.fromThreeGoodOneChange = YES;
        pushurlCtl.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:pushurlCtl animated:YES];
        [pushurlCtl beginLoad:url exParam:nil];
    }
    
    //记录友盟统计模块使用量
    NSDictionary *dict = @{@"Function" : dictStr};
    [MobClick event:@"buttonClick" attributes:dict];
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

@end
