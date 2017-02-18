//
//  HistoryTableView.h
//  jobClient
//
//  Created by job1001 job1001 on 11-12-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHistory_DataModal.h"
#import "sqlite3.h"

//历史记录的类型
typedef enum 
{
    DefaultType,            //默认类型(快速搜索 + 高级搜索)
    NormalSearchType,       //快速搜索的记录
    AdvanceSearchType,      //高级搜索的记录
    CampusSearchType,       //校招的记录
    MapSearchType,          //地图搜索
}HistoryTableViewType;

static double UITableViewHeight_Section = 0.0;

@protocol HistoryTableViewDelegate <NSObject>

-(void) historyTableViewCellClick:(SearchHistory_DataModal *)dataModal;

@end

@interface HistoryTableView : UITableView<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray                  *resultArr_;
    
    
    HistoryTableViewType            tableType_;
}

@property(nonatomic,retain) NSMutableArray                  *resultArr_;
@property(nonatomic,assign) id<HistoryTableViewDelegate>    delegate_;

//设置自己的类型
-(void) initInfo:(HistoryTableViewType)type;

//开始载入数据
-(void) reloadData;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;


@end
