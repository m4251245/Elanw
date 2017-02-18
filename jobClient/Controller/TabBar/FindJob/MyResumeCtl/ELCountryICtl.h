//
//  ELCountryICtl.h
//  jobClient
//
//  Created by 一览ios on 16/1/18.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseListCtl.h"

@protocol countryICtlDelegate <NSObject>

-(void)countryICtl:(NSString *)countryName;

@end


@interface ELCountryICtl : ELBaseListCtl

@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (nonatomic,weak) id<countryICtlDelegate>delegate;

@end
