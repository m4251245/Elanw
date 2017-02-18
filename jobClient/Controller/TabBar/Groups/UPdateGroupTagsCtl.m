//
//  UPdateGroupTagsCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-10-15.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "UPdateGroupTagsCtl.h"

static NSInteger kMaxTextLenght = 8;
static NSInteger kMarging = 10;

@interface UPdateGroupTagsCtl ()
{
    UIButton *_deleteBtn;
    CGRect previousFrame;
    BOOL isFlag;
}
@end

@implementation UPdateGroupTagsCtl
@synthesize delegate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightNavBarStr_ = @"完成";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"标签修改"];
    
    [groupTagTfview_ addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [groupTagTfview_ setTextColor:BLACKCOLOR];
    [groupTagTfview_ setFont:TWEELVEFONT_COMMENT];
    groupTagTfview_.layer.cornerRadius = 2;
    
    TFbackView.layer.cornerRadius = 12;
    TFbackView.layer.borderWidth = 1;
    TFbackView.layer.borderColor = GRAYCOLOR.CGColor;
    TFbackView.layer.masksToBounds = YES;
    
    self.scrollView_.layer.masksToBounds = YES;
    
    _alertlab = [[UILabel alloc] init];
    [_alertlab setFont:NINEFONT_TIME];
    _alertlab.textColor = REDCOLOR;
    _alertlab.textAlignment = NSTextAlignmentCenter;
    [self.scrollView_ addSubview:_alertlab];
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 50, 35)];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_03.png"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteTagDidPush:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    
}


- (void)addTagToLast:(NSString *)tag animated:(BOOL)animated
{
    for (NSString *t in _tagsMade)
    {
        //是否存在相同标签
        if ([tag isEqualToString:t])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"标签已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }
    
    [_tagsMade addObject:tag];
    groupTagTfview_.text = @"";
    
    if (_tagsMade.count > 6) {
        [BaseUIViewController showAlertView:@"最多输入6个标签" msg:nil btnTitle:@"知道了"];
        [groupTagTfview_ resignFirstResponder];
        [_tagsMade removeLastObject];
    }
    else
    {
        [self addTagViewToLast:tag animated:animated];
        [self layoutGroupTfAndGourpView];
    }
}

- (void)removeTag:(NSString *)tag animated:(BOOL)animated
{
    NSInteger foundedIndex = -1;
    for (NSString *t in _tagsMade)
    {
        if ([tag isEqualToString:t])
        {
            foundedIndex = (NSInteger)[_tagsMade indexOfObject:t];
            break;
        }
    }
    
    if (foundedIndex == -1)
    {
        return;
    }
    
    [_tagsMade removeObjectAtIndex:foundedIndex];
    
    [self removeTagViewWithIndex:foundedIndex animated:animated];
}

//添加标签按钮
- (void)addTagViewToLast:(NSString *)newTag animated:(BOOL)animated
{
    CGFloat posX = [self posXForObjectNextToLastView];
    CustomButton *tagBtn = [self tagButtonWithTag:newTag posX:posX];
    [_tagViews addObject:tagBtn];
    
    tagBtn.tag = [_tagViews indexOfObject:tagBtn];
    
    [self.scrollView_ addSubview:tagBtn];
    
    if (animated)
    {
        tagBtn.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            tagBtn.alpha = 1.0f;
        }];
    }
}

