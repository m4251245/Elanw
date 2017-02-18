//
//  ELJobSearchChangeListCtl.h
//  jobClient
//
//  Created by 一览iOS on 16/12/20.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELBaseUIViewController.h"

@protocol ELSearchChangeDeleagte <NSObject>

-(void)selectCellRefreshWithModel:(SearchParam_DataModal *)dataModal;
-(void)selectCellRefreshKeyWord:(NSString *)keyWord;
-(void)searchHideKeyBoard;

@end

@protocol ELSearchRequestDataDelegate <NSObject>

-(void)requestFinish:(NSString *)key;

@end

@interface ELJobSearchChangeListCtl : UIView

@property (nonatomic,assign) BOOL iskeyboardShow;

@property (nonatomic,weak) id <ELSearchChangeDeleagte> searchDelegate;
@property (nonatomic,copy) NSString *tradeId;

-(void)saveKeyWord:(NSString *)keyWord searchModel:(SearchParam_DataModal *)model;
-(void)searchBarDidChange:(NSString *)searchText tradeId:(NSString *)tradeId regionId:(NSString *)regionId;
-(UIView *)getNoDataFooterView;

@end

@interface ELJobRequestListModel : NSObject

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,copy) NSString *keyWord;
@property (nonatomic,weak) id <ELSearchRequestDataDelegate> delegate;

-(void)requestDataWithBodyMsg:(NSString *)bodyMsg;

@end

@interface ELJobRequestJsonModel : NSObject

@property (nonatomic,copy) NSString *logopath;
@property (nonatomic,copy) NSString *cname;
@property (nonatomic,copy) NSString *region;
@property (nonatomic,copy) NSString *regionid;
@property (nonatomic,copy) NSString *cxz;
@property (nonatomic,copy) NSString *zw_cnt;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *jtzw;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,assign) BOOL isZW;

-(id)initWithDictionary:(NSDictionary *)dic;

@end
