//
//  ELFMDevice.m
//  jobClient
//
//  Created by 一览ios on 16/10/27.
//  Copyright © 2016年 YL1001. All rights reserved.
//

#import "ELFMDevice.h"
#import "FMDeviceManager.h"

@implementation ELFMDevice

+ (void)setup
{
    //同盾
//    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
//    NSMutableDictionary *options = [NSMutableDictionary dictionary];
//    // SDK具有防调试功能，当使用xcode运行时，请取消此行注释，开启调试模式
//    // 否则使用xcode运行会闪退，(但直接在设备上点APP图标可以正常运行)
//    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
//    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
//    // 指定对接同盾的测试环境，正式上线时，请删除或者注释掉此行代码，切换到同盾生产环境
//    [options setValue:@"sandbox" forKey:@"env"]; // TODO
//    // 指定合作方标识
//    [options setValue:@"job1001" forKey:@"partner"];
//    // 使用上述参数进行SDK初始化
//    manager->initWithOptions(options);

}

+ (NSString *)getBlackBox
{
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    // 获取设备指纹黑盒数据，请确保在应用开启时已经对SDK进行初始化，切勿在get的时候才初始化
    NSString *blackBox = manager->getDeviceInfo();
    NSLog(@"同盾设备指纹数据: %@", blackBox);
    return blackBox;
}
@end
