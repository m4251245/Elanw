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
#import "Manager.h"

@implementation PersonInfo_ResumeCtl

-(id) init
{
    self  = [self initWithNibName:PersonInfo_ResumeCtl_Xib_Name bundle:nil];
    self.title = PersonInfo_ResumeCtl_Title;

    //初始化性别为'男'
    sexState_ = Boy;
    
    selectImageOn_  = [UIImage imageNamed:Stadio_On_Image];
    selectImageOff_ = [UIImage imageNamed:Stadio_Off_Image];
    
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //更改性别按扭状态
    [self changeSexBtnStatus];
    
    //设置相关代理
    nameTf_.delegate = self;
    yearTf_.delegate = self;
    cellPhoneTf_.delegate = self;
    emailTf_.delegate = self;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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
    
    [nameTf_ resignFirstResponder];
    [yearTf_ resignFirstResponder];
    [cellPhoneTf_ resignFirstResponder];
    [emailTf_ resignFirstResponder];
}

//更新控件上的值
-(void) updateComInfo:(PreRequestCon *)con
{
    [super updateComInfo:con];
    
    PersonDetailInfo_DataModal *dataModal = personDetailInfoDataModal;
    
    if( dataModal && !bHaveUpdateComData_ )
    {   
        //说明数据已经被加载
        bHaveUpdateComData_ = YES;
        
        //姓名
        if( dataModal.iname_ )
        {
            nameTf_.text = dataModal.iname_;
        }else
            nameTf_.text = @"";
        //工作年限
        if( dataModal.gznum_ )
        {
            yearTf_.text = dataModal.gznum_;
        }else
            yearTf_.text = @""; 
        //性别
        if( [dataModal.sex_ isEqualToString:@"男"] )
        {
            sexState_ = Boy;
            [self changeSexBtnStatus];
        }
        if( [dataModal.sex_ isEqualToString:@"女"] )
        {
            sexState_ = Girl;
            [self changeSexBtnStatus];
        }
        //最高学历
        if( dataModal.edu_ && ![dataModal.edu_ isEqualToString:@""])
        {
            [hightEduBtn_ setTitle:dataModal.edu_ forState:UIControlStateNormal];
        }else
            [hightEduBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //籍贯
        if( dataModal.hka_ && ![dataModal.hka_ isEqualToString:@""] )
        {
            //通过id获取str
            NSString *regionStr = [CondictionPlaceCtl getRegionStr:dataModal.hka_];
            [placeOriginBtn_ setTitle:regionStr forState:UIControlStateNormal];
        }else
            [placeOriginBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //出生日期
        if( dataModal.bday_ && ![dataModal.bday_ isEqualToString:@""] )
        {
            [birthBayBtn_ setTitle:dataModal.bday_ forState:UIControlStateNormal];
        }else
            [birthBayBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //手机号码
        if( dataModal.shouji_ )
        {
            cellPhoneTf_.text = dataModal.shouji_;
        }else
            cellPhoneTf_.text = @"";
        //email
        if( dataModal.emial_ )
        {
            emailTf_.text = dataModal.emial_;
        }
        //现居住地
        NSString *address = [CondictionPlaceCtl getRegionDetailAddress:dataModal.region_];
        if( address )
        {
             [addressBtn_ setTitle:address forState:UIControlStateNormal];
        }else
            [addressBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //现有职称
        if( dataModal.zcheng_ && ![dataModal.zcheng_ isEqualToString:@""] )
        {
            [positionLevelBtn_ setTitle:dataModal.zcheng_ forState:UIControlStateNormal];
        }else
            [positionLevelBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //婚姻
        if( dataModal.marray_ && ![dataModal.marray_ isEqualToString:@""] )
        {
            [marryBtn_ setTitle:dataModal.marray_ forState:UIControlStateNormal];
        }else
            [marryBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //政治面貌
        if( dataModal.zzmm_ && ![dataModal.zzmm_ isEqualToString:@""] )
        {
            [politicsBtn_ setTitle:dataModal.zzmm_ forState:UIControlStateNormal];
        }else
            [politicsBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
        //民族
        if( dataModal.mzhu_ && ![dataModal.mzhu_ isEqualToString:@""] )
        {
            [nationBtn_ setTitle:dataModal.mzhu_ forState:UIControlStateNormal];
        }else
            [nationBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }
}

#pragma ChooseHotCityDelegate
-(void) chooseHotCity:(RegionCtl *)ctl city:(NSString *)city
{
    CondictionList_DataModal *dataModal = [[CondictionList_DataModal alloc] init];
    dataModal.str_ = city;
    dataModal.id_ = [CondictionPlaceCtl getRegionId:city];
    
    regionDataModal_ = dataModal;
    
    //地区
    if( !regionDataModal_ || regionDataModal_ == nil )
    {
        [addressBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
    }else
    {
        NSString *str = [CondictionPlaceCtl getRegionDetailAddress:regionDataModal_.id_];
        [addressBtn_ setTitle:str forState:UIControlStateNormal];
    }
    
    [self updateComInfo:nil];
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
                NSString *str = [CondictionPlaceCtl getRegionDetailAddress:regionDataModal_.id_];
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
            
            //籍guan
            if( !placeOriginDataModal_ || placeOriginDataModal_ == nil )
            {
                [placeOriginBtn_ setTitle:ChooseResume_Null_DefaultValue forState:UIControlStateNormal];
            }else
            {
                [placeOriginBtn_ setTitle:placeOriginDataModal_.str_ forState:UIControlStateNormal];
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
            }else
            {
                [marryBtn_ setTitle:marrayDataModal_.str_ forState:UIControlStateNormal];
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
    
    [self updateComInfo:nil];
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
    }else
    {
        NSString *gznumStr = [[NSString alloc] initWithFormat:@"%.1f",gznum];
        yearTf_.text = gznumStr;
    }
    
    if( !hightEduBtn_.titleLabel.text || [hightEduBtn_.titleLabel.text isEqualToString:@""] || [hightEduBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择您的最高学历"    delegate:nil
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        return NO;
    }
    
    if( !placeOriginBtn_.titleLabel.text || [placeOriginBtn_.titleLabel.text isEqualToString:@""] || [placeOriginBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择您的籍贯"    delegate:nil 
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:nil];
		[alert show];
        
        return NO;
    }
    
    if( !birthBayBtn_.titleLabel.text || [birthBayBtn_.titleLabel.text isEqualToString:@""] || [birthBayBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择您的出生日期"    delegate:nil 
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
    }
    
    return YES;
}

//保存
-(void) saveResume
{
    if( [self checkCanSave] )
    {
        [super saveResume];
        
        if( ![hightEduBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            edu_ = hightEduBtn_.titleLabel.text;
        }
        if( ![placeOriginBtn_.titleLabel.text isEqualToString:ChooseResume_Null_DefaultValue] )
        {
            hka_ = [CondictionPlaceCtl getRegionId:placeOriginBtn_.titleLabel.text];
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
            nowRegionId_ = personDetailInfoDataModal.region_;
        }
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
        
        //开始保存
        [PreRequestCon_Update_ updateResumeBaseInfo:nameTf_.text gznum:yearTf_.text sex:sexState_ edu:edu_ hka:hka_ birthday:birthday_ nowRegion:nowRegionId_ phoneNum:cellPhoneTf_.text email:emailTf_.text zcheng:zcheng_ marray:marray_ zzmm:zzmm_ mzhu:mzhu_];
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
                    
                    //去更新登录中的性别与名称
                    // need fix
//                    manager.loginCtl_.loginDataModal_.iname_ = nameTf_.text;
//                    manager.loginCtl_.loginDataModal_.sex_ = personInfoDataModal.sex_;
                    
                    loginDataModal.iname_ = nameTf_.text;
                    loginDataModal.sex_ = personDetailInfoDataModal.sex_;
                    [self.resumeDelegate_ resumeInfoChanged:self modal:personDetailInfoDataModal];
                    
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

#pragma TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL flag = [super textFieldShouldReturn:textField];
    
    //进入下一项
    if( textField == nameTf_ )
    {
        [yearTf_ becomeFirstResponder];
    }
    
    if( textField == yearTf_ )
    {
        [cellPhoneTf_ becomeFirstResponder];
    }
    
    if( textField == cellPhoneTf_ )
    {
        [emailTf_ becomeFirstResponder];
    }
    
    return flag;
}

-(void) buttonResponse:(id)sender
{
    //选中性别'男'
    if( sender == boyBtn_ )
    {
        sexState_ = Boy;
        [self changeSexBtnStatus];
    }
    //选中性别'女'
    else if( sender == girlBtn_ )
    {
        sexState_ = Girl;
        [self changeSexBtnStatus];
    }
    //选择学历
    else if( sender == hightEduBtn_ )
    {
        [self.navCtl_ pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetEduType];
    }
    //选择居住地
    else if( sender == addressBtn_ )
    {
        if (![Manager shareMgr].regionListCtl_) {
            [Manager shareMgr].regionListCtl_ = [[RegionCtl alloc] init];
        }
        [self.navCtl_ pushViewController:[Manager shareMgr].regionListCtl_ animated:YES];
        [[Manager shareMgr].regionListCtl_ beginLoad:nil exParam:nil];
        [Manager shareMgr].regionListCtl_.delegate_ = self;
        
//        [self.navCtl_ pushViewController:condictionPlaceCtl animated:YES];
//        condictionPlaceCtl.delegate_ = self;
    }
    //选择籍贯
    else if( sender == placeOriginBtn_ )
    {
        [self.navCtl_ pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetPlaceOriginType];
    }
    //选择出生日期
    else if( sender == birthBayBtn_ )
    {
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetBirthDayDateType];
    }
    //选择现有职称
    else if( sender == positionLevelBtn_ )
    {
        [self.navCtl_ pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetPostionLevelType];
    }
    //选择婚姻状态
    else if( sender == marryBtn_ )
    {
        [self.navCtl_ pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetMarrayType];
    }
    //选择政治面貌
    else if( sender == politicsBtn_ )
    {
        [self.navCtl_ pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetPoliticsType];
    }
    //选择民族
    else if( sender == nationBtn_ )
    {
        [self.navCtl_ pushViewController:preCondictionListCtl animated:YES];
        preCondictionListCtl.delegate_ = self;
        [preCondictionListCtl beginGetData:nil exParam:nil type:GetNationType];
    }
    //选择了保存
    else if( sender == saveBtn_ )
    {
        [self saveResume];
    }
}

@end
