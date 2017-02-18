//
//  ELResumeTypeChangeCtl.m
//  jobClient
//
//  Created by 一览iOS on 2017/2/3.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELResumeTypeChangeCtl.h"
#import "InterviewModel_DataModal.h"

@interface ELResumeTypeChangeCtl ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *_dataArr;
    UITextField *textF;
    NSString *alertStr;
}
@end

@implementation ELResumeTypeChangeCtl

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    switch (_changeType) {
        case PlaceType:
        {
            [self setNavTitle:@"面试地点"];
            alertStr = @"面试地点";
            [self creatEditorViewWithType:PlaceType];
        }
            break;
        case PeopleType:
        {
            [self setNavTitle:@"联系人"];
            alertStr = @"联系人";
            [self creatEditorViewWithType:PeopleType];
        }
            break;
        case PhoneType:
        {
            [self setNavTitle:@"联系电话"];
            alertStr = @"联系电话";
            [self creatEditorViewWithType:PhoneType];
        }
            break;
        case JobType:
        {
            bFooterEgo_ = NO;
            bHeaderEgo_ = NO;
            [self creatTableView];
            [self setNavTitle:@"选择应聘岗位"];
            [self requestRctdData];
        }
            break;
        case TemplateType:
        {
            bFooterEgo_ = YES;
            bHeaderEgo_ = YES;
            [self creatTableView];
            [self setNavTitle:@"面试模板"];
        }
            break;
        default:
            break;
    }
   
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (textF) {
        [textF becomeFirstResponder];
    }
}

