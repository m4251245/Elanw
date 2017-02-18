//
//  AnswerList_Ctl.m
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "AnswerList_Ctl.h"
#import "AnswerList_Cell.h"
#import "MLEmojiLabel.h"
#import "MyQuestionAndAnswerModal.h"

@interface AnswerList_Ctl ()
{
    UILabel *answerTitleLb;
}
@end

@implementation AnswerList_Ctl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bFooterEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,self.view.height) style:UITableViewStylePlain];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    [self.view addSubview:tableView_];
    [super viewDidLoad];
    [tableView_ setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_isMyCenter)
    {
//        self.navigationItem.title = @"我的回答";
        [self setNavTitle:@"我的回答"];
    }
    else
    {
//        self.navigationItem.title = @"TA的回答";
        [self setNavTitle:@"TA的回答"];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    tableView_.frame = CGRectMake(0,0,ScreenWidth,self.view.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
    if (_isMyCenter)
    {
//        self.navigationItem.title = @"我的回答";
    }
    else
    {
//        self.navigationItem.title = @"TA的回答";
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    _userId = dataModal;
}

-(void)getDataFunction:(RequestCon *)con
{
    NSUserDefaults *homeDefaults = [[NSUserDefaults alloc]init];
    NSString * showtime = [homeDefaults objectForKey:@"HOMETIMEUSERDEFAULT"];
    if(!showtime)
        showtime = @"";
    if (_isMyCenter) {
        _userId = [Manager getUserInfo].userId_;
    }
    NSInteger type = 2;
    if (_isWaitList){
        type = 3;
    }
    [con getMyAQList:_userId type:type pageInde:requestCon_.pageInfo_.currentPage_ pageSize:20 showtime:showtime];
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_MyAQlist:
        {
            for (MyQuestionAndAnswerModal *modal in dataArr)
            {
                modal.answer_content = [MyCommon removeAllSpace:modal.answer_content];
                if (_isWaitList) {
                    if (modal.question_person_id) {
                        modal.person_pic = modal.question_person_pic;
                        modal.person_iname = modal.question_person_iname;
                        modal.person_id = modal.question_person_id;
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyQuestionAndAnswerModal *model = requestCon_.dataArr_[indexPath.row];
    //已回答列表卡片
    if (!_isWaitList && _formMyAnswer){
        return [self getTableViewCellOneWithTableView:tableView model:model];
    }
    //待回答卡片
    return [self getTableViewCellTwoWithTableView:tableView model:model];
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    MyQuestionAndAnswerModal *selectModal = requestCon_.dataArr_[indexPath.row];
    
    AnswerDetailCtl * detailCtl = [[AnswerDetailCtl alloc] init];
    [[Manager shareMgr].centerNav_ pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:selectModal.question_id exParam:exParam];
}

#pragma mark - UItableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyQuestionAndAnswerModal *model = requestCon_.dataArr_[indexPath.row];
    if (!_isWaitList && _formMyAnswer){
        return [self heightCellOneWithModel:model];
    }
    return [self heightCellTwoWithAnswerModel:model];
}

-(CGFloat)heightCellOneWithModel:(MyQuestionAndAnswerModal *)model{
    CGFloat leftW = 10;
    CGFloat rightW = 8;
    CGFloat width = ScreenWidth-leftW-rightW;
    if ([model.manage_status integerValue] == 0) {
        width = ScreenWidth-52-leftW-rightW;
    }else if ([model.manage_status integerValue] == 2){
        width = ScreenWidth-52-leftW-rightW;
    }
    if (!answerTitleLb) {
        answerTitleLb = [[UILabel alloc] init];
        answerTitleLb.font = [UIFont systemFontOfSize:14];
    }
    answerTitleLb.numberOfLines = 2;
    answerTitleLb.frame = CGRectMake(leftW,15,width,20);
    NSString *title = [MyCommon translateHTML:model.question_title];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.lineSpacing = 5.f;
    NSDictionary *attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title attributes:attrDic];
    [answerTitleLb setAttributedText:str];
    [answerTitleLb sizeToFit];
    model.titleAttString = str;
    model.titleFrame = answerTitleLb.frame;
    model.cellHeight = answerTitleLb.frame.size.height + 60;
    return model.cellHeight;
}

-(CGFloat)heightCellTwoWithAnswerModel:(MyQuestionAndAnswerModal*)model
{
    CGFloat height = 15;
    NSString *title = [MyCommon translateHTML:model.question_title];
    
    CGFloat leftW = 10;
    CGFloat rightW = 8;
    
    CGFloat width = ScreenWidth-leftW-rightW;

    if ([model.manage_status integerValue] == 0) {
        width = ScreenWidth-52-leftW-rightW;
    }else if ([model.manage_status integerValue] == 2){
        width = ScreenWidth-52-leftW-rightW;
    }
    if (!answerTitleLb) {
        answerTitleLb = [[UILabel alloc] init];
        answerTitleLb.font = [UIFont systemFontOfSize:14];
    }
    answerTitleLb.frame = CGRectMake(leftW,height,width,20);
    answerTitleLb.numberOfLines = 2;
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    pStyle.lineSpacing = 5.f;
    NSDictionary *attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title attributes:attrDic];
    [answerTitleLb setAttributedText:str];
    [answerTitleLb sizeToFit];
    model.titleAttString = str;
    model.titleFrame = answerTitleLb.frame;
    height += answerTitleLb.frame.size.height;
    
    NSString *content = [MyCommon translateHTML:model.answer_content];
    if (content && ![content isEqualToString:@""]) {
        height += 5;
        answerTitleLb.frame = CGRectMake(leftW,height,ScreenWidth-leftW-rightW,20);
        answerTitleLb.numberOfLines = 3;
        attrDic = @{NSParagraphStyleAttributeName:pStyle, NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0x999999)};
        NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:content attributes:attrDic];
        [answerTitleLb setAttributedText:strContent];
        [answerTitleLb sizeToFit];
        model.contentAttString = strContent;
        model.contentFrame = answerTitleLb.frame;
        height += answerTitleLb.frame.size.height;
    }
    height += 45;
    model.cellHeight = height;
    return model.cellHeight;
}

-(UITableViewCell *)getTableViewCellOneWithTableView:(UITableView *)tableView model:(MyQuestionAndAnswerModal *)model{
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lable = [[UILabel alloc] init];
        lable.numberOfLines = 2;
        lable.tag = 101;
        lable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-56,16,44,17)];
        lable.tag = 102;
        lable.layer.cornerRadius = 2.0;
        lable.layer.masksToBounds = YES;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 1;
        lable.tag = 103;
        lable.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 1;
        lable.tag = 104;
        lable.textAlignment = NSTextAlignmentRight;
        lable.font = [UIFont systemFontOfSize:13];
        lable.textColor = UIColorFromRGB(0x999999);
        [cell.contentView addSubview:lable];
        
        ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)WithColor:UIColorFromRGB(0xe0e0e0)];
        line.tag = 105;
        [cell.contentView addSubview:line];
    }
    UILabel *titleLb = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *statusLb = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *answerLb = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *timeLb = (UILabel *)[cell.contentView viewWithTag:104];
    ELLineView *line = (ELLineView *)[cell.contentView viewWithTag:105];
    
    titleLb.attributedText = model.titleAttString;
    titleLb.frame = model.titleFrame;
    titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if ([model.manage_status integerValue] == 0 && model.answer_id && ![model.answer_id isEqualToString:@""]) {
        statusLb.textColor = UIColorFromRGB(0xffffff);
        statusLb.backgroundColor = UIColorFromRGB(0xf5bf2b);
        statusLb.text = @"审核中";
        statusLb.hidden = NO;
    }else if ([model.manage_status integerValue] == 2){
        statusLb.textColor = UIColorFromRGB(0xffffff);
        statusLb.backgroundColor = UIColorFromRGB(0xbdbdbd);
        statusLb.text = @"已禁用";
        statusLb.hidden = NO;
    }else{
        statusLb.hidden = YES;
    }
    
    NSString *answerContent = [NSString stringWithFormat:@"我的回答：%@",model.answer_content];
    if (!_isMyCenter) {
        answerContent = [NSString stringWithFormat:@"TA的回答：%@",model.answer_content];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:answerContent];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE9474D) range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(5,str.length-5)];
    [answerLb setAttributedText:str];
    answerLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if(model.answer_idate.length >= 10)
    {
        NSString *timeStr = [model.answer_idate substringWithRange:NSMakeRange(0,10)];
        timeLb.text = [NSString stringWithFormat:@"回答于：%@",timeStr];
    }
    else if (model.answer_idate.length > 0) {
        timeLb.text = [NSString stringWithFormat:@"回答于：%@",model.answer_idate];
    }
    else
    {
        timeLb.text = @"";
    }
    answerLb.frame = CGRectMake(10,model.cellHeight-35,ScreenWidth-150,20);
    timeLb.frame = CGRectMake(ScreenWidth-138,model.cellHeight-35,130,20);
    line.frame =  CGRectMake(10,model.cellHeight-1,ScreenWidth,1);
    return cell;
}


