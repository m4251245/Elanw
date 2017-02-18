//
//  CreaterGroupCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CreaterGroupCtl.h"
#import "CreateGroupStep2Ctl.h"
#import "UpdateGroupPhotoCtl.h"
#import "ELCreatChangeCtl.h"
#import "ELLineView.h"

@interface CreaterGroupCtl () <UITextViewDelegate,ChangeTypeDelegate>
{
    __weak IBOutlet UITextView *groupNameTV; //社群名称输入框
    
    __weak IBOutlet UITextView *groupIntroTV; //社群简介输入框
    
    __weak IBOutlet UILabel *groupNameLb; //社群名称输入框无内容文本
    
    __weak IBOutlet UILabel *groupIntroLb  //社群简介输入框无内容文本
;
    __weak IBOutlet UILabel *changeLb; //加群验证类型显示的文本
     
    __weak IBOutlet UIButton *changeButton; //加群验证选择按钮
    
    BOOL fillFinish; //标识能否点击下一步
    
    NSString *changeStatus; //标识加群验证的状态
    
    CreateGroupDataModel *groupModel_; //存放社群信息
    CGFloat textViewHeight; //标识社群名称输入框的高
    __weak IBOutlet UIView *titleBackView;
    
}
@end

@implementation CreaterGroupCtl
@synthesize enterType_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"下一步";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView_.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
    
//    self.navigationItem.title = @"创建社群";
    [self setNavTitle:@"创建社群"];
    groupNameTV.delegate = self;
    groupIntroTV.delegate = self;
    
    changeLb.text = kJoinTypeAll;
    changeStatus = @"100";
    
    [self changeDataFillFinish];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    groupNameTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    groupIntroTV.textContainerInset = UIEdgeInsetsMake(0,0,0,0);
    //标题下方的线
    ELLineView *lineView = [[ELLineView alloc] initWithFrame:CGRectMake(0,56,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [titleBackView addSubview:lineView];
}

#pragma mark - 动态改变社群名称输入框的高度和位置
-(void)textChanged:(UITextView *)textView{
    if (groupNameTV.isFirstResponder){
        [self changeDataFillFinish];
        CGRect textFrame = [[groupNameTV layoutManager] usedRectForTextContainer:[groupNameTV textContainer]];
        CGFloat height = textFrame.size.height;
        if (fabs(height -textViewHeight) < 10) {
            return;
        }
        CGRect frame = groupNameTV.frame;
        if (height < 20) {
            frame.origin.y = 18;
        }else{
            frame.origin.y = 10;
        }
        groupNameTV.frame = frame;
        textViewHeight = height;
    }
}

#pragma mark - 修改右上方按钮的状态
-(void)setDataFinish:(BOOL)isFinish{
    if (isFinish) {
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
    }
}

-(void)changeDataFillFinish{
    BOOL isFinish = NO;
    fillFinish = NO;
    if(groupNameTV.text.length > 0){
        fillFinish = YES;
        isFinish = YES;
    }
    [self setDataFinish:isFinish];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == groupNameTV) {
        if (textView.text.length <= 0) {
            groupNameLb.hidden = NO;
        }
    }else if (textView == groupIntroTV) {
        if (textView.text.length <= 0) {
            groupIntroLb.hidden = NO;
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == groupNameTV) {
        groupNameLb.hidden = YES;
    }else if (textView == groupIntroTV) {
        groupIntroLb.hidden = YES;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView == groupNameTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:groupNameTV wordsNum:20];
    }else if(textView == groupIntroTV){
        [MyCommon dealLabNumWithTipLb:nil numLb:nil textView:groupIntroTV wordsNum:250];
    }
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"下一步" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 50, 44)];
    [rightBarBtn_.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
}

- (void)btnResponse:(id)sender
{ 
    if (sender == changeButton) {
        ELCreatChangeCtl *changeCtl = [[ELCreatChangeCtl alloc] init];
        changeCtl.selectModel = [[ELGroupChangeTypeModel alloc] init];
        changeCtl.selectModel.status = changeLb.text;
        changeCtl.typeDeleagte = self;
        changeCtl.dataType = JoinType;
        [self.navigationController pushViewController:changeCtl animated:YES];
    }
}

-(void)selectTypeWithName:(ELGroupChangeTypeModel *)dataModel{
    if (dataModel) {
        changeLb.text = dataModel.status;
        changeStatus = dataModel.detailStatus;
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    if (!fillFinish) {
        return;
    }
    if ([MyCommon stringContainsEmoji:groupNameTV.text]){
        [BaseUIViewController showAlertViewContent:@"社群名称不能包含表情" toView:self.view second:1.0 animated:YES];
        return;
    }
    if (!groupModel_) {
        groupModel_ = [[CreateGroupDataModel alloc]init];
    }
    groupModel_.isPublic_ = changeStatus;
    groupModel_.groupName_ = [MyCommon removeSpaceAtSides:groupNameTV.text];
    groupModel_.groupIntro = [MyCommon removeSpaceAtSides:groupIntroTV.text];
    
    [groupNameTV resignFirstResponder];
    [groupIntroTV resignFirstResponder];
    UpdateGroupPhotoCtl *photoCtl = [[UpdateGroupPhotoCtl alloc]init];
    photoCtl.groupMoal_ = groupModel_;
    photoCtl.inType = CREATEGROUP;
    photoCtl.enterType_ = enterType_;
    [photoCtl beginLoad:groupModel_ exParam:nil];
    [self.navigationController pushViewController:photoCtl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
