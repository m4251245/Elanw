//
//  ELInterViewAdressCtl.h
//  jobClient
//
//  Created by YL1001 on 15/11/17.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"

@protocol chooseAddressDelegate <NSObject>

- (void)addInterviewAddressWithRegionName:(NSString *)regionName regionId:(NSString *)regionId;

@end


@interface ELInterViewAdressCtl : BaseListCtl<UITextFieldDelegate>
{
    
    IBOutlet UITextField *addressTF;
    IBOutlet UIButton *confirmBtn;
}

@property (nonatomic,assign) id<chooseAddressDelegate> delegate;

@end
