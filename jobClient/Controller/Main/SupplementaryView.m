//
//  SupplementaryView.m
//  jobClient
//
//  Created by 一览ios on 15/10/13.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "SupplementaryView.h"
#import "EditorBasePersonInfoCtl.h"
#import "SysTemSetCtl.h"
#import "ELPersonCenterCtl.h"
#import "UIButton+WebCache.h"
#import "Mycommon.h"

@implementation SupplementaryView 

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self changFrame];
}

- (void)changFrame
{
    if ([Manager shareMgr].haveLogin) {
        [_qrBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bianzBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_personCentenBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _personPhotoImage.clipsToBounds = YES;
        _personPhotoImage.layer.cornerRadius = 84/2;
        _personPhotoImage.layer.borderColor = UIColorFromRGB(0xf37272).CGColor;
        _personPhotoImage.layer.borderWidth = 2.0;
        [_personPhotoImage sd_setImageWithURL:[NSURL URLWithString:[Manager getUserInfo].img_] placeholderImage:[UIImage imageNamed:@"headimage_moren.png"]];
        
        if ([Manager getUserInfo].isExpert_) {
            [_markImv setHidden:NO];
            _nameLbToCenter.constant = 10;
        }else{
            _nameLbToCenter.constant = 0;
            [_markImv setHidden:YES];
        }
        if([Manager shareMgr].userCenterModel.userModel_.iname_.length <= 0){
            _nameLb.text = [Manager getUserInfo].name_;
        }else{
           [_nameLb setText:[Manager shareMgr].userCenterModel.userModel_.iname_]; 
        }
        
        NSString * str  = @"";
        if ([Manager getUserInfo].job_ && ![[Manager getUserInfo].job_ isEqualToString:@""]) {
            str = [NSString stringWithFormat:@"%@",[Manager getUserInfo].job_];
        }else{
            str = [Manager getUserInfo].zye_;
        }
        if ([str isEqualToString:@""]) {
            str = @"未填写";
        }
        [_zwdescLb setText:[NSString stringWithFormat:@"%@",str]];
        [_morView setHidden:YES];
    }else{
        _morphotoImgv.layer.cornerRadius = 84/2;
        _morphotoImgv.layer.borderColor = UIColorFromRGB(0xf37272).CGColor;
        _morphotoImgv.layer.borderWidth = 2.0;
        _morphotoImgv.layer.masksToBounds =YES;
        [_morphotoImgv setImage:[UIImage imageNamed:@"bg__xinwen.png"]];
        [_morView setHidden:NO];
        [_morPhotoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)buttonClick:(UIButton *)sender
{
    if (sender == _personCentenBtn) {
        ELPersonCenterCtl *personCenter = [[ELPersonCenterCtl alloc] init];
        [personCenter beginLoad:[Manager getUserInfo].userId_ exParam:nil];
        personCenter.hidesBottomBarWhenPushed = YES;
        personCenter.isFromManagerCenterPop = YES;
        [[Manager shareMgr].centerNav_ pushViewController:personCenter animated:YES];
        NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"我的主页",NSStringFromClass([self class])]};
        [MobClick event:@"buttonClick" attributes:dict];
    }
    else if (sender == _qrBtn){
        qrCodeCtl = [[PersonQRCodeCtl alloc] initWithDataModal:[Manager getUserInfo]];
        [qrCodeCtl show];
    }
    else if (sender == _morPhotoBtn)
    {
        [Manager shareMgr].registeType_ = FromMessage;
        [NoLoginPromptCtl loginOutWithDelegate:self type:LoginType_PushPersonCenter loginRefresh:NO];
    }
}

#pragma mark - NoLoginDelegate
-(void)loginSuccessResponse{
    switch ([NoLoginPromptCtl getNoLoginManager].loginType) {
        case LoginType_PushPersonCenter:
        {
            ELPersonCenterCtl *personCenter = [[ELPersonCenterCtl alloc] init];
            [personCenter beginLoad:[Manager getUserInfo].userId_ exParam:nil];
            personCenter.hidesBottomBarWhenPushed = YES;
            personCenter.isFromManagerCenterPop = YES;
            [[Manager shareMgr].centerNav_ pushViewController:personCenter animated:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)setBtnResopne:(UIButton *)sender
{
    SysTemSetCtl *setController = [[SysTemSetCtl alloc] init];
    [Manager shareMgr].registeType_ = FromMore;
    setController.hidesBottomBarWhenPushed = YES;
    [[Manager shareMgr].centerNav_ pushViewController:setController animated:YES];
    [setController beginLoad:nil exParam:nil];
    NSDictionary * dict = @{@"Function":[NSString stringWithFormat:@"%@_%@",@"设置",NSStringFromClass([self class])]};
    [MobClick event:@"buttonClick" attributes:dict];
}

@end
