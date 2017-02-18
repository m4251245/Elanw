//
//  PersonInfo_ResumeCtl.m
//  jobClient
//
//  Created by job1001 job1001 on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonInfo_ResumeCtl.h"
#import "BaseResumeCtl.h"
#import "PreCondictionListCtl.h"
#import "PreCommon.h"
#import "PreStatus_DataModal.h"
#import "CommonConfig.h"
#import "BindCtl.h"
#import "PersonCenterDataModel.h"
#import "ELChangeDateCtl.h"
#import "New_PersonDataModel.h"
#import "SalarySelectionViewController.h"
#import "FBRegionCtl.h"

@interface PersonInfo_ResumeCtl()<UIScrollViewDelegate>
{
    EditorPersonInfo *editorCtl;
    PersonCenterDataModel *personCenterModel;
    PersonDetailInfo_DataModal *dataBaseModal;
    
    UITextField *weightF;
    NSDictionary *idTypeDic;
    
    NSString *genderStr;
    NSString *roleStr;
    NSString *jobStatusStr;
    
    ELChangeDateCtl *changeDateCtl;
    NSDictionary *salaArrDic;
    
    BOOL isRegion;//是籍贯
    BOOL hotCity;//热门城市
    NSString *cityId;//城市id
    
    NSString *nowLiveId;//现居住地ID
    
}
@property (weak, nonatomic) IBOutlet UIButton *marryStatus;
@property(nonatomic,retain)NSArray *typeArr;
@end
@implementation PersonInfo_ResumeCtl

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(id) init
{
    self  = [self initWithNibName:PersonInfo_ResumeCtl_Xib_Name bundle:nil];
    

    //初始化性别为'男'
    sexState_ = Boy;
    
    selectImageOn_  = [UIImage imageNamed:@"ico_select_on.png"];
    selectImageOff_ = [UIImage imageNamed:@"ico_select_off.png"];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UIView *view = textField.superview;
    CGRect rect1 = [view convertRect:textField.frame toView:self.view];
    viewTF = view;
    
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64) && showKeyBoard)
    {
        CGFloat height1 = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView_.contentOffset = CGPointMake(0,height1 + scrollView_.contentOffset.y);
    }
}

