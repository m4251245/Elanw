//
//  ChosseInterviewModelCtl.m
//  jobClient
//
//  Created by YL1001 on 14-9-13.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "ChosseInterviewModelCtl.h"
#import "ChooseModelCell.h"

@interface ChosseInterviewModelCtl ()
{
    NSString * companyId_;
}

@end

@implementation ChosseInterviewModelCtl
@synthesize delegate_,type_;

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
    [super viewDidLoad];
    if (type_ == ChooseInterview) {
        [self setNavTitle:@"选择模板"];
    }
    else if (type_ == ChooseZWForInterview){
        [self setNavTitle:@"选择职位"];
    }
    else if (type_ == ChooseZWForScreen){
        [self setNavTitle:@"筛选职位"];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    companyId_ = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if (type_ == ChooseInterview) {
        [con getInterviewModel:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
    }
    else if(type_ == ChooseZWForInterview || type_ == ChooseZWForScreen)
    {
        [con getCompanyZWForUsing:companyId_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
    }
    
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type_ dataArr:dataArr];
    switch (type) {
        case Request_GetCompanyZWForUsing:
        {
            if (type_ == ChooseZWForScreen ) {
                ZWDetail_DataModal * model = [[ZWDetail_DataModal alloc] init];
                model.zwID_ = @"";
                model.regionName_ = @"所有地区";
                model.resumeNewNum_ = [NSString stringWithFormat:@"%ld",(long)[Manager getUserInfo].companyModal_.resumeCnt_];
                model.jtzw_ = @"全部";
                
                [requestCon_.dataArr_ insertObject:model atIndex:0];
            }
        }
            break;
            
        default:
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChooseModelCell";
    
    ChooseModelCell *cell = (ChooseModelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        //cell = [[MainCtl_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseModelCell" owner:self options:nil] lastObject];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if (type_ == ChooseInterview) {
        InterviewModel_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        cell.nameLb_.text = dataModal.temlname_;
        cell.regionLb_.text = dataModal.address_;
    }
    else
    {
        ZWDetail_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
        cell.nameLb_.text = dataModal.jtzw_;
        cell.regionLb_.text = dataModal.regionName_;
        if (ChooseZWForScreen && ![dataModal.jtzw_ isEqualToString:@"全部"]) {
            cell.resumeNumLb_.text = [NSString stringWithFormat:@"%@(未阅%@)",dataModal.resumeNum_,dataModal.resumeNewNum_];
        }
    }
    
    
    return cell;

}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    if (type_ == ChooseInterview) {
        [delegate_ chooseInterviewModel:selectData];
    }
    else
    {
        [delegate_ chooseZw:selectData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}







@end
