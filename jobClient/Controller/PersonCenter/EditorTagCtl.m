//
//  EditorTagCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-1.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "EditorTagCtl.h"
#import "personTagModel.h"
#import "CustomTagButton.h"

@interface EditorTagCtl ()

@end

@implementation EditorTagCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        rightNavBarStr_ = @"确定";
        
    }
    return self;
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"确定" forState:UIControlStateNormal];
    rightBarBtn_.layer.cornerRadius = 2.0;
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"我的个性标签";
    [self setNavTitle:@"我的个性标签"];
    // Do any additional setup after loading the view from its nib.
    customTagArray_ = [[NSMutableArray alloc]init];
    if ([_tagsType isEqualToString:@"PERSON_LABEL"]) {
//        self.navigationItem.title = @"我的个性标签";
        [self setNavTitle:@"我的个性标签"];
        customTagArray_ = inModel_.tagListArray_;
    }else if ([_tagsType isEqualToString:@"PERSON_SKILL"]){
//        self.navigationItem.title = @"我想学的技能";
        [self setNavTitle:@"我想学的技能"];
        customTagArray_ = inModel_.skillListArray_;
    }else if ([_tagsType isEqualToString:@"PERSON_FIELD"]){
//        self.navigationItem.title = @"我擅长的领域";
        [self setNavTitle:@"我擅长的领域"];
        customTagArray_ = inModel_.fieldListArray_;
    }
    [tagsTextField_ setFont:FIFTEENFONT_TITLE];
    [tagsTextField_ setTextColor:BLACKCOLOR];
    bgView_.layer.cornerRadius = 2.5;
    bgView_.layer.masksToBounds = YES;
    bgView_.layer.borderWidth = 0.5;
    bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
}

- (void)getDataFunction:(RequestCon *)con
{
    
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_ = dataModal;
    
    if (!getTagsCon_) {
        getTagsCon_ = [self getNewRequestCon:NO];
    }
//    if ([_tagsType isEqualToString:@"PERSON_SKILL"]) {
//        _tagsType = @"PERSON_FIELD";
//    }
    [getTagsCon_ getTagsList:_tagsType];
}


- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (con == updateTagsCon_) {
        return;
    }
    [self changTags];
    //默认标签布局
    NSInteger tagCount = [defaultTagArray_ count];
    if (tagCount == 0) {
        return;
    }
    NSInteger remainder = tagCount%2;
    NSInteger line = 0;
    if (remainder ==0) {
        line = tagCount/2;
    }else{
        line = tagCount/2 +1;
    }
    
    //判断默认标签是否已经选择
    for (personTagModel *model in customTagArray_) {
        for (personTagModel *defaultModel in defaultTagArray_) {
            if ([model.tagName_ isEqualToString:defaultModel.tagName_]) {
                defaultModel.isCustomTag = YES;
                continue;
            }
        }
    }
    
    CGFloat width = (ScreenWidth-46)/2.0;
    for (int i=0; i<line; i++) {
        for (int k=0;k<2;k++) {
            if ((2*i+k) < defaultTagArray_.count) {
                personTagModel *model = [defaultTagArray_ objectAtIndex:i*2+k];
                CustomTagButton *button = [[CustomTagButton alloc]init];
                [button setFrame:CGRectMake(18+k*(width+10), 65+i*48, width, 38)];
                [button setTitle:model.tagName_ forState:UIControlStateNormal];
                [button setTag:1000+i*2+k];
                [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                if (model.isCustomTag) {
                    [button setBackgroundColor:[UIColor colorWithRed:118.0/255.0 green:103.0/255.0 blue:104.0/255.0 alpha:1.0]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.isSeleted_ = YES;
                }else{
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
                    button.isSeleted_ = NO;
                }
                [self.scrollView_ setContentSize:CGSizeMake(ScreenWidth, button.frame.origin.y+button.frame.size.height+10)];
                [self.scrollView_ addSubview:button];
            }
        }
    }
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    if( !singleTapRecognizer_ )
        singleTapRecognizer_ = [MyCommon addTapGesture:self.scrollView_ target:self numberOfTap:1 sel:@selector(viewSingleTap:)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [MyCommon removeTapGesture:self.scrollView_ ges:singleTapRecognizer_];
    singleTapRecognizer_ = nil;
}

- (void)rightBarBtnResponse:(id)sender
{
    NSString *tagsString = [[MyCommon removeAllSpace:tagsTextField_.text] stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray *arr = [tagsString componentsSeparatedByString:@","];
    NSMutableArray *tagArray = [[NSMutableArray alloc] init];
    if (arr){
        [tagArray addObjectsFromArray:arr];
    }
    for (int i=0 ;i<[tagArray count];i++) {
        NSString *str = [tagArray objectAtIndex:i];
        if ([str isEqualToString:@""]) {
            [tagArray removeObject:str];
            i--;
        }
    }
    if ([tagArray count] <= 0) {
        [BaseUIViewController showAlertView:nil msg:@"请选择标签" btnTitle:@"确定"];
        return;
    }
    if ([tagArray count] >6) {
        [BaseUIViewController showAlertView:nil msg:@"最多只能设置6个标签" btnTitle:@"确定"];
        return;
    }
    NSString *tagsStr = @"";
    if (tagArray.count > 0) {
        for (int i=0; i< [tagArray count]; i++) {
            NSString *tagModel = [tagArray objectAtIndex:i];
            NSString *temp = @"";
            if (i!= [tagArray count]-1) {
                temp =[NSString stringWithFormat:@"%@,",tagModel];
            }else{
                temp = tagModel;
            }
            tagsStr = [tagsStr stringByAppendingString:temp];
        }
    }
    [tagsTextField_ setText:tagsStr];
    if (self.block) {
        self.block(tagsStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tagButtonClick:(CustomTagButton *)button
{
    NSLog(@"button tag %ld",(long)(button.tag-1000));
    [self changTagsArray:tagsTextField_.text];
    @try {
        if (button.isSeleted_) {
            personTagModel *defualtModel = [defaultTagArray_ objectAtIndex:button.tag-1000];
            defualtModel.isCustomTag = NO;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            button.isSeleted_ = NO;
            for (personTagModel *model in customTagArray_) {
                if ([model.tagName_ isEqualToString:defualtModel.tagName_]) {
                    [customTagArray_ removeObject:model];
                    break;
                }
            }
        }else{
            personTagModel *model = [defaultTagArray_ objectAtIndex:button.tag-1000];
            [button setBackgroundColor:[UIColor colorWithRed:118.0/255.0 green:103.0/255.0 blue:104.0/255.0 alpha:1.0]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.isSeleted_ = YES;
            model.isCustomTag = YES;
            [customTagArray_ addObject:model];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error=%@",exception);
    }
    @finally {
        
    }
    
    
    [self changTags];
    
    
}

- (void)changTagsArray:(NSString *)tagsString
{
    [customTagArray_ removeAllObjects];
    if ([[MyCommon removeSpaceAtSides:tagsString] isEqualToString:@""]) {
        return;
    }
    tagsString = [tagsString stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray  *tagArray = [tagsString componentsSeparatedByString:@","];
    for (NSString *str in tagArray) {
        personTagModel *model = [[personTagModel alloc]init];
        model.tagName_ = str;
        [customTagArray_ addObject:model];
    }
}

- (void)changTags
{
    if (customTagArray_ != nil) {
        NSString *tagsStr =[[NSString alloc]init];
        for (int i=0; i< [customTagArray_ count]; i++) {
            personTagModel *tagModel = [customTagArray_ objectAtIndex:i];
            NSString *temp = @"";
            if (i!= [customTagArray_ count]-1) {
                temp =[NSString stringWithFormat:@"%@,",tagModel.tagName_];
            }else{
                temp = tagModel.tagName_;
            }
            tagsStr = [tagsStr stringByAppendingString:temp];
        }
        [tagsTextField_ setText:tagsStr];
    }
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetTagsList:
        {
            defaultTagArray_ = [dataArr mutableCopy];
        }
            break;
        case Request_UpdateTagsList:
        {
            NSString *status = [dataArr objectAtIndex:0];
            if ([status isEqualToString:@"OK"]) {
                if (self.block) {
                    self.block(_tagsType);
                }
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil seconds:0.5];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
