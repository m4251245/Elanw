//
//  ELBeGoodAtTradeChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/10/29.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELBeGoodAtTradeChangeCtl.h"
#import "CustomTagButton.h"
#import "TagView.h"
#import "PreCommonConfig.h"
#import "CondictionList_DataModal.h"
#import "ELLableCustomView.h"

//#define FIRST_LEVEL_W 80
//#define MARGIN_LEFT 10
//#define MARGIN_TOP 8
static double MARGIN_LEFT = 10;
static double MARGIN_TOP = 8;

@interface ELBeGoodAtTradeChangeCtl () <UITextFieldDelegate>
{
    RequestCon *_getTradeTagCon;
    RequestCon *_getTagsBySecondTagCon;
    
    __weak IBOutlet UILabel *changCountLb;
    
    TagView *firstTagView;
    TagView *secondTagView;
    
    NSArray *arrListData;
    
    __weak IBOutlet UILabel *tradeLb;
    
    __weak IBOutlet UIView *titleView;
    
    ELLableCustomView *addTagView;
 
IBOutlet UIButton *rightSaveBtn;
    
}

@end

@implementation ELBeGoodAtTradeChangeCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleView.clipsToBounds = YES;
    titleView.layer.cornerRadius = 3.0;
    titleView.layer.borderWidth = 0.5;
    titleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    addTagView = [[ELLableCustomView alloc]init];
    addTagView.addTextField.delegate = self;
    [addTagView.addTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [addTagView.cancelBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    [addTagView.confirmationBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];

    rightSaveBtn.clipsToBounds = YES;
    rightSaveBtn.layer.cornerRadius = 3.0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightSaveBtn];
    
//    self.navigationItem.title = @"选择擅长领域";
    [self setNavTitle:@"选择擅长领域"];
    
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    //[self beginLoad:nil exParam:nil];
    
    changCountLb.text = @"已选领域：";
    
    @try {
        id archieveData = [MyCommon unArchiverFromFile:TradeDataFile_Name];
        arrListData = archieveData;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    [self creatTradeChangeView];
    [self refreshSelectedTag];
    if (_tradeModel.tagId_.length > 0 && ![_tradeModel.tagName_ isEqualToString:@"其他"])
    {
        firstTagView.hidden = YES;
        tradeLb.text = _tradeModel.tagName_;
        CGSize size = [_tradeModel.tagName_ sizeNewWithFont:[UIFont systemFontOfSize:14]];
        self.tradeBtn.frame = CGRectMake(ScreenWidth-45-size.width,0,size.width+20,35);
        [self creatTradeSecondChangeViewWithModel:_tradeModel];
    }
    else
    {
        firstTagView.hidden = YES;
        personTagModel *tag = firstTagView.tagArray[0];
        tradeLb.text = tag.tagName_;
        CGSize size = [tag.tagName_ sizeNewWithFont:[UIFont systemFontOfSize:14]];
        self.tradeBtn.frame = CGRectMake(ScreenWidth-45-size.width,0,size.width+20,35);
        [self creatTradeSecondChangeViewWithModel:tag];
    }
}

-(void)creatTradeChangeView
{
    firstTagView = [[TagView alloc]init];
    
    __weak ELBeGoodAtTradeChangeCtl *learnTechniqueCtl = self;
    __weak TagView *tagView = firstTagView;
    __weak UILabel *lable = tradeLb;
    firstTagView.clickBlock =^(personTagModel *tag)
    {
        tagView.hidden = YES;
        lable.text = tag.tagName_;
        CGSize size = [tag.tagName_ sizeNewWithFont:[UIFont systemFontOfSize:14]];
        learnTechniqueCtl.tradeBtn.frame = CGRectMake(275-size.width,0,size.width+20,35);
        [learnTechniqueCtl creatTradeSecondChangeViewWithModel:tag];
    };
    firstTagView.frame = _tradeView.bounds;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (CondictionList_DataModal *dataModal in arrListData)
    {
        if( dataModal.bParent_ )
        {
            personTagModel *model = [[personTagModel alloc] init];
            model.tagName_ = dataModal.str_;
            model.tagId_ = dataModal.id_;
            [arr addObject:model];
        }
    }
    
    firstTagView.tagArray = [NSArray arrayWithArray:arr];
    
    for (id button in firstTagView.subviews)
    {
        if ([button isKindOfClass:[CustomTagButton class]])
        {
            [button setBackgroundColor:[UIColor clearColor]];
        }
    }
    firstTagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_tradeView addSubview:firstTagView];
    firstTagView.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
}

