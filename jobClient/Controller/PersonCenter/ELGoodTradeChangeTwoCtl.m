//
//  ELGoodTradeChangeTwoCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/11/19.
//  Copyright © 2015年 YL1001. All rights reserved.
//

#import "ELGoodTradeChangeTwoCtl.h"
#import "CustomTagButton.h"
#import "personTagModel.h"

//#define FIRST_LEVEL_W 80
//#define MARGIN_LEFT 15
//#define MARGIN_TOP 10

@interface ELGoodTradeChangeTwoCtl ()
{
    __weak IBOutlet UIScrollView *scrollView_;
    NSMutableArray *tagArr;
    NSMutableArray *selectArr;
}
@end

@implementation ELGoodTradeChangeTwoCtl

-(instancetype)init
{
    self = [super init];
    if (self) {
       rightNavBarStr_ = @"保存"; 
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"擅长行业";
    [self setNavTitle:@"擅长行业"];
    // Do any additional setup after loading the view from its nib.
    selectArr = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [super beginLoad:dataModal exParam:exParam];
}
- (void)getDataFunction:(RequestCon *)con
{
    [con getTradeTagsList];
}
- (void)finishGetData:(RequestCon *)requestCon code:(ErrorCode)code type:(int)type dataArr:(NSArray *)dataArr
{
    [super finishGetData:requestCon code:code type:type dataArr:dataArr];
    
    switch (type) {
        case Request_GetTradeTagsList:
        {
            tagArr = [NSMutableArray arrayWithArray:dataArr];
            [self refreshSelectedTag];
        }
            break;
            
        default:
            break;
    }
}

- (void)refreshSelectedTag
{
    CGFloat lastX = 20;
    CGFloat lastY = 40;
    
    CGRect maxFrame = CGRectZero;
    for (int i=0; i<tagArr.count; i++)
    {
        CustomTagButton *button = [[CustomTagButton alloc]init];
        personTagModel *tag = tagArr[i];
        [button setTitle:tag.tagName_ forState:UIControlStateNormal];
        button.titleLabel.font = TWEELVEFONT_COMMENT;
        if ([_selectNameArr isKindOfClass:[NSMutableArray class]])
        {
            if ([_selectNameArr containsObject:tag.tagName_])
            {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundColor:UIColorFromRGB(0xe13e3e)];
                button.layer.borderColor = [UIColor clearColor].CGColor;
                button.selected = YES;
                [selectArr addObject:tag];
            }
            else
            {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
            }
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.selected = NO;
        }
      
        button.layer.borderWidth = 0.5;
        CGRect frame = [self setButtonTitle:tag.tagName_ button:button lastX:&lastX lastY:&lastY width:ScreenWidth];
        button.frame = frame;
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnTag:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView_ addSubview:button];
        maxFrame = frame;
    }
    scrollView_.contentSize = CGSizeMake(320,CGRectGetMaxY(maxFrame)+20);
}
#pragma mark 计算根据文字计算宽度 返回frame
-(CGRect) setButtonTitle:(NSString *)title button:(UIButton*) button lastX:(CGFloat *)lastX lastY:(CGFloat *)lastY width:(CGFloat)maxW
{
    CGSize titleSize = [title sizeNewWithFont:button.titleLabel.font];
    titleSize.height = 30;
    button.layer.cornerRadius = 15;
    titleSize.width += 35;
    if (*lastX + titleSize.width> maxW) {
        *lastX = 20;
        *lastY += titleSize.height + 10;
    }
    CGRect frame = CGRectMake(*lastX, *lastY, titleSize.width, titleSize.height);
    [button setFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    *lastX += titleSize.width + 15;
    return frame;
}

-(void)btnTag:(UIButton *)sender
{
    personTagModel *model = tagArr[sender.tag-100];
    if (sender.selected)
    {
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor clearColor]];
        sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
        sender.selected = NO;
        for (personTagModel *model1 in selectArr)
        {
            if ([model1.tagId_ isEqualToString:model.tagId_])
            {
                [selectArr removeObject:model];
                break;
            }
        }
    }
    else
    {
        if (selectArr.count >= 3)
        {
           [BaseUIViewController showAlertView:nil msg:@"最多可选择3个擅长行业" btnTitle:@"知道了"];
            return;
        }
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:UIColorFromRGB(0xe13e3e)];
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        sender.selected = YES;
        [selectArr addObject:model];
    }
}

-(void)rightBarBtnResponse:(id)sender
{
    [_changeDelegate changeGoodTradeWithArr:selectArr];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
