//
//  ZWDescript_Cell.h
//  jobClient
//
//  Created by job1001 job1001 on 11-12-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ZWDescript_Cell_Xib_Name                @"ZWDescript_Cell"

@interface ZWDescript_Cell : UITableViewCell {
    
}

@property(nonatomic,weak)IBOutlet   UILabel        *updateTimeLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *regionNameLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *peopeleCountLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *yearCountLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *eduLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *moneyCountLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *majorLb_;
@property(nonatomic,weak)IBOutlet   UILabel        *zwJianJieLb_;

@end
