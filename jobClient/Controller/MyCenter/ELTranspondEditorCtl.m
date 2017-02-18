//
//  ELTranspondEditorCtl.m
//  jobClient
//
//  Created by 一览iOS on 2017/1/19.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELTranspondEditorCtl.h"
#import "CompanyOtherHR_DataModal.h"

@interface ELTranspondEditorCtl ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *tableView_;
    NSMutableArray *listArr;
    UITextField *nameTF;
    UITextField *emailTF;
    NSIndexPath *selectIndexPath;
}
@end

@implementation ELTranspondEditorCtl

-(instancetype)init{
    self = [super init];
    if (self) {
        rightNavBarStr_ = @"确定";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isEditor) {
        [self setNavTitle:@"编辑评审人"];
    }else{
        [self setNavTitle:@"添加评审人"];
    }
    [self creatUI];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
}

-(void)creatUI{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-1,-1,ScreenWidth+2,97)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = UIColorFromRGB(0xe0e0e0).CGColor;
    view.layer.borderWidth = 1.0;
    view.layer.masksToBounds = YES;
    
    ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"姓名：" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,24);
    [view addSubview:label];
    
    label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"邮箱：" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,0,200,0)];
    [label sizeToFit];
    label.frame = CGRectMake(16,0,label.width+3,label.height);
    label.center = CGPointMake(label.center.x,72);
    [view addSubview:label];
    
    ELLineView *line = [[ELLineView alloc] initWithFrame:CGRectMake(16,48,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
    [view addSubview:line];
    
    nameTF = [[UITextField alloc] initWithFrame:CGRectMake(80,14,ScreenWidth-90,20)];
    nameTF.placeholder = @"请输入姓名";
    nameTF.delegate = self;
    nameTF.font = [UIFont systemFontOfSize:16];
    //[nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:nameTF];
    
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(80,62,ScreenWidth-90,20)];
    emailTF.placeholder = @"请输入电子邮箱";
    emailTF.delegate = self;
    emailTF.font = [UIFont systemFontOfSize:16];
    //[emailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:emailTF];
    
    [self.view addSubview:view];
    
    if (_isEditor){
        nameTF.text = _name;
        emailTF.text = _email;
        ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"删除" textColor:UIColorFromRGB(0xe13e3e) Target:self action:@selector(deleteBtnRespone:) frame:CGRectMake(-1,106,ScreenWidth+2,48)];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setBorderWidth:1.0 borderColor:UIColorFromRGB(0xe0e0e0)];
        [self.view addSubview:label];
    }else{
        NSString *key = [NSString stringWithFormat:@"%@%@",[Manager getUserInfo].userId_,[Manager getUserInfo].companyModal_.companyID_];
        NSArray *arr = getUserDefaults(key);
        if (arr) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,96,ScreenWidth,ScreenHeight-64-96) style:UITableViewStylePlain];
            tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.bounces = NO;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            [self.view addSubview:tableView];
            tableView_ = tableView;
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,35)];
            headView.backgroundColor = UIColorFromRGB(0xf5f5f5);
            
            ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"历史记录" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,15,100,15)];
            [headView addSubview:label];
            
            tableView_.tableHeaderView = headView;
            
            listArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in arr) {
                CompanyOtherHR_DataModal *modal = [[CompanyOtherHR_DataModal alloc] init];
                modal.name_ = dic[@"name"];
                modal.contactEmail_ = dic[@"email"];
                for (CompanyOtherHR_DataModal *modalOne in _selectArr) {
                    if ([modal.name_ isEqualToString:modalOne.name_] && [modalOne.contactEmail_ isEqualToString:modal.contactEmail_]) {
                        modal.bSelected_ = YES;
                        modal.bChoosed_ = YES;
                        break;
                    }
                }
                [listArr addObject:modal];
            }
            [tableView_ reloadData];
        }
    }
}

