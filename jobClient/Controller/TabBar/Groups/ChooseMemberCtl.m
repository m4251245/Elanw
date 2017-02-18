//
//  ChooseMemberCtl.m
//  Association
//
//  Created by YL1001 on 14-5-30.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "ChooseMemberCtl.h"
#import "InviteFansCtl_Cell.h"

@interface ChooseMemberCtl ()
{
    BOOL    bAll_;
    NSString *_groupId;
}

@end

@implementation ChooseMemberCtl
@synthesize allBtn_,okBtn_,delegate_,type_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        bHeaderEgo_  = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"选择成员"];
    myMemberArr_ = [[NSMutableArray alloc] init];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [myMemberArr_ removeAllObjects];
    [super beginLoad:dataModal exParam:exParam];
    _groupId = dataModal;
    if (exParam) {
        inMemberArr_ = [[NSMutableArray alloc] initWithArray:exParam];
    }else{
        inMemberArr_ = [[NSMutableArray alloc] init];
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetGroupMember:
        {
            if (inMemberArr_.count > 0) {
                for (ELSameTradePeopleFrameModel * model in requestCon_.dataArr_) {
                    if ([inMemberArr_ containsObject:model.peopleModel.person_id]) {
                        model.isInvite_ = YES;
                    }
                }
            }
            [tableView_ reloadData];
        }
            break;
        default:
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InviteFansCtl_Cell";
    
    InviteFansCtl_Cell *cell = (InviteFansCtl_Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteFansCtl_Cell" owner:self options:nil] lastObject];
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        [cell.imgView_.layer setMasksToBounds:YES];
        [cell.imgView_.layer setCornerRadius:4.0];
        
        cell.leftWidth.constant = 0;
        cell.rightWidth.constant = 40;
        cell.imageInvite.hidden = YES;
        cell.rightImageView.hidden = NO;
    }
    ELSameTradePeopleFrameModel * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    cell.nameLb_.text = dataModal.peopleModel.person_iname;
    cell.tradeLb_.text = [NSString stringWithFormat:@"职位:%@",dataModal.peopleModel.trade_job_desc];
    
    [cell.imgView_ sd_setImageWithURL:[NSURL URLWithString:dataModal.peopleModel.person_pic] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
    if (dataModal.isInvite_) {
        cell.rightImageView.image = [UIImage imageNamed:@"checkBox.png"];
    }else{
        cell.rightImageView.image = [UIImage imageNamed:@"uncheckBox.png"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELSameTradePeopleFrameModel *dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    dataModal.isInvite_ = !dataModal.isInvite_;
    [tableView reloadData];
}

-(void)btnResponse:(id)sender
{
    if (sender == okBtn_) {
        for (ELSameTradePeopleFrameModel * dataModal in requestCon_.dataArr_) {
            if (dataModal.isInvite_) {
                [myMemberArr_ addObject:dataModal.peopleModel.person_id];
            }
        }
        if ([myMemberArr_ count] == 0) {
            return;
        }
        if ([delegate_ respondsToSelector:@selector(chooseMember:memberArray:type:)]){
            [delegate_ chooseMember:self memberArray:myMemberArr_ type:type_];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (sender == allBtn_) {
        for (ELSameTradePeopleFrameModel * dataModal in requestCon_.dataArr_) {
            if (!bAll_) {
                [allBtn_ setTitle:@"反选" forState:UIControlStateNormal];
                dataModal.isInvite_ = YES;
            }
            else
            {
                [allBtn_ setTitle:@"全选" forState:UIControlStateNormal];
                dataModal.isInvite_ = NO;
            }
            
        }
        bAll_ = !bAll_;
        [tableView_ reloadData];
    }
    else
    {
        UIButton * btn = sender;
        ELSameTradePeopleFrameModel * dataModal = [requestCon_.dataArr_ objectAtIndex:btn.tag-1];
        dataModal.isInvite_ = !dataModal.isInvite_;
        [btn setSelected:dataModal.isInvite_];
    }
}

@end
