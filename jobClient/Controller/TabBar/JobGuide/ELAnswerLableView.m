//
//  ELAnswerLableView.m
//  jobClient
//
//  Created by 一览iOS on 16/9/12.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELAnswerLableView.h"
#import "ELAnswerLableModel.h"
#import "myJobGroupSearchCtr.h"
#import "JobGuideTypeAQListCtl.h"

@interface ELAnswerLableView()
{
    NSMutableArray *dataArr;
    NSMutableArray *dataModelArr;
}
@end

@implementation ELAnswerLableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [self initWithMaxCount:7];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithMaxCount:(NSInteger)count{
    self = [super init];
    if (self){
        _oneLineMaxCount = 0;
        dataArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<count;i++) {
            UILabel *lable = [self getLableWithTag:i];
            [dataArr addObject:lable];
            [self addSubview:lable];
        }
    }
    return self;
}

-(UILabel *)getLableWithTag:(NSInteger)tag
{
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:12];
    lable.clipsToBounds = YES;
    lable.layer.cornerRadius = 2.0;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.userInteractionEnabled = YES;
    lable.tag = 100+tag;
    [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];
    return lable;
}

-(void)labelTap:(UITapGestureRecognizer *)sender
{
    if (sender.view.tag-100 < dataModelArr.count){
        ELAnswerLableModel *model = dataModelArr[sender.view.tag-100];
        if (model.colorType == CyanColorType){
            NSArray *arr = @[@"简历指导",@"职业定位",@"职业困惑",@"薪酬行情",@"晋升通道",@"面试技巧",@"志愿填报",@"劳动法规",@"其他类型"];
            if ([arr containsObject:model.name]){
                NSArray *typeArray = @[
                              @{@"title":@"简历指导",@"img":@"resumeBgImg",@"type":@"2"},
                              @{@"title":@"职业定位",@"img":@"jobLocationBgImg",@"type":@"1"},
                              @{@"title":@"职业困惑",@"img":@"puzziBgImg",@"type":@"5"},
                              @{@"title":@"薪酬行情",@"img":@"salaryBgImg",@"type":@"4"},
                              @{@"title":@"晋升通道",@"img":@"promotionBgImg",@"type":@"6"},
                              @{@"title":@"面试技巧",@"img":@"mailBgImg",@"type":@"3"},
                              @{@"title":@"志愿填报",@"img":@"volunteerBgImg",@"type":@"8161394610695137"},
                              @{@"title":@"劳动法规",@"img":@"laborBgImg",@"type":@"2251394610721631"},
                              @{@"title":@"其他类型",@"img":@"otherTypeBgImg",@"type":@"0"}];
                NSDictionary *dic = [typeArray objectAtIndex:[arr indexOfObject:model.name]];
                NSString *title = dic[@"title"];
                NSString *type = dic[@"type"];
                JobGuideTypeAQListCtl *typeAQList = [[JobGuideTypeAQListCtl alloc] init];
                typeAQList.hidesBottomBarWhenPushed = YES;
                [[Manager shareMgr].centerNav_ pushViewController:typeAQList animated:YES];
                [typeAQList beginLoad:type exParam:title];
            }else{
                myJobGroupSearchCtr *ctl = [[myJobGroupSearchCtr alloc] init];
                ctl.hidesBottomBarWhenPushed = YES;
                ctl.keyWord = model.name;
                [[Manager shareMgr].centerNav_ pushViewController:ctl animated:YES];
            }
        }else{
            NSString *title = @"行业问答";
            NSString *type = @"8581399449565705";
            JobGuideTypeAQListCtl *typeAQList = [[JobGuideTypeAQListCtl alloc] init];
            if ([title isEqualToString:@"行业问答"]) {
                typeAQList.showTradeChange = YES;
            }
            typeAQList.tradeModel = model.tradeModel;
            typeAQList.hidesBottomBarWhenPushed = YES;
            [[Manager shareMgr].centerNav_ pushViewController:typeAQList animated:YES];
            [typeAQList beginLoad:type exParam:title];
        }
    }
}

-(void)giveDataModalWithArr:(NSArray *)arr
{
    if (arr){
        dataModelArr = [[NSMutableArray alloc] initWithArray:arr];
        if (arr.count > dataArr.count){
            for (NSInteger i = 0;i<arr.count-dataArr.count;i++) {
                UILabel *lable = [self getLableWithTag:i];
                [dataArr addObject:lable];
                [self addSubview:lable];
            }
        }
        CGRect oldFrame = CGRectZero;
        for (NSInteger i=0;i<dataArr.count;i++){
            UILabel *lable = dataArr[i];
            if (i<arr.count) {
                lable.hidden = NO;
                ELAnswerLableModel *model = arr[i];
                lable.text = model.name;
                switch (model.colorType) {
                    case GrayColorType:
                    {
                        lable.textColor = UIColorFromRGB(0x757575);
                        lable.backgroundColor = UIColorFromRGB(0xf5f5f5);
                    }
                        break;
                    case CyanColorType:
                    {
                        lable.textColor = UIColorFromRGB(0x4570aa);
                        lable.backgroundColor = UIColorFromRGB(0xecf4f8);
                    }    
                        break; 
                    default:
                        break;
                }
                [lable sizeToFit];
                [self setFrameWithLable:lable frame:oldFrame];
                oldFrame = lable.frame;
            }else{
                lable.hidden = YES;
            }
        }
        CGRect frame = self.frame;
        frame.size.height = CGRectGetMaxY(oldFrame);
        self.frame = frame;
    }
}

-(CGFloat)getViewHeightWithModel:(NSArray *)arr{
    CGRect oldFrame = CGRectZero;
    if (arr.count > dataArr.count){
        for (NSInteger i = 0;i<arr.count-dataArr.count;i++) {
            UILabel *lable = [self getLableWithTag:i];
            [dataArr addObject:lable];
            [self addSubview:lable];
        }
    }
    for (NSInteger i=0;i<arr.count;i++){
        ELAnswerLableModel *model = arr[i];
        UILabel *lable = dataArr[i];
        lable.text = model.name;
        [lable sizeToFit];
        [self setFrameWithLable:lable frame:oldFrame];
        oldFrame = lable.frame;
    }
    return CGRectGetMaxY(oldFrame);
}

-(void)setFrameWithLable:(UILabel *)lable frame:(CGRect)oldFrame{
    if (oldFrame.size.height > 0){
        if ((CGRectGetMaxX(oldFrame)+10+lable.width+12) >= self.frame.size.width || [self oneLineMaxCountChange:lable.tag-100]){
            lable.frame = CGRectMake(0,CGRectGetMaxY(oldFrame)+7,lable.width+12,lable.height+8);
        }else{
            lable.frame = CGRectMake(CGRectGetMaxX(oldFrame)+10,oldFrame.origin.y,lable.width+12,lable.height+8);
        }
        
    }else{
        lable.frame = CGRectMake(0,0,lable.width+12,lable.height+8);
    }
}

-(BOOL)oneLineMaxCountChange:(NSInteger)index{
    if (_oneLineMaxCount > 0) {
        if (index%_oneLineMaxCount == 0){
            return YES;
        }
    }
    return NO;
}

-(void)setNoClick:(BOOL)noClick{
    for (UILabel *label in dataArr) {
        if (noClick) {
           label.userInteractionEnabled = NO; 
        }else{
            label.userInteractionEnabled = YES;
        }
    }
}


@end
