//
//  BaseSingleCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-2-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseSingleCtl.h"


@implementation BaseSingleCtl

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
    [deleteBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [deleteBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn_.layer.cornerRadius = 2.0;
    
    [indexBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
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

//重写changeSize
-(void) changeSize
{

}

//根据index设置自己的标题
-(void) setTitleIndex:(int)index
{
    index_ = index;
}

//设置favtherCtl
-(void) setFatherCtl:(id<FatherSingleDelegate>)ctl
{
    fatherCtl_ = ctl;
}

//自动移动自己到顶端,让自己好输入
-(void) autoMove:(UIView *)obj
{
    [fatherCtl_ autoMove:obj];
}

//恢复已移动的视图
-(void) recoverMoveSize
{
    [fatherCtl_ recoverMoveSize];
}

//询问是否删除自己
-(void) tryDeleteMyself
{
    //提示是否进行登录
    NSString *msg = [[NSString alloc] initWithFormat:@"%@\n是否确定删除?",indexBtn_.titleLabel.text];
    [self showChooseAlertView:Choose_DelSingleCtl title:msg msg:nil okBtnTitle:@"删除" cancelBtnTitle:@"取消"];
}

//删除自己
-(void) deleteMyself
{
    bDelete_ = YES;
    
    [fatherCtl_ delCtl:index_];
}

-(void) alertViewChoosed:(UIAlertView *)alertView index:(NSInteger)index type:(ChooseAlertViewType)type
{
    switch ( type ) {
        case Choose_DelSingleCtl:
        {
             [self deleteMyself];
        }
            break;
            
        default:
            break;
    }
}

-(void) buttonClick:(id)sender
{
    [super buttonClick:sender];
    
    //删除
    if( sender == deleteBtn_ )
    {
        [self tryDeleteMyself];
    }
}

- (void)backBarBtnResponse:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