//移除后的标签按钮的位置
- (void)removeTagViewWithIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSAssert(index < _tagViews.count, @"incorrected index");
    if (index >= _tagViews.count)
    {
        return;
    }
    
    UIView *deletedView = [_tagViews objectAtIndex:index];
    [deletedView removeFromSuperview];
    [_tagViews removeObject:deletedView];
    
    NSMutableArray *tagViewsCopy = [[NSMutableArray alloc] init];
    for (int i = 0; i < _tagViews.count; i++)
    {
        CustomButton *button = [_tagViews objectAtIndex:i];
        [tagViewsCopy addObject:button];
    }
    [_tagViews removeAllObjects];
    lineNum = 1;
    
    for (id obj in self.scrollView_.subviews)
    {
        if ([obj isKindOfClass:[CustomButton class]])
        {
            CustomButton* theButton = (CustomButton*)obj;
            [theButton removeFromSuperview];
        }
    }
    
    if (tagViewsCopy.count == 0)
    {
        [self layoutGroupTfAndGourpView];
    }
    else
    {
        for (int j = 0; j < tagViewsCopy.count; j++)
        {
            CustomButton *btn = [tagViewsCopy objectAtIndex:j];
            
            [self addTagViewToLast:btn.titleLabel.text animated:YES];
            [self layoutGroupTfAndGourpView];
        }
    }
}

//刷新视图
- (void)layoutGroupTfAndGourpView
{
    CGFloat accumX = [self posXForObjectNextToLastView];
    
    CGRect inputRect = groupTagTfview_.frame;
    inputRect.size.width = 60;
    groupTagTfview_.frame = inputRect;

    CGRect backRect = CGRectZero;
    if (self.scrollView_.frame.size.width - accumX - _tagGap > 85) {
        
        backRect = TFbackView.frame;
        backRect.origin.x = accumX;
        backRect.origin.y = previousFrame.origin.y;
        backRect.size.width = 85;
        TFbackView.frame = backRect;
        
        backRect = addBtn.frame;
        backRect.origin.x = 65;
        addBtn.frame = backRect;
    }
    else
    {
        backRect = TFbackView.frame;
        backRect.origin.x = _tagGap;
        backRect.origin.y = lineNum * (25 + _tagGap) + 38;
        backRect.size.width = 85;
        TFbackView.frame = backRect;
        
        backRect = addBtn.frame;
        backRect.origin.x = 65;
        addBtn.frame = backRect;
    }
}

//获取最后一个标签的坐标
- (CGFloat)posXForObjectNextToLastView
{
    CGFloat accumX = _tagGap;
    if (_tagViews.count)
    {
        UIView *last = _tagViews.lastObject;
        accumX = last.frame.size.width + last.frame.origin.x + _tagGap;
    }
    
    return accumX;
}
 
