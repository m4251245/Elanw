//
//  PositionCollectRecordCtl.h
//  Association
//
//  Created by 一览iOS on 14-6-24.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

/*  职位收藏列表类
 *
 */

#import "BaseListCtl.h"
#import "ExRequetCon.h"


@protocol PositionCollectRecordCtlDelegate <NSObject>

@optional
- (void)deletePositionCollectSuccess;

@end

@interface PositionCollectRecordCtl : BaseListCtl
{
//    NSMutableArray  *positionArray_;            //tableView数据源
    NSMutableArray  *seletedArray_;
    IBOutlet        UIImageView     *bottomView_;       //底部
    IBOutlet        UIButton        *applayBtn_;        //申请选中职位
    RequestCon      *applyCon_;     //用于请求申请职位
    RequestCon      *deleteCon_;    //用于删除收藏职位
    NSIndexPath     *indexPath_;    //用于关联cell的数据
}

@property(nonatomic,assign) id<PositionCollectRecordCtlDelegate>  delegate;

@end