-(void)rightBarBtnResponse:(id)sender{
    NSString *str = [textF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str isEqualToString:@""]) {
        [BaseUIViewController showAlertView:nil msg:[NSString stringWithFormat:@"请填写%@",alertStr] btnTitle:@"确定"];
        return;
    }
    if (_changeType == PhoneType) {
        if (![str isMobileNumValid] && ![str checkNumber]) {
            [BaseUIViewController showAlertView:nil msg:@"输入的联系电话有误" btnTitle:@"确定"];
            return;
        }
    }
    if (_block){
        [textF resignFirstResponder];
        _block(str);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)creatEditorViewWithType:(CompanyMessageChangeType)type{
    rightNavBarStr_ = @"确定";
    UIView *editorView = [[UIView alloc] initWithFrame:CGRectMake(0,16,ScreenWidth,48)];
    editorView.backgroundColor = [UIColor whiteColor];
    
    textF = [[UITextField alloc] initWithFrame:CGRectMake(16,9,ScreenWidth-32,30)];
    textF.delegate = self;
    textF.font = [UIFont systemFontOfSize:16];
    textF.textColor = UIColorFromRGB(0x333333);
    [textF addTarget:self action:@selector(TextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [editorView addSubview:textF];
    
    if (_editorContent && ![_editorContent isEqualToString:@""]) {
        textF.text = _editorContent;
    }
    
    [self.view addSubview:editorView];
    
    switch (type) {
        case PlaceType:
        {
            
        }
            break;
        case PeopleType:
        {
         
        }
            break;
        case PhoneType:
        {
            textF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
            break;
        default:
            break;
    }
}

-(void)creatTableView{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [tableView reloadData];
    
    tableView_ = tableView;
}

-(void)requestRctdData
{
    NSMutableDictionary * conditionDic = [[NSMutableDictionary alloc] init];
    [conditionDic setObject:[NSString stringWithFormat:@"%ld",(long)requestCon_.pageInfo_.currentPage_] forKey:@"page_index"];
    [conditionDic setObject:[CommonConfig getDBValueByKey:@"synergy_id"] forKey:@"m_id"];
    [conditionDic setObject:[CommonConfig getDBValueByKey:@"m_dept_id"] forKey:@"m_dept_id"];
    [conditionDic setObject:@"10" forKey:@"page_size"];
    [conditionDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
    NSString * conditionStr = [jsonWriter stringWithObject:conditionDic];
    
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&conditionArr=%@",[Manager getUserInfo].companyModal_.companyID_,conditionStr];
    NSString *function = @"mResumezwList";
    NSString *op = @"company_person_busi";
    
    _dataArr = [[NSMutableArray alloc] init];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            for ( NSMutableDictionary *dict in result)
            {
                CondictionList_DataModal *model = [[CondictionList_DataModal alloc]init];
                model.id_ = [dict objectForKey:@"id"];
                model.str_ = [dict objectForKey:@"jtzw"];
                model.positionMark = [dict objectForKey:@"zptype"];
                if (model.str_.length > 0 && [model.positionMark isEqualToString:@"1"])
                {
                    [_dataArr addObject:model];
                }
                
            }
            [tableView_ reloadData];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    switch (_changeType) {
        case TemplateType:
        {
            [con getInterviewModel:[Manager getUserInfo].companyModal_.companyID_ pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:10];
        }
            break;
        default:
            break;
    }
}
-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
}

- (void)TextFieldDidChange:(UITextField *)textfield
{
    if (textfield == textF){
        NSInteger strLength = 100;
        switch (_changeType) {
            case PlaceType:
            {
                strLength = 50;
            }
                break;
            case PeopleType:
            {
                strLength = 20;
            }
                break;
            case PhoneType:
            {
                
            }
                break;
            default:
                break;
        }
        [MyCommon limitTextFieldTextNumberWithTextField:textF wordsNum:strLength numLb:nil];
    }
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_changeType == TemplateType) {
        return requestCon_.dataArr_.count;
    }
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_changeType == TemplateType) {
        return 90;
    }
    return 48;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompanyOtherHR_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (_changeType == TemplateType) {
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            ELLineView *topLine = [[ELLineView alloc] initWithFrame:CGRectMake(16,89,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
            topLine.tag = 11;
            [cell.contentView addSubview:topLine];
            
            ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,11,ScreenWidth-32,18)];
            label.tag = 13;
            [cell.contentView addSubview:label];
            
            label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,38,ScreenWidth-32,15)];
            label.tag = 14;
            [cell.contentView addSubview:label];
            
            label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:14] title:@"" textColor:UIColorFromRGB(0x9e9e9e) Target:nil action:nil frame:CGRectMake(16,62,ScreenWidth-32,15)];
            label.tag = 15;
            [cell.contentView addSubview:label];
        }

        ELBaseLabel *topLb = (ELBaseLabel *)[cell.contentView viewWithTag:13];
        ELBaseLabel *centerLb = (ELBaseLabel *)[cell.contentView viewWithTag:14];
        ELBaseLabel *bottomLb = (ELBaseLabel *)[cell.contentView viewWithTag:15];
        
        InterviewModel_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];

        topLb.text = dataModal.temlname_;
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:dataModal.pname_];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 丨 " attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xe0e0e0)}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:dataModal.phone_]];
        [centerLb setAttributedText:attStr];
        
        bottomLb.text = dataModal.address_;
        
        return cell;
    }
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ELLineView *topLine = [[ELLineView alloc] initWithFrame:CGRectMake(16,47,ScreenWidth,1) WithColor:UIColorFromRGB(0xe0e0e0)];
        topLine.tag = 11;
        [cell.contentView addSubview:topLine];
        
        ELBaseLabel *label = [ELBaseLabel getNewLabelWithFont:[UIFont systemFontOfSize:16] title:@"" textColor:UIColorFromRGB(0x212121) Target:nil action:nil frame:CGRectMake(16,15,ScreenWidth-32,18)];
        label.tag = 13;
        [cell.contentView addSubview:label];
        
    }
    ELLineView *topLine = (ELLineView *)[cell.contentView viewWithTag:11];
    ELBaseLabel *usernameLb = (ELBaseLabel *)[cell.contentView viewWithTag:13];
    if (indexPath.row == requestCon_.dataArr_.count-1){
        topLine.frame = CGRectMake(0,47,ScreenWidth,1);
    }else{
        topLine.frame = CGRectMake(16,47,ScreenWidth,1);
    }
    CondictionList_DataModal *model = _dataArr[indexPath.row];
    usernameLb.text = model.str_;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_block) {
        if (_changeType == TemplateType){
            InterviewModel_DataModal * dataModal = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
            _block(dataModal);
        }else{
            CondictionList_DataModal *model = _dataArr[indexPath.row];
            _block(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
