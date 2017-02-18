//
//  ELSearchView.m
//  jobClient
//
//  Created by 一览ios on 16/4/15.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELSearchView.h"

//#define SEARCHVIEW_WIDTH   60
//#define SEARCHVIEW_HEIGHT  75
static int SEARCHVIEW_WIDTH = 60;
static int SEARCHVIEW_HEIGHT = 75;

@interface ELSearchView()
{
    BOOL state;
    UIButton *_leftBtn;
}

@property(nonatomic, strong)NSArray *btnSelectArr;
@property(nonatomic, strong)NSArray *placeHolderArr;

@end

@implementation ELSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(110/2, 0, ScreenWidth-110, 44);
        _btnSelectArr = @[@"关键字",@"职位",@"企业"];
        _placeHolderArr = @[@"搜索关键字或简历编号",@"搜索职位名称关键字",@"搜索企业名称关键字"];
        
    }
    return self;
}

- (UIView *)configSearchViewType:(NSInteger)type
{
//    UIView *searchView;
    if (type == 1) {
        [self addSubview:[self configSearchView]];
    }else{
        [self addSubview:[self configSearchViewWithKeywordArray:_btnSelectArr placeHolderArray:_placeHolderArr]];
    }
    return self;
}


- (UIView *)configSearchView
{
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, 200, 24)];
    bgImgv.layer.cornerRadius = 12;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    _keyWordTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 180, 24)];
    _keyWordTF.returnKeyType = UIReturnKeySearch;
    [_keyWordTF setFont:[UIFont systemFontOfSize:14]];
    [_keyWordTF setTextColor:[UIColor blackColor]];
    _keyWordTF.delegate = self;
    [_keyWordTF setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:_keyWordTF];

    return searchView;
}

- (UIView *)configSearchViewWithKeywordArray:(NSArray *)keywordArr placeHolderArray:(NSArray *)placeHolderArr
{
   UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 110, 44)];

    UIImageView *bgImgv = [[UIImageView alloc]init];;
    [bgImgv setFrame:CGRectMake(0, 10, ScreenWidth - 110, 24)];
    bgImgv.layer.cornerRadius = 2;
    bgImgv.layer.masksToBounds = YES;
    [bgImgv setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    [searchView addSubview:bgImgv];
    
    //    添加左侧按钮
   _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitle:@"关键字" forState:UIControlStateNormal];
    _leftBtn.frame = CGRectMake(5, 10, 45, 24);
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [searchView addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //    添加图标
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(_leftBtn.right, 20, 6, 4)];
    img.image = [UIImage imageNamed:@"popoverArrowDown@2x"];
    [searchView addSubview:img];
    
    //    添加线条
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(59, 12, 1, 20)];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [searchView addSubview:lineView];
    
    //    搜索框
    _keyWordTF = [[UITextField alloc] initWithFrame:CGRectMake(62, 10, searchView.frame.size.width - 65, 24)];
    _keyWordTF.returnKeyType = UIReturnKeySearch;
    _keyWordTF.placeholder = @"搜索关键字或简历编号";
    [_keyWordTF setFont:[UIFont systemFontOfSize:13]];
    [_keyWordTF setTextColor:[UIColor blackColor]];
    _keyWordTF.delegate = self;
    [_keyWordTF setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:_keyWordTF];
//    _keyWordTF = keyWorkTF;
    
    
//    _paramDataModel = [[SearchParam_DataModal alloc]init];
    
//    _informalMemberTiPView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:_informalMemberTiPView];
//    [_informalMemberTiPView setHidden:YES];
    
    //   关键字选择背景view
    _searchCon = [[UIView alloc]initWithFrame:CGRectMake(48, 51, SEARCHVIEW_WIDTH, SEARCHVIEW_HEIGHT)];
    _searchCon.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [[UIApplication sharedApplication].keyWindow addSubview:_searchCon];
    [self configBtnSel:keywordArr];
    _searchCon.hidden = YES;

    return searchView;
}

//左侧关键字选择btnClick
-(void)leftBtnClick
{
    if (!state) {
        _searchCon.hidden = NO;
    }
    else{
        _searchCon.hidden = YES;
    }
    NSLog(@"%d",state);
    state = !state;
}


//配置关键字
-(void)configBtnSel:(NSArray *)keywordArr
{
    for (int i = 0; i < keywordArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, SEARCHVIEW_HEIGHT/3 * i, SEARCHVIEW_WIDTH, SEARCHVIEW_HEIGHT/3);
        [btn setTitle:keywordArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_searchCon addSubview:btn];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SEARCHVIEW_HEIGHT/3 * i, SEARCHVIEW_WIDTH, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xececec);
        [_searchCon addSubview:lineView];
    }
}

- (void)btnClick:(UIButton *)btn
{
    NSInteger tag = btn.tag -1000;
    if ([_delegate respondsToSelector:@selector(selectKeywordBtn:)]) {
        [_delegate selectKeywordBtn:btn];
        [_leftBtn setTitle:_btnSelectArr[tag] forState:UIControlStateNormal];
        _keyWordTF.placeholder = _placeHolderArr[tag];
        [self leftBtnClick];
        
    }
}

@end
