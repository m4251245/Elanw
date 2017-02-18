//
//  PublishInIOS6.h
//  jobClient
//
//  Created by YL1001 on 14-8-18.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "GCPlaceholderTextView.h"

@protocol PublishInIOS6Delegate <NSObject>

-(void)finishAddContent:(NSString*)content;

@end

@interface PublishInIOS6 : BaseEditInfoCtl<UITextViewDelegate>

{
    IBOutlet GCPlaceholderTextView * contentTx_;
}

@property(nonatomic,assign) id<PublishInIOS6Delegate> delegate_;

@end