-(UITableViewCell *)getTableViewCellTwoWithTableView:(UITableView *)tableView model:(MyQuestionAndAnswerModal *)model{
    static NSString *cellStr = @"cellTwo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lable = [[UILabel alloc] init];
        lable.numberOfLines = 2;
        lable.tag = 101;
        lable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 3;
        lable.tag = 106;
        lable.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lable];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.layer.cornerRadius = 6.0f;
        image.layer.masksToBounds = YES;
        image.tag = 107;
        [cell.contentView addSubview:image];
        
        lable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-56,16,44,17)];
        lable.tag = 102;
        lable.layer.cornerRadius = 2.0;
        lable.layer.masksToBounds = YES;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 1;
        lable.tag = 103;
        lable.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lable];
        
        lable = [[UILabel alloc] init];
        lable.numberOfLines = 1;
        lable.tag = 104;
        lable.textAlignment = NSTextAlignmentRight;
        lable.textColor = UIColorFromRGB(0x999999);
        lable.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lable];
        
        ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,1)WithColor:UIColorFromRGB(0xe0e0e0)];
        line.tag = 105;
        [cell.contentView addSubview:line];
    }
    UILabel *titleLb = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *statusLb = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *answerLb = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *timeLb = (UILabel *)[cell.contentView viewWithTag:104];
    ELLineView *line = (ELLineView *)[cell.contentView viewWithTag:105];
    UILabel *contentLb = (UILabel *)[cell.contentView viewWithTag:106];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:107];
    
    [image sd_setImageWithURL:[NSURL URLWithString:model.person_pic] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    titleLb.attributedText = model.titleAttString;
    titleLb.frame = model.titleFrame;
    titleLb.lineBreakMode = NSLineBreakByTruncatingTail;
    if (model.contentAttString) {
        contentLb.hidden = NO;
        contentLb.attributedText = model.contentAttString;
        contentLb.frame = model.contentFrame;
        contentLb.lineBreakMode = NSLineBreakByTruncatingTail;
    }else{
        contentLb.hidden = YES;
    }
    
    if ([model.manage_status integerValue] == 0 && model.answer_id && ![model.answer_id isEqualToString:@""]) {
        statusLb.textColor = UIColorFromRGB(0xffffff);
        statusLb.backgroundColor = UIColorFromRGB(0xf5bf2b);
        statusLb.text = @"审核中";
        statusLb.hidden = NO;
    }else if ([model.manage_status integerValue] == 2){
        statusLb.textColor = UIColorFromRGB(0xffffff);
        statusLb.backgroundColor = UIColorFromRGB(0xbdbdbd);
        statusLb.text = @"已禁用";
        statusLb.hidden = NO;
    }else{
        statusLb.hidden = YES;
    }
    
    NSString *answerContent = [NSString stringWithFormat:@"提问者：%@",model.person_iname];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:answerContent];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE9474D) range:NSMakeRange(4,str.length-4)];
    [answerLb setAttributedText:str];
    answerLb.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if(model.question_idate.length >= 10)
    {
        NSString *timeStr = [model.question_idate substringWithRange:NSMakeRange(0,10)];
        timeLb.text = [NSString stringWithFormat:@"提问于：%@",timeStr];
    }
    else if (model.question_idate.length > 0) {
        timeLb.text = [NSString stringWithFormat:@"提问于：%@",model.question_idate];
    }
    else
    {
        timeLb.text = @"";
    }
    image.frame = CGRectMake(10,model.cellHeight-40,32,32);
    answerLb.frame = CGRectMake(45,model.cellHeight-35,ScreenWidth-140-45,20); 
    timeLb.frame = CGRectMake(ScreenWidth-138,model.cellHeight-35,130,20);
    line.frame =  CGRectMake(10,model.cellHeight-1,ScreenWidth,1);
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