- (void)TextFieldDidChange:(UITextField *)textfield
{
    if (textfield == addTagView.addTextField) {
        [MyCommon limitTextFieldTextNumberWithTextField:addTagView.addTextField wordsNum:10 numLb:nil];
    }
}

-(void)creatTradeSecondChangeViewWithModel:(personTagModel *)dataOne
{
    [secondTagView removeFromSuperview];
    secondTagView = [[TagView alloc]init];
    CGRect frame = _tradeView.frame;
    frame.size.width = ScreenWidth;
    _tradeView.frame = frame;
    
    secondTagView.frame = _tradeView.bounds;
    
    secondTagView.hidden = NO;
    __weak TagView *tagView = secondTagView;
    __weak ELBeGoodAtTradeChangeCtl *learnTechniqueCtl = self;
    secondTagView.clickBlock =^(personTagModel *tag)
    {
        if (learnTechniqueCtl.fromExpertCtl)
        {
            if (learnTechniqueCtl.selectedTags.count >= 1)
            {
                [BaseUIViewController showAlertView:nil msg:@"最多可选择1个标签" btnTitle:@"知道了"];
                return;
            }
        }
        else
        {
            if (learnTechniqueCtl.selectedTags.count >= 6)
            {
                [BaseUIViewController showAlertView:nil msg:@"最多可选择6个标签" btnTitle:@"知道了"];
                return;
            }
        }
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        for (personTagModel *modal in learnTechniqueCtl.selectedTags)
        {
            [arrData addObject:modal.tagName_];
        }
        if ([arrData containsObject:tag.tagName_]) {
            return;
        }
        CustomTagButton *button = (CustomTagButton *)[tagView viewWithTag:tag.buttonIndex];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:PINGLUNHONG];
        [learnTechniqueCtl.selectedTags addObject:tag];
        [learnTechniqueCtl refreshSelectedTag];
    };
    
   
    
    NSMutableArray *subArr = [[NSMutableArray alloc] init];
    for ( CondictionList_DataModal *dataModal in arrListData )
    {
        if( [dataModal.pId_ isEqualToString:dataOne.tagId_] && !dataModal.bParent_ )
        {
            personTagModel *model = [[personTagModel alloc] init];
            model.tagName_ = dataModal.str_;
            model.tagId_ = dataModal.id_;
            [subArr addObject:model];
        }
    }
    secondTagView.tagArray = [NSArray arrayWithArray:subArr];
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    for (personTagModel *modal in self.selectedTags)
    {
        [arrData addObject:modal.tagName_];
    }
    
    for (id button in secondTagView.subviews)
    {
        if ([button isKindOfClass:[CustomTagButton class]])
        {
            CustomTagButton *btn = (CustomTagButton *)button;
            if ([arrData containsObject:btn.titleLabel.text])
            {
                [button setBackgroundColor:PINGLUNHONG];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
    secondTagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_tradeView addSubview:secondTagView];
    secondTagView.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
}

#pragma mark 刷新显示选择的标签
- (void)refreshSelectedTag
{
    NSArray *subViews = _selectedTagView.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    CGFloat lastX = 10;
    CGFloat lastY = 10;
    
    for (int i=0; i<=_selectedTags.count; i++)
    {
        if(i == _selectedTags.count)
        {
            CustomTagButton *button = [[CustomTagButton alloc]init];
            [button setTitle:@"+  自定义" forState:UIControlStateNormal];
            button.titleLabel.font = FOURTEENFONT_CONTENT;
            [button setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            CGRect frame = [self setButtonTitle:@"+  自定义" button:button lastX:&lastX lastY:&lastY];
            button.frame = frame;
            [button addTarget:self action:@selector(addTagBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_selectedTagView addSubview:button];
        }
        else
        {
            CustomTagButton *button = [[CustomTagButton alloc]init];
            personTagModel *tag = _selectedTags[i];
            [button setTitle:tag.tagName_ forState:UIControlStateNormal];
            button.titleLabel.font = FOURTEENFONT_CONTENT;
            [button setTag:200+i];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:PINGLUNHONG];
            CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY];
            UIView *deleteView = [self getDeleteView:button];
            frame.size.width +=15;
            deleteView.frame = frame;
            [_selectedTagView addSubview:deleteView];
            [button addTarget:self action:@selector(selectedTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    CGRect frame = _selectedTagView.frame;
    frame.size.height = lastY + 30 +MARGIN_TOP;
    frame.origin.x = 70;
    frame.origin.y = 0;
    frame.size.width = ScreenWidth-70;
    if (_selectedTags.count == 0) {
        frame.size.height = 48;
    }
    _selectedTagView.frame = frame;
    CGFloat maxY = CGRectGetMaxY(_selectedTagView.frame);
    frame = _containerView.frame;
    frame.origin.y = maxY;
    frame.size.height = self.view.bounds.size.height - maxY;
    _containerView.frame = frame;
}

-(void)addTagBtn:(UIButton *)sender
{
    if (self.fromExpertCtl)
    {
        if (self.selectedTags.count >= 1)
        {
            [BaseUIViewController showAlertView:nil msg:@"最多可选择1个标签" btnTitle:@"知道了"];
            return;
        }
    }
    else
    {
        if (self.selectedTags.count >= 6)
        {
            [BaseUIViewController showAlertView:nil msg:@"最多可选择6个标签" btnTitle:@"知道了"];
            return;
        }
    }
    addTagView.addTextField.text = @"";
    addTagView.frame = [UIScreen mainScreen].bounds;
    [[[UIApplication sharedApplication] keyWindow] addSubview:addTagView];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:addTagView];
}

- (UIView *)getDeleteView:(UIButton *)btn
{
    UIView *view = [[UIView alloc]initWithFrame:btn.bounds];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:btn];
    UIButton *delView = [UIButton buttonWithType:UIButtonTypeCustom];
    [delView setImage:[UIImage imageNamed:@"icon_delete_red.png"] forState:UIControlStateNormal];
    delView.bounds = CGRectMake(0, 0, 30, 30);
    delView.center = CGPointMake(btn.bounds.size.width*0.95, btn.bounds.size.height*0.25);
    delView.tag = btn.tag;
    [delView addTarget:self action:@selector(selectedTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:delView];
    return view;
}
#pragma mark 计算根据文字计算宽度 返回frame
-(CGRect) setButtonTitle:(NSString *)title button:(UIButton*) button lastX:(CGFloat *)lastX lastY:(CGFloat *)lastY{
    CGSize titleSize = [title sizeNewWithFont:button.titleLabel.font];
    titleSize.height = 30;
    button.layer.cornerRadius = 15;
    titleSize.width += 32;
    if (*lastX + titleSize.width + MARGIN_LEFT> ScreenWidth-70) {
        *lastX = MARGIN_LEFT;
        *lastY += titleSize.height + MARGIN_TOP;
    }
    CGRect frame = CGRectMake(*lastX, *lastY, titleSize.width, titleSize.height);
    [button setFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    *lastX += titleSize.width + MARGIN_LEFT;
    return frame;
}
#pragma mark 删除选择的标签
- (void)selectedTagBtnClick:(UIButton *)sender
{
    NSInteger tag = sender.tag-200;
    personTagModel *model = _selectedTags[tag];
    [_selectedTags removeObjectAtIndex:tag];
    [self refreshSelectedTag];
  
    for (id button in secondTagView.subviews)
    {
        if ([button isKindOfClass:[CustomTagButton class]])
        {
            CustomTagButton *btn = (CustomTagButton *)button;
            if ([btn.titleLabel.text isEqualToString:model.tagName_])
            {
                [button setBackgroundColor:[UIColor clearColor]];
                [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
            }
        }
    }
   
    //[self refreshTags];
}

-(void)btnResponse:(id)sender
{
    if (sender == _tradeBtn)
    {
        firstTagView.hidden = NO;
        [secondTagView removeFromSuperview];
    }
    else if(sender == addTagView.cancelBtn)
    {
        [addTagView removeFromSuperview];
        [addTagView.addTextField resignFirstResponder];
    }
    else if (sender == addTagView.confirmationBtn)
    {
        if (addTagView.addTextField.text.length > 0)
        {
            personTagModel *model = [[personTagModel alloc] init];
            model.tagName_ = addTagView.addTextField.text;
            model.tagId_ = @"001";
            [_selectedTags addObject:model];
            [self refreshSelectedTag];
            [addTagView removeFromSuperview];
            [addTagView.addTextField resignFirstResponder];
        }
    }
    else if (sender == rightSaveBtn)
    {
        if ([self.delegate respondsToSelector:@selector(updateTechniqueTags:)]) {
            [self.delegate updateTechniqueTags:_selectedTags];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.text.length >= 10 && string.length != 0)
//    {
//        textField.text = [textField.text substringWithRange:NSMakeRange(0,10)];
//    }
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
