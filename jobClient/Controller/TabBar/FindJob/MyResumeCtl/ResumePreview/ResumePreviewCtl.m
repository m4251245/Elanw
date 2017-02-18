//
//  ResumePreviewCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-2-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResumePreviewCtl.h"
#import "PreCommon.h"

@implementation ResumePreviewCtl

-(id) init
{
    self = [self initWithNibName:ResumePreviewCtl_Xib_Name bundle:nil];
    
    
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
//    self.navigationItem.title = ResumePreview_Title;
    [self setNavTitle:ResumePreview_Title];
    webView_.dataDetectorTypes = UIDataDetectorTypeNone;
    webView_.scalesPageToFit = YES;
    webView_.delegate = self;
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

-(UIView *) getInReloadSuperView
{
    return nil;
}

//更新状态栏
-(void) updateStatusLabel:(NSString *)text haveError:(BOOL)flag
{
    if( flag )
    {
        statusLb_.textColor = [UIColor redColor];
    }else
        statusLb_.textColor = [UIColor yellowColor];
    
    statusLb_.text = text;
}

-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    if( loadStats_ == FinishLoad ){
        indicatorView_.alpha = 0.0;
        [self updateStatusLabel:@"加载简历完成" haveError:NO];
        
        //开始载入
        if( dataModal_ ){
            NSString * str = [NSString stringWithString:dataModal_.path_];
            //NSLog(@"path=======%@",str);
            NSURL *path = [[NSURL alloc] initWithString:str];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:path];
            [webView_ loadRequest:request];
        }
    }else if( loadStats_ == ErrorLoad ){
        [webView_ loadHTMLString:@"" baseURL:nil];
        indicatorView_.alpha = 0.0;
        [self updateStatusLabel:@"载入有误" haveError:YES];
    }else
    {
        indicatorView_.alpha = 1.0;
        [self updateStatusLabel:@"正在加载简历参数..." haveError:NO];
    }
}

-(void) getDataFunction
{
    //首先去获取自己的简历path
    [PreRequestCon_ loadResumePath:ShowResumeType];
}

#pragma UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateStatusLabel:@"正在载入您的简历..." haveError:NO];
    
    indicatorView_.alpha = 1.0;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateStatusLabel:@"加载简历完成." haveError:NO];
    
    indicatorView_.alpha = 0.0;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateStatusLabel:@"显示简历时遇到错误,简历可能无法正常显示." haveError:YES];
    
    indicatorView_.alpha = 0.0;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch ( navigationType ) {
        case UIWebViewNavigationTypeLinkClicked:
            return NO;
            break;
            
        default:
            break;
    }
    
    return YES;
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case GetResumePath_XMLParser:
        {            
            @try {
                dataModal_ = nil;
                dataModal_ = [dataArr objectAtIndex:0];
            }
            @catch (NSException *exception) {

            }
            @finally {
                
            }
            
        }
            break;
        default:
            break;
    }
}

@end
