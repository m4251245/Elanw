//
//  AssociationDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-1-15.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "Groups_DataModal.h"
#import "ExRequetCon.h"
#import "Article_DataModal.h"
#import "ArticleDetailCtl.h"
#import "JionGroupReasonCtl.h"
#import "PublishArticle.h"
#import "ELGroupDetailModal.h"

@protocol AssociationDetailCtlDelegate <NSObject>

@optional

-(void)refresh;
-(void)joinSuccess;

@end

@interface AssociationDetailCtl : BaseListCtl<JionGroupReasonCtlDelegate,UITextViewDelegate,UISearchBarDelegate,PublishArticleDelegate,joinGroupDelegate>
{
    RequestCon  *joinCon_;
    RequestCon  *permissionCon_;
    RequestCon  *deleteCon_;
    
    ELGroupDetailModal  *groupsDataModal_;
    NSMutableArray  *topArticleArray_;
    
    IBOutlet    UIView  *noArticleView_;
    BOOL    isCreate_;
    NSIndexPath *clickIndexPath;
    
    NSMutableArray  *articleDetailArray_;
}

@property(nonatomic,assign) BOOL                isMine_;
@property(nonatomic,assign) id<AssociationDetailCtlDelegate> delegate_;
@property(nonatomic,strong) NSString            *type_;   //1个人中心社群列表
@property (nonatomic,assign) BOOL isZbar; //表示来自二维码扫描进入，用于返回上上层页面
@property (nonatomic,assign) BOOL isCompanyGroup;
@property (nonatomic,assign) BOOL isGroupPop;

//- (void)deleteBtnClick:(id)sender event:(id)event;
//-(void)joinCompany:(NSString *)groupId;

@end
