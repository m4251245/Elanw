//
//  YLArticleAttachmentList.m
//  jobClient
//
//  Created by 一览iOS on 15/6/5.
//  Copyright (c) 2015年 YL1001. All rights reserved.
//

#import "YLArticleAttachmentList.h"
#import "YLArticleAttachmentCtl.h"

@interface YLArticleAttachmentList ()

@end

@implementation YLArticleAttachmentList

-(instancetype)init
{
    self = [super init];
    if (self) {
        bHeaderEgo_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"附件";
    [self setNavTitle:@"附件"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,30,30)];
        imageTitle.clipsToBounds = YES;
        imageTitle.tag = 100;
        imageTitle.layer.cornerRadius = 4.0f;
        [cell.contentView addSubview:imageTitle];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(50,15,ScreenWidth-80,20)];
        titleLable.font = FIFTEENFONT_TITLE;
        titleLable.tag = 200;
        [cell.contentView addSubview:titleLable];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,49,ScreenWidth,1)];
        image.image = [UIImage imageNamed:@"gg_home_line2@2x.png"];
        [cell.contentView addSubview:image];
        
        UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30,18,7,13)];
        imageRight.image = [UIImage imageNamed:@"icon_jiantou.png"];
        [cell.contentView addSubview:imageRight];
    }
    
    YLMediaModal *dataModal = _dataArr[indexPath.row];
    UIImageView *titleImage = (UIImageView *)[cell viewWithTag:100];
    titleImage.image = [UIImage imageNamed:dataModal.titleImage];
    
    UILabel *titleLb = (UILabel *)[cell viewWithTag:200];
    titleLb.text = dataModal.title;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)loadDetail:(id)selectData exParam:(id)exParam indexPath:(NSIndexPath *)indexPath
{
    [super loadDetail:selectData exParam:exParam indexPath:indexPath];
    
     YLMediaModal *dataModal = _dataArr[indexPath.row];
    
    if ([dataModal.postfix.lowercaseString isEqualToString:@"jpg"] || [dataModal.postfix.lowercaseString isEqualToString:@"png"] || [dataModal.postfix.lowercaseString isEqualToString:@"jpeg"] || [dataModal.postfix.lowercaseString isEqualToString:@"gif"] ||[dataModal.postfix.lowercaseString isEqualToString:@"bmp"])
    {
        
    }
    else
    {
        if(dataModal.file_swf.length == 0)
        {
            return;
        }
    }
    YLArticleAttachmentCtl *ctl = [[YLArticleAttachmentCtl alloc] init];
    ctl.dataModal = _dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
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
