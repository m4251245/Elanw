//
//  ELScanQRCodeCtl.m
//  jobClient
//
//  Created by 一览ios on 17/1/4.
//  Copyright © 2017年 YL1001. All rights reserved.
//

#import "ELScanQRCodeCtl.h"
#import <AVFoundation/AVFoundation.h>
#import "ConsultantResumePreviewCtl.h"
#import "ELPersonCenterCtl.h"
#import "ELCompanyScanCodeLoginCtl.h"
#import "ELNewResumePreviewCtl.h"
#import "SalaryIrrigationDetailCtl.h"
#import "CompanyInfo_DataModal.h"
#import "PCLoginAuthCtl.h"

#define CROP_WIDTH ([UIScreen mainScreen].bounds.size.width-80)

typedef NS_ENUM(NSInteger, overlayState)
{
    overlayStateReady,
    overlayStateScanning,
    overlayStateEnd
};
@interface ELScanQRCodeCtl ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIView *overlayView;
    
    NSString *_result;
    NSString *groupId_;
    RequestCon *resumeCon;
    RequestCon *signInCon;
    NSString   *_offerPartyId;
}

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@end

@implementation ELScanQRCodeCtl

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_type isEqualToString:@"1"]) {
        [self setNavTitle:@"扫一扫"];
    }else{
        [self setNavTitle:@"二维码扫描"];
    }
    self.view.backgroundColor = [UIColor blackColor];
    //权限判断
    WS(weakSelf)
    BOOL accessStatus = [[Manager shareMgr] getTheCameraAccessWithCancel:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    if (!accessStatus) {
        return;
    }
    
    [self initOverlayView:overlayStateReady];
    //初始化二维码扫描
    [self initScanQRcode];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self requestFindPeople];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        return;
    }
    [self initOverlayView:overlayStateReady];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initOverlayView:overlayStateScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [_session stopRunning];
    [self initOverlayView:overlayStateReady];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        self.view.backgroundColor = [UIColor blackColor];
    }
//    [overlayView removeFromSuperview];
//    overlayView = [self overlayView:];
//    [self.view addSubview:overlayView];
}

#pragma mark -----------数据请求与刷新－－－－－－－－
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}

-(void)getDataFunction:(RequestCon *)con
{
    if(con == requestCon_){
        NSString *userId = [Manager getUserInfo].userId_;
        [con scanQrcodeWithCompanyId:_inDataModel.companyID_ userId:userId url:_result];
    }
}

