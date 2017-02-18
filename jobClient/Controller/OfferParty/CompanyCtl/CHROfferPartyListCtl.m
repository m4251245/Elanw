//
//  CHRIndexCtl.m
//  jobClient
//
//  Created by 一览ios on 15/6/2.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "CHROfferPartyListCtl.h"
#import "CHROfferPartyList_Cell.h"
#import "CHROfferPartyDetailCtl.h"

@interface CHROfferPartyListCtl ()
{
    
}
@end

@implementation CHROfferPartyListCtl

- (instancetype)init
{
    if (self = [super init]) {
        bFooterEgo_= YES;
        bHeaderEgo_ = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:_companyInfo.companyLogo] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _companyNameLb.text = _companyInfo.cname_;
    
    NSString *startDate = _companyInfo.startDate;
    if (startDate.length > 10) {
        startDate = [startDate substringToIndex:10];
    }
    NSString *endDate = _companyInfo.endDate;
    if (endDate.length > 10) {
        endDate = [endDate substringToIndex:10];
    }
    _statusLb.text = [NSString stringWithFormat:@"%@至%@", startDate, endDate];
    _versionLb.attributedText = [self dealNowTime:_companyInfo.endDate withVersion:_companyInfo.serviceVersion];
    
    CALayer *layer = _companyLogoImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2.f;
    layer.borderWidth = 0.5f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
}

//服务版本设置
-(NSAttributedString *)dealNowTime:(NSString *)endDataStr withVersion:(NSString *)version{
    NSDate *today = [[NSDate alloc] init];
    NSTimeInterval todaytime = [today timeIntervalSince1970];

    NSDate *endDate = [endDataStr dateFormStringCurrentLocaleFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    NSInteger lastTime = (endTime - todaytime)/24/60/60;
    NSString *warnStr;
    if (lastTime > 0) {
        warnStr = [NSString stringWithFormat:@" %ld天到期",(long)lastTime];
    }
    else{
        warnStr = @" 已到期";
    }
    if (version.length == 0) {
        version = @"暂无版本";
    }
    
    NSString *servinceStr = [NSString stringWithFormat:@"%@|%@", version,warnStr];
    
    NSRange range = {version.length,1};
    
    NSMutableAttributedString *serviceAttString = [[NSMutableAttributedString alloc]initWithString:servinceStr];
    [serviceAttString setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xe0e0e0)} range:range];
    return serviceAttString;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    
}

- (void)getDataFunction:(RequestCon *)con
{
    [super updateCom:con];
    [con getOfferPartyListByCompanyId:_companyId pageIndex:requestCon_.pageInfo_.currentPage_ pageSize:20];
}

- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    switch (type) {
        case Request_GetOfferPartyList://offer派列表
            
            break;
            
        default:
            break;
    }
}

- (void)updateCom:(RequestCon *)con
{
    
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return requestCon_.dataArr_.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"CHROfferPartyList_Cell";
    CHROfferPartyList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CHROfferPartyList_Cell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OfferPartyTalentsModel *dataModel = requestCon_.dataArr_[indexPath.row];
    cell.titleLb.text = dataModel.jobfair_name;
    if (dataModel.jobfair_time.length>10) {
        cell.timeLb.text = [dataModel.jobfair_time substringToIndex:10];
    }else{
        cell.timeLb.text = dataModel.jobfair_time;
    }
    
    if (dataModel.isNew) {
        cell.redDotLb.hidden = NO;
    }else{
        cell.redDotLb.hidden = YES;
    }
    cell.addressLb.text = [NSString stringWithFormat:@"地点: %@", dataModel.place_name];
    
    cell.companyLogoImgv.contentMode= UIViewContentModeScaleToFill;
    if ([dataModel.fromtype isEqualToString:@"offer"] || [dataModel.fromtype isEqualToString:@"kpb"] || [dataModel.fromtype isEqualToString:@"vph"] ) {

        
        [cell.companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:dataModel.banner_src] placeholderImage:[UIImage imageNamed:@"chr_offer_party_bg1.png"] options:SDWebImageAllowInvalidSSLCertificates];
        
    }
    else if ([dataModel.fromtype isEqualToString:@"hunter"])
    {
        [cell.companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:dataModel.logo_src] placeholderImage:[UIImage imageNamed:@"chr_offerParty_hunter.png"] options:SDWebImageAllowInvalidSSLCertificates];
    }
    else{
        
        [cell.companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:dataModel.logo_src] placeholderImage:[UIImage imageNamed:@"chr_offer_party_bg1.png"] options:SDWebImageAllowInvalidSSLCertificates];
    }
    
    
   
    return cell;
}

- (void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
    CHROfferPartyDetailCtl *offerDetailCtl = [[CHROfferPartyDetailCtl alloc]init];
    OfferPartyTalentsModel *offerPartyModel = selectData;
    if (offerPartyModel.isNew) {
        CHROfferPartyList_Cell *cell = (CHROfferPartyList_Cell *)[tableView_ cellForRowAtIndexPath:indexPath];
        cell.redDotLb.hidden = YES;
    }
    offerDetailCtl.jobfair_id = offerPartyModel.jobfair_id;
    offerDetailCtl.jobfair_time = offerPartyModel.jobfair_time;
    offerDetailCtl.jobfair_name = offerPartyModel.jobfair_name;
    offerDetailCtl.fromtype = offerPartyModel.fromtype;
    offerDetailCtl.place_name = offerPartyModel.place_name;
    offerDetailCtl.companyId = _companyId;
    [ self.navigationController pushViewController:offerDetailCtl animated:YES];
    [offerDetailCtl beginLoad:nil exParam:nil];
}
@end
