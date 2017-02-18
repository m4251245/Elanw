//
//  EditorManifestoCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-7.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PersonCenterDataModel.h"
#import "ExRequetCon.h"


typedef void(^endtorMainBlock) ();

@interface EditorManifestoCtl : BaseUIViewController<UITextViewDelegate>
{
    IBOutlet    UITextView      *manifestTextv_;
    PersonCenterDataModel       *inModel_;
    RequestCon                  *editCon_;
}

@property(nonatomic,copy) endtorMainBlock block;
@property(nonatomic,strong) NSString *type;
@end
