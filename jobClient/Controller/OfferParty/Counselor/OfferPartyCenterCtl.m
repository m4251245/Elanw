//
//  OfferPartyCenterCtl.m
//  jobClient
//
//  Created by 一览ios on 15/7/3.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "OfferPartyCenterCtl.h"
#import "ExRequetCon.h"
#import "OfferPartyCenterCell.h"
#import "MyOfferPartyDetailCtl.h"
#import "OfferPartyAllInterviewCtl.h"
#import "CounselorOfferPartyResumeListCtl.h"

@interface OfferPartyCenterCtl ()
{
    UIView *headView;
}
@end

@implementation OfferPartyCenterCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    _logoImgv.layer.borderWidth = 0.5;
    _logoImgv.layer.borderColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0].CGColor;

    if ([self.fromtype isEqualToString:@"offer"]) {
        self.navigationItem.title = @"Offer派";
        
    }else if ([self.fromtype isEqualToString:@"vph"]){
        self.navigationItem.title = @"V聘会";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countRefresh:) name:@"OFFERPAICOUNREFRESH" object:nil];
    
    [self creatUI];
}

- (void)countRefresh:(NSNotification *)nofy
{
    [self refreshLoad:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)updateCom:(RequestCon *)con
{
   
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    [super updateCom:con];
    if (!con) {
        con = [self getNewRequestCon:YES];
    }
    [con getOfferPartyCount:_jobfair_id];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetOfferPartyPersonCnt://offer派人数统计
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)creatUI{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,82)];
    headView.backgroundColor = [UIColor whiteColor];
    self.logoImgv = [[UIImageView alloc] initWithFrame:CGRectMake(8,13,65,40)];
    [headView addSubview:self.logoImgv];
    
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(80,13,ScreenWidth-90,0)];
    self.titleLb.font = [UIFont systemFontOfSize:14];
    self.titleLb.numberOfLines = 1;
    self.titleLb.textColor = UIColorFromRGB(0x262626);
    [headView addSubview:self.titleLb];
    
    self.addLb = [[UILabel alloc] initWithFrame:CGRectMake(80,32,ScreenWidth-90,0)];
    self.addLb.font = [UIFont systemFontOfSize:12];
    self.addLb.numberOfLines = 2;
    self.addLb.textColor = UIColorFromRGB(0x757575);
    [headView addSubview:self.addLb];
    
    self.timeLb = [[UILabel alloc] initWithFrame:CGRectMake(80,63,ScreenWidth-90,0)];
    self.timeLb.font = [UIFont systemFontOfSize:12];
    self.timeLb.textColor = UIColorFromRGB(0x757575);
    self.timeLb.numberOfLines = 1;
    [headView addSubview:self.timeLb];
    
    NSString *time = _jobfair_time;
    [self.titleLb setText:_jobfair_name];
    [self.titleLb sizeToFit];
    self.titleLb.frame = CGRectMake(80,13,ScreenWidth-90,self.titleLb.height);
    [self.addLb setText:_place_name];
    [self.addLb sizeToFit];
    self.addLb.frame = CGRectMake(80,CGRectGetMaxY(self.titleLb.frame)+5,ScreenWidth-90,self.addLb.height);
    [self.timeLb setText:time];
    [self.timeLb sizeToFit];
    self.timeLb.frame = CGRectMake(80,CGRectGetMaxY(self.addLb.frame)+5,ScreenWidth-90,self.timeLb.height);
    headView.frame = CGRectMake(0,0,ScreenWidth,CGRectGetMaxY(self.timeLb.frame)+10);
    [self.logoImgv sd_setImageWithURL:[NSURL URLWithString:_logo_src]placeholderImage:[UIImage imageNamed:@"chr_offer_party_bg1.png"]];
    
    tableView_.tableHeaderView = headView;
}


