//
//  ELCerDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 16/1/16.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELCerDetailCtl.h"
#import "PreCondictionListCtl.h"
#import "ELChangeDateCtl.h"

@interface ELCerDetailCtl () <UITextFieldDelegate,CondictionChooseDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIButton *saveBtn;
    
    __weak IBOutlet UIScrollView *backScrollView;
    
    __weak IBOutlet UITextField *cerNameTextField;
    
    __weak IBOutlet UITextField *cerContentTextField;
    
    __weak IBOutlet UITextField *cerTimeTextField;
    
    ELChangeDateCtl *changeDateCtl;
    
    NSDate *currentDate;
}
@end

@implementation ELCerDetailCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    saveBtn.clipsToBounds = YES;
    saveBtn.layer.cornerRadius = 4.0;
    
    if (self.addOrEditor == 1)
    {
//        self.navigationItem.title = @"添加证书";
        [self setNavTitle:@"添加证书"];
        rightBarBtn_.hidden = YES;
    }
    else if (self.addOrEditor == 2)
    {
//        self.navigationItem.title = @"编辑证书";
        [self setNavTitle:@"编辑证书"];
        rightBarBtn_.hidden = NO;
        
        cerNameTextField.text = _dataModal_.cerName_;
        cerContentTextField.text = _dataModal_.scores_;
        cerTimeTextField.text = [NSString stringWithFormat:@"%@-%@",_dataModal_.year_,_dataModal_.month_];
        
        NSString *endTime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_dataModal_.year_,_dataModal_.month_];
        
        currentDate = [endTime dateFormStringFormat:@"yyyy-MM-dd HH:mm:ss" timeZone:[NSTimeZone localTimeZone]];
    }
    backScrollView.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    backScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    backScrollView.delegate = self;
    
    cerNameTextField.delegate = self;
    cerContentTextField.delegate = self;
    cerTimeTextField.delegate = self;
    backScrollView.userInteractionEnabled = YES;
    [backScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoardOne)]];
    
}

-(void)hideKeyBoardOne
{
    [cerNameTextField resignFirstResponder];
    [cerContentTextField resignFirstResponder];
    [cerTimeTextField resignFirstResponder];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        rightBarItemStr_ = @"删除";
    }
    return self;
}

