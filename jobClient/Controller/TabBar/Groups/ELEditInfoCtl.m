//
//  ELEditInfoCtl.m
//  jobClient
//
//  Created by 一览ios on 17/1/6.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELEditInfoCtl.h"
#import "ELGroupDetailModal.h"
#import "ELNewsListDAO.h"
#import "ELNewNewsListVO.h"

@interface ELEditInfoCtl ()
{
    UITextField *editTF;
    NSString *defaultValue;
    ELGroupDetailModal   *myDataModal_;
    RequestCon     *updateCon_;
}
@end

@implementation ELEditInfoCtl
#pragma mark ------------ lifecycle ------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"保存";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNavTitle:@"修改社群名称"];
}

- (void)configUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    bgView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:bgView];
    
    editTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-40, 44)];
    //    editTF.backgroundColor = UIColorFromRGB(0xffffff);
    editTF.text = myDataModal_.group_name;
    editTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:editTF];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    myDataModal_ = dataModal;
    
    [self configUI];
}
#pragma mark --------------netWork -------------------
- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    switch (type) {
        case Request_UpdateGroups:
        {
            if ([[dataArr objectAtIndex:0] isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil seconds:0.5];
                myDataModal_.group_name = editTF.text;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kChangeGroupName" object:nil userInfo:@{@"groupName":editTF.text,@"groupId":myDataModal_.group_id}];
                
                ELNewsListDAO *listDao = [[ELNewsListDAO alloc] init];
               ELNewNewsListVO *listVo = [listDao findByType:@"group_chat_msg" info:myDataModal_.group_id personId:[Manager getUserInfo].userId_ close:YES];
                listVo.title = editTF.text;
                [listDao updateOneData:listVo];

                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:nil seconds:0.5];
            }

        }
            break;
            
        default:
            break;
    }
}

#pragma mark -------------- event response---------------
- (void)rightBarBtnResponse:(id)sender
{
    [super rightBarBtnResponse:sender];
    
    if (editTF.text.length <= 0) {
        [BaseUIViewController showAlertViewContent:@"社群名称不能为空" toView:self.view second:1.0 animated:YES];
        return;
    }
    if ([MyCommon stringContainsEmoji:editTF.text]) {
        [BaseUIViewController showAlertViewContent:@"社群名称不能包含表情" toView:self.view second:1.0 animated:YES];
        return;
    }
    
    [editTF resignFirstResponder];
    if (!updateCon_){
        updateCon_ = [self getNewRequestCon:NO];
    }
    [updateCon_ updateGroups:[Manager getUserInfo].userId_ groupId:myDataModal_.group_id groupName:editTF.text groupIntro:myDataModal_.group_intro groupTag:myDataModal_.group_tag_names openStatus:myDataModal_.group_open_status groupPic:nil];
    
}

#pragma mark - keyBoard
-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight;
    self.scrollView_.frame = frame;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight-self.keyBoardHeight;
    self.scrollView_.frame = frame;
}

- (void)dismissKeyboard
{
    [editTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
