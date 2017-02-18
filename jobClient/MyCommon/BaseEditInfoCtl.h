//
//  BaseEditInfoCtl.h
//  MBA
//
//  Created by sysweal on 13-12-14.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "User_DataModal.h"
#import "CondictionListCtl.h"

@interface BaseEditInfoCtl : BaseUIViewController<CondictionListDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UITapGestureRecognizer  *singleTapRecognizer_;  //单击的事件
    
    User_DataModal          *inModal_;      //传进来的值
}

@property(nonatomic,strong) UIView      *currentFocusView_;
@property(nonatomic,weak)   IBOutlet    UIScrollView    *scrollView_;
@property (nonatomic, strong) UIView *toolbarHolder;
@property (nonatomic, strong) UIBarButtonItem *keyboardItem;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, assign) CGRect keyBoardFrame;

//设置按扭的默认文字
+(void) setBtnDefaultValue:(UIButton *)btn str:(NSString *)str;

//根据按扭的默认文字获取str
+(NSString *) getBtnRealValue:(UIButton *)btn;

//自己视图的单击事件
-(void) viewSingleTap:(id)sender;

//根据编辑的数据设置数据(子类重写)
-(BOOL) setEditModal:(User_DataModal *)dataModal;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
-(void)dismissKeyboard;

//显示和隐藏键盘右上角按钮
-(void)showKeyBoardButtonWithBool:(BOOL)show;

@end
