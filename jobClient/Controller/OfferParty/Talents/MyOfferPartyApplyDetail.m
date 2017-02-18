//
//  MyOfferPartyApplyDetail.m
//  jobClient
//
//  Created by 一览ios on 15/6/19.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "MyOfferPartyApplyDetail.h"
#import "MyOfferPartyDetailCtl.h"
#import "PushUrlCtl.h"
#import "ELGroupDetailCtl.h"

@interface MyOfferPartyApplyDetail ()
{
    NSMutableArray *_titleArr;        /**<按钮标题Arr */
    NSMutableArray *_buttonArr;       /**<状态按钮Arr */
    NSMutableArray *_describeArr;     /**<描述Arr */
    IBOutlet UIView *_describeBgView;
 
    IBOutlet NSLayoutConstraint *_describeBgViewHeight;
    IBOutlet NSLayoutConstraint *_redLineViewAutoWidth;
    IBOutlet NSLayoutConstraint *_grayLineAutoWidth;
    
    IBOutlet UILabel *_salaryLb;
    IBOutlet UIImageView *_imageLineOne;
    IBOutlet UILabel *_educationLb;
    IBOutlet UIImageView *_imageLineTwo;
    IBOutlet UILabel *_jobNumLb;
    
    NSMutableDictionary *_nameDic;
}

@end

@implementation MyOfferPartyApplyDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"匹配详情";
    [_companyLogoImgv sd_setImageWithURL:[NSURL URLWithString:_companyModel.logoPath_] placeholderImage:nil];
    _companyNameLb.text = _companyModel.cname_;
    [_companyNameLb sizeToFit];
    _companyJobLb.text = _companyModel.job;
    
    _salaryLb.text = [NSString stringWithFormat:@"￥%@", _companyModel.userModal.salary_];
    _educationLb.text = _companyModel.userModal.eduName_;
    if ([_companyModel.userModal.eduName_ isEqualToString:@""]) {
        _imageLineOne.hidden = YES;
    }
    else
    {
        _imageLineOne.hidden = NO;
    }
    
    _jobNumLb.text = _companyModel.userModal.gzNum_;
    if ([_companyModel.userModal.gzNum_ isEqualToString:@""]) {
        _imageLineTwo.hidden = YES;
    }
    else
    {
        _imageLineTwo.hidden = NO;
    }
    
    CALayer *layer ;
    layer = _companyLogoImgv.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 2.f;
    layer.borderWidth = 0.5f;
    layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    
    [self setButtonState];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat with = ScreenWidth / 5;
    [_recommendBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, (with - 33)/2, 0, 0)];
    [_confirmFitBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, (with - 33)/2, 0, 0)];
    [_interviewBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, (with - 33)/2, 0, 0)];
    [_interviewedBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, (with - 33)/2, 0, 0)];
    [_sendOfferBtn setImageEdgeInsets:UIEdgeInsetsMake(-30, (with - 33)/2, 0, 0)];
}

