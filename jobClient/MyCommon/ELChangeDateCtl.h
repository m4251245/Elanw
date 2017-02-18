//
//  ELChangeDateCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/1/21.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreCommon.h"
#import "CondictionList_DataModal.h"

typedef void(^changeDateCtlBlock)(CondictionList_DataModal *dataModal);

@interface ELChangeDateCtl : UIViewController

@property(nonatomic,copy) changeDateCtlBlock changeDateBlock;

//修改日期显示类型
@property(nonatomic,assign) UIDatePickerMode pickerMode;
//设置是否显示至今按钮
@property(nonatomic,assign) BOOL showTodayBtn;
//设置显示最小日期为今天，默认为最大日期为今天
@property(nonatomic,assign) BOOL showMinDate;

/*显示控件
 *date 当前显示的时间 默认为今天
 *block 选择了相关时间的回调
 */
 -(void)showViewCtlCurrentDate:(NSDate *)date WithBolck:(changeDateCtlBlock)block;
//隐藏控件
-(void)hideViewCtl;

@end