//请求是否绑定了企业账号
-(void)requestFindPeople{
    NSString *bodyMsg = [NSString stringWithFormat:@"person_id=%@",[Manager getUserInfo].userId_];
    NSString *function = @"isBindingPerson";
    NSString *op = @"binding_salerperson_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES progressFlag:NO progressMsg:nil success:^(NSURLSessionDataTask *operation, id result){
        NSDictionary *dic = result;
        if ([dic isKindOfClass:[NSDictionary class]]){
            NSString *status = dic[@"status"];
            id dataModel = nil;
            if ([status isEqualToString:@"OK"]) {
                NSString *type = dic[@"type"];
                if ([type isEqualToString:@"2"]){
                    CompanyInfo_DataModal * dataModal = [[CompanyInfo_DataModal alloc] init];
                    dataModal.companyID_ = [dic objectForKey:@"company_id"];
                    dataModel = dataModal;
                    [CommonConfig setDBValueByKey:@"companyID" value:dataModal.companyID_];
                }else{
                    [CommonConfig setDBValueByKey:@"companyID" value:@""];
                }
            }else{
                [CommonConfig setDBValueByKey:@"companyID" value:@""];
            }
            return ;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


-(void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    if (requestCon == signInCon)
    {//offer派扫码签到
        Status_DataModal *model = dataArr[0];
        if ([model.status_ isEqualToString:@"OK"]) {
            [BaseUIViewController showAutoDismissSucessView:@"" msg:model.des_ seconds:1.0];
            OfferPartyDetailIndexCtl *offerPartyDetailCtl = [[OfferPartyDetailIndexCtl alloc]init];
            OfferPartyTalentsModel * offerPartyModel = [[OfferPartyTalentsModel alloc]init];
            offerPartyModel.jobfair_id = _offerPartyId;
            offerPartyModel.iscome = YES;
            offerPartyModel.isjoin = YES;
            offerPartyDetailCtl.offerPartyModel = offerPartyModel;
            offerPartyDetailCtl.isFromZbar = YES;
            [ self.navigationController pushViewController:offerPartyDetailCtl animated:YES];
            [offerPartyDetailCtl beginLoad:nil exParam:nil];
        }else{
            [BaseUIViewController showAutoDismissFailView:@"" msg:model.des_ seconds:1.0];
        }
    }
    else if (requestCon == requestCon_)
    {//企业扫描登陆
        Status_DataModal *dataModal = [dataArr objectAtIndex:0];
        //NSString *code = dataModal.code_;
        if( [dataModal.status_ isEqualToString:Success_Status] ){
            //跳转到认证页面
            PCLoginAuthCtl *authCtl = [[PCLoginAuthCtl alloc]init];
            authCtl.url = _result;
            authCtl.companyId = _inDataModel.companyID_;
            authCtl.companyName = _inDataModel.cname_;
            [self.navigationController pushViewController:authCtl animated:YES];
        }
        else {
            //需要刷新网页
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:dataModal.des_ delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 10000;
            [alertView show];
        }
    }
    else if(type == Request_ResumeZbar)
    {//扫码查看简历预览
        User_DataModal *model = dataArr[0];
        if (_isCompany) {//企业扫码
            ELNewResumePreviewCtl *resumePreviewCtl = [[ELNewResumePreviewCtl alloc] init];
            resumePreviewCtl.resumeListType = ResumeTypeTempSearch;
            resumePreviewCtl.isRecommend = YES;
            resumePreviewCtl.forType = @"0";
            [self.navigationController pushViewController:resumePreviewCtl animated:YES];
            [resumePreviewCtl beginLoad:model exParam:_companyId];
        }
        else
        {//顾问扫码
            ConsultantResumePreviewCtl *consultantResumePreviewCtl = [[ConsultantResumePreviewCtl alloc] init];
            consultantResumePreviewCtl.salerId = _companyId;
            [self.navigationController pushViewController:consultantResumePreviewCtl animated:YES];
            [consultantResumePreviewCtl beginLoad:model exParam:_companyId];
        }
    }
    else if(type == Request_JoinGroup)
    {//加入社群
        Status_DataModal * dataModal = [dataArr objectAtIndex:0];
        if ([dataModal.status_ isEqualToString:Success_Status])
        {
            if ([dataModal.code_ isEqualToString:@"200"]) {
                //审核中
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"申请成功,等待审核" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert show];
            }
            else if ([dataModal.code_ isEqualToString:@"100"]) {
                [BaseUIViewController showAutoDismissSucessView:@"加入成功" msg:nil];
                //刷新社群列表
                Groups_DataModal *data = [[Groups_DataModal alloc] init];
                data.id_ = groupId_;
                ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
                detaliCtl.isZbar = self.isZbar;
                [self.navigationController pushViewController:detaliCtl animated:YES];
                [detaliCtl beginLoad:data exParam:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CREATEGROUPSUCCESS" object:nil];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dataModal.des_ delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }
}

#pragma mark - ---------------初始化二维码扫描--------------
- (void)initScanQRcode
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [self output];
    // Session
    _session = [self session];
    // Preview
    _preview = [self previewLayer];

}

- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        //初始化输出设备
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置扫描区域
        //参照的是横屏左上角的比例，而不是竖屏
        [_output setRectOfInterest:CGRectMake (((( ScreenHeight-CROP_WIDTH)/2)-NavBarHeight)/ScreenHeight ,(( ScreenWidth - CROP_WIDTH)/ 2)/ScreenWidth , CROP_WIDTH /ScreenHeight , CROP_WIDTH /ScreenWidth)];
    }
    return _output;
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
        
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput : self.output ];
//                    NSArray *typeList = self.output.availableMetadataObjectTypes;
            // 条码类型 AVMetadataObjectTypeQRCode
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_preview == nil) {
        //负责图像渲染出来
        _preview =[ AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.view.layer insertSublayer:_preview atIndex:0];
        
    }
    return _preview;
}

- (void)initOverlayView:(overlayState)state
{
    if (state == overlayStateScanning) {
        [_session startRunning];
    }
    [overlayView removeFromSuperview];
    overlayView = [self overlayView:state];
    [self.view addSubview:overlayView];
   
}

