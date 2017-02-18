//
//  EditorBasePersonInfoCtl.m
//  jobClient
//
//  Created by 一览iOS on 14-11-3.
//  Copyright (c) 2014年 YL1001. All rights reserved.
//

#import "EditorBasePersonInfoCtl.h"
#import "CommonConfig.h"
#import "EditorPersonInfo.h"
#import "EditorManifestoCtl.h"
#import "ELTradeChangeCtl.h"
#import "CustomTagButton.h"
#import "ELBeGoodAtTradeChangeCtl.h"
#import "personTagModel.h"
#import "FBRegionCtl.h"

@interface EditorBasePersonInfoCtl () <EditorTradeDelegate,BeGoodAtChangeDelegate,UIActionSheetDelegate,ChooseHotCityDelegate,CondictionChooseDelegate>
{
    RequestCon *updateTagsCon_;
    NSArray *arrTagData;
    
    __weak IBOutlet NSLayoutConstraint *_introViewHeight;
    __weak IBOutlet NSLayoutConstraint *_expertIntorViewHeight;
    
    CondictionList_DataModal    *_regionDataModal; //居住地data
    CondictionList_DataModal    *_birthDayDataModal; //出生日期data
    RequestCon  *editCon_;
    
    BOOL hotCity;
    NSString * cityId;

}
@end

@implementation EditorBasePersonInfoCtl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"编辑资料"];
    // Do any additional setup after loading the view from its nib.
    bgView_.layer.cornerRadius = 2.5;
    bgView_.layer.masksToBounds = YES;
    bgView_.layer.borderWidth = 0.5;
    bgView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    introView_.layer.cornerRadius = 2.5;
    introView_.layer.masksToBounds = YES;
    introView_.layer.borderWidth = 0.5;
    introView_.layer.borderColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0].CGColor;
    
}

//设置右按扭的属性
//- (void)setRightBarBtnAtt
//{
//    [rightBarBtn_ setTitle:@"保存" forState:UIControlStateNormal];
//    rightBarBtn_.layer.cornerRadius = 2.0;
//    [rightBarBtn_ setBackgroundColor:[UIColor clearColor]];
//    [rightBarBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBarBtn_ setFrame:CGRectMake(0, 0, 55, 26)];
//    rightBarBtn_.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [rightBarBtn_.titleLabel setFont:FIFTEENFONT_TITLE];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Manager shareMgr].userCenterModel = inModelOne;
    
}

- (void)changSuccess:(NSNotification *)info
{
    [self updateCom:nil];
}

-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    inModelOne = dataModal;
}

- (void)updateCom:(RequestCon *)con
{
    [super updateCom:con];
    if (inModelOne != nil)
    {
        [ageLb_ setText:inModelOne.userModel_.age_];
        [addrLb_ setText:inModelOne.userModel_.cityStr_];
        [workAgeLb_ setText:inModelOne.userModel_.gznum_];
        [zyeLb_ setText:inModelOne.userModel_.job_];
        [jobLb_ setText:inModelOne.userModel_.zw_];
        
        if ([inModelOne.userModel_.tradeName isEqualToString:@"一览"]) {
            [tradeLb_ setText:@""];
            inModelOne.userModel_.tradeName = @"";
        }
        else{
            [tradeLb_ setText:inModelOne.userModel_.tradeName];
        }
        
        [nameLb_ setText:inModelOne.userModel_.iname_];
        [genderLb_ setText:inModelOne.userModel_.sex_];
        
        [introLb_ setText:inModelOne.userModel_.signature_];
        [introLb_ sizeToFit];
        _introViewHeight.constant = introLb_.frame.size.height + 47;
        
        [expertIntroLb_ setText:inModelOne.userModel_.expertIntroduce_];
        [expertIntroLb_ sizeToFit];
        _expertIntorViewHeight.constant = expertIntroLb_.frame.size.height + 47;
        
    }
}

-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_SaveInfo:
        {
//            Status_DataModal * dataModal = [dataArr objectAtIndex:0];
//            if([dataModal.status_ isEqualToString:Success_Status])
//            {
//                if (_birthDayDataModal || _birthDayDataModal != nil) {
//                    NSString *birthdayStr = _birthDayDataModal.str_;
//                    NSDateFormatter *dateMat = [[NSDateFormatter alloc] init];
//                    [dateMat setDateFormat:@"yyyy-MM-dd"];
//                    NSDate *brithDate = [dateMat dateFromString:birthdayStr];
//                    NSTimeInterval dateDiff = [brithDate timeIntervalSinceNow];
//                    int age = trunc(dateDiff/(60*60*24))/365;
//                    inModelOne.userModel_.age_ = [NSString stringWithFormat:@"%d",-age];
//                    inModelOne.userModel_.bday_ = birthdayStr;
//                }
//                
//                if (genderLb_.text != nil) {
//                    inModelOne.userModel_.sex_ = genderLb_.text;
//                }
//                
//                if (_regionDataModal || _regionDataModal != nil) {
//                    inModelOne.userModel_.cityStr_ = [CondictionPlaceCtl getRegionDetailAddress:_regionDataModal.id_];
//                }
//                
//                [self editorSuccess];
//                [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
//            }
//            else{
//                [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:@"请稍后再试"];
//            }
        }
            break;
        default:
            break;
    }
}

