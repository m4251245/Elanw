//
//  EditorTagCtl.h
//  jobClient
//
//  Created by 一览iOS on 14-11-1.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"
#import "ExRequetCon.h"
#import "PersonCenterDataModel.h"

@protocol EditorTagCtlDelegate <NSObject>

- (void)updateTagSuccess;

@end

typedef void(^editorTagBolck) (NSString *type);

@interface EditorTagCtl : BaseEditInfoCtl
{
    IBOutlet    UIView              *bgView_;
    IBOutlet    UITextField         *tagsTextField_;
    RequestCon                      *updateTagsCon_;
    RequestCon                      *getTagsCon_;
    PersonCenterDataModel           *inModel_;
    NSMutableArray                  *defaultTagArray_;
    NSMutableArray                  *customTagArray_;
}
@property(nonatomic,copy) editorTagBolck block;
@property(nonatomic,strong) NSString *tagsType;
@property(nonatomic,assign) id<EditorTagCtlDelegate> delegate_;

@end
