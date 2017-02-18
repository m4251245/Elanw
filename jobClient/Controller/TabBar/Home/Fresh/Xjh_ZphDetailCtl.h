//
//  Xjh_ZphDetailCtl.h
//  Association
//
//  Created by 一览iOS on 14-3-19.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "BaseUIViewController.h"
#import "ExRequetCon.h"
#import "Xjh_Zph_DataModal.h"

@interface Xjh_ZphDetailCtl : BaseUIViewController<UIWebViewDelegate>
{
    IBOutlet    UIScrollView        *scrollView_;
    IBOutlet    UIView              *contentView_;  //内容视图
    IBOutlet    UILabel             *titleLb_;      //标题
    IBOutlet    UIButton            *cnameBtn_;     //公司名称btn
    IBOutlet    UILabel             *sdateLb_;      //开始时间lb
    IBOutlet    UIButton            *snameBtn_;     //学校名称btn
    IBOutlet    UILabel             *addrLb_;       //地址lb
    IBOutlet    UIView              *detailView_;   //简介view
    IBOutlet    UIWebView           *webView_;      //简历webView
    
    Xjh_Zph_DataModal               *inModal_;      //传进来的值
    Xjh_Zph_DataModal               *myModal_;      //接口调用取得的值

    RequestCon                      *shareLogsCon_;
}

@end
