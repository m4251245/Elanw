//
//  MyResumeCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-9-4.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "NewMyResumeCtl.h"
#import "MyResumeCtlCell.h"
@interface NewMyResumeCtl ()

@end

@implementation NewMyResumeCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

/**
 *  更新视图
 *
 *  @param con 请求类
 */
- (void)updateComInfo:(PreRequestCon *)con
{
    
}

/**
 *  请求个人简历信息
 */
- (void)getDataFunction
{
    [PreRequestCon_ loadPersonInfo];
}

/**
 *  请求回调
 *
 *  @param preRequestCon 请求类
 *  @param code          错误CODE
 *  @param type          请求类型
 *  @param dataArr       结果集
 */
-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case PersonInfo_XMLParser:
        {
            @try {
//                personDetailInfoDataModal = nil;
                dataModel_ = [dataArr objectAtIndex:0];
                
                //让基本资料类开始载入数据
            }
            @catch (NSException *exception) {
                personDetailInfoDataModal = nil;
            }
            @finally {
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的简历";
    tableView_.delegate = self;
    tableView_.dataSource = self;
    [nameBtn_.titleLabel setFont:FOURTEENFONT_CONTENT];
    [nameBtn_.titleLabel setTextColor:GRAYCOLOR];
    nameBtn_.layer.cornerRadius = 2.0;
    nameBtn_.layer.borderWidth = 1.0;
    nameBtn_.layer.borderColor = GRAYCOLOR.CGColor;
    
    [nameLb_ setFont:FIFTEENFONT_TITLE];
    [nameLb_ setTextColor:BLACKCOLOR];
    // Do any additional setup after loading the view from its nib.
}

-(void) beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 3;
    }
    else if (section == 2)
    {
        return 3;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 24)];
    [titleLb setBackgroundColor:[UIColor clearColor]];
    [titleLb setFont:TWEELVEFONT_COMMENT];
    [titleLb setTextColor:GRAYCOLOR];
    if (section == 0) {
        [titleLb setText:@"基本信息"];
    }else if (section == 1){
        [titleLb setText:@"其他信息"];
    }else if (section == 2){
        [titleLb setText:@"学生信息"];
    }
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 24)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLb];
    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyResumeCtlCell";
    
    MyResumeCtlCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyResumeCtlCell" owner:self options:nil] lastObject];
    }
    [cell.titleLb_ setFont:FIFTEENFONT_TITLE];
    [cell.titleLb_ setTextColor:BLACKCOLOR];
    [cell.lineImgv_ setHidden:NO];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell.titleLb_ setText:@"个人信息"];
                }
                    break;
                case 1:
                {
                    [cell.titleLb_ setText:@"求职意向"];
                }
                    break;
                case 2:
                {
                    [cell.titleLb_ setText:@"工作经验"];
                    [cell.lineImgv_ setHidden:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell.titleLb_ setText:@"教育背景"];
                }
                    break;
                case 1:
                {
                    [cell.titleLb_ setText:@"工作技能"];
                }
                    break;
                case 2:
                {
                    [cell.titleLb_ setText:@"证书管理"];
                    [cell.lineImgv_ setHidden:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell.titleLb_ setText:@"所获奖项"];
                }
                    break;
                case 1:
                {
                    [cell.titleLb_ setText:@"学生干部"];
                }
                    break;
                case 2:
                {
                    [cell.titleLb_ setText:@"活动经历"];
                    [cell.lineImgv_ setHidden:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (!personInfoCtl_) {
                        personInfoCtl_  = [[PersonInfo_ResumeCtl alloc] init];
                    }
                    [self.navigationController pushViewController:personInfoCtl_ animated:YES];
                }
                    break;
                case 1:
                {
                    if (!wantJobCtl_) {
                        wantJobCtl_ = [[WantJob_ResumeCtl alloc]init];
                    }
                    [self.navigationController pushViewController:wantJobCtl_ animated:YES];
                }
                    break;
                case 2:
                {
                    if (!worksCtl_) {
                        worksCtl_ = [[Works_ResumeCtl alloc]init];
                    }
                    [self.navigationController pushViewController:wantJobCtl_ animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (!eduCtl_) {
                        eduCtl_  = [[Edu_ResumeCtl alloc] init];
                    }
                    [self.navigationController pushViewController:personInfoCtl_ animated:YES];
                }
                    break;
                case 1:
                {
                    if (!skillCtl_) {
                        skillCtl_ = [[Skill_ResumeCtl alloc]init];
                    }
                    [self.navigationController pushViewController:wantJobCtl_ animated:YES];
                }
                    break;
                case 2:
                {
                    if (!cerCtl_) {
                        cerCtl_ = [[Cer_ResumeCtl alloc]init];
                    }
                    [self.navigationController pushViewController:wantJobCtl_ animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (!awardCtl_) {
                        awardCtl_  = [[Award_ResumeCtl alloc] init];
                    }
                    [self.navigationController pushViewController:personInfoCtl_ animated:YES];
                }
                    break;
                case 1:
                {
                    if (!leaderCtl_) {
                        leaderCtl_ = [[Leader_ResumeCtl alloc]init];
                    }
                    [self.navigationController pushViewController:wantJobCtl_ animated:YES];
                }
                    break;
                case 2:
                {
                    if (!projectCtl_) {
                        projectCtl_ = [[Project_ResumeCtl alloc]init];
                    }
                    [self.navigationController pushViewController:wantJobCtl_ animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resumeInfoChanged:(BaseResumeCtl *)ctl modal:(PersonDetailInfo_DataModal *)modal
{
    
}

@end
