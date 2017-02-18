//
//  KeyboardReturnCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-4-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "KeyboardReturnCtl.h"
#import "PreCommon.h"


//当前哪个处于键盘焦点状态
UIView *currentFocusView;

@implementation KeyboardReturnCtl

-(id) init
{
    self = [self initWithNibName:@"KeyboardReturnCtl" bundle:nil];

    //增加键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self changeSize];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//重写父类的changSize方法
-(void) changeSize
{
    //让自己显示在视视图的底部
    CGRect rect = self.view.frame;
    rect.origin.x = MainHeight - rect.size.width;
    rect.origin.y = [self.view superview].frame.size.height;
    [self.view setFrame:rect];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    //Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [[self.view superview] convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newFream = self.view.bounds;
    newFream.origin.x = MainWidth - newFream.size.width;
    newFream.origin.y = keyboardTop - newFream.size.height;
    
    //Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = newFream;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect newFream = self.view.bounds;
    newFream.origin.x = MainWidth - newFream.size.width;
    newFream.origin.y = [self.view superview].frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = newFream;
    [UIView commitAnimations];
}

-(void) buttonResponse:(id)sender
{
    //失去焦点
    [currentFocusView resignFirstResponder];
    
    //将自己隐藏
    [self hide];
}

@end
