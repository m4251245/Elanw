//
//  NoDataErrorCtl.m
//  HelpMe
//
//  Created by wang yong on 11/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NoDataErrorCtl.h"


@implementation NoDataErrorCtl

@synthesize clickBtn_,imageView_,textLb_,delegate_;

-(id) init
{
	self = [self initWithNibName:NoDataErrorCtl_Xib_Name bundle:nil];
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [clickBtn_ setTitle:@"" forState:UIControlStateNormal];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[super viewDidUnload];
	
	self.clickBtn_ = nil;
	self.imageView_ = nil;
	self.textLb_ = nil;
}


#pragma mark IBAciton
-(IBAction) buttonClick:(id)sender
{
	[delegate_ reloadData:self sender:sender];
}

@end