- (UIView *)overlayView:(overlayState)state
{
    switch (state) {
        case overlayStateScanning:
        {
            CGSize size = CGSizeMake(ScreenWidth, ScreenHeight);
            UIGraphicsBeginImageContext(size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetRGBFillColor(context, 0, 0, 0, state==overlayStateScanning?0.3:0.9);
            CGContextFillRect(context, CGRectMake(0, -7, ScreenWidth, ScreenHeight-0));
            
            CGFloat   bottomHeight = (ScreenHeight-CROP_WIDTH)/2-NavBarHeight;
            CGFloat   leftWidth = ((( ScreenHeight-CROP_WIDTH)/2)-NavBarHeight) /ScreenHeight;
            CGFloat   originY = (ScreenHeight+CROP_WIDTH)/2-NavBarHeight;
            CGFloat   originX = (ScreenWidth+CROP_WIDTH)/2;
            
            CGFloat lineWidth = 2;
            UIColor *lineColor = [UIColor whiteColor];
            //扫描框4个脚的设置
            CGContextSetLineWidth(context, lineWidth);
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            //左上角
            CGContextMoveToPoint(context, leftWidth+40, bottomHeight+15);
            CGContextAddLineToPoint(context, leftWidth+40, bottomHeight);
            CGContextAddLineToPoint(context, leftWidth+15+40, bottomHeight);
            CGContextStrokePath(context);
            //右上角
            CGContextMoveToPoint(context, originX-15, bottomHeight);
            CGContextAddLineToPoint(context, originX, bottomHeight);
            CGContextAddLineToPoint(context, originX, bottomHeight+15);
            CGContextStrokePath(context);
            //左下角
            CGContextMoveToPoint(context, leftWidth+40, originY-15);
            CGContextAddLineToPoint(context, leftWidth+40,  originY);
            CGContextAddLineToPoint(context, leftWidth+15+40, originY);
            CGContextStrokePath(context);
            //右下角
            CGContextMoveToPoint(context, originX-15, originY);
            CGContextAddLineToPoint(context,  originX,  originY);
            CGContextAddLineToPoint(context,  originX, originY-15);
            CGContextStrokePath(context);
            
            UIImageView *imageLine = [[UIImageView alloc] init];
            imageLine.frame = CGRectMake(ScreenWidth/2.f-CROP_WIDTH/2, (ScreenHeight-CROP_WIDTH)/2.f-NavBarHeight, CROP_WIDTH, 2);
            imageLine.backgroundColor = [UIColor greenColor];
            imageLine.alpha = 0.8;
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
            anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2.f, (ScreenHeight-CROP_WIDTH)/2.f-NavBarHeight)];
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2.f, (ScreenHeight+CROP_WIDTH)/2.f-NavBarHeight)];
            anim.repeatCount = HUGE_VALF;
            anim.autoreverses = YES;
            anim.duration = 1.5;
            [imageLine.layer addAnimation:anim forKey:nil];
            
            CGContextClearRect(context, CGRectMake(ScreenWidth/2.f-CROP_WIDTH/2.f, (ScreenHeight -CROP_WIDTH)/2.f-NavBarHeight, CROP_WIDTH, CROP_WIDTH));
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            imageView.image = img;
            UIGraphicsEndImageContext();
            
            [imageView addSubview:imageLine];
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(0, (ScreenHeight+CROP_WIDTH)/2.f-NavBarHeight+10, ScreenWidth, 30);
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont systemFontOfSize:16];
            textLabel.textColor = [UIColor whiteColor];
            if (_isCompany) {
                textLabel.text = @"扫描人才简历或扫描登录一览";
            }else{
                textLabel.text = @"将二维码放入框内，即可自动扫描";
            }
            
            textLabel.textAlignment = YES;
            [imageView addSubview:textLabel];
            
            return imageView;
        }
            break;
        case overlayStateEnd:
        {
//            [self.loadIndicator startAnimating];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, ScreenHeight/2.f-20-0, ScreenWidth-100, 80)];
            label.numberOfLines = 5;
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 501;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            imageView.image = img;
            UIGraphicsEndImageContext();
            
//            [imageView addSubview:self.loadIndicator];
            [imageView addSubview:label];
            
            return imageView;
        }
            break;
        case overlayStateReady:
        {
//            [self.loadIndicator startAnimating];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, ScreenHeight/2.f-20-0, ScreenWidth-200, 40)];
            label.numberOfLines = 2;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"准备中...";
            label.tag = 501;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            imageView.image = img;
            UIGraphicsEndImageContext();
            
//            [imageView addSubview:self.loadIndicator];
            [imageView addSubview:label];
            
            return imageView;
        }
            break;
        default:
            return nil;
            break;
            
    }
}

