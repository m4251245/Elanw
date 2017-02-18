//
//  QuestionListCtl.m
//  jobClient
//
//  Created by YL1001 on 14/10/30.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "QuestionListCtl.h"
#import "QuestionList_Cell.h"
#import "Answer_DataModal.h"
#import "MLEmojiLabel.h"
#import "MyQuestionAndAnswerModal.h"

@interface QuestionListCtl ()

@end

@implementation QuestionListCtl

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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    tableView_ = tableView;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setFd_prefersNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self setFd_prefersNavigationBarHidden:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    NSUserDefaults *homeDefaults = [[NSUserDefaults alloc]init];
    NSString * showtime = [homeDefaults objectForKey:@"HOMETIMEUSERDEFAULT"];
    if(!showtime){
        showtime = @"";
    }
    NSString *personId = [Manager getUserInfo].userId_;
    if (_formPersonCenter) {
        if (_userId && ![_userId isEqualToString:@""]) {
            personId = _userId;
        }
    }
    [con getMyAQList:personId type:1 pageInde:requestCon_.pageInfo_.currentPage_ pageSize:20 showtime:showtime];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionListCell";
    
    QuestionList_Cell *cell = (QuestionList_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionList_Cell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView_.layer.cornerRadius = 8;
        
        cell.statusLabel.clipsToBounds = YES;
        cell.statusLabel.layer.cornerRadius = 2.0;
    }
        
    MyQuestionAndAnswerModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    CGFloat rightWidth = 16;
    if ([dataModal.question_status integerValue] == 0) {
        cell.statusLabel.textColor = UIColorFromRGB(0xffffff);
        cell.statusLabel.backgroundColor = UIColorFromRGB(0xf5bf2b);
        cell.statusLabel.text = @"审核中";
        cell.statusLabel.hidden = NO;
        rightWidth += 60;
    }else if ([dataModal.question_status integerValue] == 2){
        cell.statusLabel.textColor = UIColorFromRGB(0xffffff);
        cell.statusLabel.backgroundColor = UIColorFromRGB(0xbdbdbd);
        cell.statusLabel.text = @"已禁用";
        cell.statusLabel.hidden = NO;
        rightWidth += 60;
    }else{
        cell.statusLabel.hidden = YES;
        rightWidth += 8;
    }
    cell.questionLb_.hidden = YES;
    MLEmojiLabel *emojiLabel = [self emojiLabel:[MyCommon removeSpaceAtSides:dataModal.question_title] numberOfLines:0 textColor:UIColorFromRGB(0x333333)];
    emojiLabel.tag = 221;
    emojiLabel.frame = CGRectMake(8, 8, ScreenWidth-rightWidth, 54);
    [emojiLabel sizeToFit];
    UIView *oldView = [cell viewWithTag:221];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    [cell.contentView_ addSubview:emojiLabel];
    
    //重设answerView_ Y值
    CGRect answerViewFrame = cell.answerView_.frame;
    answerViewFrame.origin.y = CGRectGetMaxY(emojiLabel.frame)+ 5;
    cell.answerView_.frame = answerViewFrame;
    
    if (!dataModal.answer_id|| [dataModal.answer_id isEqualToString:@""] || dataModal.question_replys_count.integerValue == 0) {
        cell.noAnswerLb_.hidden = NO;
        cell.answerNameLb_.hidden = YES;
        cell.addAnswerLb_.hidden = YES;
        cell.allAnswerCnt_.text = [NSString stringWithFormat:@"回答:%ld",(long)dataModal.question_replys_count.integerValue];    }
    else
    {
        cell.noAnswerLb_.hidden = YES;
        cell.answerNameLb_.hidden = NO;
        cell.addAnswerLb_.hidden = NO;

        cell.answerNameLb_.text = dataModal.person_iname;
        
        NSString *str = [NSString stringWithFormat:@"回答:%ld",(long)dataModal.question_replys_count.integerValue];
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
        [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, str.length - 3)];
        
        cell.allAnswerCnt_.attributedText = mutableStr;
    }
    
    NSString *answerTime = [MyCommon getShortTime:dataModal.question_idate];
    [cell.atimeLb_ setText:answerTime];
    
    CGRect frame = cell.contentView_.frame;
    frame.size.height = cell.answerView_.frame.origin.y + cell.answerView_.frame.size.height + 10;
    cell.contentView_.frame = frame;
    
    frame = cell.frame;
    frame.size.height = cell.contentView_.frame.origin.y + cell.contentView_.frame.size.height;
    cell.frame = frame;

    return cell;
}

- (MLEmojiLabel *)emojiLabel:(NSString *)text numberOfLines:(int)num textColor:(UIColor *)color
{
    MLEmojiLabel * emojiLabel;
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = num;
    emojiLabel.font = [UIFont systemFontOfSize:14];
    emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (color) {
        emojiLabel.textColor = color;
    }
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    emojiLabel.customEmojiRegex = Custom_Emoji_Regex;
    emojiLabel.customEmojiPlistName = @"emoticons.plist";
    [emojiLabel setEmojiText:[MyCommon translateHTML:text]];
    return emojiLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView_ cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    MyQuestionAndAnswerModal *selectModal = requestCon_.dataArr_[indexPath.row];

    AnswerDetailCtl * detailCtl = [[AnswerDetailCtl alloc] init];
    [self.navigationController pushViewController:detailCtl animated:YES];
    [detailCtl beginLoad:selectModal.question_id exParam:exParam];
}





@end