- (void)setButtonNum
{
    if (_companyModel.userModal.resumeType == 1) {//包含通过初选
        if (_companyModel.jobStatus != 14) {
            [_recommendBtn setTitle:@"已推荐" forState:UIControlStateNormal];
            [_confirmFitBtn setTitle:@"通过初选" forState:UIControlStateNormal];
            [_interviewBtn setTitle:@"等候面试" forState:UIControlStateNormal];
            [_interviewedBtn setTitle:@"初面合格" forState:UIControlStateNormal];
            [_sendOfferBtn setTitle:@"确认录用" forState:UIControlStateNormal];
        }else{
            [_recommendBtn setTitle:@"已推荐" forState:UIControlStateNormal];
            [_confirmFitBtn setTitle:@"通过初选" forState:UIControlStateNormal];
            [_interviewBtn setTitle:@"等候面试" forState:UIControlStateNormal];
            [_interviewedBtn setTitle:@"暂不合适" forState:UIControlStateNormal];
            
            _sendOfferBtn.hidden = YES;
        }
    }
    else
    {
        if (_companyModel.jobStatus == 5 || _companyModel.jobStatus == 12 || _companyModel.jobStatus == 4) {
            //只有单独的 已推荐、已投递、待确定也显示 5 个状态
            [_recommendBtn setTitle:@"已推荐" forState:UIControlStateNormal];
            [_confirmFitBtn setTitle:@"通过初选" forState:UIControlStateNormal];
            [_interviewBtn setTitle:@"等候面试" forState:UIControlStateNormal];
            [_interviewedBtn setTitle:@"初面合格" forState:UIControlStateNormal];
            [_sendOfferBtn setTitle:@"确认录用" forState:UIControlStateNormal];
        }
//        else if (_companyModel.jobStatus == 14){
//            [_recommendBtn setTitle:@"已推荐" forState:UIControlStateNormal];
//            [_confirmFitBtn setTitle:@"暂不合适" forState:UIControlStateNormal];
//            
//            _interviewBtn.hidden = YES;
//            _interviewedBtn.hidden = YES;
//            _sendOfferBtn.hidden = YES;
//        }
        else
        {
            [_recommendBtn setTitle:@"已推荐" forState:UIControlStateNormal];
            [_confirmFitBtn setTitle:@"等候面试" forState:UIControlStateNormal];
            [_interviewBtn setTitle:@"初面合格" forState:UIControlStateNormal];
            [_interviewedBtn setTitle:@"确认录用" forState:UIControlStateNormal];
            
            _sendOfferBtn.hidden = YES;
        }
    }
}

