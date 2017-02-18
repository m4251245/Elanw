//
//  CreateGroupStep2Ctl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-27.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "CreateGroupStep2Ctl.h"

@interface CreateGroupStep2Ctl ()
{
    UIButton *_deleteBtn;
    CGRect previousFrame;
    
    NSInteger lineNum;
    BOOL isFlag;
}
@end

@implementation CreateGroupStep2Ctl
@synthesize enterType_;

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
//    self.navigationItem.title = @"创建社群";
    [self setNavTitle:@"创建社群"];
    [groupTagTfview_ setTextColor:BLACKCOLOR];
    [groupTagTfview_ setFont:FIFTEENFONT_TITLE];
    [groupTagTfview_ addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [gourpTagLb_ setFont:FIFTEENFONT_TITLE];
//    [gourpTagLb_ setTextColor:BLACKCOLOR];
    
    gourpTagView_.layer.cornerRadius = 4.0;
    gourpTagView_.layer.masksToBounds = YES;
    gourpTagView_.layer.borderWidth = 1.0;
    gourpTagView_.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0].CGColor;
    

//    [tagtipsLb_ setFont:FIFTEENFONT_TITLE];
//    [tagtipsLb_ setTextColor:BLACKCOLOR];
//    
//    [tagContentLb_ setFont:FIFTEENFONT_TITLE];
//    [tagContentLb_ setTextColor:GRAYCOLOR];
    
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

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModel_ = dataModal;
    
    _tagsMade = [[NSMutableArray alloc]init];
    _tagViews = [[NSMutableArray alloc] init];
    
    _tagGap = 5.0f;
    lineNum = 1;
    previousFrame = CGRectZero;
}

#pragma mark - AddTag
-(void)addTagToLast:(NSString *)tag animated:(BOOL)animated
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
    
    [self addTagViewToLast:tag animated:animated];
    [self layoutGroupTfAndGourpView];
}

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

#pragma mark - MoveTag
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

- (void)removeTagViewWithIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index >= _tagViews.count)
    {
        return;
    }
    
    UIView *deletedView = [_tagViews objectAtIndex:index];
    [deletedView removeFromSuperview];
    [_tagViews removeObject:deletedView];
    
    NSMutableArray *tagViewsCopy = [[NSMutableArray alloc] initWithArray:_tagViews];
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

//刷新输入框坐标
- (void)layoutGroupTfAndGourpView
{
    CGFloat accumX = [self posXForObjectNextToLastView];
    
    CGRect inputRect = groupTagTfview_.frame;
    inputRect.size.width = 60;
    groupTagTfview_.frame = inputRect;
    
    inputRect = addBtn.frame;
    inputRect.origin.x = groupTagTfview_.frame.size.width;
    addBtn.frame = inputRect;
    [gourpTagView_ layoutIfNeeded];
    CGRect backRect = gourpTagView_.frame;
    if (self.scrollView_.frame.size.width - accumX - _tagGap > 85) {
        
        backRect = gourpTagView_.frame;
        backRect.origin.x = accumX;
        backRect.origin.y = previousFrame.origin.y;
        backRect.size.width = 85;
        gourpTagView_.frame = backRect;
        
        backRect = addBtn.frame;
        backRect.origin.x = 65;
        addBtn.frame = backRect;
    }
    else
    {
        backRect = gourpTagView_.frame;
        backRect.origin.x = _tagGap;
        backRect.origin.y = lineNum * (25 + _tagGap) + 38;
        backRect.size.width = 85;
        gourpTagView_.frame = backRect;
        
        backRect = addBtn.frame;
        backRect.origin.x = 65;
        addBtn.frame = backRect;
    }

//    if (self.scrollView_.frame.size.width - accumX - _tagGap > 85)
//    {
//        backRect.origin.x = accumX;
//        if (previousFrame.origin.y == 0) {
//            backRect.origin.y = 38;
//        }
//        else
//        {
//            backRect.origin.y = previousFrame.origin.y;
//        }
//        backRect.size.width = groupTagTfview_.frame.size.width;
//    }
//    else
//    {
//        backRect.origin.x = _tagGap;
//        backRect.origin.y = lineNum * (25 + _tagGap) + 35;
//        backRect.size.width = groupTagTfview_.frame.size.width;
//        
//    }
//    gourpTagView_.frame = backRect;
}

