//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 方彬 on 11/29/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

@implementation Product


@end

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateData];
    [self.productTableView reloadData];
}


#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (NSInteger i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}



#pragma mark -
#pragma mark   ==============产生订单信息==============

- (void)generateData{
    NSArray *subjects = @[@"1",
                          @"2",@"3",@"4",
                          @"5",@"6",@"7",
                          @"8",@"9",@"10"];
    NSArray *body = @[@"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据"];
    
    if (nil == self.productList) {
        self.productList = [[NSMutableArray alloc] init];
    }
    else {
        [self.productList removeAllObjects];
    }
    
    for (int i = 0; i < [subjects count]; ++i) {
        Product *product = [[Product alloc] init];
        product.subject = [subjects objectAtIndex:i];
        product.body = [body objectAtIndex:i];
        
        product.price = 0.01f+pow(10,i-2);
        [self.productList addObject:product];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productList count];
}




//
//用TableView呈现测试数据,外部商户不需要考虑
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"Cell"];
    
    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = product.body;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"一口价：%.2f",product.price];
    
    return cell;
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088501944427718";
    NSString *seller = @"zhd@job1001.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKrYNKXz7uc6hw62Wd0HOGDC6bZbVT01od5I/yqTAIHbBa7UJPirDf7rBg9y2EHt/2ekuYW5fROovU6tSiyJDiFA0M5BiVU4ASOlapmgTuKQNJL2y4Sn+64kbjS/m8t0HQfXJp/QCjHHHT4wJPV+aFUcQQACAmNjiSIj55wlsKAZAgMBAAECgYEAkj0Tg+Iz41Xj+aH5dgsSJTFyoJe5dPWNoxpU4PqH+p+iU65gH0M8bbJ7s4mYt4ajkvIbo+3MtKFBujD3RvviTQnt0Jnb9DhUdSySKlJBsQTSYAf/y51flHkjzLl9uEeHB8/WOPSdR2NUtsmtkFlKv6fN0VDSV8NwCGlQvENqr0kCQQDdp0WNyAoqCo5Nv/NI63t2LqF/5sJ+Eq2nDn/OBY5aqworm5TcpQ9abQCV0WH8SFRhBvtnG0YxVuX527e/YlQjAkEAxVFoLOlzfD/Y3hl5NP0vV9n7979sEIEs19aadfFj0a8I1mJzr+Q8RzsyaVdDan2RPnI+XcEUY788qPpaLBlwkwJAdTJomFrY5PnH3FxN6pR4Jzjos5Pz6m093ELSWMCfUFl3ey88Op4bzBguYwje4mHsG5FxhEbrilMELmR6d3sqOQJAZ2ofG0rPSBN+agkXyXnY0kZhFJuy24OYKRdEpQP6uO7vxsyarVkFbp/L8AHYR3vAH+ZoYWLMeOrFtBpiIDLFGQJAVCS+DAfS7dIsyOdWICetPaEQ1yiSZ+IS3lunqxwwI0CAP0Wcm0p/cmhReMrEOXXoockgTH+Z3x0T3+SrFKQw+w==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.job1001.com/inc/pay/alipay/app/notify_url.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"http://m.job1001.com/";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"yl1001";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            /*
            内置sdk返回：reslut = {
            memo = "";
            result = "partner=\"2088501944427718\"&seller_id=\"zhd@job1001.com\"&out_trade_no=\"MU7CWLGF04KC64X\"&subject=\"1\"&body=\"\U6211\U662f\U6d4b\U8bd5\U6570\U636e\"&total_fee=\"0.02\"&notify_url=\"http://www.job1001.com/inc/pay/alipay/app/notify_url.php\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"U3ldpXiTYYzee5mZY5VnpeR6y0MCB0PvswjG9M6Kknc8XLvDAkILZ8Cy1s3t5vfaMaQeo9LTTYoQsZaIT7aPyVe1GTul0sEetPS39maa41gzLNBlJR3KKFk/WPVcu0X8MgMf470JfwteQb6fan3m1aC2G+xSrG5uBDOdnkuCiGU=\"";
            resultStatus = 9000;
        }
             */
            NSLog(@"reslut = %@",resultDic);
        }];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
