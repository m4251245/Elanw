//
//  TagsOfAskDefaultCtl.m
//  jobClient
//
//  Created by YL1001 on 15/7/16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "TagsOfAskDefaultCtl.h"
#import "MyJobGuideCtl.h"
#import "AnswerDetailCtl.h"

static const CGFloat tagGap = 8.0f;/**< 标签间距 */

@interface TagsOfAskDefaultCtl ()<UIAlertViewDelegate>
{
    RequestCon *askDefaultCon_;
    RequestCon *getTradeTagCon;
    
    CGRect  previousFrame1;
    CGRect  previousFrame2;
    CGRect  previousFrame3;
    NSInteger customTagNum;
    
    IBOutlet UIView *subTagBtnBgView;
    BOOL ShowSubTagView;
    
    NSMutableArray *tradeIdArr;   /**<行业标签*/
    NSMutableArray *customTagArr; /**<自定义标签*/
    NSInteger tradeIdNum;
    
    Answer_DataModal *answerModal;
}
@end

@implementation TagsOfAskDefaultCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        rightNavBarStr_ = @"提交";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"为问题添加标签";
    [self setNavTitle:@"为问题添加标签"];
    
    [_groupTagTfView setTextColor:[UIColor blackColor]];
    [_groupTagTfView setFont:TWEELVEFONT_COMMENT];
    _groupTagTfView.layer.cornerRadius = 2;
    [_groupTagTfView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    TFbackView.layer.cornerRadius = 12;
    TFbackView.layer.borderWidth = 1;
    TFbackView.layer.borderColor = [UIColor grayColor].CGColor;
    TFbackView.layer.masksToBounds = YES;
    TFbackView.hidden = YES;
    
    subTagBtnBgView.layer.cornerRadius = 8;
    subTagBtnBgView.layer.borderWidth = 1;
    subTagBtnBgView.layer.borderColor = REDCOLOR.CGColor;
    subTagBtnBgView.hidden = YES;
    
    ShowSubTagView = YES;
    customTagArr = [[NSMutableArray alloc] init];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    answerModal = [[Answer_DataModal alloc] init];
    answerModal = dataModal;
    
    _tagsMade = [[NSMutableArray alloc]init];
    _tagViews = [[NSMutableArray alloc] init];
    _subTagsMade = [[NSMutableArray alloc] init];
    _subTagViews = [[NSMutableArray alloc] init];
    lineNum = 1;
    lineNum2 = 1;
    
    if (!askDefaultCon_) {
        askDefaultCon_ = [self getNewRequestCon:NO];
    }
    [askDefaultCon_ getAskQuestTags];
    
    if (!getTradeTagCon) {
        getTradeTagCon = [self getNewRequestCon:NO];
    }
    [getTradeTagCon getTradeTagsList];
    
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_AskQuestTags:
        {
            NSArray *tagArray = [dataArr objectAtIndex:0];
            previousFrame1 = CGRectZero;
            [self updateView:tagArray];
        }
            break;
        case Request_GetTradeTagsList:
        {
            [self createSubTagBtn:dataArr];
        }
            break;
        case Request_AskQuest:
        {
            Status_DataModal *datamodel = [dataArr objectAtIndex:0];
            if ([datamodel.code_ isEqualToString:@"200"])
            {
                NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                NSDictionary *dict = @{@"Source" : typeStr};
                [MobClick event:@"askedCount" attributes:dict];
                
//                if(_fromTodayList)
//                {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
//                else
//                {
                    /*
                    NSArray *array = [self.navigationController viewControllers];
                    for (UIViewController *ctl in array) {
                        if ([ctl isKindOfClass:[JobGuideCtl2 class]]) {
                            JobGuideCtl2 *viewController = (JobGuideCtl2 *)ctl;
                            [viewController changeModel:AQright];
                            [self.navigationController popToViewController:viewController animated:YES];
                        }
                    }
                     */
                    AnswerDetailCtl *detailCtl = [[AnswerDetailCtl alloc] init];
                    detailCtl.isAsk = YES;
                    [self.navigationController pushViewController:detailCtl animated:YES];
                    [detailCtl beginLoad:datamodel.des_ exParam:nil];
//                }
                
            }
            else if ([datamodel.code_ isEqualToString:@"400"]){
                [BaseUIViewController showAutoDismissFailView:@"已存在相同的问题" msg:nil];
            }
            else if ([datamodel.code_ isEqualToString:@"401"]){
                [BaseUIViewController showAutoDismissFailView:@"请验证手机或者邮箱" msg:nil];
            }
            else{
                [BaseUIViewController showAutoDismissFailView:datamodel.status_ msg:nil];
            }
        }
            break;
        default:
            break;
    }
}

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        switch (buttonIndex) {
            case 0:
            {
                if(_fromTodayList)
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    NSArray *array = [self.navigationController viewControllers];
                    for (UIViewController *ctl in array) {
                        if ([ctl isKindOfClass:[JobGuideCtl2 class]]) {
                            JobGuideCtl2 *viewController = (JobGuideCtl2 *)ctl;
                            [viewController changeModel:AQright];
                            [self.navigationController popToViewController:viewController animated:YES];
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
    }
}
*/
 
//创建一级标签
- (void)updateView:(NSArray *)tagArray
{
    for (NSInteger i = 0; i < tagArray.count; i++)
    {
        NSDictionary *dic = [tagArray objectAtIndex:i];
        NSString *tagName = dic[@"ylt_name"];
        
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagBtn setTitle:tagName forState:UIControlStateNormal];
        [tagBtn.titleLabel setFont:THIRTEENFONT_CONTENT];
        [tagBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        tagBtn.layer.cornerRadius = 10;
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        [tagBtn setBackgroundColor:[UIColor whiteColor]];
        [tagBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tagBtn.tag = 100 + i;
        
        tagBtn.frame = CGRectMake(8, 25, 0, 25);
        CGFloat btnWidth = (self.scrollView_.frame.size.width - 40)/4;
        
        CGRect newRect = CGRectZero;
        newRect.size.width = btnWidth;
        newRect.size.height = 25;
        
        if (i == 0)
        {
            tagBtn.frame = CGRectMake(8, _commonTags.frame.origin.y + _commonTags.frame.size.height + tagGap, btnWidth, 25);
        }
        else
        {
            if (previousFrame1.origin.x + previousFrame1.size.width + btnWidth + tagGap > self.scrollView_.frame.size.width)
            {
                newRect.origin = CGPointMake(8, previousFrame1.origin.y + 25 + tagGap);
                lineNum += 1;
            }
            else
            {
                newRect.origin = CGPointMake(previousFrame1.origin.x + previousFrame1.size.width + tagGap, previousFrame1.origin.y);
            }
            tagBtn.frame = newRect;
        }
        
        previousFrame1 = tagBtn.frame;
        previousFrame2 = tagBtn.frame;
        
        [_tagsMade addObject:tagBtn];
        [self.scrollView_ addSubview:tagBtn];
    }
}

- (void)tagBtnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 109:
        {//其他类型
            if (_tagViews.count == 2) {
                [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签已达到上限" seconds:0.6];
            }
            else
            {
                TFbackView.hidden = NO;
                [_groupTagTfView becomeFirstResponder];
                
                UIButton *btn = [_tagsMade lastObject];
                CGRect frame = TFbackView.frame;
                frame.origin.y = CGRectGetMinY(btn.frame);
                frame.origin.x = CGRectGetMinX(btn.frame);
                TFbackView.frame = frame;
                
                sender.hidden = YES;
            }
        }
            break;
        case 108:
        {
            if (ShowSubTagView) {
                if (_tagViews.count == 2) {
                    [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签已达到上限" seconds:0.6];
                    return;
                }
                
                subTagBtnBgView.hidden = NO;
                ShowSubTagView = NO;
                [sender setBackgroundColor:REDCOLOR];
                [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                sender.layer.borderColor = REDCOLOR.CGColor;
                [_tagViews addObject:sender.titleLabel.text];
            }
            else
            {
                subTagBtnBgView.hidden = YES;
                ShowSubTagView = YES;
                [sender setBackgroundColor:[UIColor whiteColor]];
                [sender setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                sender.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
                [_tagViews removeObject:sender.titleLabel.text];

            }
        }
            break;
        default:
        {
            for (NSString *tagText in _tagViews) {
                if ([tagText isEqualToString:sender.titleLabel.text]) {
                    [_tagViews removeObject:tagText];
                    [self refreshTags:_tagsMade tagsView:_tagViews];
                    return;
                }
            }
            
            if (_tagViews.count == 2) {
                [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签已达到上限" seconds:0.6];
                return;
            }
            
            [_tagViews addObject:sender.titleLabel.text];
            [self refreshTags:_tagsMade tagsView:_tagViews];
        }
            break;
    }
}

- (void)refreshTags:(NSMutableArray *)tagsMade tagsView:(NSMutableArray *)tagsView
{
    for (NSInteger i = 0; i < tagsMade.count; i++) {
        
        UIButton *tagBtn = [tagsMade objectAtIndex:i];
        BOOL hasSelTag = NO;
        for (NSString *tagText in tagsView) {
            if (tagBtn.titleLabel.text == tagText) {
                hasSelTag = YES;
                break;
            }
        }
        
        if (hasSelTag) {
            UIButton *button = [tagsMade objectAtIndex:i];
            [button setBackgroundColor:REDCOLOR];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = REDCOLOR.CGColor;
        }else{
            UIButton *button = [tagsMade objectAtIndex:i];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            button.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        }
        
    }
}

//刷新TextField的坐标
- (void)layoutGroupTfAndGourpView
{
    CGFloat accumX = CGRectGetMaxX(previousFrame2);
    CGRect inputRect = _groupTagTfView.frame;
    inputRect.size.width = 60;
    _groupTagTfView.frame = inputRect;
    
    CGRect backRect = CGRectZero;
    
    if (self.view.frame.size.width - accumX - tagGap > 85) {
        
        backRect = TFbackView.frame;
        backRect.origin.x = accumX + tagGap;
        backRect.origin.y = previousFrame2.origin.y;
        backRect.size.width = 85;
        TFbackView.frame = backRect;
        
        backRect = addBtn.frame;
        backRect.origin.x = 65;
        addBtn.frame = backRect;
    }
    else
    {
        backRect = TFbackView.frame;
        backRect.origin.x = 8;
        backRect.origin.y = lineNum * (25 + tagGap) + 46;
        backRect.size.width = 85;
        TFbackView.frame = backRect;
        
        backRect = addBtn.frame;
        backRect.origin.x = 65;
        addBtn.frame = backRect;
    }
}

#pragma mark - UITextFileDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self setTFbackViewFrameWithTextFieldChange:textField.text];
    //是否需要换行
    CGRect inputRect;
    UIButton *btn = [_tagsMade lastObject];
    
    if (_tagViews.count < 2) {
        if (customTagNum == 0)
        {
            if (TFbackView.frame.size.width + TFbackView.frame.origin.x > self.scrollView_.frame.size.width)
            {
                CGRect backFrame;
                backFrame = TFbackView.frame;
                backFrame.origin.x = 8;
                backFrame.origin.y = lineNum * (25 + tagGap) + 46;
                TFbackView.frame = backFrame;
            }
            else if (btn.frame.size.width + btn.frame.origin.x + TFbackView.frame.size.width + tagGap < self.scrollView_.frame.size.width)
            {
                inputRect = TFbackView.frame;
                inputRect.origin.x = CGRectGetMinX(previousFrame1);
                inputRect.origin.y = CGRectGetMinY(previousFrame1);
                TFbackView.frame = inputRect;
            }
        }
        else
        {
            if (TFbackView.frame.size.width + TFbackView.frame.origin.x > self.scrollView_.frame.size.width)
            {
                CGRect backFrame;
                backFrame = TFbackView.frame;
                backFrame.origin.x = 8;
                backFrame.origin.y = lineNum * (25 + tagGap) + 46;
                TFbackView.frame = backFrame;
            }
            else if (btn.frame.size.width + btn.frame.origin.x + TFbackView.frame.size.width + tagGap < self.scrollView_.frame.size.width)
            {
                inputRect = TFbackView.frame;
                inputRect.origin.x = CGRectGetMaxX(previousFrame2) + tagGap;
                inputRect.origin.y = previousFrame2.origin.y;
                TFbackView.frame = inputRect;
            }
        }
    }
    
    if ([string isEqualToString:@"\n"])
    {
        if (_tagViews.count == 2) {
            [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签已达到上限" seconds:0.6];
            _groupTagTfView.text = @"";
            [_groupTagTfView resignFirstResponder];
            return NO;
        }
        
        if ([textField.text isEqualToString:@""]) {
            [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签不能为空" seconds:0.6];
            return NO;
        }
        [self createTagBtn:textField.text];
    }

    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {//如果输入的时中文
        UITextRange *selectedRange = [_groupTagTfView markedTextRange];
        UITextPosition *position = [_groupTagTfView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (_groupTagTfView.text.length > 6) {
                _groupTagTfView.text = [_groupTagTfView.text substringToIndex:6];
            }
        }
    }else{
        if (_groupTagTfView.text.length > 6) {
            _groupTagTfView.text = [_groupTagTfView.text substringToIndex:6];
        }
    }
    
    [self setTFbackViewFrameWithTextFieldChange:_groupTagTfView.text];
}


- (void)setTFbackViewFrameWithTextFieldChange:(NSString *)str{
    
    CGFloat newWidth = 0;
    newWidth = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width;
    
    CGRect inputRect = _groupTagTfView.frame;
    
    if (newWidth + 25 > 300)
    {
        inputRect.size.width = 306 - 25;
    }
    else
    {
        if (newWidth <= 60 )
        {
            inputRect.size.width = 60;
        }
        else
        {
            inputRect.size.width = newWidth;
        }
    }
    
    _groupTagTfView.frame = inputRect;
    
    inputRect = addBtn.frame;
    inputRect.origin.x = _groupTagTfView.frame.size.width + 5;
    addBtn.frame = inputRect;
    
    CGRect backRect = TFbackView.frame;
    backRect.size.width = _groupTagTfView.frame.size.width + addBtn.frame.size.width + 5;
    TFbackView.frame = backRect;
    
}

- (void)btnResponse:(id)sender {
    
    if (_tagViews.count == 2) {
        [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签已达到上限" seconds:0.6];
        _groupTagTfView.text = @"";
        [_groupTagTfView resignFirstResponder];
        return;
    }
    
    if ([_groupTagTfView.text isEqualToString:@""]) {
        [BaseUIViewController showAutoDisappearAlertView:@"" msg:@"标签不能为空" seconds:0.6];
        return;
    }
    [self createTagBtn:_groupTagTfView.text];
    
}

- (void)createTagBtn:(NSString *)tagName
{//创建自定义标签
    [_groupTagTfView resignFirstResponder];
    _groupTagTfView.text = @"";
    
    UIButton *btn = [[UIButton alloc] init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 8;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tagBtnDidPushed:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:tagName forState:UIControlStateNormal];
    [self.scrollView_ addSubview:btn];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSParagraphStyleAttributeName: paragraph};
    
    CGSize textSize = [tagName boundingRectWithSize:CGSizeMake(self.scrollView_.frame.size.width, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    textSize.width += 7.0 * 2;
    
    CGRect frame = btn.frame;
    frame.origin.x = CGRectGetMinX(TFbackView.frame);
    frame.origin.y = CGRectGetMinY(TFbackView.frame);
    frame.size = textSize;
    frame.size.height = 25;
    btn.frame = frame;
    
    previousFrame2 = btn.frame;
    [_tagViews addObject:btn.titleLabel.text];
    [customTagArr addObject:btn];
    
    customTagNum += 1;
    
    [self layoutGroupTfAndGourpView];
}

- (void)tagBtnDidPushed:(UIButton *)sender
{
    [sender removeFromSuperview];
    [_tagViews removeObject:sender.titleLabel.text];
    customTagNum -= 1;
    
    CGRect frame = CGRectZero;
    if (customTagNum > 0) {
        
        UIButton *lastBtn = [customTagArr lastObject];
        if (lastBtn.frame.origin.x > sender.frame.origin.x) {
            
            frame = lastBtn.frame;
            frame.origin.x = CGRectGetMinX(sender.frame);
            frame.origin.y = CGRectGetMinY(sender.frame);
            lastBtn.frame = frame;
            
            frame = TFbackView.frame;
            frame.origin.x = CGRectGetMaxX(lastBtn.frame) + tagGap;
            frame.origin.y = CGRectGetMinY(lastBtn.frame);
            TFbackView.frame = frame;
        }
        else
        {
            frame = TFbackView.frame;
            frame.origin.x = CGRectGetMinX(sender.frame);
            frame.origin.y = CGRectGetMinY(sender.frame);
            TFbackView.frame = frame;
        }
        
    }
    else
    {
        frame.origin.x = CGRectGetMinX(sender.frame);
        frame.origin.y = CGRectGetMinY(sender.frame);
        TFbackView.frame = frame;
    }
    
    if (customTagNum == 0) {
        TFbackView.hidden = YES;
        for (UIButton *btn in _tagsMade) {
            if ([btn.titleLabel.text isEqualToString:@"其他类型"]) {
                btn.hidden = NO;
            }
        }
    }
}

//创建二级标签
- (void)createSubTagBtn:(NSArray *)subTagBtnArr
{
    tradeIdArr = [[NSMutableArray alloc] init];
    tradeIdNum = 0;
    for (NSInteger i = 0; i < subTagBtnArr.count; i++)
    {
        personTagModel *model = [subTagBtnArr objectAtIndex:i];
        [tradeIdArr addObject:model.tagId_];
        
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagBtn setTitle:model.tagName_ forState:UIControlStateNormal];
        [tagBtn.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:12]];
        [tagBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        tagBtn.layer.cornerRadius = 10;
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        [tagBtn setBackgroundColor:[UIColor whiteColor]];
        [tagBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [tagBtn addTarget:self action:@selector(subTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tagBtn.tag = 1000 + i;
        
        tagBtn.frame = CGRectMake(5, 25, 46, 25);
        CGFloat btnWidth = (subTagBtnBgView.frame.size.width - 30)/4;
        
        CGRect newRect = CGRectZero;
        newRect.size.width = btnWidth;
        newRect.size.height = 25;
        
        if (i == 0)
        {
            tagBtn.frame = CGRectMake(5, 46, btnWidth, 25);
            [tagBtn setBackgroundColor:REDCOLOR];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tagBtn.layer.borderColor = REDCOLOR.CGColor;
        }
        else
        {
            if (previousFrame3.origin.x + previousFrame3.size.width + btnWidth + 5 > self.scrollView_.frame.size.width)
            {
                newRect.origin = CGPointMake(5, previousFrame3.origin.y + 25 + 5);
                lineNum2 += 1;
            }
            else
            {
                newRect.origin = CGPointMake(previousFrame3.origin.x + previousFrame3.size.width + 5, previousFrame3.origin.y);
            }
            tagBtn.frame = newRect;
        }
        
        previousFrame3 = tagBtn.frame;
        
        newRect = subTagBtnBgView.frame;
        newRect.size.height = CGRectGetMaxY(previousFrame3) + 16;
        subTagBtnBgView.frame = newRect;
        
        [_subTagsMade addObject:tagBtn];
        [subTagBtnBgView addSubview:tagBtn];
    }
    
}

- (void)subTagBtnClick:(UIButton *)sender
{//选择二级子标签
    [_subTagViews removeAllObjects];
    tradeIdNum = sender.tag - 1000;
    
    [_subTagViews addObject:sender.titleLabel.text];
    [self refreshTags:_subTagsMade tagsView:_subTagViews];
}

//提交标签
- (void)rightBarBtnResponse:(id)sender
{
    if (sender == rightBarBtn_)
    {
        [_groupTagTfView resignFirstResponder];
        
        if (_tagViews.count == 0)
        {
            [BaseUIViewController showAlertView:@"请添加提问标签" msg:nil btnTitle:@"知道了"];
            return;
        }
        else
        {
            groupTags_ = [[NSString alloc] init];
            for (int i=0; i<[_tagViews count]; i++)
            {
                
                NSString *tags = [_tagViews objectAtIndex:i];
                groupTags_ = [groupTags_ stringByAppendingString:tags];
                
                if (i != [_tagViews count]-1 || _groupTagTfView.text.length != 0) {
                    groupTags_ = [groupTags_ stringByAppendingString:@","];
                }
            }
            
            if (_tagViews.count < 2 && _groupTagTfView.text.length != 0) {
                groupTags_ = [groupTags_ stringByAppendingString:_groupTagTfView.text];
            }
            
            NSString *tradeId;
            if (_subTagViews.count == 1) {
                tradeId = [tradeIdArr objectAtIndex:tradeIdNum];
            }
            else
            {
                tradeId = @"";
            }
            
            if (askDefaultCon_ == nil)
            {
                askDefaultCon_ = [self getNewRequestCon:NO];
            }
            
            if ([answerModal.expertId_ isEqualToString:@""] || answerModal.expertId_ == nil) {
                [askDefaultCon_ askQuest:[Manager getUserInfo].userId_ expertId:@"" question:answerModal.questionContent_ type:@"1" questionTag:groupTags_ tradeId:tradeId];  
            }
            else
            {
                [askDefaultCon_ askQuest:[Manager getUserInfo].userId_ expertId:answerModal.expertId_ question:answerModal.questionContent_ type:@"1" questionTag:groupTags_ tradeId:tradeId];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
