//
//  ChangeRegionViewController.h
//  changeRegion
//
//  Created by 一览iOS on 14-12-15.
//  Copyright (c) 2014年 TestDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqlitData.h"
#import "BaseUIViewController.h"

typedef void(^backString)(SqlitData *regionModel);

@interface ChangeRegionViewController: BaseUIViewController
{

}
@property (nonatomic,copy) backString blockString;
@property (nonatomic,assign) BOOL navigationBarStatus;

@property (nonatomic,copy) NSString *regionRealName;

@property (nonatomic,retain)SqlitData * selectedVO;

@end
