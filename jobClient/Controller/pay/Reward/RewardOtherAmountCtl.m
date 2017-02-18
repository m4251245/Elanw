//
//  RewardOtherAmountCtl.m
//  jobClient
//
//  Created by 一览ios on 15/8/31.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "RewardOtherAmountCtl.h"

@interface RewardOtherAmountCtl ()<UITextFieldDelegate>
{
    NSTimer *moneyTimer;
    NSArray *moneyArrary;
    __weak IBOutlet UIView *tfBgView;
    __weak IBOutlet UIImageView *rmbImg;
    __weak IBOutlet UIButton *diceBtn;
   
    IBOutlet NSLayoutConstraint *_tfBgViewAutotop;
    IBOutlet NSLayoutConstraint *_amoutViewAutoHeight;
    
    IBOutlet NSLayoutConstraint *_otherAmoutTFAutoLeading;
    IBOutlet NSLayoutConstraint *_otherAmoutTFAutoWidth;
    __weak IBOutlet NSLayoutConstraint *_amountViewTopSpace;
}

@end

@implementation RewardOtherAmountCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewClick:)]];
    _amoutView.layer.cornerRadius = 8.0f;
    _amoutView.layer.masksToBounds = YES;
    
    _confirmBtn.layer.cornerRadius = 2.0f;
    _confirmBtn.layer.masksToBounds = YES;
    
    _amoutView.hidden = YES;
    _personImg.layer.cornerRadius = 20.0f;
    _personImg.layer.masksToBounds = YES;
    
    tfBgView.layer.borderWidth = 1.0;
    tfBgView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    tfBgView.layer.cornerRadius = 4.0f;
    tfBgView.layer.masksToBounds = YES;
    
    moneyArrary = [[NSArray alloc] initWithObjects:@"0.58",@"0.66",@"0.88",@"1.28",@"1.68",@"1.77",@"1.99",@"2.18",@"2.28",@"2.58",@"2.66",@"2.68",@"2.88",@"2.98",@"3.18",@"3.28",@"3.56",@"3.58",@"3.66",@"3.68",@"3.88",@"3.98",@"4.18",@"4.28",@"4.56",@"4.58",@"4.66",@"4.68",@"4.88",@"4.98",@"5.18",@"5.20",@"5.28",@"5.56",@"5.58",@"5.66",@"5.68",@"5.88",@"5.98",@"6.08",@"6.18",@"6.28",@"6.56",@"6.58",@"6.66",@"6.68",@"6.77",@"6.88",@"6.98",@"7.08",@"7.18",@"7.28",@"7.56",@"7.58",@"7.66",@"7.68",@"7.77",@"7.88",@"7.98",@"8.08",@"8.18",@"8.28",@"8.56",@"8.58",@"8.66",@"8.68",@"8.77",@"8.88",@"8.98",@"9.08",@"9.18",@"9.28",@"9.56",@"9.58",@"9.66",@"9.68",@"9.77",@"9.88",@"9.98",@"9.9",nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)maskViewClick:(UIGestureRecognizer*)sender
{
    [_otherAmountTF resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([moneyTimer isValid]) {
        [moneyTimer invalidate];
        moneyTimer = nil;
    }
}

-(void)viewDidLayoutSubviews{
    [self.view layoutSubviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    
    return YES;
}


#pragma mark - 重写键盘隐藏(解决contentSize不准)
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    if (keyboardRect.size.height < 226) {
        keyboardRect.size.height = 226;
    }
    
    if (ScreenHeight <= 480) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height - keyboardRect.size.height -_amoutView.frame.size.height;
        [UIView animateWithDuration:animationDuration animations:^{
//            [_amoutView setFrame:CGRectMake((ScreenWidth - _amoutView.frame.size.width)/2, height - 10, _amoutView.frame.size.width, _amoutView.frame.size.height)];
            _amountViewTopSpace.constant = height - 10;
        }];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (ScreenHeight <= 480) {
        [UIView animateWithDuration:animationDuration animations:^{
//            [_amoutView setFrame:CGRectMake((ScreenWidth - _amoutView.frame.size.width)/2, 130, _amoutView.frame.size.width, _amoutView.frame.size.height)];
            _amountViewTopSpace.constant = 130;
        }];
    }
    
}

- (void)btnResponse:(id)sender
{
    if (sender == _confirmBtn) {
        if (_amountBlock) {
            if ([_otherAmountTF.text floatValue] < 0.1) {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"最低金额为0.1元" seconds:1.5];
                return;
            }
            else if ([_otherAmountTF.text floatValue] > 200)
            {
                [BaseUIViewController showAutoDismissFailView:nil msg:@"最大金额为200元" seconds:1.5];
                return;
            }
            
            if (_otherAmountTF.text && ![_otherAmountTF.text isEqualToString:@""]) {
                _amountBlock(_otherAmountTF.text);
            }else{
                _amountBlock(0);
            }
        }
    }else if (sender == _closeBtn){//隐藏_amoutView
        if (_amountBlock) {
            _amoutView.hidden = YES;
            
            _randomBtn.hidden = NO;
            _packBtn.hidden = NO;
            _personNameLb.hidden = NO;
            _personImg.hidden = NO;
            
            [_otherAmountTF resignFirstResponder];
        }
        
        if ([moneyTimer isValid]) {
            [moneyTimer invalidate];
            moneyTimer = nil;
        }
    }
    else if (sender == _randomBtn)
    {//任性掷骰子
        
        //友盟统计模块使用量
        NSDictionary *dict = @{@"Function":@"打赏_任性赏"};
        [MobClick event:@"buttonClick" attributes:dict];
        
        if (_amountBlock) {
            _randomBtn.hidden = YES;
            _packBtn.hidden = YES;
            _personNameLb.hidden = YES;
            _personImg.hidden = YES;
            
            _amoutView.hidden = NO;
            _redpackImg.hidden = YES;
            
            _tfBgViewAutotop.constant = 20;
            _otherAmoutTFAutoLeading.constant = 20;
            _otherAmoutTFAutoWidth.constant = 144;
            _amoutViewAutoHeight.constant = 159;
            
            rmbImg.hidden = NO;
            diceBtn.hidden = NO;
            _otherAmountTF.userInteractionEnabled = NO;
            
            _otherAmountTF.layer.masksToBounds = YES;
            _otherAmountTF.textColor = UIColorFromRGB(0xE4403A);
        }
    }
    else if (sender == _packBtn)
    {//自定义金额
        //友盟统计模块使用量
        NSDictionary *dict = @{@"Function":@"打赏_自定义金额"};
        [MobClick event:@"buttonClick" attributes:dict];
        
        if (_amountBlock) {
             _tipsLb.text = @"其他金额";
            _randomBtn.hidden = YES;
            _packBtn.hidden = YES;
            _personNameLb.hidden = YES;
            _personImg.hidden = YES;
            
            _amoutView.hidden = NO;
            _redpackImg.hidden = NO;
            
            _tfBgViewAutotop.constant = 59;
            _otherAmoutTFAutoLeading.constant = 0;
            _otherAmoutTFAutoWidth.constant = 197;
            
            _amoutViewAutoHeight.constant = 198;
            
            rmbImg.hidden = YES;
            diceBtn.hidden = YES;
            _otherAmountTF.userInteractionEnabled = YES;
            _otherAmountTF.textColor = UIColorFromRGB(0x666666);
        }
    }
    else if (sender == _outViewBtn)
    {//隐藏MaskView
        if (_amountBlock) {
            _amountBlock(0);
        }
    }
    else if (sender == diceBtn)
    {
        [self startThrow];
    }
}

#pragma mark - 随机红包金额
- (void)startThrow{
    [diceBtn setImage:[UIImage imageNamed:@"reward_ dice_on.png"] forState:UIControlStateNormal];
    
    if (!moneyTimer) {
        moneyTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(randomMoney) userInfo:nil repeats:YES];
    }
    [moneyTimer fire];
    [self randomNumber];
}

- (void)randomNumber
{
    __block int timeout = 2; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([moneyTimer isValid]) {
                    [moneyTimer invalidate];
                    moneyTimer = nil;
                }
                [diceBtn setImage:[UIImage imageNamed:@"reward_ dice_off.png"] forState:UIControlStateNormal];
                _otherAmountTF.text = [moneyArrary objectAtIndex:arc4random()%moneyArrary.count];
                
            });
        }else{
            
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)randomMoney
{
    double money = arc4random()%10 + ((double)arc4random() / 0x100000000);
    _otherAmountTF.text = [NSString stringWithFormat:@"%.2f",money];
}


@end
