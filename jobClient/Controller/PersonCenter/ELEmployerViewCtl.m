//
//  ELEmployerViewCtl.m
//  jobClient
//
//  Created by 一览iOS on 15/9/17.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "ELEmployerViewCtl.h"


@interface ELEmployerViewCtl ()
{
    __weak IBOutlet UIView *backView;
    ELRequest *elrequest;
    NSMutableArray *frameArrData;
    NSMutableArray *dataArr;
    NSMutableArray *imageViewArr;
    UIView *imageThree;
    UIView *imageTwo;
    UIView *imageOne;
    
    NSInteger index;
    CGRect imageFrame;
    UIPanGestureRecognizer *panGesture;
    UITapGestureRecognizer *tapGesture;
    UIView *panImage;
    
    __weak IBOutlet UIButton *creatBtn;
    __weak IBOutlet UIButton *whyBtn;
    
    UIImageView *imageViewList;
    
    __weak IBOutlet NSLayoutConstraint *backViewY;
    
}
@end

@implementation ELEmployerViewCtl

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.title = @"微雇主";
    [self setNavTitle:@"微雇主"];
    creatBtn.clipsToBounds = YES;
    creatBtn.layer.cornerRadius = 4.0;
    frameArrData = [[NSMutableArray alloc] init];
    
    CGFloat imageW = 200*(ScreenWidth/320.0);
    CGFloat imageH = 300*(ScreenWidth/320.0);
    CGFloat imageX = (ScreenWidth-imageW)/2;
    CGFloat height = ([UIScreen mainScreen].bounds.size.height - 60 - imageH - 20 - 64)/3;
    
    [frameArrData addObject:[NSValue valueWithCGRect:CGRectMake(imageX+10,height,imageW,imageH)]];
    [frameArrData addObject:[NSValue valueWithCGRect:CGRectMake(imageX,height+10,imageW,imageH)]];
    [frameArrData addObject:[NSValue valueWithCGRect:CGRectMake(imageX-10,height+20,imageW,imageH)]];
    
    backViewY.constant = height * 2 + imageH + 20;
    
    [self.view sendSubviewToBack:backView];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    imageViewArr = [[NSMutableArray alloc] init];
    imageOne = [[UIView alloc] initWithFrame:[frameArrData[0] CGRectValue]];
    imageTwo = [[UIView alloc] initWithFrame:[frameArrData[1] CGRectValue]];
    imageThree = [[UIView alloc] initWithFrame:[frameArrData[2] CGRectValue]];
    
    [imageViewArr addObject:imageOne];
    [imageViewArr addObject:imageTwo];
    [imageViewArr addObject:imageThree];
    
    for (NSInteger i = 0; i< 3; i++)
    {
        UIView *imageView = imageViewArr[i];
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.cornerRadius = 4.0;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,imageW-10,imageH-35)];
        image.tag = 100;
        [imageView addSubview:image];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5,imageH-25,imageW-10,20)];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.tag = 200;
        [imageView addSubview:lable];
        [self.view addSubview:imageView];
        imageView.userInteractionEnabled = YES;
    }
    
    [self creatData];
    [[self getNoNetworkView] removeFromSuperview];
}


-(void)tap:(UITapGestureRecognizer *)sender
{
    AD_dataModal *dataModal = dataArr[sender.view.tag - 1001];
    dataModal.shareUrl = dataModal.url_;
    PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
    [self.navigationController pushViewController:pushurlCtl animated:YES];
    [pushurlCtl beginLoad:dataModal exParam:nil];
}

