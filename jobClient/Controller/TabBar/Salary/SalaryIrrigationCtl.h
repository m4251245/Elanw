//
//  SalaryIrrigationCtl.h
//  Association
//
//  Created by 一览iOS on 14-7-2.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ExRequetCon.h"
#import "SearchParam_DataModal.h"
#import "ArticleDetailCtl.h"
#import "ShareSalaryArticleCtl.h"
#import "MLEmojiLabel.h"


@interface SalaryIrrigationCtl : BaseListCtl<UITextFieldDelegate>
{
    SearchParam_DataModal *inModel_;
    ArticleDetailCtl *articleDetailCtl_;
    
    
    RequestCon     * addlikeCon_;
    RequestCon     * shareLogsCon_;
    RequestCon     * addCommentCon_;
    
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    @public
    IBOutlet       UISearchBar  *  kwTF_;
    BOOL isSearch;
    @protected
    IBOutlet       UIButton     *  searchBtn_;
    IBOutlet       UIButton     *  publishBtn_;
    IBOutlet       UIView       *  headView_;
    
    IBOutlet       UIView *publishView_;
    float                          contentSetY_;
}

@property(nonatomic,weak) IBOutlet UIView       *commentView_;
@property(nonatomic,weak) IBOutlet UITextField  *commentTF_;
@property(nonatomic,weak) IBOutlet UIButton     *giveCommentBtn_;
@property(nonatomic, copy) NSString *keywords;
@property (strong, nonatomic) IBOutlet UIButton *myCopyBtn;

@property (nonatomic,assign) BOOL isSalarySearch;
-(void)hideKeyboard;

@end
