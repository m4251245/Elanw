//
//  TagSelected_ViewController.m
//  jobClient
//
//  Created by 一览ios on 16/7/28.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "TagSelected_ViewController.h"
#import "CustomTagButton.h"
#import "MyConfig.h"
#import "NSString+Size.h"

#import "TagDataModel.h"

#define FIRST_LEVEL_W 80
#define MARGIN_LEFT 15
#define MARGIN_TOP 15

#define kBtn_Tag 333330

@interface TagSelected_ViewController ()<UIScrollViewDelegate>{
    NSMutableArray *dataArr;
    NSMutableArray *selectedArr;
}
@property (weak, nonatomic) IBOutlet UIScrollView *conScroll;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *tagNumLb;

@end

@implementation TagSelected_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configUI];
    
}

#pragma mark--初始化UI
-(void)configUI{
    [self rightButtonItemWithTitle:@"确定"];
    [self leftButtonItem:@"back_white_new"];
    [self setNavTitle:@"企业亮点标签"];
}

-(void)createBtn{
    CGFloat lastX = 15;
    CGFloat lastY = 55;
    for (int i = 0; i < dataArr.count; i++) {
        TagDataModel *tagVO = dataArr[i];
        NSDictionary *tagDic = tagVO.tag_info;
        CustomTagButton *button = [[CustomTagButton alloc]init];
        [button setTitle:tagDic[@"ylt_name"] forState:UIControlStateNormal];
        button.titleLabel.font = FIFTEENFONT_TITLE;
        button.tag = kBtn_Tag + i;
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xffffff)];
        CGRect frame = [self setButtonTitle:tagDic[@"ylt_name"] button:button lastX:&lastX lastY:&lastY];
        UIView *deleteView = [self getDeleteView:button];
        frame.size.width += 15;
        deleteView.frame = frame;
        [_bgView addSubview:deleteView];
        
        for (int j = 0; j < _tagMarkArr.count; j++) {
            if ([tagDic[@"ylt_name"] isEqualToString:_tagMarkArr[j][@"ylt_name"] ]) {
                button.isSeleted_ = YES;
                [selectedArr addObject:button];
                [self settingBtnStatus:button];
            }
        }
        
        [button addTarget:self action:@selector(selectedTagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
   
}

#pragma mark--加载数据
-(void)loadData{
    dataArr = [NSMutableArray array];
    selectedArr = [NSMutableArray array];
    [self requestData];
}

#pragma mark--数据请求
-(void)requestData{
    //组装请求参数
    NSString *function = @"getAllTag";
    NSString *op = @"company_info_busi";
    [ELRequest postbodyMsg:@"" op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        for (NSDictionary *dataDic in result) {
            TagDataModel *tagVO = [TagDataModel new];
            [tagVO setValuesForKeysWithDictionary:dataDic];
            [dataArr addObject:tagVO];
        }
        [self createBtn];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

-(void)refreshData{
    [BaseUIViewController showLoadView:YES content:nil view:nil];

    NSString *tag;
    if (selectedArr.count > 0) {
        CustomTagButton *firstbtn = selectedArr[0];
        tag = firstbtn.titleLabel.text;
    }
    for (int i = 1; i < selectedArr.count; i++) {
        CustomTagButton *btn = selectedArr[i];
        tag = [tag stringByAppendingFormat:@",%@",btn.titleLabel.text];
    }
    //组装请求参数
    NSString * bodyMsg = [NSString stringWithFormat:@"company_id=%@&tagStr=%@",_companyId,tag];
    NSString *function = @"editCompanyTags";
    NSString *op = @"company_info_busi";
    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result) {
        NSString *status = result[@"status"];
        if ([status isEqualToString:@"TRUE"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < selectedArr.count; i++) {
                CustomTagButton *btn = selectedArr[i];
                [arr addObject:btn.titleLabel.text];
            }
            if (_myBlock) {
                _myBlock(arr);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [BaseUIViewController showLoadView:NO content:nil view:nil];
    }];
}

#pragma mark--代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

#pragma mark--事件
-(void)leftBtnClick:(id)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick:(id)button{
    [self refreshData];
    
}

//选中与取消
-(void)selectedTagBtnClick:(CustomTagButton *)btn{
    if (btn.isSeleted_) {
        btn.isSeleted_ = NO;
        [btn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.layer.borderColor = UIColorFromRGB(0xbdbdbd).CGColor;
        [selectedArr removeObject:btn];
    }
    else{
        if (selectedArr.count < 10) {
            btn.isSeleted_ = YES;
            [btn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
            [selectedArr addObject:btn];
        }
        else{
            
        }
    }
   _tagNumLb.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)selectedArr.count];
    NSLog(@"......");
}
#pragma mark--通知

#pragma mark--业务逻辑
-(void)settingBtnStatus:(CustomTagButton *)btn{
    [btn setBackgroundColor:UIColorFromRGB(0xe13e3e)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderColor = UIColorFromRGB(0xe13e3e).CGColor;
    _tagNumLb.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)selectedArr.count];
}

- (UIView *)getDeleteView:(UIButton *)btn
{
    UIView *view = [[UIView alloc]initWithFrame:btn.bounds];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:btn];
    return view;
}

#pragma mark-计算根据文字计算宽度 返回frame
-(CGRect) setButtonTitle:(NSString *)title button:(UIButton*) button lastX:(CGFloat *)lastX lastY:(CGFloat *)lastY{
    CGSize titleSize = [title sizeNewWithFont:button.titleLabel.font];
    titleSize.height = 30;
    button.layer.cornerRadius = 15;
    titleSize.width += 32;
    if (*lastX + titleSize.width + MARGIN_LEFT > ScreenWidth) {
        *lastX = MARGIN_LEFT;
        *lastY += titleSize.height + MARGIN_TOP;
    }
    CGRect frame = CGRectMake(*lastX, *lastY, titleSize.width, titleSize.height);
    [button setFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    *lastX += titleSize.width + MARGIN_LEFT;
    return frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
