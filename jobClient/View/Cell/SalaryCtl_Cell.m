//
//  SalaryCtl_self.m
//  Association
//
//  Created by 一览iOS on 14-1-23.
//  Copyright (c) 2014年 job1001. All rights reserved.
//

#import "SalaryCtl_Cell.h"
#import "User_DataModal.h"
#import "Common.h"
#import "FMDatabase.h"
#import "ELSalaryResultModel.h"

@interface SalaryCtl_Cell()
{
 
}
@end

@implementation SalaryCtl_Cell
@synthesize sexImg_,jobLb_,salaryLb_;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.sexImg_.layer.cornerRadius = 25.0;
    self.sexImg_.layer.masksToBounds = YES;
    self.contentView_.backgroundColor = [UIColor whiteColor];
    [self.firstNameLb_ setTextColor:UIColorFromRGB(0x666666)];
    [self.sexLb_ setTextColor:UIColorFromRGB(0x666666)];
    [self.jobLb_ setTextColor:UIColorFromRGB(0x333333)];
    [self.lineView_ setBackgroundColor:[UIColor lightGrayColor]];
    [self.salaryLb_ setTextColor:UIColorFromRGB(0xff5000)];
    [self.moneyLb_ setTextColor:UIColorFromRGB(0xff5000)];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataModal:(ELSalaryResultModel *)dataModal{
    self.jobLb_.text = dataModal.jtzw;
    
    if (![dataModal.person_sex isEqualToString:@"2"]) {
        [self.firstNameLb_ setText:[NSString stringWithFormat:@"%@先生", [dataModal.person_iname substringToIndex:1]]];
    }else{
        [self.firstNameLb_ setText:[NSString stringWithFormat:@"%@小姐", [dataModal.person_iname substringToIndex:1]]];
    }
    
    if (!dataModal._pic) {
        NSString * imageName = [self getLianMengImage:[self sqlStr:[self setKey:dataModal._pic age:dataModal.person_age]]];
        [self.sexImg_ setImage:[UIImage imageNamed:imageName]];
        dataModal._pic = imageName;
    }else{
        [self.sexImg_ setImage:[UIImage imageNamed:dataModal._pic]];
    }
    //地点
    NSString *address = dataModal.zw_regionid_show;
    CGSize addressSize = [address sizeNewWithFont:self.addressLb.font constrainedToSize:CGSizeMake(60, 20)];
    CGRect frame = self.addressLb.frame;
    frame.size.width = addressSize.width;
    self.addressLb.frame = frame;
    self.addressLb.text = address;
    
    CGFloat padding = 5.f;
    frame = self.workAgeImgv.frame;
    frame.origin.x = CGRectGetMaxX(self.addressLb.frame) +padding;
    self.workAgeImgv.frame = frame;
    
    
    //工作年限
    NSString *workAge = dataModal.person_gznum;
    if (![workAge isEqualToString:@"暂无"] && ![workAge isEqualToString:@""]) {//工作年限
        workAge = [NSString stringWithFormat:@"%@年经验", dataModal.person_gznum];
    }
    else
    {
        workAge = @"暂无";
    }
    
    CGSize workAgeSize = [workAge sizeNewWithFont:self.workAgeLb.font];
    CGFloat workAgeX = CGRectGetMaxX(self.workAgeImgv.frame);
    frame = self.workAgeLb.frame;
    frame.origin.x = workAgeX;
    frame.size.width = workAgeSize.width;
    self.workAgeLb.frame = frame;
    self.workAgeLb.text = workAge;
    
    //学校
    frame = self.schoolImgv.frame;
    frame.origin.x = CGRectGetMaxX(self.workAgeLb.frame) + padding;
    self.schoolImgv.frame = frame;
    
    NSString *school = dataModal.school;
    self.schoolLb.text = school;
    frame = self.schoolLb.frame;
    frame.origin.x = CGRectGetMaxX(self.schoolImgv.frame);
    self.schoolLb.frame = frame;
    
    //月薪
    NSMutableAttributedString *mutableStr;
    if ([dataModal.person_yuex integerValue] > 10000||[dataModal.person_yuex integerValue] == 10000)
    {
        NSMutableString *str = [[NSMutableString alloc] initWithString:dataModal.person_yuex];
        [str insertString:@"." atIndex:str.length-4];
        
        mutableStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@万",[str substringToIndex:str.length-3]]];
        [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
    }
    else{
        mutableStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",dataModal.person_yuex]];
        [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
        
    }
    self.salaryLb_.attributedText = mutableStr;
}

-(void)setDataModalOne:(ELSalaryResultModel *)dataModalOne{
    ELSalaryResultModel *dataModal = dataModalOne;
    self.jobLb_.text = dataModal.job_desc;
    if (![dataModal.sex isEqualToString:@"2"]) {
        [self.firstNameLb_ setText:[NSString stringWithFormat:@"%@先生", [dataModal.iname substringToIndex:1]]];
    }else{
        [self.firstNameLb_ setText:[NSString stringWithFormat:@"%@小姐", [dataModal.iname substringToIndex:1]]];
    }
    
    if (!dataModal._pic) {
        NSString * imageName = [self getLianMengImage:[self sqlStr:[self setKey:dataModal._pic age:@"20"]]];
        [self.sexImg_ setImage:[UIImage imageNamed:imageName]];
        dataModal._pic = imageName;
    }else{
        [self.sexImg_ setImage:[UIImage imageNamed:dataModal._pic]];
    }
    //地点
    NSString *address = dataModal.regionid_desc;
    CGSize addressSize = [address sizeNewWithFont:self.addressLb.font constrainedToSize:CGSizeMake(60, 20)];
    CGRect frame = self.addressLb.frame;
    frame.size.width = addressSize.width;
    self.addressLb.frame = frame;
    self.addressLb.text = address;
    
    CGFloat padding = 5.f;
    frame = self.workAgeImgv.frame;
    frame.origin.x = CGRectGetMaxX(self.addressLb.frame) +padding;
    self.workAgeImgv.frame = frame;
    
    //工作年限
    NSString *workAge = dataModal.gznum;
    if (![workAge isEqualToString:@"暂无"] && ![workAge isEqualToString:@""]) {//工作年限
        workAge = [NSString stringWithFormat:@"%@年经验", dataModal.gznum];
    }
    else
    {
        workAge = @"暂无";
    }
    CGSize workAgeSize = [workAge sizeNewWithFont:self.workAgeLb.font];
    CGFloat workAgeX = CGRectGetMaxX(self.workAgeImgv.frame);
    frame = self.workAgeLb.frame;
    frame.origin.x = workAgeX;
    frame.size.width = workAgeSize.width;
    self.workAgeLb.frame = frame;
    self.workAgeLb.text = workAge;
    
    //学校
    frame = self.schoolImgv.frame;
    frame.origin.x = CGRectGetMaxX(self.workAgeLb.frame) +padding;
    self.schoolImgv.frame = frame;
    
    if ([dataModal.zym isEqualToString:@"暂无"]) {
        dataModal.zym = dataModal.zye;
    }
    NSString *school = dataModal.zym;
    self.schoolLb.text = school;
    frame = self.schoolLb.frame;
    frame.origin.x = CGRectGetMaxX(self.schoolImgv.frame);
    self.schoolLb.frame = frame;
    
    //月薪
    NSMutableAttributedString *mutableStr;
    if ([dataModal.salary integerValue] > 10000||[dataModal.salary integerValue] == 10000)
    {
        NSMutableString *str = [[NSMutableString alloc] initWithString:dataModal.salary];
        [str insertString:@"." atIndex:str.length-4];
    
        mutableStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@万",[str substringToIndex:str.length-3]]];
        [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];
    }
    else{
        mutableStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",dataModal.salary]];
        [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, 1)];

    }
    self.salaryLb_.attributedText = mutableStr;
}


static FMDatabase *database;

#pragma mark-读取数据库里的头像
-(NSString*)getLianMengImage:(NSString*)str
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [Common getSandBoxPath:@"lianmeng_image.sqlite"];
    if( ![fileManager fileExistsAtPath:filePath] ){
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[mainBundle resourcePath],@"lianmeng_image.sqlite"]];
        [data writeToFile:[Common getSandBoxPath:@"lianmeng_image.sqlite"] atomically:YES];
    }
    if (!database) {
        database = [FMDatabase databaseWithPath:filePath];
    }
    if ([database open])
    {
        FMResultSet *set = [database executeQuery:str];
        while ([set next]) {
            NSString * imageName = [set stringForColumn:@"value"];
            [database close];
            return imageName;
        }
    }
    [database close];
    return @"Gender100-nan.png";
}

#pragma mark - 根据年龄和性别获取查询的key
-(NSString*)setKey:(NSString*)sex age:(NSString*)age
{
    NSString * sexStr = @"";
    NSString * ageStr = @"";
    int randomIndex = 1 + arc4random() % 3;
    if ([sex isEqualToString:@"2"]) {
        sexStr = @"girl";
    }
    else{
        sexStr = @"boy";
    }
    
    if ([age integerValue] < 30) {
        ageStr = @"30";
    }
    else if ([age integerValue] >= 30 && [age integerValue] < 40){
        ageStr = @"40";
    }
    else if ([age integerValue] >= 40 && [age integerValue] < 50){
        ageStr = @"50";
    }
    else if ([age integerValue] >= 50 ){
        ageStr = @"60";
    }
    
    return [NSString stringWithFormat:@"%@_%@%d",sexStr,ageStr,randomIndex];
}

#pragma mark - 获取查询语句
-(NSString*)sqlStr:(NSString*)key
{
    return  [NSString stringWithFormat:@"select * from user_image where key='%@'",key];
}

@end
