//
//  ELJobGuideLableChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/9/9.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELJobGuideLableChangeCtl.h"
#import "TagView.h"
#import "CustomTagButton.h"
#import "ELLableCustomView.h"
#import "ELRequest.h"
#import "ELJobGuideTradeChangeCtl.h"
#import "AnswerDetialModal.h"

static double MARGIN_LEFT = 10;
static double MARGIN_TOP = 8;

@interface ELJobGuideLableChangeCtl () <ELTradeChangeDelegate>
{
    __weak IBOutlet UILabel *nameLable;
    
    __weak IBOutlet UIButton *nameButton;
    
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet NSLayoutConstraint *titleViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *changeViewTop;
    
    __weak IBOutlet UIView *selectView;
    
    TagView *secondTagView;
    NSMutableArray *secondDataArr;
    ELLableCustomView *addTagView;
    Answer_DataModal *answerModal;
    
    CGRect oldFrame;
    
    CondictionList_DataModal *selectTradeModel;
}

@property(nonatomic,strong) NSMutableArray *selectedTags;

@end

@implementation ELJobGuideLableChangeCtl

-(instancetype)init{
    self=  [super init];
    if (self) {
        rightNavBarStr_ = @"提交";
        rightNavBarRightWidth = @"16";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"为问题添加标签";
    [self setNavTitle:@"为问题添加标签"];
    nameLable.text = @"请选择";
//    
//    addTagView = [[ELLableCustomView alloc]init];
//    addTagView.titleLable.text = @"请填写标签名称，最长8个汉字";
//    [addTagView.addTextField addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    
//    [addTagView.cancelBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
//    [addTagView.confirmationBtn addTarget:self action:@selector(btnResponse:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectedTags = [[NSMutableArray alloc] init];
    secondDataArr = [[NSMutableArray alloc] init];
    
    [self changeRightButtonStatus];
    
    NSString * function = @"getQuestionTagList";
    NSString * op = @"zd_ask_question_busi";
    [ELRequest postbodyMsg:@"" op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSArray *arr = result;
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arr) {
                personTagModel *model = [[personTagModel alloc] init];
                model.tagName_ = dic[@"ylt_name"];
                if(![model.tagName_ isEqualToString:@"行业问答"] && ![model.tagName_ isEqualToString:@"其他类型"]){
                    [secondDataArr addObject:model];
                }
            }
            [self creatTradeSecondChangeViewWithModel:nil];
            [self refreshSelectedTag];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
    if (_editorModel) {
        if (_editorModel.tag_info) {
            for (NSString *name in _editorModel.tag_info) {
                personTagModel *model = [[personTagModel alloc] init];
                model.tagName_ = name;
                [_selectedTags addObject:model];
            }
            [self refreshSelectedTag];
        }
        if (_editorModel.tradeid) {
            CondictionList_DataModal *model = [CondictionTradeCtl returnModelWithTradeId:_editorModel.tradeid];
            if (model) {
                model.pName = [CondictionTradeCtl getTotalNameWithTotalId:model.pId_];
                [self tradeChangeWithArr:model];
            }
        }
    }
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam{
    answerModal = dataModal;
}

- (void)TextFieldDidChange:(UITextField *)textfield
{
    if (textfield == addTagView.addTextField) {
        [MyCommon limitTextFieldTextNumberWithTextField:addTagView.addTextField wordsNum:8 numLb:nil];
    }
}

-(void)rightBarBtnResponse:(id)sender{
    if (_selectedTags.count <= 0 && !selectTradeModel) {
        return;
    }
    
    NSString *groupTags_ = @"";
    for (int i=0; i<[_selectedTags count]; i++)
    {
        
        personTagModel *tags = [_selectedTags objectAtIndex:i];
        groupTags_ = [groupTags_ stringByAppendingString:tags.tagName_];
        
        if (i != [_selectedTags count]-1) {
            groupTags_ = [groupTags_ stringByAppendingString:@","];
        }
    }
    
    NSString *tradeId = @"";
    if (selectTradeModel.id_) {
        tradeId = selectTradeModel.id_;
    }
    NSString *questionTitle = @"";
    NSString *questionContent = @"";
    NSString *expertId = @"";
       
    if (answerModal.expertId_ && ![answerModal.expertId_ isEqualToString:@""]) {
        expertId = answerModal.expertId_;
    }
    
    if (_editorModel) {
        if (_editorModel.question_content && ![_editorModel.question_content isEqualToString:@""]) {
            questionContent = _editorModel.question_content;
        }
        if (_editorModel.question_title && ![_editorModel.question_title isEqualToString:@""]) {
            questionTitle = _editorModel.question_title;
        } 
        NSMutableDictionary * questionDic = [[NSMutableDictionary alloc] init];
        [questionDic setObject:questionTitle forKey:@"question_title"];
        [questionDic setObject:questionContent forKey:@"question_content"];
        [questionDic setObject:groupTags_ forKey:@"question_targ"];
        [questionDic setObject:tradeId forKey:@"tradeid"];
        [questionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        NSString *questionArr = [jsonWriter2 stringWithObject:questionDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"contentArr=%@&question_id=%@",questionArr,_editorModel.question_id];
        NSString * function = @"doeditQuestion";
        NSString * op = @"zd_ask_question_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"正在提交" success:^(NSURLSessionDataTask *operation, id result) {
            if ([result isKindOfClass:[NSDictionary class]]){
                NSDictionary *dic = result;
                Status_DataModal * datamodel = [[Status_DataModal alloc] init];
                datamodel.status_ = [dic objectForKey:@"status_des"];
                datamodel.code_ = [dic objectForKey:@"code"];
                datamodel.des_ = [dic objectForKey:@"info"];
                
                if ([datamodel.code_ isEqualToString:@"200"])
                {
                    [BaseUIViewController showAlertViewContent:@"修改成功" toView:nil second:1.0 animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"answerEditorSuccessRefresh" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
                    });
                }
                else if ([datamodel.code_ isEqualToString:@"400"]){
                    [BaseUIViewController showAutoDismissFailView:@"已存在相同的问题" msg:nil];
                }
                else if ([datamodel.code_ isEqualToString:@"401"]){
                    [BaseUIViewController showAutoDismissFailView:@"请验证手机或者邮箱" msg:nil];
                }else{
                    [BaseUIViewController showAutoDismissFailView:datamodel.status_ msg:nil];
                }
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];

    }else{
        if (answerModal.questionContent_ && ![answerModal.questionContent_ isEqualToString:@""]) {
            questionTitle = answerModal.questionContent_;
        }
        if (answerModal.content_ && ![answerModal.content_ isEqualToString:@""]) {
            questionContent = answerModal.content_;
        } 
        NSMutableDictionary * questionDic = [[NSMutableDictionary alloc] init];
        [questionDic setObject:@"" forKey:@"category_id"];
        [questionDic setObject:@"1" forKey:@"type"];
        [questionDic setObject:questionTitle forKey:@"question_title"];
        [questionDic setObject:questionContent forKey:@"question_content"];
        [questionDic setObject:groupTags_ forKey:@"question_targ"];
        [questionDic setObject:tradeId forKey:@"tradeid"];
        
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        NSString *questionArr = [jsonWriter2 stringWithObject:questionDic];
        
        //组装请求参数
        NSString * bodyMsg = [NSString stringWithFormat:@"uid=%@&querstionArr=%@&topic_id=%@&expert_id=%@&conditionArr=%@&tag_flag=%@",[Manager getUserInfo].userId_,questionArr,@"",expertId,@"",@"tag_name"];
        NSString * function = @"new_sumbit_question";
        NSString * op = @"zd_ask_question_busi";
        [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:YES progressMsg:@"正在提交" success:^(NSURLSessionDataTask *operation, id result) {
            if ([result isKindOfClass:[NSDictionary class]]){
                NSDictionary *dic = result;
                Status_DataModal * datamodel = [[Status_DataModal alloc] init];
                NSDictionary *dicOne = dic[@"data"];
                datamodel.status_ = [dic objectForKey:@"status_desc"];
                datamodel.code_ = [dic objectForKey:@"code"];
                datamodel.des_ = [dic objectForKey:@"info"];
                if ([dicOne isKindOfClass:[NSDictionary class]] && datamodel.status_.length <= 0) {
                    datamodel.status_ = [dicOne objectForKey:@"status_desc"];
                    datamodel.code_ = [dicOne objectForKey:@"code"];
                    datamodel.des_ = [dicOne objectForKey:@"info"];
                }
                
                if ([datamodel.code_ isEqualToString:@"200"])
                {
                    NSString * typeStr = [RegCtl getRegTypeStr:[Manager shareMgr].registeType_];
                    NSDictionary *dict = @{@"Source" : typeStr};
                    [MobClick event:@"askedCount" attributes:dict];
                    
                    AnswerDetailCtl *detailCtl = [[AnswerDetailCtl alloc] init];
                    detailCtl.isAsk = YES;
                    [self.navigationController pushViewController:detailCtl animated:YES];
                    detailCtl.backCtlIndex = _backCtlIndex;
                    [detailCtl beginLoad:datamodel.des_ exParam:nil];
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
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];

    }
    
        
//    if ([answerModal.expertId_ isEqualToString:@""] || answerModal.expertId_ == nil) {
//        [askDefaultCon_ askQuest:[Manager getUserInfo].userId_ expertId:@"" question:answerModal.questionContent_ type:@"1" questionTag:groupTags_ tradeId:tradeId];  
//    }
//    else
//    {
//        [askDefaultCon_ askQuest:[Manager getUserInfo].userId_ expertId:answerModal.expertId_ question:answerModal.questionContent_ type:@"1" questionTag:groupTags_ tradeId:tradeId];
//    }
}

-(void)btnResponse:(id)sender{
    if(sender == addTagView.cancelBtn)
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
    }else if (sender == nameButton){
        ELJobGuideTradeChangeCtl *ctl = [[ELJobGuideTradeChangeCtl alloc] init];
        ctl.tradeDelegate = self;
        ctl.selectChangeModal = selectTradeModel;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

-(void)tradeChangeWithArr:(CondictionList_DataModal *)dataModal{
    if (dataModal){
        selectTradeModel = dataModal;
        nameLable.textColor = UIColorFromRGB(0x757575);
        nameLable.text = [NSString stringWithFormat:@"%@-%@",dataModal.pName,dataModal.str_];
        
        NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
        if (dataModal.str_) {
            [conditionDic setObject:dataModal.str_ forKey:@"trade_name"];
        }
        if (dataModal.pId_){
            [conditionDic setObject:dataModal.pId_ forKey:@"totalid"];
        }
        if (dataModal.id_){
            [conditionDic setObject:dataModal.id_ forKey:@"tradeid"];
        }
        SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
        NSString *conditionStr = [jsonWriter2 stringWithObject:conditionDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"arr=%@",conditionStr];
        [ELRequest postbodyMsg:bodyMsg op:@"zd_ask_question_busi" func:@"get_tag_list_by_tade_name" requestVersion:YES progressFlag:YES progressMsg:@"" success:^(NSURLSessionDataTask *operation, id result) {
            NSDictionary *dic = result;
            [secondDataArr removeAllObjects];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *arr = dic[@"tag_list"];
                if ([arr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *subDic in arr) {
                        personTagModel *model = [[personTagModel alloc] init];
                        model.tagName_ = subDic[@"ylt_name"];
                        model.tagId_ = subDic[@"ylt_id"];
                        [secondDataArr addObject:model];
                    }
                }
            }
            [self creatTradeSecondChangeViewWithModel:nil];
            [self refreshSelectedTag];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
}

-(void)setRightBarBtnAtt{
    [super setRightBarBtnAtt];
    rightBarBtn_.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
}

-(void)changeRightButtonStatus{
    if (_selectedTags.count > 0 || selectTradeModel) {
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{
        [rightBarBtn_ setTitleColor:UIColorFromRGB(0xf3b4b4) forState:UIControlStateNormal];
    }
}

-(void)creatTradeSecondChangeViewWithModel:(personTagModel *)dataOne
{
    [secondTagView removeFromSuperview];
    secondTagView = [[TagView alloc]init];
    secondTagView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    secondTagView.backgroundColor = [UIColor whiteColor];
    __weak TagView *tagView = secondTagView;
    __weak ELJobGuideLableChangeCtl *learnTechniqueCtl = self;
    secondTagView.clickBlock =^(personTagModel *tag)
    {
        if (learnTechniqueCtl.selectedTags.count >= 6)
        {
            [BaseUIViewController showAlertViewContent:@"最多6个标签" toView:learnTechniqueCtl.view second:1.0 animated:YES];
            return;
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
    
    secondTagView.tagArray = [NSArray arrayWithArray:secondDataArr];
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
            }else{
                [button setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
    secondTagView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:secondTagView];
}

#pragma mark 刷新显示选择的标签
- (void)refreshSelectedTag
{
    for (UIView *view in selectView.subviews) {
        [view removeFromSuperview];
    }
    oldFrame = CGRectZero;
    for (int i=0; i<_selectedTags.count; i++)
    {
//        if(i == _selectedTags.count)
//        {
//            CustomTagButton *button = [[CustomTagButton alloc]init];
//            [button setTitle:@"+  自定义" forState:UIControlStateNormal];
//            button.titleLabel.font = FOURTEENFONT_CONTENT;
//            [button setTitleColor:FONEREDCOLOR forState:UIControlStateNormal];
//            [button setBackgroundColor:[UIColor clearColor]];
//            CGRect frame = [self setButtonTitle:@"+ 自定义" button:button];
//            button.frame = frame;
//            [button addTarget:self action:@selector(addTagBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [selectView addSubview:button];
//        }else{
            CustomTagButton *button = [[CustomTagButton alloc]init];
            personTagModel *tag = _selectedTags[i];
            [button setTitle:tag.tagName_ forState:UIControlStateNormal];
            button.titleLabel.font = FOURTEENFONT_CONTENT;
            [button setTag:200+i];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:PINGLUNHONG];
            CGRect frame = [self setButtonTitle:tag.tagName_ button:button];
            UIView *deleteView = [self getDeleteView:button];
            frame.size.width +=15;
            deleteView.frame = frame;
            [selectView addSubview:deleteView];
            [button addTarget:self action:@selector(selectedTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //}
    }
    titleViewHeight.constant = CGRectGetMaxY(oldFrame) + 33 + 16;
    changeViewTop.constant = titleViewHeight.constant + 25;
    CGFloat tagHeight = ScreenHeight-64-changeViewTop.constant-58;
    if (tagHeight > secondTagView.contentSize.height) {
        tagHeight = secondTagView.contentSize.height;
    }
    secondTagView.frame = CGRectMake(0,changeViewTop.constant + 58,ScreenWidth,tagHeight);
    oldFrame = CGRectZero;
    [self changeRightButtonStatus];
}

-(void)addTagBtn:(UIButton *)sender
{
    if (self.selectedTags.count >= 6)
    {
        [BaseUIViewController showAlertViewContent:@"最多6个标签" toView:self.view second:1.0 animated:YES];
        return;
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
-(CGRect) setButtonTitle:(NSString *)title button:(UIButton*)button{
    [button sizeToFit];
    CGSize titleSize = button.size;
    titleSize.height = 30;
    button.layer.cornerRadius = 15;
    titleSize.width += 32;
    
    CGFloat buttonX = 16;
    CGFloat buttonY = 16;
    CGFloat maxButtonY = 0;
    if (oldFrame.size.height>0) {
        buttonX = CGRectGetMaxX(oldFrame)+MARGIN_LEFT;
        buttonY = CGRectGetMinY(oldFrame);
        maxButtonY = CGRectGetMaxY(oldFrame) + MARGIN_TOP;
    }
    CGRect frame;
    if (buttonX + titleSize.width > ScreenWidth-20) {
        frame = CGRectMake(16,maxButtonY,titleSize.width,titleSize.height);
    }else{
        frame = CGRectMake(buttonX,buttonY,titleSize.width,titleSize.height);
    }
    button.frame = CGRectMake(0,0,titleSize.width,titleSize.height);
    oldFrame = frame;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
