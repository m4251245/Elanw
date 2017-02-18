//
//  companySearchCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-1-27.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "CHRIndexCtl.h"
@class SearchParam_DataModal;

@interface CompanySearchCtl : BaseListCtl
{
        
}

@property (nonatomic,strong) NSString *companyId;
@property(nonatomic, copy) NSString *regionId;


@property (strong, nonatomic) SearchParam_DataModal *paramDataModel;
@property (assign, nonatomic) ResumeType resumeType;

@property (weak, nonatomic) IBOutlet UIView *conditionView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *workAgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *educationLevelBtn;

@property (strong, nonatomic) IBOutlet UIView *informalMemberTiPView;

-(void)hideKeyboard;

@end
