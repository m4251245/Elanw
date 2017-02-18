//
//  ELTranspondAddPeopleCtl.m
//  jobClient
//
//  Created by 一览iOS on 2017/1/19.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELTranspondAddPeopleCtl.h"
#import "CompanyOtherHR_DataModal.h"

@interface ELTranspondAddPeopleCtl ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView_;
}
@end

@implementation ELTranspondAddPeopleCtl

-(instancetype)init{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"确定";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"选择同事"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:tableView];
    tableView_ = tableView;
    [self creatHeaderView];
    
    [tableView_ reloadData];
}

-(void)creatHeaderView{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"同事" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,15,label.width+3,label.height);
   
    [headView addSubview:label];
    
    headView.frame = CGRectMake(0,0,ScreenWidth,CGRectGetMaxY(label.frame)+5);
    
    tableView_.tableHeaderView = headView;
}

-(void)addPeople:(UITapGestureRecognizer *)sender{
    
}

-(void)rightBarBtnResponse:(id)sender{
    if (_block) {
        _block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr_.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyOtherHR_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ELLineView *topLine = [[ELLineView alloc] initWithFrame:CGRectMake(16,0,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        topLine.tag = 11;
        [cell.contentView addSubview:topLine];
        
        ELLineView *bottomLine = [[ELLineView alloc] initWithFrame:CGRectMake(0,59,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        bottomLine.tag = 12;
        [cell.contentView addSubview:bottomLine];
        
        ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(53,12,ScreenWidth-66,18)];
        label.tag = 13;
        [cell.contentView addSubview:label];
        
        label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(53,34,ScreenWidth-66,16)];
        label.tag = 14;
        [cell.contentView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(16,18,24,24)];
        image.image = [UIImage imageNamed:@"list_cell_normal"];
        image.tag = 15;
        [cell.contentView addSubview:image];
    }
    ELLineView *topLine = (ELLineView *)[cell.contentView viewWithTag:11];
    ELLineView *bottomLine = (ELLineView *)[cell.contentView viewWithTag:12];
    ELBaseLabel *usernameLb = (ELBaseLabel *)[cell.contentView viewWithTag:13];
    ELBaseLabel *emailLb = (ELBaseLabel *)[cell.contentView viewWithTag:14];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:15];
    
    CompanyOtherHR_DataModal * dataModal = [self.dataArr_ objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0){
        topLine.frame = CGRectMake(0,0,ScreenWidth,1);
    }else{
        topLine.frame = CGRectMake(16,0,ScreenWidth,1);
    }
    if (indexPath.row == self.dataArr_.count-1){
        bottomLine.hidden = NO;
    }else{
        bottomLine.hidden = YES;
    }
    if (dataModal.bChoosed_) {
        if (dataModal.bSelected_) {
            image.image = [UIImage imageNamed:@"checkBox_selected_grey"];
        }else{
           image.image = [UIImage imageNamed:@"list_cell_selected"]; 
        }
    }else{
        image.image = [UIImage imageNamed:@"list_cell_normal"];
    }
    usernameLb.text = dataModal.name_;
    emailLb.text = dataModal.contactEmail_;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyOtherHR_DataModal * dataModal = self.dataArr_[indexPath.row];
    if (dataModal.bChoosed_ && !dataModal.bSelected_){
        dataModal.bChoosed_ = NO;
    }else{
        dataModal.bChoosed_ = YES;
    }
    [tableView_ reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
