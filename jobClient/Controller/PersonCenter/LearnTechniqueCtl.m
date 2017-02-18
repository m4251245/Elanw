//
//  LearnTechniqueCtl.m
//  jobClient
//
//  Created by 一览ios on 15/2/25.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "LearnTechniqueCtl.h"
#import "TagView.h"
#import "MyConfig.h"
#import "CustomTagButton.h"

//#define FIRST_LEVEL_W 80
//#define MARGIN_LEFT 10
//#define MARGIN_TOP 8
static int FIRST_LEVEL_W = 80;
static int MARGIN_LEFT = 10;
static int MARGIN_TOP = 8;

@interface LearnTechniqueCtl ()<UITableViewDelegate, UITableViewDataSource>
{
    RequestCon *_getTradeTagCon;
    RequestCon *_getTagsBySecondTagCon;
    
    __weak IBOutlet UILabel *changCountLb;
}
@end

@implementation LearnTechniqueCtl



- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn setFrame:CGRectMake(0, 0, 40, 35)];
    [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(rightBarBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,buttonItem, nil];
    
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    [self.view bringSubviewToFront:self.tagView];
    [self beginLoad:nil exParam:nil];
    
    if (_fromExpertCtl) {
        changCountLb.text = @"最多可选择1个标签";
    }
    else
    {
        changCountLb.text = @"最多可选择6个标签";
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    if (!_tradeId) {
        //默认互联网
        _tradeId = @"2381423703730498";
    }
    
}

- (void)getDataFunction:(RequestCon *)con
{
    con.storeType_ = TempStoreType;
    [con getHotTagAndChildTag:_tradeId];//行业
    
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetHotTagAndChildTag://获取行业下面的2和第一个的3级标签
        {
            for (UIView *view in _tagView.subviews) {
                [view removeFromSuperview];
            }
            //最后一级标签的view
            TagView *tagView = [[TagView alloc]init];
            __weak LearnTechniqueCtl *learnTechniqueCtl = self;
            tagView.clickBlock =^(personTagModel *tag)
            {
                if (_fromExpertCtl)
                {
                    if (learnTechniqueCtl.selectedTags.count > 0)
                    {
                         personTagModel *tagModel = learnTechniqueCtl.selectedTags[0];
                        
                        if ([tagModel.tagId_ isEqualToString:tag.tagId_])
                        {
                            return;
                        }
                        else
                        {
                            [learnTechniqueCtl.selectedTags removeAllObjects];
                        }
                    }
                }
                else
                {
                    for (personTagModel *tagModel in learnTechniqueCtl.selectedTags)
                    {
                        if ([tagModel.tagId_ isEqualToString:tag.tagId_])
                        {
                            [learnTechniqueCtl.selectedTags removeObject:tagModel];
                            [learnTechniqueCtl refreshSelectedTag];
                            [learnTechniqueCtl refreshTags];
                            return;
                        }
                    }
                    if(learnTechniqueCtl.selectedTags.count == 6)
                    {
                        [BaseUIViewController showAlertView:nil msg:@"最多可选择6个标签" btnTitle:@"知道了"];
                        return;
                    }
                }
               
                [learnTechniqueCtl.selectedTags addObject:tag];
                [learnTechniqueCtl refreshSelectedTag];
                [learnTechniqueCtl refreshTags];
            };
            if (dataArr.count ==2 ) {//
                [self getFirstLevelView];
                tagView.frame = CGRectMake(FIRST_LEVEL_W, 0, self.tagView.frame.size.width - FIRST_LEVEL_W, self.tagView.frame.size.height);
                tagView.tagArray = [NSArray arrayWithArray:dataArr[1]];
            }else if (dataArr.count ==1 ){
                tagView.frame = self.tagView.bounds;
                tagView.tagArray = [NSArray arrayWithArray:dataArr[0]];
            }
            tagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.tagView addSubview:tagView];
            tagView.backgroundColor = WhiteColor;
            [self refreshSelectedTag];
            [self refreshTags];
            [self.containerView bringSubviewToFront:self.tagView];
        }
            break;
        case Request_GetTagsBySecondTag://根据二级标签获取三级标签
        {
            UIView *view = _tagView.subviews[1];
            [view removeFromSuperview];
            //最后一级标签的view
            TagView *tagView = [[TagView alloc]init];
            __weak LearnTechniqueCtl *learnTechniqueCtl = self;
            tagView.clickBlock =^(personTagModel *tag)
            {
                if (_fromExpertCtl)
                {
                    if (learnTechniqueCtl.selectedTags.count > 0)
                    {
                        personTagModel *tagModel = learnTechniqueCtl.selectedTags[0];
                        
                        if ([tagModel.tagId_ isEqualToString:tag.tagId_])
                        {
                            return;
                        }
                        else
                        {
                            [learnTechniqueCtl.selectedTags removeAllObjects];
                        }
                    }
                }
                else
                {
                    for (personTagModel *tagModel in learnTechniqueCtl.selectedTags) {
                        if ([tagModel.tagId_ isEqualToString:tag.tagId_]) {
                            [learnTechniqueCtl.selectedTags removeObject:tagModel];
                            [learnTechniqueCtl refreshSelectedTag];
                            [learnTechniqueCtl refreshTags];
                            return;
                        }
                    }
                    if(learnTechniqueCtl.selectedTags.count == 6){
                        [BaseUIViewController showAlertView:nil msg:@"最多可选择6个标签" btnTitle:@"知道了"];
                        return;
                    }
                }
                
                [learnTechniqueCtl.selectedTags addObject:tag];
                [learnTechniqueCtl refreshSelectedTag];
                [learnTechniqueCtl refreshTags];
            };
            tagView.frame = CGRectMake(FIRST_LEVEL_W, 0, self.tagView.frame.size.width - FIRST_LEVEL_W, self.tagView.frame.size.height);
            tagView.tagArray = [NSArray arrayWithArray:dataArr];
            tagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.tagView addSubview:tagView];
            tagView.backgroundColor = WhiteColor;
            [self refreshTags];
        }
            break;
        case Request_GetSkillTradeTagsList://行业标签选择
        {
            TagView *tagView = [[TagView alloc]init];
            __weak LearnTechniqueCtl *learnTechniqueCtl = self;
            tagView.clickBlock =^(personTagModel *tag){
                if ([tag.tagId_ isEqualToString:learnTechniqueCtl.tradeId]) {
                    [learnTechniqueCtl.containerView bringSubviewToFront:learnTechniqueCtl.tagView];
                    return ;
                }
                learnTechniqueCtl.tradeId = tag.queryId_;
                [learnTechniqueCtl.tradeBtn setTitle:tag.tagName_ forState:UIControlStateNormal];
                [learnTechniqueCtl beginLoad:nil exParam:nil];
                learnTechniqueCtl.hotTagLb.textColor = [UIColor blackColor];
            };
            tagView.frame = _tradeView.bounds;
            tagView.tagArray = [NSArray arrayWithArray:dataArr];
            tagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [_tradeView addSubview:tagView];
            tagView.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
        }
            break;
        default:
            break;
    }
}

