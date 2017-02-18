//
//  BaseSingleCtl.h
//  jobClient
//
//  Created by job1001 job1001 on 12-2-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

/*********************************
 
单个ctl,用于在多个ctl中处理逻辑的基类
 *********************************/

#import <UIKit/UIKit.h>
#import "BaseResumeCtl.h"

@protocol FatherSingleDelegate <NSObject>

@required
//删除某个
-(void) delCtl:(int)index;

//移动视图
-(void) autoMove:(UIView *)subObj;

//恢复视图
-(void) recoverMoveSize; 

@end

@interface BaseSingleCtl : BaseResumeCtl<UITextFieldDelegate,UITextViewDelegate> {
    IBOutlet    UIButton            *indexBtn_;         //索引标题
    IBOutlet    UIButton            *deleteBtn_;        //删除
    
    int                             index_;             //自己的索引
        
    id<FatherSingleDelegate>        fatherCtl_;         //是谁在容纳自己
}

//根据index设置自己的标题
-(void) setTitleIndex:(int)index;

//设置favtherCtl
-(void) setFatherCtl:(id<FatherSingleDelegate>)ctl;

//自动移动自己到顶端,让自己好输入
-(void) autoMove:(UIView *)obj;

//恢复已移动的视图
-(void) recoverMoveSize;

//询问是否删除自己
-(void) tryDeleteMyself;

//确认删除
-(void) deleteMyself;

@end
