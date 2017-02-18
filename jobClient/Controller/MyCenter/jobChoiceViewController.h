//
//  jobChoiceViewController.h
//  jobClient
//
//  Created by 一览ios on 15/12/23.
//  Copyright © 2015年 YL1001. All rights reserved.
//


#import "BaseUIViewController.h"

@class jobChoiceViewController;

@protocol jobChoiceDelegate <NSObject>

-(void)jobChoiceCtl:(jobChoiceViewController *)jobChoiceCtl selectedArr:(NSMutableArray *)selectedArr;

@end


@interface jobChoiceViewController : BaseUIViewController
@property (weak, nonatomic) IBOutlet UITableView *tabview;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSMutableArray *dataRctdArr;//数据列表
@property (nonatomic, strong) NSMutableArray *titleArr;//存放标题的数组

@property (nonatomic, assign) id <jobChoiceDelegate> delegate;

-(void)showJobChoiceList;
-(void)hideJobChoiceList;

- (IBAction)makeSureClick:(id)sender;

@end
