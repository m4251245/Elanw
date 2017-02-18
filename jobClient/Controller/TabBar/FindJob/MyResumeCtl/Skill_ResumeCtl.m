//
//  Skill_ResumeCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-2-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Skill_ResumeCtl.h"
#import "PreCommon.h"
#import "PreStatus_DataModal.h"
#import "BaseUIViewController.h"
@implementation Skill_ResumeCtl{
    NSString *detailStr;
}

-(id) init
{
    self = [self initWithNibName:Skill_ResumeCtl_Xib_Name bundle:nil];
    
    
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

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    detailStr = dataModal;
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = Skill_ResumeCtl_Title;
    [self setNavTitle:Skill_ResumeCtl_Title];
    //设置代理
    desTv_.delegate = self;
    
    [desTv_ setFont:FOURTEENFONT_CONTENT];
    [desTv_ setTextColor:BLACKCOLOR];
//    [_wordsNumLb setFont:[UIFont fol]];
//    [grayWordLb setFont:FOURTEENFONT_CONTENT];

    [self updateComInfo:nil];
    
//    [titleBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
//    [titleLb_ setFont:FOURTEENFONT_CONTENT];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gest:)];
    [self.view addGestureRecognizer:tap];
    
    saveBtn_.layer.cornerRadius = 3;
    saveBtn_.layer.masksToBounds = YES;
    
    scrollView_.backgroundColor = UIColorFromRGB(0xf0f0f0);
    saveBtn_.titleLabel.font = [UIFont systemFontOfSize:16];

}

-(void)viewDidAppear:(BOOL)animated{
    scrollView_.contentSize = CGSizeMake(ScreenWidth, 100 + ScreenHeight);
}

-(void)gest:(UIGestureRecognizer *)sender
{
    [desTv_ resignFirstResponder];
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


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger i = 1000;
    if ((textView.text.length + text.length) >= i)
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
        textView.text = [str substringWithRange:NSMakeRange(0,i)];
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == desTv_)
    {
        if (textView.text.length == 0)
        {
            _wordsNumLb.text = @"1000";
        }else if (textView.text.length >= 1000){
            _wordsNumLb.text = @"0";
            
        }else
        {
            _wordsNumLb.text = [NSString stringWithFormat:@"%ld",(long)(1000 - textView.text.length)];
        }
        
        if (textView.text.length > 0)
        {
            grayWordLb.hidden = YES;
        }
        else
        {
            grayWordLb.hidden = NO;
        }
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        grayWordLb.hidden = NO;
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [grayWordLb setHidden:YES];
}


//让有焦点的控件失去焦点
-(void) comResignFirstResponse
{
    
    [grayWordLb setHidden:YES];
    [desTv_ resignFirstResponder];
}

//更新控件上的值
-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    if (detailStr == nil) {
        detailStr = @"";
    }
    
    if(![detailStr isEqualToString:@""])
    {
        grayWordLb.hidden = YES;
        desTv_.text = detailStr;
    }
        else
        {
            desTv_.text = @"";
            grayWordLb.hidden = NO;
        }
        [self textViewDidChange:desTv_];
}

-(void) getDataFunction
{
    //不用载入数据
    loadStats_ = FinishLoad;
}

//检查是否能保存
-(BOOL) checkCanSave
{
    if( [PreCommon checkStringIsNull:[desTv_.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请您输入工作技能"    delegate:nil
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        desTv_.text = @"";
        return NO;
    }
    
    return YES;
}

//保存数据
-(void) saveResume
{
    [super saveResume];
        des_ = nil;
        des_ = desTv_.text;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@"othertc" forKey:@"columnName"];
        [dic setObject:des_ forKey:@"columnValue"];
        
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:dic];
        
        NSString *whereId = [NSString stringWithFormat:@"id=%@",[Manager getUserInfo].userId_];
        
        [dict setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
        [dict setObject: array forKey:@"update"];
        [dict setObject: whereId forKey:@"where"];
        
        NSString *searchStr = [jsonWrite stringWithObject:dict];
        
        NSString *bodyMsg = [NSString stringWithFormat:@"param=%@",searchStr];
        NSString *op = @"person_info_busi";
        NSString *func = @"updatePersonDetail";
        
        [BaseUIViewController showLoadView:YES content:nil view:nil];
        [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
            
            NSDictionary *dic = result;
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            if ([dic[@"status"] isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:nil msg:@"保存成功"];
                if (self.block) {
                    self.block();
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
        }];
}

-(void) buttonResponse:(id)sender
{
    //保存
    if( sender == saveBtn_ )
    {
        [self saveResume];
    }
}

@end