-(void)pan:(UIPanGestureRecognizer *)sender
{
    UIImageView *image = (UIImageView *)sender.view;
    CGPoint point = [sender translationInView:sender.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGRect frame = image.frame;
            frame.origin.x = point.x + imageFrame.origin.x;
            frame.origin.y = point.y + imageFrame.origin.y;
            image.frame = frame;
        }
            break;
        case UIGestureRecognizerStateEnded :
        {
            
            CGRect frame = image.frame;
            if(point.x > 80 || point.x < -80 || point.y > 100 || point.y < -100)
            {
                frame.origin.y = point.y*6 + imageFrame.origin.y;
                frame.origin.x = point.x*6 + imageFrame.origin.x;
                
                [UIView animateWithDuration:0.3 animations:^{
                    image.frame = frame;
                } completion:^(BOOL finished)
                 {
                     panImage.hidden = YES;
                     [panImage removeGestureRecognizer:panGesture];
                     [panImage removeGestureRecognizer:tapGesture];
                     [self.view insertSubview:panImage atIndex:1];
                     [imageViewArr removeObject:panImage];
                     [imageViewArr insertObject:panImage atIndex:0];
                     
                     [UIView animateWithDuration:0.2 animations:^
                      {
                          for (NSInteger i = 0; i< 3; i++)
                          {
                              UIView *imageView = imageViewArr[i];
                              imageView.frame = [frameArrData[i] CGRectValue];
                          }
                          index ++;
                          if (index >= dataArr.count) {
                              index = 0;
                          }
                          UIView *imageView = imageViewArr[0];
                          imageView.tag = 1001 + index;
                          UIImageView *imageViewOne = (UIImageView *)[imageView viewWithTag:100];
                          UILabel *lable = (UILabel *)[imageView viewWithTag:200];
                          AD_dataModal *dataModal = dataArr[index];
                          /*
                          if (!dataModal.picImage)
                          {
                              dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                  
                                  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataModal.pic_]];
                                  
                                  UIImage *image = [UIImage imageWithData:data];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      dataModal.picImage = image;
                                      imageViewOne.image = dataModal.picImage;
                                  });
                                  
                              });
                          }
                          else
                          {
                              imageViewOne.image = dataModal.picImage;
                          }
                           */
                          
                          [imageViewOne sd_setImageWithURL:[NSURL URLWithString:dataModal.pic_]];
                          lable.text = dataModal.title_;
                          
                      } completion:^(BOOL finished)
                      {
                          UIView *imageView = [imageViewArr lastObject];
                          [imageView addGestureRecognizer:panGesture];
                          [imageView addGestureRecognizer:tapGesture];
                          panImage.hidden = NO;
                          panImage = imageView;
                      }];
                 }];
            }
            else
            {
                frame.origin.x = imageFrame.origin.x;
                frame.origin.y = imageFrame.origin.y;
                [UIView animateWithDuration:0.26 animations:^{
                    image.frame = frame;
                }];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)creatData
{
    NSString * userId = [Manager getUserInfo].userId_;
    if (![Manager shareMgr].haveLogin) {
        userId = @"";
    }
    
    NSString * bodyMsg = nil;
    NSString * function = @"getWgzAdv";
    NSString * op = @"yl_adv_busi";

    [ELRequest postbodyMsg:bodyMsg op:op func:function requestVersion:YES success:^(NSURLSessionDataTask *operation, id result)
     {
         dataArr = [[NSMutableArray alloc] init];
         NSArray *arrData = result;
         
         for (NSDictionary *dic in arrData)
         {
             AD_dataModal *modal = [[AD_dataModal alloc] init];
             modal.adId = dic[@"yar_id"];
             modal.pic_ = dic[@"path"];
             modal.url_ = dic[@"url"];
             modal.title_ = dic[@"title"];
             modal.target_ = dic[@"target"];
             modal.sharePic = dic[@"small_pic"];
             [dataArr addObject:modal];
         }
         
         if (dataArr.count > 0) {
             [imageThree addGestureRecognizer:panGesture];
             [imageThree addGestureRecognizer:tapGesture];
             panImage = imageThree;
             imageFrame = imageThree.frame;
         }
         else
         {
             return;
         }
         
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         if (dataArr.count == 1) {
             [arr addObject:dataArr[0]];
             [arr addObject:dataArr[0]];
             [arr addObject:dataArr[0]];
             index = 0;
         }
         else if (dataArr.count == 2)
         {
             [arr addObject:dataArr[0]];
             [arr addObject:dataArr[1]];
             [arr addObject:dataArr[0]];
             index = 0;
         }
         else if(dataArr.count >= 3)
         {
             [arr addObject:dataArr[0]];
             [arr addObject:dataArr[1]];
             [arr addObject:dataArr[2]];
             index = 2;
         }
         
         for (NSInteger i = 0;i<3;i++)
         {
             UIView *imageView = imageViewArr[i];
             imageView.tag = 1001 + [dataArr indexOfObject:arr[2-i]];
             imageView.frame = [frameArrData[i] CGRectValue];
             UIImageView *imageViewOne = (UIImageView *)[imageView viewWithTag:100];
             UILabel *lable = (UILabel *)[imageView viewWithTag:200];
             AD_dataModal *dataModal = arr[2-i];
             
             /*
             if (!dataModal.picImage)
             {
                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     
                     NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataModal.pic_]];
                     
                     UIImage *image = [UIImage imageWithData:data];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         dataModal.picImage = image;
                         imageViewOne.image = dataModal.picImage;
                     });
                     
                 });
             }
             else
             {
                 imageViewOne.image = dataModal.picImage;
             }
              */
             
             [imageViewOne sd_setImageWithURL:[NSURL URLWithString:dataModal.pic_]];
             lable.text = dataModal.title_;
         }
         
     } failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [BaseUIViewController showAutoDismissFailView:nil msg:@"请求数据失败，请稍后再试" seconds:1.0f];
     }];
}

- (IBAction)btnRespone:(UIButton *)sender
{
    if(sender == creatBtn)
    {
        AD_dataModal *dataModal = [[AD_dataModal alloc] init];
        dataModal.url_ = @"http://m.job1001.com/company/regwgz/";
        dataModal.title_ = @"申请建立微雇主";
        PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
        pushurlCtl.fromEmploy = YES;
        [self.navigationController pushViewController:pushurlCtl animated:YES];
        [pushurlCtl beginLoad:dataModal exParam:nil];
    }
    else if (sender == whyBtn)
    {
        AD_dataModal *dataModal = [[AD_dataModal alloc] init];
        dataModal.url_ = @"http://m.job1001.com/wgz/xuanchuan_2015";
        dataModal.title_ = @"了解微雇主";
        PushUrlCtl * pushurlCtl = [[PushUrlCtl alloc] init];
        pushurlCtl.fromEmploy = YES;
        [self.navigationController pushViewController:pushurlCtl animated:YES];
        [pushurlCtl beginLoad:dataModal exParam:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
