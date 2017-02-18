//
//  ELActivityPeopleFrameCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/6/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELActivityPeopleFrameModel.h"
#import "NSString+Size.h"

@implementation ELActivityPeopleFrameModel

-(void)setPeopleModel:(ELActivityPeopleModel *)peopleModel{
    _peopleModel = peopleModel;
    
    _arrListData = [[NSMutableArray alloc] init];
    if (peopleModel.gaae_contacts.length > 0){
        [_arrListData addObject:@"gaae_contacts"];
    }
    if (peopleModel.company.length > 0){
        [_arrListData addObject:@"company"];
    }
    if (peopleModel.group.length > 0){
        [_arrListData addObject:@"group"];
    }
    if (peopleModel.email.length > 0){
        [_arrListData addObject:@"email"];
    }
    if (peopleModel.remark.length > 0){
        [_arrListData addObject:@"remark"];
    }
    
    if (_arrListData.count > 0){
        if ([_arrListData containsObject:@"remark"]){
            CGSize size = [peopleModel.remark sizeNewWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-63,10000)];
            self.cellHeight = 68 + ((_arrListData.count - 1)*24) + size.height + 10;
        }else{
            self.cellHeight = 68 + _arrListData.count*24 + 5;
        }
    }else{
        self.cellHeight = 70;
    }
    if ([peopleModel.enroll_status isEqualToString:@"50"]) {
        _agreeStatus = @"已忽略";
    }else if([peopleModel.enroll_status isEqualToString:@"100"]){
        _agreeStatus = @"已同意";
    }else if([peopleModel.enroll_status isEqualToString:@"0"]){
        _agreeStatus = @"未处理";
    }
}

@end
