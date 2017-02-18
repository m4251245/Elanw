//
//  GroupsZbarDetailCtl.m
//  jobClient
//
//  Created by 一览iOS on 15-1-16.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "GroupsZbarDetailCtl.h"
#import "QRCodeGenerator.h"


@interface GroupsZbarDetailCtl ()
{
    __weak IBOutlet NSLayoutConstraint *groupZbarImageHeight;
    __weak IBOutlet NSLayoutConstraint *backViewHeight;
}
@end

@implementation GroupsZbarDetailCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationItem.title = @"社群二维码";
    [self setNavTitle:@"社群二维码"];
    
    CGFloat imageH = ScreenWidth-16;
    groupZbarImageHeight.constant = imageH;
    backViewHeight.constant = imageH + 46;
    
    _groupZbar.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@%@",GroupZbar,_myDataModal.group_id] imageSize:_groupZbar.bounds.size.height];
    
    [self.groupImage sd_setImageWithURL:[NSURL URLWithString:_myDataModal.group_pic] placeholderImage:[UIImage imageNamed:@"icon_zhiysq.png"]];
   
    self.groupTitle.text = _myDataModal.group_name;
   
    self.groupNumber.text = [NSString stringWithFormat:@"社群号:%@",_myDataModal.group_number];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnResponse:(id)sender
{
  if(sender == myRightBarBtnItem_)
  {
//      [[ShareManger sharedManager] shareWithCtl:self.navigationController title:_myDataModal.name_ image:_groupZbar.image];
      NSString *title = [NSString stringWithFormat:@"我邀请您加入一览社群：“%@“(群号：%@)",_myDataModal.group_name,_myDataModal.group_number];
      NSString *content = @"点击我加入吧~\n分享来自：一览";
      [[ShareManger sharedManager] shareWithCtl:self.navigationController title:title content:content image:self.groupImage.image url:[NSString stringWithFormat:@"%@%@",GroupZbar,_myDataModal.group_id]];
  }
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
