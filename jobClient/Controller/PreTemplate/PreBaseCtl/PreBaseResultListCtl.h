//
//  PreBaseResultListCtl.h
//  HelpMe
//
//  Created by wang yong on 11/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
 Ctl Base ResultList Class
 
 ***************************/

#import <UIKit/UIKit.h>
#import "PreBaseUIViewController.h"
#import "PageInfo.h"
#import "EGORefreshTableView.h"
#import "NoMoreDataCtl.h"
#import "ErrorLoadCtl.h"

@interface PreBaseResultListCtl : PreBaseUIViewController<EGORefreshTableDelegate,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet	UITableView			*tableView_;		//tableView
	IBOutlet	UIView				*noDataOkView_;		//no data and load ok
	IBOutlet    UILabel             *noDataOkLb_;       //no data and the ok lb
    
    NSString                        *noDataOkText_;     //no data and the ok lb's text
    
	NoMoreDataCtl					*noMoreDataCtl_;
	ErrorLoadCtl                    *errorLoadCtl_;
    BOOL                            bHaveShowErrorLoad_;
    
	NSMutableArray					*resultArr_;		//result mutable arr
	PageInfo						*pageInfo_;			//page info
    PageInfo                        *prePageInfo_;      //pre page info
	
	EGORefreshTableView				*refreshHeaderView_;//head ego view
	EGORefreshTableView				*refreshFooterView_;//footer ego view
	
	BOOL							bHeaderEgo_;		//head push refresh
	BOOL							bFooterEgo_;		//bottom push refresh
    
    BOOL                            bHaveEditMode_;     //b have edit mode
    BOOL                            bEditMode_;         //be in edit mode
    NSIndexPath                     *selectIndexPath_;  //select index path
}

@property(nonatomic,retain) UITableView			*tableView_;
@property(nonatomic,retain) UIView				*noDataOkView_;
@property(nonatomic,retain) UILabel             *noDataOkLb_;
@property(nonatomic,retain) NSMutableArray		*resultArr_;
@property(nonatomic,retain) PageInfo			*pageInfo_;

//EGO Fun
-(void) reloadTableViewDataSource:(EGORefreshTableView *)egoView;
-(void) doneLoadingTableViewData:(EGORefreshTableView *)egoView;

//show/hide have more page
-(void) showFooterRefreshView:(BOOL)flag;

//show/hide no more data
-(void) showNoMoreDataView:(BOOL)flag;

//show/hide error load
-(void) showErrorLoadView:(BOOL)flag;

//load more
-(void) loadMoreData;

//load detail
-(void) loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath;

//delete cell
-(void) deleteCell:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath;

//add obj from dataArr
-(void) addDataModal:(PreRequestCon *)con dataArr:(NSArray *)dataArr type:(XMLParserType)type;

//sub class rewrite it
-(void) beginClearData:(PreRequestCon *)con;

//clear data
-(void) clearData:(PreRequestCon *)con;


@end
