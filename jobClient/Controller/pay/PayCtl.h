//
//  PayCtl.h
//  jobClient
//
//  Created by 一览ios on 15/3/7.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#define ALIPAY_PARTNER @"2088501944427718"
#define ALIPAY_SELLER @"zhd@job1001.com"
#define ALIPAY_PRIVATE_KEY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKrYNKXz7uc6hw62Wd0HOGDC6bZbVT01od5I/yqTAIHbBa7UJPirDf7rBg9y2EHt/2ekuYW5fROovU6tSiyJDiFA0M5BiVU4ASOlapmgTuKQNJL2y4Sn+64kbjS/m8t0HQfXJp/QCjHHHT4wJPV+aFUcQQACAmNjiSIj55wlsKAZAgMBAAECgYEAkj0Tg+Iz41Xj+aH5dgsSJTFyoJe5dPWNoxpU4PqH+p+iU65gH0M8bbJ7s4mYt4ajkvIbo+3MtKFBujD3RvviTQnt0Jnb9DhUdSySKlJBsQTSYAf/y51flHkjzLl9uEeHB8/WOPSdR2NUtsmtkFlKv6fN0VDSV8NwCGlQvENqr0kCQQDdp0WNyAoqCo5Nv/NI63t2LqF/5sJ+Eq2nDn/OBY5aqworm5TcpQ9abQCV0WH8SFRhBvtnG0YxVuX527e/YlQjAkEAxVFoLOlzfD/Y3hl5NP0vV9n7979sEIEs19aadfFj0a8I1mJzr+Q8RzsyaVdDan2RPnI+XcEUY788qPpaLBlwkwJAdTJomFrY5PnH3FxN6pR4Jzjos5Pz6m093ELSWMCfUFl3ey88Op4bzBguYwje4mHsG5FxhEbrilMELmR6d3sqOQJAZ2ofG0rPSBN+agkXyXnY0kZhFJuy24OYKRdEpQP6uO7vxsyarVkFbp/L8AHYR3vAH+ZoYWLMeOrFtBpiIDLFGQJAVCS+DAfS7dIsyOdWICetPaEQ1yiSZ+IS3lunqxwwI0CAP0Wcm0p/cmhReMrEOXXoockgTH+Z3x0T3+SrFKQw+w=="

#import "BaseUIViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"
#import "ResumeOrderRecord.h"
#import "RRResumeOrderRecord.h"
#import "DataVerifier.h"

@class Order;

@protocol paySuccessDelegate <NSObject>

- (void)interviewPaySuccess;
@end

typedef NS_ENUM(NSInteger, PayType){
    PayTypeResumeBuy,
    PayTypeQuerySalary,
    PayTypeResumeRecommed,
    PayTypeReward, //打赏
    PayTypeDiscuss  //约谈
};

@interface PayCtl : BaseUIViewController

@property (nonatomic,weak) id<paySuccessDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;

@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;

@property (weak, nonatomic) IBOutlet UIButton *balancePayBtn;
 
@property (weak, nonatomic) IBOutlet UILabel *priceLb;

@property (weak, nonatomic) IBOutlet UILabel *balancePayAmtLb;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) Order *order;

@property (weak, nonatomic) IBOutlet UILabel *orderNUm;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UIView *payTypeView;

@property (assign, nonatomic) BOOL isRedPacket;

+ (NSDictionary *)parseQueryString:(NSString *)query ;


@end
