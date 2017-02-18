//
//  SalaryIrrigationDtailCtl.h
//  jobClient
//
//  Created by 一览ios on 14/11/27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "BaseListCtl.h"
#import "ToReportCtl.h"
#import "ELSalaryModel.h"


@protocol SalaryIrrigationDetailDelegate <NSObject>

@optional

-(void)refreshCommentIndex:(NSInteger)indexPathRow Count:(NSInteger)count;

-(void)refreshAddLikeIndex:(NSInteger)indexPathRow Count:(NSInteger)count;

-(void)refreshActivityCell:(ELSalaryModel *)modal index:(NSInteger)row;

@end

@interface SalaryIrrigationDetailCtl : BaseListCtl<UITextViewDelegate,UIScrollViewDelegate>
{
     ELSalaryModel* inModal_;//
    
    IBOutlet UIButton * moreBtn_;
    
    IBOutlet UIView    * popView_;
    IBOutlet UIButton  * shareBtn2_;
    IBOutlet UIButton  * jubaoBtn_;
    
    IBOutlet UIView *allCommentView;
}

@property (nonatomic,weak) id <SalaryIrrigationDetailDelegate> salaryDetailDelegate;

@property (nonatomic, strong) NSString *articeId;

@property (nonatomic, strong) ELSalaryModel *article;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UITextView *commentTF_;
@property (weak, nonatomic) IBOutlet UIButton *noNameCommentBtn;
@property (weak, nonatomic) IBOutlet UIView *commentView_;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@property (weak, nonatomic) IBOutlet UILabel *tspLb;

@property (nonatomic,assign) NSInteger path;

- (IBAction)noNameCommentBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *myCopyBtn;

@property (nonatomic,assign) BOOL isPop;

@end