- (void)btnResponse:(id)sender
{
    if (sender == introBtn_)
    {
        EditorManifestoCtl *manifestoCtl = [[EditorManifestoCtl alloc]init];
        manifestoCtl.type = @"1";   //职业宣言
        manifestoCtl.block = ^(){
#pragma mark 职业宣言编辑成功回调
            [self updateCom:nil];
            [_delegate edtorBaseSuccess];
        };
        
        [manifestoCtl beginLoad:inModelOne exParam:nil];
        [self.navigationController pushViewController:manifestoCtl animated:YES];
        return;
    }
    else if (sender == expertIntroBtn_)
    {
        EditorManifestoCtl *manifestoCtl = [[EditorManifestoCtl alloc]init];
        manifestoCtl.type = @"2";   //个人简介
        manifestoCtl.block = ^(){
            [self updateCom:nil];
            [_delegate edtorBaseSuccess];
        };
        
        [manifestoCtl beginLoad:inModelOne exParam:nil];
        [self.navigationController pushViewController:manifestoCtl animated:YES];
        return;
    }
    
    EditorPersonInfo *editorCtl = [[EditorPersonInfo alloc] init];
    
    if (sender == nameBtn_)
    {
        //姓名
        editorCtl.editorType = name_type;
    }
    else if (sender == ageBtn_)
    {
        //年龄
        preCondictionListCtl.delegate_ = self;
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = nil;
        if ([ageLb_.text isEqualToString:@"请选择出生年月"] || [ageLb_.text isEqualToString:@""]) {
            date = [formater dateFromString:@"1980-01-01"];
        }else{
            date = [formater dateFromString:ageLb_.text];
        }
        [preCondictionListCtl beginGetData:date exParam:nil type:GetBirthDayDateType];
        return;
        
//        editorCtl.editorType = age_type;
    }
    else if (sender == gznumBtn_)
    {
        //工作年限
        editorCtl.editorType = workage_type;
    }
    else if (sender == workAddrBtn_)
    {
        //现工作地
        
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
        ctl.isModify = YES;
        ctl.showQuanGuo = YES;
        ctl.showLocation = YES;
        if (addrLb_.text.length > 0 && ![addrLb_.text isEqualToString:ChooseResume_Null_DefaultValue]) {
            ctl.selectName = addrLb_.text;
            if (!(cityId.length > 0)) {
                NSArray *nameArr = [inModelOne.userModel_.cityStr_ componentsSeparatedByString:@"-"];
                ctl.selectId = [CondictionPlaceCtl getRegionId:nameArr.lastObject];
            }
            else{
                ctl.selectId = cityId;
            }
            ctl.selectHotCity = hotCity;
        }
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
            addrLb_.text = [CondictionPlaceCtl getRegionDetailAddress:regionId];
            cityId = regionId;
            hotCity = selectHotCity;
            inModelOne.userModel_.cityStr_ = addrLb_.text;
            [_delegate edtorBaseSuccess];
        };
        [self.navigationController pushViewController:ctl animated:YES];
        return;
        
//        if (![Manager shareMgr].regionListCtl_) {
//            [Manager shareMgr].regionListCtl_ = [[RegionCtl alloc] init];
//        }
//        [self.navigationController pushViewController:[Manager shareMgr].regionListCtl_ animated:YES];
//        [[Manager shareMgr].regionListCtl_ beginLoad:nil exParam:nil];
//        [Manager shareMgr].regionListCtl_.delegate_ = self;
//        return;
        
//        editorCtl.editorType = workAddr_type;
    }
    else if (sender == tradeBtn_)
    {
        //所属行业
        editorCtl.editorType = trade_type;
        ELTradeChangeCtl *ctl = [[ELTradeChangeCtl alloc] init];
        ctl.delegate = self;
        [self.navigationController pushViewController:ctl animated:YES];
        [ctl beginLoad:inModelOne.userModel_ exParam:nil];
        return;
    }
    else if (sender == jobBtn_)
    {
        //职业
        editorCtl.editorType = zhiye_type;
    }
    else if (sender == zwBtn_)
    {
        //头衔
        editorCtl.editorType = touxian_type;
    }
    else if (sender == genderBtn_)
    {
        //选择性别
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
        return;
        
//      editorCtl.editorType = gender_type;
    }
    
    [editorCtl beginLoad:inModelOne exParam:nil];
    editorCtl.delegate = self;
    [self.navigationController pushViewController:editorCtl animated:YES];
}


#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        genderLb_.text = @"男";
    }
    else if (buttonIndex == 1)
    {
        genderLb_.text = @"女";
    }
    
    [self savePersonInfoWithSex:genderLb_.text regionStr:nil brithday:nil];
}