//设计label、button、textField字号，颜色
- (void)changFontWithLabel:(UILabel *)label_ button:(UIButton *)button_ textField:(UITextField *)textField_
{
    if (label_ !=nil) {
        [label_ setFont:FOURTEENFONT_CONTENT];
        //[label_ setTextColor:BLACKCOLOR];
        [label_ setTextColor:UIColorFromRGB(0x888888)];
    }
    if (button_ !=nil) {
        [button_.titleLabel setFont:FOURTEENFONT_CONTENT];
       // [button_ setTitleColor:BLACKCOLOR forState:UIControlStateNormal];
        [button_ setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    if (textField_ != nil) {
        [textField_ setFont:FOURTEENFONT_CONTENT];
        //[textField_ setTextColor:BLACKCOLOR];
        [textField_ setTextColor:UIColorFromRGB(0x333333)];
    }
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = PersonInfo_ResumeCtl_Title;
    [self setNavTitle:PersonInfo_ResumeCtl_Title];
//    //暂时隐藏目前年薪，接口未出
//    salaryView.hidden = NO;
    _typeArr = @[@"1",@"2",@"3",@"4",@"12",@"5",@"6",@"7",@"13",@"8",@"9",@"10",@"11"];
    idTypeDic= @{@"大陆身份证":@"0",@"香港身份证":@"3",@"澳门身份证":@"4",@"台湾身份证":@"5",@"台胞证":@"6",@"国外证件":@"7"};
    salaArrDic = @{@"1":@"￥1万以下",@"2":@"￥1-2万",@"3":@"￥2-3万",@"4":@"￥3-4万",@"12":@"￥4-5万",@"5":@"￥5-6万",@"6":@"￥6-8万",@"7":@"￥8-10万",@"13":@"￥10-15万",@"8":@"￥15-30万",@"9":@"￥30-50万",@"10":@"￥50-100万",@"11":@"￥100万以上"};
    
    [saveBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn_.titleLabel.font = [UIFont systemFontOfSize:15];
    
    saveBtn_.layer.cornerRadius = 3;
    saveBtn_.layer.masksToBounds = YES;

    //更改性别按扭状态
    [self changeSexBtnStatus];
    
    //设置相关代理
    nameTf_.delegate = self;
    yearTf_.delegate = self;
    cellPhoneTf_.delegate = self;
    emailTf_.delegate = self;
    idNumField.delegate = self;
    heightField.delegate = self;
    weightField.delegate = self;
    
    personCenterModel = [[PersonCenterDataModel alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gest:)];
    [self.view addGestureRecognizer:tap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];

    [self updateComInfo:nil];
    [self loadData];
}

-(void)loadData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"sendPhoneNumber" object:nil];
    if (_personVO.marry.length > 0) {
        [marryBtn_ setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
}

-(void)notify:(NSNotification *)notify{
    NSNumber *num = notify.object;
    NSInteger idx = [num integerValue];
    if (idx == 1) {
        NSString *phone = notify.userInfo[@"phone"];
        cellPhoneTf_.text = phone;
    }
    else if (idx == 2){
        NSString *email = notify.userInfo[@"email"];
        emailTf_.text = email;
    }
}

#pragma mark - 重写键盘显示、隐藏
-(void)keyBoardShow:(NSNotification *)notification
{
    showKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboarfHeight = keyboardRect.size.height;
    
    CGRect rect1 = [viewTF convertRect:weightField.frame toView:self.view];
    if (CGRectGetMaxY(rect1) > ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64))
    {
        CGFloat height1 = (CGRectGetMaxY(rect1) - ([UIScreen mainScreen].bounds.size.height - keyboarfHeight - 64));
        scrollView_.contentOffset = CGPointMake(0,height1 + scrollView_.contentOffset.y);
    }
    scrollView_.contentInset = UIEdgeInsetsMake(0,0,keyboarfHeight,0);
}

-(void)keyBoardHide:(NSNotification *)notification
{
    showKeyBoard = NO;
    scrollView_.contentInset = UIEdgeInsetsZero;
}

//释放UITextField
-(void)gest:(UIGestureRecognizer *)sender
{
    [nameTf_ resignFirstResponder];
    [yearTf_ resignFirstResponder];
    [emailTf_ resignFirstResponder];
    [cellPhoneTf_ resignFirstResponder];
    [idNumField resignFirstResponder];
    [heightField resignFirstResponder];
    [weightField resignFirstResponder];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//更改性别按扭状态
-(void) changeSexBtnStatus
{
    switch ( sexState_ ) {
        case Boy:
        {
            [boyBtn_ setImage:selectImageOn_    forState:UIControlStateNormal];
            [girlBtn_ setImage:selectImageOff_  forState:UIControlStateNormal];
        }
            break;
        case Girl:
        {
            [boyBtn_ setImage:selectImageOff_   forState:UIControlStateNormal];
            [girlBtn_ setImage:selectImageOn_   forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

//不用加载
-(void) getDataFunction
{
    loadStats_ = FinishLoad;
}

//让有焦点的控件失去焦点
-(void) comResignFirstResponse
{
    [super comResignFirstResponse];
    if ([nameTf_ isFirstResponder]) {
        [nameTf_ resignFirstResponder];
    }
    if ([yearTf_ isFirstResponder]) {
        [yearTf_ resignFirstResponder];
    }
    if ([cellPhoneTf_ isFirstResponder]) {
        [cellPhoneTf_ resignFirstResponder];
    }
    if ([emailTf_ isFirstResponder]) {
        [emailTf_ resignFirstResponder];
    }
    if ([idNumField isFirstResponder]) {
        [idNumField resignFirstResponder];
    }
    if ([heightField isFirstResponder]) {
        [heightField resignFirstResponder];
    }
    if ([weightField isFirstResponder]) {
        [weightField resignFirstResponder];
    }
    
    
}

//更新控件上的值
-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];

    
    dataBaseModal = personDetailInfoDataModal;


    //性别
    if(![_personVO.sex isEqualToString:@""])
    {          //[self changeSexBtnStatus];
        [sexBtn setTitle:_personVO.sex forState:UIControlStateNormal];
    }else{
        [sexBtn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    //求职身份
    if ([_personVO.rctypeId isEqualToString:@"1"] && ![_personVO.rctypeId isEqualToString:@""]) {
        [roleBtn setTitle:@"社会人才" forState:UIControlStateNormal];
        
    }else if([_personVO.rctypeId isEqualToString:@"0"] && ![_personVO.rctypeId isEqualToString:@""]){
        [roleBtn setTitle:@"应届生" forState:UIControlStateNormal];
        
    }else{
        [roleBtn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
    
    
    jobStatus1 = dataBaseModal.jobStatus1;
    //求职状态
    if ([_personVO.resume_status isEqualToString:@"4"]){
        [jobStatusBtn setTitle: @"已离职，即可到岗" forState:UIControlStateNormal];
    }else if ([_personVO.resume_status isEqualToString:@"5"]){
        [jobStatusBtn setTitle: @"仍在职，欲换工作" forState:UIControlStateNormal];
    }else if ([_personVO.resume_status isEqualToString:@"6"]){
        [jobStatusBtn setTitle: @"暂不跳槽" forState:UIControlStateNormal];
    }else if ([_personVO.resume_status isEqualToString:@"7"]){
        [jobStatusBtn setTitle: @"寻找新机会" forState:UIControlStateNormal];
    }

    //国籍
    if( _personVO.guoji && ![_personVO.guoji isEqualToString:@""] )
    {
        [countryBtn setTitle:_personVO.guoji forState:UIControlStateNormal];
    }else{
        [countryBtn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //证件类型
    if( _personVO.certId && ![_personVO.certId isEqualToString:@""] )
    {
        for (NSString *str in [idTypeDic allKeys])
        {
            NSString *str1 = idTypeDic[str];
            if ([str1 isEqualToString:_personVO.certId])
            {
                [idTypeBtn setTitle:str forState:UIControlStateNormal];
                break;
            }
        }
        
    }else{
        [idTypeBtn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //证件号码
    if( _personVO.code && ![_personVO.code isEqualToString:@""] )
    {
        idNumField.text = _personVO.code;
    }

    //身高
    if( _personVO.shengao && ![_personVO.shengao isEqualToString:@""] )
    {
        heightField.text = _personVO.shengao;
    }

    //体重
    if( _personVO.tizhong && ![_personVO.tizhong isEqualToString:@""] )
    {
        weightField.text = _personVO.tizhong;
    }

    //目前年薪
    NSString *salaryStr = @"";
    if( _personVO.salary.length > 0 && ![_personVO.salary isEqualToString:@""] && ![_personVO.salary isEqualToString:@"0"] && _personVO.salary)
    {
        NSInteger num = [_personVO.salary integerValue];
        NSString *userName = [CommonConfig getDBValueByKey:Config_Key_User];
        NSString *usr_selected_salary = [NSString stringWithFormat:@"%@selected_salary",userName];
        kUserDefaults(@(num), usr_selected_salary);
        kUserSynchronize;
        salaryStr = salaArrDic[_personVO.salary];
    }
    if ([salaryStr isKindOfClass:[NSString class]] && salaryStr.length > 0){
        [salaryBtn setTitle:salaryStr forState:UIControlStateNormal];
        [salaryBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }else{
        [salaryBtn setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        [salaryBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    }

    //姓名
    if( _personVO.iname )
    {
        nameTf_.text = _personVO.iname;
    }else
    {
        nameTf_.text = @"";
    }
    
    //工作年限
    if(_personVO.gznum.length > 0)
    {
        yearTf_.text = _personVO.gznum;
    }
    else
    {
        yearTf_.text = @"";
    }
    
   
    //出生日期
    if( _personVO.bday && ![_personVO.bday isEqualToString:@""] )
    {
        [birthBayBtn_ setTitle:_personVO.bday forState:UIControlStateNormal];
    }else{
        [birthBayBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //手机号码
    if( _personVO.shouji )
    {
        cellPhoneTf_.text = _personVO.shouji;
    }else
    {
        cellPhoneTf_.text = @"";
    }

    //email
    if( _personVO.email )
    {
        emailTf_.text = _personVO.email;
    }
    
    //籍贯
    if( _personVO.hka && ![_personVO.hka isEqualToString:@""] )
    {
        //通过id获取str
        NSString *regionStr = [CondictionPlaceCtl getRegionDetailAddress:_personVO.hka];
        cityId = _personVO.hka;
        [placeOriginBtn_ setTitle:regionStr forState:UIControlStateNormal];
    }else{
        [placeOriginBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //现居住地
    NSString *address = [CondictionPlaceCtl getRegionDetailAddress:_personVO.regionid];
    if( address )
    {
        nowLiveId = _personVO.regionid;
        [addressBtn_ setTitle:address forState:UIControlStateNormal];
    }else{
        [addressBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //现有职称
    if( _personVO.zcheng && ![_personVO.zcheng isEqualToString:@""] )
    {
        [positionLevelBtn_ setTitle:_personVO.zcheng forState:UIControlStateNormal];
    }else{
        [positionLevelBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //婚姻
    if( _personVO.marry && ![_personVO.marry isEqualToString:@""] )
    {
        [marryBtn_ setTitle:_personVO.marry forState:UIControlStateNormal];
    }

    //政治面貌
    if( _personVO.zzmm && ![_personVO.zzmm isEqualToString:@""] )
    {
        [politicsBtn_ setTitle:_personVO.zzmm forState:UIControlStateNormal];
    }else{
        [politicsBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }

    //民族
    if( _personVO.mzhu && ![_personVO.mzhu isEqualToString:@""] )
    {
        [nationBtn_ setTitle:_personVO.mzhu forState:UIControlStateNormal];
    }else{
        [nationBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
}

#pragma mark - 修改后返回刷新(没用到)
-(void)editorSuccess
{
    if (editorCtl.editorType == gender_type) {
        NSString *str = personCenterModel.userModel_.sex_;
        [sexBtn setTitle:str forState:UIControlStateNormal];
        
    }else if (editorCtl.editorType == role_type){
        NSString *str = personCenterModel.userModel_.role_;
        if ([str isEqualToString:@"0"]) {
            [roleBtn setTitle:@"社会人才" forState:UIControlStateNormal];
            
        }else if([str isEqualToString:@"1"]){
            [roleBtn setTitle:@"应届生" forState:UIControlStateNormal];
        }
    }else if (editorCtl.editorType == jobStatus_type)
    {
        NSString *str = personCenterModel.userModel_.jobStatus;
        if ([str isEqualToString:@"已离职，即可到岗"]){
            jobStatus1 = @"4";
        }
        else if ([str isEqualToString:@"仍在职，欲换工作"])
        {
            jobStatus1 = @"5";
        }
        else if ([str isEqualToString:@"暂不跳槽"]){
            jobStatus1 = @"6";
        }
        else if ([str isEqualToString:@"寻找新机会"]){
            jobStatus1 = @"7";
        }
        [jobStatusBtn setTitle:str forState:UIControlStateNormal];
    }
    editorCtl.fromResume = NO;
    //[self updateComInfo:PreRequestCon_Update_];
    
}

//#pragma ChooseHotCityDelegate
-(void) chooseHotCity:(NSString *)city hotCityId:(NSString *)hotCityId
{
    CondictionList_DataModal *dataCityModal = [[CondictionList_DataModal alloc] init];
    dataCityModal.str_ = city;
    dataCityModal.id_ = hotCityId;//[CondictionPlaceCtl getRegionId:city];
    
    if (isRegion) {
        placeOriginDataModal_ = dataCityModal;
        NSString *strOringin = [CondictionPlaceCtl getRegionDetailAddress:placeOriginDataModal_.id_];
        //籍guan
        if( !placeOriginDataModal_ || placeOriginDataModal_ == nil )
        {
            [placeOriginBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        }else
        {
            [placeOriginBtn_ setTitle:strOringin forState:UIControlStateNormal];
        }
    }
    else{
        regionDataModal_ = dataCityModal;
        //地区
        if( !regionDataModal_ || regionDataModal_ == nil )
        {
            [addressBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        }else
        {
            NSString *str = [CondictionPlaceCtl getRegionDetailAddress:regionDataModal_.id_];
            [addressBtn_ setTitle:str forState:UIControlStateNormal];
        }
    }
    
    
    //[self updateComInfo:nil];
}

//条件选择已经完成
-(void) condictionChooseComplete:(PreBaseUIViewController *)ctl dataModal:(CondictionList_DataModal *)dataModal type:(CondictionChooseType)type
{
    switch ( type ) {
        case GetEduType:
        {
            eduDataModal_ = dataModal;
            
            //学历
            if( !eduDataModal_ || eduDataModal_ == nil )
            {
                [hightEduBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
                [hightEduBtn_ setTitle:eduDataModal_.str_ forState:UIControlStateNormal];
        }
            break;
        case GetRegionType:
        {
            regionDataModal_ = dataModal;
            
            //地区
            if( !regionDataModal_ || regionDataModal_ == nil )
            {
                [addressBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                NSString *str = regionDataModal_.str_;//[CondictionPlaceCtl getRegionDetailAddress:regionDataModal_.id_];
                [addressBtn_ setTitle:str forState:UIControlStateNormal];
            }
        }
            break;
        case GetBirthDayDateType:
        {
            birthDayDataModal_ = dataModal;
            
            //出生日期
            if( !birthDayDataModal_ || birthDayDataModal_ == nil )
            {
                [birthBayBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                [birthBayBtn_ setTitle:birthDayDataModal_.str_ forState:UIControlStateNormal];
            }
        }
            break;
        case GetPlaceOriginType:
        {
            placeOriginDataModal_ = dataModal;
            NSString *strOringin = placeOriginDataModal_.str_;//[CondictionPlaceCtl getRegionDetailAddress:placeOriginDataModal_.id_];
            //籍guan
            if( !placeOriginDataModal_ || placeOriginDataModal_ == nil )
            {
                [placeOriginBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                [placeOriginBtn_ setTitle:strOringin forState:UIControlStateNormal];
            }
        }
            break;
        case GetPostionLevelType:
        {
            positionLevelDataModal_ = dataModal;
            
            //现有职称
            if( !positionLevelDataModal_ || positionLevelDataModal_ == nil )
            {
                [positionLevelBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                [positionLevelBtn_ setTitle:positionLevelDataModal_.str_ forState:UIControlStateNormal];
            }
        }
            break;
        case GetMarrayType:
        {
            marrayDataModal_ = dataModal;
            
            //婚姻状态
            if( !marrayDataModal_ || marrayDataModal_ == nil )
            {
                [marryBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
                [marryBtn_ setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
            }else
            {
                [marryBtn_ setTitle:marrayDataModal_.str_ forState:UIControlStateNormal];
                [marryBtn_ setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            }
        }
            break;
        case GetPoliticsType:
        {
            politicsDataModal_ = dataModal;
            
            //政治面貌
            if( !politicsDataModal_ || politicsDataModal_ == nil )
            {
                [politicsBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                [politicsBtn_ setTitle:politicsDataModal_.str_ forState:UIControlStateNormal];
            }
        }
            break;
        case GetNationType:
        {
            nationDataModal_ = dataModal;
            
            //民族
            if( !nationDataModal_ || nationDataModal_ == nil )
            {
                [nationBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                [nationBtn_ setTitle:nationDataModal_.str_ forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    
    //[self updateComInfo:nil];
}

//检测是否能保存
-(BOOL) checkCanSave
{
    if( [PreCommon checkStringIsNull:[nameTf_.text UTF8String]] )
    {        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写您的真实姓名"    delegate:nil
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        nameTf_.text = @"";

        //[nameTf_ becomeFirstResponder];
        return NO;
    }
    
    if( [PreCommon checkStringIsNull:[yearTf_.text UTF8String]] )
    {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您填写您的工作年限"    delegate:nil
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        yearTf_.text = @"";
        //[yearTf_ becomeFirstResponder];
        return NO;
    }
    
    float gznum = [yearTf_.text floatValue];
    if( gznum < PersonInfo_Gz_Num_Min || gznum > PersonInfo_Gz_Num_Max )
    {
        NSString *msg = [[NSString alloc] initWithFormat:@"工作年限要在: %d - %d 间",PersonInfo_Gz_Num_Min,PersonInfo_Gz_Num_Max];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg    delegate:nil
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        yearTf_.text = @"";
        //[yearTf_ becomeFirstResponder];
        return NO;
    }else {
        NSString *gznumStr = [[NSString alloc] initWithFormat:@"%.1f",gznum];
        yearTf_.text = gznumStr;
    }
    
    if( !birthBayBtn_.titleLabel.text || [birthBayBtn_.titleLabel.text isEqualToString:@""] || [birthBayBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择您的出生日期"    delegate:nil 
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        return NO;
    }
    
    if( !placeOriginBtn_.titleLabel.text || [placeOriginBtn_.titleLabel.text isEqualToString:@""] || [placeOriginBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择您的贯籍"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    

    if( !addressBtn_.titleLabel.text || [addressBtn_.titleLabel.text isEqualToString:@""] || [addressBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择您的现居住地"    delegate:nil 
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        return NO;
    }
    
    if( [PreCommon checkStringIsNull:[cellPhoneTf_.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入您的手机号码"    delegate:nil 
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        cellPhoneTf_.text = @"";
        [cellPhoneTf_ becomeFirstResponder];
        return NO;
    }
    
    if( [PreCommon checkStringIsNull:[emailTf_.text UTF8String]] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入您的email地址"    delegate:nil 
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        emailTf_.text = @"";
        [emailTf_ becomeFirstResponder];
        return NO;
    }else{
        BOOL flag = [self validateEmail:emailTf_.text];
        if (!flag) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"email地址不合法"    delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    if(idNumField.text.length > 0){
        if (![self hyb_isValidPersonID:idNumField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的身份证号码"    delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    if(jobStatusBtn.titleLabel.text.length == 0 || [jobStatusBtn.titleLabel.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写求职状态"    delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    return YES;
}

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//保存
-(void) saveResume
{
    if( [self checkCanSave] )
    {
        //[super saveResume];
        
        if( ![hightEduBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            edu_ = hightEduBtn_.titleLabel.text;
        }
//        if( ![placeOriginBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
//        {
//            hka_ = [CondictionPlaceCtl getRegionId:placeOriginBtn_.titleLabel.text];
//        }
        if (placeOriginDataModal_) {
            hka_ = placeOriginDataModal_.id_;
        }
        else{
            hka_ = _personVO.hka;
        }
        if( ![birthBayBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            birthday_ = birthBayBtn_.titleLabel.text;
        }
        if( regionDataModal_ )
        {
            nowRegionId_ = regionDataModal_.id_;
        }else
        {
            nowRegionId_ = _personVO.regionid;
        }
//        if (![addressBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue]) {
//            nowRegionId_ = [CondictionPlaceCtl getRegionDetailAddress:addressBtn_.titleLabel.text];
//        }
        
        if( ![positionLevelBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            zcheng_ = positionLevelBtn_.titleLabel.text;
        }else
            zcheng_ = nil;
        if( ![marryBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            marray_ = marryBtn_.titleLabel.text;
            
        }else
            marray_ = nil;
        if( ![politicsBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            zzmm_ = politicsBtn_.titleLabel.text;
        }else
            zzmm_ = nil;
        if( ![nationBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            mzhu_ = nationBtn_.titleLabel.text;
        }else
            mzhu_ = nil;
        
        NSString *typeId = @"";
        if (idTypeBtn.titleLabel.text.length > 0) {
            typeId = idTypeDic[idTypeBtn.titleLabel.text];
        }
        
        PersonDetailInfo_DataModal *dataModal = [[PersonDetailInfo_DataModal alloc] init];
        
        dataModal.iname_ = nameTf_.text.length > 0 ? nameTf_.text:@"";
        dataModal.sex_ = sexBtn.titleLabel.text.length > 0 ? sexBtn.titleLabel.text:@"";
        dataModal.bday_ = birthday_.length > 0 ? birthday_:@"";
        dataModal.rcType_ = [roleBtn.titleLabel.text isEqualToString:@"社会人才"] ? @"1":@"0";
        dataModal.gznum_ = yearTf_.text.length > 0 ? yearTf_.text:@"";
        dataModal.hka_ = hka_.length > 0 ? hka_:@"";
        dataModal.region_ = nowRegionId_.length > 0 ? nowRegionId_:@"";
        dataModal.jobStatus1 = jobStatus1.length > 0 ? jobStatus1:@"";
        dataModal.shouji_ = cellPhoneTf_.text.length > 0 ? cellPhoneTf_.text:@"";
        dataModal.emial_ = emailTf_.text.length > 0 ? emailTf_.text:@"";
        dataModal.country = countryBtn.titleLabel.text.length > 0 ? countryBtn.titleLabel.text:@"";
        dataModal.mzhu_ = mzhu_.length > 0 ? mzhu_:@"";
        dataModal.zzmm_ = zzmm_.length > 0 ? zzmm_:@"";
        dataModal.idType = typeId.length > 0 ? typeId:@"";
        dataModal.idNum = idNumField.text.length > 0 ? idNumField.text:@"";
        dataModal.height = heightField.text.length > 0 ? heightField.text:@"";
        dataModal.weight = weightField.text.length > 0 ? weightField.text:@"";
        dataModal.zcheng_ = zcheng_.length > 0 ? zcheng_:@"";
        dataModal.salary = salaryBtn.titleLabel.text.length > 0 ? salaryBtn.titleLabel.text:@"";
        

        NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] init];
        if (![dataModal.iname_ isEqualToString:personDetailInfoDataModal.iname_])
        {
            [searchDic setObject:dataModal.iname_ forKey:@"iname"];
            personDetailInfoDataModal.iname_ = dataModal.iname_;
        }
        if (![dataModal.sex_ isEqualToString:personDetailInfoDataModal.sex_]) {
             [searchDic setObject:dataModal.sex_ forKey:@"sex"];
            personDetailInfoDataModal.sex_ = dataModal.sex_;
        }
        if (![dataModal.bday_ isEqualToString:personDetailInfoDataModal.bday_]) {
             [searchDic setObject:dataModal.bday_ forKey:@"bday"];
            personDetailInfoDataModal.bday_ = dataModal.bday_;
        }
        if (![dataModal.rcType_ isEqualToString:personDetailInfoDataModal.rcType_]) {
             [searchDic setObject:dataModal.rcType_ forKey:@"rctypeId"];
            personDetailInfoDataModal.rcType_ = dataModal.rcType_;
        }
        if (![dataModal.gznum_ isEqualToString:personDetailInfoDataModal.gznum_]) {
            [searchDic setObject:dataModal.gznum_ forKey:@"gznum"];
            personDetailInfoDataModal.gznum_ = dataModal.gznum_;
        }
        if (![dataModal.hka_ isEqualToString:personDetailInfoDataModal.hka_]) {
            [searchDic setObject:dataModal.hka_ forKey:@"hka"];
            personDetailInfoDataModal.hka_ = dataModal.hka_;
        }
        if (![dataModal.region_ isEqualToString:personDetailInfoDataModal.region_]) {
            [searchDic setObject:dataModal.region_ forKey:@"regionid"];
            personDetailInfoDataModal.region_ = dataModal.region_;
        }
        if (![dataModal.shouji_ isEqualToString:personDetailInfoDataModal.shouji_]) {
            [searchDic setObject:dataModal.shouji_ forKey:@"shouji"];
            personDetailInfoDataModal.shouji_ = dataModal.shouji_;
        }
        if (![dataModal.emial_ isEqualToString:personDetailInfoDataModal.emial_]) {
             [searchDic setObject:dataModal.emial_ forKey:@"email"];
            personDetailInfoDataModal.emial_ = dataModal.emial_;
        }
        if (![dataModal.country isEqualToString:personDetailInfoDataModal.country]) {
            [searchDic setObject:dataModal.country forKey:@"guoji"];
            personDetailInfoDataModal.country = dataModal.country;
        }
        if (![dataModal.mzhu_ isEqualToString:personDetailInfoDataModal.mzhu_]) {
            [searchDic setObject:dataModal.mzhu_ forKey:@"mzhu"];
            personDetailInfoDataModal.mzhu_ = dataModal.mzhu_;
        }
        if (![dataModal.zzmm_ isEqualToString:personDetailInfoDataModal.zzmm_]) {
            [searchDic setObject:dataModal.zzmm_ forKey:@"zzmm"];
            personDetailInfoDataModal.zzmm_ = dataModal.zzmm_;
        }
        if (![dataModal.idType isEqualToString:personDetailInfoDataModal.idType]) {
            [searchDic setObject:dataModal.idType forKey:@"certId"];
            personDetailInfoDataModal.idType = dataModal.idType;
        }
        if (![dataModal.idNum isEqualToString:personDetailInfoDataModal.idNum]) {
            [searchDic setObject:dataModal.idNum forKey:@"code"];
            personDetailInfoDataModal.idNum = dataModal.idNum;
        }
        if (![dataModal.height isEqualToString:personDetailInfoDataModal.height]) {
             [searchDic setObject:dataModal.height forKey:@"shengao"];
            personDetailInfoDataModal.height = dataModal.height;
        }
        if (![dataModal.weight isEqualToString:personDetailInfoDataModal.weight]) {
            [searchDic setObject:dataModal.weight forKey:@"tizhong"];
            personDetailInfoDataModal.weight = dataModal.weight;
        }
        if (![dataModal.zcheng_ isEqualToString:personDetailInfoDataModal.zcheng_]) {
            [searchDic setObject:dataModal.zcheng_ forKey:@"zcheng"];
            personDetailInfoDataModal.zcheng_ = dataModal.zcheng_;
        }
        if (marray_) {
            [searchDic setObject:marray_ forKey:@"marry"];
        }
        NSString *userName = [CommonConfig getDBValueByKey:Config_Key_User];
        NSString *usr_selected_salary = [NSString stringWithFormat:@"%@selected_salary",userName];
        NSString *salary_new = [NSString stringWithFormat:@"%@",getUserDefaults(usr_selected_salary)];
        if (salary_new.length > 0) {
            [searchDic setObject:salary_new forKey:@"salary"];
        }
        
        
        //[searchDic setObject:dataBaseModal.salary forKey:@"salary"];
        
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        for (NSString *key in [searchDic allKeys])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[searchDic objectForKey:key] forKey:@"columnValue"];
            [dic setObject:key forKey:@"columnName"];
            [arrData addObject:dic];
        }
        
        NSMutableDictionary *allDic = [[NSMutableDictionary alloc] init];
        [allDic setObject:[Manager getUserInfo].userId_ forKey:@"personId"];
        
        if (![dataModal.jobStatus1 isEqualToString:personDetailInfoDataModal.jobStatus1]) {
            [allDic setObject:dataModal.jobStatus1 forKey:@"resume_status"];
        }
        
        [allDic setObject:arrData forKey:@"update"];
        [allDic setObject:[NSString stringWithFormat:@"id=%@",[Manager getUserInfo].userId_] forKey:@"where"];
        
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *searchStr = [jsonWriter stringWithObject:allDic];
        
        NSString * bodyMsg = [NSString stringWithFormat:@"param=%@",searchStr];
        [BaseUIViewController showLoadView:YES content:@"正在保存" view:nil];
#pragma 保存信息请求
        [ELRequest postbodyMsg:bodyMsg op:@"person_info_busi" func:@"updatePersonDetail" requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
         {
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             NSDictionary *dic = result;
             NSString *status = dic[@"status"];
             if( [status isEqualToString:Request_OK] )
             {
                 [self.resumeDelegate_ resumeInfoChanged:self modal:personDetailInfoDataModal];
                 [CommonConfig setDBValueByKey:Config_Key_UserName value:nameTf_.text];
                 [Manager getUserInfo].name_ = nameTf_.text;
                 [_delegate personInfoChang];
                 [PreBaseUIViewController showAutoLoadingView:@"保存成功" msg:nil seconds:1.0];

                 
                 if (self.myBlock) {
                     self.myBlock(@"成功!");
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 
             }
             else
             {
                 [PreBaseUIViewController showAlertView:@"保存失败" msg:@"请稍候再试" btnTitle:@"关闭"];
             }
             
         } failure:^(NSURLSessionDataTask *operation, NSError *error) {
             [BaseUIViewController showLoadView:NO content:nil view:nil];
             [PreBaseUIViewController showAutoLoadingView:@"请检查网络" msg:nil seconds:1.0];
         }];
    }
}

-(void) finishGetData:(PreRequestCon *)preRequestCon code:(ErrorCode)code type:(XMLParserType)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:preRequestCon code:code type:type dataArr:dataArr];
    
    switch ( type ) {
        case UpdateResume_BaseInfo_XMLParser:
        {
            @try {
                PreStatus_DataModal *dataModal = [dataArr objectAtIndex:0];
                if( [dataModal.status_ isEqualToString:Request_OK] )
                {
                    //如果修改成功了,个人信息的dataModal有些也需要做相应的更改
                    PersonDetailInfo_DataModal *personInfoDataModal = personDetailInfoDataModal;
                    
                    if( sexState_ == Girl )
                    {
                        personInfoDataModal.sex_    = @"女";
                    }else
                        personInfoDataModal.sex_    = @"男";
                    
                    personInfoDataModal.iname_      = nameTf_.text;
                    personInfoDataModal.gznum_      = yearTf_.text;
                    personInfoDataModal.edu_        = edu_;
                    personInfoDataModal.hka_        = hka_;
                    personInfoDataModal.bday_       = birthday_;
                    personInfoDataModal.region_     = nowRegionId_;
                    personInfoDataModal.shouji_     = cellPhoneTf_.text;
                    personInfoDataModal.emial_      = emailTf_.text;
                    personInfoDataModal.zcheng_     = zcheng_;
                    personInfoDataModal.marray_     = marray_;
                    personInfoDataModal.zzmm_       = zzmm_;
                    personInfoDataModal.mzhu_       = mzhu_;
                    
//                    personInfoDataModal.sex_ = sexBtn.titleLabel.text;
//                    personInfoDataModal.role = roleBtn.titleLabel.text;
//                    personInfoDataModal.newJobStatus = jobStatusBtn.titleLabel.text;
//                    personInfoDataModal.country = countryBtn.titleLabel.text;
//                    personInfoDataModal.idType = idTypeBtn.titleLabel.text;
//                    personInfoDataModal.idNum = idNumField.text;
//                    personInfoDataModal.height = heightField.text;
//                    personInfoDataModal.weight = weightField.text;
//                    personInfoDataModal.salary = salaryBtn.titleLabel.text;

                    
                    
                    
                    //去更新登录中的性别与名称
                    // need fix
//                    manager.loginCtl_.loginDataModal_.iname_ = nameTf_.text;
//                    manager.loginCtl_.loginDataModal_.sex_ = personInfoDataModal.sex_;
                    
                    loginDataModal.iname_ = nameTf_.text;
                    loginDataModal.sex_ = personDetailInfoDataModal.sex_;
                    [self.resumeDelegate_ resumeInfoChanged:self modal:personDetailInfoDataModal];
                    [CommonConfig setDBValueByKey:Config_Key_UserName value:nameTf_.text];
                    [Manager getUserInfo].name_ = nameTf_.text;
                    [_delegate personInfoChang];
                    [PreBaseUIViewController showAutoLoadingView:@"更新成功" msg:nil seconds:2.0];
                }
            }
            @catch (NSException *exception) {                
                [PreBaseUIViewController showAlertView:@"更新失败" msg:@"请稍候再试" btnTitle:@"关闭"];
            }
            @finally {
                
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark = TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL flag = [super textFieldShouldReturn:textField];
    
    if( textField == emailTf_ )
    {
        [emailTf_ resignFirstResponder];
    }
    
    if( textField == cellPhoneTf_ )
    {
        [cellPhoneTf_ becomeFirstResponder];
    }
    
    if( textField == idNumField )
    {
        [idNumField resignFirstResponder];
    }
    
    if( textField == heightField )
    {
        [heightField resignFirstResponder];
    }
    
    if( textField == weightField )
    {
        [weightField resignFirstResponder];
    }
    
    return flag;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == cellPhoneTf_) {
        BindCtl *bindCtl = [[BindCtl alloc]init];
        if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 11) {
            bindCtl.varifyType = VarifyTypeUpdatePhone;
        }else{
            bindCtl.varifyType = VarifyTypeBindPhone;
        }
        [self.navigationController pushViewController:bindCtl animated:YES];
        return NO;
    }else if (textField == emailTf_){
//        if (![[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
//            NSString *userName = [Manager getUserInfo].uname_;
//            if ([MyCommon isValidateEmail:userName] && [userName isEqualToString:emailTf_.text]) {
        if (_personVO.email.length > 0) {
            BindCtl *bindCtl = [[BindCtl alloc]init];
            bindCtl.varifyType = VarifyTypeUpdateEmail;
            [self.navigationController pushViewController:bindCtl animated:YES];
            return NO;
        }
        
//            }
//        }
    }
    return YES;
}

#pragma mark--检验身份证号码
//检验身份证号码
- (BOOL)hyb_isValidPersonID:(NSString *)personId {
    // 判断位数
    if (personId.length != 15 && personId.length != 18) {
        return NO;
    }
    NSString *carid = personId;
    long lSumQT = 0;
    // 加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    // 校验码
    unsigned char checkers[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    // 将15位身份证号转换成18位
    NSMutableString *str = [NSMutableString stringWithString:personId];
    if (personId.length == 15) {
        [str insertString:@"19" atIndex:6];
        long p = 0;
        const char *personId = [str UTF8String];
        
        for (int i = 0; i<= 16; i++) {
            p += (personId[i] - 48) * R[i];
        }
        
        int o = p % 11;
        NSString *string_content = [NSString stringWithFormat:@"%c", checkers[o]];
        [str insertString:string_content atIndex:[str length]];
        carid = str;
    }
    
    // 判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self _areaCode:sProvince]) {
        return NO;
    }
    
    // 判断年月日是否有效
    // 年份
    int strYear = [[self _substringWithString:carid begin:6 end:4] intValue];
    // 月份
    int strMonth = [[self _substringWithString:carid begin:10 end:2] intValue];
    // 日
    int strDay = [[self _substringWithString:carid begin:12 end:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"]];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",
                                            strYear, strMonth, strDay]];
    if (date == nil) {
        return NO;
    }
    
    const char *pid  = [carid UTF8String];
    // 检验长度
    if(18 != strlen(pid)) return NO;
    // 校验数字
    for (int i = 0; i < 18; i++) {
        if ( !isdigit(pid[i]) && !(('X' == pid[i] || 'x' == pid[i]) && 17 == i) ) {
            return NO;
        }
    }
    
    // 验证最末的校验码
    for (int i = 0; i <= 16; i++) {
        lSumQT += (pid[i]-48) * R[i];
    }
    
    if (checkers[lSumQT%11] != pid[17] ) {
        return NO;
    }
    return YES;
}

- (NSString *)_substringWithString:(NSString *)str begin:(NSInteger)begin end:(NSInteger )end {
    return [str substringWithRange:NSMakeRange(begin, end)];
}

- (BOOL)_areaCode:(NSString *)code {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 1000) {
        switch (buttonIndex) {
            case 0:
                genderStr = @"男";
                [sexBtn setTitle:genderStr forState:UIControlStateNormal];
                dataBaseModal.sex_ = genderStr;
                break;
            case 1:
                genderStr = @"女";
                [sexBtn setTitle:genderStr forState:UIControlStateNormal];
                dataBaseModal.sex_ = genderStr;
                break;
            default:
                break;
        }
    }
    else if (actionSheet.tag == 1001){
        switch (buttonIndex) {
            case 0:
                roleStr = @"社会人才";
                [roleBtn setTitle:roleStr forState:UIControlStateNormal];
                if ([roleStr isEqualToString:@"社会人才"]) {
                    dataBaseModal.role = @"1";
                }
                
                break;
            case 1:
                roleStr = @"应届生";
                [roleBtn setTitle:roleStr forState:UIControlStateNormal];
                if ([roleStr isEqualToString:@"应届生"]) {
                    dataBaseModal.role = @"0";
                }
                
                break;
            default:
                break;
        }
    }
    else if (actionSheet.tag == 1002){
        
        /*
         if ([dataBaseModal.jobStatus1 isEqualToString:@"4"]){
         [jobStatusBtn setTitle: @"求职中，即可到岗" forState:UIControlStateNormal];
         }else if ([dataBaseModal.jobStatus1 isEqualToString:@"5"]){
         [jobStatusBtn setTitle: @"仍在职，欲换工作" forState:UIControlStateNormal];
         }else if ([dataBaseModal.jobStatus1 isEqualToString:@"6"]){
         [jobStatusBtn setTitle: @"暂不跳槽" forState:UIControlStateNormal];
         }else if ([dataBaseModal.jobStatus1 isEqualToString:@"7"]){
         [jobStatusBtn setTitle: @"寻找新机会" forState:UIControlStateNormal];
         }
         */
        switch (buttonIndex) {
            case 0:
                jobStatusStr = @"已离职，即可到岗";
                [jobStatusBtn setTitle:jobStatusStr forState:UIControlStateNormal];
                if ([jobStatusStr isEqualToString:@"已离职，即可到岗"]) {
                    jobStatus1= @"4";
                }
                
                break;
            case 1:
                jobStatusStr = @"仍在职，欲换工作";
                [jobStatusBtn setTitle:jobStatusStr forState:UIControlStateNormal];
                if ([jobStatusStr isEqualToString:@"仍在职，欲换工作"]) {
                    jobStatus1 = @"5";
                }
                
                break;
            case 2:
                jobStatusStr = @"暂不跳槽";
                [jobStatusBtn setTitle:jobStatusStr forState:UIControlStateNormal];
                if ([jobStatusStr isEqualToString:@"暂不跳槽"]) {
                    jobStatus1 = @"6";
                }
                
                break;
            case 3:
                jobStatusStr = @"寻找新机会";
                [jobStatusBtn setTitle:jobStatusStr forState:UIControlStateNormal];
                if ([jobStatusStr isEqualToString:@"寻找新机会"]) {
                    jobStatus1 = @"7";
                }
                
                break;

            default:
                break;
        }
    }

    
}
-(void) buttonResponse:(id)sender
{
    editorCtl = [[EditorPersonInfo alloc] init];
    //性别
    if (sender == sexBtn) {
    
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        actionSheet.tag = 1000;
        [actionSheet showInView:self.view];
    }
    //求职身份
    else if (sender == roleBtn){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"社会人才",@"应届生", nil];
        actionSheet.tag = 1001;
        [actionSheet showInView:self.view];
    }
    
    //求职状态
    else if (sender == jobStatusBtn){
       
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"已离职，即可到岗",@"仍在职，欲换工作",@"暂不跳槽",@"寻找新机会",nil];
        actionSheet.tag = 1002;
        [actionSheet showInView:self.view];
    }
    
    //选择学历
    else if( sender == hightEduBtn_ )
    {
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetEduType];
    }
    else if( sender == addressBtn_ )
    {//选择居住地
        
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
        
        ctl.showQuanGuo = YES;
        ctl.showLocation = YES;
        if (addressBtn_.titleLabel.text.length > 0 && ![addressBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue]) {
            ctl.selectName = addressBtn_.titleLabel.text;
            ctl.selectId = nowLiveId;
            ctl.selectHotCity = hotCity;
        }
        WS(weakSelf)
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
            
            //                placeOriginBtn_.titleLabel.text = regionName;
            [addressBtn_ setTitle:regionName forState:UIControlStateNormal];
            nowLiveId = regionId;
            hotCity = selectHotCity;
            isRegion = NO;
            [weakSelf chooseHotCity:regionName hotCityId:regionId];
        };
        
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == placeOriginBtn_ )
    {//选择籍贯
        
        FBRegionCtl *ctl = [[FBRegionCtl alloc] init];
       
        ctl.showQuanGuo = YES;
        ctl.showLocation = YES;
        if (placeOriginBtn_.titleLabel.text.length > 0 && ![placeOriginBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue]) {
            ctl.selectName = placeOriginBtn_.titleLabel.text;
            ctl.selectId = cityId;
            ctl.selectHotCity = hotCity;
        }
        WS(weakSelf)
        ctl.block = ^(NSString *regionName,NSString *regionId,BOOL selectHotCity){
        
            [placeOriginBtn_ setTitle:regionName forState:UIControlStateNormal];
            cityId = regionId;
            hotCity = selectHotCity;
            isRegion = YES;
            [weakSelf chooseHotCity:regionName hotCityId:regionId];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if( sender == birthBayBtn_ )
    {//选择出生日期
        NSDate *date = nil;
        if ([birthBayBtn_.titleLabel.text isEqualToString:@"请选择"] || [birthBayBtn_.titleLabel.text isEqualToString:@""]) {
            date = [@"1980-01-01" dateFormStringFormat:@"yyyy-MM-dd"];
        }else{
            date = [birthBayBtn_.titleLabel.text dateFormStringFormat:@"yyyy-MM-dd"];
        }
        if (!changeDateCtl)
        {
            changeDateCtl = [[ELChangeDateCtl alloc] init];
        }
        changeDateCtl.showTodayBtn = NO;
        [changeDateCtl showViewCtlCurrentDate:date WithBolck:^(CondictionList_DataModal *dataModal)
         {
             [birthBayBtn_ setTitle:[dataModal.oldString substringWithRange:NSMakeRange(0,10)] forState:UIControlStateNormal];
         }];
    }
    else if( sender == positionLevelBtn_ )
    {//选择现有职称
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetPostionLevelType];
    }
    else if(sender == salaryBtn){//薪水
//        __weak typeof(self) WeakSelf = self;
        SalarySelectionViewController *salaryVC = [[SalarySelectionViewController alloc]init];
        salaryVC.myBlock = ^(NSString *title){
            [salaryBtn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
            [salaryBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        };
        salaryVC.selSalaryIdx = salaryBtn.titleLabel.text;
        [self.navigationController pushViewController:salaryVC animated:YES];
    }
    else if( sender == marryBtn_ )
    {//选择婚姻状态
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetMarrayType];
    }
    else if( sender == politicsBtn_ )
    {//选择政治面貌
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetPoliticsType];
    }
    else if( sender == nationBtn_ )
    {//选择民族
        [self.navigationController pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetNationType];
    }
    else if( sender == countryBtn )
    {//选择国籍
        ELCountryICtl *countryCtr = [[ELCountryICtl alloc]init];
        [self.navigationController pushViewController:countryCtr animated:YES];
        countryCtr.delegate = self;
        //[preCondictionListCtl beginGetData:nil exParam:nil type:GetNationType];
    }
    else if( sender == idTypeBtn )
    {//选择证件类型
        ELIdTypeCtl *idTypeCtr = [[ELIdTypeCtl alloc]init];
        [self.navigationController pushViewController:idTypeCtr animated:YES];
        idTypeCtr.delegate = self;
        //[preCondictionListCtl beginGetData:nil exParam:nil type:GetNationType];
    }
    else if( sender == saveBtn_ )
    {//选择了保存
        if ([self checkCanSave]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存已修改的信息？"    delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"保存",nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [self saveResume];
    }
}

#pragma mark - 选择国籍
-(void)countryICtl:(NSString *)countryName
{
    if (![countryName isEqualToString:@""]) {
        [countryBtn setTitle:countryName forState:UIControlStateNormal];
    }
    
}

#pragma mark - 选择证件类型
-(void)idTypeCtl:(NSString *)idTypeName
{
    if (![idTypeName isEqualToString:@""]) {
        [idTypeBtn setTitle:idTypeName forState:UIControlStateNormal];
    }
    
}


-(void) backBarBtnResponse:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate backCtl];
}

@end