- (void)setButtonState
{
    /**
     * 0.可投递简历
     * 1.确认录用
     * 2.通过初选(1.顾问推荐 ，2主动投递)
     * 3.面试合格
     * 4:人才自己投递(等待面试)
     * 5:顾问推荐
     * 7.等待面试
     * 10.不通过初选
     * 11.面试不合格
     * 12.待确定
     * 14.放弃面试
     */
    
    //_companyModel.userModal.resumeType :1 通过初选  2 不通过初选  3 待确定
    CGFloat btnWidth = ScreenWidth / 5;
    NSString *toudiStr = @"";
    NSString *toudiDescribe = @"";
    
    switch (_companyModel.jobStatus) {
        case 1:
        {//1.确认录用
            
            if ([_companyModel.userModal.deliverState isEqualToString:@"4"]) {//人才自己投递
                toudiStr = @"已投递";
                toudiDescribe = @"你已向该公司投递了你的简历！";
            }
            else
            {
                toudiStr = @"已推荐";
                toudiDescribe = @"顾问推荐了你的简历!";
            }
            
            if (_companyModel.userModal.resumeType == 1) {//包含通过初选
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"企业向你发送了offer!", @"初次面试合格！", @"等候面试!", @"你已通过公司的初步筛选!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"通过初选", @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn,_interviewedBtn, _sendOfferBtn,  nil];
            }
            else
            {
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"企业向你发送了offer!", @"初次面试合格！", @"等候面试!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn,_interviewedBtn, nil];
            }
        }
            break;
        case 2:
        {//通过初选(1.顾问推荐 ，2主动投递)
            if ([_companyModel.userModal.deliverState isEqualToString:@"4"]) {//人才自己投递
                toudiStr = @"已投递";
                toudiDescribe = @"你已向该公司投递了你的简历！";
            }
            else
            {
                toudiStr = @"已推荐";
                toudiDescribe = @"顾问推荐了你的简历!";
            }
            
            if (_companyModel.userModal.resumeType == 1) {//包含通过初选
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"你已通过公司的初步筛选!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr,@"通过初选", @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, nil];
            }
            else
            {
                _describeArr = [[NSMutableArray alloc] initWithObjects:toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, nil];
            }
            
        }
            break;
        case 3:
        {//面试合格
            if ([_companyModel.userModal.deliverState isEqualToString:@"4"]) {//人才自己投递
                toudiStr = @"已投递";
                toudiDescribe = @"你已向该公司投递了你的简历！";
            }
            else
            {
                toudiStr = @"已推荐";
                toudiDescribe = @"顾问推荐了你的简历!";
            }
            
            if (_companyModel.userModal.resumeType == 1) {//包含通过初选
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"初次面试合格!", @"等候面试!", @"你已通过公司的初步筛选!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:@"已推荐", @"通过初选", @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn,_interviewedBtn, nil];
            }
            else
            {
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"初次面试合格!", @"等候面试!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:@"已推荐", @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn, nil];
            }
        }
            break;
        case 4:
        {//人才自己投递(等待面试)
            _recommendBtn.selected = YES;
            [_recommendBtn setTitle:@"已投递" forState:UIControlStateSelected];
            
            _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, nil];
            _describeArr = [[NSMutableArray alloc] initWithObjects:@"你已向该公司投递了你的简历！", nil];
            
        }
            break;
        case 5: //顾问推荐
        case 12: //待确定
        {
            
            _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, nil];
            _describeArr = [[NSMutableArray alloc] initWithObjects:@"顾问推荐了你的简历!", nil];
        }
            break;
        case 7:
        {//等待面试
            
            if ([_companyModel.userModal.deliverState isEqualToString:@"4"]) {//人才自己投递
                toudiStr = @"已投递";
                toudiDescribe = @"你已向该公司投递了你的简历！";
            }
            else
            {
                toudiStr = @"已推荐";
                toudiDescribe = @"顾问推荐了你的简历!";
            }

            
            if (_companyModel.userModal.resumeType == 1) {//包含通过初选
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"等候面试!", @"你已通过公司的初步筛选!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"通过初选", @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn, nil];
            }
            else
            {
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"等候面试!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"等候面试", @"初面合格", @"确认录用", nil];
                _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, nil];
            }
            
        }
            break;
        case 10:
        case 14:
        {//不通过初选
            [self NotThroughPrimaryOrInterviewIsUnqualified];
            
            if ([_companyModel.userModal.deliverState isEqualToString:@"4"]) {//人才自己投递
                toudiStr = @"已投递";
                toudiDescribe = @"你已向该公司投递了你的简历！";
            }
            else
            {
                toudiStr = @"已推荐";
                toudiDescribe = @"顾问推荐了你的简历!";
            }
            
            _describeArr = [[NSMutableArray alloc] initWithObjects: @"你与公司用人需求不符合，暂不合适！",toudiDescribe, nil];
            _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"暂不合适", nil];
        }
            break;
        case 11:
        {//面试不合格
            [self NotThroughPrimaryOrInterviewIsUnqualified];
            
            if ([_companyModel.userModal.deliverState isEqualToString:@"4"]) {//人才自己投递
                toudiStr = @"已投递";
                toudiDescribe = @"你已向该公司投递了你的简历！";
            }
            else
            {
                toudiStr = @"已推荐";
                toudiDescribe = @"顾问推荐了你的简历!";
            }
            
            if (_companyModel.userModal.resumeType == 1) {//包含通过初选
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"你与公司用人需求不符合，暂不合适!", @"等候面试!", @"你已通过公司的初步筛选！", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"通过初选", @"等候面试", @"暂不合适", nil];
            }
            else
            {
                _describeArr = [[NSMutableArray alloc] initWithObjects:@"你与公司用人需求不符合，暂不合适!", @"等候面试!", toudiDescribe, nil];
                _titleArr = [[NSMutableArray alloc] initWithObjects:toudiStr, @"等候面试", @"暂不合适", nil];
            }
            
        }
            break;
        default:
            break;
    }
    
    [self setButtonNum];
    [self selectedBtnWithTitleArr:_buttonArr];
    _redLineViewAutoWidth.constant = (_buttonArr.count - 1) * btnWidth;
    
    if (_companyModel.userModal.resumeType == 1) {//包含通过初选
        
        if (_companyModel.jobStatus == 10 || _companyModel.jobStatus == 14) {//不通过初选
            _grayLineAutoWidth.constant = 0;
        }
        else if (_companyModel.jobStatus == 11)
        {//面试不合格
            _grayLineAutoWidth.constant = (4 - _buttonArr.count) * btnWidth;
        }
        else
        {
            _grayLineAutoWidth.constant = (5 - _buttonArr.count) * btnWidth;
        }
    }
    else
    {
        if (_companyModel.jobStatus == 10 || _companyModel.jobStatus == 14) {//不通过初选
            _grayLineAutoWidth.constant = 0;
        }
        else if (_companyModel.jobStatus == 11)
        {//面试不合格
            _grayLineAutoWidth.constant = (3 - _buttonArr.count) * btnWidth;
        }
        else if (_companyModel.jobStatus == 5 || _companyModel.jobStatus == 12 || _companyModel.jobStatus == 4)
        {
            _grayLineAutoWidth.constant = (5 - _buttonArr.count) * btnWidth;
        }
        else
        {
            _grayLineAutoWidth.constant = (4 - _buttonArr.count) * btnWidth;
        }
    }
    
    [self describeLbLayout];
}