#pragma mark - scan result
- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    if ([metadataObjects count ] > 0 )
    {
        // 停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        _result = metadataObject.stringValue ;
    }
    
    [overlayView removeFromSuperview];
    overlayView = [self overlayView:overlayStateEnd];
    [self.view addSubview:overlayView];
    
    NSString *strPersonId = @"";
    BOOL personZbar = NO;
    if ([_result containsString:@"http://m.yl1001.com/u/"])
    {
        strPersonId = [_result substringFromIndex:[@"http://m.yl1001.com/u/" length]];
        NSScanner* scan = [NSScanner scannerWithString:strPersonId];
        int val;
        personZbar = [scan scanInt:&val] && [scan isAtEnd];
    }
    
    if (personZbar)//个人主页
    {
        ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
        [personCtl beginLoad:strPersonId exParam:nil];
        [self.navigationController pushViewController:personCtl animated:YES];
    }
    else if ([_result containsString:@"yl1001.com/article/"] || [_result containsString:@"yl1001.com/xinwen_article/"] || [_result containsString:@"yl1001.com/group_article"])//文章
    {
        NSArray *array = [_result componentsSeparatedByString:@"/"];
        NSString *str = @"";
        if (array.count > 0)
        {
            str = [array lastObject];
        }
        NSArray *array1 = [str componentsSeparatedByString:@"."];
        NSString *str1 =@"";
        if (array1.count > 0)
        {
            str1 = [array1 firstObject];
        }
        
        ArticleDetailCtl *articleDetailCtl = [[ArticleDetailCtl alloc]init];
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        if ([_result containsString:@"group_article"]) {
            articleDetailCtl.isFromGroup_ = YES;
        }
        else if([_result containsString:@"xinwen_article"])
        {
            articleDetailCtl.isFromNews = YES;
        }
        Article_DataModal *article = [[Article_DataModal alloc] init];
        article.id_ = str1;
        [articleDetailCtl beginLoad:article exParam:nil];
    }
    else if([_result containsString:@"yl1001.com/gxs_article/"])//灌薪水
    {
        NSArray *array = [_result componentsSeparatedByString:@"/"];
        NSString *str = @"";
        if (array.count > 0)
        {
            str = [array lastObject];
        }
        NSArray *array1 = [str componentsSeparatedByString:@"."];
        NSString *str1 =@"";
        if (array1.count > 0)
        {
            str1 = [array1 firstObject];
        }
        ELSalaryModel *article = [[ELSalaryModel alloc] init];
        article.article_id = str1;
        article.bgColor_ = [UIColor whiteColor];
        SalaryIrrigationDetailCtl * articleDetailCtl = [[SalaryIrrigationDetailCtl alloc] init];
        [self.navigationController pushViewController:articleDetailCtl animated:YES];
        [articleDetailCtl beginLoad:article exParam:nil];
    }
    else if([_result hasPrefix:QR_PERSON_TYPE])
    {
        NSString *personId = [[_result componentsSeparatedByString:QR_PERSON_TYPE] lastObject];
        ELPersonCenterCtl *personCtl = [[ELPersonCenterCtl alloc] init];
        [personCtl beginLoad:personId exParam:nil];
        [self.navigationController pushViewController:personCtl animated:YES];
    }
    else if ([_result hasPrefix:@"http://www.job1001.com/companyServe/connect/"])
    {//扫描登录
        [self performSelector:@selector(delayTime) withObject:nil afterDelay:0.1];
    }
    else if ([_result containsString:GroupZbar])
    {//社群二维码
        NSString *groupId = [_result substringFromIndex:GroupZbar.length];
        groupId_ = groupId;
        
        Groups_DataModal *data = [[Groups_DataModal alloc] init];
        data.id_ = groupId_;
        ELGroupDetailCtl *detaliCtl = [[ELGroupDetailCtl alloc]init];
        detaliCtl.isZbar = self.isZbar;
        [self.navigationController pushViewController:detaliCtl animated:YES];
        [detaliCtl beginLoad:data exParam:nil];
        /*
         if (!joinCon_) {
         joinCon_ = [self getNewRequestCon:NO];
         }
         [joinCon_ joinGroup:[Manager getUserInfo].userId_ group:groupId content:@""];
         */
    }
    else if([_result containsString:ResumeZbar])
    {//简历预览二维码
        NSString *personId = [_result substringFromIndex:ResumeZbar.length];
        if (_companyId && ![_companyId isEqualToString:@""]) {
            if (!resumeCon) {
                resumeCon = [self getNewRequestCon:NO];
            }
            if (_isCompany) {//企业
                [resumeCon getResumeZbar:personId roletype:@"20" companyId:_companyId];
            }
            else
            {//顾问
                [resumeCon getResumeZbar:personId roletype:@"30" companyId:_companyId];
            }
        }else{
            [BaseUIViewController showAlertView:@"提示" msg:@"请移至企业后台或者顾问后台进行简历扫描..." btnTitle:@"确定"];
        }
    }
    else if ([_result containsString:OfferPai])
    {
        NSRange range = [_result rangeOfString:@"/offerpai/"];
        NSString *offerId = [_result substringFromIndex:(range.location +range.length)];
        
        NSScanner* scan = [NSScanner scannerWithString:offerId];
        int val;
        BOOL isOfferId = [scan scanInt:&val] && [scan isAtEnd];
        
        if (isOfferId) {
            if (_scanResultBlock){
                _scanResultBlock(offerId);
            }else{
                if (!signInCon) {
                    signInCon = [self getNewRequestCon:NO];
                }
                if (!offerId) {
                    return ;
                }
                _offerPartyId = offerId;
                NSString *userId = [Manager getUserInfo].userId_;
                if (!userId) {
                    return;
                }
                [signInCon signInOfferPartyId:offerId userId:userId roleId:userId role:@"10"];
            }
        }else{
            return;
        }
    }
    else if ([_result containsString:@"companyServe/company_app.php?uid"])
    {//App扫码登录企业后台
        ELCompanyScanCodeLoginCtl *companyLoginCtl = [[ELCompanyScanCodeLoginCtl alloc] init];
        [companyLoginCtl beginLoad:_result exParam:nil];
        [self.navigationController pushViewController:companyLoginCtl animated:YES];
    }
    else if ([_result containsString:@"m.job1001.com/act/yilan"] || [_result containsString:@"m.yl1001.com/act/yilan"]){
        PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
        pushurlCtl.isApplication = YES;
        pushurlCtl.backTowCtl = YES;
        [self.navigationController pushViewController:pushurlCtl animated:YES];
        [pushurlCtl beginLoad:[self encryptionCheck] exParam:@"一览客户答谢会"];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否用浏览器打开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 5000;
        [alertView show];
    }
}

