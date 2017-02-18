//
//  ELAddResumeReason.m
//  jobClient
//
//  Created by 一览ios on 16/12/10.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAddResumeReason.h"
#import "ELAddResumeReasonCell.h"
#import "ELTextView.h"

@interface ELAddResumeReason ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

{
    UITableView    *_tableView;
    NSMutableArray *_dataSource;
    ELTextView     *_textView;
    NSMutableArray *tags_name;//记录选择的原因
}

@end

@implementation ELAddResumeReason

- (instancetype)init
{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"提交";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"不通过原因"];
    
    [self configData];
    [self configUI];
}

- (void)configUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 48;
//    _tableView.tableFooterView = [UIView new];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth, 150)];
    _tableView.tableFooterView = bottomView;
    
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, bottomView.width-32, 13)];
    tipLabel.text = @"备注内容";
    tipLabel.textColor = UIColorFromRGB(0x9e9e9e);
    [bottomView addSubview:tipLabel];
    
    _textView = [[ELTextView alloc] initWithFrame:CGRectMake(tipLabel.left, tipLabel.bottom+15, tipLabel.width, 60)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textColor = UIColorFromRGB(0x212121);
    _textView.placeholder = @"请备注原因";
    _textView.delegate = self;
    [bottomView addSubview:_textView];
    
}

- (void)configData
{
    _dataSource = [NSMutableArray arrayWithArray:@[@"期待薪酬过高",@"学历不符",@"行业背景不符",@"技能水平不符",@"人才拒绝"]];
    tags_name = [NSMutableArray arrayWithCapacity:1];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-12-24, 12, 24, 24);
    btn.tag = 1000+indexPath.row;
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"checkBox_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"checkBox_selected"] forState:UIControlStateSelected];
    [cell.contentView addSubview:btn];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell viewWithTag:1000+indexPath.row];
    btn.selected = !btn.selected;

    if (btn.selected) {
        [tags_name addObject:_dataSource[indexPath.row]];
    }else{
        for (int i = 0; i < tags_name.count; i++) {
            if ([tags_name[i] isEqualToString:_dataSource[indexPath.row]]) {
                [tags_name removeObjectAtIndex:i];
            }
        }
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.contentOffset = CGPointMake(0, 44*_dataSource.count);
    }];
    
    [textView viewWithTag:1000].hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _tableView.contentOffset = CGPointMake(0, 0);
    if (textView.text.length <= 0) {
        [textView viewWithTag:1000].hidden = NO;
    }else{
        [textView viewWithTag:1000].hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _tableView.contentOffset = CGPointMake(0, 0);
    [_textView resignFirstResponder];
}

#pragma mark - keyBoard 
-(void)keyboardWillHide:(NSNotification *)notification{
    [super keyboardWillHide:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight;
    self.scrollView_.frame = frame;
}

-(void)keyboardWillShow:(NSNotification *)notification{
    [super keyboardWillShow:notification];
    CGRect frame = self.scrollView_.frame;
    frame.size.height = ScreenHeight-self.keyBoardHeight;
    self.scrollView_.frame = frame;
}

#pragma mark --- 提交
- (void)rightBarBtnResponse:(id)sender
{
    [_textView resignFirstResponder];
        
    if (_textView.text.length <= 0) {
        [BaseUIViewController showAutoDismissSucessView:@"请填写不通过原因" msg:nil];
        return;
    }
    
    NSMutableDictionary *tjresumeDic = [[NSMutableDictionary alloc] init];
    [tjresumeDic setObject:_userModel.companyId forKey:@"reid"];
    [tjresumeDic setObject:_userModel.recommendId forKey:@"id"];
    [tjresumeDic setObject:_companyId forKey:@"company_id"];
    [tjresumeDic setObject:@"mianshi" forKey:@"type"];
    [tjresumeDic setObject:@"7" forKey:@"state"];
    
    
    NSMutableDictionary *commentDic = [[NSMutableDictionary alloc] init];
    [commentDic setObject:_userModel.zpId_ forKey:@"jobid"];
    [commentDic setObject:_textView.text?_textView.text:@"" forKey:@"commentContent"];
    [commentDic setObject:@"面试不通过" forKey:@"comment_type"];
    [commentDic setObject:_userModel.userId_ forKey:@"person_id"];
    NSString *synergy_id = [CommonConfig getDBValueByKey:@"synergy_id"];
    if (synergy_id && synergy_id.length > 1) {
        [commentDic setObject:synergy_id forKey:@"synergy_m_id"];
    }
    [commentDic setObject:@"40" forKey:@"company_resume_comment_label_id"];
    [commentDic setObject:@"5" forKey:@"person_type"];
    [commentDic setObject:tags_name forKey:@"tags_name"];
    
    SBJsonWriter *jsonWrite = [[SBJsonWriter alloc] init];
    NSString *tjresumeStr = [jsonWrite stringWithObject:tjresumeDic];
    NSString *commentStr = [jsonWrite stringWithObject:commentDic];
    
    NSString * bodyMsg = [NSString stringWithFormat:@"tjresumeArr=%@&commentArr=%@&conditionArr=&", tjresumeStr, commentStr];
    
    NSString * function = @"updateTjStateNew";
    NSString * op = @"offerpai_busi";
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        if ([result isEqual:@1]) {
            [BaseUIViewController showAutoDismissSucessView:@"提交成功" msg:nil];
            _addReasonBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
               
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