//更改状态按钮图片
- (void)selectedBtnWithTitleArr:(NSMutableArray *)buttonArr
{
    for (NSInteger i= 0; i < buttonArr.count; i++) {
        UIButton *selectedBtn = [buttonArr objectAtIndex:i];
        
        NSString *string = _titleArr[i];
        [selectedBtn setTitle:string forState:UIControlStateSelected];
        
        
        if (i == buttonArr.count - 1) {
            [selectedBtn setImage:[UIImage imageNamed:@"select_04.png"] forState:UIControlStateSelected];
        }
        
        if ([string isEqualToString:@"暂不合适"]) {
            [selectedBtn setImage:[UIImage imageNamed:@"unselect_03.png"] forState:UIControlStateSelected];
        }
        
        selectedBtn.selected = YES;
    }
}

//文案描述
- (void)describeLbLayout
{
    CGFloat labelY = CGRectGetMaxY(_recommendBtn.frame) + 10;
    CGFloat imageY = CGRectGetMaxY(_recommendBtn.frame) + 15;
    
    for (NSInteger i = 0; i < _describeArr.count; i++) {
        
        NSString *describeStr = [_describeArr objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageY, 10, 10)];
        imageView.image = [UIImage imageNamed:@"apply_unselect.png"];
        [_describeBgView addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, labelY, ScreenWidth - 35 - 10, 21)];
        label.font = FOURTEENFONT_CONTENT;
        label.textColor = UIColorFromRGB(0x333333);
        label.text = describeStr;
        [_describeBgView addSubview:label];
        
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"img_select_on.png"];
            label.textColor = [UIColor redColor];
        }
        
        labelY = CGRectGetMaxY(label.frame) + 20;
        imageY = CGRectGetMaxY(label.frame) + 25;
        
        
        //等候面试时显示排队人数和状态描述
        if (_describeArr.count > 1 && i != _describeArr.count - 1) {
            
            UIView *lineView = nil;
            if (!lineView) {
                lineView = [[UIView alloc] initWithFrame:CGRectMake(imageView.center.x - 1, imageView.center.y + 5, 1, 35)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [_describeBgView addSubview:lineView];
            }
            
            if (i == 0 && [describeStr isEqualToString:@"等候面试!"]) {
                
                UILabel *interviewLb = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(label.frame) + 5, 100, 21)];
                interviewLb.backgroundColor = UIColorFromRGB(0xEDEDED);
                interviewLb.textColor = UIColorFromRGB(0x666666);
                interviewLb.font = FOURTEENFONT_CONTENT;
                [_describeBgView addSubview:interviewLb];
                
                
                if (_companyModel.userModal.joinstate == 1)
                {
                    interviewLb.text = @"你已离场";
                }
                else
                {
                    NSInteger waitNum = _companyModel.userModal.waiteNum.intValue;
                    
                    NSString *waiNumStr = [NSString stringWithFormat:@"%ld", (long)labs(waitNum)];
                    if (waitNum != 0) {
                        UILabel *countLb = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(label.frame) + 5, 100, 21)];
                        countLb.backgroundColor = UIColorFromRGB(0xEDEDED);
                        countLb.textColor = UIColorFromRGB(0x666666);
                        countLb.font = FOURTEENFONT_CONTENT;
                        [_describeBgView addSubview:countLb];
                        
                        if (waitNum > 0) {
                            NSString *str = [NSString stringWithFormat:@"你前面还有%ld人", labs(waitNum)];
                            
                            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
                            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, waiNumStr.length)];
                            countLb.attributedText = mutableStr;
                            
                            
                            interviewLb.text = @"你已进入公司排队队伍";
                        }
                        else if (waitNum < 0)
                        {
                            NSString *str = [NSString stringWithFormat:@"过号了你前面还有%ld人", labs(waitNum)];
                            
                            NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
                            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, waiNumStr.length)];
                            countLb.attributedText = mutableStr;
                            
                            interviewLb.text = @"你被延迟了面试，请留意！";
                        }
                        
                        [countLb sizeToFit];
                        interviewLb.frame = CGRectMake(35, CGRectGetMaxY(countLb.frame) + 5, 100, 21);
                        
                    }
                    else
                    {
                        interviewLb.text = @"将轮到你面试，请耐心等候通知!";
                    }
                }
                
                [interviewLb sizeToFit];
                
                labelY = CGRectGetMaxY(interviewLb.frame) + 15;
                imageY = CGRectGetMaxY(interviewLb.frame) + 20;
                
                CGRect lineViewFrame = lineView.frame;
                lineViewFrame.size.height = CGRectGetMaxY(interviewLb.frame) - CGRectGetMaxY(imageView.frame) + 20;
                lineView.frame = lineViewFrame;
            }
        }
    }
    
    _describeBgViewHeight.constant = labelY + 20;
}


