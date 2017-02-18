//
//  TagSelected_ViewController.h
//  jobClient
//
//  Created by 一览ios on 16/7/28.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELNewBaseViewController.h"

@interface TagSelected_ViewController : ELNewBaseViewController

@property(nonatomic,retain)NSArray *tagMarkArr;

@property(nonatomic,copy)void (^myBlock)(NSArray *selArr);

@property(nonatomic,copy)NSString *companyId;

@end
