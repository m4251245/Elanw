//
//  TJZWCell.m
//  jobClient
//
//  Created by YL1001 on 14-9-2.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "TJZWCell.h"
#import "ELArticlePositionModel.h"

@interface TJZWCell()
{
    ELArticleDetailModel *_myDataModal;
}
@end

@implementation TJZWCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMyDataModal:(ELArticleDetailModel *)dataModal
{
    _myDataModal = dataModal;
    self.btn1_.tag = 10010;
    self.btn2_.tag = 10011;
    
    [self.btn1_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2_ addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    @try {
        ELArticlePositionModel * dataModal1 = [dataModal.zhiwei objectAtIndex:0];
        self.zw1NameLb_.text = dataModal1.jtzw;
        self.zw1RegionLb_.text = [NSString stringWithFormat:@"工作地点:%@",dataModal1.region_name];
        [self.zw1NameLb_ setFont:FOURTEENFONT_CONTENT];
        [self.zw1RegionLb_ setFont:TWEELVEFONT_COMMENT];
        
        ELArticlePositionModel * dataModal2 = [dataModal.zhiwei objectAtIndex:1];
        self.zw2NameLb_.text = dataModal2.jtzw;
        self.zw2RegionLb_.text = [NSString stringWithFormat:@"工作地点:%@",dataModal2.region_name];
        [self.zw2NameLb_ setFont:FOURTEENFONT_CONTENT];
        [self.zw2RegionLb_ setFont:TWEELVEFONT_COMMENT];
    }
    @catch (NSException *exception) {
        self.bgImg2_.alpha = 0.0;
        
    }
    @finally {
        
    }

}
-(void)btnClick:(UIButton *)sender
{
    if (sender.tag == 10010) {
        @try {
            ELArticlePositionModel * dataModal = [_myDataModal.zhiwei objectAtIndex:0];
            //跳转到职位详情
            ZWDetail_DataModal *modal = [[ZWDetail_DataModal alloc] init];
            modal.jtzw_ = dataModal.jtzw;
            modal.zwID_ = dataModal.id_;
            modal.regionId_ = dataModal.regionid;
            modal.regionName_ = dataModal.region_name;
            modal.companyName_ = dataModal.cname_all;
            modal.companyLogo_ = dataModal.logopath; 
            modal.companyID_ = dataModal.uid;
            PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
            [[self viewController].navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:modal exParam:nil];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    else if (sender.tag == 10011) {
        @try {
            ELArticlePositionModel * dataModal = [_myDataModal.zhiwei objectAtIndex:1];
            //跳转到职位详情
            ZWDetail_DataModal *modal = [[ZWDetail_DataModal alloc] init];
            modal.jtzw_ = dataModal.jtzw;
            modal.zwID_ = dataModal.id_;
            modal.regionId_ = dataModal.regionid;
            modal.regionName_ = dataModal.region_name;
            modal.companyName_ = dataModal.cname_all;
            modal.companyLogo_ = dataModal.logopath; 
            modal.companyID_ = dataModal.uid;
            PositionDetailCtl *detailCtl = [[PositionDetailCtl alloc] init];
            [[self viewController].navigationController pushViewController:detailCtl animated:YES];
            [detailCtl beginLoad:modal exParam:nil];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
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

@end