//创建标签按钮
- (CustomButton *)tagButtonWithTag:(NSString *)tag posX:(CGFloat)posX
{
    _tagBtn = [[CustomButton alloc] init];
    [_tagBtn.titleLabel setFont:THIRTEENFONT_CONTENT];
    [_tagBtn setBackgroundColor:[UIColor whiteColor]];
    _tagBtn.layer.borderWidth = 1;
    _tagBtn.layer.cornerRadius = 12;
    _tagBtn.layer.borderColor = REDCOLOR.CGColor;
    [_tagBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
    [_tagBtn addTarget:self action:@selector(tagBtnDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    [_tagBtn setTitle:tag forState:UIControlStateNormal];
    _tagBtn.clickState = 1;
    
    _tagBtn.frame = CGRectMake(posX, 25, 0, 25);
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSParagraphStyleAttributeName: paragraph};
    
    CGSize textSize = [tag boundingRectWithSize:CGSizeMake(self.scrollView_.frame.size.width, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    textSize.width += 7.0*2;
    
    if (_tagViews.count == 0)
    {
        _tagBtn.frame = CGRectMake(_tagGap, 38, textSize.width, 25);
    }
    else
    {
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + textSize.width + _tagGap > self.scrollView_.frame.size.width)
        {
            newRect.origin = CGPointMake(_tagGap, previousFrame.origin.y + 25 + _tagGap);
            lineNum += 1;
        }
        else
        {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + _tagGap, previousFrame.origin.y);
        }
        newRect.size = textSize;
        newRect.size.height = 25;
        _tagBtn.frame = newRect;
    }
    
    previousFrame = _tagBtn.frame;
    
    return _tagBtn;
}

- (void)tagBtnDidPushed:(CustomButton *)btn
{
    
    if (_deleteBtn.hidden == NO && btn.tag == _deleteBtn.tag)
    {
        // hide delete button
        _deleteBtn.hidden = YES;
        [_deleteBtn removeFromSuperview];
    }
    else
    {
        // show delete button
        CGPoint newCenter = btn.center;
        _deleteBtn.center = newCenter;
        
        CGRect newRect = _deleteBtn.frame;
        newRect.origin.y = btn.frame.origin.y - 35;
        _deleteBtn.frame = newRect;
        _deleteBtn.tag = btn.tag;
        
        if (_deleteBtn.superview == nil)
        {
            [self.scrollView_ addSubview:_deleteBtn];
        }
        [self.scrollView_ addSubview:_deleteBtn];
        _deleteBtn.hidden = NO;
    }
    
    for (id obj in self.scrollView_.subviews)
    {
        if ([obj isKindOfClass:[CustomButton class]])
        {
            CustomButton *button = (CustomButton *)obj;
            
            if (button.tag != btn.tag)
            {
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setTitleColor:REDCOLOR forState:UIControlStateNormal];
                button.clickState = 1;
            }
            else
            {
                switch (btn.clickState)
                {
                    case 1:
                    {
                        [button setBackgroundColor:REDCOLOR];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        button.clickState = 2;
                    }
                        break;
                    case 2:
                    {
                        [button setBackgroundColor:[UIColor whiteColor]];
                        [button setTitleColor:REDCOLOR forState:UIControlStateNormal];
                        button.clickState = 1;
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

- (void)deleteTagDidPush:(id)sender
{
    NSAssert(_tagsMade.count > _deleteBtn.tag, @"out of range");
    if (_tagsMade.count <= _deleteBtn.tag)
    {
        return;
    }
    
    _deleteBtn.hidden = YES;
    [_deleteBtn removeFromSuperview];
    
    NSString *tag = [_tagsMade objectAtIndex:_deleteBtn.tag];
    [self removeTag:tag animated:YES];
}

//计算字符串长度
-(NSInteger)unicodeLengthOfString:(NSString *)text
{
    NSInteger i,l=0,a=0,b=0;
    NSInteger n=[text length];
    
    unichar c;
    
    for(i=0;i<n;i++){
        
        c=[text characterAtIndex:i];
        
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    
    return l+(NSInteger)ceilf((CGFloat)(a+b)/2.0);
}


#pragma mark - UITextFileDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    //tag字数限制 最多八个
    [MyCommon dealTxtFiled:groupTagTfview_ maxLength:kMaxTextLenght];
    
    
    NSString *text = textField.text;
    //textField宽度
    CGFloat newWidth = 0;
    newWidth = [text sizeWithAttributes:@{NSFontAttributeName:THIRTEENFONT_CONTENT}].width;
    
    CGRect inputRect = groupTagTfview_.frame;
    
    if (newWidth + 20 > ScreenWidth - 2*kMarging)
    {
        inputRect.size.width = ScreenWidth - 2*kMarging - 20;
    }
    else
    {
        if (newWidth <= 60 )
        {
            inputRect.size.width = 60;
        }
        else
        {
            inputRect.size.width = newWidth + (groupTagTfview_.layer.cornerRadius * 2.0f);
        }
    }
    
    groupTagTfview_.frame = inputRect;
    
    inputRect = addBtn.frame;
    inputRect.origin.x = groupTagTfview_.frame.size.width + 5;
    addBtn.frame = inputRect;
    
    CGRect backRect = TFbackView.frame;
    backRect.size.width = groupTagTfview_.frame.size.width + addBtn.frame.size.width + 5;
    TFbackView.frame = backRect;
    
    //是否需要换行
    UIButton *btn = [_tagViews lastObject];
    CGFloat accumX = [self posXForObjectNextToLastView];
    if (_tagViews.count == 0)
    {
        inputRect = TFbackView.frame;
        inputRect.origin.x = _tagGap;
        inputRect.origin.y = 38;
        TFbackView.frame = inputRect;
    }
    else
    {
        if (TFbackView.frame.size.width + TFbackView.frame.origin.x > self.scrollView_.frame.size.width)
        {
            CGRect backFrame;
            backFrame = TFbackView.frame;
            backFrame.origin.x = _tagGap;
            backFrame.origin.y = lineNum * (25 + _tagGap) + 38;
            TFbackView.frame = backFrame;
        }
        else if (btn.frame.size.width + btn.frame.origin.x + TFbackView.frame.size.width + _tagGap < self.scrollView_.frame.size.width)
        {
            inputRect = TFbackView.frame;
            inputRect.origin.x = accumX;
            inputRect.origin.y = previousFrame.origin.y;
            TFbackView.frame = inputRect;
        }
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
        if ([string isEqualToString:@"\n"])
        {
            if (![textField.text isEqualToString:@""]) {
                [self addTagToLast:textField.text animated:YES];
                textField.text = @"";

            }
        }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (id obj in self.scrollView_.subviews)
    {
        if ([obj isKindOfClass:[CustomButton class]])
        {
            CustomButton *button = (CustomButton *)obj;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:REDCOLOR forState:UIControlStateNormal];
            button.clickState = 1;
        }
    }
    _deleteBtn.hidden = YES;
}

//设置右按扭的属性
- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_ = dataModal;
    NSString *tags = inModel_.group_tag_names;
    
    _tagsMade = [[NSMutableArray alloc]init];
    _tagViews = [[NSMutableArray alloc] init];
    
    _tagGap = 8.0f;
    lineNum = 1;
    previousFrame = CGRectZero;
    
    if (![tags isEqualToString:@""]) {
        _tagsMade = [[tags componentsSeparatedByString:@","] mutableCopy];
    }
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (_tagsMade != nil) {
        [self updateView:_tagsMade];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon_ code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_UpdateGroups:
        {
            if ([[dataArr objectAtIndex:0] isEqualToString:@"OK"]) {
                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil seconds:0.5];
                inModel_.group_tag_names = groupTags_;
                [delegate_ updateTagsSuccess];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ASSOCIATIONDETAILFRESH" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:nil seconds:0.5];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)updateView:(NSMutableArray *)tagsArray
{
    @try
    {
        for (int i=0; i<_tagsMade.count; i++)
        {
            [self addTagViewToLast:[_tagsMade objectAtIndex:i] animated:YES];
            [self layoutGroupTfAndGourpView];
            [self.scrollView_ addSubview:_tagBtn];
        }
    }
    @catch(NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

//右导航按钮方法
- (void)rightBarBtnResponse:(id)sender
{
    if (!updateCon_) {
        updateCon_ = [self getNewRequestCon:NO];
    }
    
    groupTags_ = [[NSString alloc]init];
    
    for (int i=0; i<[_tagsMade count]; i++)
    {
        NSString *tags = [_tagsMade objectAtIndex:i];
        groupTags_ = [groupTags_ stringByAppendingString:tags];
        
        if (i != [_tagsMade count]-1 || groupTagTfview_.text.length != 0) {
            groupTags_ = [groupTags_ stringByAppendingString:@","];
        }
    }
    
    if (![groupTagTfview_.text isEqualToString:@""])
    {
        groupTags_ = [groupTags_ stringByAppendingString:groupTagTfview_.text];
    }
    
    if ([groupTags_ isEqualToString:@""]) {
        [BaseUIViewController showAutoDismissSucessView:@"" msg:@"请添加社群标签"];
        return;
    }
    
    [updateCon_ updateGroups:[Manager getUserInfo].userId_ groupId:inModel_.group_id groupName:inModel_.group_name groupIntro:inModel_.group_intro groupTag:groupTags_ openStatus:inModel_.group_open_status groupPic:nil];
}

- (void)btnResponse:(id)sender
{
    if (sender == addBtn)
    {
        NSString *text = [groupTagTfview_.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length <= 0) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"标签不能为空"];
            return;
        }
        _alertlab.hidden = YES;
        [self addTagToLast:text animated:YES];
        groupTagTfview_.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