//检查是否能保存
-(BOOL) checkCanSave
{
    if(cerNameTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"证书名称不能为空"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    if(cerTimeTextField.text.length == 0)
        
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择获取时间"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    return YES;
}


-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case UpdateResume_PersonCer_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"保存成功" seconds:2.0];
                    if (self.addOrEditorBlock) {
                        self.addOrEditorBlock(_dataModal_,@"update");
                    }
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"保存成功" seconds:2.0];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
        case AddResume_PersonCer_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"保存成功" seconds:2.0];
                    
                    _dataModal_.id_ = dataModal.id_;
                    if (self.addOrEditorBlock) {
                        self.addOrEditorBlock(_dataModal_,@"add");
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
        case DelResume_PersonCer_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    [PreBaseUIViewController showAutoLoadingView:indexBtn_.titleLabel.text msg:@"删除成功" seconds:2.0];
                    if (self.addOrEditorBlock)
                    {
                        self.addOrEditorBlock(_dataModal_,@"delete");
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            @catch (NSException *exception) {
                [PreBaseUIViewController showAlertView:@"删除失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
            
        default:
            break;
    }
}

-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetYearMonthDateType:
        {
           cerTimeTextField.text = dataModal.pId_;
        }
            break;
        default:
            break;
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    [super rightBarBtnResponse:sender];
    [self hideKeyBoardOne];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否要删除该证书?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
    alert.tag = 1001;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&cer_id=%@",[Manager getUserInfo].userId_,_dataModal_.id_];
        [BaseUIViewController showLoadView:YES content:@"正在删除" view:nil];
        [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"deleteCer" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
         {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            NSString *strId = result[@"status"];
            if ([strId isEqualToString:@"OK"])
            {
                if (self.addOrEditorBlock)
                {
                    self.addOrEditorBlock(_dataModal_,@"delete");
                }
                [self.navigationController popViewControllerAnimated:YES];
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除成功" seconds:1.0];
            }
            else
            {
                [BaseUIViewController showAutoDismissAlertView:@"" msg:@"删除失败" seconds:1.0];
            }
             
         } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [BaseUIViewController showLoadView:NO content:nil view:nil];
            [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
        }];

    }
}
- (IBAction)saveBtnRespone:(UIButton *)sender
{
    [self hideKeyBoardOne];
    if ([self checkCanSave])
    {
        NSString *cerName_ = cerNameTextField.text;
        NSString *scroes_ = cerContentTextField.text;
        NSString *year = [cerTimeTextField.text substringWithRange:NSMakeRange(0,4)];
        NSString *month = [cerTimeTextField.text substringFromIndex:5];
    
        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        [searchDic setObject:cerName_ forKey:@"CertName"];
        [searchDic setObject:scroes_ forKey:@"Scores"];
        [searchDic setObject:year forKey:@"Years"];
        [searchDic setObject:month forKey:@"Months"];
        [searchDic setObject:@"自定义" forKey:@"CerList"];
        
        if (_addOrEditor == 1)
        {
            [searchDic setObject:[Manager getUserInfo].userId_ forKey:@"uid"];
            
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *searchStr = [jsonWriter stringWithObject:searchDic];
            NSString * bodyMsg = [NSString stringWithFormat:@"cerArr=%@",searchStr];
            
            [BaseUIViewController showLoadView:YES content:@"正在添加" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"addCer" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 NSString *strId = result[@"status"];
                 if ([strId isEqualToString:@"OK"])
                 {
                     if (!_dataModal_)
                     {
                         _dataModal_ = [[CerResume_DataModal alloc] init];
                     }
                     _dataModal_.cerName_ = cerName_;
                     _dataModal_.scores_ = scroes_;
                     _dataModal_.year_ = year;
                     _dataModal_.month_ = month;
                     _dataModal_.id_ =  result[@"cer_id"];
                     if (self.addOrEditorBlock) {
                         self.addOrEditorBlock(_dataModal_,@"add");
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"添加成功" seconds:1.0];
                 }
                 
             } failure:^(NSURLSessionDataTask *operation, NSError *error)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"请检查网络" seconds:1.0];
                }];
        }
        else
        {
            [searchDic setObject:_dataModal_.id_ forKey:@"id"];
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *searchStr = [jsonWriter stringWithObject:searchDic];
            
            NSString * bodyMsg = [NSString stringWithFormat:@"person_id=%@&updateArr=%@",[Manager getUserInfo].userId_,searchStr];
            
            [BaseUIViewController showLoadView:YES content:@"正在修改" view:nil];
            [ELRequest postbodyMsg:bodyMsg op:@"person_sub_busi" func:@"updateMycer" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 NSDictionary *dic = result;
                 NSString *status = dic[@"status"];
                 
                 if ([status isEqualToString:@"OK"])
                 {
                     if (!_dataModal_)
                     {
                         _dataModal_ = [[CerResume_DataModal alloc] init];
                     }
                     _dataModal_.cerName_ = cerName_;
                     _dataModal_.scores_ = scroes_;
                     _dataModal_.year_ = year;
                     _dataModal_.month_ = month;
                     if (self.addOrEditorBlock) {
                         self.addOrEditorBlock(_dataModal_,@"update");
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存成功" seconds:1.0];

                 }
                 else
                 {
                     [BaseUIViewController showAutoDismissAlertView:@"" msg:@"保存失败" seconds:1.0];
                 }
             }
             failure:^(NSURLSessionDataTask *operation, NSError *error)
             {
                 [BaseUIViewController showLoadView:NO content:nil view:nil];
                 [BaseUIViewController showAutoDismissAlertView:@"" msg:@"出错了，请稍后再试" seconds:1.0];
             }];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == cerTimeTextField)
    {
        [self hideKeyBoardOne];
        if (!changeDateCtl)
        {
            changeDateCtl = [[ELChangeDateCtl alloc] init];
        }
        changeDateCtl.showTodayBtn = NO;
        [changeDateCtl showViewCtlCurrentDate:currentDate WithBolck:^(CondictionList_DataModal *dataModal)
         {
             currentDate = dataModal.changeDate;
             cerTimeTextField.text = dataModal.pId_;
         }];
        return NO;
    }
    return YES;
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
