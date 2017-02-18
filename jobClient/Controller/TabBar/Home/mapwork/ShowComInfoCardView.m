//
//  ShowComInfoCardView.m
//  ImgCircleDemo
//
//  Created by 一览ios on 16/10/9.
//  Copyright © 2016年 一览ios. All rights reserved.
//

#import "ShowComInfoCardView.h"
#import "NearPositionDataModel.h"
#define SCREEN_WIDTH self.bounds.size.width
#define SCREEN_HEIGHT self.bounds.size.height
#define GRAYCOLOR [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]
static int floatX = 10;
@interface ShowComInfoCardView(){
    UIView *bgView;
    UILabel *companyNameLb;
    UILabel *jobNameLb;
    UILabel *coditionLb;
}

@end


@implementation ShowComInfoCardView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

#pragma mark--初始化UI
-(void)configUI{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT)];
    bgView.layer.cornerRadius = 2.0;
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [bgView addGestureRecognizer:tap];
    bgView.userInteractionEnabled = YES;
    
    [self addSubview:bgView];
    
    companyNameLb = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.origin.x + 10, 6, bgView.frame.size.width - 20, 30)];
    [companyNameLb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14]];
    [companyNameLb setTextColor:[UIColor blackColor]];
    
    jobNameLb = [[UILabel alloc]initWithFrame:CGRectMake(companyNameLb.frame.origin.x, 45, bgView.frame.size.width - 20, 20)];
    jobNameLb.textColor = [UIColor blueColor];
    jobNameLb.font = [UIFont fontWithName:@"STHeitiSC-Light" size:12];
    
    coditionLb = [[UILabel alloc] initWithFrame:CGRectMake(companyNameLb.frame.origin.x, 70, bgView.frame.size.width - 20, 20)];
    [coditionLb setTextColor:[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [coditionLb setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:12]];
    
    [self addSubview:companyNameLb];
    [self addSubview:jobNameLb];
    [self addSubview:coditionLb];
    
    UILabel *tagLb0 = [[UILabel alloc]init];
    UILabel *tagLb1 = [[UILabel alloc]init];
    UILabel *tagLb2 = [[UILabel alloc]init];
    
    tagLb0.tag = 111113;
    tagLb1.tag = 111114;
    tagLb2.tag = 111115;
    [self LabelSetting:tagLb0];
    [self LabelSetting:tagLb1];
    [self LabelSetting:tagLb2];
}

//model setter
-(void)setModel:(NearPositionDataModel *)model{
    _model = model;
    companyNameLb.text = model.cname;
    jobNameLb.text = model.jtzw;
    
    NSString *conditionStr = [NSString stringWithFormat:@"%@ | %@ | %@",model.gznum,model.jobtypes,model.salary];
    [coditionLb setText:conditionStr];
    
    [self benefitsShow:model.com_tag];
}

#pragma mark--事件
-(void)clickTap:(UITapGestureRecognizer *)tap{
    ZWDetail_DataModal * dataModel =[[ZWDetail_DataModal alloc] init];
    dataModel.companyID_ = _model.uid;
    dataModel.companyName_ = _model.cname;
    dataModel.zwID_ = _model.positionId;
    dataModel.companyLogo_ = _model.logopath;
    PositionDetailCtl *positionCtl = [[PositionDetailCtl alloc]init];
    positionCtl.type_ = 1;  //职位详情
    [[self viewController].navigationController pushViewController:positionCtl animated:YES];
    [positionCtl beginLoad:dataModel exParam:nil];
}

//福利待遇数据处理
-(void)benefitsShow:(id)array{
    if ([array count] > 0) {
        
        UILabel *tagLb0 = [self viewWithTag:111113];
        UILabel *tagLb1 = [self viewWithTag:111114];
        UILabel *tagLb2 = [self viewWithTag:111115];
        
        NSMutableArray *fldyArr = [NSMutableArray array];
      
        for (NSDictionary *dic in array) {
            [fldyArr addObject:dic[@"tag_name"]];
        }
       
        for (NSInteger i=[fldyArr count] - 1; i>=0; i--) {
            NSString *tagStr = fldyArr[i];
            
            
        CGSize size = [tagStr sizeNewWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10] forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
            size.width = size.width + 4;
            switch (i) {
                case 2:
                {
                    [tagLb2 setFrame:CGRectMake(bgView.frame.size.width-floatX-size.width, 45, size.width, 14)];
                    [tagLb2 setText:tagStr];
                    tagLb2.hidden = NO;
                }
                    break;
                case 1:
                {
                    [tagLb1 setFrame:CGRectMake(tagLb2.frame.origin.x - size.width - 4, 45, size.width, 14)];
                    
                    [tagLb1 setText:tagStr];
                    tagLb1.hidden = NO;
                }
                    break;
                case 0:
                {
                    [tagLb0 setFrame:CGRectMake(tagLb1.frame.origin.x - size.width - 4, 45, size.width, 14)];
                    
                    [tagLb0 setText:tagStr];
                    tagLb0.hidden = NO;
                }
                    break;
                default:
                    break;
            }
            
        }
        [jobNameLb setFrame:CGRectMake(companyNameLb.frame.origin.x, 45, bgView.frame.size.width - 10 - tagLb0.frame.origin.x, 14)];
    }
    else{
        return;
    }
}

//福利待遇label设置
-(void)LabelSetting:(UILabel *)label{
    label.layer.borderColor = GRAYCOLOR.CGColor;
    label.layer.borderWidth = 0.5;
    [label setBackgroundColor:[UIColor whiteColor]];
    [label setTextColor:GRAYCOLOR];
    [label setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:10]];
    label.hidden = YES;
    [bgView addSubview:label];
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