#pragma mark - UITableViewDelagate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.fromtype isEqualToString:@"vph"]) {
        return 6;
    }
    else  if ([self.fromtype isEqualToString:@"offer"]) 
    {
        return 8;
    }
    else{
        return 7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    OfferPartyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OfferPartyCenterCell" owner:self options:nil][0];
        CGRect frame = cell.frame;
        frame.size.width = ScreenWidth;
        cell.frame = frame;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dataDic;
    if (requestCon_.dataArr_.count > 0) {
       dataDic =  requestCon_.dataArr_[0];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            [cell.titleLb setText:@"所有人才"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"allcnt"]];
            if ([dataDic[@"jobfairCnt"][@"allcnt"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"gunoffersuoyou"]];
        }
            break;
        case 1:
        {
            [cell.titleLb setText:@"确认参加"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"joincnt"]];
            if ([dataDic[@"jobfairCnt"][@"joincnt"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"gunoffercelldaochang"]];
        }
            break;
        case 2:
        {
            [cell.titleLb setText:@"通过初选"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"okcnt"]];
            if ([dataDic[@"jobfairCnt"][@"okcnt"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"gunoffercellshihe"]];
        }
            break;
        case 3:
        {
            [cell.titleLb setText:@"已到场"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"isjoin"]];
            if ([dataDic[@"jobfairCnt"][@"isjoin"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"gunoffercelldaochanged"]];
        }
            break;
        case 4:
        {
            [cell.titleLb setText:@"已发Offer"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"offercnt"]];
            if ([dataDic[@"jobfairCnt"][@"offercnt"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"gunoffercellfaoffer"]];
        }
            break;
        case 5:
        {
            [cell.titleLb setText:@"已上岗"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"workcnt"]];
            if ([dataDic[@"jobfairCnt"][@"workcnt"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"gunoffercellshanggang"]];
        }
            break;
        case 6:
        {
                [cell.titleLb setText:@"参会企业"];
                [cell.count setText:dataDic[@"jobfairCnt"][@"companycnt"]];
                if ([dataDic[@"jobfairCnt"][@"companycnt"] isEqualToString:@""]) {
                    cell.count.text = @"0";
                }
                [cell.markImgv setImage:[UIImage imageNamed:@"gunoffercellfaoffer"]];
            
        }
            break;
        case 7:
        {
            [cell.titleLb setText:@"面试通知详情"];
            [cell.count setText:dataDic[@"jobfairCnt"][@"smscnt"]];
            if ([dataDic[@"jobfairCnt"][@"smscnt"] isEqualToString:@""]) {
                cell.count.text = @"0";
            }
            [cell.markImgv setImage:[UIImage imageNamed:@"offer_nitification_image"]];
            
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    CounselorOfferPartyResumeListCtl *resumeListCtl = [[CounselorOfferPartyResumeListCtl alloc] init];
    resumeListCtl.jobfair_id = _jobfair_id;
    resumeListCtl.jobfair_time = _jobfair_time;
    resumeListCtl.fromtype = _fromtype;
    
    switch (indexPath.row) {
        case 0:
        {
            resumeListCtl.resumeListType = OPResumeListTypeAllResume;
            resumeListCtl.title = @"所有人才";
        }
            break;
        case 1:
        {
            resumeListCtl.resumeListType = OPResumeListTypeConfirmToAttend;
            resumeListCtl.title = @"确认参加";
        }
            break;
        case 2:
        {
            resumeListCtl.resumeListType = OPResumeListTypePrimaryElection;
            resumeListCtl.title = @"通过初选";
        }
            break;
        case 3:
        {
            resumeListCtl.resumeListType = OPResumeListTypeHasPresent;
            resumeListCtl.title = @"已到场";
        }
            break;
        case 4:
        {
            resumeListCtl.resumeListType = OPResumeListTypeReceiveOffer;
            resumeListCtl.title = @"已发Offer";
        }
            break;
        case 5:
        {
            resumeListCtl.resumeListType = OPResumeListTypeWorked;
            resumeListCtl.title = @"已上岗";
        }
            break;
        case 6://参会企业
        {
            MyOfferPartyDetailCtl *myOfferPartyDetailCtl = [[MyOfferPartyDetailCtl alloc] init];
            myOfferPartyDetailCtl.title = @"企业列表";
            myOfferPartyDetailCtl.offerPartyDetailType = OfferPartyDetailTypeConsultant;
            myOfferPartyDetailCtl.jobfair_id = _jobfair_id;
            myOfferPartyDetailCtl.jobfair_time = _jobfair_time;
            myOfferPartyDetailCtl.jobfair_name = _jobfair_name;
            myOfferPartyDetailCtl.place_name = _place_name;
            myOfferPartyDetailCtl.fromtype = _fromtype;
            myOfferPartyDetailCtl.isjoin = NO;
            myOfferPartyDetailCtl.iscome = NO;
            [ self.navigationController pushViewController:myOfferPartyDetailCtl animated:YES];
            [myOfferPartyDetailCtl beginLoad:exParam exParam:nil];
            return;
        }
            break;
        case 7:
        {
            OfferPartyAllInterviewCtl *interviewCtl = [[OfferPartyAllInterviewCtl alloc] init];
            interviewCtl.jobfair_id = _jobfair_id;
            [self.navigationController pushViewController:interviewCtl animated:YES];
            [interviewCtl beginLoad:nil exParam:nil];
            return;
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:resumeListCtl animated:YES];
    [resumeListCtl beginLoad:nil exParam:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
