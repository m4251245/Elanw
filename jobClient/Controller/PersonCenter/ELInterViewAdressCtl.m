//
//  ELInterViewAdressCtl.m
//  jobClient
//
//  Created by YL1001 on 15/11/17.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELInterViewAdressCtl.h"
#import "ELInterviewAddressCell.h"
#import "ELAspectantDiscuss_Modal.h"
#import "ELRequest.h"
#import "Status_DataModal.h"
#import "ExRequetCon.h"

@interface ELInterViewAdressCtl ()
{
    ELAspectantDiscuss_Modal *aspDataModal;
//    NSMutableArray *dataArray;
    
    NSString *regionId;
    IBOutlet UIView *bgView;
//    IBOutlet NSLayoutConstraint *_tableViewAutoHeight;
}
@end

@implementation ELInterViewAdressCtl

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        bFooterEgo_ = YES;
        bHeaderEgo_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加地点";
    confirmBtn.layer.cornerRadius = 4.0;
    confirmBtn.layer.masksToBounds = YES;
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    aspDataModal = dataModal;
}

- (void)getDataFunction:(RequestCon *)con
{
    [con getExpertRegionList:aspDataModal.dis_personId page:con.pageInfo_.currentPage_ pageSize:5];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetExpertRegionList:
        {
            [self setLayout];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return requestCon_.dataArr_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"ELInterviewAddressCell";
    ELInterviewAddressCell *cell = (ELInterviewAddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ELInterviewAddressCell" owner:self options:nil] lastObject];
    }
    
    ELAspectantDiscuss_Modal *modal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    cell.addressLb.text = modal.region;
    
    [cell.delectBtn addTarget:self action:@selector(delectRegion:) forControlEvents:UIControlEventTouchUpInside];
    cell.delectBtn.tag = 10 + indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    ELAspectantDiscuss_Modal *modal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
    addressTF.text = modal.region;
    regionId = modal.ydrId;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [addressTF resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [addressTF resignFirstResponder];
    }
    
    return YES;
}

/**
 * 删除地区
 * @param $hangjia_id  integer  用户编号
 * @param $ydr_id   integer  地区编号
 返回值：array('status'=> 'OK','code'=> 200,'status_desc'=> '删除成功！',);
 **/
- (void)delectRegion:(UIButton *)sender
{
    ELAspectantDiscuss_Modal *modal = [requestCon_.dataArr_ objectAtIndex:sender.tag - 10];
    
    NSString *op = @"yl_daoshi_region_busi";
    NSString *func = @"deleteMyRegion";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&ydr_id=%@",aspDataModal.dis_personId,modal.ydrId];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:func requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal *modal = [[Status_DataModal alloc] init];
        modal.status_ = result[@"status"];
        modal.code_ = result[@"code"];
        modal.status_desc = result[@"status_desc"];
        if ([modal.code_ isEqualToString:@"200"]) {
            [BaseUIViewController showAutoDismissSucessView:nil msg:modal.status_desc];
        }
        else
        {
            [BaseUIViewController showAutoDismissFailView:nil msg:modal.status_desc];
        }
        [self refreshLoad:nil];

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)btnResponse:(id)sender
{
    if (sender == confirmBtn) {
        if ([addressTF.text isEqualToString:@""]) {
            [BaseUIViewController showAutoDismissFailView:nil msg:@"请填写地址"];
        }
        else
        {
            [self addExpertRegion];
        }
    }
}

- (void)setLayout
{
    
    CGRect frame = tableView_.frame;
//    _tableViewAutoHeight.constant = requestCon_.dataArr_.count * 30;
    frame.size.height = requestCon_.dataArr_.count * 30;
    tableView_.frame = frame;
    
    frame = bgView.frame;
    frame.origin.y = CGRectGetMaxY(tableView_.frame) + 5;
    bgView.frame = frame;
}

/**
 * 行家添加自己的常用地址
 * @param integer $hangjia_id   行家用户ID
 * @param string  $region   常用地点
 * @param array  $conditionArr  外部条件
 * @return array  {"status":"OK","info":{"ydr_id":"3731446464249835"}}
 */
- (void)addExpertRegion
{
    NSString *op = @"yl_daoshi_region_busi";
    NSString *function= @"addMyRegion";
    
    NSString *bodyMsg = [NSString stringWithFormat:@"hangjia_id=%@&region=%@&conditionArr=%@", aspDataModal.dis_personId, addressTF.text, nil];
    
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result){
        
        regionId = result[@"info"][@"ydr_id"];
        
        [_delegate addInterviewAddressWithRegionName:addressTF.text regionId:regionId];
        [self.navigationController popViewControllerAnimated:YES];
        
    }failure:^(NSURLSessionDataTask *operation, NSError *error){
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