//获取当前长度
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
    [_tagBtn setTitle:tag forState:UIControlStateNormal];
    [_tagBtn setTitleColor:REDCOLOR forState:UIControlStateNormal];
    [_tagBtn setBackgroundColor:[UIColor whiteColor]];
    _tagBtn.layer.cornerRadius = 8;
    _tagBtn.layer.borderWidth = 1;
    _tagBtn.layer.borderColor = REDCOLOR.CGColor;
    [_tagBtn addTarget:self action:@selector(tagBtnDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    _tagBtn.clickState = 1;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSParagraphStyleAttributeName: paragraph};
    
    CGSize textSize = [tag boundingRectWithSize:CGSizeMake(self.scrollView_.frame.size.width, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    textSize.width += 7.0*2;
//    textSize.height += 3.0*2;
    
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

//显示/隐藏删除按钮
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
        [self.scrollView_ bringSubviewToFront:_deleteBtn];
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

//删除标签
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
-(NSInteger) unicodeLengthOfString: (NSString *) text
{
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++)
    {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}


#pragma mark - UITextFiledDelegate
- (void)textFieldDidChange:(id)sender
{
    //tag字数限制 最多十八个
    if (groupTagTfview_.text.length > 18) {
        _alertlab.hidden = NO;
        _alertlab.text = [NSString stringWithFormat:@"标签最多支持18个字，已超过%ld字",(long)groupTagTfview_.text.length - 18];
        CGFloat width = [_alertlab.text sizeWithAttributes:@{NSFontAttributeName:NINEFONT_TIME}].width + 10;
        CGRect labFrame = _alertlab.frame;
        labFrame.origin.x = (self.scrollView_.frame.size.width - width) / 2;
        labFrame.origin.y = gourpTagView_.frame.origin.y + gourpTagView_.frame.size.height + 4;
        labFrame.size.width = width;
        labFrame.size.height = 15;
        
        _alertlab.frame = labFrame;
        
        isFlag = NO;
    }
    else
    {
        _alertlab.hidden = YES;
        isFlag = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textField.text;
    
    //textField宽度
    CGFloat newWidth = 0;
    NSString *newText = nil;
    
    if (string.length == 0)
    {
        if (textField.text.length)
        {
            newText = [textField.text substringWithRange:NSMakeRange(0, textField.text.length - range.length)];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        newText = [NSString stringWithFormat:@"%@%@",textField.text, text];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    newWidth = [str sizeWithAttributes:@{NSFontAttributeName:THIRTEENFONT_CONTENT}].width;
    
    CGRect inputRect = groupTagTfview_.frame;
    
    if (newWidth + 20 > 300)
    {
        inputRect.size.width = 306 - 20;
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
    
    CGRect backRect = gourpTagView_.frame;
    backRect.size.width = groupTagTfview_.frame.size.width + addBtn.frame.size.width + 5;;
    gourpTagView_.frame = backRect;
    
    //是否需要换行
    UIButton *btn = [_tagViews lastObject];
    CGFloat accumX = [self posXForObjectNextToLastView];
    if (_tagViews.count == 0)
    {
        inputRect = gourpTagView_.frame;
        inputRect.origin.x = _tagGap;
        inputRect.origin.y = 38;
        gourpTagView_.frame = inputRect;
    }
    else
    {
        if (gourpTagView_.frame.size.width + gourpTagView_.frame.origin.x > self.scrollView_.frame.size.width)
        {
            CGRect backFrame;
            backFrame = gourpTagView_.frame;
            backFrame.origin.x = _tagGap;
            backFrame.origin.y = lineNum * (25 + _tagGap) + 35;
            gourpTagView_.frame = backFrame;
        }
        else if (btn.frame.size.width + btn.frame.origin.x + gourpTagView_.frame.size.width + _tagGap < self.scrollView_.frame.size.width)
        {
            inputRect = gourpTagView_.frame;
            inputRect.origin.x = accumX;
            inputRect.origin.y = previousFrame.origin.y;
            gourpTagView_.frame = inputRect;
        }
    }

    //tag指数限制 最多十八个
    if (isFlag) {
        if ([string isEqualToString:@"\n"])
        {
            if ([textField.text isEqualToString:@""]) {
                return NO;
            }
            else
            {
                [self addTagToLast:textField.text animated:YES];
                textField.text = @"";
            }
            
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

- (void)btnResponse:(id)sender
{
    if (sender == addBtn)
    {
        NSString *text = groupTagTfview_.text;
        
        NSInteger len = [self unicodeLengthOfString:text];
        
        if (len > 0 && len < 18)
        {
            _alertlab.hidden = YES;
            [self addTagToLast:text animated:YES];
            groupTagTfview_.text = @"";
        }
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    if (sender == rightBarBtn_)
    {
        [groupTagTfview_ resignFirstResponder];
        
        if (_tagsMade.count == 0) {
            [BaseUIViewController showAlertView:@"请输入社群标签" msg:nil btnTitle:@"知道了"];
            return;
        }
        else if (_tagsMade.count > 6)
        {
            [BaseUIViewController showAlertView:@"最多输入六个标签" msg:nil btnTitle:@"知道了"];
            return;
        }
        else
        {
//            if (![groupTagTfview_.text isEqualToString:@""]) {
//                [self addTagToLast:groupTagTfview_.text animated:YES];
//                groupTagTfview_.text = @"";
//            }
            groupTags = [[NSString alloc]init];
            
            for (int i=0; i<[_tagsMade count]; i++)
            {
                NSString *tags = [_tagsMade objectAtIndex:i];
                groupTags = [groupTags stringByAppendingString:tags];
                
                if (i != [_tagsMade count]-1 || groupTagTfview_.text.length != 0) {
                    groupTags = [groupTags stringByAppendingString:@" "];
                }
            }

            if (groupTagTfview_ != nil)
            {
                groupTags = [groupTags stringByAppendingString:groupTagTfview_.text];
            }
            
            groupTags = [MyCommon removeSpaceAtSides:groupTags];
            if (!createCon_) {
                createCon_ = [self getNewRequestCon:NO];
            }
            
            NSInteger status = [inModel_.isPublic_ integerValue];
            //公开
//            if ([inModel_.isPublic_ isEqualToString:@"1"]) {
//                status = 1;
//            }else{
//                //私密
//                status = 3;
//            }
            
            if (inModel_.groupImg_ !=nil) {
                NSData *imgData = UIImageJPEGRepresentation(inModel_.groupImg_, 0.01);
                //以时间命名图片
                NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
                [dateformatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateformatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
                [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
                [dateformatter setDateFormat:@"yyyy-MM-dd_HHmmss"];
                NSDate * now = [NSDate date];
                NSString * timeStr = [dateformatter stringFromDate:now];
                RequestCon *uploadCon = [self getNewRequestCon:NO];
                [uploadCon uploadPhotoData:imgData name:[NSString stringWithFormat:@"%@.jpg",timeStr]];
            }else{
                [createCon_ createGroup:[Manager getUserInfo].userId_ name:inModel_.groupName_ intro:inModel_.groupIntro tags:groupTags openStatus:status photo:nil];
            }            
        }
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_CreateGroup:
        {
            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
            if ([dataModal.status_ isEqualToString:Success_Status]) {
                [BaseUIViewController showAutoDismissSucessView:@"创建成功" msg:nil];
                User_DataModal *model = [Manager getUserInfo];
                
                NSInteger groupInt = [[Manager shareMgr].groupCount_ integerValue];
                groupInt --;
                [Manager shareMgr].groupCount_ = [NSString stringWithFormat:@"%ld",(long)groupInt];
                [CommonConfig setDBValueByKey:@"groupCreaterCnt" value:[NSString stringWithFormat:@"%ld",(long)model.groupsCreateCnt_]];
                [Manager setUserInfo:model];
                step3Ctl_ = [[CreateGroupStep3Ctl alloc]init];
                step3Ctl_.enteType_ = enterType_;
                [self.navigationController pushViewController:step3Ctl_ animated:YES];
                [step3Ctl_ beginLoad:[dataArr objectAtIndex:1] exParam:nil];
            }
            else
            {
                [BaseUIViewController showAlertView:@"创建失败" msg:dataModal.des_ btnTitle:@"确定"];
            }
        }
            break;
        case Request_UploadPhotoFile:
        {
            Upload_DataModal *imgModel = [dataArr objectAtIndex:0];
            for (Upload_DataModal *model in imgModel.pathArr_) {
                //取140大小
                if ([model.size_ isEqualToString:@"140"]) {
                    groupImgUrl_ = model.path_;
                }
            }
            if (groupImgUrl_ == nil) {
                [BaseUIViewController showAutoDismissSucessView:@"修改社群头像失败" msg:@"请稍后在试" seconds:1.0];
                return;
            }
            
            NSInteger status = [inModel_.isPublic_ integerValue];
            //公开
//            if ([inModel_.isPublic_ isEqualToString:@"1"]) {
//                status = 1;
//            }else{
//                //私密
//                status = 3;
//            }
            
            if (!createCon_) {
                createCon_ = [self getNewRequestCon:NO];
            }
            [createCon_ createGroup:[Manager getUserInfo].userId_ name:inModel_.groupName_ intro:inModel_.groupIntro tags:groupTags openStatus:status photo:groupImgUrl_];
        }
            break;
        default:
            break;
    }
}


- (void)setRightBarBtnAtt
{
    [rightBarBtn_ setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn_ setFrame:CGRectMake(0, 0, 60, 44)];
    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
