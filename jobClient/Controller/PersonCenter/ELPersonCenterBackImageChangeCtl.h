//
//  ELPersonCenterBackImageChangeCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Logo_DataModal.h"
#import "ELGroupDetailModal.h"

typedef void (^ChangeBackImageBolck)(Logo_DataModal *dataModal);

@interface ELPersonCenterBackImageChangeCtl : BaseUIViewController

@property(nonatomic,copy) ChangeBackImageBolck changeImageBolck;

@property(nonatomic,copy) NSString *imageType;

@property(nonatomic,assign) BOOL isFromGroup;

@property(nonatomic,strong) ELGroupDetailModal *groupDataModal;

@end
