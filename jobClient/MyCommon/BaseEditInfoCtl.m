//
//  BaseEditInfoCtl.m
//  MBA
//
//  Created by sysweal on 13-12-14.
//  Copyright (c) 2013年 job1001. All rights reserved.
//

#import "BaseEditInfoCtl.h"

@interface BaseEditInfoCtl ()
{
    CGPoint oldPoint;
}
@end

@implementation BaseEditInfoCtl

@synthesize currentFocusView_,scrollView_,toolbarHolder,keyboardItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //增加键盘事件的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    
//    self.view.frame = [UIScreen mainScreen].bounds;
    scrollView_.delegate = self;
    
    [scrollView_ setContentSize:CGSizeMake(0, self.view.frame.size.height)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    toolbarHolder = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-44,ScreenHeight, 44, 30)];
    toolbarHolder.backgroundColor = [UIColor whiteColor];
//    toolbarHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    UIView *toolbarCropper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
//    toolbarCropper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    toolbarCropper.clipsToBounds = YES;
//    
//    // Use a toolbar so that we can tint
//    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
//    keyboardToolbar.center = CGPointMake(22,15);
//    [toolbarCropper addSubview:keyboardToolbar];
//    
//    keyboardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSkeyboard.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
//    
//    keyboardToolbar.items = @[keyboardItem];
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    hideButton.frame = CGRectMake(0,0,44,30);
    [hideButton setImage:[UIImage imageNamed:@"ZSSkeyboard"] forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [toolbarHolder addSubview:hideButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6f, 30)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.7f;
    [toolbarHolder addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 0.6f)];
    line2.backgroundColor = [UIColor lightGrayColor];
    line2.alpha = 0.7f;
    [toolbarHolder addSubview:line2];
    
    [self.view addSubview:self.toolbarHolder];
    
    
    //设置代理
    for ( UIView *subView in [scrollView_ subviews] ) {
        if( [subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]] ){
            UITextField *tf = (UITextField *)subView;
            tf.delegate = self;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置按扭的默认文字
+(void) setBtnDefaultValue:(UIButton *)btn str:(NSString *)str
{
    if( !str || [str isEqualToString:@""] || [str isEqualToString:@"暂无"] ){
        str = @"请选择";
    }
    
    [btn setTitle:str forState:UIControlStateNormal];
}

//根据按扭的默认文字获取str
+(NSString *) getBtnRealValue:(UIButton *)btn
{
    NSString *str = btn.titleLabel.text;
    if( !str || [str isEqualToString:@"请选择"] ){
        str = @"";
    }
    
    return str;
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal_ = dataModal;
    
    [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
    
    @try {
        [self updateCom:nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma UIScrollViewDelegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [currentFocusView_ resignFirstResponder];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentFocusView_ = textField;

    return YES;
}


#pragma UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    currentFocusView_ = textView;
    
    return YES;
}

- (void)superKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyBoardFrame = [aValue CGRectValue];
    _keyBoardHeight = _keyBoardFrame.size.height;
    [self keyboardWillShow:notification];
}

- (void)superkeyboardWillHide:(NSNotification *)notification{
    [self keyboardWillHide:notification];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    oldPoint = scrollView_.contentOffset;
    if( !singleTapRecognizer_ ){
        singleTapRecognizer_ = [MyCommon addTapGesture:scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
    }
    
    CGRect keyboardRect = [self.view convertRect:_keyBoardFrame fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    float h = keyboardTop - self.view.bounds.origin.y - 35;
    
    if ([currentFocusView_ isFirstResponder]) {
        
        CGRect convertRect = [scrollView_ convertRect:currentFocusView_.frame fromView:[currentFocusView_ superview]];
 
        NSDictionary *userInfo = [notification userInfo];
        NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        if( convertRect.origin.y + convertRect.size.height + 10 > h ){
            //需要移动scrollView
            CGPoint point = scrollView_.contentOffset;
            point.y = convertRect.origin.y + convertRect.size.height + 10 - h;
            [scrollView_ setContentOffset:point animated:YES];
        }
    }
    [self showKeyBoardButtonWithBool:YES];
}

-(void)showKeyBoardButtonWithBool:(BOOL)show{
    if (show) {
        [self.view bringSubviewToFront:toolbarHolder];
        CGRect frame = toolbarHolder.frame;
        frame.origin.y = self.view.frame.size.height - (_keyBoardHeight + toolbarHolder.frame.size.height);
        self.toolbarHolder.frame = frame;
    }else{
        CGRect frame = self.toolbarHolder.frame;
        frame.origin.y = self.view.frame.size.height;
        self.toolbarHolder.frame = frame;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
    
//    CGPoint point = scrollView_.contentOffset;
//    [self.scrollView_ setContentSize:CGSizeMake(self.scrollView_.frame.size.width, self.scrollView_.frame.size.height+1)];
//    if( point.y < 0 ){
//        [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else if( scrollView_.frame.size.height + point.y > scrollView_.contentSize.height ){
//        if( scrollView_.frame.size.height > scrollView_.contentSize.height ){
//            [scrollView_ setContentOffset:CGPointMake(0, 0) animated:YES];
//        }else
//            [scrollView_ setContentOffset:CGPointMake(0, scrollView_.contentSize.height - scrollView_.frame.size.height) animated:YES];
//    }
    if(oldPoint.y < 0 || scrollView_.frame.size.height>scrollView_.contentSize.height || !scrollView_.scrollEnabled){
        oldPoint = CGPointZero;
    }
    self.scrollView_.contentOffset = oldPoint;
    [self showKeyBoardButtonWithBool:NO];
}

//自己视图的单击事件
-(void) viewSingleTap:(id)sender
{
    [currentFocusView_ resignFirstResponder];
}

//根据编辑的数据设置数据(子类重写)
-(BOOL) setEditModal:(User_DataModal *)dataModal
{
    return YES;
}

#pragma CondictionListDelegate
-(void) condictionListCtlChoosed:(CondictionListCtl *)ctl dataModal:(CondictionList_DataModal *)dataModal
{
    
}

-(void)dismissKeyboard
{
    [currentFocusView_ resignFirstResponder];
}

@end