#pragma mark 工作地址回调
-(void) chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = city;
    dataModal.id_ = [CondictionPlaceCtl getRegionId:city];
    _regionDataModal = dataModal;
    //地区
    if( _regionDataModal || _regionDataModal != nil )
    {
        NSString *str = [CondictionPlaceCtl getRegionDetailAddress:_regionDataModal.id_];
        addrLb_.text = str;
    }
    
    [self savePersonInfoWithSex:nil regionStr:[MyCommon removeAllSpace:_regionDataModal.id_] brithday:nil];
}

#pragma mark  出生年月回调
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetBirthDayDateType:
        {
            _birthDayDataModal = dataModal;
            //出生日期
            if(_birthDayDataModal || _birthDayDataModal != nil )
            {
                NSString *birthdayStr = _birthDayDataModal.str_;
                NSDateFormatter *dateMat = [[NSDateFormatter alloc] init];
                [dateMat setDateFormat:@"yyyy-MM-dd"];
                NSDate *brithDate = [dateMat dateFromString:birthdayStr];
                NSTimeInterval dateDiff = [brithDate timeIntervalSinceNow];
//                int age = trunc(dateDiff/(60*60*24))/365;
                double age = dateDiff/(60*60*24)/365;
                
                if (age >= 0) {
                    [BaseUIViewController showAutoDismissFailView:nil msg:@"请选择正确的时间"];
                    return;
                }                
                NSInteger ageNum = (int)-age;
                ageLb_.text = [NSString stringWithFormat:@"%ld", (long)ageNum];
                
                [self savePersonInfoWithSex:nil regionStr:nil brithday:[MyCommon removeAllSpace:_birthDayDataModal.str_]];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 保存更改信息
- (void)savePersonInfoWithSex:(NSString *)sex
                    regionStr:(NSString *)regionStr
                     brithday:(NSString *)brithday
{
    NSMutableDictionary * updateDic = [[NSMutableDictionary alloc] init];
    
    [updateDic setObject:[Manager getUserInfo].userId_ forKey:@"person_id"];
    if (sex !=nil && ![sex isEqualToString:@""]) {
        [updateDic setObject:sex forKey:@"person_sex"];
    }
    if (regionStr !=nil && ![regionStr isEqualToString:@""]) {
        [updateDic setObject:regionStr forKey:@"regionid"];
    }
    if (brithday !=nil && ![brithday isEqualToString:@""]) {
        [updateDic setObject:brithday forKey:@"bday"];
    }
    
    SBJsonWriter *jsonWriter2 = [[SBJsonWriter alloc] init];
    NSString *updateStr = [jsonWriter2 stringWithObject:updateDic];
    NSString *bodyMsg = [NSString stringWithFormat:@"data=%@",updateStr];
    
    
    [ELRequest postbodyMsg:bodyMsg op:@"person_info_api" func:@"edit_card" requestVersion:NO success:^(NSURLSessionDataTask *operation, id result) {
        
        Status_DataModal * dataModal = [[Status_DataModal alloc] init];
        NSString * str = [result objectForKey:@"status"];
        NSString *upperStr = [str uppercaseString];
        dataModal.status_ = upperStr;
        dataModal.des_ = [result objectForKey:@"status_desc"];
        
        if([dataModal.status_ isEqualToString:Success_Status])
        {
            if (_birthDayDataModal || _birthDayDataModal != nil) {
                NSString *birthdayStr = _birthDayDataModal.str_;
                NSDateFormatter *dateMat = [[NSDateFormatter alloc] init];
                [dateMat setDateFormat:@"yyyy-MM-dd"];
                NSDate *brithDate = [dateMat dateFromString:birthdayStr];
                NSTimeInterval dateDiff = [brithDate timeIntervalSinceNow];
                int age = trunc(dateDiff/(60*60*24))/365;
                inModelOne.userModel_.age_ = [NSString stringWithFormat:@"%d",-age];
                inModelOne.userModel_.bday_ = birthdayStr;
            }
            
            if (genderLb_.text != nil) {
                inModelOne.userModel_.sex_ = genderLb_.text;
            }
            
            if (_regionDataModal || _regionDataModal != nil) {
                inModelOne.userModel_.cityStr_ = [CondictionPlaceCtl getRegionDetailAddress:_regionDataModal.id_];
            }
            
            [self editorSuccess];
//            [BaseUIViewController showAutoDismissSucessView:@"修改成功" msg:nil];
        }
        else{
            [BaseUIViewController showAutoDismissFailView:@"修改失败" msg:@"请稍后再试"];
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - 更编辑成功回调
- (void)editorSuccess
{
    [self updateCom:nil];
    [_delegate edtorBaseSuccess];
    //刷新侧边栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
}

-(void)editorSuccessWithTradeName:(NSString *)tradeName tradeId:(NSString *)tradeId
{
    inModelOne.userModel_.tradeName = tradeName;
    inModelOne.userModel_.tradeId = tradeId;
    tradeLb_.text = tradeName;
    [_delegate edtorBaseSuccess];
    //刷新侧边栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil];
}

#pragma Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
