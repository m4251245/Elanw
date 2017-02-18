//
//  AppointmentCtl.h
//  
//
//  Created by 一览ios on 15/11/1.
//
//

#import "BaseListCtl.h"

typedef void(^FinishLoadBlock)(CGFloat height, BOOL isNoData);

@interface AppointmentCtl : UIView

//下面2个需要传递的参数
@property(nonatomic, copy) NSString *otherUserId;
@property(nonatomic, copy) FinishLoadBlock finishBlock;

@property (strong, nonatomic) UIView *noDataView;
@property (strong, nonatomic) UIButton *addArticleBtn;

@property (nonatomic, strong) NSMutableArray *dataArr;

- (void)beginLoad:(id)dataModal exParam:(id)exParam;

@end
