//
//  BaseUINavigationController.m
//  HelpMe
//
//  Created by wang yong on 11/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseUINavigationController.h"
#import "PreBaseUIViewController.h"

@implementation BaseUINavigationController

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    PreBaseUIViewController *topCtl;
    @try {
        topCtl = (PreBaseUIViewController*)[self topViewController];
        [super pushViewController:viewController animated:animated];
        
        PreBaseUIViewController *ctl = (PreBaseUIViewController*)[self topViewController];
        if( [ctl isKindOfClass:[PreBaseUIViewController class]] ){
            [ctl bePushed:topCtl];
            
            [topCtl startPush:ctl];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] : start push error!!! detail=>%@",[topCtl class],[exception description]);
    }
    @finally {
        
    }

}

-(UIViewController *) popViewControllerAnimated:(BOOL)animated
{
    @try {
        PreBaseUIViewController *topCtl = (PreBaseUIViewController *)[super popViewControllerAnimated:animated];
        
        if( [topCtl isKindOfClass:[PreBaseUIViewController class]] ){
            [topCtl startPop];
        }

        
        PreBaseUIViewController *ctl = (PreBaseUIViewController*)[self topViewController];
        
        if( [ctl isKindOfClass:[PreBaseUIViewController class]] ){
            [ctl bePoped:topCtl];
        }
        
        return ctl;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    return nil;
}

@end
