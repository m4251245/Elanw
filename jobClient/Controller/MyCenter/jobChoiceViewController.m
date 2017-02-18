//
//  jobChoiceViewController.m
//  jobClient
//
//  Created by 一览ios on 15/12/23.
//  Copyright © 2015年 YL1001. All rights reserved.
//  人才投递 顾问推荐筛选列表

#import "jobChoiceViewController.h"
#import "TradeZWModel.h"
#import "jobChoiceTableViewCell.h"
@interface jobChoiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UIView *btnBackView;
    __weak IBOutlet UIView *_maskView;
    
}
@property (nonatomic, strong) NSMutableArray *zwNameArr;//职位名称
@property (nonatomic, strong) NSMutableArray *selectedArr;  /**< 选择职位 */
@property (nonatomic, strong) NSMutableArray *jobIdArr;//jobId

@end

@implementation jobChoiceViewController

-(NSMutableArray *)dataRctdArr
{
    if (!_dataRctdArr) {
        _dataRctdArr = [[NSMutableArray alloc]init];
    }
    return _dataRctdArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_zwNameArr) {
        _zwNameArr = [[NSMutableArray alloc]init];
    }
    
    _jobIdArr = [[NSMutableArray alloc]init];
    _selectedArr = [[NSMutableArray alloc]init];
    _titleArr = [[NSMutableArray alloc]init];
    
    CGRect frame = _tabview.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - 244;
    frame.size.width = ScreenWidth;
    _tabview.frame = frame;
    
    frame = btnBackView.frame;
    frame.origin.y = CGRectGetMaxY(_tabview.frame);
    btnBackView.frame = frame;
    
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideJobChoiceView:)]];
}

- (void)hideJobChoiceView:(UITapGestureRecognizer *)singleTap
{
    [self hideJobChoiceList];
}

#pragma mark - UIatableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataRctdArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    jobChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = [UIColor redColor];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"jobChoiceTableViewCell" owner:self options:nil].lastObject;
    }
    
    TradeZWModel *model = self.dataRctdArr[indexPath.row];
    
    if ([_zwNameArr containsObject:model.zwName]) {
        cell.jobNameLb.textColor = [UIColor redColor];
        [cell.selectedIcon setHidden:NO];
        
    }else{
        cell.jobNameLb.textColor = [UIColor blackColor];
        [cell.selectedIcon setHidden:YES];
    }

    
    NSString *title;
    if ([model.type isEqualToString:@"1"]) {
        title = [NSString stringWithFormat:@"%@【在招】",model.zwName];
        
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:title];
        NSRange range1 = NSMakeRange(model.zwName.length, 4);
        [hintString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE4403A) range:range1];

        cell.jobNameLb.attributedText = hintString;

    }else if ([model.type isEqualToString:@"0"]){
        
        title = [NSString stringWithFormat:@"%@【停招】",model.zwName];
        
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc] initWithString:title];
        NSRange range1 = NSMakeRange(model.zwName.length, 4);
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range1];
        
        cell.jobNameLb.attributedText = hintString;
        
    }else{
        title = model.zwName;
        cell.jobNameLb.text = model.zwName;
    }
    
    CGSize sizeLb = [title sizeNewWithFont:FOURTEENFONT_CONTENT constrainedToSize:CGSizeMake(270, 30)];
    CGRect rect = cell.jobNameLb.frame;
    rect.size.width = sizeLb.width+5;
    cell.jobNameLb.frame = rect;

    rect = cell.selectedIcon.frame;
    rect.origin.x = CGRectGetMaxX(cell.jobNameLb.frame) + 2;
    cell.selectedIcon.frame = rect;
    
    
    cell.jobNameLb.font = FOURTEENFONT_CONTENT;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeZWModel *model = self.dataRctdArr[indexPath.row];
    NSString *zwName = model.zwName;
    NSString *jobId = model.zwid;
    
    if ([zwName isEqualToString:@"不限"]) {
        [_zwNameArr removeAllObjects];
        [_zwNameArr addObject:zwName];
        
        [_jobIdArr removeAllObjects];
        [_jobIdArr addObject:jobId];
        
    } else{
        if ([_zwNameArr containsObject:@"不限"]) {
            [_zwNameArr removeObject:@"不限"];
            [_jobIdArr removeObject:@"0"];
        }
        
        if ([_zwNameArr containsObject:zwName]) {
            [_zwNameArr removeObject:zwName];
            [_jobIdArr removeObject:jobId];
            
        }else{
            [_zwNameArr addObject:zwName];
            [_jobIdArr addObject:jobId];
        }
    }
    
    [tableView reloadData];
}

-(void)showJobChoiceList
{
    CGRect frame = self.view.frame;
    frame.origin.y = 104;
    frame.size.width = ScreenWidth;
    frame.size.height = ScreenHeight - 104;
    self.view.frame = frame;
    [_tabview reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
}

-(void)hideJobChoiceList
{
    [self.view removeFromSuperview];
}

- (IBAction)makeSureClick:(id)sender {
    
    if (_jobIdArr.count != 0 && _zwNameArr.count != 0) {
        [_selectedArr addObject:_jobIdArr];
        [_selectedArr addObject:_zwNameArr];
        
    }else{
        [_selectedArr removeAllObjects];
    }

    [_delegate jobChoiceCtl:self selectedArr:_selectedArr];
    [self hideJobChoiceList];
    
    [_zwNameArr removeAllObjects];
    [_jobIdArr removeAllObjects];
    [_selectedArr removeAllObjects];
}


@end
