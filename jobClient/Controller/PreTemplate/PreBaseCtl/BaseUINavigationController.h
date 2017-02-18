//
//  BaseUINavigationController.h
//  HelpMe
//
//  Created by wang yong on 11/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

/***************************
 
		Base Nav Class
 
 ***************************/

#import <Foundation/Foundation.h>

@interface BaseUINavigationController : UINavigationController {

}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

-(UIViewController *) popViewControllerAnimated:(BOOL)animated;

@end
