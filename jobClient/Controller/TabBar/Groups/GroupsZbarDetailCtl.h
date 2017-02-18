//
//  GroupsZbarDetailCtl.h
//  jobClient
//
//  Created by 一览iOS on 15-1-16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ELGroupDetailModal.h"

@interface GroupsZbarDetailCtl : BaseUIViewController
{
   
}

@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupNumber;

@property (weak, nonatomic) IBOutlet UIImageView *groupZbar;

@property (weak, nonatomic) IBOutlet UIButton *saveZbar;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,strong) ELGroupDetailModal *myDataModal;

@end