#pragma mark 刷新显示选择的标签
- (void)refreshSelectedTag
{
    NSArray *subViews = _selectedTagView.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    CGFloat lastX = 10;
    CGFloat lastY = 28;
    
    for (int i=0; i<_selectedTags.count; i++) {
        CustomTagButton *button = [[CustomTagButton alloc]init];
        personTagModel *tag = _selectedTags[i];
        [button setTitle:tag.tagName_ forState:UIControlStateNormal];
        button.titleLabel.font = FOURTEENFONT_CONTENT;
        [button setTag:(i) ];
        [button setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY];
        UIView *deleteView = [self getDeleteView:button];
        frame.size.width +=15;
        deleteView.frame = frame;
        [_selectedTagView addSubview:deleteView];
        [button addTarget:self action:@selector(selectedTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGRect frame = _selectedTagView.frame;
    frame.size.height = lastY + 30 +MARGIN_TOP;
    if (_selectedTags.count == 0) {
        frame.size.height = 0;
    }
    _selectedTagView.frame = frame;
    CGFloat maxY = CGRectGetMaxY(_selectedTagView.frame);
    frame = _containerView.frame;
    frame.origin.y = maxY;
    frame.size.height = self.view.bounds.size.height - maxY;
    _containerView.frame = frame;
}

#pragma mark 刷新标签
- (void)refreshTags
{
    TagView *tagView;
    if (requestCon_.dataArr_.count == 1) {//没有二级标签
        tagView = _tagView.subviews[0];
    }else if (requestCon_.dataArr_.count == 2){
        tagView = _tagView.subviews[1];
    }
    NSArray *tagArr = tagView.tagArray;
    for (int i=0; i<tagArr.count; i++) {
        personTagModel *tagModel = tagArr[i];
        BOOL hasSelTag = NO;
        for (personTagModel *seltagModel in _selectedTags) {
            if ([seltagModel.tagId_ isEqualToString: tagModel.tagId_]) {
                hasSelTag = YES;
                break;
            }
        }
        if (hasSelTag) {
            UIButton *button = tagView.subviews[i];
            [button setBackgroundColor:[UIColor colorWithRed:255.f/255 green:80.f/255 blue:80.f/255 alpha:1.0f]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            UIButton *button = tagView.subviews[i];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark 删除的view
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
    if (*lastX + titleSize.width + MARGIN_LEFT> _selectedTagView.frame.size.width) {
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
    NSInteger tag = sender.tag;
    [_selectedTags removeObjectAtIndex:tag];
    [self refreshSelectedTag];
    [self refreshTags];
}

- (UITableView *)getFirstLevelView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = CGRectMake(0, 0, FIRST_LEVEL_W, self.tagView.bounds.size.height);
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.tagView addSubview:tableView];
    [tableView reloadData];
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    return tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = requestCon_.dataArr_[0];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *reuseIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
 
 // Configure the cell...
     if (cell == nil) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
         UILabel *tagLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, FIRST_LEVEL_W, 50)];
         tagLb.textAlignment = NSTextAlignmentCenter;
         tagLb.font = FOURTEENFONT_CONTENT;
         tagLb.textColor = BLACKCOLOR;
         tagLb.tag = 1001;
         [cell.contentView addSubview:tagLb];
         cell.backgroundColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
         cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
         cell.selectedBackgroundView.backgroundColor=[UIColor whiteColor];
     }
     personTagModel *tagModel = requestCon_.dataArr_[0][indexPath.row];
     UILabel *tagLb = (UILabel *)[cell.contentView viewWithTag:1001];
     tagLb.text = tagModel.tagName_;
     return cell;
 }

#pragma mark 选择左侧热门标签
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    personTagModel *tagModel = requestCon_.dataArr_[0][indexPath.row];
    NSString *tagId = tagModel.queryId_;
    if (!_getTagsBySecondTagCon) {
        _getTagsBySecondTagCon = [self getNewRequestCon:NO];
    }
    [_getTagsBySecondTagCon getTagsBySecondTag:tagId];
}


- (void)rightBarBtnResponse:(id)sender
{
    if (!_selectedTags.count) {
        [BaseUIViewController showAlertView:nil msg:@"请选择标签" btnTitle:@"知道了"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(updateTechniqueTags:)]) {
        [self.delegate updateTechniqueTags:_selectedTags];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnResponse:(id)sender
{
    if (sender == _tradeBtn) {//行业选择
        _hotTagLb.textColor = [UIColor colorWithRed:240.f/255 green:240.f/255 blue:240.f/255 alpha:1.0];
        [_containerView bringSubviewToFront:_tradeView];
        if (!_getTradeTagCon) {
            _getTradeTagCon = [self getNewRequestCon:NO];
        }
        if (_tradeView.subviews.count) {
            return;
        }
        [_getTradeTagCon getSkillTradeTagsList];
    }
}
@end