//不通过初选 或 面试不合格
- (void)NotThroughPrimaryOrInterviewIsUnqualified
{
    
    _interviewedBtn.hidden = YES;
    _sendOfferBtn.hidden = YES;
    
    if (_companyModel.jobStatus == 10 || _companyModel.jobStatus == 14) {//不通过初选
        
        _interviewBtn.hidden = YES;
        _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, nil];
    }
    else if (_companyModel.jobStatus == 11)
    {//面试不合格
        
        if (_companyModel.userModal.resumeType == 1) {//包含通过初选
            _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn,_interviewedBtn, nil];
            _interviewedBtn.hidden = NO;
        }
        else
        {
            _buttonArr = [[NSMutableArray alloc] initWithObjects:_recommendBtn, _confirmFitBtn, _interviewBtn, nil];
        }
    }
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
    [self getDataFunction:nil];
}

- (void)getDataFunction:(RequestCon *)con
{
    NSString * function = @"get_company_group_article";
    NSString * op = @"groups_busi";
    NSString *companyId = _companyModel.companyID_;
    NSString *bodyMsg = [NSString stringWithFormat:@"company_id=%@&", companyId];
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSDictionary *dic = result;
        NSString *status = dic[@"data"][@"status"];
        if ([status isEqualToString:Success_Status]) {
            [_articleImgv sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"info"][@"thumb"]] placeholderImage:nil];
            _articleTitleLb.text = dic[@"data"][@"info"][@"title"];
            _articleContentLb.text = dic[@"data"][@"info"][@"summary"];
            [_articleContentLb sizeToFit];
            _groupId = dic[@"data"][@"info"][@"qi_id"];
        }else{
            _articleView.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        _articleView.hidden = YES;
    }];
    
}

- (void)btnResponse:(id)sender
{
    if (sender == _showCompanyDetailBtn) {
        ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
        dataModel.companyID_ = _companyModel.companyID_;
        dataModel.zwID_ = _companyModel.jobId;
        dataModel.companyName_ = _companyModel.cname_;
        dataModel.companyLogo_ = _companyModel.logoPath_;
        PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
        positionCtl.offerPartyFlag = YES; //offer派入口
        positionCtl.type_ = 4;
        [self.navigationController pushViewController:positionCtl animated:YES];
        [positionCtl beginLoad:dataModel exParam:nil];
    }else if (sender == _moreArticleBtn){//更多讨论专区
        if (!_groupId) {
            return;
        }
        ELGroupDetailCtl *detailCtl = [[ELGroupDetailCtl alloc]init];
        Groups_DataModal *dataModal = [[Groups_DataModal alloc] init];
        dataModal.id_ = _groupId;
        [self.navigationController pushViewController:detailCtl animated:YES];
        [detailCtl beginLoad:dataModal exParam:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