#pragma mark ------------ event response -----------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5000) {
        switch (buttonIndex) {
            case 0:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 1:
            {
                NSString *url;
                
                if ([NSString domainNameConstantString:_result]) {
                    url = [self encryptionCheck];
                }
                else{
                    url = _result;
                }
                
                NSLog(@"---- %@",url);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
                break;
            default:
                break;
        }
    }
    else{
        switch (buttonIndex) {
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                break;
        }
    }
}

-(void) backBarBtnResponse:(id)sender
{
    [super backBarBtnResponse:sender];
}

- (void)delayTime
{
    [self beginLoad:nil exParam:nil];
}

#pragma mark ---------------- other -----------------
-(void)updateCom:(RequestCon *)con
{
}

- (NSString *)encryptionCheck
{
    NSString *url;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *md5_personId = [MD5 getMD5:[Manager getUserInfo].userId_];
    NSString *md5_personIdCks = [MD5 getMD5:[NSString stringWithFormat:@"%@%@",timeSp,md5_personId]];
    NSString *md5_companyId = [MD5 getMD5:[CommonConfig getDBValueByKey:@"companyID"]];
    NSString *md5_companyIdCks = [MD5 getMD5:[NSString stringWithFormat:@"%@%@",timeSp,md5_companyId]];
    
    url = [NSString stringWithFormat:@"%@?version=v1&timestamp=%@&person_id=%@&person_id_cks=%@&company_id=%@&company_id_cks=%@",_result,timeSp,[Manager getUserInfo].userId_,md5_personIdCks,[CommonConfig getDBValueByKey:@"companyID"],md5_companyIdCks];
    
    return url;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