/*
-(void)textFieldDidChange:(UITextField *)textField{
    CGFloat startY = 0; 
    if (textField == nameTF) {
        startY = 48;
    }else{
        startY = 96;
    }
    NSString *content = [MyCommon removeAllSpace:textField.text];
    if (content.length > 0) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if (textField == nameTF) {
            for (CompanyOtherHR_DataModal *modal in _dataArr_) {
                if ([modal.name_ containsString:content]) {
                    [arr addObject:modal];
                }
            }
        }else{
            for (CompanyOtherHR_DataModal *modal in _dataArr_){
                if ([modal.contactEmail_ containsString:content]) {
                    [arr addObject:modal];
                }
            }
        }
        if (arr.count > 0){
            tableView_.frame = CGRectMake(0,startY,ScreenWidth,ScreenHeight-64-startY);
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                listArr = arr;
                [tableView_ reloadData];
                tableView_.contentOffset = CGPointZero;
                tableView_.hidden = NO;
            });
        }else{
            tableView_.hidden = YES;
        }
    }else{
        tableView_.hidden = YES;
    }
}
*/

//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [nameTF resignFirstResponder];
//    [emailTF resignFirstResponder];
//}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    //[self textFieldDidChange:textField];
//    return YES;
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}

-(void)deleteBtnRespone:(UITapGestureRecognizer *)sender{
    if (_block) {
        _block(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarBtnResponse:(id)sender{
   
    NSString *name = [MyCommon removeAllSpace:nameTF.text];
    NSString *email = [MyCommon removeAllSpace:emailTF.text];
    if (_isEditor) {
        if (![self editorFinish:name email:email]) {
            return;
        }
    }else{
        NSMutableArray *selectArr = [[NSMutableArray alloc] init];
        for (CompanyOtherHR_DataModal *modal in listArr) {
            if (modal.bChoosed_ && !modal.bSelected_) {
                [selectArr addObject:modal];
            }
        }
        
        if (selectArr.count > 0){
            if (name.length > 0 || email.length > 0) {
                if (![self editorFinish:name email:email]) {
                    return;
                }
            }
            if (_block) {
                _block(selectArr);
            }
        }else{
            if (![self editorFinish:name email:email]) {
                return;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)editorFinish:(NSString *)name email:(NSString *)email{
    if (name.length <= 0) {
        [BaseUIViewController showAlertView:nil msg:@"请填写姓名" btnTitle:@"确定"];
        return NO;
    }
    if (email.length <= 0) {
        [BaseUIViewController showAlertView:nil msg:@"请填写邮箱" btnTitle:@"确定"];
        return NO;
    }
    if (![MyCommon isValidateEmail:email]) {
        [BaseUIViewController showAlertView:nil msg:@"请填写正确的邮箱" btnTitle:@"确定"];
        return NO;
    }
    if (_selectArr){
        if (_isEditor && [_email isEqualToString:email] && [_name isEqualToString:name]){
            return YES;
        }
        for (CompanyOtherHR_DataModal *modal in _selectArr) {
            if ([modal.name_ isEqualToString:name] && [modal.contactEmail_ isEqualToString:email]) {
                [BaseUIViewController showAlertView:nil msg:@"当前输入的评审人信息已存在" btnTitle:@"确定"];
                return NO;
            }
        }
    }
    
    if (_block){
        CompanyOtherHR_DataModal * dataModal = [[CompanyOtherHR_DataModal alloc] init];
        dataModal.name_ = name;
        dataModal.contactEmail_ = email;
        _block(dataModal);
        
        if (!_isEditor) {
            NSString *key = [NSString stringWithFormat:@"%@%@",[Manager getUserInfo].userId_,[Manager getUserInfo].companyModal_.companyID_];
            NSArray *arr = getUserDefaults(key);
            NSMutableArray *arrOne;
            if (arr){
                arrOne = [[NSMutableArray alloc] initWithArray:arr];
            }else{
                arrOne = [[NSMutableArray alloc] init];
            }
            if (arrOne.count >= 3) {
                [arrOne removeObjectAtIndex:0];
            }
            [arrOne addObject:@{@"name":name,@"email":email}];
            kUserDefaults(arrOne,key);
            kUserSynchronize;
        }
    }
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArr.count;
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
        
        ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(53,12,ScreenWidth-116,18)];
        label.tag = 13;
        [cell.contentView addSubview:label];
        
        label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"" textColor:UIColorFromRGB(0x757575) Target:nil action:nil frame:CGRectMake(53,34,ScreenWidth-116,16)];
        label.tag = 14;
        [cell.contentView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(16,18,24,24)];
        image.image = [UIImage imageNamed:@"list_cell_normal"];
        image.tag = 15;
        [cell.contentView addSubview:image];
        
        ELBaseButton *button = [ELBaseButton getNewButtonWithNormalImageName:@"ic_trasresume_edit" selectImgName:@"ic_trasresume_edit" Target:self action:@selector(editorBtnRespone:) frame:CGRectMake(ScreenWidth-50,8,44,44)];
        button.tag = 16;
        [cell.contentView addSubview:button];
    }
    ELLineView *topLine = (ELLineView *)[cell.contentView viewWithTag:11];
    ELLineView *bottomLine = (ELLineView *)[cell.contentView viewWithTag:12];
    ELBaseLabel *usernameLb = (ELBaseLabel *)[cell.contentView viewWithTag:13];
    ELBaseLabel *emailLb = (ELBaseLabel *)[cell.contentView viewWithTag:14];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:15];
    ELBaseButton *editorBtn = (ELBaseButton *)[cell.contentView viewWithTag:16];
    
    CompanyOtherHR_DataModal * dataModal = [listArr objectAtIndex:indexPath.row];
    editorBtn.indexPathRow = indexPath.row;
    if (indexPath.row == 0){
        topLine.frame = CGRectMake(0,0,ScreenWidth,1);
    }else{
        topLine.frame = CGRectMake(16,0,ScreenWidth,1);
    }
    if (indexPath.row == listArr.count-1){
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

-(void)editorBtnRespone:(ELBaseButton *)button{
    if (button.indexPathRow >= 0 && button.indexPathRow <listArr.count) {
        CompanyOtherHR_DataModal * dataModal = listArr[button.indexPathRow];
        ELTranspondEditorCtl *ctl = [[ELTranspondEditorCtl alloc] init];
        ctl.isEditor = YES;
        ctl.name = dataModal.name_;
        ctl.email = dataModal.contactEmail_;
        ctl.selectArr = _selectArr;
        selectIndexPath = [NSIndexPath indexPathForRow:button.indexPathRow inSection:0];
        __weak ELTranspondEditorCtl *emailCtl = self;
        ctl.block = ^(id dataModal){
            [emailCtl editorSuccessReloadWithModal:dataModal];
        };
        [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
    }
}
#pragma mark - 编辑成功回调
-(void)editorSuccessReloadWithModal:(id)dataModal{
    
     NSString *key = [NSString stringWithFormat:@"%@%@",[Manager getUserInfo].userId_,[Manager getUserInfo].companyModal_.companyID_];
    
    if (!dataModal) {
        //modal为nil是表示删除
        if (selectIndexPath.row < listArr.count){
            CompanyOtherHR_DataModal * dataModal = listArr[selectIndexPath.row];
            dataModal.bChoosed_ = NO;
            dataModal.bSelected_ = NO;
            [listArr removeObjectAtIndex:selectIndexPath.row];
            [tableView_ reloadData];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (CompanyOtherHR_DataModal *modal in listArr) {
                [arr addObject:@{@"name":modal.name_,@"email":modal.contactEmail_}];
            }
            kUserDefaults(arr,key);
            kUserSynchronize;
        }
        return;
    }
    if (selectIndexPath.row < listArr.count){
        CompanyOtherHR_DataModal *oldModel = listArr[selectIndexPath.row];
        CompanyOtherHR_DataModal *newModel = dataModal;
        if ([newModel.name_ isEqualToString:oldModel.name_] && [newModel.contactEmail_ isEqualToString:oldModel.contactEmail_]) {
            
        }else{
            BOOL isSelect = NO;
            for (CompanyOtherHR_DataModal *modal in _selectArr) {
                if ([newModel.name_ isEqualToString:modal.name_] && [newModel.contactEmail_ isEqualToString:modal.contactEmail_]) {
                    isSelect = YES;
                    break;
                }
            }
            if (isSelect) {
                newModel.bSelected_ = YES;
                newModel.bChoosed_ = YES;
            }else{
                newModel.bChoosed_ = oldModel.bChoosed_;
                newModel.bSelected_ = NO; 
            }
            [listArr replaceObjectAtIndex:selectIndexPath.row withObject:newModel];
            [tableView_ reloadData];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (CompanyOtherHR_DataModal *modal in listArr) {
                [arr addObject:@{@"name":modal.name_,@"email":modal.contactEmail_}];
            }
            kUserDefaults(arr,key);
            kUserSynchronize;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompanyOtherHR_DataModal * dataModal = listArr[indexPath.row];
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


@end
